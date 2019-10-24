//
//  UIColor+Externsion.m
//  WangliBank
//
//  Created by 王俨 on 2017/6/20.
//  Copyright © 2017年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIColor+Externsion.h"

@implementation UIColor (Externsion)

+ (instancetype)colorWithTopColor:(UIColor *)topColor
                      bottomColor:(UIColor *)bottomColor
                           height:(CGFloat)height {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    layer.colors = @[(__bridge UIColor *)topColor.CGColor, (__bridge UIColor *)bottomColor.CGColor];
    
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
