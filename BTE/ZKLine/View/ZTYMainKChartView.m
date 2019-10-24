//
//  ZTYMainKChartView.m
//  BTE
//
//  Created by wanmeizty on 2018/7/6.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYMainKChartView.h"
#import "KVOController.h"
//#import "ZYWCandlePostionModel.h"
#import "ZTYCandlePosionModel.h"
#import "ZTYCalCuteNumber.h"

#import "ZTYCircleLayer.h"

#import "ZTYKlineComment.h"

#import "ZTYDialogTextLayer.h"

#define MINDISPLAYCOUNT 6

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZTYMainKChartView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) FBKVOController *KVOController;
//@property (nonatomic,strong) NSMutableArray *modelTimeLineArray;
@property (nonatomic,strong) CAShapeLayer *ma5LineLayer; // ma5  BOLL线 UP线
@property (nonatomic,strong) CAShapeLayer *ma10LineLayer; // ma10  BOLL线 DN线
@property (nonatomic,strong) CAShapeLayer *ma25LineLayer; // ma30  BOLL线 MB线


@property (nonatomic,strong) CAShapeLayer * timeLineLayer; // 分时线
@property (nonatomic,strong) CAGradientLayer * gradientLayer; // 分时渐变
@property (nonatomic,strong) CAShapeLayer *timeLayer;
@property (nonatomic,strong) NSMutableArray *maPostionArray;
@property (nonatomic,assign) CGFloat timeLayerHeight;

@property (nonatomic,strong) CAShapeLayer * klineLayer;

@property (nonatomic,strong) CAShapeLayer * commentBGLayer;
@property (nonatomic,strong) CAShapeLayer * commentDialogBGLayer;

@property (nonatomic,strong) ZTYChartModel * currentMaxModel;
@property (nonatomic,strong) ZTYChartModel * currentMinModel;

@property (nonatomic,strong) NSMutableArray * commentLayerArray;
@property (nonatomic,strong) NSMutableArray * circleLayerArray;

@end

@implementation ZTYMainKChartView

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


//// 蜡烛图位置
//- (void)initCandleModelPositoin
//{
//    [self.currentPostionArray removeAllObjects];
//    for (NSInteger i = 0 ; i < self.currentDisplayArray.count; i++)
//    {
//        ZTYChartModel *entity  = [self.currentDisplayArray objectAtIndex:i];
//        CGFloat open = ((self.maxY - entity.open) * self.scaleY);
//        CGFloat close = ((self.maxY - entity.close) * self.scaleY);
//        CGFloat high = ((self.maxY - entity.high) * self.scaleY);
//        CGFloat low = ((self.maxY - entity.low) * self.scaleY);
//        CGFloat left = self.leftPostion+ ((self.candleWidth + self.candleSpace) * i) + self.leftMargin;
//        entity.markLeft = left;
//        if (left >= self.superScrollView.contentSize.width)
//        {
//            left = self.superScrollView.contentSize.width - self.candleWidth/2.f;
//        }
//
//        ZYWCandlePostionModel *positionModel = [ZYWCandlePostionModel modelWithOpen:CGPointMake(left, open) close:CGPointMake(left, close) high:CGPointMake(left, high) low:CGPointMake(left,low) date:entity.date];
//        positionModel.isDrawDate = entity.isDrawDate;
//        positionModel.localIndex = entity.localIndex;
//
//        [self.currentPostionArray addObject:positionModel];
//    }
//}

// 分时位置
//- (void)initTimeModelPositoin
//{
//    //    [self.modelTimeLineArray removeAllObjects];
//    [self.currentPostionArray removeAllObjects];
//    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * cmodel, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2;
//        CGFloat yPosition = ((self.maxY - cmodel.close) *self.scaleY) + self.topMargin;
//        //        ZYWLineModel *model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor redColor]];
//        //        model.isDrawDate = cmodel.isDrawDate;
//        //        model.date = cmodel.date;
//        //        [self.modelTimeLineArray addObject:model];
//
//        CGPoint point = CGPointMake(xPosition, yPosition);
//        ZYWCandlePostionModel *positionModel = [ZYWCandlePostionModel modelWithOpen:point close:point high:point low:point date:cmodel.date];
//        positionModel.isDrawDate = cmodel.isDrawDate;
//        positionModel.localIndex = cmodel.localIndex;
//
//        [self.currentPostionArray addObject:positionModel];
//
//    }];
//}

// 计算ma的位置
- (void)calcuteMaLinePostion
{
    [self.maPostionArray removeAllObjects];
    
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
    
    [self.maPostionArray addObject:ma5array];
    [self.maPostionArray addObject:ma10array];
    [self.maPostionArray addObject:ma30array];
    
}

// 计算ema的位置
- (void)calcuteEMALinePostion
{
    [self.maPostionArray removeAllObjects];
    
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
    
    [self.maPostionArray addObject:ema7array];
    [self.maPostionArray addObject:ema30array];
}

// 计算SAR的位置
- (void)calcuteSARLinePostion
{
    [self.maPostionArray removeAllObjects];
    
    NSMutableArray * SARarray = [NSMutableArray array];
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2;
        CGFloat yPosition = ((self.maxY - model.ParOpen) *self.scaleY) + self.topMargin;
        ZYWLineModel *ma5model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor colorWithHexString:@"FBC170"]];
        [SARarray addObject:ma5model];
        
    }];
    
    [self.maPostionArray addObject:SARarray];
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
    if (self.dataArray.count == 0){
        [self removeLayers]; // 移除所有的layer
        [self.currentDisplayArray removeAllObjects];
        return;
    }
    
    NSInteger needDrawKLineCount = self.displayCount ;
    NSInteger currentStartIndex = self.currentStartIndex;
    NSInteger count = (currentStartIndex + needDrawKLineCount) >self.dataArray.count ? self.dataArray.count :currentStartIndex + needDrawKLineCount;
    [self.currentDisplayArray removeAllObjects];
    
//    // 误差处理， 防止最后意外一根丢失
//    if (count > self.dataArray.count - 2 && count > MinCount) {
//        count = self.dataArray.count;
//        currentStartIndex = (count - needDrawKLineCount) < 0?0:(count - needDrawKLineCount);
////        CGFloat prevContentOffset = (self.dataArray.count - self.displayCount ) * self.candleWidth + (self.dataArray.count - self.displayCount - 1) * self.candleSpace + self.leftMargin;
////        _contentOffset = prevContentOffset;
////        self.currentStartIndex = currentStartIndex;
//    }
    
    // 误差处理， 防止最后意外一根丢失
    if (count > self.dataArray.count - 2 && count > MinCount) {
        count = self.dataArray.count;
        currentStartIndex = (count - needDrawKLineCount) < 0?0:(count - needDrawKLineCount);
        
        CGFloat prevContentOffset = (self.dataArray.count - self.displayCount ) * self.candleWidth + (self.dataArray.count - self.displayCount - 1) * self.candleSpace + self.leftMargin;
        _contentOffset = prevContentOffset;
        self.currentStartIndex = currentStartIndex;
    }
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
    
    //ma5
    if (self.ma5LineLayer)
    {
        for (NSInteger i = 0 ; i < self.ma5LineLayer.sublayers.count; i++)
        {
            id layer = self.ma5LineLayer.sublayers[i];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [layer removeFromSuperlayer];
            layer = nil;
            [CATransaction commit];
        }
        [self.ma5LineLayer removeFromSuperlayer];
        self.ma5LineLayer = nil;
    }
    
    if (!self.ma5LineLayer)
    {
        self.ma5LineLayer = [CAShapeLayer layer];
        self.ma5LineLayer.lineWidth = KLineWidth; //self.lineWidth;
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
        self.ma10LineLayer.lineWidth = KLineWidth; //self.lineWidth;
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
        self.ma25LineLayer.lineWidth = KLineWidth; //self.lineWidth;
        self.ma25LineLayer.lineCap = kCALineCapRound;
        self.ma25LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma25LineLayer];
    
    
    if (self.commentBGLayer)
    {
        [self.commentBGLayer removeFromSuperlayer];
        self.commentBGLayer = nil;
    }
    
    if (!self.commentBGLayer)
    {
        self.commentBGLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.commentBGLayer];
    }
    
    if (self.commentDialogBGLayer)
    {
        [self.commentDialogBGLayer removeFromSuperlayer];
        self.commentDialogBGLayer = nil;
    }
    
    if (!self.commentDialogBGLayer)
    {
        self.commentDialogBGLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.commentDialogBGLayer];
    }
}

// 初始化layer
- (void)removeLayers
{
    
    if (self.klineLayer) {
        
        [self.klineLayer removeFromSuperlayer];
        self.klineLayer = nil;
    }
    
    if (self.commentBGLayer)
    {
        [self.commentBGLayer removeFromSuperlayer];
        self.commentBGLayer = nil;
    }
    
    if (self.commentDialogBGLayer)
    {
        [self.commentDialogBGLayer removeFromSuperlayer];
        self.commentDialogBGLayer = nil;
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
    //ma5
    if (self.ma5LineLayer)
    {
        for (NSInteger i = 0 ; i < self.ma5LineLayer.sublayers.count; i++)
        {
            id layer = self.ma5LineLayer.sublayers[i];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [layer removeFromSuperlayer];
            layer = nil;
            [CATransaction commit];
        }
        
        [self.ma5LineLayer removeFromSuperlayer];
        self.ma5LineLayer = nil;
    }
    //ma10
    if (self.ma10LineLayer)
    {
        [self.ma10LineLayer removeFromSuperlayer];
        self.ma10LineLayer = nil;
    }
    //ma25
    if (self.ma25LineLayer)
    {
        [self.ma25LineLayer removeFromSuperlayer];
        self.ma10LineLayer = nil;
    }
    
    [self removeAllSubLayers];
    
}

//// 蜡烛图位置layer
//- (CAShapeLayer*)getShaperLayer:(ZYWCandlePostionModel*)postion
//{
//    CGFloat openPrice = postion.openPoint.y + self.topMargin;
//    CGFloat closePrice = postion.closePoint.y + self.topMargin;
//    CGFloat hightPrice = postion.highPoint.y + self.topMargin;
//    CGFloat lowPrice = postion.lowPoint.y + self.topMargin;
//    CGFloat x = postion.openPoint.x;
//    CGFloat y = openPrice > closePrice ? (closePrice) : (openPrice);
//    CGFloat height = MAX(fabs(closePrice-openPrice), self.minHeight);
//
//    CGRect rect = CGRectMake(x, y, self.candleWidth, height);
//    UIBezierPath *path = [UIBezierPath drawKLine:openPrice close:closePrice high:hightPrice low:lowPrice candleWidth:self.candleWidth rect:rect xPostion:x lineWidth:self.lineWidth];
//    CAShapeLayer *subLayer = [CAShapeLayer layer];
//    if (postion.openPoint.y >= postion.closePoint.y)
//    {
//        subLayer.strokeColor = RoseColor.CGColor;
//        subLayer.fillColor = RoseColor.CGColor;
//    }
//
//    else
//    {
//        subLayer.strokeColor = DropColor.CGColor;
//        subLayer.fillColor = DropColor.CGColor;
//    }
//
//    subLayer.path = path.CGPath;
//    [path removeAllPoints];
//    return subLayer;
//}

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
//- (void)addCandleRef:(CGMutablePathRef)ref postion:(ZYWCandlePostionModel*)postion
//{
//    CGFloat openPrice = postion.openPoint.y + self.topMargin;
//    CGFloat closePrice = postion.closePoint.y + self.topMargin;
//    CGFloat hightPrice = postion.highPoint.y + self.topMargin;
//    CGFloat lowPrice = postion.lowPoint.y + self.topMargin;
//    CGFloat x = postion.openPoint.x;
//    CGFloat y = openPrice > closePrice ? (closePrice) : (openPrice);
//    CGFloat height = MAX(fabs(closePrice-openPrice), _minHeight);
//    CGRect rect = CGRectMake(x, y, _candleWidth, height);
//
//    if (isEqualZero(fabs(closePrice-openPrice)))
//    {
//        rect = CGRectMake(x, closePrice - height, _candleWidth, height);
//    }
//
//    CGPathAddRect(ref, NULL, rect);
//
//    CGFloat xPostion = x + _candleWidth / 2;
//    if (closePrice < openPrice)
//    {
//        if (!isEqualZero(closePrice - hightPrice))
//        {
//            CGPathMoveToPoint(ref, NULL, xPostion, closePrice);
//            CGPathAddLineToPoint(ref, NULL, xPostion, hightPrice);
//        }
//
//        if (!isEqualZero(lowPrice - openPrice))
//        {
//            CGPathMoveToPoint(ref, NULL, xPostion, lowPrice);
//            CGPathAddLineToPoint(ref, NULL, xPostion, openPrice + _lineWidth/2.f);
//        }
//    }
//
//    else
//    {
//        if (!isEqualZero(openPrice - hightPrice))
//        {
//            CGPathMoveToPoint(ref, NULL, xPostion, openPrice);
//            CGPathAddLineToPoint(ref, NULL, xPostion, hightPrice);
//        }
//
//        if (!isEqualZero(lowPrice - closePrice))
//        {
//            CGPathMoveToPoint(ref, NULL, xPostion, lowPrice);
//            CGPathAddLineToPoint(ref, NULL, xPostion, closePrice - _lineWidth);
//        }
//    }
//}

#pragma mark draw
// 画所有蜡烛图
- (void)drawCandleSublayers
{
    //    CGMutablePathRef redRef = CGPathCreateMutable();
    //    CGMutablePathRef greenRef = CGPathCreateMutable();
//    for (ZYWCandlePostionModel *model in self.currentPostionArray) {
//
//        if (model.openPoint.y > model.closePoint.y)
//        {
//            //            [self addCandleRef:redRef postion:model];
//            [self getShaperLayer:model color:RoseColor];
//        }
//
//        else if (model.openPoint.y < model.closePoint.y)
//        {
//            //            [self addCandleRef:greenRef postion:model];
//            [self getShaperLayer:model color:DropColor];
//        }
//
//        else
//        {
//            [self getShaperLayer:model color:RoseColor];
//            //            [self addCandleRef:redRef postion:model];
//        }
//    }
    
    //    self.redLayer.lineWidth = (1 / [UIScreen mainScreen].scale) *1.5f;
    //    self.redLayer.path = redRef;
    //    self.redLayer.fillColor = RoseColor.CGColor;
    //    self.redLayer.strokeColor = RoseColor.CGColor;
    //
    //    self.greenLayer.lineWidth = (1 / [UIScreen mainScreen].scale) *1.5f;
    //    self.greenLayer.path = greenRef;
    //    self.greenLayer.fillColor = DropColor.CGColor;
    //    self.greenLayer.strokeColor = DropColor.CGColor;
    
    for (int index = 0; index < self.currentPostionArray.count; index ++) {
        NSInteger idx = (self.currentPostionArray.count - 1- index);
        ZTYCandlePosionModel *model = [self.currentPostionArray objectAtIndex:idx];
        if (model.openPoint.y > model.closePoint.y)
        {
            //            [self addCandleRef:redRef postion:model];
            [self getShaperLayer:model color:RoseColor];
        }
        
        else if (model.openPoint.y < model.closePoint.y)
        {
            //            [self addCandleRef:greenRef postion:model];
            [self getShaperLayer:model color:DropColor];
        }
        
        else
        {
            [self getShaperLayer:model color:RoseColor];
            //            [self addCandleRef:redRef postion:model];
        }
        
    }
}

// 画均线MA
- (void)drawMALineLayer
{
    
    UIBezierPath *ma5Path = [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"ma7Point" dayCount:7];
    self.ma5LineLayer.path = ma5Path.CGPath;
    self.ma5LineLayer.strokeColor = [UIColor colorWithHexString:@"FBC170"].CGColor;
    self.ma5LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma5LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIBezierPath *ma10Path = [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"ma10Point" dayCount:10];
    self.ma10LineLayer.path = ma10Path.CGPath;
    self.ma10LineLayer.strokeColor =[UIColor magentaColor].CGColor;
    self.ma10LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma10LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIBezierPath *ma25Path = [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"ma30Point" dayCount:30];
    self.ma25LineLayer.path = ma25Path.CGPath;
    self.ma25LineLayer.strokeColor = [UIColor colorWithHexString:@"AED3E3"].CGColor;
    self.ma25LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma25LineLayer.contentsScale = [UIScreen mainScreen].scale;
}

// 画均线EMA
- (void)drawEMALineLayer
{
    
    if (self.ma10LineLayer) {
        [self.ma10LineLayer removeFromSuperlayer];
        self.ma10LineLayer = nil;
    }
    
    //    NSMutableArray *pathsArray = [UIBezierPath drawLines:self.maPostionArray];
    
    UIBezierPath *ma5Path = [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"ema7Point" dayCount:7];//pathsArray[0];
    self.ma5LineLayer.path = ma5Path.CGPath;
    self.ma5LineLayer.strokeColor = [UIColor colorWithHexString:@"AED3E3"].CGColor;
    self.ma5LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma5LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    UIBezierPath *ma25Path = [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"ema30Point" dayCount:30];;
    self.ma25LineLayer.path = ma25Path.CGPath;
    self.ma25LineLayer.strokeColor = [UIColor colorWithHexString:@"FBC170"].CGColor;
    self.ma25LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma25LineLayer.contentsScale = [UIScreen mainScreen].scale;
}

// 画分时线
- (void)drawTimeLineLayer
{
    //    UIBezierPath *ma5Path =  [UIBezierPath drawLine:self.currentPostionArray];
//    UIBezierPath *timePath =  [UIBezierPath drawcandlePosionLine:self.currentPostionArray];
    
    //    UIBezierPath *ma5Path =  [UIBezierPath drawLine:self.currentPostionArray];
    UIBezierPath *timePath =  [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"closePoint" dayCount:0 topmagin:self.topMargin];
    
    self.timeLineLayer.path = timePath.CGPath;
    self.timeLineLayer.strokeColor = backBlue.CGColor;
    self.timeLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.timeLineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"308CDD"].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:1].CGColor];
    //    // 设置渐变方向(0~1)
    //    self.gradientLayer.startPoint = CGPointMake(0, 0);
    //    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //
    //    // 设置渐变色的起始位置和终止位置(颜色的分割点)
    //    self.gradientLayer.locations = @[@(0.0),@(1.0)];
    //    self.gradientLayer.borderWidth  = 0.0;
    
    
    //    UIBezierPath *gradientPath = [UIBezierPath drawLine:self.currentPostionArray];
    //    ZYWCandlePostionModel* firstLine = [self.currentPostionArray firstObject];
    //    ZYWCandlePostionModel* lastLine = [self.currentPostionArray lastObject];
    //
    //
    //    [gradientPath addLineToPoint:CGPointMake(lastLine.closePoint.x, self.height - self.timeLayerHeight - self.bottomMargin)];
    //    [gradientPath addLineToPoint:CGPointMake(firstLine.closePoint.x, self.height - self.timeLayerHeight - self.bottomMargin)];
    //    CAShapeLayer * mask = [CAShapeLayer layer];
    //    mask.path = gradientPath.CGPath;
    //    self.gradientLayer.frame = CGRectMake(0, 0, lastLine.closePoint.x, self.height - self.bottomMargin);
    //    self.gradientLayer.mask = mask;
    
}


- (void)calcuteBollLinePostion{
    [self.maPostionArray removeAllObjects];
    NSMutableArray * upArray = [NSMutableArray array];
    NSMutableArray * dnArray = [NSMutableArray array];
    NSMutableArray * mbArray = [NSMutableArray array];
    [self.currentDisplayArray enumerateObjectsUsingBlock:^(ZTYChartModel *kLinemodel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2;
        CGFloat yupPosition = ((self.maxY - kLinemodel.BOLL_UP.floatValue) *self.scaleY) + self.topMargin;
        
        CGFloat ydnPosition = ((self.maxY - kLinemodel.BOLL_DN.floatValue) *self.scaleY) + self.topMargin;
        
        CGFloat ymbPosition = ((self.maxY - kLinemodel.BOLL_MB.floatValue) *self.scaleY) + self.topMargin;
        
        
        
        if ([_dataArray indexOfObject:kLinemodel] > 19){
            ZYWLineModel *upmodel = [ZYWLineModel  initPositon:xPosition yPosition:yupPosition color:[UIColor redColor]];
            [upArray addObject:upmodel];
            
            ZYWLineModel *dnmodel = [ZYWLineModel  initPositon:xPosition yPosition:ydnPosition color:[UIColor redColor]];
            [dnArray addObject:dnmodel];
            
            ZYWLineModel *mbmodel = [ZYWLineModel  initPositon:xPosition yPosition:ymbPosition color:[UIColor redColor]];
            [mbArray addObject:mbmodel];
        }
        
    }];
    
    [self.maPostionArray addObject:upArray];
    [self.maPostionArray addObject:dnArray];
    [self.maPostionArray addObject:mbArray];
}

// 画BOLL线
- (void)drawBollLineLayer{
    
    // ma5 up
    // ma10 dn
    // ma30 mb
//    UIBezierPath * upPath = [UIBezierPath drawLine:self.maPostionArray[0]];
//    UIBezierPath * dnPath = [UIBezierPath drawLine:self.maPostionArray[1]];
//    UIBezierPath * mbPath = [UIBezierPath drawLine:self.maPostionArray[2]];

    UIBezierPath * upPath = [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"uperPoint" dayCount:20];
    UIBezierPath * dnPath = [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"downPoint" dayCount:20];
    UIBezierPath * mbPath = [UIBezierPath drawcandlePosionLine:self.currentPostionArray withKey:@"midPoint" dayCount:20];
    
    self.ma5LineLayer.path = upPath.CGPath;
    self.ma5LineLayer.strokeColor = [UIColor colorWithHexString:@"D89640"].CGColor;
    self.ma5LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma5LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    self.ma10LineLayer.path = dnPath.CGPath;
    self.ma10LineLayer.strokeColor = [UIColor colorWithHexString:@"E08FE0"].CGColor;
    self.ma10LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma10LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    self.ma25LineLayer.path = mbPath.CGPath;
    self.ma25LineLayer.strokeColor = [UIColor colorWithHexString:@"2DB52D"].CGColor;
    self.ma25LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma25LineLayer.contentsScale = [UIScreen mainScreen].scale;
}

// 画所有蜡烛图
- (void)drawSARSublayers
{
    
    if (self.ma10LineLayer) {
        [self.ma10LineLayer removeFromSuperlayer];
        self.ma10LineLayer = nil;
    }
    if (self.ma25LineLayer) {
        [self.ma25LineLayer removeFromSuperlayer];
        self.ma25LineLayer = nil;
    }
    
    for (ZTYCandlePosionModel *model in self.currentPostionArray) {
        
        CGPoint point = [[model valueForKey:@"sarPoint"] CGPointValue];
        
        UIBezierPath *inbezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point.x ,point.y) radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        inbezierPath.lineWidth = 1;
        CAShapeLayer * incircle = [CAShapeLayer layer];
        
        incircle.path = inbezierPath.CGPath;
        incircle.strokeColor = [UIColor colorWithHexString:@"2FD2B2"].CGColor;
        incircle.lineWidth = 1;
        incircle.fillColor = [UIColor whiteColor].CGColor;
        [self.ma5LineLayer addSublayer:incircle];
    }
    
}

// 日期显示以及时间线 竖线
//- (void)drawKlineTimeLayer
//{
//    [self.currentPostionArray enumerateObjectsUsingBlock:^(ZYWCandlePostionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (model.isDrawDate)
//        {
//            [self drawTimeText:model.date xposion:model.highPoint.x];
//            //时间
//        }
//    }];
//
//}
//
//// 日期显示以及时间线 竖线  分时
//- (void)drawTimeLayer
//{
//    [self.currentPostionArray enumerateObjectsUsingBlock:^(ZYWCandlePostionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (model.isDrawDate)
//        {
//            [self drawTimeText:model.date xposion:model.closePoint.x];
//        }
//    }];
//
//}

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
        layer.position = CGPointMake(xposion + self.candleWidth , self.height - self.timeLayerHeight/2 - self.bottomMargin);
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
        [path moveToPoint:CGPointMake(xposion + self.candleWidth/2 - BoxborderWidth/2, 1*heightradio)];
        [path addLineToPoint:CGPointMake(xposion + self.candleWidth/2 - BoxborderWidth/2 ,self.height - self.timeLayerHeight - self.bottomMargin)];
        lineLayer.path = path.CGPath;
        [self.timeLayer addSublayer:lineLayer];
        
    }
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
    
    //    CAShapeLayer *maxLineLayer = [self getAxispLayer];
    //    maxLineLayer.lineWidth = lineWidht;
    //    UIBezierPath *maxpath = [UIBezierPath bezierPath];
    //    [maxpath moveToPoint:CGPointMake(0, height * 1)];
    //    [maxpath addLineToPoint:CGPointMake(klineW,height * 1)];
    //    maxpath.lineWidth = lineWidht;
    //    maxLineLayer.path = maxpath.CGPath;
    //    [self.timeLayer addSublayer:maxLineLayer];
    //
    //    CAShapeLayer *smaxLineLayer = [self getAxispLayer];
    //    smaxLineLayer.lineWidth = lineWidht;
    //    UIBezierPath *bpath = [UIBezierPath bezierPath];
    //    [bpath moveToPoint:CGPointMake(0, height * 2)];
    //    [bpath addLineToPoint:CGPointMake(klineW,height * 2)];
    //    bpath.lineWidth = lineWidht;
    //    smaxLineLayer.path = bpath.CGPath;
    //    [self.timeLayer addSublayer:smaxLineLayer];
    //
    //    CAShapeLayer *middleLineLayer = [self getAxispLayer];
    //    middleLineLayer.lineWidth = self.lineWidth;
    //    UIBezierPath *middlepath = [UIBezierPath bezierPath];
    //    [middlepath moveToPoint:CGPointMake(0, height * 3)];
    //    [middlepath addLineToPoint:CGPointMake(klineW,height * 3)];
    //    middlepath.lineWidth = self.lineWidth;
    //    middleLineLayer.path = middlepath.CGPath;
    //    [self.timeLayer addSublayer:middleLineLayer];
    //
    //    CAShapeLayer *sminLayer = [self getAxispLayer];
    //    sminLayer.lineWidth = lineWidht;
    //    UIBezierPath *sminpath = [UIBezierPath bezierPath];
    //    [sminpath moveToPoint:CGPointMake(0, height * 4)];
    //    [sminpath addLineToPoint:CGPointMake(klineW,height * 4)];
    //    sminpath.lineWidth = lineWidht;
    //    sminLayer.path = sminpath.CGPath;
    //    [self.timeLayer addSublayer:sminLayer];
    //
    //    CAShapeLayer *minLayer = [self getAxispLayer];
    //    minLayer.lineWidth = lineWidht;
    //    UIBezierPath *minpath = [UIBezierPath bezierPath];
    //    [minpath moveToPoint:CGPointMake(0, height * 5)];
    //    [minpath addLineToPoint:CGPointMake(klineW,height * 5)];
    //    minpath.lineWidth = lineWidht;
    //    minLayer.path = minpath.CGPath;
    //    [self.timeLayer addSublayer:minLayer];
    
    
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
    if (self.lineCount == 0) {
        self.lineCount = 6;
    }
    CGFloat height = self.height / (self.lineCount * 1.0);
    self.leftMargin = 2;
    self.rightMargin = 2;
    self.topMargin = height; // 20
    self.bottomMargin = 0;
    self.minHeight = 1;
    self.kvoEnable = YES;
    if (self.NoBottm) {
        self.timeLayerHeight = 5; // 15
    }else{
        self.timeLayerHeight = height; // 15
    }
    
}

#pragma mark -- 开始画线
- (void)drawKLine
{
    // 将要显示的数据
    [self initCurrentDisplayModels];
    [self calculateMaxAndMinValue]; // 计算极值
    [self calculatePosion];
    if (self.delegate && [self.delegate respondsToSelector: @selector(displayScreenleftPostion:startIndex:count:)])
    {
        [_delegate displayScreenleftPostion:self.leftPostion startIndex:self.currentStartIndex count:self.displayCount];
    }
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(displayLastModel:)])
        {
            ZTYChartModel *lastModel = self.currentDisplayArray.lastObject;
            [_delegate displayLastModel:lastModel];
        }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self removeAllSubLayers]; // 移除所有的layer
    [self initLayer]; // 初始化layer
    //    [self drawCandleSublayers]; // 画所有蜡烛图
    [self drawlayer];
    [self drawAxisLine]; // 画横线
    [self showCommentBtns];
    [CATransaction commit];

}

- (void)calculateMaxAndMinValue{
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    if (self.mainchartType == MainChartcenterViewTypeKline) {
        [self calcuteCandleMaxAndMinValue]; // 计算蜡烛极值
    }else{
        // 选择分时
        [self calcuteTimeLineMaxAndMinValue]; // 计算分时极值
    }
    
    if (self.mainquotaName == MainViewQuotaNameWithBOLL) {
        [self calcuteBollMaxAndMinValue];
    }else if (self.mainquotaName == MainViewQuotaNameWithMA){
        [self calcuteMaMaxAndMinValue];
    }else if (self.mainquotaName == MainViewQuotaNameWithEMA){
        [self calcuteEMAMaxAndMinValue];
    }else if(self.mainquotaName == MainViewQuotaNameWithSAR){
        [self calcuteSARMaxAndMinValue];
    }
    
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight) / (self.maxY - self.minY);
    
}

- (void)calculatePosion{
    
    
//    if (self.mainchartType == MainChartcenterViewTypeKline) {
//        [self initCandleModelPositoin];
//    }else{
//        [self initTimeModelPositoin];
//    }
//
//    if (self.mainquotaName == MainViewQuotaNameWithBOLL) {
//        [self calcuteBollLinePostion]; // 计算BOLL的位置
//    }else if (self.mainquotaName == MainViewQuotaNameWithMA){
//        [self calcuteMaLinePostion];
//    }else if (self.mainquotaName == MainViewQuotaNameWithEMA){
//        [self calcuteEMALinePostion];
//    }else if(self.mainquotaName == MainViewQuotaNameWithSAR){
//        [self calcuteSARLinePostion];
//    }
    
    [self.currentPostionArray removeAllObjects];
    
    NSUInteger idx = 0;
    for (ZTYChartModel *model in self.currentDisplayArray) {
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.leftMargin;
        model.markLeft = xPosition;
        ZTYCandlePosionModel *candlePosionModel = [ZTYCandlePosionModel initWithCandleModel:model left:xPosition maxY:self.maxY scaleY:self.scaleY topMagin:self.topMargin];
        candlePosionModel.superArrIndex = [self.dataArray indexOfObject:model];
        //        NSLog(@"index===>%ld",[self.dataArray indexOfObject:model]);
        [self.currentPostionArray addObject:candlePosionModel];
        
        idx ++;
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
    
    if (self.mainquotaName == MainViewQuotaNameWithBOLL) {
        [self drawBollLineLayer]; // 画均线BOLL
        
    }else if (self.mainquotaName == MainViewQuotaNameWithMA){
        
        [self drawMALineLayer]; // 画均线MA
    }else if (self.mainquotaName == MainViewQuotaNameWithEMA){
        [self drawEMALineLayer];
    }else if(self.mainquotaName == MainViewQuotaNameWithSAR){
        [self drawSARSublayers];
    }else{
        [self removeAllQuotaLayer];
    }
}


- (void)removeAllQuotaLayer{
    
    [self.maPostionArray removeAllObjects];
    if (self.ma5LineLayer) {
        for (NSInteger i = 0 ; i < self.ma5LineLayer.sublayers.count; i++)
        {
            id layer = self.ma5LineLayer.sublayers[i];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [layer removeFromSuperlayer];
            layer = nil;
            [CATransaction commit];
        }
        [self.ma5LineLayer removeFromSuperlayer];
        self.ma5LineLayer = nil;
    }
    if (self.ma10LineLayer) {
        [self.ma10LineLayer removeFromSuperlayer];
        self.ma10LineLayer = nil;
    }
    if (self.ma25LineLayer) {
        [self.ma25LineLayer removeFromSuperlayer];
        self.ma25LineLayer = nil;
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
    
    CGFloat prevContentOffset = self.currentStartIndex * self.candleWidth + (self.currentStartIndex - 1) * self.candleSpace + self.leftMargin+self.rightMargin;
    CGFloat klineWidth = self.dataArray.count*(self.candleWidth) + (self.dataArray.count - 1) *self.candleSpace + self.leftMargin + self.rightMargin;
    if(klineWidth < self.superScrollView.width)
    {
        klineWidth = self.superScrollView.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    
    self.superScrollView.contentSize = CGSizeMake(klineWidth,0);
    self.superScrollView.contentOffset = CGPointMake(prevContentOffset,0);
    [self layoutIfNeeded];
    [self drawKLine];
}

- (void)displayLayer:(CALayer *)layer
{
    [self drawKLine];
}

- (void)initCommentLayer{
    
    if (self.commentBGLayer)
    {
        [self.commentBGLayer removeFromSuperlayer];
        self.commentBGLayer = nil;
    }
    
    if (!self.commentBGLayer)
    {
        self.commentBGLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.commentBGLayer];
    }
    
    if (self.commentDialogBGLayer)
    {
        [self.commentDialogBGLayer removeFromSuperlayer];
        self.commentDialogBGLayer = nil;
    }
    
    if (!self.commentDialogBGLayer)
    {
        self.commentDialogBGLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.commentDialogBGLayer];
    }
}

//BOOL firstCommentShow = YES;
#pragma mark -- 添加点评线
- (void)showCommentBtns{
    
    if (!_isNotComment) {
        
        [self.commentLayerArray removeAllObjects];
        [self.circleLayerArray removeAllObjects];
        
        [self initCommentLayer];
        
        for (int i = 0; i< self.commentArr.count; i ++) {
            
            ZTYKlineComment * comment = self.commentArr[i];
            
            for (NSInteger index = 0; index < self.currentDisplayArray.count; index ++) {
                
                
                
                NSInteger kindex = self.currentDisplayArray.count - 1 - index;
                ZTYChartModel * model = [self.currentDisplayArray objectAtIndex:kindex];
                
                
                if ([comment.klineDateTime integerValue] == [model.timestamp integerValue]) {
                    CGFloat yMaxPosition = ((self.maxY - model.low) *self.scaleY) + self.topMargin ;
                    
                    
                    // 标记位置1：上影线0：下影线  markerPlace
                    
                    
                    
                    
                    //                CGFloat close = ((self.maxY - entity.close) * self.scaleY);
                    ZTYCircleLayer * circleLayer = [ZTYCircleLayer layer];
                    circleLayer.tag = 8888;
                    circleLayer.timestanp = [model.timestamp integerValue];
                    //                    circleLayer.circleColor = [UIColor colorWithHexString:@"C8C8C8" alpha:0.2];
                    [self.commentBGLayer addSublayer:circleLayer];
                    [self.circleLayerArray addObject:circleLayer];
                    
                    
                    ZTYDialogTextLayer * dialogLayer = [ZTYDialogTextLayer layer];
                    
                    
                    
                    if (_isFreshing) {
                        //                        comment.isShow = !comment.isShow;
                        
                        
                        if (comment.isShow == YES) {
                            
                            //                            dialogLayer.hidden = !comment.isShow;
                            dialogLayer.hidden = NO;
                            
                            dialogLayer.isDHiden = NO;
                            
                        }else{
                            
                            dialogLayer.hidden = YES;
                            dialogLayer.isDHiden = YES;
                        }
                    }else{
                        
                        
                        //                        dialogLayer.hidden = !firstCommentShow;
                        //                        dialogLayer.isDHiden = !firstCommentShow;
                        //                        comment.isShow = firstCommentShow;
                        if (_firstCommentShow) {
                            dialogLayer.hidden = !_firstCommentShow;
                            dialogLayer.isDHiden = !_firstCommentShow;
                            comment.isShow = _firstCommentShow;
                            _firstCommentShow = NO;
                        }else{
                            dialogLayer.hidden = !comment.isShow;
                            dialogLayer.isDHiden = !comment.isShow;
                            
                        }
                    }
                    
                    
                    
                    
                    
                    //                    [dialogLayer setText:comment.content];
                    //                    [dialogLayer setText:@"把程序放在网站中，提供给最终用户一个链接，他们就能够直接下载并自动安装了"];
                    
                    dialogLayer.tag = [comment.klineDateTime integerValue];
                    CGFloat xpoint = model.markLeft + _candleWidth / 2.0f ;
                    
                    // 标记位置1：上影线  0：下影线  markerPlace
                    if (comment.markerPlace == 1) {
                        yMaxPosition = ((self.maxY - model.high) *self.scaleY) + self.topMargin - 19;
                    }else{
                        yMaxPosition = ((self.maxY - model.low) *self.scaleY) + self.topMargin;
                    }
                    
                    CGSize size = [comment.content getSizeOfString:[UIFont systemFontOfSize:10] constroSize:CGSizeMake(129 - 15, SCREEN_HEIGHT)];
                    
                    [dialogLayer setBackFrame:CGRectMake(xpoint -129 + 3.2 + 7.3, yMaxPosition + 19 + 2, 129, size.height + 22) contentText:comment.content];
                    circleLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"klinecircle"]].CGColor;
                    circleLayer.frame =CGRectMake(xpoint - 9.5, yMaxPosition , 19, 19);
                    //                    [circleLayer setCirleFrame:CGRectMake(xpoint - 20, yMaxPosition , 40, 40)];
                    [self.commentDialogBGLayer addSublayer:dialogLayer];
                    [self.commentLayerArray addObject:dialogLayer];
                    
                    
                    
                    break;
                    
                }
                
                
            }
        }
        
    }
    
    //    NSLog(@"%@",self.commentArr);
}

- (void)hideCommentBtns{
    
    for (ZTYCircleLayer * layer in self.circleLayerArray) {
        layer.hidden = YES;
    }
    for (ZTYDialogTextLayer * layer in self.commentLayerArray) {
        layer.hidden = YES;
    }
    _isNotComment = YES;
}

- (void)hideDialogs{
    for (ZTYDialogTextLayer * layer in self.commentLayerArray) {
        layer.hidden = YES;
    }
    
    for (ZTYKlineComment * comment in self.commentArr) {
        comment.isShow = NO;
    }
}

- (void)commentClick:(UIButton *)btn{
    
    UILabel * label = [self viewWithTag:(btn.tag - 1000000000000)];
    if (label.hidden) {
        label.hidden = NO;
    }else{
        label.hidden = YES;
    }
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
        
        ZTYCandlePosionModel *kLinePositionModel = self.currentPostionArray[index];
        
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
    ZTYCandlePosionModel *lastPositionModel = self.currentPostionArray.lastObject;
    
    if (localPostion >= lastPositionModel.closePoint.x)
    {
        return CGPointMake(lastPositionModel.highPoint.x, lastPositionModel.openPoint.y);
    }
    
    //第一根线
    ZTYCandlePosionModel *firstPositionModel = self.currentPostionArray.firstObject;
    if (firstPositionModel.closePoint.x >= localPostion)
    {
        return CGPointMake(firstPositionModel.highPoint.x, firstPositionModel.openPoint.y);
    }
    
    return CGPointZero;
}

-(CGPoint)getTapModelPostionWithPostion:(CGPoint)postion
{
    
    if (!self.isNotComment) {
        
        BOOL layerIsHidden = NO;
        ZTYCircleLayer *layer = (ZTYCircleLayer *)[self.commentBGLayer hitTest:postion];
        if ( layer.tag == 8888) {
            
            
            int index = 0;
            for (ZTYDialogTextLayer * dialogLayer in self.commentLayerArray) {
                
                
                if (dialogLayer.tag == layer.timestanp ) {
                    
                    dialogLayer.hidden = !dialogLayer.isDHiden;
                    dialogLayer.isDHiden = !dialogLayer.isDHiden;
                    layerIsHidden = dialogLayer.isDHiden;
                    
                }else{
                    
                    dialogLayer.hidden = YES;
                    
                }
                index ++;
                
            }
            for (ZTYKlineComment *com in self.commentArr) {
                if ([com.klineDateTime isEqualToString:[NSString stringWithFormat:@"%ld",layer.timestanp]]) {
                    com.isShow = !layerIsHidden;
                }
                
                else{
                    com.isShow = NO;
                }
            }
            
            return CGPointZero;
        }
    }
    
    
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(tapCandleViewWithIndex:kLineModel:startIndex:price:)])
            {
                ZTYChartModel * model = self.currentDisplayArray[index];
                [self.delegate tapCandleViewWithIndex:index kLineModel:model startIndex:_currentStartIndex price:price];
                
                BOOL layerIsHidden = NO;
                for (ZTYDialogTextLayer * dialogLayer in self.commentLayerArray) {
                    if (dialogLayer.tag == [model.timestamp integerValue]) {
                        dialogLayer.hidden = !dialogLayer.isDHiden;
                        dialogLayer.isDHiden = !dialogLayer.isDHiden;
                        layerIsHidden = dialogLayer.isDHiden;
                    }else{
                        dialogLayer.hidden = YES;
                    }
                    
                }
                
                for (ZTYKlineComment *com in self.commentArr) {
                    if ([com.klineDateTime isEqualToString:model.timestamp]) {
                        com.isShow = !layerIsHidden;
                    }
                    
                    else{
                        com.isShow = NO;
                    }
                }
                
            }
            
            return CGPointMake(kLinePositionModel.highPoint.x, kLinePositionModel.openPoint.y);
        }
    }
    
    //最后一根线
    ZTYCandlePosionModel *lastPositionModel = self.currentPostionArray.lastObject;
    
    if (localPostion >= lastPositionModel.closePoint.x)
    {
        return CGPointMake(lastPositionModel.highPoint.x, lastPositionModel.openPoint.y);
    }
    
    //第一根线
    ZTYCandlePosionModel *firstPositionModel = self.currentPostionArray.firstObject;
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

#pragma mark setter

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

- (NSMutableArray *)commentLayerArray{
    
    if (!_commentLayerArray) {
        _commentLayerArray = [NSMutableArray array];
    }
    return _commentLayerArray;
}

- (NSMutableArray *)circleLayerArray{
    
    if (!_circleLayerArray) {
        _circleLayerArray = [NSMutableArray array];
    }
    return _circleLayerArray;
}

@end

