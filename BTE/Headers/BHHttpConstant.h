//
//  BHHttpConstant.h
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#ifndef BHHttpConstant_h
#define BHHttpConstant_h

#define ONLION 0

//数据库接口
#if ONLION
static NSString * const kDomain = @"http://m.biteye.org/";
#else
static NSString * const kDomain = @"http://47.94.217.12:18081/";
#endif
//开发环境  web-王磊开发环境
#if ONLION
static NSString * const kHeader = @"http://m.biteye.org/";
#else
static NSString * const kHeader = @"http://192.168.24.135:3001/";
#endif


// MARK: 注册&登录

//发送短信验证码
#define kMessageAuth [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/sms/login"]
// 用户手机号登录接口
#define kCodeLogin [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/login"]
//密码登录
#define kPwdLogin [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/loginPwd"]
//系统密码 更新密码
#define kreSetPwd [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/password"]

//MARK:版本更新
#define kAppVersion [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/config/update"]
//协议地址
#define kAppBTEProtcol [NSString stringWithFormat:@"%@%@",kDomain,@"wechat/protocol/"]

// 比特易h5入口地址
#define kAppBTEH5Address [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/index"]


#endif /* BHHttpConstant_h */









