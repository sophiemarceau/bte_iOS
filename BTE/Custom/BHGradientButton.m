//
//  WLGradientButton.m
//  WangliBank
//
//  Created by qy on 2017/6/20.
//  Copyright © 2017年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "BHGradientButton.h"

@implementation BHGradientButton

+ (instancetype)normalGradientButton {
    BHGradientButton *sender = [BHGradientButton buttonWithType:UIButtonTypeCustom];
    sender.frame = CGRectZero;
    sender.gradienttype = 0;
    return sender;
}

- (void)gradientColorSetter {
    _startColor = BHColorBlue;
    _endColor = BHColorBlue;
    [self setNeedsDisplay];

}

- (void)grayColorSetter {
    
    _startColor = BHHexColor(@"E1E5EA");
    _endColor = BHHexColor(@"CBD3DE");
    [self setNeedsDisplay];
}

- (void)enableNoStartColor:(UIColor*)start endColor:(UIColor*)end {
    _startColor = start;
    _endColor = end;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setBackgroundImageNormal];
}

- (void)setBackgroundImageNormal {
    if (!_startColor || !_endColor) {
        _startColor = BHHexColor(@"FB5457");
        _endColor = BHHexColor(@"F5422A");
    }
    [self setBackgroundImageHighlighted];
    NSArray *colorArray = @[_startColor,_endColor];
    UIImage *backImage = [self buttonImageFromColors:colorArray ByGradientType:_gradienttype];
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    if (!_closeCorner) {
        [self setTheRoundedCorners];
    }
    
}

- (void)setTheRoundedCorners {
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds = YES;
}

- (void)setBackgroundImageHighlighted {
    UIColor *color1 = [_startColor colorWithAlphaComponent:0.9];
    UIColor *color2 = [_endColor colorWithAlphaComponent:0.9];
    NSArray *colorArray = @[color1,color2];
    UIImage *backImage = [self buttonImageFromColors:colorArray ByGradientType:_gradienttype];
    [self setBackgroundImage:backImage forState:UIControlStateHighlighted];
}

- (UIImage*)buttonImageFromColors:(NSArray*)colors ByGradientType:(NSInteger)gradientType {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start = CGPointMake(0.0, 0.0);;
    CGPoint end = CGPointMake(0.0, self.frame.size.height);;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, self.frame.size.height);
            break;
        case 3:
            start = CGPointMake(self.frame.size.width, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
