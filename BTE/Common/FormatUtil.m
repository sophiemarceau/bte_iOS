//
//  FormatUtil.m
//  BTE
//
//  Created by wanmeizty on 7/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "FormatUtil.h"

@implementation FormatUtil
// 金额
+ (NSString *)formatprice:(double)price{
    if (price >= 1000) {
        NSInteger priceInt = (NSInteger)price;
        return [NSString stringWithFormat:@"%ld",priceInt];
    }else if (price >= 10){
        return [NSString stringWithFormat:@"%.1f",price];
    }else{
        return [NSString stringWithFormat:@"%.2f",price];
    }
}

// 价格
+ (NSString *)formatCount:(double)price{
    if (price >= 100000000) {
        return [NSString stringWithFormat:@"%.2lf亿",price/ 100000000.0];
    }else if (price >= 10000){
        NSInteger priceInt = (NSInteger)(price/10000.0 + 0.5);
        return [NSString stringWithFormat:@"%ld万",priceInt];
    }else{
        NSInteger priceInt = (NSInteger)(price + 0.5);
        return [NSString stringWithFormat:@"%ld",priceInt];
    }
}

+ (NSString *)dealSientificNumber:(double)number{
    NSString * dealStr = [NSString stringWithFormat:@"%@",@(number)];
    if ([dealStr containsString:@"e-"])dealStr = [NSString stringWithFormat:@"%.8f",number];
    while ([dealStr hasSuffix:@"0"]) dealStr=[dealStr substringToIndex:(dealStr.length-1)];
    return dealStr;
}

+ (CGSize)getsizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    CGSize size = [text getSizeOfString:font constroSize:CGSizeMake(width, CGFLOAT_MAX)];
    return size;
}

+ (CGSize)getsizeWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height{
    CGSize size = [text getSizeOfString:font constroSize:CGSizeMake(CGFLOAT_MAX, height)];
    return size;
}
@end
