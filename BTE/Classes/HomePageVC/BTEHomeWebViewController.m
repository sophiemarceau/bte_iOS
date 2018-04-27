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
    if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
        //初始化为0
        self.isloginAndGetMyAccountInfo = @"0";
    }
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
    
    //个人中心点击邀请
    [self.bridge registerHandler:@"jumpToManageMoney" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"-----------%@",data);
        BTEInviteFriendViewController *invateVc = [[BTEInviteFriendViewController alloc] init];
        [weakSelf.navigationController pushViewController:invateVc animated:YES];
    }];
    
    //关于我们官网跳转
    [self.bridge registerHandler:@"bteTop" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"-----------%@",data);
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://bte.top"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bte.top"]];
        }
    }];
    
    //市场分析详情点击返回首页
    [self.bridge registerHandler:@"jumpToDiscoverView" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (weakSelf.tabBarController.selectedIndex == 0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"top" forKey:@"top"];
            [defaults synchronize];
            
        }
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
        // 强制显示tabbar
        weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
        weakSelf.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
        weakSelf.tabBarController.tabBar.hidden = NO;
    }];
    //标识是否是index页面 显示左返回键
    [self.bridge registerHandler:@"twoIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.isHiddenLeft = NO;
        if (data && [data objectForKey:@"title"]) {
            weakSelf.navigationItem.title = [data objectForKey:@"title"];
        }
        
        if (data && [data objectForKey:@"url"]) {
            weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItem];
            weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
            if ([[data objectForKey:@"url"] rangeOfString:@"wechat/strategy/"].location != NSNotFound) {
              weakSelf.sharetitle = [NSString stringWithFormat:@"比特易—%@,当前收益%@%%",weakSelf.productInfoModel.name,weakSelf.productInfoModel.ror];
              weakSelf.shareDesc = [NSString stringWithFormat:@"我跟随了比特易%@，当前收益%@%%，比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，玩转比特币，多看比特易。",weakSelf.productInfoModel.name,weakSelf.productInfoModel.ror];
                
            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/deal/"].location != NSNotFound)
            {
                weakSelf.sharetitle = @"比特易—数字货币分析平台";
                NSString *price = [NSString positiveFormat:weakSelf.desListModel.price];
                weakSelf.shareDesc = [NSString stringWithFormat:@"%@当前价格：$%@\t\n走势分析：%@\t\n操作建议：%@",weakSelf.desListModel.symbol,price,weakSelf.desListModel.trend,weakSelf.desListModel.operation];
            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/baza/"].location != NSNotFound)
            {
                weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItemDetail];
                weakSelf.sharetitle = [NSString stringWithFormat:@"%@",[data objectForKey:@"type"]];
                weakSelf.shareDesc = [data objectForKey:@"summary"];
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
        

        
        [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
        [_statusBarView removeFromSuperview];
        _statusBarView = nil;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (_statusBarView == nil)
        {
            //设置状态栏颜色
            _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    self.view.bounds.size.width, STATUS_BAR_HEIGHT)];
            _statusBarView.backgroundColor = BHHexColor(@"168BF0");
//            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//            gradientLayer.colors = @[(__bridge id)BHHexColor(@"53AFFF").CGColor, (__bridge id)BHHexColor(@"1389EF").CGColor];
//            gradientLayer.startPoint = CGPointMake(0, 0);
//            gradientLayer.endPoint = CGPointMake(1.0, 0);
//            gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
//            [_statusBarView.layer addSublayer:gradientLayer];
            [self.view addSubview:_statusBarView];
        }

        if ([self.isloginAndGetMyAccountInfo isEqualToString:@"0"]) {
            //获取登录状态
            [self getMyAccountLoginStatus];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_statusBarView removeFromSuperview];
    _statusBarView = nil;
}


- (void)getMyAccountLoginStatus
{
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
            //获取账户基本信息
//            _islogin = YES;
//            [weakSelf getMyAccountInfo];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
    }];
}



-(void)dealloc {
    NMRemovLoadIng;
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
