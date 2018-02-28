//
//  CTWebViewVC.m
//  CreditTreasury
//
//  Created by zhangyuanzhe on 2017/8/3.
//  Copyright © 2017年 YinSheng Technology Co. Ltd. All rights reserved.
//

#import "BHBaseWebViewVC.h"

#define iOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion]floatValue] >= 9.0)

@interface BHBaseWebViewVC ()

@end

@implementation BHBaseWebViewVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.isHiddenLeft) {
        UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
//        [self.navigationItem setBackBarButtonItem:leftItem];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    [self loadWebView];
    [self initBridge];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handlerNetworkUnReachableStatus];
    if (_bridge) {
        [_bridge setWebViewDelegate:self];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bridge setWebViewDelegate:nil];
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
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - initBridge Moedth
- (void)initBridge {
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    [self observeH5BridgeHandler];
}


- (void)observeH5BridgeHandler {
    //do something
}
- (void)loadWebView {
    //清理缓存
    if (iOS9_OR_LATER) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache]];
        //日期
        NSDate * dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        ////执行
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^ {
            NSLog(@"清除缓存成功");
        }];
    }else {
        NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    [self.view addSubview:self.webView];
}

#define mark - WKNavigationDelegate
//webView 请求开始定向加载  在此处可以屏蔽 不需要加载的url 类似于 shouldStartLoadWithRequest
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [BHProgressHUD showLoading];
    decisionHandler(WKNavigationActionPolicyAllow);
}
//webView 请求开始定向加载。返回相应
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    [BHProgressHUD hideLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    decisionHandler(WKNavigationResponsePolicyAllow);
}
//webView开始加载内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
//webView内容开始返回的时候调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
//webView加载完成调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    [BHProgressHUD hideLoading];
}
//webView加载失败
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    [BHProgressHUD hideLoading];
}
#pragma mark - WKUIDelegate
/* 在JS端调用alert函数时，会触发此代理方法。JS端调用alert时所传的数据可以通过message拿到 在原生得到结果后，需要回调JS，是通过completionHandler回调 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [BHProgressHUD hideLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    [BHProgressHUD hideLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                completionHandler(YES);
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action){
                                                completionHandler(NO);
                                            }]];
    [self presentViewController:alert animated:YES completion:^{}];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    [BHProgressHUD hideLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    completionHandler(@"Client Not handler");
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
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
        conf.userContentController = [WKUserContentController new];

        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT  - (_isHiddenBottom ? HOME_INDICATOR_HEIGHT : TAB_BAR_HEIGHT)) configuration:conf];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
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
            NSMutableString *javascript = [NSMutableString string];
            [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
            [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
            //javascript 注入
            WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript
                                                                    injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                                 forMainFrameOnly:YES];
            [_webView.configuration.userContentController addUserScript:noneSelectScript];
        }
    }
    return _webView;
}

#pragma mark - KVO 监听title
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
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

