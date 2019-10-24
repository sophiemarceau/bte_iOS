//
//  ZTYQuoteChartView.m
//  BTE
//
//  Created by wanmeizty on 2018/7/5.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYQuoteChartView.h"
#import "ZTYCandlePosionModel.h"
#import "ZTYChartModel.h"

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZTYQuoteChartView()

@property (nonatomic,strong) NSMutableArray *displayArray;

@property (nonatomic,strong) NSMutableArray * currentPosionArray;

@property (nonatomic,strong) CAShapeLayer   *macdLayer;

@property (nonatomic,strong) CAShapeLayer   *macdLineLayer;
@property (nonatomic,strong) CAShapeLayer   *deaLineLayer;
@property (nonatomic,strong) CAShapeLayer   *diffLineLayer;

@property (nonatomic,strong) CAShapeLayer * timerLineLayer;

@property (nonatomic,assign) CGFloat timeLayerHeight;
@end

@implementation ZTYQuoteChartView

- (void)calcuteMACDMaxAndMinValue
{
    
    self.minY = CGFLOAT_MAX;
    self.maxY = CGFLOAT_MIN;
    if (self.quotaName == FigureViewQuotaNameWithMACD) {
        for (ZTYChartModel *  macdData in self.displayArray) {
            self.minY = self.minY < macdData.DEA.doubleValue ? self.minY : macdData.DEA.doubleValue;
            self.minY = self.minY < macdData.DIF.doubleValue ? self.minY : macdData.DIF.doubleValue;
            self.minY = self.minY < macdData.MACD.doubleValue ? self.minY : macdData.MACD.doubleValue;
            
            self.maxY = self.maxY > macdData.DEA.doubleValue ? self.maxY : macdData.DEA.doubleValue;
            self.maxY = self.maxY > macdData.DIF.doubleValue ? self.maxY : macdData.DIF.doubleValue;
            self.maxY = self.maxY > macdData.MACD.doubleValue ? self.maxY : macdData.MACD.doubleValue;
        }
    }else if(self.quotaName == FigureViewQuotaNameWithKDJ){
        
        for (ZTYChartModel *  model in self.displayArray) {
            self.minY = self.minY < model.KDJ_K.doubleValue ? self.minY : model.KDJ_K.doubleValue;
            self.maxY = self.maxY > model.KDJ_K.doubleValue ? self.maxY : model.KDJ_K.doubleValue;
            
            self.minY = self.minY < model.KDJ_D.doubleValue ? self.minY : model.KDJ_D.doubleValue;
            self.maxY = self.maxY > model.KDJ_D.doubleValue ? self.maxY : model.KDJ_D.doubleValue;
            
            self.minY = self.minY < model.KDJ_J.doubleValue ? self.minY : model.KDJ_J.doubleValue;
            self.maxY = self.maxY > model.KDJ_J.doubleValue ? self.maxY : model.KDJ_J.doubleValue;
        }
    }else if (self.quotaName == FigureViewQuotaNameWithRSI){
        
        for (ZTYChartModel *  lineData in self.displayArray) {
            if ([_dataArray indexOfObject:lineData] > 5) {
                CGFloat kvalue = [lineData.RSI_6 floatValue];
                self.minY = self.minY < kvalue ? self.minY : kvalue;
                self.maxY = self.maxY > kvalue ? self.maxY : kvalue;
            }
            
            if ([_dataArray indexOfObject:lineData] > 11) {
                CGFloat dvalue = [lineData.RSI_12 floatValue];
                self.minY = self.minY < dvalue ? self.minY : dvalue;
                self.maxY = self.maxY > dvalue ? self.maxY : dvalue;
            }
            
            if ([_dataArray indexOfObject:lineData] > 23) {
                CGFloat jvalue = [lineData.RSI_24 floatValue];
                self.minY = self.minY < jvalue ? self.minY : jvalue;
                self.maxY = self.maxY > jvalue ? self.maxY : jvalue;
            }
        }
    }
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight) / (self.maxY - self.minY);
}

-(void)calcuteQuotePosition{
    
    [self.currentPosionArray removeAllObjects];
    NSUInteger idx = 0;
    for (ZTYChartModel * model in self.displayArray) {
        
        CGFloat xPosition = self.leftPostion + ((self.candleSpace+self.candleWidth) * idx) + self.leftMargin;
        CGFloat yPosition = ABS((self.maxY - model.MACD.doubleValue)*self.scaleY) + self.topMargin;
        ZTYCandlePosionModel *candlePosionModel = [ZTYCandlePosionModel initQuotePositionWithCandleModel:model left:xPosition maxY:self.maxY scaleY:self.scaleY topMagin:self.topMargin];
        candlePosionModel.endPoint = CGPointMake(xPosition, yPosition);
        candlePosionModel.startPoint = CGPointMake(xPosition,self.maxY*self.scaleY + self.topMargin);
        candlePosionModel.superArrIndex = [self.dataArray indexOfObject:model];
        [self.currentPosionArray addObject:candlePosionModel];
        
        idx ++;
    }
}

// 画柱状图
- (CAShapeLayer*)drawMacdLayer:(ZTYCandlePosionModel*)model candleModel:(ZTYChartModel*)macdModel
{
    CGRect rect = CGRectZero;
    CGFloat y = self.maxY*self.scaleY + self.topMargin;
    if (macdModel.MACD.doubleValue > 0)
    {
        rect = CGRectMake(model.startPoint.x, model.endPoint.y, self.candleWidth, ABS(y - model.endPoint.y));
    }
    
    else
    {
        rect = CGRectMake(model.startPoint.x,y, self.candleWidth, ABS(model.endPoint.y - model.startPoint.y));
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    subLayer.path = path.CGPath;
    if (macdModel.MACD.doubleValue > 0)
    {
        subLayer.strokeColor = RoseColor.CGColor;
        subLayer.fillColor = RoseColor.CGColor;
    }
    else
    {
        subLayer.strokeColor = DropColor.CGColor;
        subLayer.fillColor = DropColor.CGColor;
    }
    return subLayer;
}

- (void)drawQuoteLine
{
    
    if (self.quotaName == FigureViewQuotaNameWithMACD) {
        [self initMACDLayer];
        NSUInteger idx = 0;
        for (ZTYCandlePosionModel* obj in self.currentPosionArray) {
            ZTYChartModel *model = self.displayArray[idx];
            CAShapeLayer *layer = [self drawMacdLayer:obj candleModel:model];
            [self.macdLayer addSublayer:layer];
            idx ++;
        }
        
//        UIBezierPath *deaPath = [UIBezierPath drawLine:self.deaArray];
        UIBezierPath * deaPath = [UIBezierPath drawcandlePosionLine:self.currentPosionArray withKey:@"deaPoint" dayCount:0];
        CAShapeLayer *deaLayer = [CAShapeLayer layer];
        deaLayer.path = deaPath.CGPath;
        deaLayer.strokeColor = [UIColor colorWithHexString:@"F0BC79"].CGColor;
        deaLayer.fillColor = [[UIColor clearColor] CGColor];
        deaLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.macdLayer addSublayer:deaLayer];
        
//        UIBezierPath *diffPath = [UIBezierPath drawLine:self.diffArray];
        UIBezierPath * diffPath = [UIBezierPath drawcandlePosionLine:self.currentPosionArray withKey:@"difPoint" dayCount:0];
        CAShapeLayer *diffLayer = [CAShapeLayer layer];
        diffLayer.path = diffPath.CGPath;
        diffLayer.strokeColor = [UIColor colorWithHexString:@"ACD2E5"].CGColor;
        diffLayer.fillColor = [[UIColor clearColor] CGColor];
        diffLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.macdLayer addSublayer:diffLayer];
    }else if(self.quotaName == FigureViewQuotaNameWithKDJ){
        
        // self.macdArray K
        // self.diffArray D
        // self.deaArray J
       
        [self initMacdDiffDeaLineLayer];
        UIColor * macdColor = [UIColor colorWithHexString:@"B2DBEF"];
        UIColor * diffColor = [UIColor colorWithHexString:@"FDC071"];
        UIColor * deacolor = [UIColor colorWithHexString:@"EA9BEA"];
        
        UIBezierPath *macdPath = [UIBezierPath drawcandlePosionLine:self.currentPosionArray withKey:@"kPoint" dayCount:9];//[UIBezierPath drawLine:self.macdArray];
        UIBezierPath *diffPath = [UIBezierPath drawcandlePosionLine:self.currentPosionArray withKey:@"dPoint" dayCount:9];//[UIBezierPath drawLine:self.diffArray];
        UIBezierPath *deaPath = [UIBezierPath drawcandlePosionLine:self.currentPosionArray withKey:@"jPoint" dayCount:9];//[UIBezierPath drawLine:self.deaArray];
        
        self.macdLineLayer.path = macdPath.CGPath;
        self.macdLineLayer.strokeColor = macdColor.CGColor;
        self.macdLineLayer.fillColor = [[UIColor clearColor] CGColor];
        self.macdLineLayer.contentsScale = [UIScreen mainScreen].scale;
        
        
        self.diffLineLayer.path = diffPath.CGPath;
        self.diffLineLayer.strokeColor = diffColor.CGColor;
        self.diffLineLayer.fillColor = [[UIColor clearColor] CGColor];
        self.diffLineLayer.contentsScale = [UIScreen mainScreen].scale;
        
        
        self.deaLineLayer.path = deaPath.CGPath;
        self.deaLineLayer.strokeColor = deacolor.CGColor;
        self.deaLineLayer.fillColor = [[UIColor clearColor] CGColor];
        self.deaLineLayer.contentsScale = [UIScreen mainScreen].scale;
//        [self drawMacdcolor:macdColor diffColor:diffColor deaColor:deacolor];
        
    }else if (self.quotaName == FigureViewQuotaNameWithRSI){
        
        // self.macdArray RSI6
        // self.diffArray RSI12
        // self.deaArray RSI24
        [self initMacdDiffDeaLineLayer];
        UIColor * macdColor = [UIColor colorWithHexString:@"62BEA7"];
        UIColor * diffColor = [UIColor colorWithHexString:@"CFB85B"];
        UIColor * deacolor = [UIColor colorWithHexString:@"C24EA9"];
        
        
        UIBezierPath *macdPath = [UIBezierPath drawcandlePosionLine:self.currentPosionArray withKey:@"rsi6Point" dayCount:6];//[UIBezierPath drawLine:self.macdArray];
        UIBezierPath *diffPath = [UIBezierPath drawcandlePosionLine:self.currentPosionArray withKey:@"rsi12Point" dayCount:12];//[UIBezierPath drawLine:self.diffArray];
        UIBezierPath *deaPath = [UIBezierPath drawcandlePosionLine:self.currentPosionArray withKey:@"rsi24Point" dayCount:24];//[UIBezierPath drawLine:self.deaArray];
        
        self.macdLineLayer.path = macdPath.CGPath;
        self.macdLineLayer.strokeColor = macdColor.CGColor;
        self.macdLineLayer.fillColor = [[UIColor clearColor] CGColor];
        self.macdLineLayer.contentsScale = [UIScreen mainScreen].scale;
        
        
        self.diffLineLayer.path = diffPath.CGPath;
        self.diffLineLayer.strokeColor = diffColor.CGColor;
        self.diffLineLayer.fillColor = [[UIColor clearColor] CGColor];
        self.diffLineLayer.contentsScale = [UIScreen mainScreen].scale;
        
        
        self.deaLineLayer.path = deaPath.CGPath;
        self.deaLineLayer.strokeColor = deacolor.CGColor;
        self.deaLineLayer.fillColor = [[UIColor clearColor] CGColor];
        self.deaLineLayer.contentsScale = [UIScreen mainScreen].scale;
//        [self drawMacdcolor:macdColor diffColor:diffColor deaColor:deacolor];
    }
}

- (void)removeFromSubLayer
{
    for (NSInteger i = 0 ; i < self.macdLayer.sublayers.count; i++)
    {
        CAShapeLayer *layer = (CAShapeLayer*)self.macdLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    [self.macdLayer removeFromSuperlayer];
    self.macdLayer = nil;
    
    for (NSInteger i = 0 ; i < self.timerLineLayer.sublayers.count; i++)
    {
        CAShapeLayer *layer = (CAShapeLayer*)self.timerLineLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    [self.timerLineLayer removeFromSuperlayer];
    self.timerLineLayer = nil;
    
    if (!self.timerLineLayer.sublayers.count)
    {
        [self.layer addSublayer:self.timerLineLayer];
    }
    
    if (self.macdLineLayer) {
        [self.macdLineLayer removeFromSuperlayer];
        self.macdLineLayer = nil;
    }
    
    if (self.diffLineLayer) {
        [self.diffLineLayer removeFromSuperlayer];
        self.diffLineLayer = nil;
    }
    
    
    if (self.deaLineLayer) {
        [self.deaLineLayer removeFromSuperlayer];
        self.deaLineLayer = nil;
    }
}

- (void)removeAllObjectFromArray
{
    if (self.displayArray.count>0)
    {
        [self.displayArray removeAllObjects];
    }
}

- (void)initMACDLayer
{
    if (!self.macdLayer.sublayers.count)
    {
        [self.layer addSublayer:self.macdLayer];
    }
}

- (void)initMacdDiffDeaLineLayer{
    
    //    if (!self.macdLineLayer) {
    [self.layer addSublayer:self.macdLineLayer];
    //    }
    //    if (!self.deaLineLayer) {
    [self.layer addSublayer:self.deaLineLayer];
    //    }
    //    if (!self.diffLineLayer) {
    [self.layer addSublayer:self.diffLineLayer];
    //    }
}

#pragma mark setter,getter

- (void)stockFill
{
    [self removeAllObjectFromArray];
    [self initConfig];
    
    if (_startIndex + _displayCount > _dataArray.count)
    {
        
        for (NSInteger idx = _startIndex; idx < _displayCount && idx < self.dataArray.count; idx ++) {
            ZTYChartModel * model = self.dataArray[idx];
            [self.displayArray addObject:model];
        }
    }
    
    else
    {
        [self.displayArray addObjectsFromArray:[self.dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount)]];
    }
    
    [self layoutIfNeeded];
    [self calcuteMACDMaxAndMinValue];
    [self calcuteQuotePosition];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self removeFromSubLayer];
    [self drawQuoteLine];
    [self drawTimeLine];
    [CATransaction commit];
}

- (void)drawTimeLine{
    if (self.dataArray.count == 0) return;
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    
    if (klineWidth < SCREEN_HEIGHT) {
        klineWidth = SCREEN_HEIGHT;
    }
    
    
    CAShapeLayer *bottomLayer = [self getAxispLayer];
    bottomLayer.lineWidth = self.lineWidth;
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0, self.height - self.timeLayerHeight)];
    [bpath addLineToPoint:CGPointMake(klineWidth, self.height - self.timeLayerHeight )];
    bpath.lineWidth = self.lineWidth;
    bottomLayer.path = bpath.CGPath;
    [self.timerLineLayer addSublayer:bottomLayer];
    
    [self.displayArray enumerateObjectsUsingBlock:^(ZTYChartModel *kLinemodel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (kLinemodel.isDrawDate) {
            CGFloat xposion = self.leftPostion+ ((self.candleWidth + self.candleSpace) * idx) + self.leftMargin;
            CATextLayer *layer = [self getTextLayer];
            layer.string = kLinemodel.date;
            if (isEqualZero(xposion))
            {
                layer.frame =  CGRectMake(0, self.height - self.timeLayerHeight, 60, self.timeLayerHeight);
            }
            
            else
            {
                layer.position = CGPointMake(xposion + self.candleWidth , self.height - self.timeLayerHeight/2.0 - self.bottomMargin/2.0);
                layer.bounds = CGRectMake(0, 0, 60, self.timeLayerHeight);
            }
            [self.timerLineLayer addSublayer:layer];
            
        }
    }];
    
    
}

- (void)initConfig{
    self.leftMargin = 2;
    self.rightMargin = 2;
    self.topMargin = 15;
    self.bottomMargin = 2;
    self.timeLayerHeight = 12;
}

-(CGPoint)getTapModelPostionWithPostion:(CGPoint)postion
{
    CGFloat localPostion = postion.x;
    NSInteger startIndex = (NSInteger)((localPostion - self.leftPostion) / (self.candleSpace + self.candleWidth));
    
    CGFloat ypoision = postion.y;
    
    CGFloat price = self.maxY - (ypoision - self.topMargin) / self.scaleY;
    
    NSInteger arrCount = self.currentPosionArray.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        ZTYCandlePosionModel * model = self.currentPosionArray[index];
        CGFloat minX = model.macdPoint.x- (self.candleSpace + self.candleWidth/2.0);
        CGFloat maxX =model.macdPoint.x + (self.candleSpace + self.candleWidth/2.0);
        
        if(localPostion > minX && localPostion < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(tapCandleViewWithIndex:kLineModel:startIndex:price:)])
            {
                [self.delegate tapCandleViewWithIndex:index kLineModel:self.displayArray[index] startIndex:_startIndex price:price];
            }
            
            return CGPointMake(model.macdPoint.x, model.macdPoint.y - self.topMargin);
        }
    }
    
    //最后一根线
    ZTYCandlePosionModel *lastPositionModel = self.currentPosionArray.lastObject;
    
    if (localPostion >= lastPositionModel.macdPoint.x)
    {
        return CGPointMake(lastPositionModel.macdPoint.x, lastPositionModel.macdPoint.y - self.topMargin);
    }
    
    //第一根线
    ZTYCandlePosionModel *firstPositionModel = self.currentPosionArray.firstObject;
    if (firstPositionModel.macdPoint.x >= localPostion)
    {
        return CGPointMake(firstPositionModel.macdPoint.x, firstPositionModel.macdPoint.y - self.topMargin);
    }
    
    return CGPointZero;
}

#pragma mark lazyLoad
- (NSMutableArray*)currentPosionArray
{
    if (!_currentPosionArray)
    {
        _currentPosionArray = [NSMutableArray array];
    }
    return _currentPosionArray;
}

- (NSMutableArray*)displayArray
{
    if (!_displayArray)
    {
        _displayArray = [NSMutableArray array];
    }
    return _displayArray;
}

- (CAShapeLayer*)macdLayer
{
    if (!_macdLayer)
    {
        _macdLayer = [self getCAShapeLayer];
    }
    return _macdLayer;
}

- (CAShapeLayer*)macdLineLayer
{
    if (!_macdLineLayer)
    {
        _macdLineLayer = [self getCAShapeLayer];
    }
    return _macdLineLayer;
}

- (CAShapeLayer*)diffLineLayer
{
    if (!_diffLineLayer)
    {
        _diffLineLayer = [self getCAShapeLayer];
    }
    return _diffLineLayer;
}

- (CAShapeLayer*)deaLineLayer
{
    if (!_deaLineLayer)
    {
        _deaLineLayer = [self getCAShapeLayer];
    }
    return _deaLineLayer;
}

- (CAShapeLayer*)timerLineLayer
{
    if (!_timerLineLayer)
    {
        _timerLineLayer = [self getCAShapeLayer];
    }
    return _timerLineLayer;
}

- (CAShapeLayer *)getCAShapeLayer{
    CAShapeLayer * cLayer = [CAShapeLayer layer];
    cLayer.lineWidth = KLineWidth;
    cLayer.strokeColor = [UIColor clearColor].CGColor;
    cLayer.fillColor = [UIColor clearColor].CGColor;
    return cLayer;
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

// text显示时间
- (CATextLayer*)getTextLayer
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = 10.f;
//    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    //set layer font
//    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
//    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
//    layer.font = fontRef;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end

