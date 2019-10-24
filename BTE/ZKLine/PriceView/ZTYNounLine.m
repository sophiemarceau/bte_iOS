//
//  ZTYNounLine.m
//  ZTYNounLineView
//
//  Created by wanmeizty on 2018/6/13.
//  Copyright © 2018年 wanmeizty. All rights reserved.
//

#import "ZTYNounLine.h"

@interface ZTYNounLine ()
@property (nonatomic,strong) CAShapeLayer * nounslayer;
@end

@implementation ZTYNounLine

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        if (!self.strokeColor) {
            self.strokeColor = LineBGColor;//[UIColor lightGrayColor];
        }
        if (!self.lineWidth) {
            self.lineWidth = 0.5;
        }
        
        CAShapeLayer * yLayer = [CAShapeLayer layer];
        yLayer.strokeColor = self.strokeColor.CGColor; //[UIColor colorWithHexString:@"E5E5EE"].CGColor; // E5E5EE ededed
        yLayer.fillColor = [[UIColor clearColor] CGColor];
        yLayer.contentsScale = [UIScreen mainScreen].scale;
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
        yLayer.path = path.CGPath;
        path.lineWidth = self.lineWidth;
        yLayer.lineWidth = self.lineWidth;
        [self.layer addSublayer:yLayer];
        
    }
    return self;
}

/**
 * points 包含的所有y坐标的点
 */
- (void)setNounlinewidthNouns:(NSArray *)points{
    if (self.nounslayer)
    {
        [self.nounslayer removeFromSuperlayer];
        self.nounslayer = nil;
    }
    
    if (!self.nounslayer)
    {
        self.nounslayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.nounslayer];
    }
    
//    CGMutablePathRef redRef = CGPathCreateMutable();
//
//    [points enumerateObjectsUsingBlock:^(NSNumber * ypoint, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGPathMoveToPoint(redRef, NULL, 0, ypoint.floatValue);
//        CGPathAddLineToPoint(redRef, NULL, self.lineWidth+4, ypoint.floatValue);
//    }];
    
    for (NSNumber * ypoint in points) {
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.strokeColor = self.strokeColor.CGColor;
        layer.fillColor = self.strokeColor.CGColor;
        layer.lineWidth = self.lineWidth;
        UIBezierPath * bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:CGPointMake(0, ypoint.floatValue)];
        [bezier addLineToPoint:CGPointMake(self.lineWidth+4, ypoint.floatValue)];
        layer.path = bezier.CGPath;
        [self.nounslayer addSublayer:layer];
    }
    
    
    self.nounslayer.lineWidth = self.lineWidth;
//    self.nounslayer.path = redRef;
    self.nounslayer.fillColor = self.strokeColor.CGColor;
    self.nounslayer.strokeColor = self.strokeColor.CGColor;
    
}

@end
