//
//  ZYWMacdView.m
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWMacdView.h"
#import "ZYWMacdPostionModel.h"
#import "ZYWLineModel.h"

static inline bool isEqualZero(float value)
 {
    return fabsf(value) <= 0.00001f;
}

@interface ZYWMacdView()

@property (nonatomic,strong) NSMutableArray *displayArray;
@property (nonatomic,strong) NSMutableArray *macdArray;
@property (nonatomic,strong) NSMutableArray *deaArray;
@property (nonatomic,strong) NSMutableArray *diffArray;
@property (nonatomic,strong) CAShapeLayer   *macdLayer;

@end

@implementation ZYWMacdView

- (void)calcuteMaxAndMinValue
{
    CGFloat maxPrice = 0;
    CGFloat minPrice = 0;
    
    ZYWMacdModel *first = [self.displayArray objectAtIndex:0];
    maxPrice = MAX(first.dea, MAX(first.diff, first.macd));
    minPrice = MIN(first.dea, MIN(first.diff, first.macd));
    first.left = self.leftPostion + self.leftMargin;
    for (NSInteger i = 1;i<self.displayArray.count;i++)
    {
        
        ZYWMacdModel *macdData = [self.displayArray objectAtIndex:i];
        maxPrice = MAX(maxPrice, MAX(macdData.dea, MAX(macdData.diff, macdData.macd)));
        minPrice = MIN(minPrice, MIN(macdData.dea, MIN(macdData.diff, macdData.macd)));
        macdData.left = self.leftPostion+ ((self.candleWidth + self.candleSpace) * i) + self.leftMargin;
    }
    self.maxY = maxPrice;
    self.minY = minPrice;
    if (self.maxY - self.minY < 0.5)
    {
        self.maxY += 0.5;
        self.minY += 0.5;
    }
    self.topMargin = 5;
    self.bottomMargin = 5;
    self.leftMargin = 2;
    self.scaleY = (self.maxY - self.minY) / (self.height - self.topMargin - self.bottomMargin);
}

- (void)calMaModelPosition
{
    for (NSInteger i = 0;i < self.displayArray.count;i++)
    {
        ZYWMacdModel *lineData = [self.displayArray objectAtIndex:i];
        CGFloat xPosition = self.leftPostion + ((self.candleSpace+self.candleWidth) * i) + self.leftMargin;
        CGFloat yPosition = ABS((self.maxY - lineData.macd)/self.scaleY) + self.topMargin ;
        //macd
        ZYWMacdPostionModel *model = [[ZYWMacdPostionModel alloc] init];
        model.endPoint = CGPointMake(xPosition, yPosition);
        model.startPoint = CGPointMake(xPosition,self.maxY/self.scaleY + self.topMargin);
        
        float x = model.startPoint.y - model.endPoint.y;
        if (isEqualZero(x))
        {
            //柱线的最小高度
            model.endPoint = CGPointMake(xPosition,self.maxY/self.scaleY+1);
        }
        [self.macdArray addObject:model];
        
        //diff
        CGFloat diffPostion = ABS((self.maxY - lineData.diff)/self.scaleY) +self.topMargin;
        ZYWLineModel *difModel = [ZYWLineModel initPositon:xPosition+self.candleWidth/2 yPosition:diffPostion color:[UIColor redColor]];
        [self.diffArray addObject:difModel];
        
        //dea
        CGFloat deayPostion = ABS((self.maxY - lineData.dea)/self.scaleY) + self.topMargin;
        ZYWLineModel *deaModel = [ZYWLineModel initPositon:xPosition+self.candleWidth/2 yPosition:deayPostion color:[UIColor redColor]];
        [self.deaArray addObject:deaModel];
    }
}

- (CAShapeLayer*)drawMacdLayer:(ZYWMacdPostionModel*)model candleModel:(ZYWMacdModel*)macdModel
{
    CGRect rect = CGRectZero;
    CGFloat y = self.maxY/self.scaleY + self.topMargin;
    if (macdModel.macd > 0)
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
    if (macdModel.macd > 0)
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
    __weak typeof(self) this = self;
    [_macdArray enumerateObjectsUsingBlock:^(ZYWMacdPostionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZYWMacdModel *model = this.displayArray[idx];
        CAShapeLayer *layer = [this drawMacdLayer:obj candleModel:model];
        [this.macdLayer addSublayer:layer];
    }];

    UIBezierPath *deaPath = [UIBezierPath drawLine:self.deaArray];
    CAShapeLayer *deaLayer = [CAShapeLayer layer];
    deaLayer.path = deaPath.CGPath;
    deaLayer.strokeColor = [UIColor redColor].CGColor;
    deaLayer.fillColor = [[UIColor clearColor] CGColor];
    deaLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.macdLayer addSublayer:deaLayer];
    
    UIBezierPath *diffPath = [UIBezierPath drawLine:self.diffArray];
    CAShapeLayer *diffLayer = [CAShapeLayer layer];
    diffLayer.path = diffPath.CGPath;
    diffLayer.strokeColor = [UIColor blackColor].CGColor;
    diffLayer.fillColor = [[UIColor clearColor] CGColor];
    diffLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.macdLayer addSublayer:diffLayer];
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
        [self.deaArray removeAllObjects];
        [self.diffArray removeAllObjects];
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
    if (_startIndex == -1) return;
    [self removeAllObjectFromArray];
//    NSLog(@"_startIndex====%ld---_displayCount====%ld",_startIndex,_displayCount);
    
    
    
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
    [self calcuteMaxAndMinValue];
    [self calMaModelPosition];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self removeFromSubLayer];
    [self initLayer];
    [self drawLine];
//    [self drawAxisLine];
//    [self drawTimeLayer];
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

- (void)drawTimeLayer
{
    [self.displayArray enumerateObjectsUsingBlock:^(ZYWMacdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.isDrawDate)
        {
            
            if (ISShowTimeLine == 1) {
                //时间线
                CAShapeLayer *lineLayer = [self getAxispLayer];
                UIBezierPath *path = [UIBezierPath bezierPath];
                path.lineWidth = self.lineWidth;
                lineLayer.lineWidth = self.lineWidth;
                // + self.candleWidth/2 - self.lineWidth/2
                [path moveToPoint:CGPointMake(model.left + self.candleWidth/2 - self.lineWidth/2, 1*heightradio)];
                [path addLineToPoint:CGPointMake(model.left + self.candleWidth/2 - self.lineWidth/2,self.height -self.bottomMargin)];
                lineLayer.path = path.CGPath;
                [self.macdLayer addSublayer:lineLayer];

            }
        }
    }];
}

- (ZYWMacdModel *)searchModel:(NSInteger)index{
    ZYWMacdModel * model = [self.dataArray objectAtIndex:index];
    return model;
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
