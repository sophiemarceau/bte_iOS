//
//  ZTYCircleLayer.m
//  BTE
//
//  Created by wanmeizty on 2018/6/25.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYCircleLayer.h"

@interface ZTYCircleLayer()

//@property (nonatomic,strong) CAShapeLayer * circleLayer;
@end

@implementation ZTYCircleLayer

- (instancetype)init{
    if (self = [super init]) {
        
        //        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:8.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        ////        bezierPath.lineWidth = 5;
        //        //圆环遮罩
        //        self.fillColor = [UIColor clearColor].CGColor;
        //        self.strokeColor = [UIColor colorWithHexString:@"c8c8c8" alpha:0.2].CGColor;
        //        self.lineWidth = 5;
        ////        self.strokeStart = 0;
        ////        self.strokeEnd = 1;
        ////        self.lineCap = kCALineCapRound;
        ////        self.lineDashPhase = 0.8;
        //        self.path = bezierPath.CGPath;
        ////        self.backgroundColor = [UIColor colorWithHexString:@"dadada"].CGColor;
        //
        //
        //        UIBezierPath *inbezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:4.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        //        inbezierPath.lineWidth = 2.5;
        //        CAShapeLayer * incircle = [CAShapeLayer layer];
        //
        //        incircle.path = inbezierPath.CGPath;
        //        incircle.strokeColor = [UIColor colorWithHexString:@"c9c9c9"].CGColor;
        //        incircle.lineWidth = 2.5;
        //        incircle.fillColor = [UIColor whiteColor].CGColor;
        //        [self addSublayer:incircle];
        
        //        self.circleLayer = [CAShapeLayer layer];
        //        self.circleLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"klinecircle"]].CGColor;
        ////        self.circleLayer.frame = CGRectMake(10.5, 10.5, 19, 19);
        //
        //        [self addSublayer:self.circleLayer];
        //
        self.backgroundColor = [UIColor clearColor].CGColor;
        
        
        
    }
    return self;
}

- (void)setCirleFrame:(CGRect)frame{
    //    self.circleLayer.frame = CGRectMake((frame.size.width - 19) * 0.5, (frame.size.height - 19) * 0.5, 19, 19);
    self.frame = frame;
    
    //    self.circleLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"klinecircle"]].CGColor;
}

//- (void)setCircleWith:(CGFloat)circleWith{
//    self.lineWidth = circleWith;
//}
//
//-(void)setCircleColor:(UIColor *)circleColor{
//    self.strokeColor = circleColor.CGColor;
//}

@end

