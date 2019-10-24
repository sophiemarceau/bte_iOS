//
//  ZTYArrowLine.m
//  BTE
//
//  Created by wanmeizty on 2018/7/31.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYArrowLine.h"

@implementation ZTYArrowLine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor colorWithHexString:@"626A75" alpha:0.6].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath * anglePath = [UIBezierPath bezierPath];
        [anglePath moveToPoint:CGPointMake(0, frame.size.height * 0.5)];
        [anglePath addLineToPoint:CGPointMake(frame.size.width, frame.size.height * 0.5)];
        [anglePath addLineToPoint:CGPointMake(frame.size.width - 5.2, 0)];
        [anglePath addLineToPoint:CGPointMake(frame.size.width, frame.size.height * 0.5)];
        [anglePath addLineToPoint:CGPointMake(frame.size.width - 5.2, frame.size.height)];
        layer.path = anglePath.CGPath;
        layer.lineWidth = 1;
        [self.layer addSublayer:layer];
    }
    return self;
}

@end
