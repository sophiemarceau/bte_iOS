//
//  BTEUserInfo.m
//  BTE
//
//  Created by 张竟巍 on 2018/2/27.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEUserInfo.h"
#define LOGIN_DATA_KEY @"BTE_LOGIN_KEY"

static BTEUserInfo * info = nil;


@implementation BTEUserInfo
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self getInfo];
        if (!info) {
            info = [BTEUserInfo new];
            info.isLogin = NO;
        }else {
            info.isLogin = YES;
        }
        
    });
    return info;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [super allocWithZone:zone];
    });
    return info;
}
- (id)copyWithZone:(NSZone *)zone {
    return [BTEUserInfo shareInstance];
}

-(void)removeLoginData {
    info = [BTEUserInfo new];
    info.userToken = nil;
    info.hxuserPassword = nil;
    info.hxuserName = nil;
    _isLogin = NO;
    info.isFutureDogUser = NO;
    info.futureDogGoal = nil;
    [self remove];
}

- (void)save {
    NSMutableDictionary *dic = [self yy_modelToJSONObject];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:LOGIN_DATA_KEY];
    [userDefaults synchronize];
    _isLogin = YES;
}

+ (void)getInfo {
    info = (BTEUserInfo *)[BTEUserInfo yy_modelWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_DATA_KEY]];
    info.isFutureDogUser = [[[NSUserDefaults standardUserDefaults] objectForKey:KisFutureDogUser] boolValue];
    info.futureDogGoal = [[[NSUserDefaults standardUserDefaults] objectForKey:KisFutureDogUserGoal] integerValue];
    
    
    
}

- (void)remove {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:LOGIN_DATA_KEY];
    [userDefaults removeObjectForKey:KisFutureDogUser];
    [userDefaults removeObjectForKey:KisFutureDogUserGoal];
    [userDefaults synchronize];
}

@end
