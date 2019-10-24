//
//  ZYWCandleChartView.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/17.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWCandleChartView.h"
#import "KVOController.h"
#import "ZYWCandlePostionModel.h"
#import "ZYWCalcuteTool.h"

#define MINDISPLAYCOUNT 6

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZYWCandleChartView () <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) FBKVOController *KVOController;
@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,strong) NSMutableArray *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *ma5LineLayer;
@property (nonatomic,strong) CAShapeLayer *ma10LineLayer;
@property (nonatomic,strong) CAShapeLayer *ma25LineLayer;
@property (nonatomic,strong) CAShapeLayer *timeLayer;
@property (nonatomic,strong) NSMutableArray *maPostionArray;
@property (nonatomic,assign) CGFloat timeLayerHeight;

@property (nonatomic,strong) CAShapeLayer *redLayer;
@property (nonatomic,strong) CAShapeLayer *greenLayer;

@end

@implementation ZYWCandleChartView

#pragma mark setter

- (NSMutableArray*)modelPostionArray
{
    if (!_modelPostionArray)
    {
        _modelPostionArray = [NSMutableArray array];
    }
    return _modelPostionArray;
}

- (NSMutableArray*)currentDisplayArray
{
    if (!_currentDisplayArray)
    {
        _currentDisplayArray = [NSMutableArray array];
    }
    return _currentDisplayArray;
}

- (NSMutableArray*)currentPostionArray
{
    if (!_currentPostionArray)
    {
        _currentPostionArray = [NSMutableArray array];
    }
    return _currentPostionArray;
}

- (NSMutableArray*)maPostionArray
{
    if (!_maPostionArray)
    {
        _maPostionArray = [NSMutableArray array];
    }
    return _maPostionArray;
}

#pragma mark KVO

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    _superScrollView = (UIScrollView*)self.superview;
    _superScrollView.delegate = self;
    UIPanGestureRecognizer *panGestureRecognizer = _superScrollView.panGestureRecognizer;
    [panGestureRecognizer addTarget:self action:@selector(panGestureRecognizer:)];
    [self addListener];
}

- (void)addListener
{
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    __weak typeof(self) this = self;
    [self.KVOController observe:_superScrollView keyPath:ContentOffSet options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (self.kvoEnable)
        {
            this.contentOffset = this.superScrollView.contentOffset.x;
            [this drawKLine];
        }
    }];
}

// 计算极值
#pragma mark privateMethod
- (void)calcuteMaxAndMinValue
{
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    NSInteger idx = 0;
    
    for (NSInteger i = idx; i < self.currentDisplayArray
         .count; i++)
    {
        ZTYChartModel * entity = [self.currentDisplayArray objectAtIndex:i];
        self.minY = self.minY < entity.low ? self.minY : entity.low;
        self.maxY = self.maxY > entity.high ? self.maxY : entity.high;
        
        if (self.maxY - self.minY < 0.5)
        {
            self.maxY += 0.5;
            self.minY -= 0.5;
        }
    }
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight) / (self.maxY - self.minY);
}

// 计算ma的位置
- (void)calcuteMaLinePostion
{
    [self.maPostionArray removeAllObjects];
    NSMutableArray *maLines = [[NSMutableArray alloc] init];
    NSMutableArray *array = (NSMutableArray*)[[self.currentDisplayArray reverseObjectEnumerator] allObjects];
    [maLines addObject:computeMAData(array,5)];
    [maLines addObject:computeMAData(array,10)];
    [maLines addObject:computeMAData(array,30)];
    for (NSInteger i = 0;i<maLines.count;i++)
    {
        ZYWLineData *lineData = [maLines objectAtIndex:i];
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger j = 0;j <lineData.data.count; j++)
        {
            ZYWLineUntil *until = lineData.data[j];
            CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * j) + self.candleWidth/2;
            CGFloat yPosition = ((self.maxY - until.value) *self.scaleY) + self.topMargin;
            ZYWLineModel *model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:lineData.color];
            [array addObject:model];
        }
        [self.maPostionArray addObject:array];
    }
}

#pragma mark publicMethod

- (void)setKvoEnable:(BOOL)kvoEnable
{
    _kvoEnable = kvoEnable;
}

// 当前开始位置索引
- (NSInteger)currentStartIndex
{
    CGFloat scrollViewOffsetX = self.leftPostion < 0 ? 0 : self.leftPostion;
    NSInteger leftArrCount = ABS(scrollViewOffsetX) / (self.candleWidth+self.candleSpace);
    if (leftArrCount > self.dataArray.count)
    {
        _currentStartIndex = self.dataArray.count - 1;
    }
    
    else if (leftArrCount == 0)
    {
        _currentStartIndex = 0;
    }
    
    else
    {
        _currentStartIndex =  leftArrCount ;
    }
    return _currentStartIndex;
}

// x位置
- (NSInteger)leftPostion
{
    CGFloat scrollViewOffsetX = _contentOffset <  0  ?  0 : _contentOffset;
    if (_contentOffset + self.superScrollView.width >= self.superScrollView.contentSize.width)
    {
        scrollViewOffsetX = self.superScrollView.contentSize.width - self.superScrollView.width;
    }
    return scrollViewOffsetX;
}

// 显示的数据
- (void)initCurrentDisplayModels
{
    if (self.dataArray.count == 0) return;
    NSInteger needDrawKLineCount = self.displayCount ;
    NSInteger currentStartIndex = self.currentStartIndex;
    NSInteger count = (currentStartIndex + needDrawKLineCount) >self.dataArray.count ? self.dataArray.count :currentStartIndex + needDrawKLineCount;
    [self.currentDisplayArray removeAllObjects];
    if (currentStartIndex < count)
    {
        for (NSInteger i = currentStartIndex; i <  count ; i++)
        {
            ZTYChartModel *model = self.dataArray[i];
            model.localIndex = i;
            [self.currentDisplayArray addObject:model];
        }
    }
}

// 蜡烛图位置
- (void)initModelPositoin
{
    [self.currentPostionArray removeAllObjects];
    for (NSInteger i = 0 ; i < self.currentDisplayArray.count; i++)
    {
        ZTYChartModel *entity  = [self.currentDisplayArray objectAtIndex:i];
        CGFloat open = ((self.maxY - entity.open) * self.scaleY);
        CGFloat close = ((self.maxY - entity.close) * self.scaleY);
        CGFloat high = ((self.maxY - entity.high) * self.scaleY);
        CGFloat low = ((self.maxY - entity.low) * self.scaleY);
        CGFloat left = self.leftPostion+ ((self.candleWidth + self.candleSpace) * i) + self.leftMargin;
        
        if (left >= self.superScrollView.contentSize.width)
        {
            left = self.superScrollView.contentSize.width - self.candleWidth/2.f;
        }
        
        ZYWCandlePostionModel *positionModel = [ZYWCandlePostionModel modelWithOpen:CGPointMake(left, open) close:CGPointMake(left, close) high:CGPointMake(left, high) low:CGPointMake(left,low) date:entity.date];
        positionModel.isDrawDate = entity.isDrawDate;
        positionModel.localIndex = entity.localIndex;
        
        [self.currentPostionArray addObject:positionModel];
    }
}

#pragma mark layer相关
// 移除所有的layer
- (void)removeAllSubLayers
{
    for (NSInteger i = 0 ; i < self.timeLayer.sublayers.count; i++)
    {
        id layer = self.timeLayer.sublayers[i];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [layer removeFromSuperlayer];
        layer = nil;
        [CATransaction commit];
    }
}

// 初始化layer
- (void)initLayer
{
    if (!self.redLayer)
    {
        self.redLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.redLayer];
    }
    
    if (self.greenLayer)
    {
        [self.greenLayer removeFromSuperlayer];
        self.greenLayer = nil;
    }
    
    if (!self.greenLayer)
    {
        self.greenLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.greenLayer];
    }
    
    if (self.timeLayer)
    {
        [self.timeLayer removeFromSuperlayer];
        self.timeLayer = nil;
    }
    
    if (!self.timeLayer)
    {
        self.timeLayer = [CAShapeLayer layer];
        self.timeLayer.contentsScale = [UIScreen mainScreen].scale;
        self.timeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.timeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    [self.layer addSublayer:self.timeLayer];
    
    //ma5
    if (self.ma5LineLayer)
    {
        [self.ma5LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma5LineLayer)
    {
        self.ma5LineLayer = [CAShapeLayer layer];
        self.ma5LineLayer.lineWidth = self.lineWidth;
        self.ma5LineLayer.lineCap = kCALineCapRound;
        self.ma5LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma5LineLayer];
    
    //ma10
    if (self.ma10LineLayer)
    {
        [self.ma10LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma10LineLayer)
    {
        self.ma10LineLayer = [CAShapeLayer layer];
        self.ma10LineLayer.lineWidth = self.lineWidth;
        self.ma10LineLayer.lineCap = kCALineCapRound;
        self.ma10LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma10LineLayer];
    
    //ma25
    if (self.ma25LineLayer)
    {
        [self.ma25LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma25LineLayer)
    {
        self.ma25LineLayer = [CAShapeLayer layer];
        self.ma25LineLayer.lineWidth = self.lineWidth;
        self.ma25LineLayer.lineCap = kCALineCapRound;
        self.ma25LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma25LineLayer];
}

// 蜡烛图位置layer
- (CAShapeLayer*)getShaperLayer:(ZYWCandlePostionModel*)postion
{
    CGFloat openPrice = postion.openPoint.y + self.topMargin;
    CGFloat closePrice = postion.closePoint.y + self.topMargin;
    CGFloat hightPrice = postion.highPoint.y + self.topMargin;
    CGFloat lowPrice = postion.lowPoint.y + self.topMargin;
    CGFloat x = postion.openPoint.x;
    CGFloat y = openPrice > closePrice ? (closePrice) : (openPrice);
    CGFloat height = MAX(fabs(closePrice-openPrice), self.minHeight);
    
    CGRect rect = CGRectMake(x, y, self.candleWidth, height);
    UIBezierPath *path = [UIBezierPath drawKLine:openPrice close:closePrice high:hightPrice low:lowPrice candleWidth:self.candleWidth rect:rect xPostion:x lineWidth:self.lineWidth];
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    if (postion.openPoint.y >= postion.closePoint.y)
    {
        subLayer.strokeColor = RoseColor.CGColor;
        subLayer.fillColor = RoseColor.CGColor;
    }
    
    else
    {
        subLayer.strokeColor = DropColor.CGColor;
        subLayer.fillColor = DropColor.CGColor;
    }
    
    subLayer.path = path.CGPath;
    [path removeAllPoints];
    return subLayer;
}

// text显示时间
- (CATextLayer*)getTextLayer
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = 12.f;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}

// 划线
- (CAShapeLayer*)getAxispLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"E5E5EE"].CGColor; // E5E5EE ededed
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

// 单个蜡烛绘制
- (void)addCandleRef:(CGMutablePathRef)ref postion:(ZYWCandlePostionModel*)postion
{
    CGFloat openPrice = postion.openPoint.y + self.topMargin;
    CGFloat closePrice = postion.closePoint.y + self.topMargin;
    CGFloat hightPrice = postion.highPoint.y + self.topMargin;
    CGFloat lowPrice = postion.lowPoint.y + self.topMargin;
    CGFloat x = postion.openPoint.x;
    CGFloat y = openPrice > closePrice ? (closePrice) : (openPrice);
    CGFloat height = MAX(fabs(closePrice-openPrice), _minHeight);
    CGRect rect = CGRectMake(x, y, _candleWidth, height);
    
    if (isEqualZero(fabs(closePrice-openPrice)))
    {
        rect = CGRectMake(x, closePrice - height, _candleWidth, height);
    }
    
    CGPathAddRect(ref, NULL, rect);
    
    CGFloat xPostion = x + _candleWidth / 2;
    if (closePrice < openPrice)
    {
        if (!isEqualZero(closePrice - hightPrice))
        {
            CGPathMoveToPoint(ref, NULL, xPostion, closePrice);
            CGPathAddLineToPoint(ref, NULL, xPostion, hightPrice);
        }
        
        if (!isEqualZero(lowPrice - openPrice))
        {
            CGPathMoveToPoint(ref, NULL, xPostion, lowPrice);
            CGPathAddLineToPoint(ref, NULL, xPostion, openPrice + _lineWidth/2.f);
        }
    }
    
    else
    {
        if (!isEqualZero(openPrice - hightPrice))
        {
            CGPathMoveToPoint(ref, NULL, xPostion, openPrice);
            CGPathAddLineToPoint(ref, NULL, xPostion, hightPrice);
        }
        
        if (!isEqualZero(lowPrice - closePrice))
        {
            CGPathMoveToPoint(ref, NULL, xPostion, lowPrice);
            CGPathAddLineToPoint(ref, NULL, xPostion, closePrice - _lineWidth);
        }
    }
}

#pragma mark draw
// 画所有蜡烛图
- (void)drawCandleSublayers
{
    CGMutablePathRef redRef = CGPathCreateMutable();
    CGMutablePathRef greenRef = CGPathCreateMutable();
    for (ZYWCandlePostionModel *model in _currentPostionArray) {
        
        if (model.openPoint.y < model.closePoint.y)
        {
            [self addCandleRef:redRef postion:model];
        }
        
        else if (model.openPoint.y > model.closePoint.y)
        {
            [self addCandleRef:greenRef postion:model];
        }
        
        else
        {
            [self addCandleRef:redRef postion:model];
        }
    }
    
    self.redLayer.lineWidth = (1 / [UIScreen mainScreen].scale) *1.5f;
    self.redLayer.path = redRef;
    self.redLayer.fillColor = RoseColor.CGColor;
    self.redLayer.strokeColor = RoseColor.CGColor;
    
    self.greenLayer.lineWidth = (1 / [UIScreen mainScreen].scale) *1.5f;
    self.greenLayer.path = greenRef;
    self.greenLayer.fillColor = DropColor.CGColor;
    self.greenLayer.strokeColor = DropColor.CGColor;
}

// 画均线MA
- (void)drawMALineLayer
{
    
    if ([self.maPostionArray[0] count] == 0) return;
    if ([self.maPostionArray[1] count] == 0) return;
    if ([self.maPostionArray[2] count] == 0) return;
    NSMutableArray *pathsArray = [UIBezierPath drawLines:self.maPostionArray];

    ZYWLineModel *ma5Model = self.maPostionArray[0][0];
    ZYWLineModel *ma10Model = self.maPostionArray[1][0];
    ZYWLineModel *ma25Model = self.maPostionArray[2][0];
    
    UIBezierPath *ma5Path = pathsArray[0];
    self.ma5LineLayer.path = ma5Path.CGPath;
    self.ma5LineLayer.strokeColor = ma5Model.lineColor.CGColor;
    self.ma5LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma5LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIBezierPath *ma10Path = pathsArray[1];
    self.ma10LineLayer.path = ma10Path.CGPath;
    self.ma10LineLayer.strokeColor = ma10Model.lineColor.CGColor;
    self.ma10LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma10LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIBezierPath *ma25Path = pathsArray[2];
    self.ma25LineLayer.path = ma25Path.CGPath;
    self.ma25LineLayer.strokeColor = ma25Model.lineColor.CGColor;
    self.ma25LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma25LineLayer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)drawMALayer
{
    [self calcuteMaLinePostion]; // 计算ma的位置
    [self drawMALineLayer]; // 画均线MA
}

// 日期显示以及时间线 竖线
- (void)drawTimeLayer
{
    [self.currentPostionArray enumerateObjectsUsingBlock:^(ZYWCandlePostionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.isDrawDate)
        {
            //时间
            CATextLayer *layer = [self getTextLayer];
            layer.string = model.date;
            if (isEqualZero(model.highPoint.x))
            {
                layer.frame =  CGRectMake(0, self.height - self.timeLayerHeight - self.bottomMargin, 60, self.timeLayerHeight);
            }
            
            else
            {
                layer.position = CGPointMake(model.highPoint.x + self.candleWidth, self.height - self.timeLayerHeight/2 - self.bottomMargin);
                layer.bounds = CGRectMake(0, 0, 60, self.timeLayerHeight);
            }
            [self.timeLayer addSublayer:layer];
            
            if (ISShowTimeLine) {
                //时间线
                CAShapeLayer *lineLayer = [self getAxispLayer];
                lineLayer.strokeColor = GradeBGColor.CGColor;
                UIBezierPath *path = [UIBezierPath bezierPath];
                path.lineWidth = BoxborderWidth; //self.lineWidth;
                lineLayer.lineWidth = BoxborderWidth; //self.lineWidth;
                [path moveToPoint:CGPointMake(model.highPoint.x + self.candleWidth/2 - BoxborderWidth/2, 1*heightradio)];
                [path addLineToPoint:CGPointMake(model.highPoint.x + self.candleWidth/2 - BoxborderWidth/2 ,self.height - self.timeLayerHeight - self.bottomMargin)];
                lineLayer.path = path.CGPath;
                [self.timeLayer addSublayer:lineLayer];
                
            }
        }
    }];
}

// 横线
- (void)drawAxisLine
{
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    CAShapeLayer *bottomLayer = [self getAxispLayer];
    bottomLayer.lineWidth = self.lineWidth;
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0, self.height - self.timeLayerHeight - self.bottomMargin)];
    [bpath addLineToPoint:CGPointMake(klineWidth, self.height - self.timeLayerHeight - self.bottomMargin)];
    bpath.lineWidth = self.lineWidth;
    bottomLayer.path = bpath.CGPath;
    [self.timeLayer addSublayer:bottomLayer];
    
    CAShapeLayer *bottomLayer2 = [self getAxispLayer];
    bottomLayer2.lineWidth = self.lineWidth;
    UIBezierPath *bpath2 = [UIBezierPath bezierPath];
    [bpath2 moveToPoint:CGPointMake(0, self.height - self.bottomMargin)];
    [bpath2 addLineToPoint:CGPointMake(klineWidth, self.height - self.bottomMargin)];
    bpath2.lineWidth = self.lineWidth;
    bottomLayer2.path = bpath2.CGPath;
    [self.timeLayer addSublayer:bottomLayer2];
    
    
    if (ISShowTimeLine == 1) {
        CGFloat lineHeigth = 0;
        while (lineHeigth <= self.height) {
            CAShapeLayer *centXLayer = [self getAxispLayer];
            centXLayer.strokeColor = GradeBGColor.CGColor;
            UIBezierPath *xPath = [UIBezierPath bezierPath];
            [xPath moveToPoint:CGPointMake(0,lineHeigth)];
            [xPath addLineToPoint:CGPointMake(klineWidth,lineHeigth)];
            CGFloat dashPattern[] = {3,1};// 3实线，1空白
            [xPath setLineDash:dashPattern count:1 phase:1];
            centXLayer.path = xPath.CGPath;
            centXLayer.lineWidth = BoxborderWidth;//self.lineWidth;
            [self.timeLayer addSublayer:centXLayer];
            lineHeigth += 41;
        }
    }else if(ISShowTimeLine == 2){
        CAShapeLayer *centXLayer = [self getAxispLayer];
        centXLayer.strokeColor = GradeBGColor.CGColor;
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(0,self.centerY)];
        [xPath addLineToPoint:CGPointMake(klineWidth,self.centerY)];
        centXLayer.path = xPath.CGPath;
        centXLayer.lineWidth = BoxborderWidth;//self.lineWidth;
        [self.timeLayer addSublayer:centXLayer];
    }
}

#pragma mark 绘制
// 更新宽度
- (void)updateWidthWithNoOffset
{
    if (self.dataArray.count == 0)
    {
        return;
    }
    CGFloat klineWidth = self.dataArray.count*(self.candleWidth) + (self.dataArray.count - 1) *self.candleSpace + self.leftMargin + self.rightMargin;
    if(klineWidth < self.superScrollView.width)
    {
        klineWidth = self.superScrollView.width;
    }
    
    if (isnan(klineWidth) || isinf(klineWidth))
    {
        return;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    self.superScrollView.contentSize = CGSizeMake(klineWidth,0);
}

// 计算蜡烛图宽度
- (void)calcuteCandleWidth
{
    self.candleWidth = (self.superScrollView.width - (self.displayCount - 1) * self.candleSpace - self.leftMargin - self.rightMargin) / self.displayCount;
}

// 更新宽度
- (void)updateWidth
{
    CGFloat klineWidth = self.dataArray.count*(self.candleWidth) + (self.dataArray.count - 1 ) *self.candleSpace + self.leftMargin + self.rightMargin;
    if(klineWidth < self.superScrollView.width)
    {
        klineWidth = self.superScrollView.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    
    self.superScrollView.contentSize = CGSizeMake(klineWidth,0);
    [self layoutIfNeeded];
    self.superScrollView.contentOffset = CGPointMake(klineWidth - self.superScrollView.width, 0);
}

// 初始化数据
-(void)initConfig
{
    self.leftMargin = 2;
    self.rightMargin = 2;
    self.topMargin = 20;
    self.bottomMargin = 0;
    self.minHeight = 1;
    self.kvoEnable = YES;
    self.timeLayerHeight = 15;
}

// 开始画线
- (void)drawKLine
{
    // 将要显示的数据
    [self initCurrentDisplayModels];
    if (self.delegate && [self.delegate respondsToSelector: @selector(displayScreenleftPostion:startIndex:count:)])
    {
        [_delegate displayScreenleftPostion:self.leftPostion startIndex:self.currentStartIndex count:self.displayCount];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(displayLastModel:)])
    {
        ZTYChartModel *lastModel = self.currentDisplayArray.lastObject;
        [_delegate displayLastModel:lastModel];
    }

    [self calcuteMaxAndMinValue]; // 计算极值
    [self initModelPositoin]; // 蜡烛图位置
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self removeAllSubLayers]; // 移除所有的layer
    [self initLayer]; // 初始化layer
    [self drawCandleSublayers]; // 画所有蜡烛图
    [self drawMALayer]; // 绘制MA
    [self drawTimeLayer]; // 画时间
    [self drawAxisLine]; // 画横线
    [CATransaction commit];
}

- (void)stockFill
{
    [self initConfig];
    [self initLayer];
    [self.superScrollView layoutIfNeeded];
    [self calcuteCandleWidth];
    [self updateWidth];
    [self drawKLine];
}

// 重新加载
- (void)reload
{
    if (self.dataArray.count == 0)
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.superScrollView.width));
        }];
        
        self.superScrollView.contentSize = CGSizeMake(self.superScrollView.width,0);
        return;
    }
    
    CGFloat prevContentOffset = self.superScrollView.contentSize.width;
    CGFloat klineWidth = self.dataArray.count*(self.candleWidth) + (self.dataArray.count - 1) *self.candleSpace + self.leftMargin + self.rightMargin;
    if(klineWidth < self.superScrollView.width)
    {
        klineWidth = self.superScrollView.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    
    self.superScrollView.contentSize = CGSizeMake(klineWidth,0);
    self.superScrollView.contentOffset = CGPointMake(klineWidth - prevContentOffset,0);
    [self layoutIfNeeded];
    [self drawKLine];
}

- (void)displayLayer:(CALayer *)layer
{
    [self drawKLine];
}

#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.contentOffset = scrollView.contentOffset.x;
    [self.layer setNeedsDisplay];
}

#pragma mark 长按获取坐标

-(CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    CGFloat localPostion = xPostion;
    NSInteger startIndex = (NSInteger)((localPostion - self.leftPostion) / (self.candleSpace + self.candleWidth));
    NSInteger arrCount = self.currentPostionArray.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        ZYWCandlePostionModel *kLinePositionModel = self.currentPostionArray[index];
        
        CGFloat minX = kLinePositionModel.highPoint.x - (self.candleSpace + self.candleWidth/2);
        CGFloat maxX = kLinePositionModel.highPoint.x + (self.candleSpace + self.candleWidth/2);
        
        if(localPostion > minX && localPostion < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(longPressCandleViewWithIndex:kLineModel:startIndex:)])
            {
                [self.delegate longPressCandleViewWithIndex:index kLineModel:self.currentDisplayArray[index] startIndex:_currentStartIndex];
            }
            
            return CGPointMake(kLinePositionModel.highPoint.x, kLinePositionModel.openPoint.y);
        }
    }
    
    //最后一根线
    ZYWCandlePostionModel *lastPositionModel = self.currentPostionArray.lastObject;
   
    if (localPostion >= lastPositionModel.closePoint.x)
    {
        return CGPointMake(lastPositionModel.highPoint.x, lastPositionModel.openPoint.y);
    }
    
    //第一根线
    ZYWCandlePostionModel *firstPositionModel = self.currentPostionArray.firstObject;
    if (firstPositionModel.closePoint.x >= localPostion)
    {
        return CGPointMake(firstPositionModel.highPoint.x, firstPositionModel.openPoint.y);
    }
    
    return CGPointZero;
}

#pragma mark panGestureRecognizerAction

- (void)panGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer
{
    switch (panGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            
        }break;
            
        case UIGestureRecognizerStateChanged:
        {
            
        }break;
            
        case UIGestureRecognizerStateEnded:
        {
            //给定一个临界初始值(负数)
            if (self.superScrollView.contentOffset.x <= -5)
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(displayMoreData)])
                {
                    //记录上一次的偏移量
                    self.previousOffsetX = _superScrollView.contentSize.width  -_superScrollView.contentOffset.x;
                    [_delegate displayMoreData];
                }
            }
        }break;
        default:
            break;
    }
}

@end
