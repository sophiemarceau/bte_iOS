//
//  MyPersonalViewController.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/4.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "MyPersonalViewController.h"
#import "BTELoginVC.h"
#import "BTEInviteFriendViewController.h"
#import "BTEFeedBackViewController.h"
#import "ClearCacheTool.h"
#import "JPUSHService.h"
@interface MyPersonalViewController ()

@property (nonatomic, assign) BOOL isFirstLoad;//记录首次加载
@property (nonatomic, assign) BOOL isOneClass;//记录是否一级页面
@property (nonatomic,assign) BOOL isHiddetabBar;

@end

@implementation MyPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addNotification];
    
    _isFirstLoad = YES;
    self.isloginAndGetMyAccountInfo = @"0";
    self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    self.view.height = SCREEN_HEIGHT;
    self.tabBarController.tabBar.hidden = NO;
//    if ([self.isPersonalCenter isEqualToString:@"1"]) {
//        // 强制显示tabbar
//        
//    }
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationReSetPassword object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendUserTokenAndReloadWebView) name:NotificationUserLoginSuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
        weakSelf.isloginAndGetMyAccountInfo = @"0";
        [weakSelf update];
        [weakSelf.tabBarController setSelectedIndex:0];
    }];
    
    //邀请
    [self.bridge registerHandler:@"jumpToInvite" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToInvite----");
        BTEInviteFriendViewController *invateVc = [[BTEInviteFriendViewController alloc] init];
        [weakSelf.navigationController pushViewController:invateVc animated:YES];
        weakSelf.tabBarController.tabBar.hidden = YES;
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

    //标识是否是index页面 隐藏左返回键
    [self.bridge registerHandler:@"oneClass" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"------registerHandler-----------oneClass---%@",data);
        weakSelf.isHiddenLeft = YES;
        weakSelf.isOneClass = YES;
        
        if (data && [data objectForKey:@"title"]) {
            if ([[data objectForKey:@"title"] isEqualToString:@"个人中心"]) {
                [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
                if (_statusBarView == nil) {
                    //设置状态栏颜色
                    _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    weakSelf.view.bounds.size.width, STATUS_BAR_HEIGHT)];
                    _statusBarView.backgroundColor = BHHexColor(@"168BF0");
                    //                    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                    //                    gradientLayer.colors = @[(__bridge id)BHHexColor(@"53AFFF").CGColor, (__bridge id)BHHexColor(@"1389EF").CGColor];
                    //                    gradientLayer.startPoint = CGPointMake(0, 0);
                    //                    gradientLayer.endPoint = CGPointMake(1.0, 0);
                    //                    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
                    //                    [_statusBarView.layer addSublayer:gradientLayer];
                    [weakSelf.view addSubview:_statusBarView];
                }
            } else
            {
                weakSelf.navigationItem.title = [data objectForKey:@"title"];
                weakSelf.navigationItem.rightBarButtonItem = nil;
            }
        }
        weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
        weakSelf.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
        weakSelf.tabBarController.tabBar.hidden = NO;
        weakSelf.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
    }];
}

- (void)sendUserTokenAndReloadWebView{
    [self sendUserToken];
    [self reloadWebView:self.urlString];
}

#pragma mark - sendUserToken
- (void)sendUserToken {
    NSLog(@"i send userToken ---%@",User.userToken);
    
    [self.bridge registerHandler:@"sendUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
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
//    NSString * url = [request.URL absoluteString];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    NSString *numHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = numHtmlInfo;
}

//返回
- (void)goback {
    [super goback];
    UINavigationController *nav = self.tabBarController.selectedViewController;
    NSLog(@"nav.visibleViewController.navigationItem.title-------->%@",nav.visibleViewController.navigationItem.title);
    if ([nav.visibleViewController.navigationItem.title isEqualToString:@"关于"]) {
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
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
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
            [weakSelf update];
            //获取账户基本信息
            //            _islogin = YES;
            //            [weakSelf getMyAccountInfo];
        }
    } failure:^(NSError *error) {
        weakSelf.view.alpha = 1;
        NMRemovLoadIng;
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
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)dealloc {
    NMRemovLoadIng;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (_statusBarView == nil && !_isFirstLoad)
        {
            //设置状态栏颜色
            _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    self.view.bounds.size.width, STATUS_BAR_HEIGHT)];
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
        [self sendUserToken];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self update];
    });
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_statusBarView removeFromSuperview];
    _statusBarView = nil;
}

@end
