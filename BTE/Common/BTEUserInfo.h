//
//  BTEUserInfo.h
//  BTE
//
//  Created by 张竟巍 on 2018/2/27.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTEUserInfo : NSObject
/**
 是否登录
 */
@property (nonatomic, assign) BOOL isLogin;
/**
 用户令牌
 */
@property (nonatomic, copy) NSString * userToken;



#pragma mark - methods
+ (instancetype)shareInstance;
//删除登录数据
- (void)removeLoginData;
//保存登录数据
- (void)save;
@end
