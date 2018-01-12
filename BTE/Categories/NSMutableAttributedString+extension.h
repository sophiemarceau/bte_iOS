//
//  NSMutableAttributedString+extension.h
//  TestAttributeString
//
//  Created by xuehan on 15/8/7.
//  Copyright (c) 2015年 xuehan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (extension)

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)str attribute:(NSDictionary *)attribute andString:(NSString *)str2 attribute:(NSDictionary *)attribute2 andString:(NSString *)str3 attribute:(NSDictionary *)attribute3;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)str attribute:(NSDictionary *)attribute andString:(NSString *)str2 attribute:(NSDictionary *)attribute2;

@end
