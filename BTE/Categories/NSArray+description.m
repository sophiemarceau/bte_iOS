//
//  NSArray+description.m
//  05- 数组字典输出汉字
//
//  Created by 王俨 on 15/7/14.
//  Copyright (c) 2015年 王俨. All rights reserved.
//

#import "NSArray+description.h"

@implementation NSArray (description)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\r\n"];
    if (self.count) {
        for (int i = 0; i< self.count - 1; i++){
            [strM appendFormat:@"\t\"%@\",\r\n", self[i]];
        }
        [strM appendFormat:@"\t\"%@\"", self.lastObject];
    }
    [strM appendString:@"\r\n)"];
    return strM;
}

@end

@implementation NSDictionary (description)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"{\r\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [strM appendString:@"\r\n}"];
    return strM;
}

@end
