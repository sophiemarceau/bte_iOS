//
//  ZTYRSILineView.m
//  BTE
//
//  Created by wanmeizty on 2018/6/1.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYRSILineView.h"
#import "ZYWLineData.h"
#import "ZYWLineUntil.h"
#import "ZTYChartModel.h"

@interface ZTYRSILineView()

@property (nonatomic,strong) CAShapeLayer *kLineLayer; // RSI_6
@property (nonatomic,strong) CAShapeLayer *dLineLayer; // RSI_12
@property (nonatomic,strong) CAShapeLayer *jLineLayer; // RSI_24
@property (nonatomic,strong) NSMutableArray *kPostionArray;
@property (nonatomic,strong) NSMutableArray *dPostionArray;
@property (nonatomic,strong) NSMutableArray *jPostionArray;

@end

@implementation ZTYRSILineView

- (void)initLayer
{
    if (self.kLineLayer)
    {
        [self.kLineLayer removeFromSuperlayer];
        self.kLineLayer = nil;
    }
    
    if (!self.kLineLayer)
    {
        self.kLineLayer = [CAShapeLayer layer];
        self.kLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.kLineLayer.lineWidth = self.lineWidth;
        self.kLineLayer.lineCap = kCALineCapRound;
        self.kLineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.kLineLayer];
    
    if (self.dLineLayer)
    {
        [self.dLineLayer removeFromSuperlayer];
        self.dLineLayer = nil;
    }
    
    if (!self.dLineLayer)
    {
        self.dLineLayer = [CAShapeLayer layer];
        self.dLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.dLineLayer.lineWidth = self.lineWidth;
        self.dLineLayer.lineCap = kCALineCapRound;
        self.dLineLayer.lineJoin = kCALineJoinRound;
    }
    
    [self.layer addSublayer:self.dLineLayer];
    
    if (self.jLineLayer)
    {
        [self.jLineLayer removeFromSuperlayer];
        self.jLineLayer = nil;
    }
    
    if (!self.jLineLayer)
    {
        self.jLineLayer = [CAShapeLayer layer];
        self.jLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.jLineLayer.lineWidth = self.lineWidth;
        self.jLineLayer.lineCap = kCALineCapRound;
        self.jLineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.jLineLayer];
}

- (void)initMaxAndMinValue
{
    [self layoutIfNeeded];
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;

    NSArray *array = [_dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount)];
    for (ZTYChartModel *lineData in array)
    {
        if (lineData.x > 5) {
            CGFloat kvalue = [lineData.RSI_6 floatValue];
            self.minY = self.minY < kvalue ? self.minY : kvalue;
            self.maxY = self.maxY > kvalue ? self.maxY : kvalue;
        }
        
        if (lineData.x > 11) {
            CGFloat dvalue = [lineData.RSI_12 floatValue];
            self.minY = self.minY < dvalue ? self.minY : dvalue;
            self.maxY = self.maxY > dvalue ? self.maxY : dvalue;
        }
        
        if (lineData.x > 23) {
            CGFloat jvalue = [lineData.RSI_24 floatValue];
            self.minY = self.minY < jvalue ? self.minY : jvalue;
            self.maxY = self.maxY > jvalue ? self.maxY : jvalue;
        }
    }
    
    if (self.maxY - self.minY < 0.5)
    {
        self.maxY += 0.5;
        self.minY  += 0.5;
    }
    
    self.leftMargin = 2;
    self.topMargin = 10;
    self.bottomMargin = 5;
    self.scaleY = (self.height - self.topMargin - self.bottomMargin)/(self.maxY-self.minY);
    
}

- (void)initLinesModelPosition
{
    [self.kPostionArray removeAllObjects];
    [self.dPostionArray removeAllObjects];
    [self.jPostionArray removeAllObjects];
    
    
    NSArray *array = [_dataArray subarrayWithRange:NSMakeRange(_startIndex,_displayCount)];
    [array enumerateObjectsUsingBlock:^(ZTYChartModel *kLinemodel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (kLinemodel.x > 5) {
            CGFloat kvalue = [kLinemodel.RSI_6 floatValue];
            CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2 + self.leftMargin;
            CGFloat yPosition = ((self.maxY - kvalue) *self.scaleY) + self.topMargin;
            ZYWLineModel *kmodel = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:[UIColor redColor]];
            [self.kPostionArray addObject:kmodel];
        }
        
        if (kLinemodel.x > 11) {
            CGFloat dvalue = [kLinemodel.RSI_12 floatValue];
            CGFloat dxPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2 + self.leftMargin;
            CGFloat dyPosition = ((self.maxY - dvalue) *self.scaleY) + self.topMargin;
            ZYWLineModel *dmodel = [ZYWLineModel  initPositon:dxPosition yPosition:dyPosition color:[UIColor greenColor]];
            [self.dPostionArray addObject:dmodel];
        }
        
        
        
        if (kLinemodel.x > 23) {
            CGFloat jvalue = [kLinemodel.RSI_24 floatValue];
            CGFloat jxPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * idx) + self.candleWidth/2 + self.leftMargin;
            CGFloat jyPosition = ((self.maxY - jvalue) *self.scaleY) + self.topMargin;
            ZYWLineModel *jmodel = [ZYWLineModel  initPositon:jxPosition yPosition:jyPosition color:[UIColor blueColor]];
            [self.jPostionArray addObject:jmodel];
        }
        
    }];
    
    
}

- (void)drawLineLayer
{
    
    //    ZYWLineData *kData = self.dataArray[0];
    UIBezierPath *kPath = [UIBezierPath drawLine:self.kPostionArray];
    self.kLineLayer.path = kPath.CGPath;
    self.kLineLayer.strokeColor = [UIColor redColor].CGColor;
    self.kLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.kLineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //    ZYWLineData *dData = self.dataArray[1];
    UIBezierPath *dPath = [UIBezierPath drawLine:self.dPostionArray];
    self.dLineLayer.path = dPath.CGPath;
    self.dLineLayer.strokeColor = [UIColor greenColor].CGColor;
    self.dLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.dLineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //    ZYWLineData *jData = self.dataArray[2];
    UIBezierPath *jPath = [UIBezierPath drawLine:self.jPostionArray];
    self.jLineLayer.path = jPath.CGPath;
    self.jLineLayer.strokeColor = [UIColor blueColor].CGColor;
    self.jLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.jLineLayer.contentsScale = [UIScreen mainScreen].scale;
}

#pragma mark 绘制

- (void)stockFill
{
    [self initMaxAndMinValue];
    [self initLayer];
    [self initLinesModelPosition];
    [self drawLineLayer];
}

#pragma mark lazyMethod

- (NSMutableArray*)kPostionArray
{
    if (!_kPostionArray)
    {
        _kPostionArray = [NSMutableArray array];
    }
    return _kPostionArray;
}

- (NSMutableArray*)dPostionArray
{
    if (!_dPostionArray)
    {
        _dPostionArray = [NSMutableArray array];
    }
    return _dPostionArray;
}

- (NSMutableArray*)jPostionArray
{
    if (!_jPostionArray)
    {
        _jPostionArray = [NSMutableArray array];
    }
    return _jPostionArray;
}

@end
