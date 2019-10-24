//
//  ZTYQuotaChartView.m
//  BTE
//
//  Created by wanmeizty on 2018/6/1.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYQuotaChartView.h"
#import "ZYWMacdPostionModel.h"
#import "ZYWLineModel.h"
#import "ZYWMacdModel.h"
#import "ZYWCalcuteTool.h"
//#import "ZYWCandleModel.h"
#import "ZTYCalCuteNumber.h"

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZTYQuotaChartView()

@property (nonatomic,strong) NSMutableArray *displayArray;
@property (nonatomic,strong) NSMutableArray *macdArray;
@property (nonatomic,strong) NSMutableArray *deaArray;
@property (nonatomic,strong) NSMutableArray *diffArray;
@property (nonatomic,strong) NSMutableArray * linePosionArray;

@property (nonatomic,strong) CAShapeLayer   *macdLayer;

@property (nonatomic,strong) CAShapeLayer   *macdLineLayer;
@property (nonatomic,strong) CAShapeLayer   *deaLineLayer;
@property (nonatomic,strong) CAShapeLayer   *diffLineLayer;

@property (nonatomic,strong) CAShapeLayer * timerLineLayer;

@property (nonatomic,assign) CGFloat timeLayerHeight;

@end

@implementation ZTYQuotaChartView

- (void)calcuteMACDMaxAndMinValue
{
    //    __block CGFloat maxPrice = CGFLOAT_MIN;
    //    __block CGFloat minPrice = CGFLOAT_MAX;
    self.minY = CGFLOAT_MAX;
    self.maxY = CGFLOAT_MIN;
    if (self.quotaName == FigureViewQuotaNameWithMACD) {
        [self.displayArray enumerateObjectsUsingBlock:^(ZTYChartModel *  macdData, NSUInteger idx, BOOL * _Nonnull stop) {
            
            self.minY = self.minY < macdData.DEA.doubleValue ? self.minY : macdData.DEA.doubleValue;
            self.minY = self.minY < macdData.DIF.doubleValue ? self.minY : macdData.DIF.doubleValue;
            self.minY = self.minY < macdData.MACD.doubleValue ? self.minY : macdData.MACD.doubleValue;
            
            self.maxY = self.maxY > macdData.DEA.doubleValue ? self.maxY : macdData.DEA.doubleValue;
            self.maxY = self.maxY > macdData.DIF.doubleValue ? self.maxY : macdData.DIF.doubleValue;
            self.maxY = self.maxY > macdData.MACD.doubleValue ? self.maxY : macdData.MACD.doubleValue;
        }];
    }else if(self.quotaName == FigureViewQuotaNameWithKDJ){
        [self.displayArray enumerateObjectsUsingBlock:^(ZTYChartModel *  model, NSUInteger idx, BOOL * _Nonnull stop) {
            self.minY = self.minY < model.KDJ_K.doubleValue ? self.minY : model.KDJ_K.doubleValue;
            self.maxY = self.maxY > model.KDJ_K.doubleValue ? self.maxY : model.KDJ_K.doubleValue;
            
            self.minY = self.minY < model.KDJ_D.doubleValue ? self.minY : model.KDJ_D.doubleValue;
            self.maxY = self.maxY > model.KDJ_D.doubleValue ? self.maxY : model.KDJ_D.doubleValue;
            
            self.minY = self.minY < model.KDJ_J.doubleValue ? self.minY : model.KDJ_J.doubleValue;
            self.maxY = self.maxY > model.KDJ_J.doubleValue ? self.maxY : model.KDJ_J.doubleValue;
            
        }];
    }else if (self.quotaName == FigureViewQuotaNameWithRSI){
        [self.displayArray enumerateObjectsUsingBlock:^(ZTYChartModel *  lineData, NSUInteger idx, BOOL * _Nonnull stop) {
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
            
        }];
    }
    
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight) / (self.maxY - self.minY);
}



- (void)calMACDModelPosition
{
    
    
    [self.macdArray removeAllObjects];
    [self.diffArray removeAllObjects];
    [self.deaArray removeAllObjects];
    [self.linePosionArray removeAllObjects];
    if (self.quotaName == FigureViewQuotaNameWithMACD) {
        [self.displayArray enumerateObjectsUsingBlock:^(ZTYChartModel * lineData, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat xPosition = self.leftPostion + ((self.candleSpace+self.candleWidth) * idx) + self.leftMargin;
            CGFloat yPosition = ABS((self.maxY - lineData.MACD.doubleValue)*self.scaleY) + self.topMargin ;
            
            //macd
            ZYWMacdPostionModel *model = [[ZYWMacdPostionModel alloc] init];
            model.endPoint = CGPointMake(xPosition, yPosition);
            model.startPoint = CGPointMake(xPosition,self.maxY*self.scaleY + self.topMargin);
            
            float x = model.startPoint.y - model.endPoint.y;
            if (isEqualZero(x))
            {
                //柱线的最小高度
                model.endPoint = CGPointMake(xPosition,self.maxY*self.scaleY+self.topMargin);
            }
            [self.macdArray addObject:model];
            
            //diff
            CGFloat diffPostion = ABS((self.maxY - lineData.DIF.doubleValue)*self.scaleY) +self.topMargin;
            ZYWLineModel *difModel = [ZYWLineModel initPositon:xPosition+self.candleWidth/2 yPosition:diffPostion color:[UIColor redColor]];
            [self.diffArray addObject:difModel];
            
            //dea
            CGFloat deayPostion = ABS((self.maxY - lineData.DEA.doubleValue)*self.scaleY) + self.topMargin;
            ZYWLineModel *deaModel = [ZYWLineModel initPositon:xPosition+self.candleWidth/2 yPosition:deayPostion color:[UIColor redColor]];
            [self.deaArray addObject:deaModel];
            
            ZYWLineModel * tapline = [ZYWLineModel initPositon:xPosition yPosition:yPosition color:[UIColor whiteColor]];
            [self.linePosionArray addObject:tapline];
            
        }];
    }else if(self.quotaName == FigureViewQuotaNameWithKDJ){
        
        // self.macdArray K
        // self.diffArray D
        // self.deaArray J
        [self.displayArray enumerateObjectsUsingBlock:^(ZTYChartModel *  model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2 + self.leftMargin;
            CGFloat ykPosition = ((self.maxY - model.KDJ_K.doubleValue) *self.scaleY) + self.topMargin;
            ZYWLineModel *kmodel = [ZYWLineModel  initPositon:xPosition yPosition:ykPosition color:[UIColor redColor]];
            [self.macdArray addObject:kmodel];
            
            CGFloat ydPosition = ((self.maxY - model.KDJ_D.doubleValue) *self.scaleY) + self.topMargin;
            ZYWLineModel *dmodel = [ZYWLineModel  initPositon:xPosition yPosition:ydPosition color:[UIColor redColor]];
            [self.diffArray addObject:dmodel];
            
            CGFloat yjPosition = ((self.maxY - model.KDJ_J.doubleValue) *self.scaleY) + self.topMargin;
            ZYWLineModel *jmodel = [ZYWLineModel  initPositon:xPosition yPosition:yjPosition color:[UIColor redColor]];
            [self.deaArray addObject:jmodel];
            
            
            ZYWLineModel * tapline = [ZYWLineModel initPositon:xPosition yPosition:ykPosition color:[UIColor whiteColor]];
            [self.linePosionArray addObject:tapline];
            
        }];
    }else if (self.quotaName == FigureViewQuotaNameWithRSI){
        
        // self.macdArray RSI6
        // self.diffArray RSI12
        // self.deaArray RSI24
        [self.displayArray enumerateObjectsUsingBlock:^(ZTYChartModel *  kLinemodel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([_dataArray indexOfObject:kLinemodel] > 5) {
                CGFloat kvalue = [kLinemodel.RSI_6 floatValue];
                CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2 + self.leftMargin;
                CGFloat yPosition = ((self.maxY - kvalue) *self.scaleY) + self.topMargin;
                ZYWLineModel *kmodel = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor redColor]];
                [self.macdArray addObject:kmodel];
            }
            
            if ([_dataArray indexOfObject:kLinemodel] > 11) {
                CGFloat dvalue = [kLinemodel.RSI_12 floatValue];
                CGFloat dxPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2 + self.leftMargin;
                CGFloat dyPosition = ((self.maxY - dvalue) *self.scaleY) + self.topMargin;
                ZYWLineModel *dmodel = [ZYWLineModel  initPositon:dxPosition yPosition:dyPosition color:[UIColor greenColor]];
                [self.diffArray addObject:dmodel];
            }
            
            
            
            if ([_dataArray indexOfObject:kLinemodel] > 23) {
                CGFloat jvalue = [kLinemodel.RSI_24 floatValue];
                CGFloat jxPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2 + self.leftMargin;
                CGFloat jyPosition = ((self.maxY - jvalue) *self.scaleY) + self.topMargin;
                ZYWLineModel *jmodel = [ZYWLineModel  initPositon:jxPosition yPosition:jyPosition color:[UIColor blueColor]];
                [self.deaArray addObject:jmodel];
            }
            
            CGFloat value = [kLinemodel.RSI_6 floatValue];
            CGFloat xvPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2 + self.leftMargin;
            CGFloat yvPosition = ((self.maxY - value) *self.scaleY) + self.topMargin;
            ZYWLineModel * tapline = [ZYWLineModel initPositon:xvPosition yPosition:yvPosition color:[UIColor whiteColor]];
            [self.linePosionArray addObject:tapline];
            
        }];
    }
    
}

// 画柱状图
- (CAShapeLayer*)drawMacdLayer:(ZYWMacdPostionModel*)model candleModel:(ZTYChartModel*)macdModel
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

- (void)drawMACDLine
{
    
    if (self.quotaName == FigureViewQuotaNameWithMACD) {
        [self initMACDLayer];
        __weak typeof(self) this = self;
        [_macdArray enumerateObjectsUsingBlock:^(ZYWMacdPostionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZTYChartModel *model = this.displayArray[idx];
            CAShapeLayer *layer = [this drawMacdLayer:obj candleModel:model];
            [this.macdLayer addSublayer:layer];
        }];
        
        UIBezierPath *deaPath = [UIBezierPath drawLine:self.deaArray];
        CAShapeLayer *deaLayer = [CAShapeLayer layer];
        deaLayer.path = deaPath.CGPath;
        deaLayer.strokeColor = [UIColor colorWithHexString:@"F0BC79"].CGColor;
        deaLayer.fillColor = [[UIColor clearColor] CGColor];
        deaLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.macdLayer addSublayer:deaLayer];
        
        UIBezierPath *diffPath = [UIBezierPath drawLine:self.diffArray];
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
        
        [self drawMacdcolor:macdColor diffColor:diffColor deaColor:deacolor];
        
    }else if (self.quotaName == FigureViewQuotaNameWithRSI){
        
        // self.macdArray RSI6
        // self.diffArray RSI12
        // self.deaArray RSI24
        
        [self initMacdDiffDeaLineLayer];
        UIColor * macdColor = [UIColor colorWithHexString:@"62BEA7"];
        UIColor * diffColor = [UIColor colorWithHexString:@"CFB85B"];
        UIColor * deacolor = [UIColor colorWithHexString:@"C24EA9"];
        
        [self drawMacdcolor:macdColor diffColor:diffColor deaColor:deacolor];
    }
}


// 绘制三条线
- (void)drawMacdcolor:(UIColor *)macdColor diffColor:(UIColor *)diffColor deaColor:(UIColor *)deaColor{
    
    UIBezierPath *macdPath = [UIBezierPath drawLine:self.macdArray];
    self.macdLineLayer.path = macdPath.CGPath;
    self.macdLineLayer.strokeColor = macdColor.CGColor;
    self.macdLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.macdLineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIBezierPath *diffPath = [UIBezierPath drawLine:self.diffArray];
    self.diffLineLayer.path = diffPath.CGPath;
    self.diffLineLayer.strokeColor = diffColor.CGColor;
    self.diffLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.diffLineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIBezierPath *deaPath = [UIBezierPath drawLine:self.deaArray];
    self.deaLineLayer.path = deaPath.CGPath;
    self.deaLineLayer.strokeColor = deaColor.CGColor;
    self.deaLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.deaLineLayer.contentsScale = [UIScreen mainScreen].scale;
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
        [self.macdArray removeAllObjects];
        [self.deaArray removeAllObjects];
        [self.diffArray removeAllObjects];
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
        if (_displayCount > self.dataArray.count) {
            
            [self.displayArray addObjectsFromArray:[self.dataArray subarrayWithRange:NSMakeRange(_startIndex, self.dataArray.count -1)]];
        }else{
            [self.displayArray addObjectsFromArray:[self.dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount - 1)]];
        }
    }
    
    else
    {
        [self.displayArray addObjectsFromArray:[self.dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount)]];
    }
    
    [self layoutIfNeeded];
    [self calcuteMACDMaxAndMinValue];
    [self calMACDModelPosition];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self removeFromSubLayer];
    
    [self drawMACDLine];
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
    
    //    NSArray *array = [_dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount)];
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
    
    NSInteger arrCount = self.linePosionArray.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        ZYWLineModel * model = self.linePosionArray[index];
        CGFloat minX = model.xPosition- (self.candleSpace + self.candleWidth/2);
        CGFloat maxX = model.xPosition + (self.candleSpace + self.candleWidth/2);
        
        if(localPostion > minX && localPostion < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(tapCandleViewWithIndex:kLineModel:startIndex:price:)])
            {
                [self.delegate tapCandleViewWithIndex:index kLineModel:self.dataArray[index] startIndex:_startIndex price:price];
            }
            
            return CGPointMake(model.xPosition, model.yPosition - self.topMargin);
        }
    }
    
    //最后一根线
    ZYWLineModel *lastPositionModel = self.linePosionArray.lastObject;
    
    if (localPostion >= lastPositionModel.xPosition)
    {
        return CGPointMake(lastPositionModel.xPosition, lastPositionModel.yPosition - self.topMargin);
    }
    
    //第一根线
    ZYWLineModel *firstPositionModel = self.linePosionArray.firstObject;
    if (firstPositionModel.xPosition >= localPostion)
    {
        return CGPointMake(firstPositionModel.xPosition, firstPositionModel.yPosition - self.topMargin);
    }
    
    return CGPointZero;
}

#pragma mark lazyLoad

- (NSMutableArray*)macdArray
{
    if (!_macdArray)
    {
        _macdArray = [NSMutableArray array];
    }
    return _macdArray;
}

- (NSMutableArray*)deaArray
{
    if (!_deaArray)
    {
        _deaArray = [NSMutableArray array];
    }
    return _deaArray;
}

- (NSMutableArray*)diffArray
{
    if (!_diffArray)
    {
        _diffArray = [NSMutableArray array];
    }
    return _diffArray;
}

- (NSMutableArray*)linePosionArray
{
    if (!_linePosionArray)
    {
        _linePosionArray = [NSMutableArray array];
    }
    return _linePosionArray;
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
//    //set layer font
//    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
//    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
//    layer.font = fontRef;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}

@end


