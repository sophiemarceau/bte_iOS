//
//  AppDelegate.m
//  BTE
//
//  Created by wangli on 2018/1/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "AppDelegate.h"
#import "EAIntroView.h" //引导图
#import "BHVersionTool.h" //版本升级

#import <Bugly/Bugly.h> //腾讯Bugly
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMErrorCatch/UMErrorCatch.h>
#import <UMShare/UMShare.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "BTEHomeWebViewController.h"
#import "ViewController.h"
#import "MyAccountViewController.h"
#import "BTEHomePageViewController.h"
#import "BTEStrategyFollowViewController.h"
#import "BTEScoreView.h"
#import "LBTabBar.h"
#import "LBTabBarController.h"
#import "BTEHomePageViewController.h"
#import "BTEHomeWebViewController.h"
#import "PhoneInfo.h"
#import "WXApi.h"
#import "WXApiManager.h"
@interface AppDelegate ()<EAIntroDelegate,JPUSHRegisterDelegate,UITabBarControllerDelegate>
{
    NSDate *lastTimeStamp;//首次记录时间
    NSString *lastVersion;//首次记录版本
    NSDate *lastTimeStampScore;//首次记录时间评分
    LBTabBarController *tabBarVc;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 启动图片延时: 1秒
    //    [NSThread sleepForTimeInterval:3];
//    NSDictionary *resultDic = launchOptions[@"UIApplicationLaunchOptionsRemoteNotificationKey"];
//    if (resultDic) {//推送进入APP
//        _jPushDic=resultDic;
//        [self performSelector:@selector(postNoti) withObject:nil afterDelay:2];
//    }
    //去掉红点
    application.applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
    
    [self setupKeyWindow];
    
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
        NSLog(@"-WXApi---log : %@", log);
    }];
    //微信注册
    [WXApi registerApp:kWechatAppKey];
    
    // 引导图
    [self _showGuideView];
    //腾讯Bugly
    [Bugly startWithAppId:BuglyAppId];
    [self setUMengInit]; //友盟初始化相关
    [self setJPush:launchOptions]; //Jpush
    [self initHuaXin];//环信初始化
    // 修改 网页user-agent
    [self sendUserAgent];
    
    //通知开关检测
    [self checkNotification];
    //评分检测
    [self checkScore];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"url-openURL--->%@",url.scheme);
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isEable) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    NSLog(@"url-openURL--->%@",url.scheme);
    if([url.scheme isEqualToString:kWechatAppKey]){
        NSLog(@"url-openURL--->%@",url.absoluteString);
        if ([url.absoluteString rangeOfString:@"://oauth?code="].location != NSNotFound){
            NSArray * arr = [url.absoluteString componentsSeparatedByString:@"&state="];
            if (arr != nil && arr.count == 2 && [arr[1] isEqualToString:WechatStatueStr]) {
                return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
            }
        }
    }
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

-(void)checkNotification{
    if (IS_IOS_8) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
            [self checkNotificationTime];
        }
    }
}

-(void)checkScore{
    if (IS_IOS_8) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSLog(@"lastVersion = %@   CFBundleShortVersionString = %@",[defaults objectForKey:@"lastVersion"],[defaults objectForKey:@"lastTimeStampScore"]);
        if ([defaults objectForKey:@"lastVersion"]) {//覆盖安装
            if (![[defaults objectForKey:@"lastVersion"] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]) {
                if ([defaults objectForKey:@"lastTimeStampScore"]) {
                    NSDate *date = [NSDate date];
                    //计算时间间隔（单位是秒）
                    lastTimeStampScore = [defaults objectForKey:@"lastTimeStampScore"];
                    NSTimeInterval time = [date timeIntervalSinceDate:lastTimeStampScore];
                    if (time >= TimeString) {
                        [defaults setObject:nil forKey:@"lastTimeStampScore"];
                        
                        
                        [BTEScoreView popActivateNowCallBack:^{
                            lastVersion = [[[NSBundle mainBundle] infoDictionary]
                                           objectForKey:@"CFBundleShortVersionString"];
                            [defaults setObject:lastVersion forKey:@"lastVersion"];
                            
                            NSURL *url = [NSURL URLWithString:kAppStoreCommentAddress];
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                [[UIApplication sharedApplication] openURL:url];
                            }
                        } cancelCallBack:^{
                            lastTimeStampScore = [NSDate date];
                            [defaults setObject:lastTimeStampScore forKey:@"lastTimeStampScore"];
                        }];
                    }
                } else
                {
                    lastTimeStampScore = [NSDate date];
                    [defaults setObject:lastTimeStampScore forKey:@"lastTimeStampScore"];
                }
            }
        } else//首次安装 包括卸载后安装
        {
            if ([defaults objectForKey:@"lastTimeStampScore"]) {
                NSDate *date = [NSDate date];
                //计算时间间隔（单位是秒）
                lastTimeStampScore = [defaults objectForKey:@"lastTimeStampScore"];
                NSTimeInterval time = [date timeIntervalSinceDate:lastTimeStampScore];
                if (time >= TimeString) {
                    [defaults setObject:nil forKey:@"lastTimeStampScore"];
                    [BTEScoreView popActivateNowCallBack:^{
                        lastVersion = [[[NSBundle mainBundle] infoDictionary]
                                       objectForKey:@"CFBundleShortVersionString"];
                        [defaults setObject:lastVersion forKey:@"lastVersion"];
                        
                        NSURL *url = [NSURL URLWithString:kAppStoreCommentAddress];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    } cancelCallBack:^{
                        lastTimeStampScore = [NSDate date];
                        [defaults setObject:lastTimeStampScore forKey:@"lastTimeStampScore"];
                    }];
                }
            } else
            {
                lastTimeStampScore = [NSDate date];
                [defaults setObject:lastTimeStampScore forKey:@"lastTimeStampScore"];
            }
        }
    }
}

-(void)checkNotificationTime{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"lastTimeStamp"]) {
        NSDate *date = [NSDate date];
        //计算时间间隔（单位是秒）
        lastTimeStamp = [defaults objectForKey:@"lastTimeStamp"];
        NSTimeInterval time = [date timeIntervalSinceDate:lastTimeStamp];
        if (time >= TimeString) {
            [defaults setObject:nil forKey:@"lastTimeStamp"];
            //弹框
            NSString *message = NSLocalizedString(@"为了为您提供更好的服务，建议您打开消息通知",nil);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            //改变message的大小和颜色
            NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
            [messageAtt addAttribute:NSFontAttributeName value:UIFontRegularOfSize(14) range:NSMakeRange(0, message.length)];
            [messageAtt addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"626A75") range:NSMakeRange(0, message.length)];
            [alertController setValue:messageAtt forKey:@"attributedMessage"];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"设置",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:sureAction];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    } else
    {
        lastTimeStamp = [NSDate date];
        [defaults setObject:lastTimeStamp forKey:@"lastTimeStamp"];
    }
}

#pragma mark - Actions
#pragma mark - webview与H5交互
/**
 发送safari user-agent信息
 */
-(void)sendUserAgent{
    
    UIWebView *webView = [[UIWebView alloc] init];
    
    //区分客户端与其它端
    NSString *TERMINAL = @"bteAPP";
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    if (![oldAgent hasSuffix:TERMINAL]) {
        
        NSString *version =  [[[NSBundle mainBundle] infoDictionary]
                              objectForKey:@"CFBundleShortVersionString"];
        NSString *str = [NSString stringWithFormat:@" %@/%@",TERMINAL,version];
        NSString *newAgent = [oldAgent stringByAppendingString:str];
        NSDictionary *dictionnary = @{@"UserAgent":newAgent};
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
}

- (void)setupKeyWindow {
    tabBarVc = [[LBTabBarController alloc] init];
    tabBarVc.delegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    //请求版本更新 （注意一定要在初始化网络之后加载）
    [BHVersionTool requestAppVersion:tabBarVc.viewControllers[0]];
    
    self.window.rootViewController = tabBarVc;
}

#pragma mark - tabbar 代理及属性修改方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[BHNavigationController class]]) {
        BHNavigationController *temNav = (BHNavigationController *)viewController;
        if (temNav.viewControllers.count > 1) {
            [temNav popToRootViewControllerAnimated:NO];
        }
    }
//    if (tabBarController.viewControllers.count == 4) {
//        if (tabBarController.selectedIndex == 3) {
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:@"pesonalCenter" forKey:@"pesonalCenter"];
//            [defaults synchronize];
//        }
//    }
//
//    if (tabBarController.viewControllers.count == 5) {
//        if (tabBarController.selectedIndex == 4) {
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:@"pesonalCenter" forKey:@"pesonalCenter"];
//            [defaults synchronize];
//        }
//    }
}

#pragma mark - UMeng初始化相关
- (void)setUMengInit {
    
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:UMENGKEY channel:@"App Store"];//初始化
    //调试模式此函数不起作用 错误捕获
    [UMErrorCatch initErrorCatch];
    // 统计组件配置 也可不设置 有默认配置
    [MobClick setScenarioType:E_UM_NORMAL];
    //分享平台初始化
    [self setupUSharePlatforms];
}

#pragma mark - 环信初始化相关
-(void)initHuaXin{
    EMOptions *options = [EMOptions optionsWithAppkey:kIMAppKey];
    options.enableConsoleLog = YES;
    options.isDeleteMessagesWhenExitChatRoom = NO;
//    options.apnsCertName = @"istore_dev";
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (!error) {
//        NSLog(@"环信 初始化成功！");
        [self setHuaXinLogin];
    }else{
        NSLog(@"环信 初始化错误！%@",error);
    }
}

- (void)setupUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAppKey appSecret:kWechatAppSecret redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106634295"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"949809257"  appSecret:@"9cd222420c53f0e27fd5b371fdc4be1d" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 钉钉的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
    
    /* 支付宝的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:nil];
    
    
    /* 设置易信的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置点点虫（原来往）的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置领英的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
    
    /* 设置Twitter的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    
    /* 设置Facebook的appKey和UrlString */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:nil];
    
    /* 设置Pinterest的appKey */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
    
    /* dropbox的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
    
    /* vk的appkey */
//    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];
    
}

#pragma mark - JPush 极光初始化
- (void)setJPush:(NSDictionary *)launchOptions {
    //Required
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
#ifdef DEBUG
    [JPUSHService setupWithOption:launchOptions appKey:JPushKEY
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
#else
    [JPUSHService setupWithOption:launchOptions appKey:JPushKEY
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
#endif
}

#pragma mark- JPUSHRegisterDelegate JPush 回调方法 在app里 会调这个方法收到推送通知
// iOS 10 Support//前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"jpushNotificationCenter -------willPresentNotification");
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
    
    if ([userInfo objectForKey:@"target"] && ![[userInfo objectForKey:@"target"] isEqualToString:@""])//前台
    {
        _jPushDic=userInfo;
        NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"比特易"
                                                            message:[NSString stringWithFormat:@"%@", alert]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"查看",nil];
        [alertView show];
    }
    
    if ([userInfo objectForKey:@"title"] && [[userInfo objectForKey:@"title"] isEqualToString:@"设备登录异常"])//前台
    {
        //退出成功删除手机号
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:MobilePhoneNum];
        //删除本地登录信息
        [User removeLoginData];
        
        
        _jPushDic=userInfo;
        NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        WS(weakSelf)
        NSString *message = NSLocalizedString(alert,nil);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        //改变message的大小和颜色
        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
        [messageAtt addAttribute:NSFontAttributeName value:UIFontRegularOfSize(16) range:NSMakeRange(0, message.length)];
        [messageAtt addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"626A75") range:NSMakeRange(0, message.length)];
        [alertController setValue:messageAtt forKey:@"attributedMessage"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            _jPushDic = nil;
            [weakSelf postNoti];
        }];
        [cancelAction setValue:BHHexColor(@"626A75") forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"重新登录",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf postNoti];
        }];
        [sureAction setValue:BHHexColor(@"37A2F6") forKey:@"_titleTextColor"];
        [alertController addAction:sureAction];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support//后台 JPush 回调方法 app里并没有打开 是从通知栏里点击进入app后 会调这个方法收到推送通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"jpushNotificationCenter----------didReceiveRemoteNotification");
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
    if ([userInfo objectForKey:@"target"] && ![[userInfo objectForKey:@"target"] isEqualToString:@""])
    {
        _jPushDic=userInfo;
        [self performSelector:@selector(postNoti) withObject:nil afterDelay:0.3];
    }
    if ([userInfo objectForKey:@"title"] && [[userInfo objectForKey:@"title"] isEqualToString:@"设备登录异常"])
    {
        //退出成功删除手机号
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:MobilePhoneNum];
        //删除本地登录信息
        [User removeLoginData];
        _jPushDic=userInfo;
        [self performSelector:@selector(postNoti) withObject:nil afterDelay:0.3];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    NSLog(@"application -------didReceiveRemoteNotification");
    NSLog(@"userInfo ---application----didReceiveRemoteNotification------>%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
//    if (application.applicationState == UIApplicationStateActive && [userInfo objectForKey:@"target"] && ![[userInfo objectForKey:@"target"] isEqualToString:@""])//前台
//    {
//        _jPushDic=userInfo;
//        NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"比特易"
//                                                            message:[NSString stringWithFormat:@"%@", alert]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"查看",nil];
//        [alertView show];
//    }
//    else if ([userInfo objectForKey:@"target"] && ![[userInfo objectForKey:@"target"] isEqualToString:@""])//后台
//    {
//        _jPushDic=userInfo;
//        [self performSelector:@selector(postNoti) withObject:nil afterDelay:0.3];
//    }
//
//
//
//    if (application.applicationState == UIApplicationStateActive && [userInfo objectForKey:@"title"] && [[userInfo objectForKey:@"title"] isEqualToString:@"设备登录异常"])//前台
//    {
//        //退出成功删除手机号
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:nil forKey:MobilePhoneNum];
//        //删除本地登录信息
//        [User removeLoginData];
//        _jPushDic=userInfo;
//        NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        WS(weakSelf)
//        NSString *message = NSLocalizedString(alert,nil);
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//        //改变message的大小和颜色
//        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
//        [messageAtt addAttribute:NSFontAttributeName value:UIFontRegularOfSize(16) range:NSMakeRange(0, message.length)];
//        [messageAtt addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"626A75") range:NSMakeRange(0, message.length)];
//        [alertController setValue:messageAtt forKey:@"attributedMessage"];
//
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            _jPushDic = nil;
//            [weakSelf postNoti];
//        }];
//        [cancelAction setValue:BHHexColor(@"626A75") forKey:@"_titleTextColor"];
//        [alertController addAction:cancelAction];
//        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"重新登录",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            [weakSelf postNoti];
//        }];
//        [sureAction setValue:BHHexColor(@"37A2F6") forKey:@"_titleTextColor"];
//        [alertController addAction:sureAction];
//        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//    } else if ([userInfo objectForKey:@"title"] && [[userInfo objectForKey:@"title"] isEqualToString:@"设备登录异常"])//后台
//    {
//        //退出成功删除手机号
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:nil forKey:MobilePhoneNum];
//        //删除本地登录信息
//        [User removeLoginData];
//        _jPushDic=userInfo;
//        [self performSelector:@selector(postNoti) withObject:nil afterDelay:0.3];
//    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    NSLog(@"application -------didReceiveRemoteNotification");
    [JPUSHService handleRemoteNotification:userInfo];
}

//上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    if ([JPUSHService registrationID]) {
    
        NSLog(@"*******get RegistrationID = %@ ",[JPUSHService registrationID]);
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = [JPUSHService registrationID];
    }
 
    
    
    
    
    
//    NSSet *set;
//    set = [NSSet setWithObjects:kGlobal,kindexDogPush,nil];
////    [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
////        NSLog(@"isrescode=%ld",iResCode);
////    } seq:1];
//    [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//        [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//            NSLog(@"getAllTags-isrescode=%ld",iResCode);
//            NSLog(@"getAllTags-iTags=%@",iTags);
//            NSLog(@"getAllTags-seq=%ld",seq);
//        } seq:1];
//    } seq:1];
    NSString *version =  [[[NSBundle mainBundle] infoDictionary]
                          objectForKey:@"CFBundleShortVersionString"];
    NSSet *set;
    set = [NSSet setWithObjects:@"iOS",@"debug",version,nil];
    [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//        NSLog(@"isrescode=%ld",iResCode);
        [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"login------getAllTags-isrescode=%ld",iResCode);
            NSLog(@"login------getAllTags-iTags=%@",iTags);
            NSLog(@"login------getAllTags-seq=%ld",seq);
        } seq:1];
    } seq:1];
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    if (buttonIndex == 1){
        [self postNoti];
    }
}

-(void)postNoti{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JpushNotice" object:_jPushDic];
}

#pragma mark EAIntroDelegate 版本引导图
- (void)_showGuideView {
    // 功能简介图
    if ([self isFirstLoad]) {
        [self showIntroWithCrossDissolve];
    }
}

- (BOOL)isFirstLoad {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    } else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}

-(void)introDidFinish {
    //no do somthing
}

- (void)showIntroWithCrossDissolve {
    NSMutableArray *pages = [NSMutableArray array];
    for (int i=1; i<=5; i++) {
        EAIntroPage *page = [EAIntroPage page];
        if(!IS_IPHONEX){
             page.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"show%d",i]];
        }else{
             page.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"show%dX",i]];
        }
       
        [pages addObject:page];
    }
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andPages:pages];
    intro.delegate=self;
    [intro showInView:self.window animateDuration:0.0];
}


- (void)setHuaXinLogin{
    //如果登录成功 并且 账号是个已经关联环信服务器的账号 则 去登录环信IM服务器
//    NSLog(@"UserToken----->%@",User.userToken);
//    NSLog(@"hxuserName----->%@",User.hxuserName);
//    NSLog(@"hxuserPassword----->%@",User.hxuserPassword);
//    NSLog(@"isLogin----->%d",User.isLogin);
    if (User.userToken) {
//         NSLog(@"use------->%@",User.hxuserName);
        if (User.hxuserName != nil) {
            [self loginHuaXinServer];
        }
    }
}
    
#pragma mark - 环信登录  //点击登录后的操作
//点击登录后的操作
- (void)loginHuaXinServer{
    BOOL isAutoLogin = [[EMClient sharedClient].options isAutoLogin];
    NSLog(@"isLoggedIn--------->%d",isAutoLogin);
    if (!isAutoLogin) {
        [[EMClient sharedClient] loginWithUsername:User.hxuserName password:User.hxuserPassword completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
            }else{
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
                NSLog(@"---loginWithUsername--password---aerror--->%@",aError.errorDescription);
            }
        }];
    }
}
// 退出环信
- (void)logoutHuaXinServer{
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
        NSLog(@"UserToken---退出成功-->%@",User.userToken);
        NSLog(@"hxuserName---退出成功-->%@",User.hxuserName);
        NSLog(@"hxuserPassword-退出成功---->%@",User.hxuserPassword);
        NSLog(@"isLogin--退出成功--->%d",User.isLogin);
    }
//    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
//        if (aError != nil) {
//            NSLog(@"huanxin-------logout--------->%@",aError.description);
//        }
//    }];
}

-(void)getReview{
    PhoneInfo * phone = [[PhoneInfo alloc] init];
    [YQNetworking getWithUrl:kAppVersion refreshRequest:NO cache:NO params:@{@"type":@"1",@"version":kCurrentVersion,@"channel":@"ios",@"sdkVersionName":phone.phoneVersion,@"Model":phone.platform,@"Brand":@"iphone"} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
    } successBlock:^(id response) {
        NSLog(@"---getReview-----%@",response);
        BHVersionItem * appItem = [BHVersionItem yy_modelWithDictionary:response[@"data"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:MobileTradeNum] ) {
            [defaults setObject:appItem.trade forKey:MobileTradeNum];
        }else{
            if ([[defaults objectForKey:MobileTradeNum] integerValue] != [appItem.trade integerValue] ) {
                [defaults setObject:appItem.trade forKey:MobileTradeNum];
                [defaults synchronize];
                 [[NSNotificationCenter defaultCenter]postNotificationName:NotificationReviewUpdateMenu object:nil];
            }
            [defaults setObject:appItem.trade forKey:MobileTradeNum];
        }
        [defaults synchronize];
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
