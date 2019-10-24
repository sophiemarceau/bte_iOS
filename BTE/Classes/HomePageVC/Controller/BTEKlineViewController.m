//
//  BTEKlineViewController.m
//  BTE
//
//  Created by wanmeizty on 2018/5/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEKlineViewController.h"
#import "ZTYChartModel.h"
#import "ZTYQuoteChartView.h"
#import "ZYWPriceView.h"
#import "ZTYChartProtocol.h"
#import "ZTYCandlePosionModel.h"
#import "BTEFullScreenKlineViewController.h"
#import "ZTYDataReformator.h"
//#import "ZTYMainChartView.h"
//#import "ZTYMainKChartView.h"
#import "ZTYMainView.h"
#import "BigOrderTradeTableViewCell.h"
//#import "ZTYVolumCahrtView.h"
#import "ZTYVolumView.h"
#import "ZTYLineTextView.h"
#import "ZTYCalCuteNumber.h"
#import "ZTYLeftLabel.h"
#import "UILabel+leftAndRight.h"
#import "ExchangeModel.h"
#import "ExchangeTableViewCell.h"
#import "ZTYKlineComment.h"
#import "ZTYNounLine.h"
#import "ZTYLineTextView.h"
#import "BTEZTYLineKBottonView.h"
#import "BTEQuoteSetViewController.h"
#import "BTEKlineChatViewController.h"
#import "BTELoginVC.h"
#import "AddNickHeaderView.h"
#import "SuspendImgV.h"
#import "BTEActivityView.h"
#import "ChatViewController.h"
#import "BTEKlineChatViewController.h"
#import "UserCacheManager.h"
#import "ZTYArrowLine.h"
#import "ZTYScreenshot.h"
#import "BTEShareView.h"
#import "JSBadgeView.h"
#import "SecondaryLevelWebViewController.h"

#import "BTEBigOrderTableViewCell.h"
#import "BTEOrderDeepTableViewCell.h"
#import "BTEOrderHeadView.h"
#import "KitemWebViewController.h"

#import "FormatUtil.h"
//#import "ZTYDistrabuteView.h"
//#import "BTECalculateDistrabutionValue.h"
#import "ZTYTradeDistrabuteView.h"
#import "BTESaveDataUtil.h"
#define ScrollScale 1.00
#define CandleScale 0.55
#define VolumeScale 0.18
#define QuotaScale 0.27
#define btnWidth 53
#define HeadTopHeight 118
#define headerHeight (HeadTopHeight + 22)
#define intalval  5

#define bottomHeight 50
#define tableBtnHeight 42
#define tableFootAndHeadHeight 40

#define timeWidth 48

#define KlineTopViewHeight (SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - tableBtnHeight)

// key
#define BurnedKey @"Burned"
#define DepthKey @"depth"
#define DepthRemarkKey @"depthRemark"
#define AbnormityKey @"hugeDeal"
#define hugeDealMaxKey @"hugeDealMaxkey"

@interface BTEKlineViewController ()
<UITableViewDelegate,UITableViewDataSource,ChatDelegate,ZTYChartProtocol,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>{
    BOOL loginUserFlag;
    NSString *headPicStr;
    NSString *telStr;
    NSString *nickNameStr;
    NSString *emailStr;
    BOOL hiddenStatusBar;
}
@property (nonatomic,strong) UIView * kLineBGView;
@property (strong,nonatomic) ZTYTradeDistrabuteView * distrabuteView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) ZTYMainView *candleChartView;
@property (nonatomic,strong) ZTYVolumView * volumeView;
@property (nonatomic,strong) ZTYQuoteChartView *quotaChartView;
@property (nonatomic,strong) UIView *topBoxView;
@property (nonatomic,strong) ZYWPriceView *candlePrice;
@property (nonatomic,strong) ZYWPriceView *quotaPrice;
@property (nonatomic,strong) ZYWPriceView *volumePrice;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) NSUInteger zoomRightIndex;
@property (nonatomic, assign) CGFloat currentZoom;
@property (nonatomic, assign) NSInteger displayCount;
@property (nonatomic,strong) UIView * headView;
@property (nonatomic,strong) UIView * ktypeBGView,*mainQuotaTypeBGView,*fitureQuotaBGView,*otherBGView;
@property (nonatomic,strong) UILabel * descLabel,*roseDropLabel,*mainTextLabel,*volumTextLabel,*fitureTextLabel;
@property (nonatomic,strong) UILabel * verticalLabel;
@property (nonatomic,strong) UIView *verticalView;
@property (nonatomic,strong) UIView *leavView;
@property (nonatomic,strong) ZTYLineTextView * latestLinetextView;
@property (nonatomic,strong) ZTYChartModel * latestModel;
@property (nonatomic,assign) CGFloat latesetClose;
@property (nonatomic,strong) NSMutableArray *klineAataArray;
@property (nonatomic,copy) NSString * ktype;
@property (nonatomic,copy) NSString * end;
@property (nonatomic,copy) NSString * exchange;
@property (nonatomic,copy) NSString * base;
@property (nonatomic,copy) NSString * quote;
@property (nonatomic,copy) NSString * start;
@property (nonatomic,assign) CGFloat ChartHeight;
@property (nonatomic,assign) int isrelaod; // 加载更多刷新
@property (nonatomic,strong) NSArray * klineTypes;
@property (nonatomic,strong) UITableView * exchangeTableView;
@property (nonatomic,strong) NSMutableArray * exchangeArray;
//@property (nonatomic,strong) UIButton * combtn;
@property (nonatomic,strong)SuspendImgV *assistiveBtn;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) UIWebView * webDescView;
@property (nonatomic,strong) UIWebView * webFlowView;
@property (nonatomic,strong) NSArray * optionArray;
//@property (nonatomic,copy) NSString * optionId;
@property (nonatomic,copy) NSString * chatOnLineNumStr;//聊天在线人数
@property (nonatomic,strong)UILabel *chatOnLineNumStrLabel;

@property (nonatomic,assign) BOOL isfreshing;

@property (nonatomic,assign) NSInteger webIndex; // 评级
@property (strong, nonatomic) EMConversation *conversation;
@property (nonatomic,strong) NSString *chatRoomId;
@property (nonatomic,strong)JSBadgeView *badgeView;
@property (nonatomic,strong)UIImageView *hiddenImageView;

@property (strong,nonatomic) UIScrollView * rootScrollView;
@property (strong,nonatomic) UIScrollView * itemScrollView;
@property (strong,nonatomic) UIView * bottomView;
@property (strong,nonatomic) UIView * floatBottomView;
@property (assign,nonatomic) BottomType bottomType;
@property (assign,nonatomic) BottomType tempbottomType;
@property (strong,nonatomic) NSMutableDictionary * bottomDict;
@property (assign,nonatomic) CGFloat descHeight;
@property (assign,nonatomic) CGFloat flowHeight;
@property (assign,nonatomic) CGFloat counterHeight;
@property (assign,nonatomic) CGFloat gradeHeight;
@property (strong,nonatomic) UIButton * topImageView;

@property (strong,nonatomic) ChatViewController * chatVC;
@property (assign,nonatomic) CGFloat exchangeX;

@end

@implementation BTEKlineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavitems];
    [self initData];
    [self addRootScrollView];
    
    [self addSubViews];
    [self addBottomViews];
    [self addPriceView];
    [self initCrossLine];
    [self addChartTitle];
    [self addActivityView];
    [self addArrowUp];
    
    if ([self judgeIsBigCoin]) {
        [self addBottomItem];
    }else{
        [self addBottomSmallItem];
    }
    
    UITapGestureRecognizer *  tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.kLineBGView addGestureRecognizer:tap];
    
    [self requestData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startClock) userInfo:nil repeats:YES];
    
    //  关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    
    //BTC,ETH,BCH,EOS
    if ([self judgeIsBigCoin]) {
//        [self setFloatBtn];
        [self requestDeepth];
    }
    
    
    
    self.badgeView = [[JSBadgeView alloc] initWithParentView:self.hiddenImageView alignment:JSBadgeViewAlignmentTopRight];
    self.badgeView.badgeBackgroundColor = BHHexColor(@"F01313");
    self.badgeView.badgeOverlayColor =  BHHexColor(@"F01313");//没有反光面
    self.badgeView.badgeStrokeColor = BHHexColor(@"F01313");//外圈的颜色，默认是白色
    [self getLocalData];

    [self addOptionLeadBG];
}

- (BOOL)prefersStatusBarHidden{
    return hiddenStatusBar;
}
- (void)addOptionLeadBG{
    
    
    
    NSString * isfirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"isoptionLead"];
    if (isfirst == nil) {
    hiddenStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.hidden = YES;
        UIButton * imgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imgView setBackgroundImage:[UIImage imageNamed:@"optionLead"] forState:UIControlStateNormal];
        [imgView addTarget:self action:@selector(optionLead) forControlEvents:UIControlEventTouchUpInside];
        imgView.tag = 333;
        [self.view addSubview:imgView];
        
    }

}

- (void)optionLead{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"isfurst" forKey:@"isoptionLead"];
    [user synchronize];
    self.navigationController.navigationBar.hidden = NO;
    UIButton * button = [self.view viewWithTag:333];
    button.hidden = YES;
    hiddenStatusBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)addArrowUp{
    self.topImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topImageView.frame = CGRectMake(SCREEN_WIDTH-SCALE_W(28)-SCALE_W(10), SCREEN_HEIGHT - 200 - HOME_INDICATOR_HEIGHT, SCALE_W(28), SCALE_W(28));
    [self.topImageView setImage:[UIImage imageNamed:@"返回k线"] forState:UIControlStateNormal];
    [self.topImageView  addTarget:self action:@selector(gotoTop) forControlEvents:UIControlEventTouchUpInside];
    self.topImageView.hidden = YES;
    [self.view addSubview:self.topImageView];
}

- (BOOL)judgeIsBigCoin{
    //BTC,ETH,BCH,EOS
    if([self.base isEqualToString:@"BTC"] || [self.base isEqualToString:@"ETH"] || [self.base isEqualToString:@"BCH"] ||[self.base isEqualToString:@"EOS"]){
        return YES;
    }
    return NO;
}

- (void)createNavitems{
    self.navigationItem.title  = @"K线图";
    self.navigationItem.rightBarButtonItem = [self creatRightBarItem];
    
    UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(disback)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)disback{
    if (self.bottomType == BottomTypeChatView) {
        self.bottomType = BottomTypeSuperDeep;
        UIButton * button = [self.bottomView viewWithTag:900];
        [self itemTabelChoose:button];
        [self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initData{
    self.base = self.desListModel.symbol;
    self.quote = self.desListModel.quote;
    self.exchange = self.desListModel.exchange;
    _isrelaod = 0;
    self.ktype = @"1h";
    _bottomType = BottomTypeSuperDeep;
    self.ChartHeight = (DEVICE_HEIGHT - headerHeight - NAVIGATION_HEIGHT - bottomHeight - HOME_INDICATOR_HEIGHT);
    
    self.klineAataArray = [NSMutableArray array];
    _exchangeArray = [NSMutableArray array];
    self.bottomDict = [NSMutableDictionary dictionary];
    self.title = [NSString stringWithFormat:@"%@/%@",self.base,self.quote];
}

-(void)setUnreadMessageCountByChatRoomId{
    if (self.chatRoomId && self.chatRoomId.length > 0) {
        self.conversation = [[EMClient sharedClient].chatManager getConversation:self.chatRoomId type:EMConversationTypeGroupChat createIfNotExist:NO];
        int unreadMessageCount =  [self.conversation unreadMessagesCount];
        if (unreadMessageCount==0) {
            self.badgeView.badgeText = nil;
        }else{
            self.badgeView.badgeText = [NSString stringWithFormat:@"%d",unreadMessageCount];
        }
        [self.badgeView setNeedsLayout];
        NSLog(@"unreadMessageCount-------->%d",unreadMessageCount);
    }
    
    
}

- (void)getWhetherRegisterHX{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kWhetherRegisterHX;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            loginUserFlag = [responseObject[@"data"][@"loginUserVO"] integerValue];
//            if (loginUserFlag) {
                [weakSelf AddUserAndRoomHX];
//            }
        }
    } failure:^(NSError *error) {
        RequestError(error);
    }];
}

- (void)AddUserAndRoomHX{
    if([self.desListModel.symbol isEqualToString:@"BTC"] || [self.desListModel.symbol isEqualToString:@"ETH"] || [self.desListModel.symbol isEqualToString:@"BCH"] ||[self.desListModel.symbol isEqualToString:@"EOS"]){
        
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        if (User.userToken) {
            [pramaDic setObject:User.userToken forKey:@"bte-token"];
        }
        [pramaDic setObject:self.desListModel.symbol forKey:@"roomName"];
        [pramaDic setObject:nickNameStr forKey:@"nickName"];
        [pramaDic setObject:headPicStr forKey:@"headImage"];
        methodName = kAddUserAndRoom;
        
        WS(weakSelf)
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            if (IsSafeDictionary(responseObject)) {
                User.hxuserName =  responseObject[@"data"][@"result"][@"userId"];
                User.hxuserPassword = responseObject[@"data"][@"result"][@"password"];
                User.nickName = responseObject[@"data"][@"result"][@"nickName"];
                weakSelf.chatRoomId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupid"]];
                //            BOOL isAutoLogin = [[EMClient sharedClient].options isAutoLogin];
                BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
                NSLog(@"hxuserName------>%@",User.hxuserName);
                NSLog(@"hxpassword------>%@",User.hxuserPassword);
                if (!isAutoLogin) {
                    NSLog(@"isAutoLogin---false----->%d",isAutoLogin);
                    [[EMClient sharedClient] loginWithUsername:User.hxuserName password:User.hxuserPassword completion:^(NSString *aUsername, EMError *aError) {
                        if (!aError) {
                            if (loginUserFlag) {
                                [weakSelf setUnreadMessageCountByChatRoomId];
                            }else{
                                // 通过消息的扩展属性传递昵称和头像时，需要调用这句代码缓存
                                [UserCacheManager save:User.hxuserName avatarUrl:headPicStr nickName:User.nickName];
                                loginUserFlag = 1;
                            }
                        }else{
                            NSLog(@"---loginWithUsername--password---aerror--->%@",aError.errorDescription);
                        }
                    }];
                }else{
                    NSLog(@"isAutoLogin---true----->%d",isAutoLogin);
                    [weakSelf setUnreadMessageCountByChatRoomId];
                }
            }
        } failure:^(NSError *error) {
            RequestError(error);
            NSLog(@"error----kAddUserAndRoom---->%@",error);
        }];
    }
}

-(void)setFloatBtn{
    self.assistiveBtn = [[SuspendImgV alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 64, headerHeight+self.ChartHeight*(CandleScale)+2, 64 , 50) topMargin:0 btomMargin:0];
    
    UIImageView *btnImageView =  [[UIImageView alloc] init];
    btnImageView.image = [UIImage imageNamed:@"fuceng"];
    
    btnImageView.frame = CGRectMake(0, 0, 64, 50);
    [self.assistiveBtn addSubview:btnImageView];
    
    
    self.chatOnLineNumStrLabel = [[UILabel alloc]init];
    self.chatOnLineNumStrLabel.frame = CGRectMake(0,39, 64, 15);
    
    self.chatOnLineNumStrLabel.textAlignment = NSTextAlignmentCenter;
    self.chatOnLineNumStrLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.chatOnLineNumStrLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    [btnImageView addSubview:self.chatOnLineNumStrLabel];
    self.hiddenImageView  =  [[UIImageView alloc] init];
    self.hiddenImageView.frame = CGRectMake(14, 0, 33, 36);
    self.hiddenImageView.backgroundColor = [UIColor clearColor];
    [self.assistiveBtn addSubview:self.hiddenImageView];
    [self.kLineBGView addSubview:self.assistiveBtn];
    self.assistiveBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_clickBtn)];
    [self.assistiveBtn addGestureRecognizer:singleTap];
}

-(void)p_clickBtn{
    
    UIButton * button = [self.bottomView viewWithTag:904];
    [self itemTabelChoose:button];
    
    //    self.assistiveBtn.userInteractionEnabled = NO;
    //    if (User.userToken) {
    //        NSLog(@"userToken----->%@",User.userToken);
    //        // true 表示已经注册过环信 false 表示没有注册过环信
    //        if (loginUserFlag) {
    //            BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    //            if (!isAutoLogin) {
    //                NSLog(@"isAutoLogin---false----->%d",isAutoLogin);
    //
    //                [[EMClient sharedClient] loginWithUsername:User.hxuserName password:User.hxuserPassword completion:^(NSString *aUsername, EMError *aError) {
    //                    if (!aError) {
    //                        [self setUnreadMessageCountByChatRoomId];
    //                        [self gotoChatRoomWith:self.chatRoomId];
    //                    }else{
    //                        NSLog(@"---loginWithUsername--password---aerror--->%@",aError.errorDescription);
    //                    }
    //                }];
    //            }else{
    //                [self setUnreadMessageCountByChatRoomId];
    //                NSLog(@"isAutoLogin---true----->%d",isAutoLogin);
    //                [self gotoChatRoomWith:self.chatRoomId];
    //            }
    //        }else{
    //            AddNickHeaderView *v = [[AddNickHeaderView alloc] initAddNickHeadView];
    //            v.roomName = self.desListModel.symbol;
    //            [v setConfirmCallBack:^(BOOL isComplete, NSString *chatRoomId) {
    //                if (isComplete) {
    //                    NSLog(@"isComplete----chatRoomId---->%@",chatRoomId);
    //                    self.chatRoomId = chatRoomId;
    //                    [self setUnreadMessageCountByChatRoomId];
    //                    [self gotoChatRoomWith:chatRoomId];
    //                }
    //            }];
    //
    //        }
    //        self.assistiveBtn.userInteractionEnabled = YES;
    //    }else{
    //        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
    //            if (isComplete) {
    //                [self getWhetherRegisterHX];
    //            }
    //        }];
    //        self.assistiveBtn.userInteractionEnabled = YES;
    //        return;
    //    }
}

- (void)GetRoomInfo{
    if([self.desListModel.symbol isEqualToString:@"BTC"] || [self.desListModel.symbol isEqualToString:@"ETH"] || [self.desListModel.symbol isEqualToString:@"BCH"] ||[self.desListModel.symbol isEqualToString:@"EOS"]){
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:self.desListModel.symbol forKey:@"base"];
        methodName = kGetRoomInfo;
        NSLog(@"GetRoomInfo---pramaDic----->%@",pramaDic);
        WS(weakSelf)
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NSLog(@"GetRoomInfo-------->%@",responseObject);
            //        NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {
                weakSelf.chatOnLineNumStr = [NSString stringWithFormat:@"在线人数%@",responseObject[@"data"][@"result"]];
                weakSelf.chatOnLineNumStrLabel.text = weakSelf.chatOnLineNumStr;
                UILabel * countlabel = [weakSelf.bottomView viewWithTag:222];
                countlabel.text = [NSString stringWithFormat:@"%@人",responseObject[@"data"][@"result"]];
                UILabel * fcountlabel = [self.floatBottomView viewWithTag:222];
                fcountlabel.text = [NSString stringWithFormat:@"%@人",responseObject[@"data"][@"result"]];
                NSLog(@"self.chatOnLineNumStr-------->%@",weakSelf.chatOnLineNumStr);
            }
        } failure:^(NSError *error) {
            //        NMRemovLoadIng;
            RequestError(error);
        }];
    }
}

-(void)gotoChatRoomWith:(NSString *)chatRoomStr{
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:chatRoomStr conversationType:EMConversationTypeGroupChat];
    chatController.groupName = self.desListModel.symbol;
    chatController.base = self.desListModel.symbol;
    chatController.quote = self.desListModel.quote;
    chatController.exchange = self.desListModel.exchange;
    [self.navigationController pushViewController:chatController animated:YES];
    self.assistiveBtn.userInteractionEnabled = YES;
}

- (void)tapClick{
    [self hiddenAllChoseBGView];
}

#pragma mark -- 刷新倒计时
static int clockCount = 3;
- (void)startClock{
    NSString * title = self.desListModel.symbol;
    if (self.base.length > 0) {
        title = self.base;
    }
    //    self.title = [NSString stringWithFormat:@"%@(%d)",title,clockCount];
    clockCount --;
    if (clockCount <= -1) {
        [self requestLastModelData];
        clockCount = 3;
    }
    
    if (clockCount % 2 == 0 && [self judgeIsBigCoin]) {
        if (self.bottomType == BottomTypeOrderChange) {
            [self requestAbnormity];
        }else if (self.bottomType == BottomTypeSuperDeep){
            [self requestDeepth];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self judgeTimerIsInit];
    
    [self getSelfSelectList];
    
    [self GetRoomInfo];
    
    if (User.userToken) {
        [self getUserInfo];
    }
    self.tabBarController.tabBar.hidden = YES;
}

- (void)judgeTimerIsInit{
    if (!self.timer) {
        clockCount = 3;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startClock) userInfo:nil repeats:YES];
        
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer{
    clockCount = 3;
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];
    
}

- (void)stopTimer{
    //  关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];

}

#pragma mark -- 当前K线数据指标值显示
- (void)addChartTitle{
    
    _mainTextLabel = [self createLabelTitle:@"" frame:CGRectMake(10, headerHeight + 2, SCREEN_WIDTH - 62, 10)];
    _mainTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.kLineBGView addSubview:_mainTextLabel];
    _mainTextLabel.hidden = YES;
    
    _volumTextLabel = [self createLabelTitle:@"" frame:CGRectMake(10, headerHeight + 2+ self.ChartHeight * CandleScale, SCREEN_WIDTH - 62, 10)];
    _volumTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.kLineBGView addSubview:_volumTextLabel];
    _volumTextLabel.hidden = YES;
    
    _fitureTextLabel = [self createLabelTitle:@"" frame:CGRectMake(10, headerHeight + 2 + self.ChartHeight * (CandleScale + VolumeScale), SCREEN_WIDTH - 100, 10)];
    _fitureTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
    _fitureTextLabel.adjustsFontSizeToFitWidth=YES;
    _fitureTextLabel.minimumScaleFactor=0.5;
    [self.kLineBGView addSubview:_fitureTextLabel];
    
    UILabel * riseDropLabel = [self createLabelTitle:@"涨幅：+0.27%  振幅：0.44%" frame:CGRectMake(10, headerHeight + 14, SCREEN_WIDTH - 32, 10)];
    riseDropLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:riseDropLabel.text];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[riseDropLabel.text rangeOfString:@"+0.27%"]];
    riseDropLabel.attributedText = att;
    _roseDropLabel = riseDropLabel;
    
    [self.kLineBGView addSubview:riseDropLabel];
}

// 主指标与成交量
- (void)upddateChartViewModel:(ZTYChartModel *)model{
    
    _volumTextLabel.text = [NSString stringWithFormat:@"量:%ld",model.volumn.integerValue];
    _volumTextLabel.hidden = NO;
    if (_candleChartView.mainquotaName == MainViewQuotaNameWithBOLL) {
        
        _mainTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"BOLL(20,2) BOLL:%@ UB:%@ LB:%@",[ZTYCalCuteNumber calculateBesideLing:model.BOLL_MB.floatValue],[ZTYCalCuteNumber calculateBesideLing:model.BOLL_UP.floatValue],[ZTYCalCuteNumber calculateBesideLing:model.BOLL_DN.floatValue]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2DB52D"] range:[title rangeOfString:[NSString stringWithFormat:@"BOLL:%@",[ZTYCalCuteNumber calculateBesideLing:model.BOLL_MB.floatValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"D89640"] range:[title rangeOfString:[NSString stringWithFormat:@"UB:%@",[ZTYCalCuteNumber calculateBesideLing:model.BOLL_UP.floatValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"E08FE0"] range:[title rangeOfString:[NSString stringWithFormat:@"LB:%@",[ZTYCalCuteNumber calculateBesideLing:model.BOLL_DN.floatValue]]]];
        _mainTextLabel.attributedText = attr;
        
    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithMA){
        _mainTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"MA5:%@ MA10:%@ MA30:%@",[ZTYCalCuteNumber calculateBesideLing:model.MA5.floatValue],[ZTYCalCuteNumber calculateBesideLing:model.MA10.floatValue],[ZTYCalCuteNumber calculateBesideLing:model.MA30.floatValue]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FBC170"] range:[title rangeOfString:[NSString stringWithFormat:@"MA5:%@",[ZTYCalCuteNumber calculateBesideLing:model.MA5.floatValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor magentaColor] range:[title rangeOfString:[NSString stringWithFormat:@"MA10:%@",[ZTYCalCuteNumber calculateBesideLing:model.MA10.floatValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"AED3E3"] range:[title rangeOfString:[NSString stringWithFormat:@"MA30:%@",[ZTYCalCuteNumber calculateBesideLing:model.MA30.floatValue]]]];
        _mainTextLabel.attributedText = attr;
    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithEMA){
        _mainTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"EMA7:%@ EMA30:%@",[ZTYCalCuteNumber calculateBesideLing:model.EMA7.floatValue],[ZTYCalCuteNumber calculateBesideLing:model.EMA30.floatValue]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"AED3E3"] range:[title rangeOfString:[NSString stringWithFormat:@"EMA7:%@",[ZTYCalCuteNumber calculateBesideLing:model.EMA7.floatValue]]]];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FBC170"] range:[title rangeOfString:[NSString stringWithFormat:@"EMA30:%@",[ZTYCalCuteNumber calculateBesideLing:model.EMA30.floatValue]]]];
        _mainTextLabel.attributedText = attr;
    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithSAR){
        _mainTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"SAR(20,2) %@",[ZTYCalCuteNumber calculateBesideLing:model.ParOpen]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2FD2B2"] range:[title rangeOfString:[NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculateBesideLing:model.ParOpen]]]];
        
        _mainTextLabel.attributedText = attr;
    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithNone){
        _mainTextLabel.hidden = YES;
    }
    
}

- (void)updateLatestTextLine{
    
    //    if (self.latesetClose) {
    [self.latestLinetextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:self.latesetClose]]];
    CGFloat pointY = [_candleChartView getPointYculateValue:self.latesetClose];
    if (pointY < 0 ) {
        pointY = 15;
    }
    
    if ( pointY > self.ChartHeight * CandleScale) {
        pointY = self.ChartHeight * CandleScale;
    }
    [self.latestLinetextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pointY - 7.5 + headerHeight);
    }];
    //    }
}

- (void)upddateQuotaViewModel:(ZTYChartModel *)model{
    
    _latestModel = model;
    _fitureTextLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    if (_quotaChartView.quotaName == FigureViewQuotaNameWithMACD) {
        _fitureTextLabel.hidden = NO;
        NSString * title = [NSString stringWithFormat:@"MACD(12,26,9) DIF:%@ DEA:%@ MACD:%@",[ZTYCalCuteNumber calculateBesideLing:model.DIF.doubleValue],[ZTYCalCuteNumber calculateBesideLing:model.DEA.doubleValue],[ZTYCalCuteNumber calculateBesideLing:model.MACD.doubleValue]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"DF8ADF"] range:[title rangeOfString:[NSString stringWithFormat:@"MACD:%@",[ZTYCalCuteNumber calculateBesideLing:model.MACD.doubleValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ACD2E5"] range:[title rangeOfString:[NSString stringWithFormat:@"DIF:%@",[ZTYCalCuteNumber calculateBesideLing:model.DIF.doubleValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F0BC79"] range:[title rangeOfString:[NSString stringWithFormat:@"DEA:%@",[ZTYCalCuteNumber calculateBesideLing:model.DEA.doubleValue]]]];
        _fitureTextLabel.attributedText = attr;
        
    }else if (_quotaChartView.quotaName == FigureViewQuotaNameWithKDJ){
        
        _fitureTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"KDJ(9,3,3) K:%@ D:%@ J:%@",[ZTYCalCuteNumber calculateBesideLing:model.KDJ_K.doubleValue],[ZTYCalCuteNumber calculateBesideLing:model.KDJ_D.doubleValue],[ZTYCalCuteNumber calculateBesideLing:model.KDJ_J.doubleValue]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"B2DBEF"] range:[title rangeOfString:[NSString stringWithFormat:@"K:%@",[ZTYCalCuteNumber calculateBesideLing:model.KDJ_K.doubleValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FDC071"] range:[title rangeOfString:[NSString stringWithFormat:@"D:%@",[ZTYCalCuteNumber calculateBesideLing:model.KDJ_D.doubleValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"EA9BEA"] range:[title rangeOfString:[NSString stringWithFormat:@"J:%@",[ZTYCalCuteNumber calculateBesideLing:model.KDJ_J.doubleValue]]]];
        _fitureTextLabel.attributedText = attr;
    }else if (_quotaChartView.quotaName == FigureViewQuotaNameWithRSI){
        
        _fitureTextLabel.hidden = NO;
        NSString * title = [NSString stringWithFormat:@"RSI(6,12,24) RSI6:%@ RSI12:%@ RSI24:%@",[ZTYCalCuteNumber calculateBesideLing:model.RSI_6.doubleValue],[ZTYCalCuteNumber calculateBesideLing:model.RSI_12.doubleValue],[ZTYCalCuteNumber calculateBesideLing:model.RSI_24.doubleValue]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"62BEA7"] range:[title rangeOfString:[NSString stringWithFormat:@"RSI6:%@",[ZTYCalCuteNumber calculateBesideLing:model.RSI_6.doubleValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CFB85B"] range:[title rangeOfString:[NSString stringWithFormat:@"RSI12:%@",[ZTYCalCuteNumber calculateBesideLing:model.RSI_12.doubleValue]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"C24EA9"] range:[title rangeOfString:[NSString stringWithFormat:@"RSI24:%@",[ZTYCalCuteNumber calculateBesideLing:model.RSI_24.doubleValue]]]];
        _fitureTextLabel.attributedText = attr;
    }else if (_quotaChartView.quotaName == FigureViewQuotaNameWithWR){
        _fitureTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"WR:%@",[ZTYCalCuteNumber calculateBesideLing:model.WR.doubleValue]];
        _fitureTextLabel.textColor = [UIColor redColor];
        _fitureTextLabel.text = title;
    }
}

- (void)addRootScrollView{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HOME_INDICATOR_HEIGHT - NAVIGATION_HEIGHT)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    _rootScrollView = scrollView;
    scrollView.contentSize = CGSizeMake(0, 2 * SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
}

- (void)setChangeBackBlue:(BOOL)blue{
    ZTYLeftLabel * label = [_headView viewWithTag:719];
    UIButton * changeBtn = [_headView viewWithTag:508];
    if (blue) {
       
        label.backgroundColor = backBlue;
        [changeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        changeBtn.backgroundColor = backBlue;
        [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        label.textColor = [UIColor whiteColor];
        changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, changeBtn.titleLabel.bounds.size.width+5, 0, -changeBtn.titleLabel.bounds.size.width)];
    }else{
        label.backgroundColor = [UIColor whiteColor];;
        [changeBtn setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
        changeBtn.backgroundColor = [UIColor whiteColor];
        [changeBtn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
        label.textColor = [UIColor colorWithHexString:@"626A75"];
        changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -changeBtn.imageView.size.width + 4, 0, changeBtn.imageView.size.width - 4)];
        [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, changeBtn.titleLabel.bounds.size.width+5, 0, -changeBtn.titleLabel.bounds.size.width)];
    }
    
    
}

// 顶部视图
- (void)addHeaderView{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.kLineBGView addSubview:headView];
    _headView = headView;
    
    NSString * priceStr = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:[self.desListModel.price floatValue]]];
    CGFloat width = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:30]}].width ;
    
    UILabel *pricelabel = [self createLabelTitle:priceStr frame:CGRectMake(16, 16, width , 30)];
    pricelabel.tag = 712;
    pricelabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:29];
    pricelabel.textColor = [UIColor colorWithHexString:@"FF4040"];
    [headView addSubview:pricelabel];
    
    
    UILabel * verbPriceLabel = [self createLabelTitle:@"≈81.11CNY" frame:CGRectMake(16, 54, 100, 12)]; // CGRectMake(16 + 8 + width, 16 + 18, 80, 12)
    verbPriceLabel.tag = 718;
    verbPriceLabel.textColor = [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0];
    [headView addSubview:verbPriceLabel];
    
    NSString * changeStr = [NSString stringWithFormat:@"%.2f%%", [self.desListModel.change floatValue]];
    UILabel *cnylabel = [self createLabelTitle:[NSString stringWithFormat:@"%@",changeStr] frame:CGRectMake(16 + 8 + width, 16 + 18, 80, 12)]; // CGRectMake(16, 54, 100, 12)
    cnylabel.textColor = [UIColor colorWithHexString:@"FF4040"];
    cnylabel.tag = 711;
    [headView addSubview:cnylabel];
    [self setChangeBackBlue:NO];
    
    ZTYLeftLabel *exchangeLabel = [[ZTYLeftLabel alloc] init];
    exchangeLabel.frame = CGRectMake(SCREEN_WIDTH - 117- 100, 16, 101, 10);
    exchangeLabel.text = [NSString stringWithFormat:@"%@",self.desListModel.exchange];
    exchangeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    exchangeLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    //    ZTYLeftLabel * exchangeLabel = [self createLabelTitle:[NSString stringWithFormat:@"%@",self.desListModel.exchange] frame:CGRectMake(SCREEN_WIDTH - 107, 15, 27, 12)];
    exchangeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    exchangeLabel.tag = 719;
    [_headView addSubview:exchangeLabel];
    //    exchangeLabel.backgroundColor = [UIColor yellowColor];
    exchangeLabel.leftDistance = 4;
    [self.view addSubview:self.exchangeTableView];
    
    
    UIButton * changeBtn = [self createBtnTiltle:[NSString stringWithFormat:@"%@/%@",self.desListModel.symbol,self.desListModel.quote] frame:CGRectMake(SCREEN_WIDTH - 117 - 100, 26, 101, 28)];
    [changeBtn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.tag = 508;
    [headView addSubview:changeBtn];
    [self setChangeBackBlue:NO];
    
    
    
    self.exchangeX = SCREEN_WIDTH - 117 - 100;
    
    UILabel * onedayLabel = [self createLabelTitle:@"24h量/额：23万/11亿元" frame:CGRectMake(16, 72, SCREEN_WIDTH - 116 - 16, 12)];
    onedayLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    onedayLabel.tag = 710;
    
    //    onedayLabel.textColor = [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.8/1.0];
    onedayLabel.textColor = [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0];
    [headView addSubview:onedayLabel];
    
    
    UILabel * highRiskLabel = [self createLabelTitle:@"风险高(100)" frame:CGRectMake(SCREEN_WIDTH - 60, 12, 56, 10)];
    highRiskLabel.textColor =[UIColor colorWithHexString:@"626A75" alpha:0.6];
    highRiskLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
    highRiskLabel.textAlignment = NSTextAlignmentRight;
    [headView addSubview:highRiskLabel];
    
    UILabel * lowRiskLabel = [self createLabelTitle:@"风险低(1)" frame:CGRectMake(SCREEN_WIDTH - 64, 75, 56, 10)];
    lowRiskLabel.textColor =[UIColor colorWithHexString:@"626A75" alpha:0.6];
    lowRiskLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
    lowRiskLabel.textAlignment = NSTextAlignmentRight;
    [headView addSubview:lowRiskLabel];
    
    UIImageView * angleview = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16, 23, 10, 52)];
    angleview.image = [UIImage imageNamed:@"kangle"];
    [headView addSubview:angleview];
    
    ZTYArrowLine * arrowLine = [[ZTYArrowLine alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16+ 2.5 - 12, 23 + 26 - 3, 12, 6)];
    arrowLine.tag = 715;
    [headView addSubview:arrowLine];
    
    UILabel * airLabel = [self createLabelTitle:@"44.44" frame:CGRectMake(SCREEN_WIDTH - 67, 36, 40, 16)];
    airLabel.textColor =[UIColor colorWithHexString:@"626A75"];
    airLabel.font =  [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    airLabel.tag = 717;
    airLabel.textAlignment = NSTextAlignmentRight;
    [headView addSubview:airLabel];
    
    UILabel * airTitleLabel = [self createLabelTitle:@"空气指数" frame:CGRectMake(SCREEN_WIDTH - 68, 56, 40, 10)];
    airTitleLabel.textColor =[UIColor colorWithHexString:@"626A75" alpha:0.6];
    airTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
    airTitleLabel.textAlignment = NSTextAlignmentRight;
    [headView addSubview:airTitleLabel];
    
    
    CGFloat left =  40;
    UIButton *noteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - left, 90 , 24, 30) ];
    //    [noteBtn setImage:[UIImage imageNamed:@"full_screen"] forState:UIControlStateNormal];
    [noteBtn setTitle:@"盯盘" forState:UIControlStateNormal];
    [noteBtn setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
    [noteBtn addTarget:self action:@selector(noteclick:) forControlEvents:UIControlEventTouchUpInside];
    noteBtn.tag = 666;
    noteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_headView addSubview:noteBtn];
    //    CGFloat left =  36;
    //    UIButton *fullBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - left, 90 , 30, 30) ];
    //    [fullBtn setImage:[UIImage imageNamed:@"full_screen"] forState:UIControlStateNormal];
    //    [fullBtn addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    //    fullBtn.tag = 444;
    //    [_headView addSubview:fullBtn];
    
    
    // select_add
    UIButton * selectSelf = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - left - 32 - 14, 90 , 32, 30)];
    [selectSelf addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
    selectSelf.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [selectSelf setTitle:@"+自选" forState:UIControlStateNormal];
    [selectSelf setTitle:@"-自选" forState:UIControlStateSelected];
    [selectSelf setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateSelected];
    [selectSelf setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
    //    [selectSelf setImage:[UIImage imageNamed:@"select_add"] forState:UIControlStateNormal];
    //    [selectSelf setImage:[UIImage imageNamed:@"select_sub"] forState:UIControlStateSelected];
    selectSelf.tag = 509;
    //    selectSelf.backgroundColor = [UIColor yellowColor];
    [headView addSubview:selectSelf];
    
    
    
    
    
    NSArray * arr;
    if ([self judgeIsBigCoin]) {
        if (self.isRead) {
            arr = @[@"1小时",@"MA",@"MACD",@"交易分布"];
            _candleChartView.isNotComment = YES;
            self.distrabuteView.hidden = NO;
        }else{
            arr = @[@"1小时",@"MA",@"MACD",@"实时解盘"];
            self.distrabuteView.hidden = YES;
            _candleChartView.isNotComment = NO;
        }
    }else{
        arr = @[@"1小时",@"MA",@"MACD",@"交易分布"];
        self.distrabuteView.hidden = NO;
        _candleChartView.isNotComment = YES;
    }
    for (int i = 0; i < 4; i ++) {
        //        UIButton * btn = [self createBtn:arr[i] frame:CGRectMake(btnW * i, 103, btnW, 12)];
        //        [headView addSubview:btn];
        
        UIButton * btn;
        if (i == 0) {
            btn = [self createBtnTiltle:arr[i] frame:CGRectMake((btnWidth + intalval) * i + 16, 90, timeWidth, 28)];
        }else{
            btn = [self createBtnTiltle:arr[i] frame:CGRectMake((btnWidth + intalval) * (i - 1) + 16 + timeWidth, 90, btnWidth, 28)];
        }
        
        [btn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 500 + i;
        [headView addSubview:btn];
        
    }
    
//    UIButton *commentBtn = [self createImageBtn:CGRectMake((SCREEN_WIDTH - left - 46 - (btnWidth + intalval) * 3 - 16 - 40) * 0.5 + (btnWidth + intalval) * 3 + 16, 90, 40, 30) img:@"kcomment" title:@"分析" titleW:24];
//    [commentBtn addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
//    [commentBtn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
//    [commentBtn setTitleColor:[UIColor colorWithHexString:@"308cdd"] forState:UIControlStateSelected];
//    [commentBtn setImage:[UIImage imageNamed:@"kcomment_sel"] forState:UIControlStateSelected];
//    commentBtn.selected = YES;
//    [_headView addSubview:commentBtn];
//    commentBtn.hidden = YES;
//    _combtn = commentBtn;
    
    
    UIView * infoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, HeadTopHeight, SCREEN_WIDTH, 22)];
    infoBGView.backgroundColor = [UIColor colorWithHexString:@"E8ECEF"];
    [headView addSubview:infoBGView];
    
    UILabel * descLabel = [self createLabelTitle:@"2018/05/18 11:00 开:7991.19  高:8019.17 低:7984.21 收:8009.00" frame:CGRectMake(0, 6, SCREEN_WIDTH, 10)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:10]; //[UIFont fontWithName:@"PingFangSC-Regular" size:10];
    descLabel.textColor = [UIColor colorWithHexString:@"626A75"];//[UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0];
    [infoBGView addSubview:descLabel];
    _descLabel.numberOfLines = 0;
    _descLabel = descLabel;
    
}

- (void)addBottomSmallItem{
    
    UIView * klineb = [[UIView alloc] initWithFrame:CGRectMake(0, self.ChartHeight + headerHeight, SCREEN_WIDTH, 8)];
    klineb.backgroundColor = KBGColor;
    [self.kLineBGView addSubview:klineb];
    
    self.bottomView = [self bottomSamllItemView:CGRectMake(0, self.ChartHeight + headerHeight + 8, SCREEN_WIDTH, 42)];
    [self.kLineBGView addSubview:self.bottomView];
    
    self.floatBottomView = [self bottomSamllItemView:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    self.floatBottomView.hidden = YES;
    [self.view addSubview:self.floatBottomView];
    
    _itemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 42)];
    _itemScrollView.contentSize = CGSizeMake(2 * SCREEN_WIDTH, 0);
    _itemScrollView.pagingEnabled = YES;
    _itemScrollView.delegate = self;
    _itemScrollView.bounces = NO;
    _itemScrollView.backgroundColor = [UIColor whiteColor];
    [self.rootScrollView addSubview:_itemScrollView];
    
    NSString * baseUrlStr = [NSString stringWithFormat:@"%@%@?hideMenu=true&base=%@&quote=%@&exchange=%@", kAppKlineBottomAddress,self.base,self.base,self.quote,self.exchange];
    
    NSString * urlFlowStr = [NSString stringWithFormat:@"%@&index=1",baseUrlStr];
    KitemWebViewController * webFlowViewVC = [[KitemWebViewController alloc] initWithUrl:urlFlowStr];
    webFlowViewVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 600  / 375.0 * SCREEN_WIDTH);
    [_itemScrollView addSubview:webFlowViewVC.view];
    [self addChildViewController:webFlowViewVC];
    WS(weakSelf)
    webFlowViewVC.updateHeightBlock = ^(CGFloat height) {
        weakSelf.flowHeight = height;
        [weakSelf updateSmallFrame:height];
    };
    
    
    NSString * descurlStr = [NSString stringWithFormat:@"%@%@",kAppKlineBottomchainDetailAddress,self.base];// [NSString stringWithFormat:@"%@&index=1",baseUrlStr]; //
    KitemWebViewController * webDescViewVC = [[KitemWebViewController alloc] initWithUrl:descurlStr];
    webDescViewVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 600  / 375.0 * SCREEN_WIDTH);
    [_itemScrollView addSubview:webDescViewVC.view];
    [self addChildViewController:webDescViewVC];
    webDescViewVC.updateHeightBlock = ^(CGFloat height) {
        weakSelf.descHeight = height;
    };
    
//    NSString * counterurlStr = [NSString stringWithFormat:@"%@&index=3",baseUrlStr];
//    KitemWebViewController * webCounterViewVC = [[KitemWebViewController alloc] initWithUrl:counterurlStr];
//    webCounterViewVC.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, 1722  / 375.0 * SCREEN_WIDTH);
//    [_itemScrollView addSubview:webCounterViewVC.view];
//    [self addChildViewController:webCounterViewVC];
//    webCounterViewVC.updateHeightBlock = ^(CGFloat height) {
//        weakSelf.counterHeight = height;
//    };
    
//    NSString * gradeurlStr = [NSString stringWithFormat:@"%@&index=4",baseUrlStr];
//    KitemWebViewController * webGradeViewVC = [[KitemWebViewController alloc] initWithUrl:gradeurlStr];
//    webGradeViewVC.view.frame = CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, 1722  / 375.0 * SCREEN_WIDTH);
//    [_itemScrollView addSubview:webGradeViewVC.view];
//    [self addChildViewController:webGradeViewVC];
//    webGradeViewVC.updateHeightBlock = ^(CGFloat height) {
//        weakSelf.gradeHeight = height;
//    };
    
}

- (void)addBottomItem{
    
    UIView * klineb = [[UIView alloc] initWithFrame:CGRectMake(0, self.ChartHeight + headerHeight, SCREEN_WIDTH, 8)];
    klineb.backgroundColor = KBGColor;
    [self.kLineBGView addSubview:klineb];
    
    self.bottomView = [self bottomItemView:CGRectMake(0, self.ChartHeight + headerHeight + 8, SCREEN_WIDTH, 42)];
    [self.kLineBGView addSubview:self.bottomView];
    
    self.floatBottomView = [self bottomItemView:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    self.floatBottomView.hidden = YES;
    [self.view addSubview:self.floatBottomView];
    
    _itemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 42)];
    _itemScrollView.contentSize = CGSizeMake(5 * SCREEN_WIDTH, 0);
    _itemScrollView.pagingEnabled = YES;
    _itemScrollView.delegate = self;
    _itemScrollView.bounces = NO;
    _itemScrollView.backgroundColor = [UIColor whiteColor];
    [self.rootScrollView addSubview:_itemScrollView];
    
    for (int tag = 0; tag < 2; tag ++) {
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * tag, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 42) style:UITableViewStyleGrouped];
        tableview.dataSource = self;
        tableview.delegate = self;
        tableview.bounces = NO;
        tableview.scrollEnabled = NO;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_itemScrollView addSubview:tableview];
        tableview.backgroundColor = [UIColor whiteColor];
        tableview.tag = 400 + tag;
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@?hideMenu=true&base=%@&quote=%@&exchange=%@&index=%d", kAppKlineBottomAddress,self.base,self.base,self.quote,self.exchange,1]; // @"http://www.baidu.com";//
    KitemWebViewController * webFlowViewVC = [[KitemWebViewController alloc] initWithUrl:urlStr];
    webFlowViewVC.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, 1722  / 375.0 * SCREEN_WIDTH);
    [_itemScrollView addSubview:webFlowViewVC.view];
    [self addChildViewController:webFlowViewVC];
    WS(weakSelf)
    webFlowViewVC.updateHeightBlock = ^(CGFloat height) {
        if (weakSelf.bottomType == BottomTypeFoundFlow) {
            [weakSelf updateWebHeight:height];
        }
        weakSelf.flowHeight = height;
    };
    
    NSString * descurlStr = [NSString stringWithFormat:@"%@%@",kAppKlineBottomchainDetailAddress,self.base];// [NSString stringWithFormat:@"%@%@?hideMenu=true&base=%@&quote=%@&exchange=%@&index=%d", kAppKlineBottomAddress,self.base,self.base,self.quote,self.exchange,2]; // [NSString stringWithFormat:@"http://172.16.24.202:8081/v2/wechat/chainsearchprojectdetail/%@",self.base];//
    KitemWebViewController * webDescViewVC = [[KitemWebViewController alloc] initWithUrl:descurlStr];
    webDescViewVC.view.frame = CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, 600);
    [_itemScrollView addSubview:webDescViewVC.view];
    [self addChildViewController:webDescViewVC];
    webDescViewVC.updateHeightBlock = ^(CGFloat height) {
        
        
        if (weakSelf.bottomType == BottomTypeDesc) {
            [weakSelf updateWebHeight:height];
        }
        
        
        weakSelf.descHeight = height;
    };
    
    //    self.webFlowView = [[UIWebView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, (793) / 375.0 * SCREEN_WIDTH)];
    //    self.webFlowView.scrollView.bounces = NO;
    //    self.webFlowView.userInteractionEnabled = NO;
    //    [_itemScrollView addSubview:self.webFlowView];
    //    [self.webFlowView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    //    self.webDescView = [[UIWebView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, 1722  / 375.0 * SCREEN_WIDTH)];
    //    [self.webDescView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:descurlStr]]];
    //    self.webDescView.delegate = self;
    //    self.webDescView.userInteractionEnabled = NO;
    //    [_itemScrollView addSubview:self.webDescView];
    
}

- (void)updateWebHeight:(CGFloat)height{
    if (height <= 0) {
        height = (600 / 375.0) * SCREEN_WIDTH;
    }
    _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight , SCREEN_WIDTH, height);
    _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight + height + bottomHeight );
}

//- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx{
//    if (webView == self.webDescView) {
//        TestJSObject *testJO=[TestJSObject new];
//        testJO.delegate = self;
//        ctx[@"bteApp"]=testJO;
//        ctx[@"viewController"] = self;
//        ctx.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//            context.exception = exceptionValue;
//            NSLog(@"JSContext------>异常信息：%@", exceptionValue);
//        };
//    }else if (webView == self.webFlowView){
//        TestJSObject *testJO=[TestJSObject new];
//        testJO.delegate = self;
//        ctx[@"bteApp"]=testJO;
//        ctx[@"viewController"] = self;
//        ctx.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//            context.exception = exceptionValue;
//            NSLog(@"JSContext------>异常信息：%@", exceptionValue);
//        };
//    }
//}
//
//-(void)go2PageVc:(NSDictionary *)obj{
//    NSLog(@"%@",obj);
//    if (obj != nil) {
//        NSString *action = [obj objectForKey:@"action"];
//        if ([action isEqualToString:@"ActualHeight"]) {
//            CGFloat height = [[obj objectForKey:@"jsonStr"] floatValue];
//
////             CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, 1722  / 375.0 * SCREEN_WIDTH);
//            if (self.bottomType == BottomTypeFoundFlow) {
//                NSLog(@"BottomTypeFoundFlow===>%f",height);
//            }else if (self.bottomType == BottomTypeDesc){
//                NSLog(@"BottomTypeDesc===>%f",height);
//            }
//        }
//    }
//
//
//
//}

- (void)updateWebAndScrollViewHeigth{
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    NMShowLoadIng;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NMRemovLoadIng;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        
        return YES;
        
    }
    
    return NO;
    
}

- (UIView *)bottomItemView:(CGRect)frame{
    
    UIView * bottomView = [[UIView alloc] initWithFrame:frame];
    bottomView.backgroundColor = KBGColor;
    
    NSArray * itemTiles = @[@"超级深度",@"大单成交",@"资金流向",@"币种详情",@"实时讨论"];
    CGFloat btnW = SCREEN_WIDTH / (itemTiles.count * 1.0);
    for (int i = 0; i < itemTiles.count; i ++) {
        UIButton * btn = [self createBtn:itemTiles[i] frame:CGRectMake(0 + btnW * i, 1, btnW, 40)];
        btn.tag = 900 + i;
        btn.titleLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(itemTabelChoose:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"44A0F1"] forState:UIControlStateNormal];
        }
        [bottomView addSubview:btn];
    }
    UILabel * countLabel = [self createLabelTitle:@"" frame:CGRectMake(4 * btnW, 28, btnW, 10)];
    [bottomView addSubview:countLabel];
    countLabel.tag = 222;
    countLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    countLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    countLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake((btnW - 40) * 0.5, 1 + 40 - 2, 40, 2)];
    lineview.tag = 899;
    lineview.backgroundColor = [UIColor colorWithHexString:@"44A0F1"];
    [bottomView addSubview:lineview];
    return bottomView;
}

- (UIView *)bottomSamllItemView:(CGRect)frame{
    
    UIView * bottomView = [[UIView alloc] initWithFrame:frame];
    bottomView.backgroundColor = KBGColor;
    
    NSArray * itemTiles = @[@"资金流向",@"币种详情"];
    CGFloat btnW = SCREEN_WIDTH / (itemTiles.count * 1.0);
    for (int i = 0; i < itemTiles.count; i ++) {
        UIButton * btn = [self createBtn:itemTiles[i] frame:CGRectMake(0 + btnW * i, 1, btnW, 40)];
        btn.tag = 900 + i;
        btn.titleLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(samllitemTabelChoose:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"44A0F1"] forState:UIControlStateNormal];
        }
        [bottomView addSubview:btn];
    }
    UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake((btnW - 40) * 0.5, 1 + 40 - 2, 40, 2)];
    lineview.tag = 899;
    lineview.backgroundColor = [UIColor colorWithHexString:@"44A0F1"];
    [bottomView addSubview:lineview];
    return bottomView;
}

- (void)addQuotaBorderView
{
    UIView *bottomLineView = [UIView new];
    [self.kLineBGView addSubview:bottomLineView];
    bottomLineView.userInteractionEnabled = NO;
    bottomLineView.backgroundColor = LineBGColor;
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight + headerHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-lineBgWidth);
        make.right.equalTo(self.kLineBGView).offset(lineBgWidth);
        make.height.equalTo(@(lineBgWidth));
    }];
    
    UIView * volumeBottomLine = [UIView new];
    [self.kLineBGView addSubview:volumeBottomLine];
    volumeBottomLine.userInteractionEnabled = NO;
    volumeBottomLine.backgroundColor = LineBGColor;
    [volumeBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight * (CandleScale + VolumeScale) + headerHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-lineBgWidth);
        make.right.equalTo(self.kLineBGView).offset(lineBgWidth);
        make.height.equalTo(@(lineBgWidth));
    }];
    
    UIView * mainViewBottomLine = [UIView new];
    [self.kLineBGView addSubview:mainViewBottomLine];
    mainViewBottomLine.userInteractionEnabled = NO;
    mainViewBottomLine.backgroundColor = LineBGColor;
    [mainViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight * (CandleScale) + headerHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-lineBgWidth);
        make.right.equalTo(self.kLineBGView).offset(lineBgWidth);
        make.height.equalTo(@(lineBgWidth));
    }];
}

#pragma mark --event

#pragma mark --按钮点击事件处理
- (void)changeBtn:(UIButton *)btn{
    if (_exchangeArray.count > 0) {
        //        _exchangeTableView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 264);
        _exchangeTableView.hidden = NO;
//        [self updateBtnStatus:508 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        [self setChangeBackBlue:YES];
        [_exchangeTableView reloadData];
    }else{
        //        [self requestExchangeData];
    }
}

- (void)gotoTop{
    [self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

// 全屏模式
- (void)clickFullScreen:(UIButton *)btn{
    if (btn.tag == 444) {
        BTEFullScreenKlineViewController * fvc = [[BTEFullScreenKlineViewController alloc] init];
        fvc.base = self.base;
        fvc.exchange = self.exchange;
        fvc.quote = self.quote;
        [self presentViewController:fvc animated:NO completion:nil];
    }else{
        
        [self hiddenAllChoseBGView];
        
//        _combtn.selected = !_combtn.selected;
//        if (_combtn.selected) {
//
//            self.ktype = @"1h";
//            _candleChartView.mainchartType = MainChartcenterViewTypeKline;
//            [self resetData];
//            [self requestData];
//
//            [self updateBtnStatus:500 title:@"1小时" imageHide:NO hideBackColor:[UIColor whiteColor]];
//
//            NSArray *ktypes = @[@"分时",@"1分",@"5分",@"15分",@"1小时",@"4小时",@"1天"];
//            for (int i = 0; i < ktypes.count; i ++) {
//                UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
//                button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
//            }
//            UIButton * hourBtn = [_ktypeBGView viewWithTag:2005];
//            hourBtn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
//
//            _candleChartView.isNotComment = NO;
//            [_candleChartView showCommentBtns];
//
//        }else{
//            _candleChartView.isNotComment = YES;
//            [_candleChartView hideCommentBtns];
//        }
    }
}

- (void)noteclick:(UIButton *)btn{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@?base=%@&quote=%@&exchange=%@", kAppKlineNoteAddress,self.base,self.quote,self.exchange];
    SecondaryLevelWebViewController * vc = [[SecondaryLevelWebViewController alloc] init];
    vc.urlString = urlStr;
    vc.isHiddenLeft = NO;
    vc.isHiddenBottom = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)hideBesides:(NSInteger)tag{
    
    if (tag != 500) {
        _ktypeBGView.hidden = YES;
        [self updateBtnStatus:500 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag !=501) {
        _mainQuotaTypeBGView.hidden = YES;
        [self updateBtnStatus:501 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag != 502) {
        _fitureQuotaBGView.hidden = YES;
        [self updateBtnStatus:502 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag != 503) {
        _otherBGView.hidden = YES;
        [self updateBtnStatus:503 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag != 508) {
        _exchangeTableView.hidden = YES;
//        [self updateBtnStatus:508 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        [self setChangeBackBlue:NO];
    }
    //    _verticalLabel.hidden = YES;
    _verticalView.hidden = YES;
    //    _lineTextView.hidden = YES;
}

#pragma mark -- 设置主图指标、附图指标、K线类型选择
- (void)selectTypeItem:(UIButton *)btn{
    [self hideBesides:btn.tag];
    if (btn.tag == 500) {
        
        if (self.ktypeBGView.hidden) {
            // K线
            self.ktypeBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:500 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _ktypeBGView.hidden = YES;
            [self updateBtnStatus:500 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
        
    }else if(btn.tag == 501){
        // 主图指标
        if (self.mainQuotaTypeBGView.hidden) {
            self.mainQuotaTypeBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:501 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _mainQuotaTypeBGView.hidden = YES;
            [self updateBtnStatus:501 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
    }else if(btn.tag == 502){
        // 附图指标
        if (self.fitureQuotaBGView.hidden) {
            self.fitureQuotaBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:502 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _fitureQuotaBGView.hidden = YES;
            [self updateBtnStatus:502 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
    }else if (btn.tag == 503){
        
        if (self.otherBGView.hidden) {
            self.otherBGView.hidden = NO;
            [self updateBtnStatus:503 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _otherBGView.hidden = YES;
            [self updateBtnStatus:503 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
        
    }else if (btn.tag == 508){
        
        if (self.exchangeTableView.hidden) {
            _exchangeTableView.x = self.exchangeX;
            if (_exchangeArray.count > 0) {
                //        _exchangeTableView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 264);
                _exchangeTableView.hidden = NO;
                
//                [self updateBtnStatus:508 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
                [self setChangeBackBlue:YES];
                [_exchangeTableView reloadData];
            }else{
                [self requestExchangeData];
            }
        }else{
            _exchangeTableView.hidden = YES;
//            [self updateBtnStatus:508 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
            [self setChangeBackBlue:NO];
        }
        
    }else if (btn.tag == 509){
        if (btn.selected == YES) {
            [self delSelfSelect];
        }else{
            [self addSelfSelect];
        }
    }
}

- (void)itemTabelChoose:(UIButton *)btn{
    for (int i = 900; i < 905; i ++) {
        UIButton * button = [self.bottomView viewWithTag:i];
        [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
        UIButton * fbttn = [self.floatBottomView viewWithTag:i];
        [fbttn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    }
    UIButton * fbutton = [self.floatBottomView viewWithTag:btn.tag];
    [fbutton setTitleColor:[UIColor colorWithHexString:@"44A0F1"] forState:UIControlStateNormal];
    UIButton * obutton = [self.bottomView viewWithTag:btn.tag];
    [obutton setTitleColor:[UIColor colorWithHexString:@"44A0F1"] forState:UIControlStateNormal];
    
    UIView * line = [self.bottomView viewWithTag:899];
    CGFloat btnW = SCREEN_WIDTH / 5.0;
    line.frame = CGRectMake((btnW - 40) * 0.5 + btnW * (btn.tag - 900), line.frame.origin.y, 40, 2);
    UIView * fline = [self.floatBottomView viewWithTag:899];
    fline.frame = line.frame;
    //
    CGPoint contentOffset = _itemScrollView.contentOffset;
    contentOffset.x = (btn.tag-900) * SCREEN_WIDTH;
    [_itemScrollView setContentOffset:contentOffset animated:YES];
    _rootScrollView.scrollEnabled = YES;
    
    if (_rootScrollView.contentOffset.y >= self.ChartHeight + headerHeight + 8) {
        _rootScrollView.contentOffset = CGPointMake(0, self.ChartHeight + headerHeight + 8);
        self.topImageView.hidden = NO;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (btn.tag == 900) {
        
        self.bottomType = BottomTypeSuperDeep;
        [self requestDeepth];
    }else if (btn.tag == 901){
        self.bottomType = BottomTypeOrderChange;
        [self requestAbnormity];
        
    }else if (btn.tag == 902){
        
        self.bottomType = BottomTypeFoundFlow;
        CGFloat height = ((793) / 375.0) * SCREEN_WIDTH;
        if (_flowHeight > 0) {
            height = _flowHeight;
        }
        _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight , SCREEN_WIDTH, height);
        _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight + height + bottomHeight );
        
        
    }else if (btn.tag == 903){
        NSLog(@"%f",SCREEN_HEIGHT);
        self.bottomType = BottomTypeDesc;
        CGFloat height = (600 / 375.0) * SCREEN_WIDTH;
        if (_descHeight > 0) {
            height = _descHeight;
        }
        _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight , SCREEN_WIDTH, height);
        _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight + height + bottomHeight );
        
    }else if(btn.tag == 904){
        self.tempbottomType = self.bottomType;
        self.bottomType = BottomTypeChatView;
        _rootScrollView.scrollEnabled = NO;
        //        _rootScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
        //        [self updateTableScrollviewPosition:SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight - bottomHeight tag:4];
        
        //        _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight , SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
        //        _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight + tableBtnHeight + SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight - bottomHeight );
        
        if (self.chatVC) {
            _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight , SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
            _rootScrollView.contentOffset = CGPointMake(0, self.ChartHeight + headerHeight + 8);
            self.assistiveBtn.userInteractionEnabled = YES;
            self.topImageView.hidden = YES;
        }else{
            [self gotoChatGroup];
        }
        
    }
}

- (void)samllitemTabelChoose:(UIButton *)btn{
    for (int i = 900; i < 902; i ++) {
        UIButton * button = [self.bottomView viewWithTag:i];
        [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
        UIButton * fbttn = [self.floatBottomView viewWithTag:i];
        [fbttn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    }
    UIButton * fbutton = [self.floatBottomView viewWithTag:btn.tag];
    [fbutton setTitleColor:[UIColor colorWithHexString:@"44A0F1"] forState:UIControlStateNormal];
    UIButton * obutton = [self.bottomView viewWithTag:btn.tag];
    [obutton setTitleColor:[UIColor colorWithHexString:@"44A0F1"] forState:UIControlStateNormal];
    
    UIView * line = [self.bottomView viewWithTag:899];
    CGFloat btnW = SCREEN_WIDTH / 2.0;
    line.frame = CGRectMake((btnW - 40) * 0.5 + btnW * (btn.tag - 900), line.frame.origin.y, 40, 2);
    UIView * fline = [self.floatBottomView viewWithTag:899];
    fline.frame = line.frame;
    //
    CGPoint contentOffset = _itemScrollView.contentOffset;
    contentOffset.x = (btn.tag-900) * SCREEN_WIDTH;
    [_itemScrollView setContentOffset:contentOffset animated:YES];
    _rootScrollView.scrollEnabled = YES;
    CGFloat height = (600 / 375.0) * SCREEN_WIDTH;
    
    if (_rootScrollView.contentOffset.y >= self.ChartHeight + headerHeight + 8) {
        _rootScrollView.contentOffset = CGPointMake(0, self.ChartHeight + headerHeight + 8);
        self.topImageView.hidden = NO;
    }
    if (btn.tag == 900) {
        
        if (_descHeight > 0) {
            height = _descHeight;
        }
    }else if (btn.tag == 901){
        self.bottomType = BottomTypeFoundFlow;
        if (_flowHeight > 0) {
            height = _flowHeight;
        }
        
    }else if (btn.tag == 902){
        if (_counterHeight > 0) {
            height = _counterHeight;
        }
        
    }else if (btn.tag == 903){
        if (_gradeHeight > 0) {
            height = _gradeHeight;
        }
    }
    if (height < SCREEN_HEIGHT - tableBtnHeight - NAVIGATION_HEIGHT) {
        height = SCREEN_HEIGHT - tableBtnHeight - NAVIGATION_HEIGHT;
    }
    [self updateSmallFrame:height];
}

- (void)updateSmallFrame:(CGFloat)height{
    _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight , SCREEN_WIDTH, height);
    _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight + height + bottomHeight );
}

- (NSArray *)klineTypes{
    if (!_klineTypes) {
        _klineTypes = @[@"分时",@"1分",@"5分",@"15分",@"30分",@"1小时",@"4小时",@"1天",@"1周",@"1月"];
    }
    return _klineTypes;
}

- (UIView *)ktypeBGView{
    if (!_ktypeBGView) {
        
        _ktypeBGView = [[UIView alloc] initWithFrame:CGRectMake(16, HeadTopHeight, (btnWidth + 10)* 3, 35 * 4)];
        _ktypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_ktypeBGView];
        _ktypeBGView.hidden = YES;
        
        
        for (int index = 0; index < self.klineTypes.count; index ++) {
            
            UIButton * btn = [self createBtn:self.klineTypes[index] frame:CGRectMake((btnWidth+ 10) * (index %3) + 5, (index / 3) * 35, btnWidth, 28)];
            [btn addTarget:self action:@selector(choseKtypeItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2000 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_ktypeBGView addSubview:btn];
            if ([self.klineTypes[index] isEqualToString:@"1小时"]) {
                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            }
        }
    }
    return _ktypeBGView;
}

- (void)choseKtypeItem:(UIButton *)btn{
    
    for (int i = 0; i < self.klineTypes.count; i ++) {
        UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    [self updateBtnStatus:500 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
    _ktypeBGView.hidden = YES;
    NSArray * types= @[@"1m",@"1m",@"5m",@"15m",@"30m",@"1h",@"4h",@"1d",@"1w",@"1mo"];
    _ktype = types[btn.tag -2000];
//    _combtn.selected = NO;
    
    [self resetData];
    if ([btn.titleLabel.text isEqualToString:@"分时"]) {
        _candleChartView.mainchartType = MainChartcenterViewTypeTimeLine;
    }else{
        _candleChartView.mainchartType = MainChartcenterViewTypeKline;
    }
    [self requestData];
}

- (UIView *)mainQuotaTypeBGView{
    if (!_mainQuotaTypeBGView) {
        CGFloat btnH = 40;
        NSArray * quotaArr = @[@"MA",@"EMA",@"BOLL",@"SAR",@"关闭"];
        _mainQuotaTypeBGView = [[UIView alloc] initWithFrame:CGRectMake(16 + timeWidth, HeadTopHeight, btnWidth, quotaArr.count * btnH)];
        _mainQuotaTypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_mainQuotaTypeBGView];
        _mainQuotaTypeBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, 0 + index * btnH, btnWidth, btnH)];
            [btn addTarget:self action:@selector(chosequptaItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2100 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_mainQuotaTypeBGView addSubview:btn];
            if ([quotaArr[index] isEqualToString:@"MA"]) {
                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            }
        }
    }
    return _mainQuotaTypeBGView;
}

- (void)chosequptaItem:(UIButton *)btn{
    
    
    for (int i = 0; i < 5; i ++) {
        UIButton * button = [_mainQuotaTypeBGView viewWithTag:2100 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    if ([btn.titleLabel.text isEqualToString:@"关闭"]) {
        [self updateBtnStatus:501 title:@"主指标" imageHide:NO hideBackColor:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithNone;
        [_candleChartView reloadAtCurrentIndex];
    }else if([btn.titleLabel.text isEqualToString:@"BOLL"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithBOLL;
        [_candleChartView reloadAtCurrentIndex];
    }else if ([btn.titleLabel.text isEqualToString:@"MA"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithMA;
        [_candleChartView reloadAtCurrentIndex];
    }else if ([btn.titleLabel.text isEqualToString:@"EMA"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithEMA;
        [_candleChartView reloadAtCurrentIndex];
    }else if ([btn.titleLabel.text isEqualToString:@"SAR"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithSAR;
        [_candleChartView reloadAtCurrentIndex];
    }
    _mainQuotaTypeBGView.hidden = YES;
}

-(UIView *)fitureQuotaBGView{
    if (!_fitureQuotaBGView) {
        
        CGFloat btnH = 40;
        NSArray * quotaArr = @[@"MACD",@"KDJ",@"RSI"];
        _fitureQuotaBGView = [[UIView alloc] initWithFrame:CGRectMake(16 + (btnWidth + intalval) * 1 + timeWidth, HeadTopHeight, btnWidth, quotaArr.count * btnH)];
        _fitureQuotaBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_fitureQuotaBGView];
        _fitureQuotaBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, index * btnH, btnWidth, btnH)];
            btn.tag = 2200 + index;
            [btn addTarget:self action:@selector(choseFitureQuotaItem:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_fitureQuotaBGView addSubview:btn];
            if ([quotaArr[index] isEqualToString:@"MACD"]) {
                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            }
        }
    }
    return _fitureQuotaBGView;
}

- (void)choseFitureQuotaItem:(UIButton *)quotaBtn{
    
    for (int i = 0; i < 4; i ++) {
        UIButton * button = [_fitureQuotaBGView viewWithTag:2200 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    quotaBtn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    NSInteger tag = 502;
    NSString *title = quotaBtn.titleLabel.text;
    if ([quotaBtn.titleLabel.text isEqualToString:@"关闭"]) {
        [self updateBtnStatus:tag title:@"指标" imageHide:NO hideBackColor:[UIColor whiteColor]];
        _quotaChartView.quotaName = MainViewQuotaNameWithNone;
        [_quotaChartView stockFill];
    }else if([quotaBtn.titleLabel.text isEqualToString:@"MACD"]){
        [self updateBtnStatus:tag title:title imageHide:NO hideBackColor:[UIColor whiteColor]];
        _quotaChartView.quotaName = FigureViewQuotaNameWithMACD;
        [_quotaChartView stockFill];
        
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"KDJ"]){
        [self updateBtnStatus:tag title:title imageHide:NO hideBackColor:[UIColor whiteColor]];
        _quotaChartView.quotaName = FigureViewQuotaNameWithKDJ;
        [_quotaChartView stockFill];
        
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"RSI"]){
        [self updateBtnStatus:tag title:title imageHide:NO hideBackColor:[UIColor whiteColor]];
        _quotaChartView.quotaName = FigureViewQuotaNameWithRSI;
        [_quotaChartView stockFill];
        
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"WR"]){
        [self updateBtnStatus:tag title:title imageHide:NO hideBackColor:[UIColor whiteColor]];
        _quotaChartView.quotaName = FigureViewQuotaNameWithWR;
        [_quotaChartView stockFill];
    }
    
    [self upddateQuotaViewModel:_latestModel];
    
    
    [self showIndexLineView:self.candleChartView.leftPostion startIndex:self.candleChartView.currentStartIndex count:self.candleChartView.displayCount];
    _fitureQuotaBGView.hidden = YES;
}



-(UIView *)otherBGView{
    if (!_otherBGView) {
        
        CGFloat btnH = 40;
        NSArray * quotaArr;
        if ([self judgeIsBigCoin]) {
            quotaArr = @[@"实时解盘",@"交易分布",@"关闭"];
        }else{
            quotaArr = @[@"交易分布",@"关闭"];
        }
        
        _otherBGView = [[UIView alloc] initWithFrame:CGRectMake(16 + (btnWidth + intalval) * 2 + timeWidth, HeadTopHeight, btnWidth, quotaArr.count * btnH)];
        _otherBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_otherBGView];
        _otherBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, index * btnH, btnWidth, btnH)];
            btn.tag = 2500 + index;
            [btn addTarget:self action:@selector(otherItem:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_otherBGView addSubview:btn];
            if ([self judgeIsBigCoin]) {
                if (self.isRead) {
                    if ([quotaArr[index] isEqualToString:@"交易分布"]) {
                        btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
                    }
                }else{
                    if ([quotaArr[index] isEqualToString:@"实时解盘"]) {
                        btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
                    }
                }
                
            }else{
                if ([quotaArr[index] isEqualToString:@"交易分布"]) {
                    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
                }
            }
        }
    }
    return _otherBGView;
}

- (void)otherItem:(UIButton *)quotaBtn{
    
    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [_otherBGView viewWithTag:2500 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    quotaBtn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    self.isRead = NO;
    NSInteger tag = 503;
    NSString *title = quotaBtn.titleLabel.text;
    if ([quotaBtn.titleLabel.text isEqualToString:@"关闭"]) {
        [self updateBtnStatus:tag title:@"关闭" imageHide:NO hideBackColor:[UIColor whiteColor]];
        [_candleChartView hideCommentBtns];
        _distrabuteView.hidden = YES;
        _candleChartView.isNotComment = YES;
    }else if([quotaBtn.titleLabel.text isEqualToString:@"实时解盘"]){
        [self updateBtnStatus:tag title:title imageHide:NO hideBackColor:[UIColor whiteColor]];
        
        _distrabuteView.hidden = YES;
        
        self.ktype = @"1h";
        _candleChartView.mainchartType = MainChartcenterViewTypeKline;
        [self resetData];
        [self requestData];
        
        [self updateBtnStatus:500 title:@"1小时" imageHide:NO hideBackColor:[UIColor whiteColor]];
        
        NSArray *ktypes = @[@"分时",@"1分",@"5分",@"15分",@"1小时",@"4小时",@"1天"];
        for (int i = 0; i < ktypes.count; i ++) {
            UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
            button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        }
        UIButton * hourBtn = [_ktypeBGView viewWithTag:2005];
        hourBtn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
        
        _candleChartView.isNotComment = NO;
        
        
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"交易分布"]){
        [self updateBtnStatus:tag title:title imageHide:NO hideBackColor:[UIColor whiteColor]];
        _candleChartView.isNotComment = YES;
        _distrabuteView.hidden = NO;
        
    }
    [_candleChartView reloadAtCurrentIndex];
    
    
    [self showIndexLineView:self.candleChartView.leftPostion startIndex:self.candleChartView.currentStartIndex count:self.candleChartView.displayCount];
    _otherBGView.hidden = YES;
}

- (void)updateBtnStatus:(NSInteger)tag title:(NSString *)title imageHide:(BOOL) isHidden{
    UIButton * button = [_headView viewWithTag:tag];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
        //    CGSize titleSize = btn.titleLabel.bounds.size;
        CGSize imageSize = button.imageView.bounds.size;
        button.imageEdgeInsets = UIEdgeInsetsMake(14,width, 9, -width);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 4, 0, imageSize.width + 4);
        //        button.backgroundColor = [UIColor whiteColor];
        //        [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    }else{
        if (isHidden) {
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            button.backgroundColor = [UIColor colorWithHexString:@"1e2237"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
            CGFloat width = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
            //    CGSize titleSize = btn.titleLabel.bounds.size;
            CGSize imageSize = button.imageView.bounds.size;
            button.imageEdgeInsets = UIEdgeInsetsMake(14,width, 9, -width);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 4, 0, imageSize.width + 4);
        }
    }
    _scrollView.scrollEnabled = YES;
    
}

- (void)hiddenAllChoseBGView{
    _ktypeBGView.hidden = YES;
    [self updateBtnStatus:500 title:@"" imageHide:NO];
    _mainQuotaTypeBGView.hidden = YES;
    [self updateBtnStatus:501 title:@"" imageHide:NO];
    _fitureQuotaBGView.hidden = YES;
    [self updateBtnStatus:502 title:@"" imageHide:NO];
    _otherBGView.hidden = YES;
    [self updateBtnStatus:503 title:@"" imageHide:NO];
    _exchangeTableView.hidden = YES;
    [self setChangeBackBlue:NO];
//    [self updateBtnStatus:508 title:[NSString stringWithFormat:@"%@/%@",self.base?self.base:self.desListModel.symbol,self.quote?self.quote:self.desListModel.quote] imageHide:NO hideBackColor:[UIColor whiteColor]];
}

- (void)getLocalData{
    NSString * dataKey = [NSString stringWithFormat:@"commont-%@-%@-KEY",self.base,self.quote];
    NSDictionary * datadict = [BTESaveDataUtil unachiverKlineDataKey:dataKey];
    if (datadict) {
        NSArray * kDataArr = [[datadict objectForKey:@"data"] objectForKey:@"kline"];
        
        [self updateHeadData:[[datadict objectForKey:@"data"] objectForKey:@"ticker"]];
        self.latesetClose = [[[[datadict objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
        
        NSMutableArray * arry = [NSMutableArray arrayWithCapacity:0];
        __block ZTYChartModel * preModel = [[ZTYChartModel alloc] init];
        
        [kDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZTYChartModel * model = [[ZTYChartModel alloc] init];
            model.x = idx;
            model.preKlineModel = preModel;
            [model initBaseDataWithDict:obj];
            [arry addObject:model];
            preModel = model;
        }];
        
        NSArray *QuotaDataArray = [ZTYDataReformator initializeQuotaDataWithArray:arry];
        [self reloadData:QuotaDataArray reload:_isrelaod];
        
    }
}

#pragma mark -- 请求数据
- (void)requestData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    self.candleChartView.isFreshing = NO;
    param[@"type"] = self.ktype;
    param[@"size"] = @"500";
    if (self.desListModel.symbol.length > 0) {
        param[@"base"] = self.desListModel.symbol;//@"btc";
        param[@"exchange"] = self.desListModel.exchange;
        param[@"quote"] = self.desListModel.quote;
    }
    
    if (self.base.length > 0 && self.exchange.length > 0 && self.quote.length > 0) {
        param[@"base"] = self.base;
        param[@"exchange"] = self.exchange;
        param[@"quote"] = self.quote;
    }
    
    if (self.end) {
        [param setObject:self.end forKey:@"end"];
    }
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    methodName = kGetKLineData;
    
    WS(weakSelf)
    
    if (!_activityView.animating) {
        //        NMShowLoadIng;
        
    }else{
        self.candleChartView.isFreshing = YES;
    }
    //
    //    NSLog(@"param======>%@",param);
    //    NMShowLoadIng;  //@"http://47.94.217.12:18081/app/api/kline/line" //
    [BTERequestTools requestWithURLString:kGetKLineData parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        [_activityView stopAnimating];
        if (IsSafeDictionary(responseObject)) {
            
            NSArray * kDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"kline"];
            if (kDataArr.count > 0) {
                
                weakSelf.end = [NSString stringWithFormat:@"%@",[[kDataArr firstObject] objectForKey:@"date"]];
                
                clockCount = 3;
                //开启定时器
                [weakSelf.timer setFireDate:[NSDate distantPast]];
                
            }
            
            [weakSelf updateHeadData:[[responseObject objectForKey:@"data"] objectForKey:@"ticker"]];
            weakSelf.latesetClose = [[[[responseObject objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
            
            NSMutableArray * arry = [NSMutableArray arrayWithCapacity:0];
            __block ZTYChartModel * preModel = [[ZTYChartModel alloc] init];
            
            [kDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZTYChartModel * model = [[ZTYChartModel alloc] init];
                model.x = idx;
                model.preKlineModel = preModel;
                [model initBaseDataWithDict:obj];
                [arry addObject:model];
                preModel = model;
            }];
            
            if (weakSelf.klineAataArray.count > 0 && arry.count > 0 ) {
                ZTYChartModel * first = [weakSelf.klineAataArray firstObject];
                ZTYChartModel * last = [arry lastObject];
                first.preKlineModel = last;
            }
            [arry addObjectsFromArray:weakSelf.klineAataArray];
            weakSelf.klineAataArray = arry.mutableCopy;
            
            //            NSArray *QuotaDataArray = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            NSArray *QuotaDataArray = [ZTYDataReformator initializeQuotaDataWithArray:weakSelf.klineAataArray];
            [weakSelf reloadData:QuotaDataArray reload:_isrelaod];
            
            
            if (weakSelf.klineAataArray.count > 0) {
                ZTYChartModel * lastModel = [weakSelf.klineAataArray lastObject];
                
                // ZYWCandleModel * firstModel = [self.dataSource lastObject];
                weakSelf.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
                // self.end = [NSString stringWithFormat:@"%ld",firstModel.timestamp];
                clockCount = 3;
                //开启定时器
                [weakSelf.timer setFireDate:[NSDate distantPast]];
                
            }
            
            if ([weakSelf.ktype isEqualToString:@"1h"] && _candleChartView.isNotComment == NO && weakSelf.isRead == NO) {
                [weakSelf getKlineComment];
            }
            
            if ([weakSelf.ktype isEqualToString:@"1h"]) {
                NSString * dataKey = [NSString stringWithFormat:@"commont-%@-%@-KEY",self.base,self.quote];
                [BTESaveDataUtil achiveKlineDataDict:responseObject key:dataKey];
            }
            
            
        }
    } failure:^(NSError *error) {
        [_activityView stopAnimating];
        //        NMRemovLoadIng;
        RequestError(error);
        //        NSLog(@"error-------->%@",error);
        
    }];
}

- (void)requestExchangeData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    //    param[@"exchange"] = @"okex";
    //    param[@"symbol"] = @"btc";
    //    param[@"pair"] = @"btc/usdt";
    if (self.desListModel.symbol.length) {
        param[@"base"] = self.desListModel.symbol;
    }
    if (self.base.length) {
        param[@"base"] = self.base;
    }
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kGetExchangeData;
    [_exchangeArray removeAllObjects];
    WS(weakSelf)
    NMShowLoadIng;  //@"http://47.94.217.12:18081/app/api/exchange/info"
    [BTERequestTools requestWithURLString:kGetExchangeData parameters:param type:1 success:^(id responseObject) {
        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            
            [dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ExchangeModel * model = [[ExchangeModel alloc] init];
                [model initwidthDict:obj];
                [weakSelf.exchangeArray addObject:model];
            }];
            //            _exchangeTableView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 264);
            if (dataArr.count < 10) {
                _exchangeTableView.height = dataArr.count * 48;
            }
            _exchangeTableView.hidden = NO;
//            [weakSelf updateBtnStatus:508 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
            [self setChangeBackBlue:YES];
            [_exchangeTableView reloadData];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)requestLastModelData{
    
    self.candleChartView.isFreshing = YES;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.ktype;
    param[@"size"] = @"5"; //
    //    param[@"client"] = @"ios";
    //    param[@"exchange"] = @"okex";
    //    param[@"symbol"] = @"btc";
    //    param[@"pair"] = @"btc/usdt";
    
    if (self.desListModel.symbol.length > 0) {
        param[@"base"] = self.desListModel.symbol;//@"btc";
    }
    
    if (self.base.length > 0) {
        param[@"base"] = self.base;//@"btc";
    }
    
    if (self.desListModel.exchange.length > 0) {
        param[@"exchange"] = self.desListModel.exchange;
    }
    if (self.exchange.length > 0) {
        param[@"exchange"] = self.exchange;
    }
    
    if (self.desListModel.quote.length > 0) {
        param[@"quote"] = self.desListModel.quote;
    }
    
    if (self.quote.length > 0) {
        param[@"quote"] = self.quote; //@"btc/usdt";
    }
    
    if (self.start) {
        param[@"start"] = self.start;
        //转为字符型
    }
    
    //    param[@"end"] = @"0";
    
    //    NSLog(@"requestLastModelData：param======>%@",param);
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    
    //    NSLog(@"requestLastModelData:param====>%@",param);
    //    NSLog(@"kGetKLineData====>%@",kGetKLineData);
    WS(weakSelf)
    //    NMRemovLoadIng;
    //    NMShowLoadIng; //@"http://47.94.217.12:18081/app/api/kline/line"
    [BTERequestTools requestWithURLString:kGetKLineData parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * kDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"kline"];
            
            //            if (kDataArr.count > 0) {
            
            [weakSelf updateHeadData:[[responseObject objectForKey:@"data"] objectForKey:@"ticker"]];
            //            NSLog(@"\n requestLastModelData====>%@",responseObject);
            
            __block ZTYChartModel * preLastModel = [weakSelf.klineAataArray lastObject];
            
            [kDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                
                if ([[obj objectForKey:@"date"] integerValue] > [preLastModel.timestamp integerValue]) {
                    ZTYChartModel * model = [[ZTYChartModel alloc] init];
                    model.x = idx;
                    model.preKlineModel = preLastModel;
                    [model initBaseDataWithDict:obj];
                    [_klineAataArray addObject:model];
                    
                    preLastModel = model;
                }else if([[obj objectForKey:@"date"] integerValue] == [preLastModel.timestamp integerValue]){
                    //                    [_dataSource removeLastObject];
                    
                    ZTYChartModel * LastModel = [weakSelf.klineAataArray lastObject];
                    //                    ZYWCandleModel * model = [[ZYWCandleModel alloc] init];
                    //                    model.x = idx;
                    //                    model.preKlineModel = LastModel;
                    [LastModel initBaseDataWithDict:obj];
                    //                    [_dataSource addObject:model];
                    
                    //                    preLastModel = model;
                    
                }else{
                    
                    
                }
                
                
            }];
            
            
            _isfreshing = YES;
            //            NSArray *QuotaDataArray = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            NSArray *QuotaDataArray = [ZTYDataReformator initializeQuotaDataWithArray:weakSelf.klineAataArray];
            [weakSelf reloadData:QuotaDataArray reload:2];
            
            
            
            weakSelf.latesetClose = [[[[responseObject objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
            //                [self.latestLinetextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:self.latesetClose]]];
            [weakSelf updateLatestTextLine];
            
            
            if (weakSelf.klineAataArray.count > 0) {
                ZTYChartModel * lastModel = [weakSelf.klineAataArray lastObject];
                
                weakSelf.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
            }
            
            //            }
            
            //            [weakSelf updateHeadData:[[responseObject objectForKey:@"data"] objectForKey:@"ticker"]];
            //            NSMutableArray * arry = [NSMutableArray arrayWithCapacity:0];
            
            
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)getKlineComment{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.desListModel.symbol.length > 0) {
        param[@"symbol"] = self.desListModel.symbol;//@"btc";
    }
    
    if (self.base.length > 0) {
        param[@"symbol"] = self.base;//@"btc";
    }
    
    if (self.klineAataArray.count > 0) {
        ZTYChartModel * first = [self.klineAataArray firstObject];
        param[@"startTime"] = first.timestamp;
        
        ZTYChartModel * last = [self.klineAataArray lastObject];
        param[@"endTime"] = last.timestamp;
        
    }
    
    WS(weakSelf)
    
    //    NSLog(@"param======>%@",param);
    //    NMShowLoadIng;  //@"@"http://47.94.217.12:18081/app/api/klineComment/getHourShortComment"" //
    [BTERequestTools requestWithURLString:kGetKlineCommentList parameters:param type:2 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            
            //            NSLog(@"responseObject====>%@",responseObject);
            NSArray * list = [responseObject objectForKey:@"data"];
            [weakSelf dealCommentData:list];
            //            if (list.count > 0) {
            //                NSMutableArray * tempArr = [NSMutableArray array];
            //                for (int index = 0; index < list.count; index ++) {
            //
            //                    NSDictionary * dict = [list objectAtIndex:(list.count - 1 - index)];
            //                    ZTYKlineComment * comment = [[ZTYKlineComment alloc] initWidthDict:dict];
            //                    [tempArr addObject:comment];
            //                }
            //
            //                //                [self.commentArr addObjectsFromArray:tempArr];
            //                _combtn.selected = YES;
            //                _combtn.hidden = NO;
            //
            //                NSArray * commentarr =  [tempArr sortedArrayUsingComparator:^NSComparisonResult(ZTYKlineComment * comment1, ZTYKlineComment * comment2) {
            //                    //                    return NSOrderedDescending;
            //                    if (comment1.klineDateTime.integerValue < comment2.klineDateTime.integerValue) {
            //                        return NSOrderedDescending;
            //                    }else{
            //                        return NSOrderedAscending;
            //                    }
            //
            //                }];
            //
            //                weakSelf.candleChartView.isNotComment = NO;
            //                weakSelf.candleChartView.commentArr = commentarr.mutableCopy;
            //                [weakSelf.candleChartView showCommentBtns];
            //            }else{
            //                _combtn.hidden = YES;
            //            }
            
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)dealCommentData:(NSArray *)list{
    if (list.count > 0) {
        for (int index = 0; index < list.count; index ++) {
            
            NSDictionary * dict = [list objectAtIndex:(list.count - 1 - index)];
            ZTYKlineComment * comment = [[ZTYKlineComment alloc] initWidthDict:dict];
            
            for (ZTYChartModel * model in _candleChartView.dataArray) {
                
                if ([comment.klineDateTime integerValue] == [model.timestamp integerValue]) {
                    model.comment = comment;
                }
                
            }
        }
//        _combtn.selected = YES;
//        _combtn.hidden = NO;
        self.candleChartView.isNotComment = NO;
        [self.candleChartView reloadAtCurrentIndex];
    }
    
    else{
//        _combtn.hidden = YES;
    }
}

// http://47.94.217.12:18081/app/api/market/optionalList
- (void)getSelfSelectList{
    
    _optionArray = nil;
    //    NSLog(@"delSelfSelect:User.userToken=====>%@",User.userToken);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"token"];
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    WS(weakSelf)
    [BTERequestTools requestWithURLString:kGetOptionalList parameters:param type:3 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            
            
            
            _optionArray =[NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"result"]];
            //            NSLog(@"responseObject====>%@",responseObject);
            
            [weakSelf performSelectorOnMainThread:@selector(dealOptionData) withObject:nil waitUntilDone:NO];
            
            
            
        }
    } failure:^(NSError *error) {
        RequestError(error);
    }];
}

- (void)dealOptionData{
    
    WS(weakSelf)
    __block BOOL isNotInAllSelected = NO;
    [_optionArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict objectForKey:@"base"] isEqualToString:self.base] && [[dict objectForKey:@"exchange"] isEqualToString:self.exchange] && [[dict objectForKey:@"quote"] isEqualToString:self.quote] ) {
            isNotInAllSelected = YES;
            *stop = YES;
            
        }
    }];
    
    UIButton * btn = [weakSelf.headView viewWithTag:509];
    btn.selected = isNotInAllSelected;
}

- (void)addSelfSelect{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    
    if (!User.isLogin) {
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            
        }];
        return;
    }
    
    if (self.desListModel) {
        param[@"base"] = self.desListModel.symbol;//@"btc";
        param[@"exchange"] = self.desListModel.exchange;
        param[@"quote"] = self.desListModel.quote;
    }
    
    if (self.base.length > 0 && self.exchange.length > 0 && self.quote.length > 0) {
        param[@"base"] = self.base;//@"btc";
        param[@"quote"] = self.quote; //@"btc/usdt";
        param[@"exchange"] = self.exchange;
    }
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    NSLog(@"User.userToken=====>%@",User.userToken);
    WS(weakSelf)
    
    //    exchange=okex&base=BTC&quote=USDT
    // http://47.94.217.12:18081/app/api/market/addOptional?exchange=okex&base=BTC&quote=USDT
    [BTERequestTools requestWithURLString:kGetAddOptional parameters:param type:3 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            
            
            if ([[responseObject objectForKey:@"code"] integerValue] == -1) {
                [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                    
                }];
            }else{
                UIButton * btn = [weakSelf.headView viewWithTag:509];
                btn.selected = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRefreshTradeList object:nil];
                
                [BHToast showMessage:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
                
                
                
                [weakSelf getSelfSelectList];
                
                
                
            }
            
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error====>%@",error);
    }];
    
}

- (void)delSelfSelect{
    
    NSLog(@"delSelfSelect:User.userToken=====>%@",User.userToken);
    if (!User.isLogin) {
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            
        }];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
        
    }
    
    if (self.base.length > 0 && self.exchange.length > 0 && self.quote.length > 0) {
        param[@"base"] = self.base;//@"btc";
        param[@"quote"] = self.quote; //@"btc/usdt";
        param[@"exchange"] = self.exchange;
    }
    
    WS(weakSelf)
    // http://47.94.217.12:18081/app/api/market/deleteOptional?id=12
    [BTERequestTools requestWithURLString:kGetDeleteOptional parameters:param type:3 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            
            
            if ([[responseObject objectForKey:@"code"] integerValue] == -1) {
                [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                    
                }];
            }else{
                UIButton * btn =[weakSelf.headView viewWithTag:509];
                btn.selected = NO; NSLog(@"responseObject====>%@",responseObject);
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRefreshTradeList object:nil];
                [BHToast showMessage:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
                
            }
            
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

// 大单成交
- (void)requestAbnormity{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    
    if (self.base.length) {
        param[@"base"] = self.base;
    }
    
    NSString * methodName = kGetKlinehugeDealUrl;
    [_bottomDict removeAllObjects];
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * dataDcit = [responseObject objectForKey:@"data"];
            [_bottomDict removeAllObjects];
            UITableView * tableview = [weakSelf.rootScrollView viewWithTag:401];
            [tableview reloadData];
            
            NSArray * rankList = [dataDcit objectForKey:@"rankList"];
            NSArray * hugeList = [dataDcit objectForKey:@"hugeList"];
            
            NSInteger maxCount = 0;
            // bidAmount 买  askAmount 卖
            for (NSDictionary * subDict in rankList) {
                NSInteger sellCount = [[subDict objectForKey:@"askAmount"] integerValue];
                NSInteger buyCount = [[subDict objectForKey:@"bidAmount"] integerValue];
                if (sellCount > maxCount ) {
                    maxCount = sellCount;
                }
                if (buyCount > maxCount ) {
                    maxCount = buyCount;
                }
            }
            [_bottomDict setObject:@(maxCount) forKey:hugeDealMaxKey];
            [_bottomDict setObject:dataDcit forKey:AbnormityKey];
            
            
            CGFloat tableheight = [BTEBigOrderTableViewCell cellHeight] * hugeList.count + [BigOrderTradeTableViewCell cellHeight] * rankList.count + 106 + 50 - 12;
            //            CGFloat tableheight = [BTEBigOrderTableViewCell cellHeight] * dataArr.count + [BigOrderTradeTableViewCell cellHeight] * 0 + 106;
            [weakSelf updateTableScrollviewPosition:tableheight tag:1];
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

// 超级深度
- (void)requestDeepth{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    
    if (self.base.length) {
        param[@"base"] = self.base;
    }
    
    NSString * methodName = kGetKlineTradeDepthUrl;
    [_bottomDict removeAllObjects];
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * dataDict = [responseObject objectForKey:@"data"];
            [_bottomDict removeAllObjects];
            
            NSArray * dataArr = [dataDict objectForKey:@"depth"];
            //            [_dataTableView reloadData];
            UITableView * tableview = [weakSelf.rootScrollView viewWithTag:400];
            [tableview reloadData];
            if (dataArr.count > 0) {
            
                NSInteger maxValue = 0;
                
                
                for (NSDictionary * dict in dataArr) {
                    
                    NSInteger count = [[dict objectForKey:@"count"] integerValue];
                    if (maxValue < count) {
                        maxValue = count;
                    }
                }
                
                
                [_bottomDict setObject:@(maxValue) forKey:@"maxkey"];
                
                [_bottomDict setObject:@(maxValue) forKey:@"nagetiveMaxKey"];
                [_bottomDict setObject:dataArr forKey:DepthKey];
                
                [_bottomDict setObject:[dataDict objectForKey:@"remark"] forKey:DepthRemarkKey];
                CGFloat tableheight = [BTEOrderDeepTableViewCell cellHeight] * dataArr.count + 42;
                [weakSelf updateTableScrollviewPosition:tableheight tag:0];
            
            }
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

// 大单爆仓
- (void)requestBurned{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    
    if (self.base.length) {
        param[@"base"] = self.base;
    }
    
    if (self.quote.length) {
        param[@"quote"] = self.quote;
    }
    
    if (self.exchange.length) {
        param[@"exchange"] = self.exchange;
    }
    param[@"base"] = @"BTC";
    param[@"exchange"] = @"okex";
    param[@"quote"] = @"QUARTER";
    //    if (self.start.length) {
    //        param[@"start"] = self.start;
    //    }
    //
    //    if (User.userToken) {
    //        [param setObject:User.userToken forKey:@"bte-token"];
    //    }
    [_bottomDict removeAllObjects];
    NSString * methodName = kGetBurnedUrl;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            
            
            [_bottomDict removeAllObjects];
            //            [_dataTableView reloadData];
            UITableView * tableview = [weakSelf.rootScrollView viewWithTag:402];
            [tableview reloadData];
            
            [_bottomDict setObject:dataArr forKey:BurnedKey];
            
            CGFloat tableheight = [BTEBigOrderTableViewCell cellHeight] * dataArr.count;
            [weakSelf updateTableScrollviewPosition:tableheight tag:2];
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)updateTableScrollviewPosition:(CGFloat)height tag:(NSUInteger)tag{
    
    
    
    if (_bottomType == BottomTypeChatView) {
        if (height <= KlineTopViewHeight) {
            height = KlineTopViewHeight;
        }
        _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight , SCREEN_WIDTH, height);
        _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight + height + bottomHeight );
    }else{
        if (height <= KlineTopViewHeight - tableFootAndHeadHeight) {
            height = KlineTopViewHeight - tableFootAndHeadHeight;
        }
        
        UITableView * tableview = [_itemScrollView viewWithTag:400 + tag];
        tableview.frame = CGRectMake(tag * SCREEN_WIDTH, 0, SCREEN_WIDTH, height+tableFootAndHeadHeight);
        _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight, SCREEN_WIDTH, height + tableFootAndHeadHeight);
        
        _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight  + bottomHeight + height + tableFootAndHeadHeight);
        tableview.backgroundColor = [UIColor whiteColor];
        [tableview reloadData];
    }
    
}

#pragma mark -- 头部数据更新
- (void)updateHeadData:(NSDictionary *)dict{
    
    UILabel * onedayLabel = [_headView viewWithTag:710];
    NSString * onedaytext = [NSString stringWithFormat:@"24h量/额：%@/%@",[self caculateValue:[[dict objectForKey:@"vol"] doubleValue]],[NSString stringWithFormat:@"%@元",[self caculateValue:[[dict objectForKey:@"amountVol"] doubleValue]]]];
    //    [onedayLabel setTitle:@"24h量/额：" value:onedaytext];
    onedayLabel.text = onedaytext;
    
    NSString * priceStr = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculateBesideLing:[[dict objectForKey:@"price"] doubleValue]]];
    
    UILabel *pricelabel = [_headView viewWithTag:712];
    pricelabel.text = priceStr;
    
    CGFloat width = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:30]}].width ;
    pricelabel.frame = CGRectMake(16, 16, width, 30);
    
    UILabel *verbPriceLabel = [_headView viewWithTag:718];
    verbPriceLabel.text = [NSString stringWithFormat:@"≈%.2lfCNY",[[dict objectForKey:@"cnyPrice"] doubleValue]];
    
    UILabel *cnylabel = [_headView viewWithTag:711];
    
    NSString * changestr = @"";
    
    UIColor * changeColor = DropColor;
    if ([[dict objectForKey:@"change"] floatValue] < 0) {
        changestr = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"change"] floatValue] * 100];
        changeColor = [UIColor colorWithHexString:@"FF4040"];
        
    }else{
        changestr = [NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"change"] floatValue] * 100];
        changeColor = RoseColor;
    }
    pricelabel.textColor = changeColor;
    NSString * cnyStr = [NSString stringWithFormat:@"%@%%",changestr];
    NSMutableAttributedString * cnyatt = [[NSMutableAttributedString alloc] initWithString:cnyStr];
    NSRange range = [cnyStr rangeOfString:[NSString stringWithFormat:@"%@%%",changestr]];
    //    [cnyatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff4040"] range:range];
    
    [cnyatt addAttribute:NSForegroundColorAttributeName value:changeColor range:range];
    cnylabel.attributedText = cnyatt;
    
    CGFloat cynwidth = [cnyStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]}].width + 20;
    cnylabel.frame = CGRectMake(16 + width + 8, 16 + 18, cynwidth, 12);
    
    UILabel * exchangeLabel = [_headView viewWithTag:719];
    exchangeLabel.frame = CGRectMake(5 + width + cynwidth, 16, 101, 10);
    UIButton * changeBtn = [_headView viewWithTag:508];
    changeBtn.frame = CGRectMake(5 +width + cynwidth, 26, 101, 28);
    
    self.exchangeX = 5 +width + cynwidth;
    //    [self updateBtnStatus:508 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    
    double airValue = [[dict objectForKey:@"airIndex"] doubleValue];
    UILabel *airLabel = [_headView viewWithTag:717];
    airLabel.text = [NSString stringWithFormat:@"%.2f",airValue];
    
    
    ZTYArrowLine *arrowRightLine = [_headView viewWithTag:715];
    CGFloat ydistance = 52 - airValue * 52 / 100.0;
    CGFloat xdistance = 5 * ydistance / 52.0;
    arrowRightLine.frame = CGRectMake(SCREEN_WIDTH - 16 + xdistance - 12, 23 + ydistance - 3, 12, 6);
    
    self.title = [NSString stringWithFormat:@"%@/%@(%@)",self.base,self.quote,priceStr];
}

- (NSString *)caculateValue:(double)value{
    if (value > 100000000) {
        return [NSString stringWithFormat:@"%.2lf亿",(value / 100000000.0)];
    }else if (value > 10000){
        return [NSString stringWithFormat:@"%.2lf万",(value / 10000.0)];
    }else{
        return [NSString stringWithFormat:@"%.2lf",value];
    }
}

#pragma mark 添加视图

- (void)addActivityView
{
    _activityView = [UIActivityIndicatorView new];
    [self.kLineBGView addSubview:_activityView];
    _activityView.hidesWhenStopped = YES;
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(5));
        make.centerY.equalTo(self.kLineBGView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)addScrollView
{
    _scrollView = [UIScrollView new];
    [self.kLineBGView addSubview:_scrollView];
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
//    _scrollView.alpha = 0.5;
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kLineBGView).offset(headerHeight);
        make.left.equalTo(self.kLineBGView);
        make.right.equalTo(self.kLineBGView).offset(-57);
        make.height.equalTo(@(self.ChartHeight));
    }];
}

- (void)addCandleChartView
{
    _candleChartView = [ZTYMainView new];
    [_scrollView addSubview:_candleChartView];
    _candleChartView.mainquotaName = MainViewQuotaNameWithMA;
    _candleChartView.mainchartType = MainChartcenterViewTypeKline;
    _candleChartView.firstCommentShow = YES;
    _candleChartView.delegate = self;
    _currentZoom = -.001f;
    [_candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.height.equalTo(@((self.ChartHeight)*CandleScale));
        make.top.equalTo(_scrollView);
    }];
    
    _candleChartView.candleSpace = 2;
    _candleChartView.displayCount = CandleCount;
    _displayCount = _candleChartView.displayCount;
    _candleChartView.lineWidth = 1*widthradio;
    UITapGestureRecognizer * candleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(candleClick:)];
    [_candleChartView addGestureRecognizer:candleTap];
    
    CGFloat percandlePriceHeight = (self.ChartHeight * CandleScale) / 6.0;
    self.distrabuteView = [[ZTYTradeDistrabuteView alloc] initWithFrame:CGRectMake(0, percandlePriceHeight, SCREEN_WIDTH - 57, percandlePriceHeight * 4) showCount:50];
//    self.distrabuteView.hidden = YES;
    [self.candleChartView addSubview:self.distrabuteView];
    
    UIButton *fullBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, headerHeight + self.ChartHeight * CandleScale - 30, 30, 30)];
    [fullBtn setImage:[UIImage imageNamed:@"kfull_screen"] forState:UIControlStateNormal];
    [fullBtn addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    fullBtn.tag = 444;
    [self.kLineBGView addSubview:fullBtn];
    
    
}

- (void)addTopBoxView
{
    _topBoxView = [UIView new];
    [self.kLineBGView addSubview:_topBoxView];
    _topBoxView.userInteractionEnabled = NO;
    _topBoxView.layer.borderWidth = 0;
    _topBoxView.layer.borderColor = [UIColor blackColor].CGColor;
    [_topBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(lineBgWidth);
        make.left.equalTo(_scrollView.mas_left).offset(-lineBgWidth);
        make.right.equalTo(_scrollView.mas_right).offset(lineBgWidth);
        make.height.equalTo(@(self.ChartHeight));
    }];
}

- (void)addVolumView
{
    _volumeView = [[ZTYVolumView alloc] init];;
    [_scrollView addSubview:_volumeView];
    _volumeView.delegate = self;
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_candleChartView.mas_bottom);
        make.left.right.equalTo(_scrollView);
        make.height.equalTo(@((self.ChartHeight)*VolumeScale));
    }];
    UITapGestureRecognizer * volumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(volumTap:)];
    [_volumeView addGestureRecognizer:volumTap];
    _volumeView.candleSpace = 2;
    _volumeView.displayCount = 50;
    _volumeView.lineWidth = BoxborderWidth; //1 *widthradio;
}

- (void)addPriceView
{
    CGFloat percandlePriceHeight = (self.ChartHeight * CandleScale) / 6.0;
    _candlePrice = [ZYWPriceView new];
    [self.kLineBGView addSubview:_candlePrice];
    [_candlePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBoxView).offset(percandlePriceHeight - 5);
        make.height.equalTo(@(percandlePriceHeight * 4 + 10));
        make.right.equalTo(self.kLineBGView).offset(8);
        make.left.equalTo(_topBoxView.mas_right).offset(9);
    }];
    
    _volumePrice = [ZYWPriceView new];
    [self.kLineBGView addSubview:_volumePrice];
    [_volumePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBoxView).offset(self.ChartHeight * CandleScale);
        make.height.equalTo(@(self.ChartHeight * VolumeScale));
        make.right.equalTo(self.kLineBGView).offset(8);
        make.left.equalTo(_topBoxView.mas_right).offset(9);
    }];
    
    _quotaPrice = [ZYWPriceView new];
    [self.kLineBGView addSubview:_quotaPrice];
    [_quotaPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBoxView).offset(self.ChartHeight * (CandleScale + VolumeScale) + 5);
        make.height.equalTo(@(self.ChartHeight * QuotaScale - 12));
        make.right.equalTo(self.kLineBGView).offset(8);
        make.left.equalTo(_topBoxView.mas_right).offset(9);
    }];
    
    
    ZTYNounLine * rightLine = [[ZTYNounLine alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 57, headerHeight, 9, self.ChartHeight)];
    rightLine.lineWidth = 1;
    rightLine.strokeColor = LineBGColor;//[UIColor lightGrayColor];
    [rightLine setNounlinewidthNouns:@[@(percandlePriceHeight),@(percandlePriceHeight * 2),@(percandlePriceHeight * 3),@(percandlePriceHeight * 4),@(percandlePriceHeight * 5),@(self.ChartHeight * (CandleScale + VolumeScale) + 7 + 5),@(self.ChartHeight * (CandleScale + VolumeScale) + (self.ChartHeight * QuotaScale - 12) * 0.5 + 5),@(self.ChartHeight -12)]];
    [self.kLineBGView addSubview:rightLine];
    
}

- (void)addSubViews
{
    //    [self addQuotaView];
    [self addKLineBGView];
    [self addHeaderView];
    [self addScrollView];
    
    
    [self addCandleChartView];
    
//    [self createDistrabuteView];
    [self addTopBoxView];
    [self addVolumView];
    [self addQuotaBorderView];
    [self addGestureToCandleView];
}

- (void)addKLineBGView{
    
    self.kLineBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT)];
    [self.rootScrollView addSubview:self.kLineBGView];
    
    
}

#pragma mark 添加手势

- (void)addGestureToCandleView
{
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    [self.candleChartView addGestureRecognizer:longPressGesture];
    
    UIPinchGestureRecognizer *  pinchPressGesture= [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchesView:)];
    [self.scrollView addGestureRecognizer:pinchPressGesture];
    
}

- (void)quotaClick:(UITapGestureRecognizer *)tapgesture{
    
    if ([self judgeLineHideOrShow]) {
        CGPoint location = [tapgesture locationInView:self.quotaChartView];
        CGPoint newLocation = [self.quotaChartView getTapModelPostionWithPostion:location];
        CGFloat xPositoin = newLocation.x + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f ;
        CGPoint point = CGPointMake(xPositoin, newLocation.y);
        [self updateCrossline:point linetextTop:(self.ChartHeight * (CandleScale + VolumeScale))];
    }
    
}

- (void)volumTap:(UITapGestureRecognizer *)tapgesture{
    
    if ([self judgeLineHideOrShow]) {
        CGPoint location = [tapgesture locationInView:self.volumeView];
        
        CGPoint newLocation = [self.volumeView getTapModelPostionWithPostion:location];
        CGFloat xPositoin = newLocation.x + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f ;
        CGPoint point = CGPointMake(xPositoin, newLocation.y);
        
        [self updateCrossline:point linetextTop:(self.ChartHeight * CandleScale)];
    }
}

- (void)candleClick:(UITapGestureRecognizer *)tapgesture{
    
    [_candleChartView hideDialogs];
    
    if ([self judgeLineHideOrShow]) {
        CGPoint location = [tapgesture locationInView:self.candleChartView];
        CGPoint newLocation = [self.candleChartView getTapModelPostionWithPostion:location];
        CGFloat xPositoin = newLocation.x + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f ;
        CGPoint point = CGPointMake(xPositoin, newLocation.y);
        
        [self updateCrossline:point linetextTop:0];
    }else{
        CGPoint location = [tapgesture locationInView:self.candleChartView];
        [self.candleChartView getTapModelPostionWithPostion:location];
    }
}

- (void)updateCrossline:(CGPoint)location linetextTop:(CGFloat)top{
    
    [self hiddenAllChoseBGView];
    
    CGFloat xPositoin = location.x; // + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f
    CGFloat yPositoin = location.y; //+ self.candleChartView.topMargin
    [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(xPositoin));
    }];
    [self.verticalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(xPositoin - 50));
    }];
    
    //    [self.lineTextView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(yPositoin - 10 + headerHeight + top);
    //    }];
    
    self.verticalView.hidden = NO;
    //    self.lineTextView.hidden = NO;
    self.verticalLabel.hidden = NO;
}

- (BOOL)judgeLineHideOrShow{
    
    if (self.verticalView.hidden || self.verticalLabel.hidden) {
        return YES;
    }else{
        self.verticalView.hidden = YES;
        //        self.lineTextView.hidden = YES;
        self.verticalLabel.hidden = YES;
        return NO;
    }
}

#pragma mark 指标视图

- (void)addBottomViews
{
    _quotaChartView = [ZTYQuoteChartView new];
    [_scrollView addSubview:_quotaChartView];
    _quotaChartView.delegate = self;
    _quotaChartView.lineWidth = 1*widthradio;
    _quotaChartView.quotaName = FigureViewQuotaNameWithMACD;
    [_quotaChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(_scrollView);
        make.top.equalTo(_volumeView.mas_bottom);
        make.height.equalTo(@(self.ChartHeight * QuotaScale));
        make.left.right.equalTo(_volumeView);
    }];
    
    UITapGestureRecognizer * quotaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quotaClick:)];
    [_quotaChartView addGestureRecognizer:quotaTap];
    
}

#pragma mark 十字线

- (void)initCrossLine
{
    
    self.verticalView = [UIView new];
    self.verticalView.clipsToBounds = YES;
    [self.scrollView addSubview:self.verticalView];
    self.verticalView.backgroundColor = LineBGColor;
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_candleChartView);
        make.width.equalTo(@(0.5));
        make.bottom.equalTo(_quotaChartView);
        make.left.equalTo(@(0));
    }];
    
    self.verticalLabel = [[UILabel alloc]init];
    self.verticalLabel.layer.borderColor = LineBGColor.CGColor;//[UIColor blackColor].CGColor;
    self.verticalLabel.layer.borderWidth = 0.5;
    self.verticalLabel.backgroundColor = [UIColor whiteColor];
    self.verticalLabel.textAlignment = NSTextAlignmentCenter;
    self.verticalLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.verticalLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    [self.scrollView addSubview:self.verticalLabel];
    
    [self.verticalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight - 12));
        make.width.equalTo(@(100));
        make.height.equalTo(@(12));
        make.left.equalTo(@(0));
    }];
    
    self.latestLinetextView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, -SCREEN_HEIGHT, SCREEN_WIDTH - 5, 15)];
    [self.kLineBGView addSubview:self.latestLinetextView];
    
    //    self.lineTextView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 5, 20)];
    //    [self.lineTextView setBackGroudImage:@"textLineLatest"];
    //    [self.lineTextView setTextColor:[UIColor blackColor]];
    //    [self.kLineBGView addSubview:self.lineTextView];
    //
    //    self.lineTextView.hidden = YES;
    self.verticalView.hidden = YES;
    self.verticalLabel.hidden = YES;
}

#pragma mark 长按手势
- (void)longGesture:(UILongPressGestureRecognizer*)longPress
{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self.candleChartView];
        if(ABS(oldPositionX - location.x) < (self.candleChartView.candleWidth + self.candleChartView.candleSpace)/2)
        {
            return;
        }
        
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        
        CGPoint point = [self.candleChartView getLongPressModelPostionWithXPostion:location.x];
        CGFloat xPositoin = point.x + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f ;
        CGFloat yPositoin = point.y + self.candleChartView.topMargin;
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin));
        }];
        
        [self.verticalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin - 50));
        }];
        
        
        //        [self.lineTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(yPositoin - 10 + headerHeight);
        //        }];
        
        
        self.verticalView.hidden = NO;
        
        //        self.leavView.hidden = NO;
        //        self.verPriceLabel.hidden = NO;
        //        self.lineTextView.hidden = NO;
        
        self.verticalLabel.hidden = NO;
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        if(self.verticalView)
        {
            self.verticalView.hidden = YES;
            
        }
        if (self.verticalLabel) {
            self.verticalLabel.hidden = YES;
        }
        
        //        if(self.lineTextView)
        //        {
        //            self.lineTextView.hidden = YES;
        //
        //        }
        
        oldPositionX = 0;
        self.scrollView.scrollEnabled = YES;
    }
}

#pragma mark 缩放手势

- (void)pinchesView:(UIPinchGestureRecognizer *)pinchTap
{
    if (pinchTap.state == UIGestureRecognizerStateEnded)
    {
        _currentZoom = pinchTap.scale;
        self.scrollView.scrollEnabled = YES;
    }
    
    else if (pinchTap.state == UIGestureRecognizerStateBegan && _currentZoom != 0.0f)
    {
        self.scrollView.scrollEnabled = NO;
        pinchTap.scale = _currentZoom;
        
        ZTYCandlePosionModel *model = self.candleChartView.currentDisplayArray.lastObject;
        _zoomRightIndex = model.localIndex+1;
    }
    
    else if (pinchTap.state == UIGestureRecognizerStateChanged)
    {
        CGFloat tmpZoom = 0.f;
        if (isnan(_currentZoom))
        {
            return;
        }
        tmpZoom = (pinchTap.scale)/ _currentZoom;
        _currentZoom = pinchTap.scale;
        NSInteger showNum = round(_displayCount / tmpZoom);
        
        if (showNum == _displayCount)
        {
            return;
        }
        
        if (showNum >= _displayCount && _displayCount == MaxCount) return;
        if (showNum <= _displayCount && _displayCount == MinCount) return;
        
        _displayCount = showNum;
        _displayCount = _displayCount < MinCount ? MinCount : _displayCount;
        _displayCount = _displayCount > MaxCount ? MaxCount : _displayCount;
        
        _candleChartView.displayCount = _displayCount;
        [_candleChartView calcuteCandleWidth];
        [_candleChartView updateWidthWithNoOffset];
        [_candleChartView drawKLine];
        CGFloat offsetX = fabs(_zoomRightIndex* (self.candleChartView.candleSpace + self.candleChartView.candleWidth) - self.scrollView.width + self.candleChartView.leftMargin) ;
        if (offsetX <= self.scrollView.frame.size.width)
        {
            offsetX = 0;
        }
        
        if (offsetX > self.scrollView.contentSize.width - self.scrollView.frame.size.width)
        {
            offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
        }
        
        self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    }
}

- (void)reloadData:(NSArray *)array reload:(int)reload
{
    _quotaChartView.dataArray = array.mutableCopy;
    _volumeView.dataArray = array.mutableCopy;
    self.candleChartView.dataArray = array.mutableCopy;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reload == 1)
            {
                [self.candleChartView reload];
                
            }else if (reload == 2){
                
                [self.candleChartView reloadAtCurrentIndex];
            }
            else
            {
                [self.candleChartView stockFill];
                
            }
        });
    });
}

#pragma mark -- 附图代理
/**
 点按手势获得当前k线下标以及模型
 
 @param kLineModeIndex 当前k线在可视范围数组的位置下标
 @param kLineModel   k线模型
 */
- (void)tapCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)index price:(CGFloat)price{
    [self updateDeslAndRosedrop:kLineModel];
    [self upddateQuotaViewModel:kLineModel];
    [self upddateChartViewModel:kLineModel];
    self.verticalLabel.text = [NSString stringWithFormat:@"%@",kLineModel.timeStr];
    //    [_lineTextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:price]]];
    
}

#pragma mark -- 主图代理
- (void)displayLastModel:(ZTYChartModel *)kLineModel
{
    [self updateLatestTextLine];
    
    if (_isfreshing) {
        
    }else{
        [self updateDeslAndRosedrop:kLineModel];
        [self upddateChartViewModel:kLineModel];
        [self upddateQuotaViewModel:kLineModel];
    }
    
}

- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)startIndex
{
    
    _verticalLabel.text = [NSString stringWithFormat:@"%@",kLineModel.timeStr];
    //    [_lineTextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:kLineModel.close]]];
    [self updateDeslAndRosedrop:kLineModel];
    [self upddateChartViewModel:kLineModel];
    [self upddateQuotaViewModel:kLineModel];
}


- (void)updateBtnStatus:(NSInteger)tag title:(NSString *)title imageHide:(BOOL) isHidden hideBackColor:(UIColor *)backColor{
    
    UIButton * button = [_headView viewWithTag:tag];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
        //    CGSize titleSize = btn.titleLabel.bounds.size;
        CGSize imageSize = button.imageView.bounds.size;
        button.imageEdgeInsets = UIEdgeInsetsMake(14,width, 9, -width);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 4, 0, imageSize.width + 4);
        //        button.backgroundColor = [UIColor whiteColor];
        //        [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    }else{
        if (isHidden) {
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            button.backgroundColor = backColor;//[UIColor colorWithHexString:@"308cdd"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
            CGFloat width = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
            //    CGSize titleSize = btn.titleLabel.bounds.size;
            CGSize imageSize = button.imageView.bounds.size;
            button.imageEdgeInsets = UIEdgeInsetsMake(14,width, 9, -width);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 4, 0, imageSize.width + 4);
        }
    }
    ZTYLeftLabel * exchangeLabel = [_headView viewWithTag:719];

    if (tag == 508) {
        
        if (isHidden) {
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
            CGFloat width = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
            //    CGSize titleSize = btn.titleLabel.bounds.size;
            CGSize imageSize = button.imageView.bounds.size;
            button.imageEdgeInsets = UIEdgeInsetsMake(14,width, 9, -width);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 4, 0, imageSize.width + 4);
        }
        CGFloat width = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
        exchangeLabel.backgroundColor = backColor;
        if (self.exchangeTableView.hidden) {
            CGSize imageSize = button.imageView.bounds.size;
            CGFloat left = 4;//(button.frame.size.width - width - imageSize.width - 4) * 0.5;
            //            if (left <= 0) {
            //                left = 0;
            //            }
            exchangeLabel.leftDistance = left;
            exchangeLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        }else{
            CGFloat left = (button.frame.size.width - width) * 0.5;
            exchangeLabel.leftDistance = left;
            exchangeLabel.textColor = [UIColor whiteColor];
        }
    }
    _scrollView.scrollEnabled = YES;
    
}

- (void)updateDeslAndRosedrop:(ZTYChartModel *)kLineModel{
    
    NSString * descText = [NSString stringWithFormat:@"%@ 开：%@ 高：%@ 低：%@ 收：%@",kLineModel.timeString,[ZTYCalCuteNumber calculateBesideLing:kLineModel.open],[ZTYCalCuteNumber calculateBesideLing:kLineModel.high],[ZTYCalCuteNumber calculateBesideLing:kLineModel.low],[ZTYCalCuteNumber calculateBesideLing:kLineModel.close]];
    NSArray * descTitles = @[@"开：",@"高：",@"低：",@"收："];
    [_descLabel setText:descText titles:descTitles date:kLineModel.timeString];
    
    
    CGFloat dr = roundf(((kLineModel.close - kLineModel.preKlineModel.close) / kLineModel.preKlineModel.close )* 100000.0 + 0.5) / 1000.0;
    CGFloat dx = roundf((kLineModel.high / kLineModel.low - 1.0) * 100000.0 + 0.5)/1000.0;
    NSString * roseDropStr = [NSString stringWithFormat:@"涨幅：%.2f%% 振幅：%.2f%%",dr,dx];
    if (dr > 0) {
        roseDropStr = [NSString stringWithFormat:@"涨幅：+%.2f%% 振幅：%.2f%%",dr,dx];
    }
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:roseDropStr];
    if (dr < 0) {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF4040"] range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"%.2f%%",dr]]];
    }else{
        [att addAttribute:NSForegroundColorAttributeName value:RoseColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"+%.2f%%",dr]]];
    }
    
    _roseDropLabel.attributedText = att;
}


- (void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count
{
    [self showIndexLineView:leftPostion startIndex:index count:count];
    
}


- (void)showIndexLineView:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count
{
    
    _volumeView.candleSpace = _candleChartView.candleSpace;
    _volumeView.candleWidth = _candleChartView.candleWidth;
    _volumeView.leftPostion = leftPostion;
    _volumeView.startIndex = index;
    _volumeView.displayCount = count;
    [_volumeView stockFill];
    
    CGFloat maxValue = _candleChartView.maxY;
    CGFloat minValue = _candleChartView.minY;
    if (ABS(maxValue)  > 10|| ABS(minValue) > 10) {
        _candlePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",maxValue];
        _candlePrice.maxMiddlePriceLabel.text = [NSString stringWithFormat:@"%.2f",((maxValue - minValue) * 0.75 + minValue)];
        _candlePrice.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",((maxValue - minValue)* 0.5 + minValue)];
        _candlePrice.minMiddlePriceLabel.text = [NSString stringWithFormat:@"%.2f",((maxValue - minValue)* 0.25 + minValue)];
        _candlePrice.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",minValue];
    }else{
        _candlePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:maxValue]];
        _candlePrice.maxMiddlePriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:((maxValue - minValue) * 0.75 + minValue)]];
        _candlePrice.middlePriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:((maxValue - minValue)* 0.5 + minValue)]];
        _candlePrice.minMiddlePriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:((maxValue - minValue)* 0.25 + minValue)]];
        _candlePrice.minPriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:minValue]];
    }
    
    _quotaChartView.candleSpace = _candleChartView.candleSpace;
    _quotaChartView.candleWidth = _candleChartView.candleWidth;
    _quotaChartView.leftPostion = leftPostion;
    _quotaChartView.startIndex = index;
    _quotaChartView.displayCount = count;
    [_quotaChartView stockFill];
    
    
    if (ABS(self.quotaChartView.maxY)  > 10|| ABS(self.quotaChartView.minY) > 10) {
        _quotaPrice.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.quotaChartView.maxY];
        _quotaPrice.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",(self.quotaChartView.maxY - self.quotaChartView.minY)/2 + self.quotaChartView.minY];
        _quotaPrice.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.quotaChartView.minY];
    }else{
        _quotaPrice.maxPriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:self.quotaChartView.maxY]];
        _quotaPrice.middlePriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:(self.quotaChartView.maxY - self.quotaChartView.minY)/2 + self.quotaChartView.minY]];
        _quotaPrice.minPriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:self.quotaChartView.minY]];
    }
    _volumePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumeView.maxY/1000.0];
    _volumePrice.minPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumeView.minY/1000.0];
    
    [self.distrabuteView showDistrabute:self.candleChartView.currentDisplayArray max:maxValue min:minValue left:leftPostion];
}

/**
 加载更多数据
 */
- (void)displayMoreData{
    //    [self hideMore];
    NSLog(@"正在加载更多....");
    [_activityView startAnimating];
    //    WS(weakSelf)
    __weak typeof(self) this = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [this loadMoreData];
    });
}

- (void)loadMoreData
{
    
    NSLog(@"请求中....");
    _isrelaod = 1;
    [self requestData];
}


#pragma mark -- 切换交易所
- (UITableView *)exchangeTableView{
    if (!_exchangeTableView) {
        _exchangeTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 117 - 100, 26 + 28 + 0.5, 101, 48 * 10) style:UITableViewStylePlain];
        _exchangeTableView.delegate = self;
        _exchangeTableView.dataSource = self;
        _exchangeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _exchangeTableView.rowHeight = 48;
        _exchangeTableView.bounces = NO;
        _exchangeTableView.hidden = YES;
        _exchangeTableView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        _exchangeTableView.tableFooterView = [UIView new];
    }
    return _exchangeTableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.exchangeTableView) {
        ExchangeModel * model = [_exchangeArray objectAtIndex:indexPath.row];
        
        self.exchange = model.exchange;
        self.base = model.baseAsset;
        
        self.quote = model.quoteAsset;
        self.end = nil;
        
        [self resetData];
        _exchangeTableView.hidden = YES;
        UILabel * exchangeLabel = [_headView viewWithTag:719];
        exchangeLabel.text = model.exchange;
        
        UIButton * exchangebtn = [_headView viewWithTag:508];
        [exchangebtn setTitle:[NSString stringWithFormat:@"%@/%@",model.baseAsset,model.quoteAsset] forState:UIControlStateNormal];
        [self setChangeBackBlue:NO];
        [self requestData];
    }
    
}

- (void)resetData{
    self.end = nil;
    self.start = nil;
    _isrelaod = 0;
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    //    [self.commentArr removeAllObjects];
    _candleChartView.firstCommentShow = YES;
    _candleChartView.commentArr = @[].copy;
    [_klineAataArray removeAllObjects];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 401) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.exchangeTableView) {
        return self.exchangeArray.count;
    }else{
        NSArray * arr;
        if (_bottomType == BottomTypeOrderChange) {
            
            NSDictionary * dataDict = [_bottomDict objectForKey:AbnormityKey];
            if (section == 0) {
                
                if (dataDict) {
                    return [[dataDict objectForKey:@"rankList"] count];
                }else{
                    return 0;
                }
            }else{
                if (dataDict) {
                    return [[dataDict objectForKey:@"hugeList"] count];
                }else{
                    return 0;
                }
                
            }
        }else if (_bottomType == BottomTypeSuperDeep){
            arr = [_bottomDict objectForKey:DepthKey];
        }else if (_bottomType == BottomTypeOrderBreak){
            arr = [_bottomDict objectForKey:BurnedKey];
        }else{
            arr = @[];
        }
        return arr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.exchangeTableView == tableView) {
        ExchangeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"exchange"];
        if (!cell) {
            cell =[[ExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"exchange"];
        }
        ExchangeModel * model = [self.exchangeArray objectAtIndex:indexPath.row];
        if (self.base == model.baseAsset && self.quote == model.quoteAsset && self.exchange == model.exchange) {
            cell.backgroundColor = [UIColor colorWithHexString:@"5cacf3" alpha:1];
        }else{
            cell.backgroundColor = [UIColor colorWithHexString:@"308cdd" alpha:1];
        }
        [cell configCommonKlinewidthModel:model];
        return cell;
    }else{
        if (_bottomType == BottomTypeOrderChange) {
            NSDictionary * dataDict = [_bottomDict objectForKey:AbnormityKey];
            if (indexPath.section == 0) {
                BigOrderTradeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AbnormityKey];
                if (!cell) {
                    cell = [[BigOrderTradeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AbnormityKey];
                }
                NSArray * rankList = [dataDict objectForKey:@"rankList"];
                NSInteger count = [[_bottomDict objectForKey:hugeDealMaxKey] integerValue];
                BOOL isLast = NO;
                if (rankList.count == indexPath.row) {
                    isLast = YES;
                }
                [cell configWithDict:rankList[indexPath.row] maxCount:count isLast:isLast];
                return cell;
            }else if (indexPath.section == 1){
                BTEBigOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AbnormityKey];
                if (!cell) {
                    cell = [[BTEBigOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AbnormityKey];
                }
                NSArray * hugeList = [dataDict objectForKey:@"hugeList"];
                
                [cell configHanlistWithDict:hugeList[indexPath.row]];
                return cell;
            }else{
                return [UITableViewCell new];
            }
        }else if (_bottomType == BottomTypeSuperDeep){
            BTEOrderDeepTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DepthKey];
            if (!cell) {
                cell = [[BTEOrderDeepTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DepthKey];
            }
            NSArray * arr = [_bottomDict objectForKey:DepthKey];
            
            [cell configDict:arr[indexPath.row] maxMindict:_bottomDict];
            return cell;
        }else{
            BTEBigOrderTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:BurnedKey];
            if (!cell) {
                cell = [[BTEBigOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BurnedKey];
            }
            NSArray * arr = [_bottomDict objectForKey:BurnedKey];
            [cell configWithDict:arr[indexPath.row] isBurnedOrder:YES base:self.base];
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_exchangeTableView == tableView) {
        return 48;
    }else{
        if (_bottomType == BottomTypeSuperDeep) {
            return [BTEOrderDeepTableViewCell cellHeight];
        }else if(_bottomType == BottomTypeOrderChange){
            if (indexPath.section == 0) {
                
                NSDictionary * dataDict = [_bottomDict objectForKey:AbnormityKey];
                NSArray * rankList = [dataDict objectForKey:@"rankList"];
                if (indexPath.row == rankList.count - 1) {
                    return 16;
                }else{
                    return [BigOrderTradeTableViewCell cellHeight];
                }
            }else if(indexPath.section == 1){
                return [BTEBigOrderTableViewCell cellHeight];
            }else{
                return 0;
            }
        }else{
            return [BTEBigOrderTableViewCell cellHeight];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _exchangeTableView) {
        return 0;
    }else{
        
        if (_bottomType == BottomTypeOrderChange) {
            if (section == 0) {
                return 106;
            }else{
                return 40;
            }
        }else{
            return 40;
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _exchangeTableView) {
        return [UIView new];
    }else{
        
        if (_bottomType == BottomTypeOrderChange) {
            
            if (section == 0) {
                
                NSDictionary * dataDict = [_bottomDict objectForKey:AbnormityKey];
                
                UIView * headBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 106)];
                headBGView.backgroundColor = [UIColor whiteColor];
                
                NSString * sellPrice = [FormatUtil formatCount:[[dataDict objectForKey:@"hugeAsk"] doubleValue]];
                NSString * sellStr = [NSString stringWithFormat:@"近7日大单卖出：$%@",sellPrice];
                UILabel * sellLabel = [self createLabelTitle:sellStr frame:CGRectMake(16, 22, SCREEN_WIDTH * 0.5 - 16, 12)];
                [headBGView addSubview:sellLabel];
                
                NSMutableAttributedString * sellAttrat = [[NSMutableAttributedString alloc] initWithString:sellStr];
                ;
                NSRange sellRange = [sellStr rangeOfString:[NSString stringWithFormat:@"$%@",sellPrice]];
                [sellAttrat addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF4040"] range: sellRange];
                sellLabel.attributedText = sellAttrat;
                
                NSString * buyPrice = [FormatUtil formatCount:[[dataDict objectForKey:@"hugeBid"] doubleValue]];
                NSString * buyStr = [NSString stringWithFormat:@"近7日大单买入：$%@",buyPrice];
                NSMutableAttributedString * buyAttrat = [[NSMutableAttributedString alloc] initWithString:buyStr];
                ;
                NSRange buyRange = [buyStr rangeOfString:[NSString stringWithFormat:@"$%@",buyPrice]];
                [buyAttrat addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"228B22"] range: buyRange];
                UILabel * buyLabel = [self createLabelTitle:buyStr frame:CGRectMake(SCREEN_WIDTH * 0.5, 22, SCREEN_WIDTH * 0.5 - 16, 12)];
                buyLabel.attributedText = buyAttrat;
                buyLabel.textAlignment = NSTextAlignmentRight;
                [headBGView addSubview:buyLabel];
                
                UIView * buyView = [[UIView alloc] initWithFrame:CGRectMake(16, 44, SCREEN_WIDTH - 32, 6)];
                buyView.layer.cornerRadius = 3;
                buyView.layer.masksToBounds = YES;
                buyView.backgroundColor = [UIColor colorWithHexString:@"228B22"];
                [headBGView addSubview:buyView];
                
                double buycount = [[dataDict objectForKey:@"hugeBid"] doubleValue];
                double sellcount = [[dataDict objectForKey:@"hugeAsk"] doubleValue];
                
                CGFloat sellwidth = (SCREEN_WIDTH - 32) * sellcount / (buycount * 1.0 + sellcount * 1.0);
                if (dataDict == nil) {
                    sellwidth = 0;
                }
                UIView * sellView = [[UIView alloc] initWithFrame:CGRectMake(16, 44, sellwidth, 6)];
                sellView.layer.cornerRadius = 3;
                sellView.layer.masksToBounds = YES;
                sellView.backgroundColor = [UIColor colorWithHexString:@"FF4040"];
                [headBGView addSubview:sellView];
                
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 65.5, SCREEN_WIDTH - 32, 0.5)];
                lineView.backgroundColor = KBGColor;
                [headBGView addSubview:lineView];
                
                BTEOrderHeadView * headview = [[BTEOrderHeadView alloc] initWithFrame:CGRectMake(0, 66, SCREEN_WIDTH, 40)];
                NSArray * titles = @[@"金额($)",@"大单卖出",@"价格($)",@"大单买入",@"金额($)"];
                [headview setTitlesCenter:titles];
                UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = LineBGColor;
                [headview addSubview:line];
                [headBGView addSubview:headview];
                
                return headBGView;
            }else{
                
                BTEOrderHeadView * headview = [[BTEOrderHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
                NSArray * titles = @[@"时间",@"交易所",@"类型",@"价格",@"金额($)"];
                [headview setTitlesCenter:titles];
                UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = LineBGColor;
                [headview addSubview:line];
                
                return headview;
            }
        }else if (_bottomType == BottomTypeSuperDeep){
            UIView *percentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            percentView.backgroundColor = [UIColor whiteColor];
            NSArray * percentTitles = @[@"挂单数量",@"价格",@"挂单数量"];
            NSUInteger index = 0;
            CGFloat labelW = (SCREEN_WIDTH - 16) / 3.0;
            for (NSString * title in percentTitles) {
                
                CGRect frame = CGRectMake( 8 + labelW * index , 0, labelW, 40);
                UILabel * label = [self createLabelTitle:title frame:frame];
                label.textColor = [UIColor colorWithHexString:@"525866" alpha:0.6];
                label.backgroundColor = [UIColor whiteColor];
                label.tag = 60 + index;
                if (index == 0) {
                    label.textAlignment = NSTextAlignmentLeft;
                }else if (index == 1) {
                    label.textAlignment = NSTextAlignmentCenter;
                }if (index == 2) {
                    label.textAlignment = NSTextAlignmentRight;
                }
                label.frame = frame;
                [percentView addSubview:label];
                index ++;
            }
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = LineBGColor;
            [percentView addSubview:line];
            return percentView;
            
        }else{
            BTEOrderHeadView * headview = [[BTEOrderHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            NSArray * titles = @[@"时间",@"方向",@"价格",@"数量",@"成交状态"];
            [headview setTitles:titles];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = LineBGColor;
            [headview addSubview:line];
            return headview;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == 401) {
        if (section == 0) {
            return 50;
        }else{
            return 0;
        }
    }else if (tableView.tag == 400) {
        return 42;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView.tag == 401) {
        if (section == 0) {
            
            UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            footView.backgroundColor = [UIColor whiteColor];
            
            NSDictionary * dataDict = [_bottomDict objectForKey:AbnormityKey];
            NSString * remark = [dataDict objectForKey:@"remark"];
            UILabel * label = [self createLabelTitle:remark frame:CGRectMake(25, 4, SCREEN_WIDTH - 50, 36)];
            label.numberOfLines = 0;
            label.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
            [footView addSubview:label];
            
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = LineBGColor;
            [footView addSubview:line];
            
            return footView;
        }else{
            
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
    }else if(tableView.tag == 400){
        UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
        footView.backgroundColor = [UIColor whiteColor];
        
        NSString * remark = [_bottomDict objectForKey:DepthRemarkKey];
        UILabel * label = [self createLabelTitle:remark frame:CGRectMake(16, 0, SCREEN_WIDTH - 32, 42)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
        //        label.numberOfLines = 0;
        [footView addSubview:label];
        return footView;
    }else{
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
}

#pragma mark -- ScrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _itemScrollView) {
        NSLog(@"减速结束 %f",(long)scrollView.contentOffset.x/scrollView.bounds.size.width);
        NSInteger count = (long)scrollView.contentOffset.x/scrollView.bounds.size.width;
        UIButton * button = [self.bottomView viewWithTag:900 + count];
        if (!self.floatBottomView.hidden) {
            button = [self.floatBottomView viewWithTag:900 + count];
        }
        
        if ([self judgeIsBigCoin]) {
            [self itemTabelChoose:button];
        }else{
            [self samllitemTabelChoose:button];
        }
        
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _rootScrollView){
        [self judgeFloatBottomItemHidenStatus:scrollView.contentOffset.y];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _rootScrollView) {
        [self judgeFloatBottomItemHidenStatus:scrollView.contentOffset.y];
    }
}

- (void)judgeFloatBottomItemHidenStatus:(CGFloat)y{
    if (y >= (self.ChartHeight + headerHeight + 8)) {
        self.floatBottomView.hidden = NO;
        if (self.bottomType != BottomTypeChatView) {
            self.topImageView.hidden = NO;
        }
    }else{
        self.floatBottomView.hidden = YES;
        self.topImageView.hidden = YES;
    }
}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if (scrollView == _rootScrollView){
//        [self judgeFloatBottomItemHidenStatus:scrollView.contentOffset.y];
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == _rootScrollView) {
//        [self judgeFloatBottomItemHidenStatus:scrollView.contentOffset.y];
//    }
//}
//
//- (void)judgeFloatBottomItemHidenStatus:(CGFloat)y{
//    if (y > (self.ChartHeight + headerHeight + 8)) {
//        self.floatBottomView.hidden = NO;
//    }else{
//        self.floatBottomView.hidden = YES;
//    }
//}

#pragma mark -- 初始化
- (UILabel *)createLabelTitle:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    return label;
}

- (UIButton *)createBtn:(NSString *)title frame:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = frame;
    //    [btn setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [btn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    return btn;
}

- (UIButton *)createBtnTiltle:(NSString *)title frame:(CGRect)frame{
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    btn.titleLabel.font =  font;
    [btn setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
    
    //    btn.titleLabel.backgroundColor = [UIColor yellowColor];
    //    btn.imageView.backgroundColor = [UIColor greenColor];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
    //    CGSize titleSize = btn.titleLabel.bounds.size;
    CGSize imageSize = btn.imageView.bounds.size;
    btn.imageEdgeInsets = UIEdgeInsetsMake(14,width, 9, -width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 4, 0, imageSize.width + 4);
    return btn;
}

- (UIButton *)createImageBtn:(CGRect)frame img:(NSString *)imgName title:(NSString *)title titleW:(CGFloat)titleW{
    UIButton *imgBtn = [[UIButton alloc] init];
    [imgBtn setTitle:title forState:UIControlStateNormal];
    [imgBtn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:imgName] forState:UIWindowLevelNormal];
    imgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    imgBtn.frame = frame;
    imgBtn.showsTouchWhenHighlighted = YES;
    imgBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    // 重点位置开始
    imgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, titleW + 7.8, 0, -titleW - 7.8);
    imgBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -8.5, 0, 8.5);
    // 重点位置结束
    imgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [imgBtn addTarget:self action:@selector(clickFullScreen) forControlEvents:UIControlEventTouchUpInside];
    return imgBtn;
}

- (UIButton *)createImgTitleBtn:(NSString *)tilte imgName:(NSString *)imgName frame:(CGRect)frame{
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = frame;
    [button setTitle:tilte forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"636F97"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.frame.size.width * 0.5+14, 0,0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, button.imageView.bounds.size.width - 5, 0,0)];
    return button;
}

- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"kshare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (void)shareAlert
{
    
    [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:kGetcontractDogUrl sharetitle:nil shareDesc:nil shareType:UMS_SHARE_TYPE_IMAGE captionImg:[ZTYScreenshot screenshotImage] currentVc:self];
    
    
}

#pragma mark -- 聊天
-(void)gotoChatGroup{
    self.assistiveBtn.userInteractionEnabled = NO;
    if (User.userToken) {
        NSLog(@"userToken----->%@",User.userToken);
        // true 表示已经注册过环信 false 表示没有注册过环信
        if (loginUserFlag) {
            BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
            if (!isAutoLogin) {
                NSLog(@"isAutoLogin---false----->%d",isAutoLogin);
                WS(weakSelf)
                [[EMClient sharedClient] loginWithUsername:User.hxuserName password:User.hxuserPassword completion:^(NSString *aUsername, EMError *aError) {
                    if (!aError) {
                        [weakSelf setUnreadMessageCountByChatRoomId];
                        [weakSelf gotoChatRoomBottomWith:weakSelf.chatRoomId];
                    }else{
                        NSLog(@"---loginWithUsername--password---aerror--->%@",aError.errorDescription);
                    }
                }];
            }else{
                [self setUnreadMessageCountByChatRoomId];
                NSLog(@"isAutoLogin---true----->%d",isAutoLogin);
                [self gotoChatRoomBottomWith:self.chatRoomId];
            }
        }else{
             [self gotoChatRoomBottomWith:self.chatRoomId];
//            WS(weakSelf)
//            AddNickHeaderView *v = [[AddNickHeaderView alloc] initAddNickHeadView];
//            v.roomName = self.desListModel.symbol;
//            [v setConfirmCallBack:^(BOOL isComplete, NSString *chatRoomId) {
//                if (isComplete) {
//                    NSLog(@"isComplete----chatRoomId---->%@",chatRoomId);
//                    weakSelf.chatRoomId = chatRoomId;
////                    [weakSelf setUnreadMessageCountByChatRoomId];
//                    [weakSelf gotoChatRoomBottomWith:chatRoomId];
//                    loginUserFlag = 1;
//                }else{
//                    [weakSelf recoverOriginStatus];
//                }
//            }];
            
        }
        self.assistiveBtn.userInteractionEnabled = YES;
    }else{
        WS(weakSelf)
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            if (isComplete) {
                [weakSelf getUserInfo];
            }else{
                [weakSelf recoverOriginStatus];
            }
        }];
        self.assistiveBtn.userInteractionEnabled = YES;
        return;
    }
}

- (void)recoverOriginStatus{
    NSInteger tag = 900;
    if (_tempbottomType == BottomTypeOrderChange) {
        tag = 901;
    }else if (_tempbottomType == BottomTypeSuperDeep){
        tag = 900;
    }else if (_tempbottomType == BottomTypeFoundFlow){
        tag = 902;
    }else if (_tempbottomType == BottomTypeDesc){
        tag = 903;
    }
    UIButton * btn = [self.bottomView viewWithTag:tag];
    [self itemTabelChoose:btn];
}

-(void)gotoChatRoomBottomWith:(NSString *)chatRoomStr{
    
    _itemScrollView.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeight , SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
    _rootScrollView.contentOffset = CGPointMake(0, self.ChartHeight + headerHeight + 8);
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:chatRoomStr conversationType:EMConversationTypeGroupChat];
    
    chatController.base = self.base;
    chatController.quote = self.quote;
    chatController.exchange = self.exchange;
    
    chatController.view.frame = CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
    
    chatController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.itemScrollView addSubview:chatController.view];
    
    [self addChildViewController:chatController];
    chatController.chatdelegate = self;
    
    self.assistiveBtn.userInteractionEnabled = YES;
    
    self.topImageView.hidden = YES;
    _chatVC = chatController;
}

#pragma 回滚到顶部
- (void)gotoSuperViewTop {
    UIButton * button = [self.bottomView viewWithTag:900];
    [self itemTabelChoose:button];
    [self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)dealloc{
    NSLog(@"普通K线dealloc");
}

#pragma mark Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 获取user信息
- (void)getUserInfo{
    //接口调用
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        [pramaDic setObject:User.userToken forKey:@"token"];
    }
    
    methodName = kGetUserInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        NSLog(@"getUserInfo---->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (data) {
                
                telStr = [data objectForKey:@"tel"];
                nickNameStr = stringFormat([data objectForKey:@"name"]);
                
                emailStr = stringFormat([data objectForKey:@"email"]);
                
                headPicStr = stringFormat([data objectForKey:@"avator"]);
                
                if (![headPicStr isEqualToString:@""]) {
                }else{
                    headPicStr= @"https://file.bte.top/common/avatar/1.png";
                }
                if (![nickNameStr isEqualToString:@""]) {
                    if ([telStr isEqualToString:nickNameStr]) {
                        nickNameStr = [NSString stringWithFormat:@"%@****%@",[nickNameStr substringToIndex:4],[nickNameStr substringFromIndex:7]];
                    }else{
                        if ([nickNameStr isValidateEmail]) {
                            NSArray *emailArray = [emailStr componentsSeparatedByString:@"@"];
                            if (emailArray != nil && emailArray.count >0 ) {
                                NSInteger length = [emailArray[0] length];
                                NSString *emailStr = [NSString stringWithFormat:@"%@****%@",[emailArray[0] substringToIndex:1],
                                                      [nickNameStr substringFromIndex:length - 1]];
                                nickNameStr = emailStr;
                            }
                        }
                    }
                }else{
                    NSArray *emailArray = [emailStr componentsSeparatedByString:@"@"];
                    if (emailArray != nil && emailArray.count >0 ) {
                        NSInteger length = [emailArray[0] length];
                        NSString *emailStr = [NSString stringWithFormat:@"%@****%@@%@",[emailArray[0] substringToIndex:1],
                                              [nickNameStr substringFromIndex:length - 1],emailArray[1]];
                        nickNameStr = emailStr;
                    }
                }
                [weakSelf getWhetherRegisterHX];
            }
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}
@end

