//
//  BHNightModeView.m
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2018/1/7.
//  Copyright © 2018年 zhangyuanzhe. All rights reserved.
//

#import "BHNightModeView.h"

static BHNightModeView *userDefalut = nil;

@implementation BHNightModeView
+ (BHNightModeView *)shareUserDefault
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefalut = [[self alloc] init];
        userDefalut.backgroundColor = BHHexColorAlpha(@"#333333", 0.6);
        userDefalut.userInteractionEnabled = NO;
    });
    return userDefalut;
}
@end
