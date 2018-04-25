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
static NSString * const kDomain = @"http://m.bte.top/";
#else
static NSString * const kDomain = @"http://47.94.217.12:18081/";
#endif
//开发环境  web-王磊开发环境
#if ONLION
static NSString * const kHeader = @"http://m.bte.top/";
static NSString * const kChart = @"http://chart.bte.top/";
static NSString * const kGlobal = @"global";
#else
//static NSString * const kHeader = @"http://192.168.24.135:3001/";
static NSString * const kHeader = @"http://192.168.24.64:3001/";
static NSString * const kChart = @"http://192.168.24.64:8082/";
static NSString * const kGlobal = @"global_test";
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
#define kAppBTEProtcol [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/protocol/"]

// 比特易h5入口地址 市场分析
#define kAppBTEH5AnalyzeAddress [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/index"]

// 比特易h5入口地址 策略跟随
#define kAppBTEH5FollowAddress [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/StrategyIndex"]

// 比特易h5入口地址 我的账户
#define kAppBTEH5MyAccountAddress [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/mime"]



// 投资详情入口地址
#define kAppStrategyAddress [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/strategy"]

// 交易详情入口地址
#define kAppDealAddress [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/deal"]
// 市场分析详情入口地址
#define kAppDetailDealAddress [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/baza"]
// 首页市场分析图表
#define kAppMarketAnalysisAddress [NSString stringWithFormat:@"%@%@",kChart,@"chart/stockChart"]

//MARK:我的账户

//账户基本信息
#define kAcountInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/account/info"]
//获取当前账户电话号码
#define kAcountPhoneNum [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/info"]
//获取当前跟投信息
#define kAcountHoldInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/account/hold"]
//获取当前跟投份额信息
#define kAcountSettleInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/account/settle"]
//退出登录
#define kAcountUserLogout [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/logout"]

//获取用户登录状态
#define kGetUserLoginInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/online"]

//MARK:首页市 场分析
#define kGetlatestInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/advise/latests"]

//新闻快讯
#define kGetlatestNewsInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/news/latest"]

//获取首页显示的策略信息
#define kGetlatestProductInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/product/home"]

//MARK:策略列表页
//获取策略列表
#define kGetlatestProductList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/product/list"]

//获取邀请好友
#define kGetUserInvateFrend [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/myQrCode"]
#define kGetUserInvateFrendUrl [NSString stringWithFormat:@"%@%@",kHeader,@"wechat/regiSter"]

//获取邀请好友结果
#define kGetUserInvateFrendCount [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/invite/list"]
#endif /* BHHttpConstant_h */









