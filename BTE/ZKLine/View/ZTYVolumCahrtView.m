//
//  ZTYVolumCahrtView.m
//  BTE
//
//  Created by wanmeizty on 2018/5/30.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYVolumCahrtView.h"

#import "ZYWMacdPostionModel.h"
//#import "ZYWLineModel.h"

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZTYVolumCahrtView()

@property (nonatomic,strong) NSMutableArray *displayArray;
@property (nonatomic,strong) NSMutableArray *macdArray;
@property (nonatomic,strong) CAShapeLayer   *macdLayer;

@end

@implementation ZTYVolumCahrtView

- (void)calcuteMaxAndMinValue
{
    CGFloat maxPrice = CGFLOAT_MIN;
    CGFloat minPrice = CGFLOAT_MAX;
    
    
    for (ZTYChartModel *macdData in self.displayArray) {
        minPrice = minPrice < macdData.volumn.floatValue ? minPrice : macdData.volumn.floatValue;
        maxPrice = maxPrice > macdData.volumn.floatValue ? maxPrice : macdData.volumn.floatValue;
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
    
    self.scaleY = (self.maxY - self.minY) / (self.height - self.topMargin - self.bottomMargin);
    
    
}

- (void)calMaModelPosition
{
    NSUInteger idx = 0;
    for (ZTYChartModel *lineData in self.displayArray) {
        CGFloat xPosition = self.leftPostion + ((self.candleSpace+self.candleWidth) * idx) + self.leftMargin;
        
        CGFloat yPosition = ABS((self.maxY - lineData.volumn.doubleValue)/self.scaleY) +self.topMargin;
        //macd
        ZYWMacdPostionModel *model = [[ZYWMacdPostionModel alloc] init];
        model.endPoint = CGPointMake(xPosition, yPosition);
        model.startPoint = CGPointMake(xPosition,self.maxY/self.scaleY);
        
        float x = model.startPoint.y - model.endPoint.y;
        if (isEqualZero(x))
        {
            //柱线的最小高度
            model.endPoint = CGPointMake(xPosition,self.maxY/self.scaleY+1);
        }
        [self.macdArray addObject:model];
        idx ++;
    }
    //    for (NSInteger i = 0;i < self.displayArray.count;i++)
    //    {
    //        ZYWCandleModel *lineData = [self.displayArray objectAtIndex:i];
    //        CGFloat xPosition = self.leftPostion + ((self.candleSpace+self.candleWidth) * i) + self.leftMargin;
    //
    //        CGFloat yPosition = ABS((self.maxY - lineData.volumn.doubleValue)/self.scaleY) +self.topMargin;
    //        //macd
    //        ZYWMacdPostionModel *model = [[ZYWMacdPostionModel alloc] init];
    //        model.endPoint = CGPointMake(xPosition, yPosition);
    //        model.startPoint = CGPointMake(xPosition,self.maxY/self.scaleY);
    //
    //        float x = model.startPoint.y - model.endPoint.y;
    //        if (isEqualZero(x))
    //        {
    //            //柱线的最小高度
    //            model.endPoint = CGPointMake(xPosition,self.maxY/self.scaleY+1);
    //        }
    //        [self.macdArray addObject:model];
    //
    //    }
}

- (CAShapeLayer*)drawMacdLayer:(ZYWMacdPostionModel*)model candleModel:(ZTYChartModel*)macdModel
{
    CGRect rect = CGRectZero;
    //    CGFloat y = self.maxY/self.scaleY + self.topMargin;
    //    if (macdModel.macd > 0)
    //    {
    //        rect = CGRectMake(model.startPoint.x, model.endPoint.y, self.candleWidth, ABS(y - model.endPoint.y));
    //    }
    //
    //    else
    //    {
    //        rect = CGRectMake(model.startPoint.x,y, self.candleWidth, ABS(model.endPoint.y - model.startPoint.y));
    //    }
    CGFloat y = self.height;
    rect = CGRectMake(model.startPoint.x, model.endPoint.y, self.candleWidth, ABS(y - model.endPoint.y));
    
    //    if (macdModel.volumn.floatValue > 0)
    //    {
    //        CGFloat relateY = self.maxY/self.scaleY + self.topMargin;
    //        rect = CGRectMake(model.startPoint.x, y - ABS(relateY - model.endPoint.y), self.candleWidth, ABS(relateY - model.endPoint.y));
    //    }
    //
    //    else
    //    {
    //        rect = CGRectMake(model.startPoint.x,y - ABS(model.endPoint.y - model.startPoint.y), self.candleWidth, ABS(model.endPoint.y - model.startPoint.y));
    //    }
    
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
    //    __weak typeof(self) this = self;
    //    [_macdArray enumerateObjectsUsingBlock:^(ZYWMacdPostionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        ZYWCandleModel *model = this.displayArray[idx];
    //        CAShapeLayer *layer = [this drawMacdLayer:obj candleModel:model];
    //        [this.macdLayer addSublayer:layer];
    //    }];
    //    __weak typeof(self) this = self;
    
    NSUInteger idx = 0;
    for (ZYWMacdPostionModel* obj in _macdArray) {
        ZTYChartModel *model = self.displayArray[idx];
        CAShapeLayer *layer = [self drawMacdLayer:obj candleModel:model];
        [self.macdLayer addSublayer:layer];
        idx ++;
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
        [self.displayArray addObjectsFromArray:[self.dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount - 1)]];
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
    [self drawLine];
    [CATransaction commit];
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
        ZYWMacdPostionModel * model = self.macdArray[index];
        CGFloat minX = model.startPoint.x- (self.candleSpace + self.candleWidth/2);
        CGFloat maxX = model.endPoint.x + (self.candleSpace + self.candleWidth/2);
        
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
    ZYWMacdPostionModel *lastPositionModel = self.macdArray.lastObject;
    
    if (localPostion >= lastPositionModel.startPoint.x)
    {
        return CGPointMake(lastPositionModel.startPoint.x, lastPositionModel.startPoint.y - self.topMargin);
    }
    
    //第一根线
    ZYWMacdPostionModel *firstPositionModel = self.macdArray.firstObject;
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

@end

