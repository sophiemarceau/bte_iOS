//
//  ZTYTimerLineChartView.m
//  BTE
//
//  Created by wanmeizty on 2018/7/6.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYTimerLineChartView.h"

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZTYTimerLineChartView()

@property (nonatomic,strong) NSMutableArray * displayArray;
@property (nonatomic,strong) CAShapeLayer * timeLayer;
@property (nonatomic,assign) CGFloat timeLayerHeight;
@end

@implementation ZTYTimerLineChartView

- (void)stockFill{
    self.timeLayerHeight = 12;
    [self initCurrentDisplayModels];
    [self removeTimerLayer];
    [self drawTimeLayer];
}

- (void)initCurrentDisplayModels{
    
    if (self.dataArray.count == 0) return;
    [self.displayArray removeAllObjects];
    // 当前将要显示的数据
    if (_startIndex + _displayCount > self.dataArray.count)
    {
        [self.displayArray addObjectsFromArray:[_dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount - 1)]];
    }
    
    else
    {
        [self.displayArray addObjectsFromArray:[_dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount)]];
    }
}

// 日期显示以及时间线 竖线
- (void)drawTimeLayer
{
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
    [self.timeLayer addSublayer:bottomLayer];
    
    NSArray *array = [_dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount)];
    [array enumerateObjectsUsingBlock:^(ZTYChartModel *kLinemodel, NSUInteger idx, BOOL * _Nonnull stop) {
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
                layer.position = CGPointMake(xposion + self.candleWidth , self.height - self.timeLayerHeight/2);
                layer.bounds = CGRectMake(0, 0, 60, self.timeLayerHeight);
            }
            [self.timeLayer addSublayer:layer];
            
        }
    }];
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
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    layer.font = fontRef;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}

- (void)removeTimerLayer{
    for (NSInteger i = 0 ; i < self.timeLayer.sublayers.count; i++)
    {
        CAShapeLayer *layer = (CAShapeLayer*)self.timeLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    [self.timeLayer removeFromSuperlayer];
    self.timeLayer = nil;
    
    [self.layer addSublayer:self.timeLayer];
}

- (CAShapeLayer *)timeLayer{

    if (!_timeLayer)
    {
        _timeLayer = [CAShapeLayer layer];
        _timeLayer.lineWidth = KLineWidth;
        _timeLayer.strokeColor = [UIColor clearColor].CGColor;
        _timeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _timeLayer;
}

- (NSMutableArray*)displayArray
{
    if (!_displayArray)
    {
        _displayArray = [NSMutableArray array];
    }
    return _displayArray;
}

@end
