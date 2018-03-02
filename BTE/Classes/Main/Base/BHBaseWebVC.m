//
//  BTEBaseWebVC.m
//  BTE
//
//  Created by 张竟巍 on 2018/3/1.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseWebVC.h"

#define iOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion]floatValue] >= 9.0)

@interface BHBaseWebVC ()

@end

@implementation BHBaseWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.isHiddenLeft) {
        UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    [self loadWebView];
    [self initBridge];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handlerNetworkUnReachableStatus];
    if (!User.isLogin) {
        [self reloadWebView:self.urlString];
    }
}
#pragma mark - 加载本地HTML
- (void)loadLocalHTMLString:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:nil];
}
//返回
- (void)goback {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
//    else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}
#pragma mark - initBridge Moedth
- (void)initBridge {
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"我是一滴来自远方孤星的泪水");
    }];
    [self observeH5BridgeHandler];
}
- (void)loadWebView {
    //清理缓存
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/Cookies"];
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    [self.view addSubview:self.webView];
}


- (void)observeH5BridgeHandler {
    //do something
}
#pragma mark - 重新加载webview
- (void)reloadWebView:(NSString *)url{
    if (STRISEMPTY(url)) {
        return;
    }
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [_webView loadRequest:request];
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    [BHProgressHUD showLoading];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    [BHProgressHUD hideLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

#pragma mark - getCookie
//此处可以获取当前用户的token值  用来传给H5
- (NSString *)getCookieValue {
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    // cookie重复，先放到字典进行去重，再进行拼接
    NSString * cookieValue = @"";
    for (NSString *key in cookieDic) {
        if ([key isEqualToString:@"XINYONGJINKU_TOKEN"]) {
            cookieValue = [cookieDic valueForKey:key];
        }
    }
    return IsNilOrNull(cookieValue) ? @"" : cookieValue;
}

#pragma mark - webView
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT  - (_isHiddenBottom ? HOME_INDICATOR_HEIGHT : TAB_BAR_HEIGHT))];
        //添加观察者
        if (self.isAllowTitle) {
            [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        }
        //请求
        if (self.urlString || ![self.urlString isEqualToString:@""]) {
            NSURL *URL = [NSURL URLWithString:self.urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
            [_webView loadRequest:request];
        }
        if (!self.longPressGestureEnabled) {
            [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
            [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
        }
        //获取当前页面的title
//        self.title ＝ [webViewstringByEvaluatingJavaScriptFromString:@”document.title”];
    }
    return _webView;
}

#pragma mark - KVO 监听title
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            
//            self.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//网络监测
- (void)handlerNetworkUnReachableStatus {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status ==AFNetworkReachabilityStatusUnknown) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kNotReachableTipMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
- (void)dealloc {
    if (self.isAllowTitle) {
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
    NSLog(@"WKWebView删除缓存");
    [self clearCache];
    [BHProgressHUD hideLoading];
    
}
/** 清理缓存的方法，这个方法会清除缓存类型为HTML类型的文件*/
- (void)clearCache {
    /* 取得Library文件夹的位置*/
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
    /* 取得bundle id，用作文件拼接用*/
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleIdentifier"];
    /*
     * 拼接缓存地址，具体目录为App/Library/Caches/你的APPBundleID/fsCachedData
     */
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    NSError *error;
    /* 取得目录下所有的文件，取得文件数组*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:webKitFolderInCachesfs error:&error];
    /* 遍历文件组成的数组*/
    for(NSString * fileName in fileList){
        /* 定位每个文件的位置*/
        NSString * path = [[NSBundle bundleWithPath:webKitFolderInCachesfs] pathForResource:fileName ofType:@""];
        /* 将文件转换为NSData类型的数据*/
        NSData * fileData = [NSData dataWithContentsOfFile:path];
        /* 如果FileData的长度大于2，说明FileData不为空*/
        if(fileData.length >2){
            /* 创建两个用于显示文件类型的变量*/
            int char1 =0;
            int char2 =0;
            [fileData getBytes:&char1 range:NSMakeRange(0,1)];
            [fileData getBytes:&char2 range:NSMakeRange(1,1)];
            /* 拼接两个变量*/
            NSString *numStr = [NSString stringWithFormat:@"%i%i",char1,char2];
            /* 如果该文件前四个字符是6033，说明是Html文件，删除掉本地的缓存*/
            if([numStr isEqualToString:@"6033"]){
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",webKitFolderInCachesfs,fileName]error:&error];
                continue;
            }
        }
    }
}




@end
