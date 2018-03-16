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
@interface BTEHomeWebViewController ()

@end

@implementation BTEHomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self customtitleView];
    [self addNotification];
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor redColor];
//    btn.frame = CGRectMake(100, 100, 100, 100);
//    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}
- (void)click {
    //    [BTELoginVC OpenLogin:self callback:nil];
    //    self.navigationController pushViewController:[BTEBaseWebVC ] animated:<#(BOOL)#>
    //    [self.view addSubview:[BTEBaseWebVC webViewWithURL:@"http://192.168.24.135:3001/wechat/index"]];
}
- (void)update {
    [self reloadWebView:self.urlString];
}
- (void)addNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationReSetPassword object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendUserTokenAndReloadWebView) name:NotificationUserLoginSuccess object:nil];
}
-(void)observeH5BridgeHandler {
    WS(weakSelf)
    // 1.登录
    [self.bridge registerHandler:@"loginApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!STRISEMPTY(data[@"url"])) {
            [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                if (isComplete) {
                    [weakSelf sendUserToken];
                    [weakSelf reloadWebView:data[@"url"]];
                }
            }];
        }
    }];
    //.发送token给H5
    [self sendUserToken];
    //退出登录
    [self.bridge registerHandler:@"loginOut" handler:^(id data, WVJBResponseCallback responseCallback) {
        [User removeLoginData];
        [weakSelf reloadWebView:self.urlString];
    }];
    
    
    //我的账户已登录点击监听
    [self.bridge registerHandler:@"jumpToAccount" handler:^(id data, WVJBResponseCallback responseCallback) {

    }];
    
    
    
    //标识是否是index页面 隐藏左返回键
    [self.bridge registerHandler:@"oneClass" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.isHiddenLeft = YES;
        if (data && [data objectForKey:@"title"]) {
            if ([[data objectForKey:@"title"] isEqualToString:@"比特易-玩转比特币 多看比特易"]) {
                self.navigationItem.title = @"比特易";
            } else
            {
               self.navigationItem.title = [data objectForKey:@"title"];
            }
        }
        // 强制显示tabbar
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT  - TAB_BAR_HEIGHT);
        self.tabBarController.tabBar.hidden = NO;
    }];
    //标识是否是index页面 显示左返回键
    [self.bridge registerHandler:@"twoIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.isHiddenLeft = NO;
        if (data && [data objectForKey:@"title"]) {
            self.navigationItem.title = [data objectForKey:@"title"];
        }
        // 强制隐藏tabbar
//        SCREEN_HEIGHT- NAVIGATION_HEIGHT  -  HOME_INDICATOR_HEIGHT
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
        self.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
        self.tabBarController.tabBar.hidden = YES;
    }];
    
}


- (void)sendUserTokenAndReloadWebView
{
    [self sendUserToken];
    [self reloadWebView:self.urlString];
}



- (void)sendUserToken {
    NSLog(@"i send userToken ---%@",User.userToken);
    [self.bridge registerHandler:@"sendUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"sessionId": User.userToken});
    }];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    NSString * url = [request.URL absoluteString];
    
    NSLog(@"load url ----:%@",url);

    return YES;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
