//
//  NSString+CommonFunc.m
//  WangliBank
//
//  Created by xiafan on 9/25/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSString+CommonFunc.h"

@implementation NSString (CommonFunc)

- (NSString *)addColons
{
    NSString *numberString = self;
    
    BOOL hasDot;
    
    if (IS_IOS_8) {
        hasDot = [numberString containsString:@"."];
    } else {
        hasDot = [numberString rangeOfString:@"."].location != NSNotFound;
    }
    
    if (hasDot) { // 0000.00
        NSArray *parts = [numberString componentsSeparatedByString:@"."];
        NSMutableString *part1 = [NSMutableString stringWithString:[parts firstObject]];
        NSString *part2 = [parts lastObject];
        
        if (part1.length > 3) {
            
            part1 = [part1 addColon4String];
            part1 = (NSMutableString *)[part1 stringByAppendingFormat:@".%@", part2];
            
            return part1;
        }
    } else { // 0000
        return [numberString addColon4String];
    }
    
    return numberString;
}

- (NSMutableString *)addColon4String
{
    NSMutableString *colonString = [NSMutableString stringWithString:self];
    
    int step = 3;
    int len = (int)colonString.length;
    while (len - step > 0) {
        [colonString insertString:@"," atIndex:(len - step)];
        step += 3;
    }
    return colonString;
}

// 155******89
- (NSString *)encryptString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    NSUInteger length = mutableString.length;
    NSRange range = NSMakeRange(0, 0);
    NSString *replaceString = @"";
    
    if (length > 1 && length < 5) {// Name
        range = NSMakeRange(0, 1);
        replaceString = @"*";
    }
    if (length == 11) {// PhoneNo
        range = NSMakeRange(3, 6);
        replaceString = @"******";
    }
    if (length > 15) {// IdentityCardNo
        range = NSMakeRange(length-4, 4);
        replaceString = @"****";
    }
    return [mutableString stringByReplacingCharactersInRange:range withString:replaceString];
}
- (NSString *)encryptString2
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    NSUInteger length = mutableString.length;
    
    if (length<15) {
        return [self encryptString];
    }
    
    NSString *string_top = [mutableString substringWithRange:NSMakeRange(0, 4)];
    NSString *string_end = [mutableString substringWithRange:NSMakeRange(length-4, 4)];

    NSMutableString * xingStr= [[NSMutableString alloc]init];
    for (int k=0; k<length-8; k++) {
        [xingStr appendString:@"*"];
    }
    mutableString = [NSMutableString stringWithFormat:@"%@%@%@",string_top,xingStr,string_end];
    
    return mutableString;
}
@end
