//
//  BHHexColor.m
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHHexColor.h"

@implementation BHHexColor
+ (UIColor *)hexColor:(NSString *)colorString {
    return [self hexColor:colorString alpha:1.0];
}


+ (UIColor *)hexColor:(NSString *)colorString alpha:(CGFloat)alp {
    // incorrect input
    if ([colorString length] < 6) {
        return [UIColor whiteColor];
    }
    
    
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    if ([colorString length] == 6) {
        colorString = [colorString stringByAppendingString:@"64"];
    }
    unsigned int red, green, blue, alpha;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&blue];
    range.location = 6;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&alpha];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(alp/1.0)];
}
/// 导航栏渐变色
+ (UIColor *)navigationBarColor {
    static UIColor *navigationBarColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, -20, SCREEN_WIDTH, NAVIGATION_HEIGHT);
        id  color = (__bridge UIColor *)BHHexColor(@"005CCC").CGColor;
        id color2 = (__bridge UIColor *)BHHexColor(@"0083FF").CGColor;
        layer.colors = @[color, color2];
        
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [layer renderInContext:context];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIColor *patternColor = [UIColor colorWithPatternImage:image];
        navigationBarColor = patternColor;
        
        UIGraphicsEndImageContext();
    });
    
    return navigationBarColor;
}

@end
