//
//  WLWebView.m
//  WangliBank
//
//  Created by 王俨 on 16/12/20.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "BTEWebView.h"
#import "WebViewJavascriptBridge.h"


@interface BTEWebView () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *activityId; ///< 记录活动id
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, assign) BOOL jumpToLoginPage;

@end

@implementation BTEWebView

+ (instancetype)webViewWithURL:(NSString *)url {
    BTEWebView *view = [[NSBundle mainBundle] loadNibNamed:@"WLWebView" owner:nil options:nil].firstObject;
    view.url = url;
    [view reloadWebView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400);//[UIScreen mainScreen].bounds;
    
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initJSBridge];
}


- (void)reloadWebView {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    [self.webView loadRequest:request];
}


- (IBAction)closeBtnClick {
    [self removeFromSuperview];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - WLNetworkErrorViewDelegate
- (void)networkErrorViewdidCLickReloadData {
    [self reloadWebView];
}

#pragma mark - JSBridge
- (void)initJSBridge {
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"我是一滴来自远方孤星的泪水");
    }];
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
//    [_bridge setWebViewDelegate:self];
    
    
    __weak typeof(self) weakSelf = self;
    
    
    // 1.登录
    [_bridge registerHandler:@"loginApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"loginApp called:%@", data);
        
    }];

    
}


#pragma mark - getter


#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}

@end
