//
//  UIFont+extension.m
//  WangliBank
//
//  Created by 王俨 on 16/8/10.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIFont+extension.h"
#import <objc/runtime.h>

@implementation UIFont (extension)

+ (instancetype)wy_fontOfSize:(CGFloat)size {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.2) {
        return [self systemFontOfSize:size weight:UIFontWeightLight];
    }
    
    return [self systemFontOfSize:size];
}

@end
