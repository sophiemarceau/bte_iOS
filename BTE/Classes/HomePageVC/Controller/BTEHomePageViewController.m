//
//  BTEHomePageViewController.m
//  BTE
//
//  Created by wangli on 2018/1/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEHomePageViewController.h"
#import "BTEShareView.h"
#import "HomeDescriptionModel.h"
#import "HomeDesListModel.h"
#import "HomeProductModel.h"
#import "HomeProductInfoModel.h"
#import "HomeDogCountModel.h"
#import "BTECurrencyTypePickerView.h"
#import "BTELeftView.h"
#import "BTEActivityView.h"
#import "UserStatistics.h"
#import "ZTYTestViewController.h"
#import "BTEKlineViewController.h"
#import "BTEKlineWebViewController.h"
#import "BTEZTYKLIneViewController.h"
#import "SharePicView.h"
#import "ZTYCircleLayer.h"
#import "ChatViewController.h"
#import "BTEKlineContractViewController.h"
#import "ZTYKlineTestViewController.h"
//#import "SecondLevelWebViewController.h"
#import "SecondaryLevelWebViewController.h"
#import "HomeBannerModel.h"
#import "BTEInviteFriendViewController.h"
#import "ZTGCDTimerManager.h"
#import "PhoneInfo.h"
#import "AtmosphereModel.h"
#import "MessageCenterViewController.h"
#import "JSBadgeView.h"
#import "DugCoinViewContrllerViewController.h"
#import "InfoObject.h"
#import "CoinListViewController.h"
#import "SharedDugView.h"
#import "ChainViewController.h"
#import "CoinOfficeViewController.h"
#import "SearchCoinViewController.h"

@interface BTEHomePageViewController ()
{
    HomeDescriptionModel *descriptionModel;
    HomeDogCountModel *luzDogCountModel;
    NSArray *detailsList;
    NSArray *productList;
    HomeProductInfoModel *productInfoModel;
    UIButton *leftBtn;
    NSString *currentCurrencyType;//记录当前展示币种
    UIView *selectView;//下拉选择框
    NSArray *announcement;//公告内容
    NSArray *productInfoModelList;
    
    HomeDogCountModel *bandDogCountModel;
    HomeDogCountModel *contractDogModel;
    HomeDogCountModel *researchDogModel;
    HomeDogCountModel *stareDogModel;
    HomeDogCountModel *chainCheckModel;
    AtmosphereModel *atmosphereModel;
    SecondaryLevelWebViewController *bodunVC;
//    BTEKlineContractViewController *contractVC;
    SecondaryLevelWebViewController *researchVC;
    SecondaryLevelWebViewController *luzhuangDogVC;
     SecondaryLevelWebViewController *stareDogVC;
    SecondaryLevelWebViewController *chainCheckVC;
    BOOL isSignFlag;
    NSArray *bannerList;
    UIImage *decodedImage;
    NSString *invteCodeStr,*unReadNumStr;
    HomeDesListModel *eventmodel;
    UIImageView *leftBtnImageView;
     BOOL isOpenDigFlag;
}
//分享需要的参数
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;
@property (nonatomic, copy) ShareViewCallBack shareViewCallBack;

@property (nonatomic, strong) UIButton *signButton;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIButton *getScoreButton;
@property (nonatomic, strong) UIButton *dugButton;
@property (nonatomic, strong) NSDictionary *dicInvate;
@property (nonatomic, strong) JSBadgeView *badgeView;
@end

@implementation BTEHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    unReadNumStr = 0;
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    isOpenDigFlag = NO;
    isSignFlag = NO;
    bodunVC = [[SecondaryLevelWebViewController alloc] init];
//    contractVC = [[BTEKlineContractViewController alloc] init];
    researchVC = [[SecondaryLevelWebViewController alloc] init];
    luzhuangDogVC = [[SecondaryLevelWebViewController alloc] init];
    stareDogVC = [[SecondaryLevelWebViewController alloc] init];
    chainCheckVC = [[SecondaryLevelWebViewController alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self customtitleView];
    self.navigationItem.rightBarButtonItem = [self creatRightBarItem];
    self.navigationItem.leftBarButtonItem = [self creatLeftBarItem];
    
    self.badgeView = [[JSBadgeView alloc] initWithParentView:leftBtnImageView  alignment:JSBadgeViewAlignmentTopRight];
    self.badgeView.badgeBackgroundColor = BHHexColor(@"F01313");
    self.badgeView.badgeOverlayColor =  BHHexColor(@"F01313");//没有反光面
    self.badgeView.badgeStrokeColor = BHHexColor(@"F01313");//外圈的颜色，默认是白色
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([[defaults objectForKey:MobileTradeNum] integerValue] == 1) {
////        self.navigationItem.leftBarButtonItem = [self creatLeftBarItem];
//    }
//    else
//    {
//        self.navigationItem.leftBarButtonItem = nil;
//    }
    
    self.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
    self.sharetitle = @"比特易-数字货币市场专业分析平台";
    self.shareDesc = @"比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具。";
    self.shareUrl = kAppBTEH5AnalyzeAddress;
    
    if (self.homePageTableView == nil) {
        self.homePageTableView = [[BTEHomePageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_HEIGHT)];
        self.homePageTableView.delegate = self;
    }
    
    [self.view addSubview:self.homePageTableView];
    

    self.signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signButton setImage:[UIImage imageNamed:@"signFloatBtn"] forState:UIControlStateNormal];
    self.signButton.frame = CGRectMake(SCREEN_WIDTH - 48, SCREEN_HEIGHT -TAB_BAR_HEIGHT- 74 - 42 - 16 - 42 - 16 - 42 - (IS_IPHONEX ? 34 : 0), 48, 42);
    
    self.inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.inviteButton setImage:[UIImage imageNamed:@"inviteFloatBtn"] forState:UIControlStateNormal];
    self.inviteButton.frame = CGRectMake(SCREEN_WIDTH - 48,SCREEN_HEIGHT-TAB_BAR_HEIGHT - 74 - 42 -16 - 42 - (IS_IPHONEX ? 34 : 0), 48, 42);
    
    
    self.getScoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getScoreButton setImage:[UIImage imageNamed:@"getScoreBtn"] forState:UIControlStateNormal];
    self.getScoreButton.frame = CGRectMake(SCREEN_WIDTH - 48, SCREEN_HEIGHT-TAB_BAR_HEIGHT - 74 -42 - (IS_IPHONEX ? 34 : 0), 48, 42);

    self.dugButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dugButton setImage:[UIImage imageNamed:@"digEntranceIcon"] forState:UIControlStateNormal];
    self.dugButton.frame = CGRectMake(SCREEN_WIDTH - 53, SCREEN_HEIGHT -TAB_BAR_HEIGHT- 74 - 42 - 16 - 42 - 16 - 42 - 16 - 40 - (IS_IPHONEX ? 34 : 0), 53, 52);
    [self.view addSubview:self.dugButton];
    [self.view addSubview:self.signButton];
    [self.view addSubview:self.getScoreButton];
    [self.view addSubview:self.inviteButton];
    [self.signButton addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    self.signButton.tag = 3001;
    [self.inviteButton addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
     self.inviteButton.tag = 3002;
    [self.getScoreButton addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    self.getScoreButton.tag = 3003;
    [self.dugButton addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    self.dugButton.tag = 3004;
    //活动检测
    [self checkActivity];
    WS(weakSelf)
    self.homePageTableView.homePageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf updateRequest];
        if (User.userToken) {
            [self getIfCheckin];
//            [self getUserInvateFrend];
        }
    }];
    [weakSelf reloadRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoTabHome) name:NotificationGoToHomePage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLoginStatusRefresh) name:NotificationUpdateUserLoginStatus object:nil];
}

-(void)updateLoginStatusRefresh{
    [self.homePageTableView.homePageTableView reloadData];
}

// 更新各种数据刷新
-(void)reloadRequest{
    //    [self getUserCountAndincome];
    //    [self getbandDogUserCount];
    //    [self getResearchDogUserCount];
    //    [self getContractDogUserCount];
    [self getBanner];
    //获取最新的推荐列表
    [self getlatestsStatus];
    [self getlatestsNews];
    [self getlatestsProduct];
    [self getAtmosphereData];
    //公告
    [self getAnnouncement];
    [self getDogs];
    //    [self getUserInvateFrend];
}

// 更新各种数据刷新
-(void)updateRequest{
    //    [self getUserCountAndincome];
    //    [self getbandDogUserCount];
    //    [self getResearchDogUserCount];
    //    [self getContractDogUserCount];
    [self getBanner];
    //获取最新的推荐列表
    [self getlatestsStatus];
    [self getlatestsNews];
    [self getlatestsProduct];
    [self getAtmosphereData];
    //公告
    [self getAnnouncement];
    [self getDogs];
    [self getDigInfo];
//    [self getUserInvateFrend];
}

-(void)buttonOnclick:(UIButton *)sender{
    sender.enabled = NO;
    if (sender.tag == 3002) {//邀请功能 没登录 返回的是 没用用户信息的二维码 // 如果登录了 则要返回的是有 这个登录用户的二维码
        [self getTagToDo:sender.tag];
    }else{
        if(!User.userToken){
            [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                if (isComplete) {
                    [self getTagToDo:sender.tag];
                }
            }];
            sender.enabled = YES;
        }else{
            
            [self getTagToDo:sender.tag];
            sender.enabled = YES;
        }
    }
}

-(void)getTagToDo:(NSInteger)tag{
    if(tag == 3001){
        if (isSignFlag) {
            [BHToast showMessage:@"今日已签到"];
            return;
        }else{
            [self checkin];
        }
    }

    if(tag == 3002){
        self.inviteButton.enabled = NO;
//        NSMutableDictionary * pramaDic = @{}.mutableCopy;
//        NSString * methodName = @"";
//        if (User.userToken) {
//            [pramaDic setObject:User.userToken forKey:@"bte-token"];
//        }
//        [pramaDic setObject:kGetUserInvateFrendUrl forKey:@"url"];
//
//        methodName = kGetHomePageUserInvateFrend;
//        NSLog(@"kGetUserInvateFrend-----pramaDic--->%@",pramaDic);
//        WS(weakSelf)
////        NMShowLoadIng;
//        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
////            NMRemovLoadIng;
//            NSLog(@"kGetUserInvateFrend-------->%@",responseObject);
//            //        NSLog(@"kGetUserInvateFrend-------->%@",responseObject[@""]);
//            if (IsSafeDictionary(responseObject)) {
//                weakSelf.dicInvate = [responseObject objectForKey:@"data"];
//
//                if (_dicInvate) {
//                    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:[_dicInvate objectForKey:@"base64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                    decodedImage = [UIImage imageWithData:decodedImageData];
//                    invteCodeStr = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"][@"inviteCode"]];
//
//
//
//                    [SharePicView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:nil sharetitle:nil shareDesc:nil shareType:UMS_SHAREPic_TYPE_IMAGE currentVc:nil WithQrImage:decodedImage WithInviteCode:invteCodeStr];
//                }
//            }
//            self.inviteButton.enabled = YES;
//        } failure:^(NSError *error) {
////            NMRemovLoadIng;
//            RequestError(error);
//            NSLog(@"error-------->%@",error);
//            self.inviteButton.enabled = YES;
//        }];
//         [SharePicView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:nil sharetitle:nil shareDesc:nil shareType:UMS_SHAREPic_TYPE_IMAGE currentVc:nil WithQrImage:decodedImage WithInviteCode:invteCodeStr];
        [SharedDugView popShareViewCallBack:^{
          
        } imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:@"" sharetitle:@"" shareDesc:@"" shareType:UMSHAREPic_TYPE_IMAGE currentVc:self WithQrImage:decodedImage WithInviteCode:invteCodeStr WithDugNum:nil];
         self.inviteButton.enabled = YES;
    }
    
    if(tag == 3003){
        SecondaryLevelWebViewController * secondLevelVc = [[SecondaryLevelWebViewController alloc] init];
        secondLevelVc.urlString = [NSString stringWithFormat:@"%@%@",kAppBTEH5integralCheatsAddress,@"?source=index"];
        secondLevelVc.isHiddenLeft = YES;
        secondLevelVc.isHiddenBottom = YES;
        [self.navigationController pushViewController:secondLevelVc animated:YES];
    }
    if (tag == 3004) {
        [self eventCountToServerWithClickType:@"icon" WithModuleString:@"dig"];
        
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString *methodName = @"";
        if (User.userToken) {
            [pramaDic setObject:User.userToken forKey:@"bte-token"];
        }
        [pramaDic setObject:@"ios" forKey:@"terminal"];
        methodName = kGetDigInfo;
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
            NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {
                NSLog(@"getDigInfo-->%@",responseObject);
                isOpenDigFlag = [responseObject[@"data"][@"info"][@"status"] boolValue];
                NSString *codeStr =  responseObject[@"data"][@"code"];
                if (isOpenDigFlag) {
                    DugCoinViewContrllerViewController *vc =  [[DugCoinViewContrllerViewController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    SecondaryLevelWebViewController *vc = [[SecondaryLevelWebViewController alloc] init];
                    vc.urlString = [NSString stringWithFormat:@"%@?inviteCode=%@",kAppDugHomePageAddress,codeStr];
                    vc.isHiddenLeft = YES;
                     NSLog(@"getDigInfo-->%@",vc.urlString);
                    vc.isHiddenBottom = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error-------->%@",error);
        }];
    }
}

-(void)gotoTabHome{
    [self.navigationController popToRootViewControllerAnimated:NO];
     [self.tabBarController setSelectedIndex:0];
}

//关闭公告
- (void)closeGonggao
{
    announcement = nil;
    //刷新tableview
    [self.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:luzDogCountModel WithBandDog:bandDogCountModel WithContractDog:contractDogModel WithResearchDog:researchDogModel WithBannerArray:bannerList WithStartDog:stareDogModel WithAtmosphereData:atmosphereModel Withlianchacha:chainCheckModel];
    
//    [self.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:homeDogCountModel WithBandDogCount:bandDogCountStr WithContractDoyCount:contractDogCountStr WithResearchDogCountStr:researchDogCountStr WithBannerArray:bannerList WithAgencyCountStr:agencyCount];
}

-(void)gotoMessageVc{
    if(!User.userToken){
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            if (isComplete) {
                [self getUnReadNumStrFromServer];
            }
        }];
    }else{
        [self requestSetRead];
//        MessageCenterViewController * kvc = [[MessageCenterViewController alloc] init];
//        CoinListViewController *kvc = [[CoinListViewController alloc] init];
//        ChainViewController  *kvc = [[ChainViewController alloc] init];
//        CoinOfficeViewController  *kvc = [[CoinOfficeViewController alloc] init];
        SearchCoinViewController *kvc = [[SearchCoinViewController alloc] init];
        [self.navigationController pushViewController:kvc animated:YES];
    }
}

- (void)shareAlert
{
//    if (User.userToken) {
//        NSMutableDictionary * pramaDic = @{}.mutableCopy;
//        NSString * methodName = @"";
//        if (User.userToken) {
//            [pramaDic setObject:User.userToken forKey:@"bte-token"];
//        }
//        [pramaDic setObject:kGetUserInvateFrendUrl forKey:@"url"];
//
//        methodName = kGetHomePageUserInvateFrend;
//
//        WS(weakSelf)
////        NMShowLoadIng;
//        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
////            NMRemovLoadIng;
//            NSLog(@"kGetUserInvateFrend-------->%@",responseObject);
//            //        NSLog(@"kGetUserInvateFrend-------->%@",responseObject[@""]);
//            if (IsSafeDictionary(responseObject)) {
//                weakSelf.dicInvate = [responseObject objectForKey:@"data"];
//
//                if (_dicInvate) {
//                    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:[_dicInvate objectForKey:@"base64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                    decodedImage = [UIImage imageWithData:decodedImageData];
//                    invteCodeStr = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"][@"inviteCode"]];
//
//                }
//            }
//
//        } failure:^(NSError *error) {
////            NMRemovLoadIng;
//            RequestError(error);
//            NSLog(@"error-------->%@",error);
//            //        self.inviteButton.enabled = YES;
//            if(error.code == -1){
//                [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
//                    if (isComplete) {
//                        [self shareAlert];
//                    }
//                }];
//            }
//        }];
//    }else{
//        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
//            if (isComplete) {
//                [self getTagToDo:3001];
//            }
//        }];
//    }
   
    //    [selectView removeFromSuperview];
//    [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
     [UserStatistics sendEventToServer:@"首页点击右上角分享"];
    [SharedDugView popShareViewCallBack:^{
        
    } imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:@"" sharetitle:@"" shareDesc:@"" shareType:UMSHAREPic_TYPE_IMAGE currentVc:self WithQrImage:decodedImage WithInviteCode:invteCodeStr WithDugNum:nil];
//     [SharePicView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:nil sharetitle:nil shareDesc:nil shareType:UMS_SHAREPic_TYPE_IMAGE currentVc:nil WithQrImage:decodedImage WithInviteCode:invteCodeStr];
}

- (void)jumpToDetail:(HomeDesListModel *)model
{
    [UserStatistics sendEventToServer:@"进入K线"];
    BTEKlineViewController * kvc = [[BTEKlineViewController alloc] init];
    kvc.desListModel = model;
    eventmodel = model;
    kvc.isRead = model.isRead;
    [self.navigationController pushViewController:kvc animated:YES];
    [self requeestEvent:@"market_kline"];
}

//首页 点击列表 进入市场分析报告页面
- (void)jumpToDetails:(HomeDescriptionModel *)model
{
    SecondaryLevelWebViewController *marketAnalysisReportVC= [[SecondaryLevelWebViewController alloc] init];
    marketAnalysisReportVC.urlString = [NSString stringWithFormat:@"%@%@",kAppDetailDealAddress,model.id];
    marketAnalysisReportVC.isHiddenLeft = YES;
    marketAnalysisReportVC.isHiddenBottom = YES;
    [self.navigationController pushViewController:marketAnalysisReportVC animated:YES];
}

//首页 点击列表 进入策略跟随详情页面
- (void)jumpToStrategyFollow:(HomeProductInfoModel *)productInfoModeltemp
{
    SecondaryLevelWebViewController *strategyFollowDetailVC= [[SecondaryLevelWebViewController alloc] init];
    strategyFollowDetailVC.urlString = [NSString stringWithFormat:@"%@%@",kAppStrategyAddress,productInfoModeltemp.id];
    strategyFollowDetailVC.isHiddenLeft = YES;
    strategyFollowDetailVC.isHiddenBottom = YES;
    strategyFollowDetailVC.productInfoModel = productInfoModeltemp;
    [self.navigationController pushViewController:strategyFollowDetailVC animated:YES];
}

- (void)jumpToTradeDataPage {
    [UserStatistics sendEventToServer:@"首页点击市场数据"];
    [self.tabBarController setSelectedIndex:1];
}

//首页 点击 进入 撸庄狗页面
- (void)jumpToDogPage {
    luzhuangDogVC.urlString = [NSString stringWithFormat:@"%@",kAppBTEH5DogAddress];
    NSLog(@"%@",kAppBTEH5DogAddress);
    luzhuangDogVC.isHiddenLeft = NO;
    luzhuangDogVC.isHiddenBottom = YES;
    [self.navigationController pushViewController:luzhuangDogVC animated:YES];
    [self requeestEvent:@"lz_dog"];
    [UserStatistics sendEventToServer:@"首页点击撸庄狗"];
}

- (void)jumpToStrategyList {
//    [self.tabBarController setSelectedIndex:2];
    SecondaryLevelWebViewController *strategyFollowListVc= [[SecondaryLevelWebViewController alloc] init];
    strategyFollowListVc.urlString = [NSString stringWithFormat:@"%@",kAppStrategyListAddress];
    strategyFollowListVc.isHiddenLeft = YES;
    strategyFollowListVc.isHiddenBottom = YES;
    [self.navigationController pushViewController:strategyFollowListVc animated:YES];
}

- (void)jumpToBandDogPage {
    bodunVC.urlString = [NSString stringWithFormat:@"%@",kAppBrandDogAddress];
    bodunVC.isHiddenLeft = NO;
//    bodunVC.isHiddenBottom = YES;
    [self.navigationController pushViewController:bodunVC animated:YES];
    [self requeestEvent:@"band_dog"];
    [UserStatistics sendEventToServer:@"首页点击波段狗"];
}

- (void)jumpToContractDogPage {
    //    contractVC.urlString = [NSString stringWithFormat:@"%@",kAppBrandDogAddress];
    //    contractVC.isHiddenLeft = YES;
    //    contractVC.isHiddenBottom = YES;
    //    BHNavigationController * contractNavi = [[BHNavigationController alloc] initWithRootViewController:contractVC];
    BTEKlineContractViewController * contravc = [[BTEKlineContractViewController alloc] init];
    [self.navigationController pushViewController:contravc animated:YES];
    [self requeestEvent:@"future_dog"];
    [UserStatistics sendEventToServer:@"首页点击合约狗"];
}

- (void)jumpToResearchDogPage {
    researchVC.urlString = [NSString stringWithFormat:@"%@",kResearchDogAddress];
    researchVC.isHiddenLeft = NO;
    researchVC.isHiddenBottom = YES;
    [self.navigationController pushViewController:researchVC animated:YES];
    [self requeestEvent:@"research_dog"];
    [UserStatistics sendEventToServer:@"首页点击研究狗"];
}

-(void)jumpToStareDogPage{
    stareDogVC.urlString = [NSString stringWithFormat:@"%@",kStareDogAddress];
    stareDogVC.isHiddenLeft = NO;
    stareDogVC.isHiddenBottom = YES;
    [self.navigationController pushViewController:stareDogVC animated:YES];
    [self requeestEvent:@"strategy_dog"];
    [UserStatistics sendEventToServer:@"首页点击盯盘狗"];
}

-(void)jumpToChainCheckPage{
    chainCheckVC.urlString = [NSString stringWithFormat:@"%@",kAppBTECheckChainAddress];
    chainCheckVC.isHiddenLeft = NO;
    chainCheckVC.isHiddenBottom = YES;
    [self.navigationController pushViewController:chainCheckVC animated:YES];
//    [self requeestEvent:@"strategy_dog"];
    [UserStatistics sendEventToServer:@"首页点链查查"];
}

- (void)gotoAtmosphereVc:(int)vctag{
    SecondaryLevelWebViewController *vc = [[SecondaryLevelWebViewController alloc] init];
    if (vctag == 0) {
        vc.urlString = [NSString stringWithFormat:@"%@",kAirIndexAddress];
    }
    if (vctag == 1) {
        vc.urlString = [NSString stringWithFormat:@"%@",kTabAmountAddress];
    }
    if (vctag == 2) {
        vc.urlString = [NSString stringWithFormat:@"%@",kTabNetFlowAddress];
    }
    vc.isHiddenLeft = NO;
    vc.isHiddenBottom = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bannberJumpToWebView:(NSString *)urlStr{
    NSLog(@"urlStr------->%@",urlStr);
    SecondaryLevelWebViewController *bannerWebViewVc = [[SecondaryLevelWebViewController alloc] init];
    bannerWebViewVc.urlString = [NSString stringWithFormat:@"%@",urlStr];
    bannerWebViewVc.isHiddenLeft = NO;
    bannerWebViewVc.isHiddenBottom = YES;
    [self.navigationController pushViewController:bannerWebViewVc animated:YES];
    [UserStatistics sendEventToServer:@"首页点击轮播图跳转"];
}

#pragma mark - 请求接口
#pragma 首页点击事件click
-(void)requeestEvent:(NSString *)eventType{
//    if ([eventType isEqualToString:@"market_kline"]) {
////        NSString *updatetypestr = [NSString stringWithFormat:@"%@-%@",eventType,eventmodel.symbol];;
//        [self.homePageTableView pushAttention:eventType];
//    }else{
//         [self.homePageTableView pushAttention:eventType];
//    }
    if ([eventType isEqualToString:@"lz_dog"]) {//撸庄狗
        luzDogCountModel.notice = @"0";
        [self.homePageTableView pushAttention:eventType];
        //        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if([eventType isEqualToString:@"band_dog"]) {//波段狗
        bandDogCountModel.notice = @"0";
        [self.homePageTableView pushAttention:eventType];
        //         indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if([eventType isEqualToString:@"future_dog"]) {//合约狗
        contractDogModel.notice = @"0";
        [self.homePageTableView pushAttention:eventType];
        //         indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if([eventType isEqualToString:@"research_dog"]) {//研究狗
        researchDogModel.notice = @"0";
        [self.homePageTableView pushAttention:eventType];
        //         indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if([eventType isEqualToString:@"strategy_dog"]) {//盯盘狗
        //         indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        stareDogModel.notice = @"0";
        [self.homePageTableView pushAttention:eventType];
    }else {//k线行情 btc bch eos eth的短评 提示更新隐藏
        //        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.homePageTableView pushAttentioncoinString:eventmodel.symbol];
    }
    
    [self eventCountToServerWithClickType:eventType WithModuleString:@"home"];
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
    if([tagetStr isEqualToString:@"market_kline"]){
        [pramaDic setObject:eventmodel.exchange forKey:@"exchange"];
        [pramaDic setObject:eventmodel.symbol forKey:@"base"];
        [pramaDic setObject:eventmodel.quote forKey:@"quote"];
    }
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

#pragma mark - 公告
- (void)getAnnouncement
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kGetUserAnnouncement;
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            announcement = [responseObject objectForKey:@"data"];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)checkActivity
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kGetUserActivity;
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"data"] objectForKey:@"image"] && ![[[responseObject objectForKey:@"data"] objectForKey:@"image"] isEqualToString:@""]) {
                [BTEActivityView popActivateNowCallBack:^{
                    SecondaryLevelWebViewController *homePageVc= [[SecondaryLevelWebViewController alloc] init];
                    homePageVc.urlString = [[responseObject objectForKey:@"data"] objectForKey:@"url"];
                    homePageVc.isHiddenLeft = YES;
                    homePageVc.isHiddenBottom = YES;
                    homePageVc.ActivityId = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
                    homePageVc.webView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT- NAVIGATION_HEIGHT);
                    homePageVc.view.height = SCREEN_HEIGHT- NAVIGATION_HEIGHT;
                    [self.navigationController pushViewController:homePageVc animated:YES];
                } cancelCallBack:nil withUrl:[[responseObject objectForKey:@"data"] objectForKey:@"image"]];
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark - 获取消息中心未读消息数
-(void)getUnReadNumStrFromServer{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetUnReadNum;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:1 success:^(id responseObject) {
        NMRemovLoadIng;
         NSLog(@"kGetUnReadNum-------->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            unReadNumStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
            weakSelf.badgeView.badgeText = unReadNumStr;
            if ([unReadNumStr intValue] == 0) {
                weakSelf.badgeView.badgeText = nil;
            }
            [weakSelf.badgeView setNeedsLayout];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark - 设置未读消息为已读
-(void)requestSetRead{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kMessageCenterRead;
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:1 success:^(id responseObject) {
        NSLog(@"requestSetRead-------->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            unReadNumStr = @"0";
            if ([unReadNumStr intValue] == 0) {
                weakSelf.badgeView.badgeText = nil;
            }
            [weakSelf.badgeView setNeedsLayout];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark - 获取最新的推荐列表
- (void)getlatestsStatus
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetlatestInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
//            NSLog(@"responseObject--getlatestsStatus-->%@",responseObject[@"data"][@"list"]);
            descriptionModel = [HomeDescriptionModel yy_modelWithDictionary:responseObject[@"data"][@"report"]];
            detailsList = [NSArray yy_modelArrayWithClass:[HomeDesListModel class] json:responseObject[@"data"][@"list"]];
            //刷新tableview
            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:luzDogCountModel WithBandDog:bandDogCountModel WithContractDog:contractDogModel WithResearchDog:researchDogModel WithBannerArray:bannerList WithStartDog:stareDogModel WithAtmosphereData:atmosphereModel Withlianchacha:chainCheckModel];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)getIfCheckin{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kifCheckin;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            isSignFlag = [responseObject[@"data"] boolValue];
            if (isSignFlag) {
                 [weakSelf.signButton setImage:[UIImage imageNamed:@"alreadysignFloatBtn"] forState:UIControlStateNormal];
            }else{
                [weakSelf.signButton setImage:[UIImage imageNamed:@"signFloatBtn"] forState:UIControlStateNormal];
            }
//            NSLog(@"kifCheckin-->%@",responseObject);
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
        if (error.code == -1) {
            //退出成功删除手机号
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:MobilePhoneNum];
            //删除本地登录信息
            [User removeLoginData];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate logoutHuaXinServer];// 退出环信
            //发送通知告诉web token变动
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUpdateUserLoginStatus object:nil];
        }
    }];
}

- (void)checkin{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"terminal"];
    methodName = kCheckin;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSLog(@"kCheckin-->%@",responseObject);
            isSignFlag = true;
            if (isSignFlag) {
                 [weakSelf.signButton setImage:[UIImage imageNamed:@"alreadysignFloatBtn"] forState:UIControlStateNormal];
                int pointInt = [[responseObject objectForKey:@"data"][@"point"] intValue];
                if (pointInt > 0 ) {
                    NSString *pointStr = [NSString stringWithFormat:@"签到成功，已添加%d积分",pointInt];
                     [BHToast showMessage:pointStr];
                    return ;
                }
                [BHToast showMessage:@"签到成功"];
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
        if (error.code == -1) {
            [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                if (isComplete) {
                    [self getTagToDo:3001];
                }
            }];
        }
    }];
}

//首页 获取各种Dogs的显示数字
- (void)getDogs
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    NSString *methodName = @"";

    methodName = kDogsNum;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
//            NSLog(@"getDogs-->%@",responseObject);
            luzDogCountModel = [[HomeDogCountModel alloc] init];
            luzDogCountModel.dogName = @"luzdog";
            luzDogCountModel.income = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lzDog"][@"income"]];
            luzDogCountModel.userCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lzDog"][@"userCount"]];
            luzDogCountModel.recentCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lzDog"][@"count"]];
            luzDogCountModel.notice = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lzDog"][@"notice"]];
            
            bandDogCountModel = [[HomeDogCountModel alloc] init];
            bandDogCountModel.dogName = @"banddog";
            bandDogCountModel.userCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bandDog"][@"userCount"]];
            bandDogCountModel.notice = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bandDog"][@"notice"]];
            
            
            researchDogModel = [[HomeDogCountModel alloc] init];
            researchDogModel.dogName = @"researchdog";
            researchDogModel.recentCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"researchDog"][@"count"]];
            researchDogModel.agencyCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"researchDog"][@"agencyCount"]];
            researchDogModel.notice = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"researchDog"][@"notice"]];
            
            contractDogModel = [[HomeDogCountModel alloc] init];
            contractDogModel.dogName = @"contractdog";
            contractDogModel.userCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"futureDog"][@"userCount"]];
            contractDogModel.notice = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"futureDog"][@"notice"]];
            
            stareDogModel = [[HomeDogCountModel alloc] init];
            stareDogModel.dogName = @"staredog";
            stareDogModel.userCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"stareDog"][@"userCount"]];
            stareDogModel.notice = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"stareDog"][@"notice"]];
            
            chainCheckModel =  [[HomeDogCountModel alloc] init];
            chainCheckModel.dogName = @"lianchacha";
            chainCheckModel.userCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lianchacha"][@"count"]];
   
            
             [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:luzDogCountModel WithBandDog:bandDogCountModel WithContractDog:contractDogModel WithResearchDog:researchDogModel WithBannerArray:bannerList WithStartDog:stareDogModel WithAtmosphereData:atmosphereModel Withlianchacha:chainCheckModel];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}


- (void)getBanner
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    
    methodName = kGetBanner;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
//            NSLog(@"kGetBanner-->%@",responseObject);
           bannerList = [NSArray yy_modelArrayWithClass:[HomeBannerModel class] json:responseObject[@"data"]];
//            //刷新tableview
             [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:luzDogCountModel WithBandDog:bandDogCountModel WithContractDog:contractDogModel WithResearchDog:researchDogModel WithBannerArray:bannerList WithStartDog:stareDogModel WithAtmosphereData:atmosphereModel Withlianchacha:chainCheckModel];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-----kGetBanner--->%@",error);
    }];
}

//获取最近的10条新闻快讯
- (void)getlatestsNews
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetlatestNewsInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            productList = [NSArray yy_modelArrayWithClass:[HomeProductModel class] json:responseObject[@"data"]];
            //刷新tableview
            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:luzDogCountModel WithBandDog:bandDogCountModel WithContractDog:contractDogModel WithResearchDog:researchDogModel WithBannerArray:bannerList WithStartDog:stareDogModel WithAtmosphereData:atmosphereModel Withlianchacha:chainCheckModel];
        }
        [weakSelf.homePageTableView.homePageTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.homePageTableView.homePageTableView.mj_header endRefreshing];
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//获取首页策略信息
- (void)getlatestsProduct
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName =
//    kGetlatestProductInfo;
    kGetlatestProductInfoList;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            productInfoModelList = [NSArray yy_modelArrayWithClass:[HomeProductInfoModel class] json:responseObject[@"data"]];
            
            //刷新tableview
            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:luzDogCountModel WithBandDog:bandDogCountModel WithContractDog:contractDogModel WithResearchDog:researchDogModel WithBannerArray:bannerList WithStartDog:stareDogModel WithAtmosphereData:atmosphereModel Withlianchacha:chainCheckModel];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//获取邀请好友信息
- (void)getUserInvateFrend
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
//    [pramaDic setObject:kGetUserInvateFrendUrl forKey:@"url"];
    [pramaDic setObject:kDigInvateFrendUrl forKey:@"url"];
    methodName = kGetHomePageUserInvateFrend;

    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
//        NSLog(@"kGetUserInvateFrend-------->%@",responseObject);
//        NSLog(@"kGetUserInvateFrend-------->%@",responseObject[@""]);
        if (IsSafeDictionary(responseObject)) {
            weakSelf.dicInvate = [responseObject objectForKey:@"data"];

            if (_dicInvate) {

                //        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 26, SCREEN_WIDTH - 150, 14)];
                //        titleLabel.text = [NSString stringWithFormat:@"%@的二维码",[_dicInvate objectForKey:@"tel"]];
                //        titleLabel.font = UIFontRegularOfSize(16);
                //        titleLabel.textColor = BHHexColor(@"626A75");
                //        [bgImage addSubview:titleLabel];


                NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:[_dicInvate objectForKey:@"base64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                decodedImage = [UIImage imageWithData:decodedImageData];
                invteCodeStr = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"][@"inviteCode"]];
//                UIImageView *bgImage2 = [[UIImageView alloc] initWithFrame:CGRectMake((bgImage.width - 228.9) / 2, 112, 228.9, 228.9)];
//                [bgImage2 setImage:decodedImage];
//                [bgImage addSubview:bgImage2];
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//首页上方 空气相关数据统计数字
-(void)getAtmosphereData{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";

    methodName = kGetHomePageAtmospereSummmary;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:1 success:^(id responseObject) {
        NMRemovLoadIng;
//        NSLog(@"kGetHomePageAtmospereSummmary-------->%@",responseObject);

        if (IsSafeDictionary(responseObject)) {
            
            AtmosphereModel *tempAtmoModel = [[AtmosphereModel alloc] init];
            tempAtmoModel.airIndex = [responseObject objectForKey:@"data"][@"airIndex"];
            tempAtmoModel.amount = [responseObject objectForKey:@"data"][@"amount"];
            tempAtmoModel.netAmount = [responseObject objectForKey:@"data"][@"netAmount"];
            atmosphereModel = tempAtmoModel;
  
            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:luzDogCountModel WithBandDog:bandDogCountModel WithContractDog:contractDogModel WithResearchDog:researchDogModel WithBannerArray:bannerList WithStartDog:stareDogModel WithAtmosphereData:atmosphereModel Withlianchacha:chainCheckModel];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//挖矿 用户挖矿账户及任务状态信息
-(void)getDigInfo{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"terminal"];
    methodName = kGetDigInfo;
    
    //    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSLog(@"getDigInfo-->%@",responseObject);
            isOpenDigFlag = [responseObject[@"data"][@"info"][@"status"] boolValue];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//获取
//- (void)getUserCountAndincome
//{
//    NSMutableDictionary * pramaDic = @{}.mutableCopy;
//    NSString * methodName = @"";
//    if (User.userToken) {
//        [pramaDic setObject:User.userToken forKey:@"bte-token"];
//    }
//
//    methodName = kFromSummaryCountAndincome;
//
//
//    WS(weakSelf)
//    NMShowLoadIng;
//    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//
//        NMRemovLoadIng;
//        if (IsSafeDictionary(responseObject)) {
////            homedogCountModel = [HomeDogCountModel yy_modelWithDictionary:responseObject[@"data"]];
//           homedogCountModel = [[HomeDogCountModel alloc] init];
//            homedogCountModel.income = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalIncome"]];
//            homedogCountModel.userCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCount"]];
//            homedogCountModel.recentCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"recentRecommendCount"]];
//
//            //刷新tableview
//            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:homeDogCountModel WithBandDogCount:bandDogCountStr WithContractDoyCount:contractDogCountStr WithResearchDogCountStr:researchDogCountStr WithBannerArray:bannerList WithAgencyCountStr:agencyCount];
//        }
//    } failure:^(NSError *error) {
//        NMRemovLoadIng;
//        RequestError(error);
//        NSLog(@"error-------->%@",error);
//    }];
//}

//- (void)getbandDogUserCount{
//    NSMutableDictionary * pramaDic = @{}.mutableCopy;
//    NSString * methodName = @"";
//    if (User.userToken) {
//        [pramaDic setObject:User.userToken forKey:@"bte-token"];
//    }
//    methodName = kFromBandDogUserCount;
//    WS(weakSelf)
//    NMShowLoadIng;
//    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//
//        NMRemovLoadIng;
//        if (IsSafeDictionary(responseObject)) {
//            NSString *bandDogCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCount"]];
//            bandDogCountStr = bandDogCount;
//            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:homeDogCountModel WithBandDogCount:bandDogCountStr WithContractDoyCount:contractDogCountStr WithResearchDogCountStr:researchDogCountStr WithBannerArray:bannerList WithAgencyCountStr:agencyCount];
//        }
//    } failure:^(NSError *error) {
//        NMRemovLoadIng;
//        RequestError(error);
//        NSLog(@"error-------->%@",error);
//    }];
//}

//获取研究狗 正在使用的人数
//- (void)getResearchDogUserCount{
//    NSMutableDictionary * pramaDic = @{}.mutableCopy;
//    NSString * methodName = @"";
//
//    methodName = kGetResearchDogCount;
//    WS(weakSelf)
//    NMShowLoadIng;
//    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
//
//        NMRemovLoadIng;
//        if (IsSafeDictionary(responseObject)) {
//            NSString *researchDogCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"result"]];
//            researchDogCountStr = researchDogCount;
//           [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:homeDogCountModel WithBandDogCount:bandDogCountStr WithContractDoyCount:contractDogCountStr WithResearchDogCountStr:researchDogCountStr WithBannerArray:bannerList WithAgencyCountStr:agencyCount];
//        }
//    } failure:^(NSError *error) {
//        NMRemovLoadIng;
//        RequestError(error);
//        NSLog(@"error-------->%@",error);
//    }];
//}

//获取合约狗 正在使用的人数
//- (void)getContractDogUserCount{
//    NSMutableDictionary * pramaDic = @{}.mutableCopy;
//    NSString * methodName = @"";
//
//    methodName = kGetContractDogCount;
//    WS(weakSelf)
//    NMShowLoadIng;
//    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypePost success:^(id responseObject) {
//
//        NMRemovLoadIng;
//        if (IsSafeDictionary(responseObject)) {
//            NSString *contractDogCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCount"]];
//            contractDogCountStr = contractDogCount;
//           [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModelList currentCurrencyType:currentCurrencyType anouncement:announcement dogViewCount:homeDogCountModel WithBandDogCount:bandDogCountStr WithContractDoyCount:contractDogCountStr WithResearchDogCountStr:researchDogCountStr WithBannerArray:bannerList WithAgencyCountStr:agencyCount];
//        }
//    } failure:^(NSError *error) {
//        NMRemovLoadIng;
//        RequestError(error);
//        NSLog(@"error-------->%@",error);
//    }];
//}


//- (void)jumpToChatPage {
////    EMError *error = [[EMClient sharedClient] loginWithUsername:@"quxiaobo" password:@"111111"];
//////     EMError *error = [[EMClient sharedClient] loginWithUsername:@"sophiemarceau" password:@"111111"];
////    if (!error) {
////        NSLog(@"登录环信成功！");
////    }else{
////        NSLog(@"登录环信失败-------%@",error);
////    }
////    ChatViewController *chatvc= [[ChatViewController alloc] initWithConversationChatter:@"sophiemarceau" conversationType:EMConversationTypeChat];
//////    ChatViewController *chatvc= [[ChatViewController alloc] initWithConversationChatter:@"quxiaobo" conversationType:EMConversationTypeChat];
//////
//////
////    [self.navigationController pushViewController:chatvc animated:YES];
//}


//- (void)doTapChange:(NSString *)name//选择币种
//{
////    WS(weakSelf)
////    [BTECurrencyTypePickerView provincePickerViewWithArray:detailsList WithProvince:name ProvinceBlock:^(NSInteger rowIndex) {
////        //获取最新的推荐列表
////        HomeDesListModel *tempModel = detailsList[rowIndex];
////        currentCurrencyType = tempModel.symbol;
////        [weakSelf getlatestsStatus];
////    }];
//    if (detailsList.count > 0) {
//        selectView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, 110, 44 *detailsList.count)];
//        selectView.backgroundColor = BHHexColor(@"308CDD");
//        [self.view addSubview:selectView];
//
//        if (currentCurrencyType == nil) {
//            HomeDesListModel *tempModel = detailsList[0];
//            currentCurrencyType = tempModel.symbol;
//        }
//
//        for (int i = 0; i < detailsList.count; i++) {
//            HomeDesListModel *tempModel = detailsList[i];
//            UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            sureButton.frame = CGRectMake(0, 44 * i, 110, 44);
//            sureButton.tag = 100 + i;
//            if ([currentCurrencyType isEqualToString:tempModel.symbol]) {
//                sureButton.backgroundColor = BHHexColor(@"5CACF3");
//            } else
//            {
//                sureButton.backgroundColor = [UIColor clearColor];
//            }
//            [sureButton setTitle:[NSString stringWithFormat:@"%@行情",tempModel.symbol] forState:UIControlStateNormal];
//            [sureButton setTitleColor:BHHexColor(@"ffffff") forState:UIControlStateNormal];
//            sureButton.titleLabel.font = UIFontRegularOfSize(17);
//            [sureButton addTarget:self action:@selector(selectChange:) forControlEvents:UIControlEventTouchUpInside];
//            [selectView addSubview:sureButton];
//        }
//    }
//}

//- (void)selectChange:(UIButton *)sender
//{
//    NSInteger index = sender.tag - 100;
//    //获取最新的推荐列表
//    HomeDesListModel *tempModel = detailsList[index];
//    currentCurrencyType = tempModel.symbol;
//    [self getlatestsStatus];
//    [selectView removeFromSuperview];
//}



//- (UIBarButtonItem *)creatLeftBarItem {
//    UIImage *buttonNormal = [[UIImage imageNamed:@"Fill 1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(showLeftView)];
//    return leftItem;
//}
//
//
//- (void)showLeftView
//{
//    [selectView removeFromSuperview];
//    WS(weakSelf)
//    NSMutableDictionary * pramaDic = @{}.mutableCopy;
//    NSString * methodName = @"";
//    if (User.userToken) {
//        [pramaDic setObject:User.userToken forKey:@"bte-token"];
//    }
//    methodName = kGetUserLoginInfo;
//    NMShowLoadIng;
//    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//        NMRemovLoadIng;
//        if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 0) {//未登录
//            //退出成功删除手机号
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:nil forKey:MobilePhoneNum];
//            //删除本地登录信息
//            [User removeLoginData];
//        }
//        [BTELeftView popActivateNowCallBack:^(NSInteger index) {
//            [weakSelf.tabBarController setSelectedIndex:index];
//            if (index == 0) {
//                [weakSelf.homePageTableView.homePageTableView setContentOffset:CGPointMake(0,0) animated:NO];
//            }
//        } cancelCallBack:^{
//
//        }];
//    } failure:^(NSError *error) {
//        NMRemovLoadIng;
//        RequestError(error);
//        NSLog(@"error-------->%@",error);
//    }];
//}

//- (void)hidden
//{
//    [selectView removeFromSuperview];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (User.userToken) {
        [self getIfCheckin];
        [self getUnReadNumStrFromServer];
        [self getDigInfo];
    }else{
        isSignFlag = NO;
        if (isSignFlag) {
        }else{
            [self.signButton setImage:[UIImage imageNamed:@"signFloatBtn"] forState:UIControlStateNormal];
        }
    }
    
    [self getUserInvateFrend];
    // 强制显示tabbar
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ZTGCDTimerManager sharedInstance] cancelTimerWithName:@"beck.wang.singleTimer"];
//    [selectView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[ZTGCDTimerManager sharedInstance] scheduleGCDTimerWithName:@"beck.wang.singleTimer" interval:3 queue:dispatch_get_main_queue() repeats:YES option:CancelPreviousTimerAction action:^{
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        if (User.userToken) {
            [pramaDic setObject:User.userToken forKey:@"bte-token"];
        }
        methodName = kGetlatestInfo;
        WS(weakSelf)
        PhoneInfo * phone = [[PhoneInfo alloc] init];
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:pramaDic];
        [params setObject:kCurrentVersion forKey:@"version"];
        [params setObject:@"ios" forKey:@"channel"];
        [params setObject:phone.phoneVersion forKey:@"sdkVersionName"];
        [params setObject:phone.phoneVersion forKey:@"sdkVersionCode"];
        [params setObject:@"iphone" forKey:@"Brand"];
        [params setObject:phone.platform forKey:@"Model"];
        // 初始化Session对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        //https ssl 验证。
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mbtetop" ofType:@"cer"];//证书的路径
//        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//        
//        // AFSSLPinningModeCertificate 使用证书验证模式
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//        // 如果是需要验证自建证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = YES;
//        
//        //validatesDomainName 是否需要验证域名，默认为YES;
//        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//        //如置为NO，建议自己添加对应域名的校验逻辑。
//        securityPolicy.validatesDomainName = NO;
//        
//        securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
//        
//        [manager setSecurityPolicy:securityPolicy];
        // 设置请求接口回来的时候支持什么类型的数据
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [manager POST:kGetlatestInfo parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (IsSafeDictionary(responseObject)) {
                descriptionModel = [HomeDescriptionModel yy_modelWithDictionary:responseObject[@"data"][@"report"]];
                detailsList = [NSArray yy_modelArrayWithClass:[HomeDesListModel class] json:responseObject[@"data"][@"list"]];
                [weakSelf.homePageTableView updateCoin:detailsList];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"post请求失败:%@", error);
        }];
        
//        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//            NSLog(@"methodName-------->%@",responseObject);
//        } failure:^(NSError *error) {
//            NSLog(@"error-------->%@",error);
//        }];
        
//         NSLog(@"error-------->%ld",self.tabBarController.selectedIndex);
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tabBarController setSelectedIndex:0];
//    });
}

#pragma mark - 分享
- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"Group 24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (UIBarButtonItem *)creatLeftBarItem {
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(gotoMessageVc) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, NAVIGATION_HEIGHT);
    
    UIImage *buttonNormal = [[UIImage imageNamed:@"messagesIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    leftBtnImageView = [[UIImageView alloc] initWithImage:buttonNormal];
    leftBtnImageView.frame = CGRectMake(0, (NAVIGATION_HEIGHT - STATUS_BAR_HEIGHT -buttonNormal.size.height)/2, buttonNormal.size.width, buttonNormal.size.height);
    [leftBtn addSubview:leftBtnImageView];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    return leftItem;
}

@end
