//
//  FirstLevelWebViewController.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/25.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "FirstLevelWebViewController.h"
#import "ClearCacheTool.h"
#import "BTELoginVC.h"
#import "BTEInviteFriendViewController.h"
#import "BTEFeedBackViewController.h"
#import "BTEKlineViewController.h"
#import "HomeDesListModel.h"
//#import "SecondLevelWebViewController.h"
#import "SecondaryLevelWebViewController.h"
#import "BTEShareView.h"
#import "BTEInviteFriendViewController.h"
#import "BTEFeedBackViewController.h"
#import "ClearCacheTool.h"
#import "HomeDogCountModel.h"
#import "BTEFreandCountViewController.h"
//#import "BTEKlineWebViewController.h"

#import "JPUSHService.h"
@interface FirstLevelWebViewController (){
    NSString *luzhuangDogStr;
    NSString *luzhuangDogTitleStr;
}
//分享需要的参数
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;
@property (nonatomic, copy) ShareViewCallBack shareViewCallBack;
@end

@implementation FirstLevelWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
}

-(void)observeH5BridgeHandler {
    WS(weakSelf)
    // 登录
    [self.bridge registerHandler:@"loginApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"---registerHandler---loginApp-----%@",data);
        if (!STRISEMPTY(data[@"url"]) && [[data objectForKey:@"url"] rangeOfString:@"/wechat/iosaccount"].location == NSNotFound) {
            [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                if (isComplete) {
                    [weakSelf update];
                }
            }];
        }
    }];
    
    //发送token给H5
    [self sendUserToken];
    
    //退出登录
    [self.bridge registerHandler:@"loginOut" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--registerHandler----loginOut-----%@",data);
        //退出成功删除手机号
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:MobilePhoneNum];
        //删除本地登录信息
        [User removeLoginData];
        //发送通知告诉web token变动
        // 退出环信
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate logoutHuaXinServer];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
        [weakSelf update];
        [weakSelf.tabBarController setSelectedIndex:0];
    }];
    
    //邀请
    [self.bridge registerHandler:@"jumpToInvite" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToInvite----");
        BTEFreandCountViewController *invateVc = [[BTEFreandCountViewController alloc] init];
//        if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
//            invateVc.fromVCType = FromPersonVC;
//        }else{
//            invateVc.fromVCType = FromScroeVC;
//        }
        [weakSelf.navigationController pushViewController:invateVc animated:YES];
        
    }];
    
    //意见反馈
    [self.bridge registerHandler:@"Iosfeed" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"---registerHandler-Iosfeed-------%@",data);
        BTEFeedBackViewController *invateVc = [[BTEFeedBackViewController alloc] init];
        [weakSelf.navigationController pushViewController:invateVc animated:YES];
    }];
    
    //清理缓存
    [self.bridge registerHandler:@"Ioscache" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"---registerHandler--Ioscache------%@",data);
        [weakSelf clearUpdate];
        [self update];
    }];
    
    //关于我们官网跳转
    [self.bridge registerHandler:@"bteTop" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"---registerHandler-bteTop-------%@",data);
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://bte.top"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bte.top"]];
        }
    }];
    
    //跳转k线
    [self.bridge registerHandler:@"jumpToMarketDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"---registerHandler---jumpToMarketDetail-----%@",data);
        if (data && [data objectForKey:@"base"]) {
            BTEKlineViewController *homePageVc= [[BTEKlineViewController alloc] init];
            HomeDesListModel * delistModel = [[HomeDesListModel alloc] init];
            [delistModel initDict:data];
            //            homePageVc.isSmallBte = YES;
            homePageVc.desListModel = delistModel;
            [weakSelf.navigationController pushViewController:homePageVc animated:YES];
        }
    }];
    
    //市场分析详情点击返回首页
    [self.bridge registerHandler:@"jumpToDiscoverView" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"---registerHandler--jumpToDiscoverView------%@",self.urlString);
//        if (weakSelf.tabBarController.selectedIndex == 0) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//            [weakSelf reloadWebView:self.urlString];
//        } else
//        {
//            if (weakSelf.tabBarController.selectedIndex == 1) {
//
//                [weakSelf reloadWebView:self.urlString];
//                //                if (weakSelf.tabBarController.selectedIndex == 2) {
//                //                    self.sharetitle = luzhuangDogTitleStr;
//                //                    self.shareDesc = luzhuangDogStr;
//                ////                    weakSelf.navigationItem.title = @"撸庄狗";
//                //                }
//                //                if (weakSelf.tabBarController.selectedIndex == 1) {
//                ////                    weakSelf.navigationItem.title = @"行情数据";
//                //                }
//
//                // 强制显示tabbar
//                weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
//                weakSelf.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
//                weakSelf.tabBarController.tabBar.hidden = NO;
//                weakSelf.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
//                return ;
//            }
//
//            //策略 点击 回到首页
//            if (weakSelf.tabBarController.selectedIndex == 2) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGoToHomePage object:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//
//
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:@"top" forKey:@"top"];
//            [defaults synchronize];
//            [weakSelf.tabBarController setSelectedIndex:0];
//        }
    }];
    
    //h5市场分析详情页 点击调起分享
    [self.bridge registerHandler:@"touchShare" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"i send touchShare registerHandler---%@",data);
//
//        NSLog(@"weakSelf.tabBarController.selectedIndex---->%ld",weakSelf.tabBarController.selectedIndex);
//        NSLog(@"weakSelf.tabBarController.selectedIndex--title-->%@",weakSelf.navigationItem.title);
//        if (weakSelf.tabBarController.selectedIndex == 2 && [weakSelf.navigationItem.title  isEqual: @"比特易赚积分秘籍"]){
//            [weakSelf shareAlert];
//            return ;
//        }
//
//        if (weakSelf.tabBarController.selectedIndex == 2 && ![weakSelf.navigationItem.title  isEqual: @"撸庄狗每周战报"]){
//            if (data && [data objectForKey:@"id"]) {
//                weakSelf.isHiddenLeft = NO;
//                [weakSelf reloadWebView: [NSString stringWithFormat:@"%@/%@",kAppDetailDealAddress, [data objectForKey:@"id"]]];
//                return;
//            }
//        }
        
        //        if (weakSelf.tabBarController.selectedIndex == 0 && [weakSelf.navigationItem.title  isEqual: @"比特易赚积分秘籍"]){
        //            if (data && [data objectForKey:@"id"]) {
        //                weakSelf.isHiddenLeft = NO;
        //                [weakSelf reloadWebView: [NSString stringWithFormat:@"%@/%@",kAppDetailDealAddress, [data objectForKey:@"id"]]];
        //                return;
        //            }
        //        }
        
        
//        [weakSelf shareAlert];
    }];
    
    //标识是否是index页面 隐藏左返回键
    [self.bridge registerHandler:@"oneClass" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"------registerHandler-----------oneClass---%@",data);
        
        if (data) {
            int flag = [[data objectForKey:@"isOpenDog"] intValue];
            if (flag){
//                NSSet *set;
//                set = [NSSet setWithObjects:klzDogVotePush,nil];
//                [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                     NSLog(@"iTags---add---klzDogVotePush-->%@",iTags);
//                    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                        NSLog(@"iTags---getAllTags---klzDogVotePush-->%@",iTags);
//                    } seq:1];
//                } seq:1];
            }
        }
        
        if (data) {
            int flag = [[data objectForKey:@"isBandDog"] intValue];
//            NSSet *set;
//            set = [NSSet setWithObjects:kbandDogPush,nil];
//            if (flag){
//                
//                [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                        NSLog(@"iTags-----add kbandDogPush--->%@",iTags);
//                    } seq:1];
//                } seq:1];
//                
//            }
        }
        
        if(self.tabBarController.selectedIndex != 3){
            weakSelf.isHiddenLeft = YES;
            return;
        }
        
        if (data && [data objectForKey:@"title"]) {
            if ([[data objectForKey:@"title"] isEqualToString:@"个人中心"]) {
                weakSelf.isHiddenLeft = NO;
                [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
                if (_statusBarView == nil) {
                    //设置状态栏颜色
                    _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    weakSelf.view.bounds.size.width, STATUS_BAR_HEIGHT)];
                    _statusBarView.backgroundColor = BHHexColor(@"168BF0");
                    [weakSelf.view addSubview:_statusBarView];
                }
                // 强制显示tabbar
                weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
                weakSelf.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
                weakSelf.tabBarController.tabBar.hidden = NO;
                weakSelf.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
            }
        }
        
        
        //        weakSelf.isHiddenLeft = YES;
//        weakSelf.isOneClass = YES;
//        if (data) {
//            int flag = [[data objectForKey:@"isOpenDog"] intValue];
//            if (flag){
//                NSSet *set;
//                set = [NSSet setWithObjects:klzDogVotePush,nil];
//                [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                        NSLog(@"iTags---add---klzDogVotePush-->%@",iTags);
//                    } seq:1];
//                } seq:1];
//            }
//        }
//
//        if (data) {
//            int flag = [[data objectForKey:@"isBandDog"] intValue];
//            NSSet *set;
//            set = [NSSet setWithObjects:kbandDogPush,nil];
//            if (flag){
//
//                [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                        NSLog(@"iTags-----add kbandDogPush--->%@",iTags);
//                    } seq:1];
//                } seq:1];
//
//            }
//        }
//
//
//        if (data && [data objectForKey:@"title"]) {
//            if ([[data objectForKey:@"title"] isEqualToString:@"个人中心"]) {
//                [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
//                if (_statusBarView == nil) {
//                    //设置状态栏颜色
//                    _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    weakSelf.view.bounds.size.width, STATUS_BAR_HEIGHT)];
//                    _statusBarView.backgroundColor = BHHexColor(@"168BF0");
//                    [weakSelf.view addSubview:_statusBarView];
//                }
//            } else
//            {
//                weakSelf.navigationItem.title = [data objectForKey:@"title"];
//                weakSelf.navigationItem.rightBarButtonItem = nil;
//            }
//        }
//        if (![self.urlString isEqualToString:kAppBrandDogAddress]) {
//            // 强制显示tabbar
//            weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
//            weakSelf.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
//            weakSelf.tabBarController.tabBar.hidden = NO;
//            weakSelf.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
//        }
        
    }];
    
    //标识是否是index页面 显示左返回键
    [self.bridge registerHandler:@"twoIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"----registerHandler------twoIndex---%@",data);
         weakSelf.isHiddenLeft = NO;
//        weakSelf.isOneClass = NO;

        if (data && [data objectForKey:@"title"]) {
            weakSelf.navigationItem.title = [data objectForKey:@"title"];
            
            //因为 是在本webview页面 点击事件 导致h5页面刷新
            //所以 为了 装扮成二级页面 效果
            //捕捉到该回调后 显示 左上角 返回键 并且强制隐藏 tabbar  并显示出导航栏 删除上面的蓝色状态栏
            //从而装扮出 装扮成二级页面 效果
            // 强制隐藏tabbar
            //        SCREEN_HEIGHT- NAVIGATION_HEIGHT  -  HOME_INDICATOR_HEIGHT
            weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
            weakSelf.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
            weakSelf.tabBarController.tabBar.hidden = YES;
            weakSelf.tabBarController.tabBar.height = 0;
            [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
            [_statusBarView removeFromSuperview];
            _statusBarView = nil;
            
            
        }
        
       
//
//        if (data && [data objectForKey:@"url"]) {
//            weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItem];
//            weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
//            if ([[data objectForKey:@"url"] rangeOfString:@"wechat/strategyDetail/"].location != NSNotFound) {
//                weakSelf.sharetitle = [NSString stringWithFormat:@"比特易—%@,当前收益%@%%",weakSelf.productInfoModel.name,weakSelf.productInfoModel.ror];
//                weakSelf.shareDesc =  [NSString stringWithFormat:@"我跟随了比特易%@，当前收益%@%%，比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，玩转比特币，多看比特易。",weakSelf.productInfoModel.name,weakSelf.productInfoModel.ror];
//
//            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/marketDetail/"].location != NSNotFound)
//            {
//                weakSelf.sharetitle = @"比特易—数字货币分析平台";
//                NSString *price = [NSString positiveFormat:weakSelf.desListModel.price];
//                weakSelf.shareDesc = [NSString stringWithFormat:@"%@当前价格：$%@\t\n走势分析：%@\t\n操作建议：%@",weakSelf.desListModel.symbol,price,weakSelf.desListModel.trend,weakSelf.desListModel.operation];
//
//                if (weakSelf.tabBarController.selectedIndex == 1) {
//                    weakSelf.isHiddenLeft = YES;
//                    weakSelf.navigationItem.rightBarButtonItem = nil;
//                }
//
//            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/researchReport/"].location != NSNotFound)
//            {
//                weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItemDetail];
//                weakSelf.sharetitle = [NSString stringWithFormat:@"%@",[data objectForKey:@"type"]];
//                weakSelf.shareDesc = [data objectForKey:@"summary"];
//            }else if([[data objectForKey:@"url"] rangeOfString:@"wechat/featureReport"].location != NSNotFound){
//                weakSelf.isHiddenLeft = YES;
//                NSString  *week_income = [NSString stringWithFormat:@"%.2f", [[data objectForKey:@"week_income"] floatValue]];
//                NSString  *week_count = [data objectForKey:@"week_count"] ;
//                if (week_income && week_count) {
//                    self.sharetitle = [NSString stringWithFormat: @"撸庄狗周报-本周共撸%@次，收益%@%@",week_count,week_income,@"%"];
//                    self.shareDesc = [NSString stringWithFormat:@"撸庄狗是通过人工智能结合交易专家分析，实时预判并提示小币种拉盘、出货等各种迹象的工具、本周收益%@%@",week_income,@"%"];
//                }
//                self.shareUrl = self.urlString;
//            }
//            weakSelf.shareUrl = [data objectForKey:@"url"];
//        } else
//        {
//            weakSelf.navigationItem.rightBarButtonItem = nil;
//        }
//
//
//        // 强制隐藏tabbar
//        //        SCREEN_HEIGHT- NAVIGATION_HEIGHT  -  HOME_INDICATOR_HEIGHT
//        weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
//        weakSelf.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
//        weakSelf.tabBarController.tabBar.hidden = YES;
//        weakSelf.tabBarController.tabBar.height = 0;
//        [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
//        [_statusBarView removeFromSuperview];
//        _statusBarView = nil;
    }];
    
    //h5页面 撸庄狗 中点击获取积分 跳转到获取积分页面
    [self.bridge registerHandler:@"jumpToPoint" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToPoint----");
        if (data && [data objectForKey:@"source"]) {
            NSString *urlStr = [NSString stringWithFormat:@"%@?source=%@",kAppBTEH5integralCheatsAddress, [data objectForKey:@"source"]];
            SecondaryLevelWebViewController * secondLevelVc = [[SecondaryLevelWebViewController alloc] init];
            secondLevelVc.urlString = urlStr;
            secondLevelVc.isHiddenLeft = YES;
            secondLevelVc.isHiddenBottom = YES;
            
            secondLevelVc.sharetitle = luzhuangDogTitleStr = @"撸庄狗-韭菜撸庄利器";
            secondLevelVc.shareUrl = self.urlString;
            secondLevelVc.shareType = UMS_SHARE_TYPE_WEB_LINK;
            [self.navigationController pushViewController:secondLevelVc animated:YES];
        }
        

    }];
    
    //h5首页 每周战报 跳转到二级页面 周报
    [self.bridge registerHandler:@"jumpToWeekReport" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToWeekReport----");
        
        SecondaryLevelWebViewController * secondLevelVc = [[SecondaryLevelWebViewController alloc] init];
        secondLevelVc.urlString = kAppBTEH5featureReportAddress;
        secondLevelVc.isHiddenLeft = YES;
        secondLevelVc.isHiddenBottom = YES;
        secondLevelVc.isFromReviewLuZDog = YES;
        [self.navigationController pushViewController:secondLevelVc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)addNotification {
    //直接是 行情列表页面的时候才添加此 通知 监听
    if ([self.urlString isEqualToString:kAppBTEH5TradDataAddress]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:NotificationRefreshTradeList object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:NotificationReSetPassword object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendUserTokenAndReloadWebView) name:NotificationUserLoginSuccess object:nil];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //个人中心
    if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
         //设置状态栏颜色
        if (_statusBarView == nil){
            //设置状态栏颜色
            _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, STATUS_BAR_HEIGHT)];
            _statusBarView.backgroundColor = BHHexColor(@"168BF0");
            [self.view addSubview:_statusBarView];
        }
        //由于个人中心 强制隐藏 导航栏 导致适配页面的 做的特殊处理
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT -STATUS_BAR_HEIGHT);
        self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
        //获取登录状态
        self.view.alpha = 0;
        [self getMyAccountLoginStatus];
    }
    
    //撸庄狗
    if ([self.urlString isEqualToString:kAppBTEH5DogAddress]) {
        self.title = @"撸庄狗";
        self.navigationItem.rightBarButtonItem = [self creatRightBarItemDetail];
        self.sharetitle = luzhuangDogTitleStr = @"撸庄狗-韭菜撸庄利器";
        self.shareUrl = self.urlString;
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;
        [self getUserCountAndincome];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendUserToken];
    });
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_statusBarView removeFromSuperview];
    _statusBarView = nil;
}


#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    NSString *numHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = numHtmlInfo;
}

#pragma mark - sendUserToken
- (void)sendUserToken{
    NSLog(@"i send userToken ---%@",User.userToken);
    [self.bridge registerHandler:@"sendUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"i send userToken -sendUserInfo--%@",data);
        NSString *tmpSize = [ClearCacheTool getCacheSize];
        if ([tmpSize isEqualToString:@"0.0B"]) {
            tmpSize = @"0M";
        }
        responseCallback(@{@"sessionId": User.userToken,@"bufferSize": tmpSize});
    }];
}

- (void)update {
    [self reloadWebView:self.urlString];
}

- (void)sendUserTokenAndReloadWebView{
    [self sendUserToken];
    [self update];
}

- (void)clearUpdate{
    [ClearCacheTool clearCaches];
    [BHToast showMessage:@"缓存清理完毕"];
    [self sendUserToken];
}

#pragma mark - goback返回
- (void)goback {
//    UINavigationController *nav = self.tabBarController.selectedViewController;
//    if ([self.webView canGoBack]) {
//        if ([nav.visibleViewController.navigationItem.title isEqualToString:@"比特易赚积分秘籍"]) {
//            self.tabBarController.tabBar.hidden = NO;
//            self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT  - (self.isHiddenBottom ? HOME_INDICATOR_HEIGHT : TAB_BAR_HEIGHT));
//            self.view.height = SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT;
//        }
//
//
//    }
    [super goback];
    UINavigationController *nav = self.tabBarController.selectedViewController;
    NSLog(@"nav.visibleViewController.navigationItem.title-------->%@",nav.visibleViewController.navigationItem.title);
    if ([nav.visibleViewController.navigationItem.title isEqualToString:@"关于"]) {
        [self sendUserToken];
        [self update];
    }
}

- (void)shareAlert{
    [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];      
}

#pragma mark - get Data From Server

#pragma mark - 获取登录状态
- (void)getMyAccountLoginStatus{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetUserLoginInfo;
    
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        //        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 0) {//未登录
            [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                if (isComplete) {
                    //登录成功刷新我的账户页面
                    //获取账户基本信息
                    [weakSelf update];
                    [weakSelf sendUserToken];
                    [weakSelf.tabBarController setSelectedIndex:0];
                } else
                {
                    [weakSelf.tabBarController setSelectedIndex:0];
                }
            }];
            
        } else if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 1)//已登录
        {
            weakSelf.view.alpha = 1;
            [weakSelf sendUserToken];
            //            [weakSelf update];
        }
    } failure:^(NSError *error) {
        weakSelf.view.alpha = 1;
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)getUserCountAndincome{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kFromSummaryCountAndincome;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        //        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            HomeDogCountModel * homedogCountModel = [[HomeDogCountModel alloc] init];
            homedogCountModel.income = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalIncome"]];
            homedogCountModel.userCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCount"]];
            homedogCountModel.recentCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"recentRecommendCount"]];
            //[HomeDogCountModel yy_modelWithDictionary:responseObject[@"data"]];
            NSString  *incomePercent = [NSString stringWithFormat:@"%.2f", [homedogCountModel.income floatValue]];
            luzhuangDogStr =  [NSString stringWithFormat:@"撸庄狗是通过人工智能结合交易专家分析，实时预判并提示小币种拉盘、出货等各种迹象的工具。近30天收益%@%@",incomePercent,@"%"];
            weakSelf.shareDesc = luzhuangDogStr;
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark - Navigation
- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"Group 24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (UIBarButtonItem *)creatRightBarItemDetail {
    UIImage *buttonNormal = [[UIImage imageNamed:@"Group 24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

@end
