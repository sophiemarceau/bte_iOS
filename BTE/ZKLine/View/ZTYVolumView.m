//
//  ZTYVolumView.m
//  BTE
//
//  Created by wanmeizty on 2018/5/29.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYVolumView.h"

#import "ZTYCandlePosionModel.h"

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}
@interface ZTYVolumView()

@property (nonatomic,strong) NSMutableArray *displayArray;
@property (nonatomic,strong) NSMutableArray *macdArray;
@property (nonatomic,strong) CAShapeLayer   *macdLayer;

//@property (nonatomic,assign) double scaleSell;

@end

@implementation ZTYVolumView

- (void)calcuteMaxAndMinValue
{
    CGFloat maxPrice = CGFLOAT_MIN;
    CGFloat minPrice = CGFLOAT_MAX;
    
    for (ZTYChartModel *macdData in self.displayArray) {
        
        if (_showbuySell == 1) {
            minPrice = minPrice < macdData.volumn.integerValue ? minPrice : macdData.count;
            maxPrice = maxPrice > macdData.count ? maxPrice : macdData.count;
        
        }if (_showbuySell == 2) {
            double count = ABS(macdData.sellCount - macdData.buyCount);
            minPrice = 0;
            maxPrice = maxPrice > count ? maxPrice : count;
            
        }if (_showbuySell == 3) {
            
//            // 上 托单
//            maxPrice = maxPrice > macdData.supportCount ? maxPrice : macdData.supportCount;
//
//            // 压单
//            maxPrice = maxPrice > macdData.resistanceCount ? maxPrice : macdData.resistanceCount;
            
            NSInteger buyCount = macdData.supportCount - macdData.cancelbuyCount;
            
            if (buyCount > 0) {
                // 上 托单
                maxPrice = maxPrice > buyCount ? maxPrice : buyCount;
            }
            
            NSInteger sellCount = macdData.resistanceCount - macdData.cancelsellCount;
            if (sellCount > 0) {
                // 压单
                maxPrice = maxPrice > sellCount ? maxPrice : sellCount;
            }
            
            
        }else{
            minPrice = minPrice < macdData.volumn.floatValue ? minPrice : macdData.volumn.floatValue;
            maxPrice = maxPrice > macdData.volumn.floatValue ? maxPrice : macdData.volumn.floatValue;
        }
    }
    
    self.maxY = maxPrice;
    self.minY = minPrice;
    
    self.topMargin = 15;
    self.bottomMargin = 0;
    self.leftMargin = 2;
    self.rightMargin = 2;
    
    if (self.displayArray.count == 1) {
        self.minY = 0;
    }
    
    
    if (_showbuySell == 2){
        self.scaleY = (self.height - self.topMargin - self.bottomMargin) * 0.5 /(self.maxY - self.minY) ;
    }else if (_showbuySell == 3){
        self.scaleY = (self.height * 0.5 - self.topMargin - self.bottomMargin)  /(self.maxY - 0) ;
    }else{
        self.scaleY = (self.height - self.topMargin - self.bottomMargin) /(self.maxY - self.minY) ;
    }
    
    
    
}

- (void)calMaModelPosition
{
    NSUInteger idx = 0;
    for (ZTYChartModel *lineData in self.displayArray) {
        CGFloat xPosition = self.leftPostion + ((self.candleSpace+self.candleWidth) * idx) + self.leftMargin;
        
        CGFloat yPosition = ABS((self.maxY - lineData.volumn.doubleValue)*self.scaleY) +self.topMargin;
        //macd
        ZTYCandlePosionModel *model = [[ZTYCandlePosionModel alloc] init];
        model.endPoint = CGPointMake(xPosition, yPosition);
        model.startPoint = CGPointMake(xPosition,self.maxY*self.scaleY);
        
        float x = model.startPoint.y - model.endPoint.y;
        if (isEqualZero(x))
        {
            //柱线的最小高度
            model.endPoint = CGPointMake(xPosition,self.maxY*self.scaleY+1);
        }
        [self.macdArray addObject:model];
        idx ++;
    }
}

- (CAShapeLayer*)drawMacdLayer:(ZTYCandlePosionModel*)model candleModel:(ZTYChartModel*)macdModel
{
    CGRect rect = CGRectZero;
    CGFloat y = self.height;
    rect = CGRectMake(model.startPoint.x, model.endPoint.y, self.candleWidth, ABS(y - model.endPoint.y));
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    subLayer.path = path.CGPath;
    if (macdModel.open - macdModel.close < 0)
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

- (void)drawLine
{
    
    NSUInteger idx = 0;
    for (ZTYCandlePosionModel* obj in _macdArray) {
        ZTYChartModel *model = self.displayArray[idx];
        [self addCandleLayer:obj candleModel:model];
//        CAShapeLayer *layer = [self drawMacdLayer:obj candleModel:model];
//        [self.macdLayer addSublayer:layer];
        idx ++;
    }
    
}

- (void)addCandleLayer:(ZTYCandlePosionModel*)model candleModel:(ZTYChartModel*)candleModel{
    if (_showbuySell == 1) {
        CGFloat endY = self.height;
     
        CGFloat percentBuy = candleModel.buyCount / (candleModel.count * 1.0);
    
        CGFloat allY = ABS((self.maxY - candleModel.count)*self.scaleY) + self.topMargin;
        
        CGFloat allH = ABS(endY - allY);
        
        CGFloat buyH = allH * percentBuy;
        
        CGFloat sellH = allH - buyH;
        CGRect buyFrame = CGRectMake(model.startPoint.x, allY , self.candleWidth, buyH);
        
        CGRect sellFrame = CGRectMake(model.startPoint.x, allY + buyH, self.candleWidth, sellH);
        
        UIBezierPath *sellpath = [UIBezierPath bezierPathWithRect:sellFrame];
        CAShapeLayer *sellLayer = [CAShapeLayer layer];
        sellLayer.path = sellpath.CGPath;
        sellLayer.strokeColor = DropColor.CGColor;
        sellLayer.fillColor = DropColor.CGColor;
        [self.macdLayer addSublayer:sellLayer];
        
        UIBezierPath *buyPath = [UIBezierPath bezierPathWithRect:buyFrame];
        CAShapeLayer *buyLayer = [CAShapeLayer layer];
        buyLayer.path = buyPath.CGPath;
        buyLayer.strokeColor = RoseColor.CGColor;
        buyLayer.fillColor = RoseColor.CGColor;
        [self.macdLayer addSublayer:buyLayer];
        
        
    }
    if (_showbuySell == 2) {
        CGFloat endY = self.height;
        UIColor * color;
        CGRect sellFrame = CGRectZero;
        if (candleModel.buyCount < candleModel.sellCount) {
            double count = candleModel.buyCount - candleModel.sellCount;
            double buyH = count * self.scaleY;
            sellFrame = CGRectMake(model.startPoint.x, endY * 0.5 - buyH, self.candleWidth, buyH);
            color = DropColor;
            
            
        }else{
            double count = candleModel.sellCount - candleModel.buyCount;
            double sellH = count * self.scaleY;
            sellFrame = CGRectMake(model.startPoint.x, endY * 0.5, self.candleWidth, sellH);
            color = RoseColor;
        }
        
        
        UIBezierPath *sellpath = [UIBezierPath bezierPathWithRect:sellFrame];
        CAShapeLayer *sellLayer = [CAShapeLayer layer];
        sellLayer.path = sellpath.CGPath;
        sellLayer.strokeColor = color.CGColor;
        sellLayer.fillColor = color.CGColor;
        [self.macdLayer addSublayer:sellLayer];
        
       
        
        
    }if (_showbuySell == 3) {
        
//        // 上 托单
//        CGFloat endY = self.height;
//
//        double count = candleModel.supportCount;
//        double buyH = count * self.scaleY;
//        CGRect buyFrame = CGRectMake(model.startPoint.x, endY * 0.5 - buyH, self.candleWidth, buyH);
//        UIBezierPath *buypath = [UIBezierPath bezierPathWithRect:buyFrame];
//        CAShapeLayer *buyLayer = [CAShapeLayer layer];
//        buyLayer.path = buypath.CGPath;
//        buyLayer.strokeColor = RoseColor.CGColor;
//        buyLayer.fillColor = RoseColor.CGColor;
//        [self.macdLayer addSublayer:buyLayer];
//
//
//        double sellcount = candleModel.resistanceCount;
//        double sellH = sellcount * self.scaleY;
//        CGRect sellFrame = CGRectMake(model.startPoint.x, endY * 0.5, self.candleWidth, sellH);
//        UIBezierPath *sellpath = [UIBezierPath bezierPathWithRect:sellFrame];
//        CAShapeLayer *sellLayer = [CAShapeLayer layer];
//        sellLayer.path = sellpath.CGPath;
//        sellLayer.strokeColor = DropColor.CGColor;
//        sellLayer.fillColor = DropColor.CGColor;
//        [self.macdLayer addSublayer:sellLayer];

        // 上 托单
        CGFloat endY = self.height;
        
        double count = candleModel.supportCount - candleModel.cancelbuyCount;
        if (count > 0) {
            double buyH = count * self.scaleY;
            CGRect buyFrame = CGRectMake(model.startPoint.x, endY * 0.5 - buyH, self.candleWidth, buyH);
            UIBezierPath *buypath = [UIBezierPath bezierPathWithRect:buyFrame];
            CAShapeLayer *buyLayer = [CAShapeLayer layer];
            buyLayer.path = buypath.CGPath;
            buyLayer.strokeColor = RoseColor.CGColor;
            buyLayer.fillColor = RoseColor.CGColor;
            [self.macdLayer addSublayer:buyLayer];
        }
        
        
        double sellcount = candleModel.resistanceCount - candleModel.cancelsellCount;
        if (sellcount > 0) {
            double sellH = sellcount * self.scaleY;
            CGRect sellFrame = CGRectMake(model.startPoint.x, endY * 0.5, self.candleWidth, sellH);
            UIBezierPath *sellpath = [UIBezierPath bezierPathWithRect:sellFrame];
            CAShapeLayer *sellLayer = [CAShapeLayer layer];
            sellLayer.path = sellpath.CGPath;
            sellLayer.strokeColor = DropColor.CGColor;
            sellLayer.fillColor = DropColor.CGColor;
            [self.macdLayer addSublayer:sellLayer];
        }
        
    }else{
        CGRect rect = CGRectZero;
        CGFloat y = self.height;
        rect = CGRectMake(model.startPoint.x, model.endPoint.y, self.candleWidth, ABS(y - model.endPoint.y));
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        CAShapeLayer *subLayer = [CAShapeLayer layer];
        subLayer.path = path.CGPath;
        if (candleModel.open - candleModel.close < 0)
        {
            subLayer.strokeColor = RoseColor.CGColor;
            subLayer.fillColor = RoseColor.CGColor;
        }
        else
        {
            subLayer.strokeColor = DropColor.CGColor;
            subLayer.fillColor = DropColor.CGColor;
        }
        [self.macdLayer addSublayer:subLayer];
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
}

- (void)removeAllObjectFromArray
{
    if (self.displayArray.count>0)
    {
        [self.displayArray removeAllObjects];
        [self.macdArray removeAllObjects];
    }
}

- (void)initLayer
{
    if (!self.macdLayer.sublayers.count)
    {
        [self.layer addSublayer:self.macdLayer];
    }
}

#pragma mark setter,getter

- (void)stockFill
{
    [self removeAllObjectFromArray];
    if (self.dataArray.count ==0) {
        [self removeFromSubLayer];
        return;
    }
    if (self.displayCount > self.dataArray.count) {
        self.displayCount = self.dataArray.count;
    }
    
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
    [self calcuteMaxAndMinValue];
    [self calMaModelPosition];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self removeFromSubLayer];
    [self initLayer];
    [self addAcrossLine];
    [self drawLine];
    [CATransaction commit];
}

- (void)addAcrossLine{
    CGFloat endY = self.height;
    
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    
    
    if (klineWidth < SCREEN_WIDTH || klineWidth < SCREEN_HEIGHT) {
        klineWidth = SCREEN_HEIGHT;
    }
    CAShapeLayer *centXLayer = [self getAxispLayer];
    centXLayer.strokeColor = GradeBGColor.CGColor;
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:CGPointMake(0,endY * 0.5)];
    [xPath addLineToPoint:CGPointMake(klineWidth,endY * 0.5)];
    centXLayer.path = xPath.CGPath;
    centXLayer.lineWidth = BoxborderWidth;//self.lineWidth;
    [self.macdLayer addSublayer:centXLayer];
}

- (CAShapeLayer*)getAxispLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"E5E5EE"].CGColor;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

- (void)drawAxisLine
{
    if (_dataArray.count == 0) return;
    CGFloat klineWidth = self.leftPostion + ((self.candleSpace+self.candleWidth) * _dataArray.count) + self.leftMargin;
    if (ISShowTimeLine == 1) {
        CGFloat lineHeigth = 0;
        while (lineHeigth <= self.height) {
            CAShapeLayer *centXLayer = [self getAxispLayer];
            UIBezierPath *xPath = [UIBezierPath bezierPath];
            [xPath moveToPoint:CGPointMake(0,lineHeigth)];
            [xPath addLineToPoint:CGPointMake(klineWidth,lineHeigth)];
            CGFloat dashPattern[] = {3,1};// 3实线，1空白
            [xPath setLineDash:dashPattern count:1 phase:1];
            centXLayer.path = xPath.CGPath;
            centXLayer.lineWidth = self.lineWidth;
            [self.macdLayer addSublayer:centXLayer];
            lineHeigth += 41;
        }
    }else if(ISShowTimeLine == 2){
        CAShapeLayer *centXLayer = [self getAxispLayer];
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(0,0)];
        [xPath addLineToPoint:CGPointMake(klineWidth,0)];
        CGFloat dashPattern[] = {3,1};// 3实线，1空白
        [xPath setLineDash:dashPattern count:1 phase:1];
        centXLayer.path = xPath.CGPath;
        centXLayer.lineWidth = self.lineWidth;
        [self.macdLayer addSublayer:centXLayer];
        
        CAShapeLayer *centXLayer2 = [self getAxispLayer];
        UIBezierPath *xPath2 = [UIBezierPath bezierPath];
        [xPath2 moveToPoint:CGPointMake(0,self.height-1 - self.bottomMargin/2)];
        [xPath2 addLineToPoint:CGPointMake(klineWidth,self.height-1 - self.bottomMargin/2)];
        [xPath2 setLineDash:dashPattern count:1 phase:1];
        centXLayer2.path = xPath2.CGPath;
        centXLayer2.lineWidth = self.lineWidth;
        [self.macdLayer addSublayer:centXLayer2];
    }
}

-(CGPoint)getTapModelPostionWithPostion:(CGPoint)postion
{
    CGFloat localPostion = postion.x;
    NSInteger startIndex = (NSInteger)((localPostion - self.leftPostion) / (self.candleSpace + self.candleWidth));
    
    
    CGFloat ypoision = postion.y;
    
    CGFloat price = self.maxY - (ypoision - self.topMargin) * self.scaleY;
    
    NSInteger arrCount = self.macdArray.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        ZTYCandlePosionModel * model = self.macdArray[index];
        CGFloat minX = model.startPoint.x- (self.candleSpace + self.candleWidth/2.0);
        CGFloat maxX = model.endPoint.x + (self.candleSpace + self.candleWidth/2.0);
        
        if(localPostion > minX && localPostion < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(tapCandleViewWithIndex:kLineModel:startIndex:price:)])
            {
                [self.delegate tapCandleViewWithIndex:index kLineModel:self.displayArray[index] startIndex:_startIndex price:price];
            }
            
            return CGPointMake(model.startPoint.x, model.startPoint.y - self.topMargin);
        }
    }
    
    //最后一根线
    ZTYCandlePosionModel *lastPositionModel = self.macdArray.lastObject;
    
    if (localPostion >= lastPositionModel.startPoint.x)
    {
        return CGPointMake(lastPositionModel.startPoint.x, lastPositionModel.startPoint.y - self.topMargin);
    }
    
    //第一根线
    ZTYCandlePosionModel *firstPositionModel = self.macdArray.firstObject;
    if (firstPositionModel.startPoint.x >= localPostion)
    {
        return CGPointMake(firstPositionModel.startPoint.x, firstPositionModel.startPoint.y - self.topMargin);
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
        _macdLayer = [CAShapeLayer layer];
        _macdLayer.lineWidth = _lineWidth;
        _macdLayer.strokeColor = [UIColor clearColor].CGColor;
        _macdLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _macdLayer;
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
