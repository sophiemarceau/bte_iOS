//
//  BHHexColor.h
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHHexColor : NSObject
//16进制颜色转UIColor
+ (UIColor *)hexColor:(NSString *)colorString;

+ (UIColor *)hexColor:(NSString *)colorString alpha:(CGFloat)alp;

/// 导航栏渐变色
+ (UIColor *)navigationBarColor;
@end
