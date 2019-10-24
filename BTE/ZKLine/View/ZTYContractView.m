//
//  ZTYContractView.m
//  BTE
//
//  Created by wanmeizty on 20/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYContractView.h"
#import "KVOController.h"
#import "ZYWCandlePostionModel.h"
#import "ZTYCalCuteNumber.h"

#import "ZTYDialogTextLayer.h"

#import "ZTYCandlePosionModel.h"

#define MINDISPLAYCOUNT 6

#define largeWidth 15
#define smallWidth 10

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZTYContractView ()
<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) FBKVOController *KVOController;

@property (nonatomic,strong) CAShapeLayer *ma5LineLayer; // ma5  BOLL线 UP线
@property (nonatomic,strong) CAShapeLayer *ma10LineLayer; // ma10  BOLL线 DN线
@property (nonatomic,strong) CAShapeLayer *ma25LineLayer; // ma30  BOLL线 MB线

@property (nonatomic,strong) CAShapeLayer * timeLineLayer; // 分时线
//@property (nonatomic,strong) CAGradientLayer * gradientLayer; // 分时渐变
@property (nonatomic,strong) CAShapeLayer *timeLayer;
//@property (nonatomic,strong) NSMutableArray *maPostionArray;
@property (nonatomic,assign) CGFloat timeLayerHeight;

@property (nonatomic,strong) CAShapeLayer * klineLayer;

@property (nonatomic,strong) ZTYChartModel * currentMaxModel;
@property (nonatomic,strong) ZTYChartModel * currentMinModel;

@property (nonatomic,strong) CAShapeLayer * orderLayer;
@end

@implementation ZTYContractView

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
        
        if (self.reloadIndex == 3) {
            CGFloat klineWidth = self.dataArray.count*(self.candleWidth) + (self.dataArray.count - 1) *self.candleSpace + self.leftMargin + self.rightMargin;
            scrollViewOffsetX = klineWidth - self.superScrollView.width;
        }else{
            scrollViewOffsetX = self.superScrollView.contentSize.width - self.superScrollView.width;
        }
        
    }
    return scrollViewOffsetX;
}

// 显示的数据
- (void)initCurrentDisplayModels
{
    if (self.dataArray.count == 0){
//        [self removeLayers]; // 移除所有的layer
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
    if (count > self.dataArray.count - 2 && count > MinCount) {
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
    for (NSInteger i = 0 ; i < self.klineLayer.sublayers.count; i++)
    {
        id layer = self.klineLayer.sublayers[i];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [layer removeFromSuperlayer];
        layer = nil;
        [CATransaction commit];
    }
    
    for (NSInteger i = 0 ; i < self.orderLayer.sublayers.count; i++)
    {
        id layer = self.orderLayer.sublayers[i];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [layer removeFromSuperlayer];
        layer = nil;
        [CATransaction commit];
    }
    
    for (int index = 0; index < self.currentPostionArray.count; index ++) {
        NSInteger idx = (self.currentPostionArray.count - 1- index);
        ZTYCandlePosionModel *model = [self.currentPostionArray objectAtIndex:idx];
        ZTYChartModel * candeModel = [self.currentDisplayArray objectAtIndex:idx];
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
        
        [self showOrder:model candleModel:candeModel];
        
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

- (void)showOrder:(ZTYCandlePosionModel *)model candleModel:(ZTYChartModel *)candleModel{
    if (self.showOrder) {
        
        if (candleModel.support > 0|| candleModel.resistance > 0) {
            
            if (candleModel.supportCount > candleModel.resistanceCount) {
                CGFloat layerWidth = smallWidth;
                NSString * imageName = [NSString stringWithFormat:@"kbuy"];
                if (candleModel.supportCount > 50000) {
                    imageName = [NSString stringWithFormat:@"kbuy"];
                }
                CAShapeLayer * layer = [CAShapeLayer layer];
                layer.frame = CGRectMake(model.supportPoint.x - layerWidth * 0.5 + _candleWidth * 0.5, model.supportPoint.y - layerWidth * 0.5, layerWidth, layerWidth);
                UIImage * image = [UIImage imageNamed:imageName];
                layer.contents = (__bridge id _Nullable)(image.CGImage);
                [self.orderLayer addSublayer:layer];
            }else{
                CGFloat layerWidth = smallWidth;
                NSString * imageName = [NSString stringWithFormat:@"ksell"];
                if (candleModel.resistanceCount > 50000) {
                    imageName = [NSString stringWithFormat:@"ksell"];
                }
                CAShapeLayer * layer = [CAShapeLayer layer];
                layer.frame = CGRectMake(model.resitancePoint.x + _candleWidth * 0.5 - layerWidth * 0.5, model.resitancePoint.y - layerWidth * 0.5, layerWidth, layerWidth);
                UIImage * image = [UIImage imageNamed:imageName];
                layer.contents = (__bridge id _Nullable)(image.CGImage);
                [self.orderLayer addSublayer:layer];
            }
        }
        
        if (candleModel.buyburned > 0) {
            CGFloat layerWidth = smallWidth;
            NSString * imageName = [NSString stringWithFormat:@"k%@",candleModel.buyburnedType];
            if (candleModel.buyburnedCount > 50000) {
                
                imageName = [NSString stringWithFormat:@"kL%@",candleModel.buyburnedType];
            }
            CAShapeLayer * layer = [CAShapeLayer layer];
            layer.frame = CGRectMake(model.buyburnedPoint.x + _candleWidth * 0.5 - layerWidth * 0.5, model.buyburnedPoint.y - layerWidth * 0.5, layerWidth, layerWidth);
            UIImage * image = [UIImage imageNamed:imageName];
            layer.contents = (__bridge id _Nullable)(image.CGImage);
            [self.orderLayer addSublayer:layer];
        }
//        if (candleModel.buyburned > 0) {
//            CGFloat layerWidth = smallWidth;
//            NSString * imageName = [NSString stringWithFormat:@"k%@",candleModel.buyburnedType];
//            if (candleModel.buyburnedCount > 50000) {
//
//                imageName = [NSString stringWithFormat:@"kL%@",candleModel.buyburnedType];
//            }
//            CAShapeLayer * layer = [CAShapeLayer layer];
//            layer.frame = CGRectMake(model.buyburnedPoint.x + _candleWidth * 0.5 - layerWidth * 0.5, model.buyburnedPoint.y - layerWidth * 0.5, layerWidth, layerWidth);
//            UIImage * image = [UIImage imageNamed:imageName];
//            layer.contents = (__bridge id _Nullable)(image.CGImage);
//            [self.orderLayer addSublayer:layer];
//        }
        
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
    for (NSInteger i = 0 ; i < self.orderLayer.sublayers.count; i++)
    {
        id layer = self.orderLayer.sublayers[i];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [layer removeFromSuperlayer];
        layer = nil;
        [CATransaction commit];
    }
    
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
    
    for (int index = 0; index < self.currentPostionArray.count; index ++) {
        NSInteger idx = (self.currentPostionArray.count - 1- index);
        ZTYCandlePosionModel *model = [self.currentPostionArray objectAtIndex:idx];
        ZTYChartModel * candeModel = [self.currentDisplayArray objectAtIndex:idx];
        [self showOrder:model candleModel:candeModel];
        
    }
}


- (void)calcuteBollLinePostion{
    //    [self.maPostionArray removeAllObjects];
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
    
    //    [self.maPostionArray addObject:upArray];
    //    [self.maPostionArray addObject:dnArray];
    //    [self.maPostionArray addObject:mbArray];
}

// 画BOLL线
- (void)drawBollLineLayer{
    
    // ma5 up
    // ma10 dn
    // ma30 mb
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

// 画所有sar
- (void)drawSARSublayers
{
    
    self.ma10LineLayer.hidden = YES;
    self.ma25LineLayer.hidden = YES;
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

- (void)drawStranceSublayers{
    
    UIBezierPath * strance1Path = [UIBezierPath drawStrenceLine:self.currentPostionArray withKey:@"strance1Point"];
    UIBezierPath * strance2Path = [UIBezierPath drawStrenceLine:self.currentPostionArray withKey:@"strance2Point"];
    //    UIBezierPath * strance3Path = [UIBezierPath drawStrenceLine:self.currentPostionArray withKey:@"strance3Point"];
    //    UIBezierPath * strance4Path = [UIBezierPath drawStrenceLine:self.currentPostionArray withKey:@"strance4Point"];
    
    self.ma5LineLayer.path = strance1Path.CGPath;
    self.ma5LineLayer.strokeColor = [UIColor colorWithHexString:@"CC1414"].CGColor;
    self.ma5LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma5LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    self.ma10LineLayer.path = strance2Path.CGPath;
    self.ma10LineLayer.strokeColor = [UIColor colorWithHexString:@"29AC4E"].CGColor;
    self.ma10LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma10LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [self.ma25LineLayer removeFromSuperlayer];
    self.ma25LineLayer = nil;
    //    self.ma25LineLayer.path = strance3Path.CGPath;
    //    self.ma25LineLayer.strokeColor = [UIColor colorWithHexString:@"2DB52D"].CGColor;
    //    self.ma25LineLayer.fillColor = [[UIColor clearColor] CGColor];
    //    self.ma25LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    //    self.stranceLayer.path = strance4Path.CGPath;
    //    self.stranceLayer.strokeColor = [UIColor colorWithHexString:@"2DB52D"].CGColor;
    //    self.stranceLayer.fillColor = [[UIColor clearColor] CGColor];
    //    self.stranceLayer.contentsScale = [UIScreen mainScreen].scale;
    
}
// 横线
- (void)drawAxisLine
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
    //    NSLog(@"*******************start");
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
    
    [self drawAxisLine]; // 画横线
    [self drawlayer];
   
    [CATransaction commit];
    
}

- (void)calculateMaxAndMinValue{
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    double maxPrice = CGFLOAT_MIN;
    double minPrice = CGFLOAT_MAX;
    NSUInteger index = 0;
    for (ZTYChartModel * model in self.currentDisplayArray) {
        switch (self.mainchartType) {
            case MainChartcenterViewTypeTimeLine:
                // 选择分时
                if (self.minY > model.close) {
                    self.minY = model.close;
                }
                
                if (self.maxY < model.close) {
                    self.maxY = model.close;
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
                break;
        }
        
        switch (self.mainquotaName) {
            case MainViewQuotaNameWithBOLL:
                if ([_dataArray indexOfObject:model] > 19) {
                    self.minY = self.minY < model.BOLL_MB.floatValue ? self.minY : model.BOLL_MB.floatValue;
                    self.maxY = self.maxY > model.BOLL_MB.floatValue ? self.maxY : model.BOLL_MB.floatValue;
                    
                    self.minY = self.minY < model.BOLL_DN.floatValue ? self.minY : model.BOLL_DN.floatValue;
                    self.maxY = self.maxY > model.BOLL_DN.floatValue ? self.maxY : model.BOLL_DN.floatValue;
                    
                    self.minY = self.minY < model.BOLL_UP.floatValue ? self.minY : model.BOLL_UP.floatValue;
                    self.maxY = self.maxY > model.BOLL_UP.floatValue ? self.maxY : model.BOLL_UP.floatValue;
                    
                }
                break;
            case MainViewQuotaNameWithMA:
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
                break;
            case MainViewQuotaNameWithEMA:
                if ([_dataArray indexOfObject:model] >= 6) {
                    self.minY = self.minY < model.EMA7.floatValue ? self.minY : model.EMA7.floatValue;
                    self.maxY = self.maxY > model.EMA7.floatValue ? self.maxY : model.EMA7.floatValue;
                }
                
                if ([_dataArray indexOfObject:model] >= 29) {
                    self.minY = self.minY < model.EMA30.floatValue ? self.minY : model.EMA30.floatValue;
                    self.maxY = self.maxY > model.EMA30.floatValue ? self.maxY : model.EMA30.floatValue;
                }
                break;
            case MainViewQuotaNameWithSAR:
                if ([_dataArray indexOfObject:model] > 19) {
                    self.minY = self.minY < model.ParOpen ? self.minY : model.ParOpen;
                    self.maxY = self.maxY > model.ParOpen ? self.maxY : model.ParOpen;
                }
                break;
            case MainViewQuotaNameWithSTRANCE:
                if (model.sellPrice5 > 0) {
                    self.minY = self.minY < model.sellPrice5 ? self.minY : model.sellPrice5;
                    self.maxY = self.maxY > model.sellPrice5 ? self.maxY : model.sellPrice5;
                }
                
                if (model.buyPrice5 > 0) {
                    self.minY = self.minY < model.buyPrice5 ? self.minY : model.buyPrice5;
                    self.maxY = self.maxY > model.buyPrice5 ? self.maxY : model.buyPrice5;
                }
                
                break;
            default:
                break;
        }
        
        if (self.showOrder) {
            if (model.support > 0 && self.minY > model.support) {
                self.minY = model.support;
            }
            if (model.support > 0 && self.maxY < model.support) {
                self.maxY = model.support;
            }
            
            if (model.resistance > 0 && self.minY > model.resistance) {
                self.minY = model.resistance;
            }
            if (model.resistance > 0 && self.maxY < model.resistance) {
                self.maxY = model.resistance;
            }
            if (model.buyburned > 0 &&self.minY > model.buyburned) {
                self.minY = model.buyburned;
            }
            if (model.buyburned > 0 &&self.maxY < model.buyburned){
                self.maxY = model.buyburned;
            }
            if (model.sellburned > 0 &&self.minY > model.sellburned) {
                self.minY = model.sellburned;
            }
            if (model.sellburned > 0 &&self.maxY < model.sellburned){
                self.maxY = model.sellburned;
            }
        }
        
        
        index ++;
    }
    
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight) / (self.maxY - self.minY);
}



- (void)calculatePosion{
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
    
    [self removeAllQuotaLayer];
    if (self.mainquotaName == MainViewQuotaNameWithBOLL) {
        [self drawBollLineLayer]; // 画均线BOLL
        
    }else if (self.mainquotaName == MainViewQuotaNameWithMA){
        
        [self drawMALineLayer]; // 画均线MA
    }else if (self.mainquotaName == MainViewQuotaNameWithEMA){
        [self drawEMALineLayer];
    }else if(self.mainquotaName == MainViewQuotaNameWithSAR){
        [self drawSARSublayers];
    }else if(self.mainquotaName == MainViewQuotaNameWithSTRANCE){
        [self drawStranceSublayers];
    }else{
        
    }
}


- (void)removeAllQuotaLayer{
    
    //    [self.maPostionArray removeAllObjects];
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
    }
    self.ma10LineLayer.hidden = NO;
    self.ma25LineLayer.hidden = NO;
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
    NSLog(@"currentStartIndex==>%ld--dataArray===>%ld",self.currentStartIndex,self.dataArray.count);
    CGFloat prevContentOffset = (self.currentStartIndex) * self.candleWidth + (self.currentStartIndex - 1) * self.candleSpace + self.leftMargin;
    CGFloat klineWidth = self.dataArray.count*(self.candleWidth) + (self.dataArray.count - 1) *self.candleSpace + self.leftMargin + self.rightMargin;
    if(klineWidth < self.superScrollView.width)
    {
        klineWidth = self.superScrollView.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    NSLog(@"klineWidth===>%f---prevContentOffset===>%f",klineWidth,prevContentOffset);
    self.superScrollView.contentSize = CGSizeMake(klineWidth,0);
    self.superScrollView.contentOffset = CGPointMake(prevContentOffset,0);
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(longPressCandleViewWithIndex:kLineModel:startIndex:)])
            {
                [self.delegate longPressCandleViewWithIndex:index kLineModel:self.currentDisplayArray[index] startIndex:_currentStartIndex];
            }
            
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(tapCandleViewWithIndex:kLineModel:startIndex:price:)])
            {
                
                ZTYChartModel * candleModel = self.currentDisplayArray[index];
                [self.delegate tapCandleViewWithIndex:index kLineModel:candleModel startIndex:_currentStartIndex price:price];
                
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

#pragma mark setter

- (CAShapeLayer *)klineLayer{
    if (!_klineLayer) {
        _klineLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_klineLayer];
    }
    return _klineLayer;
}

- (CAShapeLayer *)ma5LineLayer{
    if (!_ma5LineLayer) {
        _ma5LineLayer = [CAShapeLayer layer];
        _ma5LineLayer.lineWidth = self.lineWidth;
        _ma5LineLayer.lineCap = kCALineCapRound;
        _ma5LineLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_ma5LineLayer];
    }
    return _ma5LineLayer;
}

- (CAShapeLayer *)ma10LineLayer{
    if (!_ma10LineLayer) {
        _ma10LineLayer = [CAShapeLayer layer];
        _ma10LineLayer.lineWidth = self.lineWidth;
        _ma10LineLayer.lineCap = kCALineCapRound;
        _ma10LineLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_ma10LineLayer];
    }
    return _ma10LineLayer;
}

- (CAShapeLayer *)ma25LineLayer{
    if (!_ma25LineLayer) {
        _ma25LineLayer = [CAShapeLayer layer];
        _ma25LineLayer.lineWidth = self.lineWidth;
        _ma25LineLayer.lineCap = kCALineCapRound;
        _ma25LineLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_ma25LineLayer];
    }
    return _ma25LineLayer;
}

- (CAShapeLayer *)timeLineLayer{
    if (!_timeLineLayer) {
        _timeLineLayer = [CAShapeLayer layer];
        _timeLineLayer.lineWidth = self.lineWidth;
        _timeLineLayer.lineCap = kCALineCapRound;
        _timeLineLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_timeLineLayer];
    }
    return _timeLineLayer;
}
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

- (CAShapeLayer *)timeLayer{
    if (!_timeLayer) {
        _timeLayer =  [CAShapeLayer layer];
        [self.layer addSublayer:_timeLayer];
    }
    return _timeLayer;
}

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
