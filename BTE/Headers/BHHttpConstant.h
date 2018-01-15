//
//  BHHttpConstant.h
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#ifndef BHHttpConstant_h
#define BHHttpConstant_h

// MARK: 注册&登录

static NSString *const kMessageAuth = @"messageAuth"; //发送短信或语音验证码
static NSString *const kLogin       = @"login";    // 用户手机号登录接口
static NSString *const kWXLogin     = @"loginWeChat";    // 用户微信登录接口
static NSString *const kSignout     = @"signout";   // 退出登录
static NSString *const KProfile     = @"profile";   // 用户详细信息
static NSString *const kSaveUserInfo = @"saveUserInfo";   //编辑用户信息


// MARK: 资讯相关接口
static NSString *const kInformationIndex = @"index"; //文章列表
static NSString *const kCollectionList = @"collectionList"; //文章收藏列表
static NSString *const kSearch = @"search"; //搜索接口


// MARK: 栏目相关接口
static NSString *const kColumnIndex = @"index"; //栏目列表

// MARK: 文章相关接口
static NSString *const kContentIndex = @"index"; //文章列表
static NSString *const kContentDesc = @"desc"; //文章详情
static NSString *const kLived = @"lived"; //文章点赞
static NSString *const kCancelLived = @"cancelLived"; //文章取消点赞
static NSString *const kCollection = @"collection"; //文章收藏
static NSString *const kCancelCollection = @"cancelCollection"; //文章取消收藏

//MARK:版本更新
static NSString *const kAppVersion = @"http://47.94.217.12:18081/app/api/config/update";//版本更新
static NSString *const kFeedback = @"feedback";//用户反馈
static NSString *const kAttention = @"attention";//关注作者
static NSString *const kCancelAttention = @"cancelAttention";//关注作者


//MARK:用户资产相关接口
static NSString *const kSign = @"sign";//签到获取积分
static NSString *const kGetassets = @"getassets";//获取用户总资产

#endif /* BHHttpConstant_h */
