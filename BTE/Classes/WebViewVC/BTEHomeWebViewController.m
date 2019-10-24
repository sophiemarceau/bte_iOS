//
//  BTEHomeWebViewController.m
//  BTE
//
//  Created by wangli on 2018/1/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEHomeWebViewController.h"
#import "BTELoginVC.h"
#import "MyAccountViewController.h"
#import "BTEShareView.h"
#import "BTEInviteFriendViewController.h"
#import "BTEFeedBackViewController.h"
#import "ClearCacheTool.h"
#import "HomeDogCountModel.h"
//#import "BTEKlineWebViewController.h"
#import "BTEKlineViewController.h"
#import "JPUSHService.h"

@interface BTEHomeWebViewController (){
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

@property (nonatomic, assign) BOOL isFirstLoad;//记录首次加载
@property (nonatomic, assign) BOOL isOneClass;//记录是否一级页面

@property (nonatomic,assign) BOOL isHiddetabBar;
@end

@implementation BTEHomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addNotification];
    
    _isFirstLoad = YES;

    if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
        //初始化为0
        self.isloginAndGetMyAccountInfo = @"0";
    }
    
    //活动详情页
    if (self.ActivityId) {
        [self ActivityIdDetail];
    }
    
    if ([self.isPersonalCenter isEqualToString:@"1"]) {
        // 强制显示tabbar
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
        self.view.height = SCREEN_HEIGHT;
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationRefreshTradeList object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationReSetPassword object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendUserTokenAndReloadWebView) name:NotificationUserLoginSuccess object:nil];
}



- (void)update {
    [self reloadWebView:self.urlString];
}

-(void)observeH5BridgeHandler {
    WS(weakSelf)
    // 登录
    [self.bridge registerHandler:@"loginApp" handler:^(id data, WVJBResponseCallback responseCallback) {
         NSLog(@"---registerHandler---loginApp-----%@",data);
        if (!STRISEMPTY(data[@"url"]) && [[data objectForKey:@"url"] rangeOfString:@"/wechat/iosaccount"].location == NSNotFound) {
            [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                if (isComplete) {
                    [weakSelf sendUserToken];
                    [weakSelf reloadWebView:data[@"url"]];
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
        weakSelf.isloginAndGetMyAccountInfo = @"0";
        [weakSelf update];
        [weakSelf.tabBarController setSelectedIndex:0];
    }];
    
    //邀请
    [self.bridge registerHandler:@"jumpToInvite" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToInvite----");
        BTEInviteFriendViewController *invateVc = [[BTEInviteFriendViewController alloc] init];
        if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
            invateVc.fromVCType = FromPersonVC;
        }else{
            invateVc.fromVCType = FromScroeVC;
        }
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
        if (weakSelf.tabBarController.selectedIndex == 0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf reloadWebView:self.urlString];
        } else
        {
            if (weakSelf.tabBarController.selectedIndex == 1) {
                
                [weakSelf reloadWebView:self.urlString];
//                if (weakSelf.tabBarController.selectedIndex == 2) {
//                    self.sharetitle = luzhuangDogTitleStr;
//                    self.shareDesc = luzhuangDogStr;
////                    weakSelf.navigationItem.title = @"撸庄狗";
//                }
//                if (weakSelf.tabBarController.selectedIndex == 1) {
////                    weakSelf.navigationItem.title = @"行情数据";
//                }
                
                // 强制显示tabbar
                weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
                weakSelf.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
                weakSelf.tabBarController.tabBar.hidden = NO;
                weakSelf.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
                return ;
            }
            
            //策略 点击 回到首页
            if (weakSelf.tabBarController.selectedIndex == 2) {
               [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGoToHomePage object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
           
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"top" forKey:@"top"];
            [defaults synchronize];
            [weakSelf.tabBarController setSelectedIndex:0];
        }
    }];
    
    //h5市场分析详情页 点击调起分享
    [self.bridge registerHandler:@"touchShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"i send touchShare registerHandler---%@",data);
        
        NSLog(@"weakSelf.tabBarController.selectedIndex---->%ld",weakSelf.tabBarController.selectedIndex);
        NSLog(@"weakSelf.tabBarController.selectedIndex--title-->%@",weakSelf.navigationItem.title);
        if (weakSelf.tabBarController.selectedIndex == 2 && [weakSelf.navigationItem.title  isEqual: @"比特易赚积分秘籍"]){
            [weakSelf shareAlert];
            return ;
        }
        
        if (weakSelf.tabBarController.selectedIndex == 2 && ![weakSelf.navigationItem.title  isEqual: @"撸庄狗每周战报"]){
            if (data && [data objectForKey:@"id"]) {
                weakSelf.isHiddenLeft = NO;
                [weakSelf reloadWebView: [NSString stringWithFormat:@"%@%@",kAppDetailDealAddress, [data objectForKey:@"id"]]];
                return;
            }
        }
        
//        if (weakSelf.tabBarController.selectedIndex == 0 && [weakSelf.navigationItem.title  isEqual: @"比特易赚积分秘籍"]){
//            if (data && [data objectForKey:@"id"]) {
//                weakSelf.isHiddenLeft = NO;
//                [weakSelf reloadWebView: [NSString stringWithFormat:@"%@/%@",kAppDetailDealAddress, [data objectForKey:@"id"]]];
//                return;
//            }
//        }
        
        
        [weakSelf shareAlert];
    }];
    
    //标识是否是index页面 隐藏左返回键
    [self.bridge registerHandler:@"oneClass" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"------registerHandler-----------oneClass---%@",data);
//        weakSelf.isHiddenLeft = YES;
        weakSelf.isOneClass = YES;
        if (data) {
            int flag = [[data objectForKey:@"isOpenDog"] intValue];
            if (flag){
//                NSSet *set;
//                set = [NSSet setWithObjects:klzDogVotePush,nil];
//                [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                        NSLog(@"iTags---add---klzDogVotePush-->%@",iTags);
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
        
        
        if (data && [data objectForKey:@"title"]) {
            if ([[data objectForKey:@"title"] isEqualToString:@"个人中心"]) {
                [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
                if (_statusBarView == nil) {
                    //设置状态栏颜色
                    _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    weakSelf.view.bounds.size.width, STATUS_BAR_HEIGHT)];
                    _statusBarView.backgroundColor = BHHexColor(@"168BF0");
                    [weakSelf.view addSubview:_statusBarView];
                }
            } else
            {
                weakSelf.navigationItem.title = [data objectForKey:@"title"];
                weakSelf.navigationItem.rightBarButtonItem = nil;
            }
        }
        if (![self.urlString isEqualToString:kAppBrandDogAddress]) {
            // 强制显示tabbar
            weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
            weakSelf.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
            weakSelf.tabBarController.tabBar.hidden = NO;
            weakSelf.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
        }
        
    }];
    
    //标识是否是index页面 显示左返回键
    [self.bridge registerHandler:@"twoIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"----registerHandler------twoIndex---%@",data);
        weakSelf.isHiddenLeft = NO;
        weakSelf.isOneClass = NO;

        if (data && [data objectForKey:@"title"]) {
            weakSelf.navigationItem.title = [data objectForKey:@"title"];
        }
        
        if (data && [data objectForKey:@"url"]) {
            weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItem];
            weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
            if ([[data objectForKey:@"url"] rangeOfString:@"wechat/strategyDetail/"].location != NSNotFound) {
                weakSelf.sharetitle = [NSString stringWithFormat:@"比特易—%@,当前收益%@%%",weakSelf.productInfoModel.name,weakSelf.productInfoModel.ror];
                weakSelf.shareDesc =  [NSString stringWithFormat:@"我跟随了比特易%@，当前收益%@%%，比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具。",weakSelf.productInfoModel.name,weakSelf.productInfoModel.ror];
                
            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/marketDetail/"].location != NSNotFound)
            {
                weakSelf.sharetitle = @"比特易—区块链市场数据分析工具";
                NSString *price = [NSString positiveFormat:weakSelf.desListModel.price];
                weakSelf.shareDesc = [NSString stringWithFormat:@"%@当前价格：$%@\t\n走势分析：%@\t\n操作建议：%@",weakSelf.desListModel.symbol,price,weakSelf.desListModel.trend,weakSelf.desListModel.operation];
                
               if (weakSelf.tabBarController.selectedIndex == 1) {
                   weakSelf.isHiddenLeft = YES;
                   weakSelf.navigationItem.rightBarButtonItem = nil;
                }
                
            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/researchReport/"].location != NSNotFound)
            {
                weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItemDetail];
                weakSelf.sharetitle = [NSString stringWithFormat:@"%@",[data objectForKey:@"type"]];
                weakSelf.shareDesc = [data objectForKey:@"summary"];
            }else if([[data objectForKey:@"url"] rangeOfString:@"wechat/featureReport"].location != NSNotFound){
                weakSelf.isHiddenLeft = YES;
                NSString  *week_income = [NSString stringWithFormat:@"%.2f", [[data objectForKey:@"week_income"] floatValue]];
                NSString  *week_count = [data objectForKey:@"week_count"] ;
                if (week_income && week_count) {
                    self.sharetitle = [NSString stringWithFormat: @"撸庄狗周报-本周共撸%@次，收益%@%@",week_count,week_income,@"%"];
                    self.shareDesc = [NSString stringWithFormat:@"撸庄狗是通过人工智能结合交易专家分析，实时预判并提示小币种拉盘、出货等各种迹象的工具、本周收益%@%@",week_income,@"%"];
                }
                self.shareUrl = self.urlString;
            }
            weakSelf.shareUrl = [data objectForKey:@"url"];
        } else
        {
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
        
    
        // 强制隐藏tabbar
        //        SCREEN_HEIGHT- NAVIGATION_HEIGHT  -  HOME_INDICATOR_HEIGHT
        weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
        weakSelf.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
        weakSelf.tabBarController.tabBar.hidden = YES;
        weakSelf.tabBarController.tabBar.height = 0;
        [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
        [_statusBarView removeFromSuperview];
        _statusBarView = nil;
    }];
    
    //h5页面 撸庄狗 波段狗 页 中点击获取积分 跳转到获取积分页面
    [self.bridge registerHandler:@"jumpToPoint" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToPoint----");
        if (data && [data objectForKey:@"source"]) {
            NSLog(@"--------registerHandler----jumpToPoint----%@", [data objectForKey:@"source"]);
        }
        weakSelf.isHiddenLeft = NO;
        NSString *urlStr = [NSString stringWithFormat:@"%@?source=%@",kAppBTEH5integralCheatsAddress, [data objectForKey:@"source"]];
        NSLog(@"--------urlStr----jumpToPoint----%@",urlStr);
        [weakSelf reloadWebView:urlStr];
        // 强制隐藏tabbar
        //        SCREEN_HEIGHT- NAVIGATION_HEIGHT  -  HOME_INDICATOR_HEIGHT
        weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
        weakSelf.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
        weakSelf.tabBarController.tabBar.hidden = YES;
//        weakSelf.tabBarController.tabBar.height = 0;
    }];
    
    //h5市场分析详情点击返回首页
    [self.bridge registerHandler:@"jumpToWeekReport" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToWeekReport----");
        [weakSelf reloadWebView:kAppBTEH5featureReportAddress];
        // 强制隐藏tabbar
        weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
        weakSelf.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
        weakSelf.tabBarController.tabBar.hidden = YES;
        weakSelf.tabBarController.tabBar.height = 0;
    }];
}

- (void)sendUserTokenAndReloadWebView{
    [self sendUserToken];
    [self reloadWebView:self.urlString];
}

- (void)shareAlert{
    //活动详情页
    if (self.ActivityId) {
        [self getShareMyAccountLoginStatus];
    }
    else{
        [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
    }
}

#pragma mark - sendUserToken
- (void)sendUserToken {
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

#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    NSString * url = [request.URL absoluteString];
    
//    NSLog(@"load url -shouldStartLoadWithRequest---:%@",url);
    
    if ([url rangeOfString:@"/wechat/feature"].location != NSNotFound){
        // 强制显示tabbar
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
        self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    NSString *numHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = numHtmlInfo;
}

#pragma mark - goback返回
- (void)goback {
    [super goback];
    UINavigationController *nav = self.tabBarController.selectedViewController;
    NSLog(@"nav.visibleViewController.navigationItem.title-------->%@",nav.visibleViewController.navigationItem.title);
    if ([nav.visibleViewController.navigationItem.title isEqualToString:@"关于"]) {
         [self update];
    }
    if ([nav.visibleViewController.navigationItem.title isEqualToString:@"市场分析报告"]) {
        [self update];
    }
}

- (void)clearUpdate{
    [ClearCacheTool clearCaches];
    [BHToast showMessage:@"缓存清理完毕"];
    [self update];
}

#pragma - get Request
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
//                    _islogin = YES;
                    [weakSelf update];
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
            //获取账户基本信息
//            _islogin = YES;
//            [weakSelf getMyAccountInfo];
        }
    } failure:^(NSError *error) {
        weakSelf.view.alpha = 1;
//        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)getShareMyAccountLoginStatus{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetUserLoginInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 0) {//未登录
            [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                if (isComplete) {
                    [weakSelf sendUserToken];
                    [weakSelf reloadWebView:self.urlString];
                }
            }];
        } else if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 1)//已登录
        {
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:weakSelf.shareUrl sharetitle:weakSelf.sharetitle shareDesc:weakSelf.shareDesc shareType:weakSelf.shareType currentVc:weakSelf];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
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

- (void)getbandDogUserCount{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kFromBandDogUserCount;
    WS(weakSelf)
//    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSString *bandDogCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCount"]];
            weakSelf.shareDesc = [NSString stringWithFormat: @"实时提供主流币买卖点提示，是短线/合约玩家的必备利器。已有%@人正在做波段。",bandDogCount];
        }
    } failure:^(NSError *error) {
//        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)ActivityIdDetail {
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:self.ActivityId forKey:@"id"];
    methodName = kGetUserActivityDetail;
    NMShowLoadIng;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            weakSelf.navigationItem.title = [[responseObject objectForKey:@"data"] objectForKey:@"title"];
            weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItem];
            weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
            weakSelf.sharetitle = [NSString stringWithFormat:@"比特易-%@",[[responseObject objectForKey:@"data"] objectForKey:@"title"]];
            weakSelf.shareDesc = [[responseObject objectForKey:@"data"] objectForKey:@"summary"];
            weakSelf.shareUrl = [[responseObject objectForKey:@"data"] objectForKey:@"shareUrl"];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.urlString isEqualToString:kAppBTEH5TradDataAddress]) {
        [_statusBarView removeFromSuperview];
        _statusBarView = nil;
    }
    
    if ([self.urlString isEqualToString:kAppBTEH5DogAddress]) {
        self.navigationItem.rightBarButtonItem = [self creatRightBarItemDetail];
        self.sharetitle = luzhuangDogTitleStr = @"撸庄狗-韭菜撸庄利器";
        self.shareUrl = self.urlString;
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;
        [self getUserCountAndincome];
        //因为现在在撸装狗里面如果收到 推送 或者周报的话 会推到市场分析报告 隐藏tabbar那么返回的时候就需要再次 把tabbar显示出来


        if(![self.navigationItem.title isEqualToString: @"比特易赚积分秘籍"]){
            self.tabBarController.tabBar.hidden = NO;
            self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
        }

    }
    
    if ([self.urlString isEqualToString:kAppBrandDogAddress]) {
        self.navigationItem.rightBarButtonItem = [self creatRightBarItemDetail];
        self.sharetitle =  @"波段狗-短线/合约玩家必备";
        self.shareUrl = self.urlString;
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;
        [self getbandDogUserCount];
    }
    
    if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (_statusBarView == nil && !_isFirstLoad){
            //设置状态栏颜色
            _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, STATUS_BAR_HEIGHT)];
            _statusBarView.backgroundColor = BHHexColor(@"168BF0");
            [self.view addSubview:_statusBarView];
        } else
        {
            _isFirstLoad = NO;
        }
        
        if ([self.isloginAndGetMyAccountInfo isEqualToString:@"0"]) {
            //获取登录状态
            self.view.alpha = 0;
            [self getMyAccountLoginStatus];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *pesonal = [defaults objectForKey:@"pesonalCenter"];
        if ([pesonal isEqualToString:@"pesonalCenter"] && self.isOneClass == NO) {
//            self.urlString = kAppBTEH5MyAccountAddress;
        }
        [self sendUserToken];
        [defaults setObject:@"" forKey:@"pesonalCenter"];
        [defaults synchronize];
    });

}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_statusBarView removeFromSuperview];
    _statusBarView = nil;
    
    self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
    self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
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
