//
//  BHNotificationConstant.h
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#ifndef BHNotificationConstant_h
#define BHNotificationConstant_h

static NSString *const NotificationCouponFromUserCenter      = @"CouponFromUserCenter";       ///< 从用户中心获取优惠券信息通知
static NSString *const NotificationUserLoginInvalid = @"UserLoginInvalid";  ///< 用户登录失效
static NSString *const NotificationUserSignout      = @"UserSignOut";       ///< 退出登录
static NSString *const NotificationUserLoginSuccess = @"UserLoginInSuccess";///< 用户登录成功
static NSString *const NotificationReSetPassword = @"reSetPasswordSuccess";///< 用户登录成功
static NSString *const NotificationUpdateUserLoginStatus = @"UpdateUserLoginStatus";///< 用户登录状态更新导致页面显示隐藏的变化
static NSString *const NotificationUserLoginH5Success = @"UserLoginInH5Success";///< 用户登录H5成功  区别是否去往首页
static NSString *const NotificationUserLoginCancel  = @"UserLoginCancel";   ///< 用户取消登录

static NSString *const NotificationHomePageViewShow = @"HomePageViewShow"; ///< 显示首页

static NSString *const NotificationAppWillEnterForeground = @"appWillEnterForeground"; ///< app进入前台通知
static NSString *const NotificationIndexLoadSuccess = @"IndexLoadSuccess";///< 首页请求成功
static NSString *const NotificationUserLoginInAnotherLocation = @"UserLoginInAnotherLocation";  ///< 用户在别的地方登录
//static NSString *const RESUME_ANIMATIONS =  @"view_ANIMATIONS";
static NSString *const NotificationRefreshTradeList =   @"NotificationRefreshTradeList";
static NSString *const NotificationGoToHomePage =   @"NotificationGoToHomePage";
static NSString *const NotificationReviewUpdateMenu = @"ReviewUpdateMenu";///< 用户登录成功
static NSString *const WechatStatueStr = @"AppGetUserInfoForBind";

static NSString *const NotificationRefreshWebBassets =   @"NotificationRefreshWeBassets"; // 刷新web
#endif /* BHNotificationConstant_h */
