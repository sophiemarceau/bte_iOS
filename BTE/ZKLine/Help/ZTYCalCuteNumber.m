//
//  ZTYCalCuteNumber.m
//  BTE
//
//  Created by wanmeizty on 2018/6/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYCalCuteNumber.h"

@implementation ZTYCalCuteNumber

+ (NSString *)calculate:(CGFloat)number{
    
    
    if (ABS(number) > 10) {
        return [NSString stringWithFormat:@"%.2f",number];
    }else{
//        return [NSString stringWithFormat:@"%@",@(number)];
        
        return [NSString stringWithFormat:@"%.8lf",number];
    }
}

+ (NSString *)calculateBesideLing:(CGFloat)number{
    
    
    if (ABS(number) > 10) {
        return [NSString stringWithFormat:@"%.2f",number];
    }else{
        //        return [NSString stringWithFormat:@"%@",@(number)];
        
        return [self changeFloat:[NSString stringWithFormat:@"%.8lf",number]];
    }
}

+(NSString *)changeFloat:(NSString *)stringFloat
{
    NSUInteger length = [stringFloat length];
    for(int i = 1; i<=8; i++)
    {
        NSString *subString = [stringFloat substringFromIndex:length - i];
        if(![subString isEqualToString:@"0"])
        {
            return stringFloat;
        }
        else
        {
            stringFloat = [stringFloat substringToIndex:length - i];
        }
        
    }
    return [stringFloat substringToIndex:length - 9];
}
@end
