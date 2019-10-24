//
//  KitemWebViewController.m
//  BTE
//
//  Created by wanmeizty on 6/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "KitemWebViewController.h"
#import "TestJSObject.h"
@interface KitemWebViewController ()<RetrunFormJsFunctionDelegate,UIWebViewDelegate>

@end

@implementation KitemWebViewController

- (instancetype)initWithUrl:(NSString *)url{
    
    if (self = [super init]){
        [self.view addSubview:self.webView];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)loadView:(NSString *)urlStr{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx{
    TestJSObject *testJO=[TestJSObject new];
    testJO.delegate = self;
    ctx[@"bteApp"]=testJO;
    ctx[@"viewController"] = self;
    ctx.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"JSContext------>异常信息：%@", exceptionValue);
    };
}

-(void)go2PageVc:(NSDictionary *)obj{
    NSLog(@"objob>>>>%@",obj);
    if (obj != nil) {
        NSString *action = [obj objectForKey:@"action"];
        if ([action isEqualToString:@"ActualHeight"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat height = [[obj objectForKey:@"jsonStr"] floatValue];
//                CGFloat realHeigth = (height / 375.0 * SCREEN_WIDTH);
                self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
                self.updateHeightBlock(height);
            });
          
        }
    }
    
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, 600)];
        _webView.delegate = self;
        _webView.scrollView.userInteractionEnabled = NO;
        
    }
    return _webView;
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
