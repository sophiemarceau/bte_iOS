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
#import "BTEHomeWebViewController.h"
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

#import "ViewController.h"
#import "MyAccountViewController.h"
#import "BTEHomePageViewController.h"
#import "BTEStrategyFollowViewController.h"
@interface AppDelegate ()<EAIntroDelegate,JPUSHRegisterDelegate,UITabBarControllerDelegate>

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
    
    [self setupKeyWindow];
    
    // 引导图
    [self _showGuideView];
    //腾讯Bugly
    [Bugly startWithAppId:BuglyAppId];
    [self setUMengInit]; //友盟初始化相关
    [self setJPush:launchOptions]; //Jpush
    // 修改 网页user-agent
    [self sendUserAgent];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isEable) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
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
    //    BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
    
    //    homePageVc.urlString = kAppBTEH5Address;
    //    homePageVc.isHiddenLeft = YES;
    //    homePageVc.isHiddenBottom = YES;
    //
    ////    ViewController *homePageVc= [[ViewController alloc] init];
    //
    //    //登录成功跳转原生我的账户页面
    ////    MyAccountViewController *homePageVc = [[MyAccountViewController alloc] init];
    //
    //
    //    BHNavigationController *NavVC = [[BHNavigationController alloc] initWithRootViewController:homePageVc];
    
    //a.初始化一个tabBar控制器
    UITabBarController *tb=[[UITabBarController alloc]init];
    tb.delegate = self;
    //设置不透明
    [UITabBar appearance].translucent = NO;
    //b.创建子控制器
    
    BTEHomePageViewController *findePageVc= [[BTEHomePageViewController alloc] init];
    
//    BTEHomeWebViewController *findePageVc= [[BTEHomeWebViewController alloc] init];
//    findePageVc.urlString = kAppBTEH5AnalyzeAddress;
//    findePageVc.isHiddenLeft = YES;
//    findePageVc.isHiddenBottom = NO;
    BHNavigationController *findeNavVC = [[BHNavigationController alloc] initWithRootViewController:findePageVc];
    findeNavVC.view.backgroundColor=[UIColor whiteColor];
    findeNavVC.tabBarItem.title=@"市场分析";
    findeNavVC.tabBarItem.image=[[UIImage imageNamed:@"tab_ic_discover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findeNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_ic_discover_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self selectedTapTabBarItems:findeNavVC.tabBarItem];
    [self unSelectedTapTabBarItems:findeNavVC.tabBarItem];
    [self setTitleAdjustment:findeNavVC.tabBarItem];
    
    BTEStrategyFollowViewController *strategyFollowPageVc= [[BTEStrategyFollowViewController alloc] init];
//    BTEHomeWebViewController *strategyFollowPageVc= [[BTEHomeWebViewController alloc] init];
//    strategyFollowPageVc.urlString = kAppBTEH5FollowAddress;
//    strategyFollowPageVc.isHiddenLeft = YES;
//    strategyFollowPageVc.isHiddenBottom = NO;
    BHNavigationController *strategyFollowNavVC = [[BHNavigationController alloc] initWithRootViewController:strategyFollowPageVc];
    strategyFollowNavVC.view.backgroundColor=[UIColor whiteColor];
    strategyFollowNavVC.tabBarItem.title=@"策略跟随";
    strategyFollowNavVC.tabBarItem.image=[[UIImage imageNamed:@"tab_ic_tactics"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    strategyFollowNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_ic_tactics_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self selectedTapTabBarItems:strategyFollowNavVC.tabBarItem];
    [self unSelectedTapTabBarItems:strategyFollowNavVC.tabBarItem];
    [self setTitleAdjustment:strategyFollowNavVC.tabBarItem];
    
    MyAccountViewController *myAccountPageVc = [[MyAccountViewController alloc] init];
    BHNavigationController *myAccountNavVC = [[BHNavigationController alloc] initWithRootViewController:myAccountPageVc];
    myAccountNavVC.view.backgroundColor=[UIColor whiteColor];
    myAccountNavVC.tabBarItem.title=@"我的账户";
    myAccountNavVC.tabBarItem.image=[[UIImage imageNamed:@"tab_ic_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myAccountNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_ic_mine_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self selectedTapTabBarItems:myAccountNavVC.tabBarItem];
    [self unSelectedTapTabBarItems:myAccountNavVC.tabBarItem];
    [self setTitleAdjustment:myAccountNavVC.tabBarItem];
    
    
    //c.添加子控制器到ITabBarController中
    //c.1第一种方式
    //    [tb addChildViewController:c1];
    //    [tb addChildViewController:c2];
    
    //c.2第二种方式
    tb.viewControllers=@[findeNavVC,strategyFollowNavVC,myAccountNavVC];
    
    //修改tabbar边线颜色
//    [tb.tabBar setShadowImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(SCREEN_WIDTH,2)]];
//    tb.tabBar.opaque = NO;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    //请求版本更新 （注意一定要在初始化网络之后加载）
    [BHVersionTool requestAppVersion:findeNavVC];
    [self.window setRootViewController:tb];
    
}


#pragma mark - tabbar 代理及属性修改方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 1) {
        
        if ([viewController isKindOfClass:[BHNavigationController class]]) {
            BHNavigationController *temNav = (BHNavigationController *)viewController;
            if (temNav.viewControllers.count > 1) {
                [temNav popToRootViewControllerAnimated:NO];
            }
        }
    }
}



-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    NSDictionary *titleAttributesNormal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:BHHexColor(@"9CA1A9"), nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor, nil]];
    [tabBarItem setTitleTextAttributes:titleAttributesNormal forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    NSDictionary *titleAttributesSelected = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:BHHexColor(@"308CDD"), nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor, nil]];
    [tabBarItem setTitleTextAttributes:titleAttributesSelected forState:UIControlStateSelected];
}

- (void)setTitleAdjustment:(UITabBarItem *)tabBarItem{
    UIOffset titleOffset = UIOffsetMake(0, -2);
    [tabBarItem setTitlePositionAdjustment:titleOffset];
}


#pragma mark - UMeng初始化相关
- (void)setUMengInit {
    [UMConfigure initWithAppkey:UMENGKEY channel:@"App Store"];//初始化
    //调试模式此函数不起作用 错误捕获
    [UMErrorCatch initErrorCatch];
    // 统计组件配置 也可不设置 有默认配置
    [MobClick setScenarioType:E_UM_NORMAL];
    //分享平台初始化
    [self setupUSharePlatforms];
}


- (void)setupUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx82c2aa4fde147029" appSecret:@"913a1174fe05b529cb80d61a4278d248" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
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

#pragma mark - JPush
- (void)setJPush:(NSDictionary *)launchOptions {
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
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
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support//前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
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
    
    
    if ([userInfo objectForKey:@"type"] && ![[userInfo objectForKey:@"type"] isEqualToString:@""])//前台
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
}
// iOS 10 Support//后台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
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
    if ([userInfo objectForKey:@"type"] && ![[userInfo objectForKey:@"type"] isEqualToString:@""])
    {
        _jPushDic=userInfo;
        [self performSelector:@selector(postNoti) withObject:nil afterDelay:0.3];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (application.applicationState == UIApplicationStateActive && [userInfo objectForKey:@"type"] && ![[userInfo objectForKey:@"type"] isEqualToString:@""])//前台
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
    else if ([userInfo objectForKey:@"type"] && ![[userInfo objectForKey:@"type"] isEqualToString:@""])//后台
    {
        _jPushDic=userInfo;
        [self performSelector:@selector(postNoti) withObject:nil afterDelay:0.3];
    }
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

//上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSSet *set;
    set = [NSSet setWithObjects:@"global",nil];
    [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSLog(@"isrescode=%ld",iResCode);
    } seq:1];
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
    for (int i=1; i<=4; i++) {
        EAIntroPage *page = [EAIntroPage page];
        page.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"show%d",i]];
        [pages addObject:page];
    }
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andPages:pages];
    intro.delegate=self;
    [intro showInView:self.window.rootViewController.view animateDuration:0.0];
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    if (buttonIndex == 1)
    {
        [self postNoti];
    }
    
}
-(void)postNoti
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JpushNotice" object:_jPushDic];
    
}

@end
