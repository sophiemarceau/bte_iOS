//
//  BHStaticConstant.h
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#ifndef BHStaticConstant_h
#define BHStaticConstant_h

//正在加载文案
static NSString * const kPleaseWait = @"Loading...";
// MARK: --服务器环境（本地测试用)----
static NSString *const kServiceEnvironment = @"serviceEnvironment";
static NSString *const kOnline = @"online";
static NSString *const kOnlineReady = @"onlineReady";
static NSString *const kTest   = @"test";
static NSString *const kLocal  = @"local";

// 保存cookie的key
static NSString *const kSessionId = @"session";
static NSString *const kVersion = @"version"; ///< 版本号
static NSString *const kUserInfo  = @"USER_INFO";

// MARK: ---- 钥匙串 ----
static NSString *const UUIDKeyChainKey = @"UUIDKeyChain"; //存入UUID的钥匙串
static NSString *const ServiceChainKey = @"com.bitcoinheadlines.iosapp"; //存入UUID的service

// MARK:  -----文案-----
static NSString *const kVerifyCodeSendSucess = @"发送验证码成功，请注意查收";
static NSString *const kVerifyCodeSendFailed = @"获取验证码失败，请重新获取";
static NSString *const kVerifyCodeNotFetch   = @"请先获取短信验证码";

// Tip Message
static NSString * const kNetworkBusyTipMessage = @"网络不给力，请重试";
static NSString * const kNotReachableTipMessage = @"网络未连接";

static NSString *const kOriginPasswordDescription  = @"请输入原交易密码，以校验身份";
static NSString *const kResetPasswordDescription   = @"请设置并牢记新的交易密码";
static NSString *const kConfirmPasswordDescription = @"请再次确认新的交易密码";

// 服务热线
static NSString *const SERVICE_HOT_LINE = @"400-965-0866";

static NSString *const kAppStoreAddress = @"https://itunes.apple.com/cn/app/id1342160976?mt=8";
//App Store评论
static NSString *const kAppStoreCommentAddress = @"itms-apps://itunes.apple.com/cn/app/id1342160976?mt=8&action=write-review";


#endif /* BHStaticConstant_h */
