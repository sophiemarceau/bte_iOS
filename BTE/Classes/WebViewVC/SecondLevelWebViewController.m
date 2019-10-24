//
//  SecondLevelWebViewController.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/26.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "SecondLevelWebViewController.h"
#import "SharePicView.h"
@interface SecondLevelWebViewController (){
    NSString *luzhuangDogStr;
    NSString *luzhuangDogTitleStr;
}

@property (nonatomic, copy) ShareViewCallBack shareViewCallBack;

@end

@implementation SecondLevelWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addNotification];
    
    //活动详情页
    if (self.ActivityId) {
        [self ActivityIdDetail];
    }
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
//        NSLog(@"--registerHandler----loginOut-----%@",data);
//        //退出成功删除手机号
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:nil forKey:MobilePhoneNum];
//        //删除本地登录信息
//        [User removeLoginData];
//        //发送通知告诉web token变动
//        // 退出环信
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate logoutHuaXinServer];
//        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
//        [weakSelf update];
//        [weakSelf.tabBarController setSelectedIndex:0];
    }];
    
    //邀请
    [self.bridge registerHandler:@"jumpToInvite" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToInvite----");
        
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        if (User.userToken) {
            [pramaDic setObject:User.userToken forKey:@"bte-token"];
        }
        [pramaDic setObject:kGetUserInvateFrendUrl forKey:@"url"];
        
        methodName = kGetHomePageUserInvateFrend;
        
//        NSLog(@"--------pramaDic----%@----");
//        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//            NMRemovLoadIng;
//            NSLog(@"kGetUserInvateFrend-------->%@",responseObject);
            //        NSLog(@"kGetUserInvateFrend-------->%@",responseObject[@""]);
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
        
//        BTEInviteFriendViewController *invateVc = [[BTEInviteFriendViewController alloc] init];
////        if ([self.urlString isEqualToString:kAppBTEH5MyAccountAddress]) {
////            invateVc.fromVCType = FromPersonVC;
////        }else{
////            invateVc.fromVCType = FromScroeVC;
////        }
//        [weakSelf.navigationController pushViewController:invateVc animated:YES];
        
    }];

    
    //跳转k线
    [self.bridge registerHandler:@"jumpToMarketDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"---registerHandler---jumpToMarketDetail-----%@",data);
        if (data && [data objectForKey:@"base"]) {
            BTEKlineViewController *homePageVc= [[BTEKlineViewController alloc] init];
            HomeDesListModel * delistModel = [[HomeDesListModel alloc] init];
            [delistModel initDict:data];
            homePageVc.desListModel = delistModel;
            [weakSelf.navigationController pushViewController:homePageVc animated:YES];
        }
    }];
    
    //点击返回首页
    // 或者 市场分析详情点击返回
    [self.bridge registerHandler:@"jumpToDiscoverView" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"---registerHandler--jumpToDiscoverView------%@",self.urlString);
        if ( [self.urlString isEqualToString:kAppBTEH5DogAddress] ) {
            [weakSelf reloadWebView:kAppBTEH5DogAddress];
            if(weakSelf.isPresentVCFlag){
                self.navigationItem.leftBarButtonItem = [self createLeftBarItem];
            }else{
                weakSelf.navigationItem.hidesBackButton = NO;
            }
        }

        if ([self.urlString rangeOfString:kAppDetailDealAddress].location != NSNotFound) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf reloadWebView:self.urlString];
        }
        
        if ([self.urlString rangeOfString:kAppStrategyAddress].location != NSNotFound) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf reloadWebView:self.urlString];
        }
        
        if ( [self.urlString isEqualToString:kAppBTEH5DogAddress] ) {
            [weakSelf reloadWebView:kAppBTEH5DogAddress];
            if(weakSelf.isPresentVCFlag){
                self.navigationItem.leftBarButtonItem = [self createLeftBarItem];
            }else{
                weakSelf.navigationItem.hidesBackButton = NO;
            }
        }
        
        if( [self.urlString isEqualToString:kAppBTEH5featureReportAddress] ){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
//        if (weakSelf.tabBarController.selectedIndex == 0) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//            [weakSelf reloadWebView:self.urlString];
//        } else
//        {
//            if (weakSelf.tabBarController.selectedIndex == 1) {
//
//                [weakSelf reloadWebView:self.urlString];
//                //                if (weakSelf.tabBarController.selectedIndex == 2) {
//                //                    self.sharetitle = luzhuangDogTitleStr;
//                //                    self.shareDesc = luzhuangDogStr;
//                ////                    weakSelf.navigationItem.title = @"撸庄狗";
//                //                }
//                //                if (weakSelf.tabBarController.selectedIndex == 1) {
//                ////                    weakSelf.navigationItem.title = @"行情数据";
//                //                }
//
//                // 强制显示tabbar
//                weakSelf.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - TAB_BAR_HEIGHT);
//                weakSelf.view.height = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
//                weakSelf.tabBarController.tabBar.hidden = NO;
//                weakSelf.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
//                return ;
//            }
//
//            //策略 点击 回到首页
//            if (weakSelf.tabBarController.selectedIndex == 2) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGoToHomePage object:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//
//
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:@"top" forKey:@"top"];
//            [defaults synchronize];
//            [weakSelf.tabBarController setSelectedIndex:0];
//        }
    }];
    
    //h5页面  点击调起分享
    [self.bridge registerHandler:@"touchShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"i send touchShare registerHandler---%@",data);
        if (data && [data objectForKey:@"source"]
            //            && [weakSelf.navigationItem.title  isEqual: @"比特易赚积分秘籍"]
            ){
            if([[data objectForKey:@"source"] isEqualToString:@"feature"]){
                self.sharetitle = luzhuangDogTitleStr = @"撸庄狗-韭菜撸庄利器";
                self.shareUrl = kAppBTEH5DogAddress;
                self.shareType = UMS_SHARE_TYPE_WEB_LINK;
                [self getUserCountAndincome];
                [weakSelf shareAlert];
                return;
            }
        }
        

        if ( [self.urlString isEqualToString:kAppBTEH5DogAddress] && ![weakSelf.navigationItem.title  isEqual: @"撸庄狗每周战报"]){
            if (data && [data objectForKey:@"id"]) {
                weakSelf.isHiddenLeft = NO;
                [weakSelf reloadWebView: [NSString stringWithFormat:@"%@%@",kAppDetailDealAddress, [data objectForKey:@"id"]]];
                return;
            }
        }

        
        if (data && [data objectForKey:@"source"]
//            && [weakSelf.navigationItem.title  isEqual: @"比特易赚积分秘籍"]
            ) {
            if([[data objectForKey:@"source"] isEqualToString:@"index"]){
                self.shareDesc = @"比特易-数字货币市场专业分析工具";
                self.sharetitle = @"比特易是业界领先的数字货币市场专业分析工具，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具";
                self.shareUrl = kGetUserInvateFrendUrl;
                self.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
                [weakSelf shareAlert];
                return;
            }
            
        }
     
        if (data && [data objectForKey:@"source"]
//            && [weakSelf.navigationItem.title  isEqual: @"比特易赚积分秘籍"]
            ){
            if([[data objectForKey:@"source"] isEqualToString:@"bandDog"]){
                self.sharetitle =  @"波段狗-短线/合约玩家必备";
                self.shareUrl = kAppBrandDogAddress;
                self.shareType = UMS_SHARE_TYPE_WEB_LINK;
                [self getbandDogUserCount];
                 [weakSelf shareAlert];
                return;
            }
        }
        
        if (data && [data objectForKey:@"source"]
//            && [weakSelf.navigationItem.title  isEqual: @"比特易赚积分秘籍"]
            ){
            if([[data objectForKey:@"source"] isEqualToString:@"contract"]){
                self.sharetitle =  @"合约狗-合约市场专用分析工具";
                self.shareDesc = @"合约狗为您深度挖掘和处理合约交易数据，是技术派选手的必备工具";
                self.shareUrl = kAppContractDogAddress;
                self.shareType = UMS_SHARE_TYPE_WEB_LINK;
                [weakSelf shareAlert];
                return;
            }
        }
       
        [weakSelf shareAlert];
    }];
    
    //标识是否是index页面 隐藏左返回键
    [self.bridge registerHandler:@"oneClass" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"------registerHandler-----------oneClass---%@",data);
        //        weakSelf.isHiddenLeft = YES;
        if (data) {
            int flag = [[data objectForKey:@"isOpenDog"] intValue];
            if (flag){
                NSSet *set;
//                set = [NSSet setWithObjects:klzDogVotePush,nil];
//                [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                        NSLog(@"iTags---add---klzDogVotePush-->%@",iTags);
//                    } seq:1];
//                } seq:1];
            }
        }
        
        if (data) {
            int flag = [[data objectForKey:@"isBandDog"] intValue];
//            NSSet *set;
//            set = [NSSet setWithObjects:kbandDogPush,nil];
//            if (flag){
//                
//                [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                        NSLog(@"iTags-----add kbandDogPush--->%@",iTags);
//                    } seq:1];
//                } seq:1];
//                
//            }
        }
        
        
        if (data && [data objectForKey:@"title"]) {
            weakSelf.navigationItem.title = [data objectForKey:@"title"];
//            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
    }];
    
    //标识是否是index页面 显示左返回键
    [self.bridge registerHandler:@"twoIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"----registerHandler------twoIndex---%@",data);
        weakSelf.isHiddenLeft = YES;
        
        if(weakSelf.isPresentVCFlag){
            self.navigationItem.leftBarButtonItem = nil;
        }else{
            weakSelf.navigationItem.hidesBackButton = YES;
        }
        
        if (data && [data objectForKey:@"title"]) {
            weakSelf.navigationItem.title = [data objectForKey:@"title"];
        }

        if (data && [data objectForKey:@"url"]) {
            weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItem];
            weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
            
            if ([[data objectForKey:@"url"] rangeOfString:@"wechat/strategyDetail/"].location != NSNotFound) {
                weakSelf.navigationItem.hidesBackButton = NO;
                weakSelf.sharetitle = [NSString stringWithFormat:@"比特易—%@,当前收益%@%%",weakSelf.productInfoModel.name,weakSelf.productInfoModel.ror];
                weakSelf.shareDesc =  [NSString stringWithFormat:@"我跟随了比特易%@，当前收益%@%%，比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具。",weakSelf.productInfoModel.name,weakSelf.productInfoModel.ror];

            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/marketDetail/"].location != NSNotFound)
            {
                weakSelf.sharetitle = @"比特易—数字货币分析平台";
                NSString *price = [NSString positiveFormat:weakSelf.desListModel.price];
                weakSelf.shareDesc = [NSString stringWithFormat:@"%@当前价格：$%@\t\n走势分析：%@\t\n操作建议：%@",weakSelf.desListModel.symbol,price,weakSelf.desListModel.trend,weakSelf.desListModel.operation];

                if (weakSelf.tabBarController.selectedIndex == 1) {
                    weakSelf.isHiddenLeft = YES;
                    weakSelf.navigationItem.rightBarButtonItem = nil;
                }

            }else if ([[data objectForKey:@"url"] rangeOfString:@"wechat/researchReport/"].location != NSNotFound)
            {
                weakSelf.navigationItem.hidesBackButton = NO;
                weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItemDetail];
                weakSelf.sharetitle = [NSString stringWithFormat:@"%@",[data objectForKey:@"type"]];
                weakSelf.shareDesc = [data objectForKey:@"summary"];
            }else if([[data objectForKey:@"url"] rangeOfString:@"wechat/featureReport"].location != NSNotFound){
                weakSelf.isHiddenLeft = NO;
                if(self.isFromReviewLuZDog){
                    weakSelf.navigationItem.hidesBackButton = NO;
                    weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItemDetail];
                }
               
                NSString  *week_income = [NSString stringWithFormat:@"%.2f", [[data objectForKey:@"week_income"] floatValue]];
                NSString  *week_count = [data objectForKey:@"week_count"] ;
                if (week_income && week_count) {
                    self.sharetitle = [NSString stringWithFormat: @"撸庄狗周报-本周共撸%@次，收益%@%@",week_count,week_income,@"%"];
                    self.shareDesc = [NSString stringWithFormat:@"撸庄狗是通过人工智能结合交易专家分析，实时预判并提示小币种拉盘、出货等各种迹象的工具、本周收益%@%@",week_income,@"%"];
                }
                self.shareUrl = self.urlString;
            }else if([[data objectForKey:@"url"] rangeOfString:@"wechat/report"].location != NSNotFound){
                weakSelf.isHiddenLeft = NO;
                [weakSelf reloadWebView:[data objectForKey:@"url"]];
                weakSelf.sharetitle = [data objectForKey:@"title"];
                weakSelf.navigationItem.title = self.sharetitle;
                weakSelf.shareDesc = [data objectForKey:@"content"];
            }
            weakSelf.shareUrl = [data objectForKey:@"url"];
        } else
        {
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
    }];
    
    //h5页面 撸庄狗 波段狗 点击获取积分 跳转到获取积分页面
    [self.bridge registerHandler:@"jumpToPoint" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToPoint----");
        if (data && [data objectForKey:@"source"]) {
            NSLog(@"--------registerHandler----jumpToPoint----%@", [data objectForKey:@"source"]);
            
            
            if([[data objectForKey:@"source"] isEqualToString:@"feature"]){
                self.sharetitle = luzhuangDogTitleStr = @"撸庄狗-韭菜撸庄利器";
                self.shareUrl = kAppBTEH5DogAddress;
                self.shareType = UMS_SHARE_TYPE_WEB_LINK;
                [self getUserCountAndincome];
            }
            
            
        }
        weakSelf.isHiddenLeft = NO;
        NSString *urlStr = [NSString stringWithFormat:@"%@?source=%@",kAppBTEH5integralCheatsAddress, [data objectForKey:@"source"]];
        NSLog(@"--------urlStr----jumpToPoint----%@",urlStr);
        [weakSelf reloadWebView:urlStr];
    }];
    
    //h5市场分析详情点击返回首页
    [self.bridge registerHandler:@"jumpToWeekReport" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"--------registerHandler----jumpToWeekReport----");
        [weakSelf reloadWebView:kAppBTEH5featureReportAddress];
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationReSetPassword object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendUserTokenAndReloadWebView) name:NotificationUserLoginSuccess object:nil];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([self.urlString isEqualToString:kAppBTEH5DogAddress]) {
        self.navigationItem.rightBarButtonItem = [self creatRightBarItemDetail];
        self.sharetitle = luzhuangDogTitleStr = @"撸庄狗-韭菜撸庄利器";
        self.shareUrl = self.urlString;
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;
        [self getUserCountAndincome];
        //因为现在在撸装狗里面如果收到 推送 或者周报的话 会推到市场分析报告 隐藏tabbar那么返回的时候就需要再次 把tabbar显示出来
        
        
//        if(![self.navigationItem.title isEqualToString: @"比特易赚积分秘籍"]){
//            self.tabBarController.tabBar.hidden = NO;
//            self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
//        }
        
    }
    
    if ([self.urlString isEqualToString:kAppBrandDogAddress]) {
        self.navigationItem.rightBarButtonItem = [self creatRightBarItemDetail];
        self.sharetitle =  @"波段狗-短线/合约玩家必备";
        self.shareUrl = self.urlString;
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;
        [self getbandDogUserCount];
    }
    
    if ([self.urlString isEqualToString:kResearchDogAddress]) {
        self.navigationItem.rightBarButtonItem = [self creatRightBarItemDetail];
        self.sharetitle =  @"研究狗-汇聚最专业的研究报告";
        self.shareUrl = self.urlString;
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;
        [self getResearchDogUserCount];
        if(self.isPresentVCFlag){
            self.navigationItem.leftBarButtonItem = [self createLeftBarItem];
        }else{
            self.navigationItem.hidesBackButton = NO;
        }
//        [self update];
    }
    
    
    if ([self.urlString rangeOfString:@"wechat/strategyDetail/"].location != NSNotFound) {

    }
    
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendUserToken];
    });
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    NSString *numHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (numHtmlInfo.length != 0) {
        self.navigationItem.title = numHtmlInfo;
    }
}

#pragma mark - sendUserToken
- (void)sendUserToken{
    NSLog(@"i send userToken ---%@",User.userToken);
    
//    [self.bridge registerHandler:@"sendUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
//        responseCallback(@{@"sessionId": User.userToken,});
//    }];
}

- (void)update {
    [self reloadWebView:self.urlString];
}

- (void)sendUserTokenAndReloadWebView{
    [self sendUserToken];
    [self update];
}

- (void)shareAlert{
    //活动详情页
    if (self.ActivityId) {
        [self getShareMyAccountLoginStatus];
    }
    else{
        [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
    }
}

#pragma mark - goback返回
- (void)goback {
    [super goback];
    UINavigationController *nav = self.tabBarController.selectedViewController;
    NSLog(@"nav.visibleViewController.navigationItem.title-------->%@",nav.visibleViewController.navigationItem.title);
    NSLog(@"urlstring----->%@",self.urlString);
    if ([self.urlString isEqualToString:kResearchDogAddress]) {
        self.sharetitle =  @"研究狗-汇聚最专业的研究报告";
        self.shareUrl = self.urlString;
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;
        [self getResearchDogUserCount];
    }
    
    if ([self.urlString isEqualToString:kAppBTEH5DogAddress]) {
        if(self.isPresentVCFlag){
            self.navigationItem.leftBarButtonItem = [self createLeftBarItem];
        }else{
            self.navigationItem.hidesBackButton = NO;
        }
        self.sharetitle = luzhuangDogTitleStr = @"撸庄狗-韭菜撸庄利器";
        self.shareUrl = self.urlString;
        self.shareType = UMS_SHARE_TYPE_WEB_LINK;
        [self getUserCountAndincome];
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
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:weakSelf.shareUrl sharetitle:weakSelf.sharetitle shareDesc:weakSelf.shareDesc shareType:weakSelf.shareType currentVc:weakSelf];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
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
    NMShowLoadIng;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            weakSelf.navigationItem.title = [[responseObject objectForKey:@"data"] objectForKey:@"title"];
            weakSelf.navigationItem.rightBarButtonItem = [weakSelf creatRightBarItem];
            weakSelf.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
            weakSelf.sharetitle = [NSString stringWithFormat:@"比特易-%@",[[responseObject objectForKey:@"data"] objectForKey:@"title"]];
            weakSelf.shareDesc = [[responseObject objectForKey:@"data"] objectForKey:@"summary"];
            weakSelf.shareUrl = [[responseObject objectForKey:@"data"] objectForKey:@"shareUrl"];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)getUserCountAndincome{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kFromSummaryCountAndincome;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        //        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            HomeDogCountModel * homedogCountModel = [[HomeDogCountModel alloc] init];
            homedogCountModel.income = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalIncome"]];
            homedogCountModel.userCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCount"]];
            homedogCountModel.recentCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"recentRecommendCount"]];
            //[HomeDogCountModel yy_modelWithDictionary:responseObject[@"data"]];
            NSString  *incomePercent = [NSString stringWithFormat:@"%.2f", [homedogCountModel.income floatValue]];
            luzhuangDogStr =  [NSString stringWithFormat:@"撸庄狗是通过人工智能结合交易专家分析，实时预判并提示小币种拉盘、出货等各种迹象的工具。近30天收益%@%@",incomePercent,@"%"];
            weakSelf.shareDesc = luzhuangDogStr;
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)getbandDogUserCount{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kFromBandDogUserCount;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        //        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSString *bandDogCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCount"]];
            weakSelf.shareDesc = [NSString stringWithFormat: @"实时提供主流币买卖点提示，是短线/合约玩家的必备利器。已有%@人正在做波段。",bandDogCount];
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//获取研究狗 正在使用的人数
- (void)getResearchDogUserCount{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    
    methodName = kGetResearchDogCount;
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
        
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSString *researchDogCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"result"]];
            weakSelf.shareDesc = [NSString stringWithFormat: @"4家研究机构，为您提供%@篇最专业的数字货币研究报告",researchDogCount];
        }
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

- (UIBarButtonItem *)creatRightBarItemDetail {
    UIImage *buttonNormal = [[UIImage imageNamed:@"Group 24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

//默认是不显示的
-(void)setIsPresentVCFlag:(BOOL)isPresentViewController{
    _isPresentVCFlag  = isPresentViewController;
    self.navigationItem.leftBarButtonItem = isPresentViewController ? [self createLeftBarItem] : nil;
}

- (UIBarButtonItem *)createLeftBarItem{
    UIImage * image = [UIImage imageNamed:@"nav_back"];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    btn.bounds = CGRectMake(0, 0, 60, 40);
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, - btn.width + MIN(image.size.width, 14), 0, 0);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

//返回
-(void)backAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
