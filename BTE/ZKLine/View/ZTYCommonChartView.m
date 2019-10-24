//
//  ZTYCommonChartView.m
//  BTE
//
//  Created by wanmeizty on 23/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYCommonChartView.h"
#import "KVOController.h"
#import "ZYWCandlePostionModel.h"
#import "ZTYCalCuteNumber.h"

#import "ZTYCircleLayer.h"

#import "ZTYKlineComment.h"
//#import "ZTYTextLayer.h"
#import "ZTYDialogTextLayer.h"

#import "ZTYCandlePosionModel.h"

#define MINDISPLAYCOUNT 6


static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZTYCommonChartView ()
<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) FBKVOController *KVOController;
//@property (nonatomic,strong) NSMutableArray *modelTimeLineArray;


@property (nonatomic,strong) CAShapeLayer * timeLineLayer; // 分时线
@property (nonatomic,strong) CAGradientLayer * gradientLayer; // 分时渐变
@property (nonatomic,strong) CAShapeLayer *timeLayer;
//@property (nonatomic,strong) NSMutableArray *maPostionArray;
@property (nonatomic,assign) CGFloat timeLayerHeight;

@property (nonatomic,strong) CAShapeLayer * klineLayer;

@property (nonatomic,strong) ZTYChartModel * currentMaxModel;
@property (nonatomic,strong) ZTYChartModel * currentMinModel;

@property (nonatomic,strong) CAShapeLayer * orderLayer;

@end

@implementation ZTYCommonChartView

#pragma mark KVO
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    _superScrollView = (UIScrollView*)self.superview;
    _superScrollView.delegate = self;
    UIPanGestureRecognizer *panGestureRecognizer = _superScrollView.panGestureRecognizer;
    [panGestureRecognizer addTarget:self action:@selector(panGestureRecognizer:)];
    //    [self addListener];
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
// 计算极值 蜡烛图的极值
- (void)calcuteCandleMaxAndMinValue
{
    //    self.maxY = CGFLOAT_MIN;
    //    self.minY  = CGFLOAT_MAX;
    NSInteger idx = 0;
    
    for (NSInteger i = idx; i < self.currentDisplayArray
         .count; i++)
    {
        ZTYChartModel * entity = [self.currentDisplayArray objectAtIndex:i];
        
        if (self.minY > entity.low) {
            self.minY = entity.low;
            entity.minOrMaxIndex = i;
            self.currentMinModel = entity;
        }
        
        if (self.maxY < entity.low) {
            self.maxY = entity.low;
            entity.minOrMaxIndex = i;
            self.currentMaxModel = entity;
        }
        
        
        if (self.minY > entity.high) {
            self.minY = entity.high;
            entity.minOrMaxIndex = i;
            self.currentMinModel = entity;
        }
        
        if (self.maxY < entity.high) {
            self.maxY = entity.high;
            entity.minOrMaxIndex = i;
            self.currentMaxModel = entity;
        }
        
    }
    
}

// 计算分时图的极值
- (void)calcuteTimeLineMaxAndMinValue{
    
    for (NSInteger i = 0; i < self.currentDisplayArray
         .count; i++)
    {
        ZTYChartModel * entity = [self.currentDisplayArray objectAtIndex:i];
        //        self.minY = self.minY < entity.close ? self.minY : entity.close;
        //        self.maxY = self.maxY > entity.close ? self.maxY : entity.close;
        
        if (self.minY > entity.close) {
            self.minY = entity.close;
            entity.minOrMaxIndex = i;
            self.currentMinModel = entity;
        }
        
        if (self.maxY < entity.close) {
            self.maxY = entity.close;
            entity.minOrMaxIndex = i;
            self.currentMaxModel = entity;
        }
        
    }
}

// 计算MA的极值
- (void)calcuteMaMaxAndMinValue{
    
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([_dataArray indexOfObject:model] >= 4) {
            self.minY = self.minY < model.MA5.floatValue ? self.minY : model.MA5.floatValue;
            self.maxY = self.maxY > model.MA5.floatValue ? self.maxY : model.MA5.floatValue;
        }
        
        if ([_dataArray indexOfObject:model] >= 9) {
            self.minY = self.minY < model.MA10.floatValue ? self.minY : model.MA10.floatValue;
            self.maxY = self.maxY > model.MA10.floatValue ? self.maxY : model.MA10.floatValue;
        }
        
        if ([_dataArray indexOfObject:model] >= 29) {
            self.minY = self.minY < model.MA30.floatValue ? self.minY : model.MA30.floatValue;
            self.maxY = self.maxY > model.MA30.floatValue ? self.maxY : model.MA30.floatValue;
        }
        
        
        
    }];
}

// 计算EMA的极值
- (void)calcuteEMAMaxAndMinValue{
    
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([_dataArray indexOfObject:model] >= 6) {
            self.minY = self.minY < model.EMA7.floatValue ? self.minY : model.EMA7.floatValue;
            self.maxY = self.maxY > model.EMA7.floatValue ? self.maxY : model.EMA7.floatValue;
        }
        
        if ([_dataArray indexOfObject:model] >= 29) {
            self.minY = self.minY < model.EMA30.floatValue ? self.minY : model.EMA30.floatValue;
            self.maxY = self.maxY > model.EMA30.floatValue ? self.maxY : model.EMA30.floatValue;
        }
        
        
    }];
}

// 计算BOLL指标的极值
- (void)calcuteBollMaxAndMinValue{
    
    for (NSInteger i = 0; i < self.currentDisplayArray
         .count; i++)
    {
        
        ZTYChartModel * entity = [self.currentDisplayArray objectAtIndex:i];
        if ([_dataArray indexOfObject:entity] > 19) {
            self.minY = self.minY < entity.BOLL_MB.floatValue ? self.minY : entity.BOLL_MB.floatValue;
            self.maxY = self.maxY > entity.BOLL_MB.floatValue ? self.maxY : entity.BOLL_MB.floatValue;
            
            self.minY = self.minY < entity.BOLL_DN.floatValue ? self.minY : entity.BOLL_DN.floatValue;
            self.maxY = self.maxY > entity.BOLL_DN.floatValue ? self.maxY : entity.BOLL_DN.floatValue;
            
            self.minY = self.minY < entity.BOLL_UP.floatValue ? self.minY : entity.BOLL_UP.floatValue;
            self.maxY = self.maxY > entity.BOLL_UP.floatValue ? self.maxY : entity.BOLL_UP.floatValue;
            
        }
        
    }
}

// 计算SAR指标的极值
- (void)calcuteSARMaxAndMinValue{
    
    for (NSInteger i = 0; i < self.currentDisplayArray
         .count; i++)
    {
        ZTYChartModel * entity = [self.currentDisplayArray objectAtIndex:i];
        if ([_dataArray indexOfObject:entity] > 19) {
            self.minY = self.minY < entity.ParOpen ? self.minY : entity.ParOpen;
            self.maxY = self.maxY > entity.ParOpen ? self.maxY : entity.ParOpen;
        }
    }
}


// 蜡烛图位置
- (void)initCandleModelPositoin
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
        entity.markLeft = left;
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

// 分时位置
- (void)initTimeModelPositoin
{
    //    [self.modelTimeLineArray removeAllObjects];
    [self.currentPostionArray removeAllObjects];
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * cmodel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2;
        CGFloat yPosition = ((self.maxY - cmodel.close) *self.scaleY) + self.topMargin;
        //        ZYWLineModel *model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor redColor]];
        //        model.isDrawDate = cmodel.isDrawDate;
        //        model.date = cmodel.date;
        //        [self.modelTimeLineArray addObject:model];
        
        CGPoint point = CGPointMake(xPosition, yPosition);
        ZYWCandlePostionModel *positionModel = [ZYWCandlePostionModel modelWithOpen:point close:point high:point low:point date:cmodel.date];
        positionModel.isDrawDate = cmodel.isDrawDate;
        positionModel.localIndex = cmodel.localIndex;
        
        [self.currentPostionArray addObject:positionModel];
        
    }];
}

// 计算ma的位置
- (void)calcuteMaLinePostion
{
    //    [self.maPostionArray removeAllObjects];
    
    NSMutableArray * ma5array = [NSMutableArray array];
    NSMutableArray * ma10array = [NSMutableArray array];
    NSMutableArray * ma30array = [NSMutableArray array];
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2;
        if ([_dataArray indexOfObject:model] >= 4) {
            
            CGFloat yPosition = ((self.maxY - model.MA5.floatValue) *self.scaleY) + self.topMargin;
            ZYWLineModel *ma5model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor colorWithHexString:@"FBC170"]];
            [ma5array addObject:ma5model];
        }
        
        if ([_dataArray indexOfObject:model] >= 9) {
            CGFloat yMa10Position = ((self.maxY - model.MA10.floatValue) *self.scaleY) + self.topMargin;
            ZYWLineModel *ma10model = [ZYWLineModel  initPositon:xPosition yPosition:yMa10Position color:[UIColor magentaColor]];
            [ma10array addObject:ma10model];
        }
        
        if ([_dataArray indexOfObject:model] >= 29) {
            CGFloat yMa30Position = ((self.maxY - model.MA30.floatValue) *self.scaleY) + self.topMargin;
            ZYWLineModel *ma30model = [ZYWLineModel  initPositon:xPosition yPosition:yMa30Position color:[UIColor colorWithHexString:@"AED3E3"]];
            [ma30array addObject:ma30model];
        }
        
        
    }];
    
    //    [self.maPostionArray addObject:ma5array];
    //    [self.maPostionArray addObject:ma10array];
    //    [self.maPostionArray addObject:ma30array];
    
}

// 计算ema的位置
- (void)calcuteEMALinePostion
{
    //    [self.maPostionArray removeAllObjects];
    
    NSMutableArray * ema7array = [NSMutableArray array];
    NSMutableArray * ema30array = [NSMutableArray array];
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2;
        if ([_dataArray indexOfObject:model] >= 6) {
            
            CGFloat yPosition = ((self.maxY - model.EMA7.floatValue) *self.scaleY) + self.topMargin;
            ZYWLineModel *ma5model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor colorWithHexString:@"FBC170"]];
            [ema7array addObject:ma5model];
        }
        
        if ([_dataArray indexOfObject:model] >= 29) {
            CGFloat yMa10Position = ((self.maxY - model.EMA30.floatValue) *self.scaleY) + self.topMargin;
            ZYWLineModel *ma10model = [ZYWLineModel  initPositon:xPosition yPosition:yMa10Position color:[UIColor magentaColor]];
            [ema30array addObject:ma10model];
        }
        
        
    }];
    
    //    [self.maPostionArray addObject:ema7array];
    //    [self.maPostionArray addObject:ema30array];
}

// 计算SAR的位置
- (void)calcuteSARLinePostion
{
    //    [self.maPostionArray removeAllObjects];
    
    NSMutableArray * SARarray = [NSMutableArray array];
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2;
        CGFloat yPosition = ((self.maxY - model.ParOpen) *self.scaleY) + self.topMargin;
        ZYWLineModel *ma5model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor colorWithHexString:@"FBC170"]];
        [SARarray addObject:ma5model];
        
    }];
    
    //    [self.maPostionArray addObject:SARarray];
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
    NSInteger leftArrCount = ABS(scrollViewOffsetX + self.candleWidth * 0.5) / (self.candleWidth+self.candleSpace);
    if (leftArrCount > self.dataArray.count)
    {
        _currentStartIndex = self.dataArray.count;
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
- (CGFloat)leftPostion
{
    CGFloat scrollViewOffsetX = _contentOffset <  0  ?  0 : _contentOffset;
    if (_contentOffset + self.superScrollView.width > self.superScrollView.contentSize.width)
    {
        scrollViewOffsetX = self.superScrollView.contentSize.width - self.superScrollView.width;
    }
    return scrollViewOffsetX;
}

// 显示的数据
- (void)initCurrentDisplayModels
{
    if (self.dataArray.count == 0){
        [self removeLayers]; // 移除所有的layer
        [self.currentDisplayArray removeAllObjects];
        return;
    }
    
    NSInteger needDrawKLineCount = self.displayCount;
    NSInteger currentStartIndex = self.currentStartIndex;
    
    //    if (self.reloadIndex == 3) {
    //        self.currentStartIndex = self.dataArray.count - self.displayCount;
    //        currentStartIndex = self.currentStartIndex;
    //    }else{
    //        currentStartIndex = self.currentStartIndex;
    //    }
    //    NSLog(@"currentStartIndex==>%ld",self.currentStartIndex);
    NSInteger count = (currentStartIndex + needDrawKLineCount) >self.dataArray.count ? self.dataArray.count :currentStartIndex + needDrawKLineCount;
    [self.currentDisplayArray removeAllObjects];
    
    // 误差处理， 防止最后意外一根丢失
    if (count >= self.dataArray.count - 3 && count > MinCount) {
        count = self.dataArray.count;
        currentStartIndex = (count - needDrawKLineCount) < 0?0:(count - needDrawKLineCount);
        
        CGFloat prevContentOffset = (self.dataArray.count - self.displayCount ) * self.candleWidth + (self.dataArray.count - self.displayCount - 1) * self.candleSpace + self.leftMargin;
        _contentOffset = prevContentOffset;
        self.currentStartIndex = currentStartIndex;
    }
    
    if (currentStartIndex < count)
    {
        
        for (NSInteger i = currentStartIndex; i <  count; i++)
        {
            ZTYChartModel *model = self.dataArray[i];
            model.localIndex = i;
            [self.currentDisplayArray addObject:model];
            
        }
        //        NSLog(@"count====>%ld----end===>%ld---dataArray====>%ld",count,count-currentStartIndex,self.dataArray.count);
    }
}



- (CGFloat)getPointYculateValue:(CGFloat)value{
    return ((self.maxY - value) * self.scaleY) + self.topMargin;
}



#pragma mark layer相关
// 移除timer所有的layer
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
    [self removeAllSubLayers];
    
    
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
    
    
    if (self.klineLayer) {
        
        for (NSInteger i = 0 ; i < self.klineLayer.sublayers.count; i++)
        {
            id layer = self.klineLayer.sublayers[i];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [layer removeFromSuperlayer];
            layer = nil;
            [CATransaction commit];
        }
        
        [self.klineLayer removeFromSuperlayer];
        self.klineLayer = nil;
    }
    
    if (!self.klineLayer)
    {
        self.klineLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.klineLayer];
    }
    
    //分时线
    if (self.timeLineLayer)
    {
        [self.timeLineLayer removeFromSuperlayer];
        self.timeLineLayer = nil;
    }
    
    if (!self.timeLineLayer)
    {
        self.timeLineLayer = [CAShapeLayer layer];
        self.timeLineLayer.lineWidth = self.lineWidth;
        self.timeLineLayer.lineCap = kCALineCapRound;
        self.timeLineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.timeLineLayer];
    
    
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
    if (!self.gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
    }
    //    [self.layer addSublayer:self.gradientLayer];
}

// 初始化layer
- (void)removeLayers
{
    
    if (self.klineLayer) {
        
        [self.klineLayer removeFromSuperlayer];
        self.klineLayer = nil;
    }
    
    
    
    if (self.timeLayer)
    {
        [self.timeLayer removeFromSuperlayer];
        self.timeLayer = nil;
    }
    //分时线
    if (self.timeLineLayer)
    {
        [self.timeLineLayer removeFromSuperlayer];
        self.timeLineLayer = nil;
    }
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
    
    [self removeAllSubLayers];
    
}

// 蜡烛图位置layer
- (CAShapeLayer*)getShaperLayer:(ZYWCandlePostionModel*)postion
{
    CGFloat openPrice = postion.openPoint.y ;
    CGFloat closePrice = postion.closePoint.y ;
    CGFloat hightPrice = postion.highPoint.y;
    CGFloat lowPrice = postion.lowPoint.y;
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

// 蜡烛图位置layer
- (void)getShaperLayer:(ZTYCandlePosionModel*)postion color:(UIColor *)color
{
    CGFloat openPrice = postion.openPoint.y + self.topMargin;
    CGFloat closePrice = postion.closePoint.y + self.topMargin;
    CGFloat hightPrice = postion.highPoint.y + self.topMargin;
    CGFloat lowPrice = postion.lowPoint.y + self.topMargin;
    CGFloat x = postion.openPoint.x;
    CGFloat y = openPrice > closePrice ? (closePrice) : (openPrice);
    CGFloat height = MAX(fabs(closePrice-openPrice), _minHeight);
    // 实体
    CGRect rect = CGRectMake(x, y, _candleWidth, height);
    
    if (isEqualZero(fabs(closePrice-openPrice)))
    {
        rect = CGRectMake(x, closePrice - height, _candleWidth, height);
    }
    
    CAShapeLayer * klineLayer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
    klineLayer.path = path.CGPath;
    klineLayer.strokeColor = color.CGColor;
    klineLayer.fillColor = color.CGColor;
    [self.klineLayer addSublayer:klineLayer];
    
    CGFloat xPostion = x + _candleWidth / 2;
    if (closePrice < openPrice)
    {
        // 涨  阴线
        // 上影线
        if (!isEqualZero(closePrice - hightPrice))
        {
            //            CGPathMoveToPoint(ref, NULL, xPostion, closePrice);
            //            CGPathAddLineToPoint(ref, NULL, xPostion, hightPrice);
            
            UIBezierPath * highPath = [UIBezierPath bezierPath];
            [highPath moveToPoint:CGPointMake(xPostion, closePrice)];
            [highPath addLineToPoint:CGPointMake(xPostion, hightPrice)];
            CAShapeLayer * highlayer = [CAShapeLayer layer];
            highlayer.strokeColor = color.CGColor;
            highlayer.fillColor = color.CGColor;
            highlayer.path = highPath.CGPath;
            [self.klineLayer addSublayer:highlayer];
            
        }
        
        // 下影线
        if (!isEqualZero(lowPrice - openPrice))
        {
            //            CGPathMoveToPoint(ref, NULL, xPostion, lowPrice);
            //            CGPathAddLineToPoint(ref, NULL, xPostion, openPrice + _lineWidth/2.f);
            
            UIBezierPath * lowpath = [UIBezierPath bezierPath];
            [lowpath moveToPoint:CGPointMake(xPostion, lowPrice)];
            [lowpath addLineToPoint:CGPointMake(xPostion, openPrice + _lineWidth/2.f)];
            CAShapeLayer * lowlayer = [CAShapeLayer layer];
            lowlayer.strokeColor = color.CGColor;
            lowlayer.fillColor = color.CGColor;
            lowlayer.path = lowpath.CGPath;
            [self.klineLayer addSublayer:lowlayer];
        }
    }
    
    else
    {
        // 跌  阳线
        // 上影线
        if (!isEqualZero(openPrice - hightPrice))
        {
            //            CGPathMoveToPoint(ref, NULL, xPostion, openPrice);
            //            CGPathAddLineToPoint(ref, NULL, xPostion, hightPrice);
            UIBezierPath * lowpath = [UIBezierPath bezierPath];
            [lowpath moveToPoint:CGPointMake(xPostion, openPrice)];
            [lowpath addLineToPoint:CGPointMake(xPostion, hightPrice)];
            
            CAShapeLayer * lowlayer = [CAShapeLayer layer];
            lowlayer.strokeColor = color.CGColor;
            lowlayer.fillColor = color.CGColor;
            lowlayer.path = lowpath.CGPath;
            [self.klineLayer addSublayer:lowlayer];
        }
        // 下影线
        if (!isEqualZero(lowPrice - closePrice))
        {
            //            CGPathMoveToPoint(ref, NULL, xPostion, lowPrice);
            //            CGPathAddLineToPoint(ref, NULL, xPostion, closePrice - _lineWidth);
            UIBezierPath * closepath = [UIBezierPath bezierPath];
            [closepath moveToPoint:CGPointMake(xPostion, lowPrice)];
            [closepath addLineToPoint:CGPointMake(xPostion, closePrice - _lineWidth)];
            
            CAShapeLayer * closelayer = [CAShapeLayer layer];
            closelayer.strokeColor = color.CGColor;
            closelayer.fillColor = color.CGColor;
            closelayer.path = closepath.CGPath;
            [self.klineLayer addSublayer:closelayer];
        }
    }
}

// text显示时间
- (CATextLayer * )getTextLayer
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = 10.f;
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
    if (self.orderLayer) {
        for (NSInteger i = 0 ; i < self.orderLayer.sublayers.count; i++)
        {
            id layer = self.orderLayer.sublayers[i];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [layer removeFromSuperlayer];
            layer = nil;
            [CATransaction commit];
        }
        [self.orderLayer removeFromSuperlayer];
        self.orderLayer = nil;
    }
    
    for (int index = 0; index < self.currentPostionArray.count; index ++) {
        NSInteger idx = (self.currentPostionArray.count - 1- index);
        ZTYCandlePosionModel *model = [self.currentPostionArray objectAtIndex:idx];
        if (model.openPoint.y > model.closePoint.y)
        {
            //            [self addCandleRef:redRef postion:model];
            [self getShaperLayer:model color:[UIColor colorWithHexString:@"FF4040"]];
        }
        
        else if (model.openPoint.y < model.closePoint.y)
        {
            //            [self addCandleRef:greenRef postion:model];
            [self getShaperLayer:model color:[UIColor colorWithHexString:@"228B22"]];
        }
        else
        {
            [self getShaperLayer:model color:[UIColor colorWithHexString:@"FF4040"]];
            //            [self addCandleRef:redRef postion:model];
        }
        
    }
    
    
    
    //    self.redLayer.lineWidth = (1 / [UIScreen mainScreen].scale) *1.5f;
    //    self.redLayer.path = redRef;
    //    self.redLayer.fillColor = RoseColor.CGColor;
    //    self.redLayer.strokeColor = RoseColor.CGColor;
    //
    //    self.greenLayer.lineWidth = (1 / [UIScreen mainScreen].scale) *1.5f;
    //    self.greenLayer.path = greenRef;
    //    self.greenLayer.fillColor = DropColor.CGColor;
    //    self.greenLayer.strokeColor = DropColor.CGColor;
}

// 画分时线
- (void)drawTimeLineLayer
{
    if (self.orderLayer) {
        for (NSInteger i = 0 ; i < self.orderLayer.sublayers.count; i++)
        {
            id layer = self.orderLayer.sublayers[i];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [layer removeFromSuperlayer];
            layer = nil;
            [CATransaction commit];
        }
        [self.orderLayer removeFromSuperlayer];
        self.orderLayer = nil;
    }
    //    UIBezierPath *ma5Path =  [UIBezierPath drawLine:self.currentPostionArray];
    UIBezierPath *timePath =  [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"closePoint" dayCount:0 topmagin:self.topMargin];
    
    self.timeLineLayer.path = timePath.CGPath;
    self.timeLineLayer.strokeColor = backBlue.CGColor;
    self.timeLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.timeLineLayer.contentsScale = [UIScreen mainScreen].scale;
    
}




// 日期显示以及时间线 竖线
- (void)drawKlineTimeLayer
{
    [self.currentPostionArray enumerateObjectsUsingBlock:^(ZYWCandlePostionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx % 18 == 0)
        {
            [self drawTimeText:model.date xposion:model.highPoint.x];
            //时间
        }
    }];
    
}

// 日期显示以及时间线 竖线  分时
- (void)drawTimeLayer
{
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    
    CGFloat klineW = klineWidth;
    
    if (klineWidth < SCREEN_WIDTH || klineWidth < SCREEN_HEIGHT) {
        klineW = SCREEN_HEIGHT;
    }
    CGFloat lineWidht = 0.5;
    //    CGFloat height = (self.height) / 6.0;
    
    CAShapeLayer *maxLineLayer = [self getAxispLayer];
    maxLineLayer.lineWidth = lineWidht;
    UIBezierPath *maxpath = [UIBezierPath bezierPath];
    [maxpath moveToPoint:CGPointMake(0, self.height - self.timeLayerHeight - self.bottomMargin)];
    [maxpath addLineToPoint:CGPointMake(klineW,self.height - self.timeLayerHeight - self.bottomMargin)];
    maxpath.lineWidth = lineWidht;
    maxLineLayer.path = maxpath.CGPath;
    [self.timeLayer addSublayer:maxLineLayer];
    
    [self.currentPostionArray enumerateObjectsUsingBlock:^(ZTYCandlePosionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx % 10 == 0)
        {
            [self drawTimeText:model.date xposion:model.closePoint.x];
        }
    }];
    
}

- (void)drawTimeText:(NSString *)dateStr xposion:(CGFloat)xposion{
    //时间
    CATextLayer *layer = [self getTextLayer];
    layer.string = dateStr;
    if (isEqualZero(xposion))
    {
        layer.frame =  CGRectMake(0, self.height - self.timeLayerHeight - self.bottomMargin, 60, self.timeLayerHeight);
    }
    
    else
    {
//        layer.position = CGPointMake(xposion + self.candleWidth , self.height - self.timeLayerHeight/2 - self.bottomMargin);
//        layer.bounds = CGRectMake(0, 0, 60, self.timeLayerHeight);
        layer.frame =  CGRectMake(xposion, self.height - self.timeLayerHeight - self.bottomMargin, 60, self.timeLayerHeight);
    }
    [self.timeLayer addSublayer:layer];
    
}

// 横线
- (void)drawAxisLine
{
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    
    CGFloat klineW = klineWidth;
    
    if (klineWidth < SCREEN_WIDTH || klineWidth < SCREEN_HEIGHT) {
        klineW = SCREEN_HEIGHT;
    }
    CGFloat lineWidht = 0.5;
    //    CGFloat height = (self.height) / 6.0;
    
    CGFloat height = (self.height) / (self.lineCount * 1.0);
    for (int k = 0; k < self.lineCount; k ++) {
        CAShapeLayer *maxLineLayer = [self getAxispLayer];
        maxLineLayer.lineWidth = lineWidht;
        UIBezierPath *maxpath = [UIBezierPath bezierPath];
        [maxpath moveToPoint:CGPointMake(0, height * (k + 1))];
        [maxpath addLineToPoint:CGPointMake(klineW,height * (k + 1))];
        maxpath.lineWidth = lineWidht;
        maxLineLayer.path = maxpath.CGPath;
        [self.timeLayer addSublayer:maxLineLayer];
    }
    
    ZTYChartModel * model = self.currentMinModel;
    CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * model.minOrMaxIndex) + self.candleWidth/2;
    
    CATextLayer *layer = [self getTextLayer];
    layer.bounds = CGRectMake(0, 0, 60, 12);
    [self.timeLayer addSublayer:layer];
    
    ZTYChartModel * maxmodel = self.currentMaxModel;
    CGFloat xMaxPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * maxmodel.minOrMaxIndex) + self.candleWidth/2;
    CATextLayer *maxlayer = [self getTextLayer];
    
    maxlayer.bounds = CGRectMake(0, 0, 60, 12);
    [self.timeLayer addSublayer:maxlayer];
    if (self.dataArray.count >= 2) {
        if (self.mainchartType == MainChartcenterViewTypeKline) {
            
            CGFloat yPosition = ((self.maxY - model.low) *self.scaleY) + self.topMargin;
            CGFloat yMaxPosition = ((self.maxY - maxmodel.high) *self.scaleY) + self.topMargin ;
            
            if (xPosition < xMaxPosition) {
                layer.position = CGPointMake(xPosition + 30 + self.candleWidth * 0.5, yPosition);
                layer.alignmentMode = kCAAlignmentLeft;
                
                //            if (maxmodel.minOrMaxIndex ) {
                //
                //            }
                maxlayer.position = CGPointMake(xMaxPosition - 30, yMaxPosition);
                maxlayer.alignmentMode = kCAAlignmentRight;
                maxlayer.string = [NSString stringWithFormat:@"%@→",[ZTYCalCuteNumber calculateBesideLing:maxmodel.high]];
                layer.string = [NSString stringWithFormat:@"←%@",[ZTYCalCuteNumber calculateBesideLing:model.low]];
            }else{
                layer.position = CGPointMake(xPosition -30, yPosition);
                layer.alignmentMode = kCAAlignmentRight;
                maxlayer.position = CGPointMake(xMaxPosition + 30 + self.candleWidth * 0.5, yMaxPosition);
                maxlayer.alignmentMode = kCAAlignmentLeft;
                maxlayer.string = [NSString stringWithFormat:@"←%@",[ZTYCalCuteNumber calculateBesideLing:maxmodel.high]];
                layer.string = [NSString stringWithFormat:@"%@→",[ZTYCalCuteNumber calculateBesideLing:model.low]];
            }
            
        }else{
            
            CGFloat yPosition = ((self.maxY - model.close) *self.scaleY) + self.topMargin;
            CGFloat yMaxPosition = ((self.maxY - maxmodel.close) *self.scaleY) + self.topMargin;
            
            if (xPosition < xMaxPosition) {
                layer.position = CGPointMake(xPosition + 30 + self.candleWidth * 0.5, yPosition);
                layer.alignmentMode = kCAAlignmentLeft;
                maxlayer.position = CGPointMake(xMaxPosition - 30, yMaxPosition);
                maxlayer.alignmentMode = kCAAlignmentRight;
                maxlayer.string = [NSString stringWithFormat:@"%@→",[ZTYCalCuteNumber calculateBesideLing:maxmodel.close]];
                layer.string = [NSString stringWithFormat:@"←%@",[ZTYCalCuteNumber calculateBesideLing:model.close]];
            }else{
                layer.position = CGPointMake(xPosition -30, yPosition);
                layer.alignmentMode = kCAAlignmentRight;
                maxlayer.position = CGPointMake(xMaxPosition + 30 + self.candleWidth * 0.5, yMaxPosition);
                maxlayer.alignmentMode = kCAAlignmentLeft;
                maxlayer.string = [NSString stringWithFormat:@"←%@",[ZTYCalCuteNumber calculateBesideLing:maxmodel.close]];
                layer.string = [NSString stringWithFormat:@"%@→",[ZTYCalCuteNumber calculateBesideLing:model.close]];
            }
        }
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
    self.candleWidth = (self.superScrollView.width - (self.displayCount - 1) * self.candleSpace - self.leftMargin - self.rightMargin) / (self.displayCount * 1.0);
    NSLog(@"candleWidth===>%f",self.candleWidth);
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
    if (self.lineCount == 0) {
        self.lineCount = 6;
    }
    CGFloat height = self.height / (self.lineCount * 1.0);
    self.leftMargin = 2;
    self.rightMargin = 2;
    self.topMargin = 2; // 20
    self.bottomMargin = 0;
    self.minHeight = 1;
    self.kvoEnable = YES;
    self.timeLayerHeight = 15; // 15
    
}

#pragma mark -- 开始画线
- (void)drawKLine
{
    //    NSLog(@"*******************start");
    // 将要显示的数据
    [self initCurrentDisplayModels];
    
    [self calculateMaxAndMinValue]; // 计算极值
    [self calculatePosion];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [self removeAllSubLayers]; // 移除所有的layer
    [self initLayer]; // 初始化layer
    //    [self drawCandleSublayers]; // 画所有蜡烛图
    //    NSLog(@"绘制start");
    [self drawlayer];
    //    NSLog(@"绘制end");
    //    [self drawMALayer]; // 绘制MA指标
    [self drawTimeLayer]; // 画时间
//    [self drawAxisLine]; // 画横线
    //    [self showCommentBtns];
    [CATransaction commit];
    
    //    NSLog(@"*******************end");
}

- (void)calculateMaxAndMinValue{
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    double maxPrice = CGFLOAT_MIN;
    double minPrice = CGFLOAT_MAX;
    //    NSLog(@"start");
    NSUInteger index = 0;
    for (ZTYChartModel * model in self.currentDisplayArray) {
        //        [self calcuteswithMinAndMax:model index:idx];
        
        switch (self.mainchartType) {
            case MainChartcenterViewTypeTimeLine:
                // 选择分时
                if (self.minY > model.close) {
                    self.minY = model.close;
                    //                    model.minOrMaxIndex = index;
                    //                    self.currentMinModel = model;
                }
                
                if (self.maxY < model.close) {
                    self.maxY = model.close;
                    //                    model.minOrMaxIndex = index;
                    //                    self.currentMaxModel = model;
                }
                
                // 计算极大值 极小值
                if (minPrice > model.close) {
                    minPrice = model.close;
                    model.minOrMaxIndex = index;
                    self.currentMinModel = model;
                }
                
                if (maxPrice < model.close) {
                    maxPrice = model.close;
                    model.minOrMaxIndex = index;
                    self.currentMaxModel = model;
                }
                break;
            default:
                
                
                // 计算极大值 极小值
                if (minPrice > model.low) {
                    minPrice = model.low;
                    model.minOrMaxIndex = index;
                    self.currentMinModel = model;
                }
                if (maxPrice < model.low) {
                    maxPrice = model.low;
                    model.minOrMaxIndex = index;
                    self.currentMaxModel = model;
                }
                if (minPrice > model.high) {
                    minPrice = model.high;
                    model.minOrMaxIndex = index;
                    self.currentMinModel = model;
                }
                if (maxPrice < model.high) {
                    maxPrice = model.high;
                    model.minOrMaxIndex = index;
                    self.currentMaxModel = model;
                }
                
                
                if (self.minY > model.low) {
                    self.minY = model.low;
                }
                if (self.maxY < model.low) {
                    self.maxY = model.low;
                }
                if (self.minY > model.high) {
                    self.minY = model.high;
                }
                if (self.maxY < model.high) {
                    self.maxY = model.high;
                }
                
                if (self.minY > model.close) {
                    self.minY = model.close;
                }
                if (self.maxY < model.close) {
                    self.maxY = model.close;
                }
                if (self.minY > model.open) {
                    self.minY = model.open;
                }
                if (self.maxY < model.open) {
                    self.maxY = model.open;
                }
                break;
        }
        
        
    }
    //    NSLog(@"end");
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight) / (self.maxY - self.minY);
    //    NSLog(@"calculateMaxAndMinValue：%f---%f--%f",self.minY,self.maxY,self.scaleY);
}

- (void)calcuteswithMinAndMax:(ZTYChartModel *)model index:(NSInteger)index{
    
    
    
    switch (self.mainchartType) {
        case MainChartcenterViewTypeTimeLine:
            // 选择分时
            if (self.minY > model.close) {
                self.minY = model.close;
                model.minOrMaxIndex = index;
                self.currentMinModel = model;
            }
            
            if (self.maxY < model.close) {
                self.maxY = model.close;
                model.minOrMaxIndex = index;
                self.currentMaxModel = model;
            }
            break;
        default:
            if (self.minY > model.low) {
                self.minY = model.low;
                model.minOrMaxIndex = index;
                self.currentMinModel = model;
            }
            
            if (self.maxY < model.low) {
                self.maxY = model.low;
                model.minOrMaxIndex = index;
                self.currentMaxModel = model;
            }
            
            
            if (self.minY > model.high) {
                self.minY = model.high;
                model.minOrMaxIndex = index;
                self.currentMinModel = model;
            }
            
            if (self.maxY < model.high) {
                self.maxY = model.high;
                model.minOrMaxIndex = index;
                self.currentMaxModel = model;
            }
            
            
            break;
    }
    
    
    
}

- (void)calcuteMinAndMax:(ZTYChartModel *)model index:(NSInteger)index{
    if (self.mainchartType == MainChartcenterViewTypeKline) {
        if (self.minY > model.low) {
            self.minY = model.low;
            model.minOrMaxIndex = index;
            self.currentMinModel = model;
        }
        
        if (self.maxY < model.low) {
            self.maxY = model.low;
            model.minOrMaxIndex = index;
            self.currentMaxModel = model;
        }
        
        
        if (self.minY > model.high) {
            self.minY = model.high;
            model.minOrMaxIndex = index;
            self.currentMinModel = model;
        }
        
        if (self.maxY < model.high) {
            self.maxY = model.high;
            model.minOrMaxIndex = index;
            self.currentMaxModel = model;
        }
    }else{
        // 选择分时
        if (self.minY > model.close) {
            self.minY = model.close;
            model.minOrMaxIndex = index;
            self.currentMinModel = model;
        }
        
        if (self.maxY < model.close) {
            self.maxY = model.close;
            model.minOrMaxIndex = index;
            self.currentMaxModel = model;
        }
    }
    
}

- (void)calculatePosion{
    [self.currentPostionArray removeAllObjects];
    
    NSUInteger idx = 0;
    for (ZTYChartModel *model in self.currentDisplayArray) {
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.leftMargin;
        model.markLeft = xPosition;
        ZTYCandlePosionModel *candlePosionModel = [ZTYCandlePosionModel initWithCandleModel:model left:xPosition maxY:self.maxY scaleY:self.scaleY topMagin:self.topMargin];
        candlePosionModel.superArrIndex = [self.dataArray indexOfObject:model];
        candlePosionModel.isDrawDate = model.isDrawDate;
        candlePosionModel.date = model.date;
        //        NSLog(@"index===>%ld",[self.dataArray indexOfObject:model]);
        [self.currentPostionArray addObject:candlePosionModel];
        
        idx ++;
    }
    
}


- (void)calcultePostionModel:(ZTYChartModel *)entity index:(NSInteger)index{
    
    if (self.mainchartType == MainChartcenterViewTypeKline) {
        ZTYChartModel *entity  = [self.currentDisplayArray objectAtIndex:index];
        CGFloat open = ((self.maxY - entity.open) * self.scaleY);
        CGFloat close = ((self.maxY - entity.close) * self.scaleY);
        CGFloat high = ((self.maxY - entity.high) * self.scaleY);
        CGFloat low = ((self.maxY - entity.low) * self.scaleY);
        CGFloat left = self.leftPostion+ ((self.candleWidth + self.candleSpace) * index) + self.leftMargin;
        entity.markLeft = left;
        if (left >= self.superScrollView.contentSize.width)
        {
            left = self.superScrollView.contentSize.width - self.candleWidth/2.f;
        }
        
        ZYWCandlePostionModel *positionModel = [ZYWCandlePostionModel modelWithOpen:CGPointMake(left, open) close:CGPointMake(left, close) high:CGPointMake(left, high) low:CGPointMake(left,low) date:entity.date];
        positionModel.isDrawDate = entity.isDrawDate;
        positionModel.localIndex = entity.localIndex;
        
        [self.currentPostionArray addObject:positionModel];
    }else{
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * index) + self.candleWidth/2;
        CGFloat yPosition = ((self.maxY - entity.close) *self.scaleY) + self.topMargin;
        CGPoint point = CGPointMake(xPosition, yPosition);
        ZYWCandlePostionModel *positionModel = [ZYWCandlePostionModel modelWithOpen:point close:point high:point low:point date:entity.date];
        positionModel.isDrawDate = entity.isDrawDate;
        positionModel.localIndex = entity.localIndex;
        
        [self.currentPostionArray addObject:positionModel];
    }

}

- (void)drawlayer{
    //    [self initLayer];
    if (self.mainchartType == MainChartcenterViewTypeKline) {
        // 选择蜡烛图
        [self drawCandleSublayers]; // 画所有蜡烛图
    }else{
        // 选择分时
        [self drawTimeLineLayer]; // 画分时
    }

}

- (void)stockFill
{
    [self initConfig];
    //    [self initLayer];
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
    CGFloat klineWidth = (self.dataArray.count)*(self.candleWidth) + (self.dataArray.count - 1) *self.candleSpace + self.leftMargin + self.rightMargin;
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

// 重新更新当前值
- (void)reloadAtCurrentIndex
{
    if (self.dataArray.count == 0)
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.superScrollView.width));
        }];
        
        self.superScrollView.contentSize = CGSizeMake(self.superScrollView.width,0);
        return;
    }
    
    CGFloat prevContentOffset = (self.currentStartIndex) * self.candleWidth + (self.currentStartIndex - 1) * self.candleSpace + self.leftMargin;
    CGFloat klineWidth = self.dataArray.count*(self.candleWidth) + (self.dataArray.count - 1) *self.candleSpace + self.leftMargin + self.rightMargin;
    if(klineWidth < self.superScrollView.width)
    {
        klineWidth = self.superScrollView.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    //    NSLog(@"klineWidth===>%f---prevContentOffset===>%f",klineWidth,prevContentOffset);
    self.superScrollView.contentSize = CGSizeMake(klineWidth,0);
    self.superScrollView.contentOffset = CGPointMake(prevContentOffset,0);
    _contentOffset = prevContentOffset;
    [self layoutIfNeeded];
    [self drawKLine];
}

// 刷新新增值
- (void)reloadAddLineAtCurrentIndex
{
    //    self.currentStartIndex = self.dataArray.count - self.displayCount;
    //    [self reloadAtCurrentIndex];
    
    if (self.dataArray.count == 0)
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.superScrollView.width));
        }];
        
        self.superScrollView.contentSize = CGSizeMake(self.superScrollView.width,0);
        return;
    }
    
    //    CGFloat prevContentOffset2 = (self.dataArray.count - self.displayCount) * self.candleWidth + (self.dataArray.count - self.displayCount - 1) * self.candleSpace + self.leftMargin;
    
    CGFloat prevContentOffset = (self.dataArray.count - self.displayCount ) * self.candleWidth + (self.dataArray.count - self.displayCount - 1) * self.candleSpace + self.leftMargin;
    //
    //    _contentOffset = (self.dataArray.count - self.displayCount ) * self.candleWidth + (self.dataArray.count - self.displayCount - 1) * self.candleSpace + self.leftMargin;
    //    CGFloat prevContentOffset = (self.currentStartIndex ) * self.candleWidth + (self.currentStartIndex - 1) * self.candleSpace + self.leftMargin;
    //    _contentOffset = prevContentOffset+ (self.candleSpace + self.candleWidth);
    
    //    NSLog(@"prevContentOffset===>%f---prevContentOffset2===>%f---%ld",prevContentOffset,prevContentOffset2,self.currentStartIndex);
    CGFloat klineWidth = self.dataArray.count*(self.candleWidth) + (self.dataArray.count - 1) *self.candleSpace + self.leftMargin + self.rightMargin;
    //    CGFloat prevContentOffset = klineWidth - ((self.displayCount) * self.candleWidth + (self.displayCount - 1) * self.candleSpace + self.rightMargin);
    //    self.currentStartIndex = self.dataArray.count - self.displayCount;
    if(klineWidth < self.superScrollView.width)
    {
        klineWidth = self.superScrollView.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    //    self.superScrollView.contentSize.width = self.superScrollView.width + _contentOffset;
    self.superScrollView.contentOffset = CGPointMake(prevContentOffset,0);
    self.superScrollView.contentSize = CGSizeMake(klineWidth,0);
    _contentOffset = prevContentOffset;
    
    [self layoutIfNeeded];
    [self drawKLine];
}

- (void)displayLayer:(CALayer *)layer
{
    [self drawKLine];
}

//BOOL firstCommentShow = YES;


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
        
        ZTYCandlePosionModel *kLinePositionModel = self.currentPostionArray[index];
        
        CGFloat minX = kLinePositionModel.highPoint.x - (self.candleSpace + self.candleWidth/2);
        CGFloat maxX = kLinePositionModel.highPoint.x + (self.candleSpace + self.candleWidth/2);
        
        if(localPostion > minX && localPostion < maxX)
        {
            
            return CGPointMake(kLinePositionModel.highPoint.x, kLinePositionModel.openPoint.y );
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
        return CGPointMake(firstPositionModel.highPoint.x, firstPositionModel.openPoint.y );
    }
    
    return CGPointZero;
}

-(CGPoint)getTapModelPostionWithPostion:(CGPoint)postion
{
    
    CGFloat localPostion = postion.x;
    NSInteger startIndex = (NSInteger)((localPostion - self.leftPostion) / (self.candleSpace + self.candleWidth));
    
    
    CGFloat ypoision = postion.y;
    
    CGFloat price = self.maxY - (ypoision - self.topMargin) / self.scaleY;
    
    
    
    NSInteger arrCount = self.currentPostionArray.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        
        ZTYCandlePosionModel *kLinePositionModel = self.currentPostionArray[index];
        
        CGFloat minX = kLinePositionModel.highPoint.x - (self.candleSpace + self.candleWidth/2);
        CGFloat maxX = kLinePositionModel.highPoint.x + (self.candleSpace + self.candleWidth/2);
        
        if(localPostion > minX && localPostion < maxX)
        {
            
            
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
                
            }
        }break;
        default:
            break;
    }
}

#pragma mark setter

//- (CAShapeLayer *)stranceLayer{
//    if (!_stranceLayer) {
//        _stranceLayer = [CAShapeLayer layer];
//        _stranceLayer.lineWidth = KLineWidth; //self.lineWidth;
//        _stranceLayer.lineCap = kCALineCapRound;
//        _stranceLayer.lineJoin = kCALineJoinRound;
//        [self.layer addSublayer:_stranceLayer];
//    }
//    return _stranceLayer;
//}

- (CAShapeLayer *)orderLayer{
    if (!_orderLayer) {
        _orderLayer =  [CAShapeLayer layer];
        [self.layer addSublayer:_orderLayer];
    }
    return _orderLayer;
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

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
