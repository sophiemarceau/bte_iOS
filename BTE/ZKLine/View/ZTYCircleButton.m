//
//  ZTYCircleButton.m
//  BTE
//
//  Created by wanmeizty on 2018/6/25.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYCircleButton.h"

@implementation ZTYCircleButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width * 0.5, frame.size.width * 0.5) radius:frame.size.width * 0.5 - 2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        //圆环遮罩
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor colorWithHexString:@"C9C9C9"].CGColor;
        shapeLayer.lineWidth = 5;
        shapeLayer.strokeStart = 0;
        shapeLayer.strokeEnd = 1;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineDashPhase = 0.8;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer setMask:shapeLayer];
        self.layer.backgroundColor = [UIColor colorWithHexString:@"DADADA"].CGColor;
        
    }
    return self;
}

@end
