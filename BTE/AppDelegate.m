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
#import "UMMobClick/MobClick.h"

#import "ViewController.h"


@interface AppDelegate ()<EAIntroDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 启动图片延时: 1秒
//    [NSThread sleepForTimeInterval:3];
    
    [self setupKeyWindow];
    
    // 引导图
    [self _showGuideView];
    //腾讯Bugly
    [Bugly startWithAppId:BuglyAppId];
    [self setUMengAnalytics];
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

- (void)setupKeyWindow {
    BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];

    homePageVc.urlString = kAppBTEH5Address;
    homePageVc.isHiddenLeft = NO;
    homePageVc.isHiddenBottom = YES;
    
//    ViewController *homePageVc= [[ViewController alloc] init];
    BHNavigationController *NavVC = [[BHNavigationController alloc] initWithRootViewController:homePageVc];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = NavVC;
    self.window.backgroundColor= [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //请求版本更新 （注意一定要在初始化网络之后加载）
    [BHVersionTool requestAppVersion:NavVC];
}
#pragma mark - UMeng统计
- (void)setUMengAnalytics {
    UMConfigInstance.appKey = UMENGKEY;
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
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

@end
