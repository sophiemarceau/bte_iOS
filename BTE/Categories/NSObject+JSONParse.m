//
//  NSObject+JSONParse.m
//  WangliBank
//
//  Created by xiafan on 9/28/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSObject+JSONParse.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (JSONParse)

- (void)setValues:(NSDictionary *)values
{
    Class c = [self class];
    
    while (c && c != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        for (int i = 0 ; i < outCount; i++) {
            Ivar ivar = ivars[i];
            
            NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
            
            [name deleteCharactersInRange:NSMakeRange(0, 1)];
            
            NSString *key = name;
            if ([key isEqualToString:@"desc"]) {
                key = @"description";
            }
            if ([key isEqualToString:@"ID"]) {
                key = @"id";
            }
            id value = values[key];
            if (!value) continue;
            
            [self setValue:value forKey:name];
        }
        
        c = class_getSuperclass(c);
    }
}

- (NSDictionary *)values
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    Class c = [self class];
    
    while (c && c != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            
            NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
            
            [name deleteCharactersInRange:NSMakeRange(0, 1)];
            
            id value = [self valueForKey:name];
            if (value) {
                dict[name] = value;
            }
        }
        c = class_getSuperclass(c);
    }
    return dict;
}

- (void)encode:(NSCoder *)encoder
{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self.class, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        
        NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        
        id value = [self valueForKey:name];
        [encoder encodeObject:value forKey:name];
    }
}

- (void)decode:(NSCoder *)decoder
{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self.class, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        
        NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        
        [self setValue:[decoder decodeObjectForKey:name] forKey:name];
    }
}

@end
