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
@interface BTEHomeWebViewController ()
//分享需要的参数
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;
@property (nonatomic, copy) ShareViewCallBack shareViewCallBack;
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
            [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
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
    
    
    //市场分析详情点击返回首页
    [self.bridge registerHandler:@"jumpToDiscoverView" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"-----------%@",data);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    //市场分析详情点击调起分享
    [self.bridge registerHandler:@"touchShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"-----------%@",data);
        [weakSelf shareAlert];
    }];
    
    //标识是否是index页面 隐藏左返回键
    [self.bridge registerHandler:@"oneClass" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.isHiddenLeft = YES;
        if (data && [data objectForKey:@"title"]) {
            if ([[data objectForKey:@"title"] isEqualToString:@"比特易-玩转比特币 多看比特易"]) {
                weakSelf.navigationItem.title = @"比特易";
                weakSelf.navigationItem.rightBarButtonItem = [self creatRightBarItem];
                weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
                weakSelf.sharetitle = @"比特易-领先的数字货币市场专业分析平台";
                weakSelf.shareDesc = @"玩转比特币，多看比特易，聪明的投资者都在这里！";
                weakSelf.shareUrl = kAppBTEH5AnalyzeAddress;
            } else
            {
               weakSelf.navigationItem.title = [data objectForKey:@"title"];
                weakSelf.navigationItem.rightBarButtonItem = nil;
            }
        }
        // 强制显示tabbar
        weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT  - TAB_BAR_HEIGHT);
        weakSelf.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT  - TAB_BAR_HEIGHT;
        weakSelf.tabBarController.tabBar.hidden = NO;
    }];
    //标识是否是index页面 显示左返回键
    [self.bridge registerHandler:@"twoIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.isHiddenLeft = NO;
        if (data && [data objectForKey:@"title"]) {
            weakSelf.navigationItem.title = [data objectForKey:@"title"];
        }
        
        if (data && [data objectForKey:@"url"]) {
            weakSelf.navigationItem.rightBarButtonItem = [self creatRightBarItem];
            weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
            if ([[data objectForKey:@"url"] rangeOfString:@"wechat/strategy/"].location != NSNotFound) {
              weakSelf.sharetitle = [NSString stringWithFormat:@"比特易—%@,当前收益%@%%",self.productInfoModel.name,self.productInfoModel.ror];
              weakSelf.shareDesc = [NSString stringWithFormat:@"我跟随了比特易%@，当前收益%@%%，比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，玩转比特币，多看比特易。",self.productInfoModel.name,self.productInfoModel.ror];
                
            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/deal/"].location != NSNotFound)
            {
                weakSelf.sharetitle = @"比特易—数字货币分析平台";
                NSString *price = [NSString positiveFormat:self.desListModel.price];
                weakSelf.shareDesc = [NSString stringWithFormat:@"%@当前价格：$%@\t\n走势分析：%@\t\n操作建议：%@",self.desListModel.symbol,price,self.desListModel.trend,self.desListModel.operation];
            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/baza/"].location != NSNotFound)
            {
                weakSelf.navigationItem.rightBarButtonItem = [self creatRightBarItemDetail];
                weakSelf.sharetitle = self.descriptionModel.title;
                weakSelf.shareDesc = self.descriptionModel.summary;
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
    }];
    
}

- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"share_button_image"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (UIBarButtonItem *)creatRightBarItemDetail {
    UIImage *buttonNormal = [[UIImage imageNamed:@"top_share_detail"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (void)sendUserTokenAndReloadWebView
{
    [self sendUserToken];
    [self reloadWebView:self.urlString];
}

- (void)shareAlert
{
    [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
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
