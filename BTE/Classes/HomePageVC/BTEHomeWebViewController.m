//
//  BTEHomeWebViewController.m
//  BTE
//
//  Created by wangli on 2018/1/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEHomeWebViewController.h"
#import "BTELoginVC.h"

@interface BTEHomeWebViewController ()

@end

@implementation BTEHomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self customtitleView];
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

-(void)observeH5BridgeHandler {
    WS(weakSelf)
    // 1.登录
    [self.bridge registerHandler:@"loginApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!STRISEMPTY(data[@"url"])) {
            [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                if (isComplete) {
                    [weakSelf sendUserToken];
                    [weakSelf reloadWebView:data[@"url"]];
                }else {
                    [weakSelf reloadWebView:self.urlString];
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
    
}
- (void)sendUserToken {
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
