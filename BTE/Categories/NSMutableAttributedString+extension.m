//
//  NSMutableAttributedString+extension.m
//  TestAttributeString
//
//  Created by xuehan on 15/8/7.
//  Copyright (c) 2015年 xuehan. All rights reserved.
//

#import "NSMutableAttributedString+extension.h"

@implementation NSMutableAttributedString (extension)

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)str attribute:(NSDictionary *)attribute andString:(NSString *)str2 attribute:(NSDictionary *)attribute2 andString:(NSString *)str3 attribute:(NSDictionary *)attribute3{
    
    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithString:str attributes:attribute];
    if(str2){
        NSMutableAttributedString *addString = [[NSMutableAttributedString alloc] initWithString:str2 attributes:attribute2];
        [temp appendAttributedString:addString];
    }
    if(str3){
        NSMutableAttributedString *addString3 = [[NSMutableAttributedString alloc] initWithString:str3 attributes:attribute3];
        [temp appendAttributedString:addString3];
    }
    return temp;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)str attribute:(NSDictionary *)attribute andString:(NSString *)str2 attribute:(NSDictionary *)attribute2{
    return [self attributedStringWithString:str attribute:attribute andString:str2 attribute:attribute2 andString:nil attribute:nil];
}

@end
