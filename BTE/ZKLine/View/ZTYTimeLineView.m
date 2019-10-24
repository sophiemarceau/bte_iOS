//
//  ZTYTimeLineView.m
//  ZYWChart
//
//  Created by wanmeizty on 2018/5/18.
//  Copyright © 2018年 zyw113. All rights reserved.
//

#import "ZTYTimeLineView.h"
#import "KVOController.h"
#import "ZYWCandlePostionModel.h"
#import "ZYWCalcuteTool.h"



#define MINDISPLAYCOUNT 6

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZTYTimeLineView()
<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) FBKVOController *KVOController;
@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,strong) NSMutableArray *modelPostionArray;
//@property (nonatomic,strong) CAShapeLayer *lineChartLayer;
@property (nonatomic,strong) CAShapeLayer *ma5LineLayer;
//@property (nonatomic,strong) CAShapeLayer *ma10LineLayer;
//@property (nonatomic,strong) CAShapeLayer *ma25LineLayer;
@property (nonatomic,strong) CAShapeLayer *timeLayer;
@property (nonatomic,strong) NSMutableArray *maPostionArray;
@property (nonatomic,assign) CGFloat timeLayerHeight;

@property (nonatomic,strong) CAGradientLayer * gradientLayer;
//@property (nonatomic,strong) CAShapeLayer * tineLineLayer; // 分时线
//@property (nonatomic,strong) NSMutableArray * tinePostionArray;

@end

@implementation ZTYTimeLineView

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

//- (NSMutableArray*)tinePostionArray
//{
//    if (!_tinePostionArray)
//    {
//        _tinePostionArray = [NSMutableArray array];
//    }
//    return _tinePostionArray;
//}


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

#pragma mark privateMethod

- (void)calcuteMaxAndMinValue
{
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    NSInteger idx = 0;
    //    CGFloat offset = CGFLOAT_MIN;
    for (NSInteger i = idx; i < self.currentDisplayArray
         .count; i++)
    {
        ZTYChartModel * entity = [self.currentDisplayArray objectAtIndex:i];
        self.minY = self.minY < entity.close ? self.minY : entity.close;
        self.maxY = self.maxY > entity.close ? self.maxY : entity.close;
        
        self.minY = self.minY < entity.open ? self.minY : entity.open;
        self.maxY = self.maxY > entity.open ? self.maxY : entity.open;
        //        if (offset < fabs(entity.open-entity.close)) {
        //            offset = fabs(entity.open-entity.close);
        //        }
        
        if (self.maxY - self.minY < 0.5)
        {
            self.maxY += 0.5;
            self.minY -= 0.5;
        }
    }
    // -40 是为了好看，然后整体上移了40单位
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight - 40) / (self.maxY - self.minY);
}

- (void)calcuteMaLinePostion
{
    [self.maPostionArray removeAllObjects];
    
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * cmodel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2;
        CGFloat yPosition = ((self.maxY - cmodel.open) *self.scaleY) + self.topMargin;
        ZYWLineModel *model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor redColor]];
        [self.maPostionArray addObject:model];
    }];
    //    NSMutableArray *maLines = [[NSMutableArray alloc] init];
    //    NSMutableArray *array = (NSMutableArray*)[[self.currentDisplayArray reverseObjectEnumerator] allObjects];
    //    // mad5
    //    [maLines addObject:computeMAData(array,5)];
    ////    // mad10
    ////    [maLines addObject:computeMAData(array,10)];
    ////    // mad25
    ////    [maLines addObject:computeMAData(array,25)];
    //    for (NSInteger i = 0;i<maLines.count;i++)
    //    {
    //        ZYWLineData *lineData = [maLines objectAtIndex:i];
    //        NSMutableArray *array = [NSMutableArray array];
    //        for (NSInteger j = 0;j <lineData.data.count; j++)
    //        {
    //            ZYWLineUntil *until = lineData.data[j];
    //            CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * j) + self.candleWidth/2;
    //            CGFloat yPosition = ((self.maxY - until.value) *self.scaleY) + self.topMargin;
    //            ZYWLineModel *model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:lineData.color];
    //            [array addObject:model];
    //        }
    //        [self.maPostionArray addObject:array];
    //    }
}

#pragma mark publicMethod

- (void)setKvoEnable:(BOOL)kvoEnable
{
    _kvoEnable = kvoEnable;
}

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
- (NSInteger)leftPostion
{
    CGFloat scrollViewOffsetX = _contentOffset <  0  ?  0 : _contentOffset;
    if (_contentOffset + self.superScrollView.width >= self.superScrollView.contentSize.width)
    {
        scrollViewOffsetX = self.superScrollView.contentSize.width - self.superScrollView.width;
    }
    return scrollViewOffsetX;
}

- (void)initCurrentDisplayModels
{
    NSInteger needDrawKLineCount = self.displayCount ;
    NSInteger currentStartIndex = self.currentStartIndex;
    NSInteger count = (currentStartIndex + needDrawKLineCount) >self.dataArray.count ? self.dataArray.count :currentStartIndex+needDrawKLineCount;
    [self.currentDisplayArray removeAllObjects];
    if (currentStartIndex < count)
    {
        for (NSInteger i = currentStartIndex; i <  count ; i++)
        {
            if (i < self.dataArray.count) {
                ZTYChartModel *model = self.dataArray[i];
                [self.currentDisplayArray addObject:model];
            }
        }
    }
}

- (void)initModelPositoin
{
    [self.currentPostionArray removeAllObjects];
    
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
    for (NSInteger i = 0 ; i < self.currentDisplayArray.count; i++)
    {
        ZTYChartModel *entity  = [self.currentDisplayArray objectAtIndex:i];
        CGFloat open = ((self.maxY - entity.open) * self.scaleY);
        //        CGFloat close = ((self.maxY - entity.close) * self.scaleY);
        CGFloat close = ((entity.close - self.minY) * self.scaleY);
        CGFloat high = ((self.maxY - entity.high) * self.scaleY);
        CGFloat low = ((self.maxY - entity.low) * self.scaleY);
        CGFloat left = self.leftPostion+ ((self.candleWidth + self.candleSpace) * i) + self.leftMargin;
        
        if (left >= self.superScrollView.contentSize.width)
        {
            left = self.superScrollView.contentSize.width - self.candleWidth/2.f;
        }
        
        ZYWCandlePostionModel *positionModel = [ZYWCandlePostionModel modelWithOpen:CGPointMake(left, open) close:CGPointMake(left, close) high:CGPointMake(left, high) low:CGPointMake(left,low) date:entity.date];
        positionModel.isDrawDate = entity.isDrawDate;
        [self.currentPostionArray addObject:positionModel];
    }
}

#pragma mark layer相关

- (void)removeAllSubLayers
{
    //    for (NSInteger i = 0 ; i < self.lineChartLayer.sublayers.count; i++)
    //    {
    //        CAShapeLayer *layer = (CAShapeLayer*)self.lineChartLayer.sublayers[i];
    //        [layer removeFromSuperlayer];
    //        layer = nil;
    //    }
    
    for (NSInteger i = 0 ; i < self.timeLayer.sublayers.count; i++)
    {
        id layer = self.timeLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
}

- (void)initLayer
{
    //    if (self.lineChartLayer)
    //    {
    //        [self.lineChartLayer removeFromSuperlayer];
    //        self.lineChartLayer = nil;
    //    }
    //
    //    if (!self.lineChartLayer)
    //    {
    //        self.lineChartLayer = [CAShapeLayer layer];
    //        self.lineChartLayer.strokeColor = [UIColor clearColor].CGColor;
    //        self.lineChartLayer.fillColor = [UIColor clearColor].CGColor;
    //    }
    //    [self.layer addSublayer:self.lineChartLayer];
    
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
    
    if (!self.gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
    }
    [self.layer addSublayer:self.gradientLayer];
    
    //
    //    //ma10
    //    if (self.ma10LineLayer)
    //    {
    //        [self.ma10LineLayer removeFromSuperlayer];
    //    }
    //
    //    if (!self.ma10LineLayer)
    //    {
    //        self.ma10LineLayer = [CAShapeLayer layer];
    //        self.ma10LineLayer.lineWidth = self.lineWidth;
    //        self.ma10LineLayer.lineCap = kCALineCapRound;
    //        self.ma10LineLayer.lineJoin = kCALineJoinRound;
    //    }
    //    [self.layer addSublayer:self.ma10LineLayer];
    //
    //    //ma25
    //    if (self.ma25LineLayer)
    //    {
    //        [self.ma25LineLayer removeFromSuperlayer];
    //    }
    //
    //    if (!self.ma25LineLayer)
    //    {
    //        self.ma25LineLayer = [CAShapeLayer layer];
    //        self.ma25LineLayer.lineWidth = self.lineWidth;
    //        self.ma25LineLayer.lineCap = kCALineCapRound;
    //        self.ma25LineLayer.lineJoin = kCALineJoinRound;
    //    }
    //    [self.layer addSublayer:self.ma25LineLayer];
    
    //分时线
    //    if (self.tineLineLayer)
    //    {
    //        [self.tineLineLayer removeFromSuperlayer];
    //    }
    //
    //    if (!self.tineLineLayer)
    //    {
    //        self.tineLineLayer = [CAShapeLayer layer];
    //        self.tineLineLayer.lineWidth = self.lineWidth;
    //        self.tineLineLayer.lineCap = kCALineCapRound;
    //        self.tineLineLayer.lineJoin = kCALineJoinRound;
    //    }
    //    [self.layer addSublayer:self.tineLineLayer];
}

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

- (CAShapeLayer*)getAxispLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"E5E5EE"].CGColor;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

#pragma mark draw

//- (void)drawCandleSublayers
//{
//    __weak typeof(self) this = self;
//    [_currentPostionArray enumerateObjectsUsingBlock:^(ZYWCandlePostionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CAShapeLayer *subLayer = [this getShaperLayer:obj];
//        [this.lineChartLayer addSublayer:subLayer];
//    }];
//}

- (void)drawtineLineLayer{
    
}

- (void)drawMALineLayer
{
    //    NSArray *pathsArray = [UIBezierPath drawLines:self.maPostionArray];
    //    ZYWLineModel *ma5Model = self.maPostionArray[0][0];
    //    ZYWLineModel *ma10Model = self.maPostionArray[1][0];
    //    ZYWLineModel *ma25Model = self.maPostionArray[2][0];
    UIBezierPath *ma5Path =  [UIBezierPath drawLine:self.maPostionArray]; //pathsArray[0];
    
    self.ma5LineLayer.path = ma5Path.CGPath;
    self.ma5LineLayer.strokeColor = backBlue.CGColor;
    self.ma5LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma5LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
//    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:250/255.0 green:170/255.0 blue:10/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.4].CGColor];
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"308CDD"].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:1].CGColor];
    // 设置渐变方向(0~1)
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    // 设置渐变色的起始位置和终止位置(颜色的分割点)
    self.gradientLayer.locations = @[@(0.0),@(1.0)];
    self.gradientLayer.borderWidth  = 0.0;
    
    
    // 将CAShapeLayer设置为渐变层的mask
    UIBezierPath *gradientPath = [UIBezierPath drawLine:self.maPostionArray];
    ZYWLineModel* firstLine = [self.maPostionArray firstObject];
    ZYWLineModel* lastLine = [self.maPostionArray lastObject];
    
    [gradientPath addLineToPoint:CGPointMake(lastLine.xPosition, self.height - self.timeLayerHeight - self.bottomMargin)];
    [gradientPath addLineToPoint:CGPointMake(firstLine.xPosition, self.height - self.timeLayerHeight - self.bottomMargin)];
    CAShapeLayer * mask = [CAShapeLayer layer];
    mask.path = gradientPath.CGPath;
    self.gradientLayer.frame = CGRectMake(0, 0, lastLine.xPosition, self.height - self.bottomMargin);
    self.gradientLayer.mask = mask;

    
    //    UIBezierPath *ma10Path = pathsArray[1];
    //    self.ma10LineLayer.path = ma10Path.CGPath;
    //    self.ma10LineLayer.strokeColor = ma10Model.lineColor.CGColor;
    //    self.ma10LineLayer.fillColor = [[UIColor clearColor] CGColor];
    //    self.ma10LineLayer.contentsScale = [UIScreen mainScreen].scale;
    //
    //    UIBezierPath *ma25Path = pathsArray[2];
    //    self.ma25LineLayer.path = ma25Path.CGPath;
    //    self.ma25LineLayer.strokeColor = ma25Model.lineColor.CGColor;
    //    self.ma25LineLayer.fillColor = [[UIColor clearColor] CGColor];
    //    self.ma25LineLayer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)drawMALayer
{
    [self calcuteMaLinePostion];
    [self drawMALineLayer];
}

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

- (void)drawAxisLine
{
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    CAShapeLayer *bottomLayer = [self getAxispLayer];
    bottomLayer.lineWidth = self.lineWidth;
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0, self.height - self.timeLayerHeight - self.bottomMargin)];
    [bpath addLineToPoint:CGPointMake(klineWidth, self.height - self.timeLayerHeight - self.bottomMargin)];
    bottomLayer.path = bpath.CGPath;
    [self.timeLayer addSublayer:bottomLayer];
    
    CAShapeLayer *bottomLayer2 = [self getAxispLayer];
    bottomLayer2.lineWidth = self.lineWidth;
    UIBezierPath *bpath2 = [UIBezierPath bezierPath];
    [bpath2 moveToPoint:CGPointMake(0, self.height - self.bottomMargin)];
    [bpath2 addLineToPoint:CGPointMake(klineWidth, self.height - self.bottomMargin)];
    bottomLayer2.path = bpath2.CGPath;
    [self.timeLayer addSublayer:bottomLayer2];
    
//    if (ISShowTimeLine) {
//        CAShapeLayer *centXLayer = [self getAxispLayer];
//        UIBezierPath *xPath = [UIBezierPath bezierPath];
//        [xPath moveToPoint:CGPointMake(0,self.centerY)];
//        [xPath addLineToPoint:CGPointMake(klineWidth,self.centerY)];
//        centXLayer.path = xPath.CGPath;
//        centXLayer.lineWidth = self.lineWidth;
//        [self.timeLayer addSublayer:centXLayer];
//
//    }
    if (ISShowTimeLine == 1) {
        CGFloat lineHeigth = 0;
        while (lineHeigth <= self.height) {
            CAShapeLayer *centXLayer = [self getAxispLayer];
            centXLayer.strokeColor = GradeBGColor.CGColor;
            UIBezierPath *xPath = [UIBezierPath bezierPath];
            xPath.lineWidth = BoxborderWidth; //self.lineWidth;
            centXLayer.lineWidth = BoxborderWidth; //self.lineWidth;
            [xPath moveToPoint:CGPointMake(0,lineHeigth)];
            [xPath addLineToPoint:CGPointMake(klineWidth,lineHeigth)];
            centXLayer.path = xPath.CGPath;
            [self.timeLayer addSublayer:centXLayer];
            lineHeigth += 41;
        }
        
        
    }else if(ISShowTimeLine == 2){
        CAShapeLayer *centXLayer = [self getAxispLayer];
        centXLayer.strokeColor = GradeBGColor.CGColor;
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        xPath.lineWidth = BoxborderWidth; //self.lineWidth;
        centXLayer.lineWidth = BoxborderWidth; //self.lineWidth;
        [xPath moveToPoint:CGPointMake(0,self.centerY)];
        [xPath addLineToPoint:CGPointMake(klineWidth,self.centerY)];
        centXLayer.path = xPath.CGPath;
        
        [self.timeLayer addSublayer:centXLayer];
    }
}

#pragma mark 绘制

- (void)calcuteCandleWidth
{
    self.candleWidth = (self.superScrollView.width - (self.displayCount - 1) * self.candleSpace - self.leftMargin - self.rightMargin) / self.displayCount;
}

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

- (void)drawKLine
{
    // 移除所有的子视图
    [self removeAllSubLayers];
    // 初始化要显示的数据
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
    // 计算极值
    [self calcuteMaxAndMinValue];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    // 初始化layer
    [self initLayer];
    // 初始化位置
    [self initModelPositoin];
    // 绘制蜡烛图
    //    [self drawCandleSublayers];
    // 绘制mad5 mad10 mad25 三条线
    [self drawMALayer];
    // 绘制时间
    [self drawTimeLayer];
    
    [self drawAxisLine];
    [CATransaction commit];
}

- (void)stockFill
{
    // 配置基本参数值
    [self initConfig];
    // 初始化layer
    [self initLayer];
    [self.superScrollView layoutIfNeeded];
    [self calcuteCandleWidth];
    [self updateWidth];
    [self drawKLine];
}

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
            if(self.delegate && [self.delegate respondsToSelector:@selector(longPressCandleViewWithIndex:kLineModel: startIndex:)])
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

