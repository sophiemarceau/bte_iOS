//
//  FormatUtil.h
//  BTE
//
//  Created by wanmeizty on 7/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatUtil : NSObject
// 金额
+ (NSString *)formatprice:(double)price;
// 价格
+ (NSString *)formatCount:(double)price;
// 处理科学计数法问题
+ (NSString *)dealSientificNumber:(double)number;

+ (CGSize)getsizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;
+ (CGSize)getsizeWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height;
@end
