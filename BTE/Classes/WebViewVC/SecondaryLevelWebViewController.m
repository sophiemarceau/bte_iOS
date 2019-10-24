//
//  SecondaryLevelWebViewController.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/8/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "SecondaryLevelWebViewController.h"
#import "BTEFreandCountViewController.h"
#import "TestJSObject.h"
#import "BTEFeedBackViewController.h"
#import "UserStatistics.h"
#import "PersonalSettingViewController.h"
#import "DugCoinViewContrllerViewController.h"
#import "SharedDugView.h"
#import "WXApiManager.h"

@interface SecondaryLevelWebViewController ()<RetrunFormJsFunctionDelegate,WXApiManagerDelegate>{
    NSUInteger selectedIndex;
}
@property (nonatomic, copy) ShareViewCallBack shareViewCallBack;
@property (nonatomic,strong) NSTimer * timer;
@end

@implementation SecondaryLevelWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApiManager sharedManager].delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
    
    
    self.navigationItem.leftBarButtonItem = [self leftBart];
    self.navigationItem.rightBarButtonItem = [self creatRightBarItem];
    //活动详情页
    if (self.ActivityId) {
        [self ActivityIdDetail];
    }
}


- (void)shareAlert{
    [UserStatistics sendEventToServer:@"积分页点击右上角分享"];
     //活动详情页
    if (self.ActivityId) {
        [self getShareMyAccountLoginStatus];
        return;
    }
//     dispatch_async(dispatch_get_main_queue(), ^{
//         NSLog(@"bte---urlString----->%@",self.urlString);
//         if ([self.urlString rangeOfString:@"source=index"].location != NSNotFound){
//             self.sharetitle = @"比特易-数字货币市场专业分析平台";
//             self.shareDesc = @"比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具。";
//             self.shareUrl = kAppBTEH5AnalyzeAddress;
//         }else{
//             NSString *getStr = @"document.getElementsByName(\"share\")[0].content";
//             NSString *sharestring = [self.webView stringByEvaluatingJavaScriptFromString:getStr];
//
//             NSDictionary *shareDictioinary = [self convertjsonStringToDict:sharestring];
//             if (shareDictioinary != nil) {
//                 self.sharetitle = shareDictioinary[@"title"];
//                 self.shareDesc = shareDictioinary[@"content"];
//                 self.shareUrl = shareDictioinary[@"url"];
//             }else{
//                 self.sharetitle = @"比特易-数字货币市场专业分析平台";
//                 self.shareDesc = @"比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具。";
//                 self.shareUrl = kAppBTEH5AnalyzeAddress;
//             }
//         }
//         self.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
//         [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
//     });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"bte---urlString----->%@",self.urlString);
        NSString *getStr = @"document.getElementsByName(\"share\")[0].content";
        NSString *sharestring = [self.webView stringByEvaluatingJavaScriptFromString:getStr];
        NSLog(@"bte---urlString----->%@",sharestring);
        if (![sharestring isEqualToString:@""]) {
            NSDictionary *shareDictioinary = [self convertjsonStringToDict:sharestring];
            if (shareDictioinary != nil) {
                self.sharetitle = shareDictioinary[@"title"];
                self.shareDesc = shareDictioinary[@"content"];
                self.shareUrl = shareDictioinary[@"url"];
            }
        }else{
            self.sharetitle = @"比特易-数字货币市场专业分析平台";
            self.shareDesc = @"比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具。";
            self.shareUrl = kAppBTEH5AnalyzeAddress;
        }
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
        [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
    });
}

- (void)shareFriendForHelpAlert{
    [UserStatistics sendEventToServer:@"积分页点击好友助力分享"];
     dispatch_async(dispatch_get_main_queue(), ^{
         NSString *getStr = @"document.getElementsByName(\"share\")[0].content";
         NSString *sharestring = [self.webView stringByEvaluatingJavaScriptFromString:getStr];
         
         NSDictionary *shareDictioinary = [self convertjsonStringToDict:sharestring];
         if (shareDictioinary != nil) {
             self.sharetitle = shareDictioinary[@"title"];
             self.shareDesc = shareDictioinary[@"content"];
             self.shareUrl = shareDictioinary[@"url"];
         }
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
        [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
    });

    //    NSString *getStr = @"document.getElementsByName(\"share\")[0].content";
    //    NSString *sharestring = [self.webView stringByEvaluatingJavaScriptFromString:getStr];
    //    if (![sharestring isEqualToString:@""]) {
    //        NSDictionary *shareDictioinary = [self convertjsonStringToDict:sharestring];
    //        if (shareDictioinary != nil) {
    //            self.sharetitle = shareDictioinary[@"title"];
    //            self.shareDesc = shareDictioinary[@"content"];
    //            self.shareUrl = shareDictioinary[@"url"];
    //        }
    //    }else{
    //        self.sharetitle = @"比特易-数字货币市场专业分析平台";
    //        self.shareDesc = @"比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具。";
    //        self.shareUrl = kAppBTEH5AnalyzeAddress;
    //    }
}


- (void)update {
    [self.webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)addNotification {
    //直接是 行情列表页面的时候才添加此 通知 监听
    if ([self.urlString isEqualToString:kAppBTEH5TradDataAddress]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:NotificationRefreshTradeList object:nil];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationReSetPassword object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationUserLoginSuccess object:nil];
}

-(void)go2PageVc:(NSDictionary *)obj{
    if (obj != nil) {
        NSString *action = [obj objectForKey:@"action"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([action isEqualToString:@"login"]) {
                selectedIndex = self.tabBarController.selectedIndex;
                [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                    if (isComplete) {
                        [self update];
                    }
                }];
            }
            
            if ([action isEqualToString:@"jumpToKline"]) {
                [UserStatistics sendEventToServer:@"进入K线"];
                BTEKlineViewController *homePageVc= [[BTEKlineViewController alloc] init];
                HomeDesListModel * delistModel = [[HomeDesListModel alloc] init];
                [delistModel initDict:obj[@"paramDic"]];
                homePageVc.desListModel = delistModel;
                [self.navigationController pushViewController:homePageVc animated:YES];
            }
            
            if ([action isEqualToString:@"share"]) {
                
                [self shareAlert];
            }
            
            if ([action isEqualToString:@"inviteBoostShare"]) {
                [self shareFriendForHelpAlert];
            }
            
            if ([action isEqualToString:@"feedBack"]) {
//                PersonalSettingViewController *personalVc = [[PersonalSettingViewController alloc] init];
//                [self.navigationController pushViewController:personalVc animated:YES];
                                BTEFeedBackViewController *invateVc = [[BTEFeedBackViewController alloc] init];
                                [self.navigationController pushViewController:invateVc animated:YES];
            }
            
            if ([action isEqualToString:@"openWeb"]) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://bte.top"]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bte.top"]];
                }
            }
            
            if ([action isEqualToString:@"about"]) {
                self.isHiddenLeft = NO;
                self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
                self.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
                self.tabBarController.tabBar.hidden = YES;
                self.tabBarController.tabBar.height = 0;
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [_statusBarView removeFromSuperview];
                _statusBarView = nil;
            }
            
            if ([action isEqualToString:@"chainSearchClick"]) {
                self.isHiddenLeft = NO;
                self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
                self.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
                self.tabBarController.tabBar.hidden = YES;
                self.tabBarController.tabBar.height = 0;
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [_statusBarView removeFromSuperview];
                _statusBarView = nil;
            }
            
            if ([action isEqualToString:@"serviceSetting"]) {
                self.isHiddenLeft = NO;
                self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
                self.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
                self.tabBarController.tabBar.hidden = YES;
                self.tabBarController.tabBar.height = 0;
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [_statusBarView removeFromSuperview];
                _statusBarView = nil;
            }
            
            if ([action isEqualToString:@"personalSetting"]) {
                PersonalSettingViewController *personalVc = [[PersonalSettingViewController alloc] init];
                [self.navigationController pushViewController:personalVc animated:YES];
            }
            
            if ([action isEqualToString:@"addGroup"]) {
                self.isHiddenLeft = NO;
                self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
                self.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
                self.tabBarController.tabBar.hidden = YES;
                self.tabBarController.tabBar.height = 0;
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [_statusBarView removeFromSuperview];
                _statusBarView = nil;
            }
            
            if ([action isEqualToString:@"integralList"]) {
                self.isHiddenLeft = NO;
                self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
                self.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
                self.tabBarController.tabBar.hidden = YES;
                self.tabBarController.tabBar.height = 0;
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [_statusBarView removeFromSuperview];
                _statusBarView = nil;
            }
            
            if ([action isEqualToString:@"logout"]) {
                //退出成功删除手机号
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:MobilePhoneNum];
                //删除本地登录信息
                [User removeLoginData];
                //发送通知告诉web token变动
                [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUpdateUserLoginStatus object:nil];
                [self.tabBarController setSelectedIndex:0];
                [self update];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate logoutHuaXinServer];// 退出环信
                [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
            }
            
            if ([action isEqualToString:@"invite"]) {
                [UserStatistics sendEventToServer:@"积分页点击邀请"];
                if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
                    BTEFreandCountViewController *FreandCount = [[BTEFreandCountViewController alloc] init];
                    [self.navigationController pushViewController:FreandCount animated:YES];
                    return;
                }
                
                NSMutableDictionary * pramaDic = @{}.mutableCopy;
                NSString * methodName = @"";
                if (User.userToken) {
                    [pramaDic setObject:User.userToken forKey:@"bte-token"];
                }
                [pramaDic setObject:kGetUserInvateFrendUrl forKey:@"url"];
                methodName = kGetHomePageUserInvateFrend;
                //        NMShowLoadIng;
                [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
                    //            NMRemovLoadIng;
                    if (IsSafeDictionary(responseObject)) {
                        NSDictionary *dic = [responseObject objectForKey:@"data"];
                        if (dic) {
                            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:[dic objectForKey:@"base64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
                            NSString *invteCodeStr = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"][@"inviteCode"]];
                            [SharePicView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:nil sharetitle:nil shareDesc:nil shareType:UMS_SHAREPic_TYPE_IMAGE currentVc:nil WithQrImage:decodedImage WithInviteCode:invteCodeStr];
                        }
                    }
                } failure:^(NSError *error) {
                    //            NMRemovLoadIng;
                    RequestError(error);
                    NSLog(@"error-------->%@",error);
                }];
            }
            
            //开启挖矿 进入原生实现的挖矿首页
            if ([action isEqualToString:@"openMining"]) {
                DugCoinViewContrllerViewController *vc= [[DugCoinViewContrllerViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
//                NSMutableDictionary * pramaDic = @{}.mutableCopy;
//                NSString * methodName = @"";
//                if (User.userToken) {
//                    [pramaDic setObject:User.userToken forKey:@"bte-token"];
//                }
//
//                methodName = kOpenDig;
//                //        NMShowLoadIng;
//                [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//                    NSLog(@"opening------->%@",responseObject);
//                    if (IsSafeDictionary(responseObject)) {
//                        DugCoinViewContrllerViewController *vc= [[DugCoinViewContrllerViewController alloc] init];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                } failure:^(NSError *error) {
//                    //            NMRemovLoadIng;
//                    RequestError(error);
//                    NSLog(@"error-------->%@",error);
//                }];
                
                
                [self eventCountToServerWithClickType:@"open" WithModuleString:@"dig"];
                
            }
            
            if ([action isEqualToString:@"backAssets"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRefreshWebBassets object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            //开启挖矿 进入原生实现的挖矿截图分享页
            if ([action isEqualToString:@"shareMining"]) {
                NSMutableDictionary * pramaDic = @{}.mutableCopy;
                NSString * methodName = @"";
                if (User.userToken) {
                    [pramaDic setObject:User.userToken forKey:@"bte-token"];
                }
//                NSString *urlStr = [NSString stringWithFormat:@"%@?inviteCode=%@",kDigInvateFrendUrl,self.invteCodeStr];
                [pramaDic setObject:kDigInvateFrendUrl forKey:@"url"];
                methodName = kGetHomePageUserInvateFrend;
                //        NMShowLoadIng;
                [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
                    //            NMRemovLoadIng;
                    if (IsSafeDictionary(responseObject)) {
                        NSDictionary *dic = [responseObject objectForKey:@"data"];
                        if (dic) {
                            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:[dic objectForKey:@"base64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
                            NSString *invteCodeStr = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"][@"inviteCode"]];
                            [SharedDugView popShareViewCallBack:^{
                                
                            }  imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:@"" sharetitle:@"" shareDesc:@"" shareType:UMSHAREPic_TYPE_IMAGE currentVc:self WithQrImage:decodedImage WithInviteCode:invteCodeStr WithDugNum:self.idStr];
                        }
                    }
                } failure:^(NSError *error) {
                    //            NMRemovLoadIng;
                    RequestError(error);
                    NSLog(@"error-------->%@",error);
                }];
            }

            if ([action isEqualToString:@"goBack"]) {
//                [self.navigationController popViewControllerAnimated:YES];
//                [self update];
                [self.webView goBack];
//                [self.webView reload];
            }
            
            if ([action isEqualToString:@"bindWechat"]) {
                [self getAuthWithUserInfoFromWechat];
            }
        });
    }
}

- (void)getAuthWithUserInfoFromWechat{
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = WechatStatueStr;
        [WXApi sendReq:req];
    } else {
        [BHToast showMessage:@"请您先安装微信"];
    }
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    // 向微信请求授权后,得到响应结果
    
    if ([response.state isEqualToString:WechatStatueStr] && response.errCode == WXSuccess) {
        //        NSLog(@"code-------->%@",response.code);
        //        NSLog(@"errStr-------->%@",response.errStr);
        
        //接口调用
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString *methodName = @"";
        if (User.userToken) {
            [pramaDic setObject:User.userToken forKey:@"bte-token"];
            [pramaDic setObject:User.userToken forKey:@"token"];
        }
        [pramaDic setObject:response.code forKey:@"code"];
        methodName = kGetWXBind;
        NSLog(@"pramaDic-------->%@",pramaDic);
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NSLog(@"kGetWXBind-------->%@",responseObject);
            NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {
                
                NSDictionary * data = [responseObject objectForKey:@"data"];
                if (data) {
                    [weakSelf update];
                }
                //                AddAttentionView *v = [[AddAttentionView alloc] initAlertView];
                //                [v setConfirmCallBack:^(BOOL isComplete, NSString *returnStr) {
                //                    if (isComplete) {
                //
                //                    }
                //                }];
            }
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error----kGetWXBind---->%@",error);
        }];
    }
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     NSLog(@"--------webview-------viewWillAppear------------------%@",self.urlString);
    //个人中心
    if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        //设置状态栏颜色
        if (_statusBarView == nil){
            //设置状态栏颜色
            _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, STATUS_BAR_HEIGHT)];
            _statusBarView.backgroundColor = BHHexColor(@"168BF0");
            [self.view addSubview:_statusBarView];
        }
        //由于个人中心 强制隐藏 导航栏 导致适配页面的 做的特殊处理
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT -STATUS_BAR_HEIGHT);
        self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
        //获取登录状态
        self.view.alpha = 0;
        [self getMyAccountLoginStatus];
    }else{
        NSLog(@"selfishiddebottom------>%d",self.isHiddenBottom);
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
        self.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
        self.tabBarController.tabBar.hidden = YES;
    }
    
    //行情数据 选项
    if ([self.urlString isEqualToString:kAppBTEH5TradDataAddress]) {
        self.isHiddenLeft = YES;
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT-NAVIGATION_HEIGHT);
        self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT- NAVIGATION_HEIGHT;
        self.tabBarController.tabBar.hidden = NO;
    }

    //链查查 选项
    if ([self.urlString isEqualToString:kAppBTECheckChainAddress]) {
//        self.isHiddenLeft = YES;
//        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT-NAVIGATION_HEIGHT);
//        self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT- NAVIGATION_HEIGHT;
//        self.tabBarController.tabBar.hidden = NO;
    }
    
    //tabbar 第三个里面的 市场分析报告 选项
    if ([self.urlString isEqualToString:kAppDetailDealAddress]) {
        [self getRepoertURL];
         self.isHiddenLeft = YES;
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT- NAVIGATION_HEIGHT);
        self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT- NAVIGATION_HEIGHT;
        self.tabBarController.tabBar.hidden = NO;
    }
    
    if (!self.timer) {
        // 创建定时器
        self.timer = [NSTimer timerWithTimeInterval:1.5f target:self selector:@selector(startClock) userInfo:nil repeats:YES];
        // 将定时器添加到runloop中，否则定时器不会启动
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        //开启定时器
         [self.timer fire];
    }else{
         [self.timer fire];
    }
    
    
    
    if([self.urlString isEqualToString:kAppMyInviteRecordAddress]){
        self.navigationItem.rightBarButtonItem = nil;
    }
    if([self.urlString isEqualToString:kAppMyWalletAddress]){
        self.navigationItem.rightBarButtonItem = nil;
    }
    if([self.urlString isEqualToString:kAppMyEnergyAddress]){
        self.navigationItem.rightBarButtonItem = nil;
    }
    if([self.urlString isEqualToString:kAppMissionlistAddress]){
        self.navigationItem.rightBarButtonItem = nil;
    }
    if([self.urlString isEqualToString:kAirIndexAddress]){
        self.navigationItem.rightBarButtonItem = nil;
    }
    if([self.urlString isEqualToString:kTabAmountAddress]){
        self.navigationItem.rightBarButtonItem = nil;
    }
    if([self.urlString isEqualToString:kTabNetFlowAddress]){
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)startClock{
   NSString *titleStr = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (titleStr.length != 0) {
        self.navigationItem.title = titleStr;
        
//        if (self.tabBarController.selectedIndex ==2) {
//            if (![self.webView canGoBack]) {
//                self.isHiddenLeft = YES;
//            }else{
//                self.isHiddenLeft = NO;
//            }
//        }
//        if (self.tabBarController.selectedIndex ==2 && self.isFromReviewLuZDog == YES && [self.webView canGoBack]) {
//            self.isHiddenLeft = YES;
//        }
    }
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_statusBarView removeFromSuperview];
    _statusBarView = nil;
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSLog(@"---------------shouldStartLoadWithRequest------------------");
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    NSLog(@"---------------START------------------");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"---------------webViewDidFinishLoad------------------>%@",self.urlString);
    [super webViewDidFinishLoad:webView];

//    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//        NSLog(@"currentURL------------>%@",currentURL);
    NSString *webNavtitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (webNavtitle.length != 0) {
        self.navigationItem.title = webNavtitle;
    }
//    NSLog(@"---------------END------------------");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"---------------error---------------%@---",error);
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

#pragma mark - goback返回
- (void)goback {
    [super goback];
    UINavigationController *nav = self.tabBarController.selectedViewController;
    NSLog(@"nav.visibleViewController.navigationItem.title-------->%@",nav.visibleViewController.navigationItem.title);
    NSLog(@"goback-------urlstring----->%@",self.urlString);
//    if ([self.urlString isEqualToString:kResearchDogAddress]) {
//
//    }
//
//    if ([self.urlString isEqualToString:kAppBTEH5DogAddress]) {
//
//    }

    if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
        self.isHiddenLeft = NO;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (_statusBarView == nil) {
            //设置状态栏颜色
            _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    self.view.bounds.size.width, STATUS_BAR_HEIGHT)];
            _statusBarView.backgroundColor = BHHexColor(@"168BF0");
            [self.view addSubview:_statusBarView];
        }
        // 强制显示tabbar
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
        self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
        [self reloadWebView:kAppBTEH5MyAccountAddress];
    }
    
//    //为了过审核 策略项目替换显示撸庄狗 然后撸庄狗要加入 回退按钮 来实现跳转流程
//    if (self.tabBarController.selectedIndex ==2 && self.isFromReviewLuZDog == YES ) {
//        self.isHiddenLeft = YES;
//    }
    
    //链查查 的选项首页 返回到该首页 强制显示tabbar
    if (self.tabBarController.selectedIndex ==2 && [self.urlString isEqualToString:kAppBTECheckChainAddress]) {
        self.isHiddenLeft = YES;
        self.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT-NAVIGATION_HEIGHT);
        self.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT- NAVIGATION_HEIGHT;
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
    }
}

#pragma mark - get Data From Server
- (void)getShareMyAccountLoginStatus{
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
                    [self update];
                }
            }];
        } else if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 1)//已登录
        {
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:weakSelf.shareUrl sharetitle:weakSelf.sharetitle shareDesc:weakSelf.shareDesc shareType:weakSelf.shareType currentVc:weakSelf];
        }
    } failure:^(NSError *error) {
//        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//获取登录状态
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
        NSLog(@"responseObject-------->%@",responseObject);
        //        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 0) {//未登录
            [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                if (isComplete) {
                    //登录成功刷新我的账户页面
                    //获取账户基本信息
                    [weakSelf update];
                    [weakSelf.tabBarController setSelectedIndex:0];
                } else
                {
                    [weakSelf.tabBarController setSelectedIndex:0];
                }
            }];
        } else if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 1)//已登录
        {
            weakSelf.view.alpha = 1;
            [weakSelf reloadWebView:self.urlString];
        }
    } failure:^(NSError *error) {
        weakSelf.view.alpha = 1;
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)getRepoertURL {
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";

    methodName = kGetUserRepoertUrl;
    
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        //        NMRemovLoadIng;
        NSLog(@"getRepoertURL-----responseObject--->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            [weakSelf reloadWebView:responseObject[@"data"][@"url"]];
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        
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
    //    NMShowLoadIng;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        //        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            weakSelf.navigationItem.title = [[responseObject objectForKey:@"data"] objectForKey:@"title"];
            weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItem];
            weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
            weakSelf.sharetitle = [NSString stringWithFormat:@"比特易-%@",[[responseObject objectForKey:@"data"] objectForKey:@"title"]];
            weakSelf.shareDesc = [[responseObject objectForKey:@"data"] objectForKey:@"summary"];
            weakSelf.shareUrl = [[responseObject objectForKey:@"data"] objectForKey:@"shareUrl"];
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)eventCountToServerWithClickType:(NSString *)tagetStr WithModuleString:(NSString *)modulStr{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }else{
        return;
    }
    [pramaDic setObject:@"ios" forKey:@"channel"];
    [pramaDic setObject:modulStr forKey:@"module"];
    [pramaDic setObject:@"click" forKey:@"type"];
    [pramaDic setObject:tagetStr forKey:@"target"];
   
    methodName = kEventCount;
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        NSLog(@"kEventCount----%@---->%@",tagetStr,responseObject);
        //        if (IsSafeDictionary(responseObject)) {
        //        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark - Navigation
- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"Group 24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (UIBarButtonItem *)leftBart{
    UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(disback)];
    return backItem;
}

- (void)disback{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(NSDictionary *)convertjsonStringToDict:(NSString *)jsonString{
    NSDictionary *retDict = nil;
    if ([jsonString isKindOfClass:[NSString class]]) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        return  retDict;
    }else{
        return retDict;
    }
}
@end
