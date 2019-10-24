//
//  BTEKlineContractViewController.m
//  BTE
//
//  Created by wanmeizty on 2018/7/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEKlineContractViewController.h"
#import "ZTYChartModel.h"
#import "ZYWCalcuteTool.h"
#import "ZYWPriceView.h"
#import "ZYWCandlePostionModel.h"
#import "ZTYCommonChartView.h"
#import "BTEFullScreenKlineViewController.h"
//#import "ZXQuotaDataReformer.h"
#import "ZTYDataReformator.h"
//#import "ZTYMainChartView.h"
#import "ZTYContractChartView.h"
#import "ZTYQuoteChartView.h"
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
#import "UserCacheManager.h"
#import "BTEQuoteSetViewController.h"

#import "BTEKlineChatViewController.h"

#import "BTEOrderHeadView.h"

#import "BTELoginVC.h"

#import "ZTYBigOrderModel.h"
#import "ZTYOrderDeepModel.h"
#import "BTEBigOrderTableViewCell.h"
#import "BTEOrderDeepTableViewCell.h"
#import "ZTYArrowLine.h"
#import "UIImage+ImageEffects.h"
#import "SecondaryLevelWebViewController.h"
//#import "SecondLevelWebViewController.h"
#import "ZTYScreenshot.h"
#import "ZTYFoundHeader.h"
#import "ChatViewController.h"
#import "AddNickHeaderView.h"
#import "JSBadgeView.h"
#import "SuspendImgV.h"

//#import "BTEDistributionModel.h"
//#import "ZTYDistrabuteView.h"
//#import "BTECalculateDistrabutionValue.h"
#import "ZTYTradeDistrabuteView.h"
#import "BTESaveDataUtil.h"
#import "BTEWalletTableViewCell.h"

//#import "MNAssistiveBtn.h"
#import "ContractInroduceVC.h"
#define ScrollScale 1.00
#define CandleScale 0.55
#define VolumeScale 0.18
#define QuotaScale 0.27


#define HeadTopHeight 118
#define headerHeight (HeadTopHeight + 22)
//#define headerHeightAndBroad (headerHeight + 32)
#define bottomHeigth 50

#define contractBtnWidth 55
#define contractBtnInterval 5

// key
#define BurnedKey @"Burned"
#define DepthKey @"depth"
#define AbnormityKey @"abnormity"
#define WalletKey @"wallet"

#define foundHeight 456
#define tableFootAndHeadHeight 40

#define KlineTopViewHeight (SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 42)

@interface BTEKlineContractViewController ()
<UITableViewDelegate,UITableViewDataSource,ChatDelegate,ZTYChartProtocol,UIScrollViewDelegate>{
    BOOL loginUserFlag;
    NSString *headPicStr;
    NSString *telStr;
    NSString *nickNameStr;
    NSString *emailStr;
}
@property (nonatomic,strong) UIView * kLineBGView;
@property (strong,nonatomic) ZTYTradeDistrabuteView * distrabuteView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) ZTYContractChartView *candleChartView;
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
@property (nonatomic,strong) UIView * ktypeBGView,*mainQuotaTypeBGView,*fitureQuotaBGView,*strengthBgView,*orderBurnedBgView,*setBgView;
@property (nonatomic,strong) UILabel * descLabel,*roseDropLabel,*mainTextLabel,*volumTextLabel,*fitureTextLabel,*swingLabel;

@property (nonatomic,strong) UILabel * verticalLabel;
@property (nonatomic,strong) UIView *verticalView;
@property (nonatomic,strong) UIView *leavView;
//@property (nonatomic,strong) ZTYLineTextView * lineTextView;
@property (nonatomic,strong) ZTYLineTextView * latestlineView;


@property (nonatomic,strong) ZTYChartModel * latestModel;
@property (nonatomic,assign) CGFloat latesetClose;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray * KLineDataArray;
@property (nonatomic,copy) NSString * ktype;
@property (nonatomic,copy) NSString * end;
@property (nonatomic,copy) NSString * exchange;
@property (nonatomic,copy) NSString * base;
@property (nonatomic,copy) NSString * quote;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * start;
@property (nonatomic,assign) CGFloat ChartHeight;
@property (nonatomic,assign) int isrelaod; // 加载更多刷新

@property (nonatomic,strong) NSArray * klineTypes;


@property (nonatomic,strong) UITableView * exchangeTableView;
@property (nonatomic,strong) NSMutableArray * exchangeArray;

@property (nonatomic,strong) NSTimer * timer;

//@property (nonatomic,strong) UITableView * dataTableView;
@property (nonatomic,strong) UIScrollView * rootScrollView;


@property (nonatomic,strong) UIView * bottomView;
@property (strong,nonatomic) UIView * floatBottomView; // 浮动显示的头
//@property (nonatomic,strong) BTEOrderHeadView * orderHeadView;
@property (nonatomic,assign) BottomType bottomType;

//@property (nonatomic,strong) UIView * percentView;
@property (nonatomic,strong) UIView * foundflowView;

@property (nonatomic,strong) NSMutableDictionary * bottomDict;

@property (nonatomic,strong) UIImageView * loginBGView;

@property (nonatomic,strong) UIView * volumeTypeView;

@property (nonatomic,strong) UILabel * orderCountLabel;
@property (nonatomic,assign) NSInteger point;

@property (nonatomic,assign) BOOL isLogining;
@property (nonatomic,assign) BOOL isfreshing;
@property (strong,nonatomic) ZTYCommonChartView * candle;
@property (strong,nonatomic) ZYWPriceView * price;
@property (strong,nonatomic) UIScrollView * itemScrollview;

@property (strong, nonatomic) EMConversation *conversation;
@property (nonatomic,strong) NSString *chatRoomId;
@property (nonatomic,strong)JSBadgeView *badgeView;
@property (nonatomic,strong)UIImageView *hiddenImageView;

@property (nonatomic,strong)SuspendImgV *assistiveBtn;
@property (nonatomic,copy) NSString * chatOnLineNumStr;//聊天在线人数
@property (nonatomic,strong)UILabel *chatOnLineNumStrLabel;

@property (assign,nonatomic) BottomType tempbottomType;

@property (strong,nonatomic) UIButton * topImageView;

@property (strong,nonatomic) ChatViewController * chatVC;

@end

@implementation BTEKlineContractViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavitems];
    [self initdata];
    
    [self addRootTableView];
    
    [self addSubViews];
    [self addBottomViews];
    [self addPriceView];
    [self addChartTitle];
    [self addActivityView];
    [self addBottomItem];
    [self initCrossLine];
    [self addLoginView];
    [self addArrowUp];
    [self.kLineBGView addSubview:self.exchangeTableView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startClock) userInfo:nil repeats:YES];
    //  关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    
//    [self setFloatBtn];
    
    [self getLocalData];
    
}

- (void)getLocalData{
    
    NSString * dataKey = [NSString stringWithFormat:@"contract-KEY"];
    
    NSDictionary * datadict = [BTESaveDataUtil unachiverKlineDataKey:dataKey];
    if (datadict != nil) {
        
        
        [self updateAfterGetKlineData:datadict];
        
        NSArray * kDataArr = [[datadict objectForKey:@"data"] objectForKey:@"kline"];
        
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
        
        
        
        NSArray *quotaDataArray = [ZTYDataReformator initializeQuotaDataWithArray:arry];
        
        [self reloadData:quotaDataArray reload:_isrelaod];
        
        
    }
}

- (void)addArrowUp{
    self.topImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topImageView.frame = CGRectMake(SCREEN_WIDTH-SCALE_W(28)-SCALE_W(10), SCREEN_HEIGHT - 200 - HOME_INDICATOR_HEIGHT, SCALE_W(28), SCALE_W(28));
    [self.topImageView setImage:[UIImage imageNamed:@"返回k线"] forState:UIControlStateNormal];
    [self.topImageView  addTarget:self action:@selector(gotoTop) forControlEvents:UIControlEventTouchUpInside];
    self.topImageView.hidden = YES;
    [self.view addSubview:self.topImageView];
}

- (void)createNavitems{
    self.navigationItem.title  = @"合约狗";
    UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(disback)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItem = [self creatRightBarItem];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initdata{
    self.base = self.desListModel.symbol;
    self.quote = self.desListModel.quote;
    self.exchange = self.desListModel.exchange;
    _isrelaod = 0;
    _bottomType = BottomTypeOrderChange;
    self.ktype = @"1h";
    self.name = @"BTC/季度合约";
    self.ChartHeight = (SCREEN_HEIGHT - headerHeight - NAVIGATION_HEIGHT -  bottomHeigth - HOME_INDICATOR_HEIGHT);
    _exchangeArray = [NSMutableArray array];
    _bottomDict = [NSMutableDictionary dictionary];
    self.dataSource = [NSMutableArray array];
}

- (void)disback{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        if (self.bottomType == BottomTypeChatView) {
            self.bottomType = BottomTypeOrderChange;
            UIButton * button = [self.bottomView viewWithTag:900];
            [self itemTabelChose:button];
            [self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        
        if (self.bottomType == BottomTypeChatView) {
            self.bottomType = BottomTypeOrderChange;
            UIButton * button = [self.bottomView viewWithTag:900];
            [self itemTabelChose:button];
            [self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark -- 刷新倒计时
static int clockCount = 3;
static int KclockCount = 1;
- (void)startClock{
    
    clockCount --;
    
    if (clockCount <= -1) {
        
        [self requestLastModelData];
        
        clockCount = 3;
    }
    KclockCount --;
    if (KclockCount <= -1) {
        
        if (self.bottomType == BottomTypeOrderChange) {
            
            [self requestAbnormity];
        }else if (self.bottomType == BottomTypeSuperDeep){
            [self requestDeepth];
        }else if (self.bottomType == BottomTypeOrderBreak){
            [self requestBurned];
        }
        KclockCount = 1;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestGoal];
    [self judgeTimerIsinit];
    [self judgeLoginStatus];
   
    [self getContractList];

//    if(User.userToken){
//        [self getUserInfo];
//    }

    [self getUserInfo];

    [self GetRoomInfo];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)judgeTimerIsinit{
    if (!self.timer) {
        clockCount = 3;
        KclockCount = 1;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startClock) userInfo:nil repeats:YES];
        //开启定时器
        [self.timer setFireDate:[NSDate distantFuture]];
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)judgeLoginStatus{
    if (self.isLogining) {
        [self goAlertView];
    }else{
        self.loginBGView.hidden = User.isFutureDogUser;
        self.rootScrollView.scrollEnabled = User.isFutureDogUser;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)openCon{

    ContractInroduceVC * introduceVC = [[ContractInroduceVC alloc] init];
    [self.navigationController pushViewController:introduceVC animated:YES];
//    [self openCloserequest:@"1"];
//    if (self.bottomType != BottomTypeOrderNone) {
//        UITableView * tableview = [self.itemScrollview viewWithTag:400 + self.bottomType];
//        [tableview reloadData];
//    }
}

- (void)closeCon{
    [self openCloserequest:@"0"];
    if (self.bottomType != BottomTypeOrderNone) {
        UITableView * tableview = [self.itemScrollview viewWithTag:400 +self.bottomType];
        [tableview reloadData];
    }
}

#pragma mark -- 当前K线数据指标值显示
- (void)addChartTitle{
    
    _mainTextLabel = [self createLabelTitle:@"" frame:CGRectMake(10, headerHeight + 2, 240, 10)];
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
    
    UILabel * riseDropLabel = [self createLabelTitle:@"涨幅:0.27%  振幅:0.44%" frame:CGRectMake(10, headerHeight + 12, SCREEN_WIDTH - 20, 10)];
    riseDropLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:riseDropLabel.text];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[riseDropLabel.text rangeOfString:@"+0.27%"]];
    riseDropLabel.attributedText = att;
    //    riseDropLabel.numberOfLines = 2;
    _roseDropLabel = riseDropLabel;
    
    [self.kLineBGView addSubview:riseDropLabel];
    
    //    UILabel * swingLabel = [self createLabelTitle:@"振幅:0.44%" frame:CGRectMake(250, headerHeightAndBroad + 12, SCREEN_WIDTH - 250, 10)];
    //    swingLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    //    _swingLabel = swingLabel;
    //    [self.kLineBGView addSubview:swingLabel];
    
    
    _orderCountLabel = [self createLabelTitle:@"" frame:CGRectMake(10, headerHeight + 14, SCREEN_WIDTH - 20, 10)];
    _orderCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.kLineBGView addSubview:_orderCountLabel];
    
}

// 主指标与成交量
- (void)upddateChartViewModel:(ZTYChartModel *)model{
    
    if (_volumeView.showbuySell == 3) {
        //        if (model.buyCount > model.sellCount) {
        //            _volumTextLabel.text = [NSString stringWithFormat:@"净买量: %@",[self caculateValue:(model.buyCount - model.sellCount)]];
        //        }else{
        //            _volumTextLabel.text = [NSString stringWithFormat:@"净卖量:%@",[self caculateValue:(model.sellCount - model.buyCount)]];
        //        }
        //        NSString * title = [NSString stringWithFormat:@"托单强度:%@  压单强度:%@",[self caculateValue:model.supportCount],[self caculateValue:model.resistanceCount]];
        
        NSString * burnedstr = @"";
        UIColor * burnedColor = [UIColor colorWithHexString:@"29AC4E" alpha:0.8];
        if (model.buyburnedCount > 0) {
            // buyburned
            burnedstr = [NSString stringWithFormat:@"空单爆仓:%@ ",[self caculateValue:model.buyburnedCount]];
//            burnedstr = [NSString stringWithFormat:@"空单爆仓:%@张($%.2f) ",[self caculateValue:model.buyburnedCount],model.buyburned];
            // 红：CC1414
            // 绿：29AC4E
            burnedColor = [UIColor colorWithHexString:@"29AC4E" alpha:0.8];
        }
        
        
        if (model.sellburnedCount > 0) {
            // sellburned
            burnedstr = [NSString stringWithFormat:@"多单爆仓:%@ ",[self caculateValue:model.sellburnedCount]];
//            burnedstr = [NSString stringWithFormat:@"多单爆仓:%@张($%.2f) ",[self caculateValue:model.sellburnedCount],model.sellburned];
            burnedColor = [UIColor colorWithHexString:@"CC1414" alpha:0.8];
        }
        
        NSString * bigOrder = @"";
        UIColor * bigOrderColor = [UIColor colorWithHexString:@"29AC4E" alpha:0.8];
        if (model.bigbuyCount > 0) {
            // buyburned
            bigOrder = [NSString stringWithFormat:@"大单买入:%@ ",[self caculateValue:model.bigbuyCount]];
            // 红：CC1414
            // 绿：29AC4E
            bigOrderColor = [UIColor colorWithHexString:@"29AC4E" alpha:0.8];
        }
        
        if (model.bigsellCount > 0) {
            // buyburned
            bigOrder = [NSString stringWithFormat:@"大单卖出:%@ ",[self caculateValue:model.bigsellCount]];
            // 红：CC1414
            // 绿：29AC4E
            bigOrderColor = [UIColor colorWithHexString:@"CC1414" alpha:0.8];
        }
        
        NSString * supportStr = @"";
        if (model.supportCount - model.cancelbuyCount != 0) {
            supportStr = [NSString stringWithFormat:@"托单:%@ ",[self caculateValue:model.supportCount - model.cancelbuyCount]];
        }
        
        NSString * restanceStr = @"";
        if (model.resistanceCount - model.cancelsellCount != 0) {
            restanceStr = [NSString stringWithFormat:@"压单:%@ ",[self caculateValue:model.resistanceCount - model.cancelsellCount]];
        }
        
        if (model.resistanceCount <=0 && model.supportCount <= 0 && model.buyburnedCount <= 0 && model.sellburnedCount <= 0) {
            _volumTextLabel.hidden = YES;
        }else{
            _volumTextLabel.hidden = NO;
        }
        
        NSString * title = [NSString stringWithFormat:@"%@%@%@%@",supportStr,restanceStr,bigOrder,burnedstr];
        
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"29AC4E" alpha:0.8] range:[title rangeOfString:supportStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CC1414" alpha:0.8] range:[title rangeOfString:restanceStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:burnedColor range:[title rangeOfString:burnedstr]];
        [attr addAttribute:NSForegroundColorAttributeName value:bigOrderColor range:[title rangeOfString:bigOrder]];
        _volumTextLabel.attributedText = attr;
        
        // 红：CC1414
        // 绿：29AC4E
    }else{
        _volumTextLabel.text = [NSString stringWithFormat:@"量:%@",[self caculateValue:model.volumn.integerValue]];
    }
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
    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithSTRANCE){
        
        //        _mainTextLabel.hidden = NO;
        NSString * restanceStr = @"";
        if (model.sellCumulativeAmount5 > 0) {
            restanceStr = [NSString stringWithFormat:@"压力线:%.2f  ",model.sellPrice5];
        }
        
        NSString * supprotStr = @"";
        if (model.buyCumulativeAmount5 > 0) {
            supprotStr = [NSString stringWithFormat:@"支撑线:%.2f",model.buyPrice5];
        }
        
        if (model.sellCumulativeAmount5 <= 0 && model.buyCumulativeAmount5 <= 0) {
            _mainTextLabel.hidden = YES;
        }else{
            _mainTextLabel.hidden = NO;
        }
        //        NSString * title = [NSString stringWithFormat:@"压力线:%.2f 支撑线:%.2f",model.sellPrice5,model.buyPrice5];
        NSString * title = [NSString stringWithFormat:@"%@%@",restanceStr,supprotStr];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CC1414" alpha:0.8] range:[title rangeOfString:restanceStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"29AC4E" alpha:0.8] range:[title rangeOfString:supprotStr]];
        _mainTextLabel.attributedText = attr;
        // 压力线：FFB400
        // 支撑线：30D2B3
        
        // 红：CC1414
        // 绿：29AC4E
        
    }
    
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

- (void)updateLatestTextLine{
    //    if (self.latesetClose) {
    [self.latestlineView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:self.latesetClose]]];
    CGFloat pointY = [_candleChartView getPointYculateValue:self.latesetClose];
    if (pointY < 0 ) {
        pointY = 15;
    }
    
    if ( pointY > self.ChartHeight * CandleScale) {
        pointY = self.ChartHeight * CandleScale;
    }
    [self.latestlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pointY - 7.5 + headerHeight);
    }];
    //    }
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
    pricelabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:30];
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
    
    
    ZTYLeftLabel *exchangeLabel = [[ZTYLeftLabel alloc] init];
    exchangeLabel.frame = CGRectMake(SCREEN_WIDTH - 107, 16, 91, 10);
    exchangeLabel.text = [NSString stringWithFormat:@"%@",self.desListModel.exchange];
    exchangeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    exchangeLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    exchangeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    exchangeLabel.tag = 719;
    [_headView addSubview:exchangeLabel];
    
    
    UIButton * changeBtn = [self createBtnTiltle:[NSString stringWithFormat:@"%@/%@",self.desListModel.symbol,self.desListModel.quote] frame:CGRectMake(SCREEN_WIDTH - 107 , 26, 91, 28)];
    [changeBtn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.tag = 508;
    [headView addSubview:changeBtn];
    [self updateBtnStatus:508 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    
    UILabel * onedayLabel = [self createLabelTitle:@"24h量/额:23万/11亿元" frame:CGRectMake(16, 72, SCREEN_WIDTH - 16 -116, 12)];
    onedayLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    onedayLabel.tag = 710;
    onedayLabel.textColor = [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0];
    [headView addSubview:onedayLabel];
    
    NSArray * arr = @[@"1小时",@"成交分布",@"主力意图",@"MACD",];
    for (int i = 0; i < arr.count; i ++) {
        
        UIButton * btn = [self createBtnTiltle:arr[i] frame:CGRectMake((contractBtnWidth + contractBtnInterval) * i + 16, 90, contractBtnWidth, 28)];
        btn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [btn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 500 + i;
        [headView addSubview:btn];
        
    }
    
    // CGRectMake((SCREEN_WIDTH - contractBtnWidth - 5 - 24 - ((contractBtnWidth + contractBtnInterval) * 4 + 16)) * 0.5 + (contractBtnWidth + contractBtnInterval) * 4 + 16, 90, 24, 28)
    UIButton *noteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - contractBtnWidth - 5, 90, contractBtnWidth+5, 28)];
    //    [noteBtn setImage:[UIImage imageNamed:@"full_screen"] forState:UIControlStateNormal];
    [noteBtn setTitle:@"盯盘" forState:UIControlStateNormal];
    [noteBtn setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
    [noteBtn addTarget:self action:@selector(noteclick:) forControlEvents:UIControlEventTouchUpInside];
    noteBtn.tag = 666;
    noteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [headView addSubview:noteBtn];
    
//    UIButton * setbtn = [self createBtnTiltle:@"设置" frame:CGRectMake(SCREEN_WIDTH - contractBtnWidth - 5, 90, contractBtnWidth+5, 28)];
//    setbtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//    [setbtn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
//    setbtn.tag = 507;
//    [headView addSubview:setbtn];
    
    
    UIView * infoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, HeadTopHeight, SCREEN_WIDTH, 22)];
    infoBGView.backgroundColor = [UIColor colorWithHexString:@"E8ECEF"];
    [headView addSubview:infoBGView];
    
    UILabel * descLabel = [self createLabelTitle:@"2018/05/18 11:00 开:7991.19  高:8019.17 低:7984.21 收:8009.00" frame:CGRectMake(0, 6, SCREEN_WIDTH, 10)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:10];
    descLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    [infoBGView addSubview:descLabel];
    //    _descLabel.numberOfLines = 0;
    _descLabel = descLabel;
    
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
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerHeight + self.ChartHeight+bottomHeigth, SCREEN_WIDTH, SCREEN_HEIGHT - 42)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 6, 0);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces = NO;
    self.itemScrollview = scrollView;
    [self.rootScrollView addSubview:scrollView];
    
    
    for (int tag = 0; tag < 5; tag ++) {
        if (tag == 3)continue;
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * tag, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 42) style:UITableViewStylePlain];
        tableview.dataSource = self;
        tableview.delegate = self;
        tableview.bounces = NO;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.tableFooterView = [UIView new];
        [scrollView addSubview:tableview];
        tableview.tag = 400 + tag;
        tableview.backgroundColor = [UIColor whiteColor];
    }
    
}

- (UIView *)bottomItemView:(CGRect)frame{
    
    UIView * bottomView = [[UIView alloc] initWithFrame:frame];
    bottomView.backgroundColor = KBGColor;
    
    NSArray * itemTiles = @[@"异动",@"深度",@"爆仓",@"资金",@"钱包",@"讨论"];
    CGFloat btnW = SCREEN_WIDTH / (itemTiles.count * 1.0);
    for (int i = 0; i < itemTiles.count; i ++) {
        UIButton * btn = [self createBtn:itemTiles[i] frame:CGRectMake(0 + btnW * i, 1, btnW, 40)];
        btn.tag = 900 + i;
        btn.titleLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(itemTabelChose:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"44A0F1"] forState:UIControlStateNormal];
        }
        [bottomView addSubview:btn];
    }
    UILabel * countLabel = [self createLabelTitle:@"" frame:CGRectMake(5 * btnW, 28, btnW, 10)];
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

- (void)aboutContract{
    
}

#pragma mark --按钮点击事件处理
- (void)changeBtn:(UIButton *)btn{
    if (_exchangeArray.count > 0) {
        //        _exchangeTableView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 264);
        _exchangeTableView.hidden = NO;
        [self updateBtnStatus:508 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        [_exchangeTableView reloadData];
    }else{
        //        [self requestExchangeData];
    }
}

- (void)gotoTop{
    [self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)openContract{
    if (User.isLogin) {
//        [self goAlertView];
        [self openCon];
    }else{
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            if (isComplete) {
                self.isLogining = YES;
//                [self goAlertView];
                [self openCon];
//                [self getUserInfo];
            }
        }];
    }
}

- (void)goAlertView{
    
//    self.isLogining = NO;
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
//                                                                   message:[NSString stringWithFormat:@"开启合约狗每天将消耗您%ld积分，是否确认开启？",_point]
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {
//                                                              //响应事件
//                                                              NSLog(@"action = %@", action);
//                                                              [self openCon];
//                                                          }];
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction * action) {
//                                                             //响应事件
//                                                             NSLog(@"action = %@", action);
//                                                         }];
//
//    [alert addAction:defaultAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
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
        
    }
}

- (void)hideBesides:(NSInteger)tag{
    
    if (tag != 500) {
        _ktypeBGView.hidden = YES;
        _volumeTypeView.hidden = YES;
        [self updateBtnStatus:500 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag !=501) {
        _mainQuotaTypeBGView.hidden = YES;
        [self updateBtnStatus:501 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag != 503) {
        _fitureQuotaBGView.hidden = YES;
        [self updateBtnStatus:503 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag != 504) {
        _strengthBgView.hidden = YES;
        [self updateBtnStatus:504 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag != 502) {
        _orderBurnedBgView.hidden = YES;
        [self updateBtnStatus:502 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    if (tag != 507) {
        _setBgView.hidden = YES;
        [self updateBtnStatus:507 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    
    if (tag != 508) {
        _exchangeTableView.hidden = YES;
        [self updateBtnStatus:508 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    }
    _verticalView.hidden = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _itemScrollview) {
        NSLog(@"减速结束 %f",(long)scrollView.contentOffset.x/scrollView.bounds.size.width);
        NSInteger count = (long)scrollView.contentOffset.x/scrollView.bounds.size.width;
        UIButton * button = [self.bottomView viewWithTag:900 + count];
        if (!self.floatBottomView.hidden) {
            button = [self.floatBottomView viewWithTag:900 + count];
        }
        
        [self itemTabelChose:button];
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
    if (y > (self.ChartHeight + headerHeight + 8)) {
        self.floatBottomView.hidden = NO;
        if (self.bottomType != BottomTypeChatView) {
            self.topImageView.hidden = NO;
        }
    }else{
        self.floatBottomView.hidden = YES;
        self.topImageView.hidden = YES;
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

- (void)itemTabelChose:(UIButton *)btn{
    NSLog(@"itemTabelChose------>%ld",btn.tag);
    if (btn.tag ==904) {
        if (!User.userToken) {
            [BHToast showMessage:@"请您开启合约狗后进行实时讨论"];
            return;
        }
    }
    for (int i = 900; i < 906; i ++) {
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
    CGFloat btnW = SCREEN_WIDTH / 6.0;
    line.frame = CGRectMake((btnW - 40) * 0.5 + btnW * (btn.tag - 900), line.frame.origin.y, 40, 2);
    UIView * fline = [self.floatBottomView viewWithTag:899];
    fline.frame = line.frame;
    
    CGPoint contentOffset = _itemScrollview.contentOffset;
    contentOffset.x = (btn.tag-900) * SCREEN_WIDTH;
    [_itemScrollview setContentOffset:contentOffset animated:YES];
    
    _rootScrollView.scrollEnabled = YES;
    if (_rootScrollView.contentOffset.y >= self.ChartHeight + headerHeight + 8) {
        _rootScrollView.contentOffset = CGPointMake(0, self.ChartHeight + headerHeight + 8);
        self.topImageView.hidden = NO;
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (btn.tag == 900) {
        self.bottomType = BottomTypeOrderChange;
        [self requestAbnormity];
        
    }else if (btn.tag == 901){
        self.bottomType = BottomTypeSuperDeep;
        [self requestDeepth];
    }else if (btn.tag == 902){
        
        self.bottomType = BottomTypeOrderBreak;
        [self requestBurned];
    }else if (btn.tag == 903){
        self.bottomType = BottomTypeFoundFlow;
        
        [self updateTableScrollviewPosition:foundHeight];
        
        if (self.loginBGView.hidden) {
            [self requestHistoryfoundFlow];
            self.foundflowView.hidden = NO;
            
        }else{
            self.foundflowView.hidden = YES;
        }
    }else if (btn.tag == 904){
        self.bottomType = BottomTypeTxs;
        [self requestTxs];
    }else if (btn.tag == 905){
        self.tempbottomType = self.bottomType;
        self.bottomType = BottomTypeChatView;
        _rootScrollView.scrollEnabled = NO;
        if (self.loginBGView.hidden) {
            
            if (self.chatVC) {
                CGFloat tableBtnHeight = 42;
                
                _itemScrollview.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeigth , SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
                _rootScrollView.contentOffset = CGPointMake(0, self.ChartHeight + headerHeight + 8);
                self.assistiveBtn.userInteractionEnabled = YES;
                
                self.topImageView.hidden = YES;
            }else{
                [self gotoChatGroup];
            }
        }
    }
    
    
}

#pragma mark -- 设置主图指标、附图指标、K线类型选择
- (void)selectTypeItem:(UIButton *)btn{
    
    [self hideBesides:btn.tag];
    if (btn.tag == 500) {
        
        if (self.ktypeBGView.hidden) {
            
            // K线
            self.ktypeBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:btn.tag title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _ktypeBGView.hidden = YES;
            [self updateBtnStatus:btn.tag title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
        
    }else if(btn.tag == 501){
        // 主图指标
        if (self.mainQuotaTypeBGView.hidden) {
            self.mainQuotaTypeBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:btn.tag title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _mainQuotaTypeBGView.hidden = YES;
            [self updateBtnStatus:btn.tag title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
    }else if(btn.tag == 503){
        // 附图指标
        if (self.fitureQuotaBGView.hidden) {
            self.fitureQuotaBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:btn.tag title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _fitureQuotaBGView.hidden = YES;
            [self updateBtnStatus:btn.tag title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
    }else if (btn.tag == 504){
        if (self.strengthBgView.hidden) {
            self.strengthBgView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:btn.tag title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _strengthBgView.hidden = YES;
            [self updateBtnStatus:btn.tag title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
        
    }else if (btn.tag == 502){
        if (self.orderBurnedBgView.hidden) {
            self.orderBurnedBgView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:btn.tag title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _orderBurnedBgView.hidden = YES;
            [self updateBtnStatus:btn.tag title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
        
    }else if (btn.tag == 507){
        if (self.setBgView.hidden) {
            self.setBgView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:btn.tag title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            _setBgView.hidden = YES;
            [self updateBtnStatus:btn.tag title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
        
    }else if (btn.tag == 505){
        
    }else if (btn.tag == 508){
        
        if (self.exchangeTableView.hidden) {
            if (_exchangeArray.count > 0) {
                //        _exchangeTableView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 264);
                _exchangeTableView.hidden = NO;
                [self updateBtnStatus:508 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
                [_exchangeTableView reloadData];
            }else{
                //                [self requestExchangeData];
                [self getContractList];
            }
        }else{
            _exchangeTableView.hidden = YES;
            [self updateBtnStatus:508 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
        }
        
    }
}

- (NSArray *)klineTypes{
    if (!_klineTypes) {
        _klineTypes = @[@"分时",@"1分",@"5分",@"15分",@"30分",@"1小时",@"4小时",@"1天",@"1周",@"1月"];
    }
    return _klineTypes;
}

- (UIView *)ktypeBGView{
    if (!_ktypeBGView) {
        
        _ktypeBGView = [[UIView alloc] initWithFrame:CGRectMake(16, HeadTopHeight, (contractBtnWidth + 10)* 3, 35 * 4)];
        _ktypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_ktypeBGView];
        _ktypeBGView.hidden = YES;
        
        
        for (int index = 0; index < self.klineTypes.count; index ++) {
            
            UIButton * btn = [self createBtn:self.klineTypes[index] frame:CGRectMake((contractBtnWidth+ 10) * (index %3) + 5, (index / 3) * 35, contractBtnWidth, 28)];
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
    _isfreshing = NO;
    for (int i = 0; i < self.klineTypes.count; i ++) {
        UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    [self updateBtnStatus:500 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
    _ktypeBGView.hidden = YES;
    NSArray * types= @[@"1m",@"1m",@"5m",@"15m",@"30m",@"1h",@"4h",@"1d",@"1w",@"1mo"];
    _ktype = types[btn.tag -2000];
    
    [self resetData];
    if ([btn.titleLabel.text isEqualToString:@"分时"]) {
        _candleChartView.mainchartType = MainChartcenterViewTypeTimeLine;
    }else{
        _candleChartView.mainchartType = MainChartcenterViewTypeKline;
        
        
    }
    
    [self requestData];
}

- (UIView *)volumeTypeView{
    if (!_volumeTypeView) {
        
        _volumeTypeView = [[UIView alloc] initWithFrame:CGRectMake(16, HeadTopHeight, (contractBtnWidth), 35 * 4)];
        _volumeTypeView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_volumeTypeView];
        _volumeTypeView.hidden = YES;
        
        NSArray * arr = @[@"1小时",@"4小时",@"1天"];
        for (int index = 0; index < arr.count; index ++) {
            
            UIButton * btn = [self createBtn:arr[index] frame:CGRectMake(0, index * 35, contractBtnWidth, 28)];
            [btn addTarget:self action:@selector(choseVolumeTypeItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2900 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_volumeTypeView addSubview:btn];
            if ([arr[index] isEqualToString:@"1小时"]) {
                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            }
        }
    }
    return _volumeTypeView;
}

- (void)choseVolumeTypeItem:(UIButton *)btn{
    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [_volumeTypeView viewWithTag:2900 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    
    for (int i = 0; i < self.klineTypes.count; i ++) {
        UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    
    
    [self updateBtnStatus:500 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
    _volumeTypeView.hidden = YES;
    NSArray * types= @[@"1h",@"4h",@"1d"];
    _ktype = types[btn.tag -2900];
    
    NSArray * originTypes= @[@"1m",@"1m",@"5m",@"15m",@"30m",@"1h",@"4h",@"1d",@"1w",@"1mo"];
    NSInteger index = [originTypes indexOfObject:_ktype];
    
    UIButton * kbutton = [_ktypeBGView viewWithTag:2000 + index];
    kbutton.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
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
        NSArray * quotaArr = @[@"成交分布",@"压力线",@"MA",@"EMA",@"BOLL",@"SAR",@"关闭"]; // @"压力线",
        _mainQuotaTypeBGView = [[UIView alloc] initWithFrame:CGRectMake(16 + (contractBtnWidth + contractBtnInterval), HeadTopHeight, contractBtnWidth, quotaArr.count * btnH)];
        _mainQuotaTypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_mainQuotaTypeBGView];
        _mainQuotaTypeBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, 0 + index * btnH, contractBtnWidth, btnH)];
            [btn addTarget:self action:@selector(chosequptaItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2100 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_mainQuotaTypeBGView addSubview:btn];
            if ([quotaArr[index] isEqualToString:@"成交分布"]) {
                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            }
        }
    }
    return _mainQuotaTypeBGView;
}

- (void)chosequptaItem:(UIButton *)btn{
    
    _isfreshing = NO;
    for (int i = 0; i < 6; i ++) {
        UIButton * button = [_mainQuotaTypeBGView viewWithTag:2100 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    self.distrabuteView.hidden = YES;
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
    }else if ([btn.titleLabel.text isEqualToString:@"压力线"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithSTRANCE;
        [_candleChartView reloadAtCurrentIndex];
    }else if ([btn.titleLabel.text isEqualToString:@"成交分布"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithNone;
        [_candleChartView reloadAtCurrentIndex];
        self.distrabuteView.hidden = NO;
    }
    _mainQuotaTypeBGView.hidden = YES;
}

-(UIView *)fitureQuotaBGView{
    if (!_fitureQuotaBGView) {
        
        CGFloat btnH = 40;
        NSArray * quotaArr = @[@"MACD",@"KDJ",@"RSI"];
        _fitureQuotaBGView = [[UIView alloc] initWithFrame:CGRectMake(16 + (contractBtnWidth + contractBtnInterval) * 3, HeadTopHeight, contractBtnWidth, quotaArr.count * btnH)];
        _fitureQuotaBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_fitureQuotaBGView];
        _fitureQuotaBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, index * btnH, contractBtnWidth, btnH)];
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
    _isfreshing = NO;
    for (int i = 0; i < 4; i ++) {
        UIButton * button = [_fitureQuotaBGView viewWithTag:2200 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    quotaBtn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    NSInteger tag = 503;
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

- (UIView *)strengthBgView{
    if (!_strengthBgView) {
        CGFloat btnH = 40;
        NSArray * quotaArr = @[@"成交量",@"净成交量"];
        _strengthBgView = [[UIView alloc] initWithFrame:CGRectMake(16 + (contractBtnWidth + contractBtnInterval)*4, HeadTopHeight, contractBtnWidth, quotaArr.count * btnH)];
        _strengthBgView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_strengthBgView];
        _strengthBgView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, 0 + index * btnH, contractBtnWidth, btnH)];
            [btn addTarget:self action:@selector(chooseStrength:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2500 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_strengthBgView addSubview:btn];
            if ([quotaArr[index] isEqualToString:@"成交量"]) {
                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            }
        }
    }
    return _strengthBgView;
}

- (void)chooseStrength:(UIButton *)btn{
    for (int i = 0; i < 2; i ++) {
        UIButton * button = [_strengthBgView viewWithTag:2500 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    [self updateBtnStatus:504 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
    if ([btn.titleLabel.text isEqualToString:@"成交量"]) {
        _volumeView.showbuySell = 0;
    }else if ([btn.titleLabel.text isEqualToString:@"净成交量"]){
        _volumeView.showbuySell = 3;
        
    }
    
    if ([self.ktype isEqualToString:@"1h"] || [self.ktype isEqualToString:@"4h"] || [self.ktype isEqualToString:@"1d"]) {
        
    }else{
        self.ktype = @"1h";
        
        [self updateBtnStatus:500 title:@"1小时" imageHide:NO hideBackColor:[UIColor whiteColor]];
        
        
        for (int i = 0; i < self.klineTypes.count; i ++) {
            UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
            button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        }
        UIButton * kbutton = [_ktypeBGView viewWithTag:2000 + 5];
        kbutton.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
        
        [self requestData];
    }
    [_candleChartView reloadAtCurrentIndex];
    _strengthBgView.hidden = YES;
}

- (UIView *)orderBurnedBgView{
    if (!_orderBurnedBgView) {
        CGFloat btnH = 40;
        NSArray * quotaArr = @[@"主力意图",@"关闭"];
        //        NSArray * imgquotaArr = @[@"contract_burned",@"contract_resistance",@"contract_support",@"contract_cancel",@""];
        _orderBurnedBgView = [[UIView alloc] initWithFrame:CGRectMake(16 + (contractBtnWidth + contractBtnInterval)*2, HeadTopHeight, contractBtnWidth, quotaArr.count * btnH)];
        _orderBurnedBgView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_orderBurnedBgView];
        _orderBurnedBgView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, 0 + index * btnH, contractBtnWidth, btnH)];
            [btn addTarget:self action:@selector(chooseBurned:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2600 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_orderBurnedBgView addSubview:btn];
            if ([quotaArr[index] isEqualToString:@"主力意图"]) {
                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            }
            
        }
    }
    return _orderBurnedBgView;
}

- (void)chooseBurned:(UIButton *)btn{
    _isfreshing = NO;
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [_orderBurnedBgView viewWithTag:2600 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    _candleChartView.showOrder = NO;
    
    [self updateBtnStatus:502 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
    
    if([btn.titleLabel.text isEqualToString:@"主力意图"]){
        
        
        _candleChartView.showOrder = YES;
        
        _volumeView.showbuySell = 3;
        
    }else if ([btn.titleLabel.text isEqualToString:@"关闭"]){
        
        _candleChartView.showOrder = NO;
        
        _volumeView.showbuySell = 0;
        
    }else if ([btn.titleLabel.text isEqualToString:@"撤单"]){
        
        
    }else if ([btn.titleLabel.text isEqualToString:@"大单爆仓"]){
        
        _candleChartView.showOrder = YES;
        
        
    }
    
    
    [_candleChartView reloadAtCurrentIndex];
    _orderBurnedBgView.hidden = YES;
}

- (UIView *)setBgView{
    if (!_setBgView) {
        CGFloat btnH = 40;
        NSArray * quotaArr = @[@"获取积分",@"开启/暂停"];
        _setBgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - contractBtnWidth-5, HeadTopHeight, contractBtnWidth + 5, quotaArr.count * btnH)];
        _setBgView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_setBgView];
        _setBgView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, 0 + index * btnH, contractBtnWidth+5, btnH)];
            [btn addTarget:self action:@selector(chooseSet:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2700 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_setBgView addSubview:btn];
            //            if ([quotaArr[index] isEqualToString:@"全部"]) {
            //                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            //            }
        }
    }
    return _setBgView;
}

- (void)chooseSet:(UIButton *)btn{
    
    for (int i = 0; i < 5; i ++) {
        UIButton * button = [_setBgView viewWithTag:2700 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    //    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    if ([btn.titleLabel.text isEqualToString:@"帮助"]) {
        //        [self updateBtnStatus:507 title:@"帮助" imageHide:NO hideBackColor:[UIColor whiteColor]];
        
    }else if([btn.titleLabel.text isEqualToString:@"获取积分"]){
        
        [self gainGoal];
        
        //        [self updateBtnStatus:507 title:btn.titleLabel.text imageHide:NO hideBackColor:[UIColor whiteColor]];
        [self updateBtnStatus:507 title:@"设置" imageHide:NO hideBackColor:[UIColor whiteColor]];
        
    }else if ([btn.titleLabel.text isEqualToString:@"开启/暂停"]){
        
        if (self.loginBGView.hidden) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"确定要暂停合约狗功能吗？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      NSLog(@"action = %@", action);
                                                                      [self closeCon];
                                                                  }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * action) {
                                                                     //响应事件
                                                                     NSLog(@"action = %@", action);
                                                                 }];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self openContract];
        }
        
        
        
        
        [self updateBtnStatus:507 title:@"设置" imageHide:NO hideBackColor:[UIColor whiteColor]];
        
    }
    _setBgView.hidden = YES;
}

- (void)gainGoal{
    SecondaryLevelWebViewController * goalVc = [[SecondaryLevelWebViewController alloc] init];
    goalVc.urlString = [NSString stringWithFormat:@"%@?source=contractDog",kAppBTEH5integralCheatsAddress];
    goalVc.isHiddenLeft = YES;
    goalVc.isHiddenBottom = YES;
    [self.navigationController pushViewController:goalVc animated:YES];
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
    [self updateBtnStatus:503 title:@"" imageHide:NO];
    
    _strengthBgView.hidden = YES;
    [self updateBtnStatus:504 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    
    _orderBurnedBgView.hidden = YES;
    [self updateBtnStatus:502 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    
    _setBgView.hidden = YES;
    [self updateBtnStatus:507 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
    
    _exchangeTableView.hidden = YES;
    [self updateBtnStatus:508 title:[NSString stringWithFormat:@"%@",self.name] imageHide:NO hideBackColor:[UIColor whiteColor]];
}

#pragma mark -- 请求数据
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
                BOOL isFutureDogUser= [[data objectForKey:@"isFutureDogUser"] boolValue];
                NSInteger futurepoint = [[data objectForKey:@"point"] integerValue];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:isFutureDogUser forKey:KisFutureDogUser];
                [defaults setInteger:futurepoint forKey:KisFutureDogUserGoal];
                [defaults synchronize];
                User.isFutureDogUser = isFutureDogUser;
                User.futureDogGoal = futurepoint;
                isFutureDogUser = YES;
                weakSelf.loginBGView.hidden = isFutureDogUser;
                weakSelf.rootScrollView.scrollEnabled = isFutureDogUser;
                if (futurepoint > 0) {
                    UILabel * noteLabel = [weakSelf.loginBGView viewWithTag:333];
                    NSString * text = [NSString stringWithFormat:@"使用合约狗将每天消耗%ld积分，当前您有%ld积分。",_point,futurepoint];
                    NSArray * texts = @[[NSString stringWithFormat:@"%ld",_point],[NSString stringWithFormat:@"%ld",futurepoint]];
                    [weakSelf label:noteLabel text:text colorText:texts];
                    
                }
                
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
                [self getWhetherRegisterHX];
            }
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)label:(UILabel *)label text:(NSString *)text  colorText:(NSArray *)colorTextArr{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *colorText  in colorTextArr) {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"308cdd"] range:[text rangeOfString:colorText]];
    }
    
    label.attributedText = att;
}

- (void)requestGoal{
    NSString * methodName = @"";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    methodName = kGetDogGoalUrl;
    
    WS(weakSelf)
    // 1开启 0关闭
    [BTERequestTools requestWithURLString:methodName parameters:param type:HttpRequestTypeNormalPost success:^(id responseObject) {
        
        if (IsSafeDictionary(responseObject)) {
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"-1"]) {
                User.isLogin = NO;
                [weakSelf openContract];
            }else if([[responseObject objectForKey:@"code"] isEqualToString:@"0000"]){
                NSDictionary * data = [responseObject objectForKey:@"data"];
                
                if (data != nil) {
                    [weakSelf dealPoint:data];
                }
                
            }else{
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)dealPoint:(NSDictionary *)data{
    NSInteger point = [[data objectForKey:@"point"] integerValue];
    
    self.point = point;
    UILabel * noteLabel = [self.loginBGView viewWithTag:333];
    
    if (User.isLogin) {
        NSString * text = [NSString stringWithFormat:@"使用合约狗将每天消耗%ld积分，当前您有%ld积分。",point,User.futureDogGoal];
        
        
        NSArray * texts = @[[NSString stringWithFormat:@"%ld",point],[NSString stringWithFormat:@"%ld",User.futureDogGoal]];
        [self label:noteLabel text:text colorText:texts];
        
        
    }else{
        NSString * text = [NSString stringWithFormat:@"使用合约狗将每天消耗%ld积分。",point];
        NSArray * texts = @[[NSString stringWithFormat:@"%ld",point]];
        [self label:noteLabel text:text colorText:texts];
        
    }
    
    UILabel * contractLabel = [self.loginBGView viewWithTag:334];
    NSString * personCount = [NSString stringWithFormat:@"%ld",[[data objectForKey:@"userCount"] integerValue]];
    NSString * text = [NSString stringWithFormat:@"深度挖掘合约交易数据，技术派合约玩家的必备工具。已有%@人在使用。",personCount];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:text];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"308cdd"] range:[text rangeOfString:[NSString stringWithFormat:@"%@",personCount]]];
    contractLabel.attributedText = att;
}

- (void)openCloserequest:(NSString *)type{
    NSString * methodName = @"";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [param setObject:type forKey:@"onOff"];
    methodName = kGetOpenContractDogUrl;
    WS(weakSelf)
    // 1开启 0关闭
    [BTERequestTools requestWithURLString:methodName parameters:param type:HttpRequestTypeNormalPost success:^(id responseObject) {
        
        if (IsSafeDictionary(responseObject)) {
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"-1"]) {
                [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                    
                    if (isComplete) {
                        [weakSelf openCloserequest:type];
                    }else{
                        User.isFutureDogUser = NO;
                        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setBool:NO forKey:KisFutureDogUser];
                        [defaults synchronize];
                        weakSelf.loginBGView.hidden = NO;
                        
                        weakSelf.rootScrollView.contentOffset = CGPointMake(0, 0); weakSelf.rootScrollView.scrollEnabled = NO;
                        weakSelf.foundflowView.hidden = YES;
                    }
                }];
            }else if([[responseObject objectForKey:@"code"] isEqualToString:@"0000"]){
                if ([type isEqualToString:@"1"]) {
                    weakSelf.loginBGView.hidden = YES;
                    weakSelf.rootScrollView.scrollEnabled = YES;
                    weakSelf.foundflowView.hidden = NO;
                    //                    _contentLabel.hidden = NO;
                    User.isFutureDogUser = YES;
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setBool:YES forKey:KisFutureDogUser];
                    [defaults synchronize];
                    //                    self.foundflowView.hidden = NO;
                }else{
                    User.isFutureDogUser = NO;
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setBool:NO forKey:KisFutureDogUser];
                    [defaults synchronize];
                    weakSelf.loginBGView.hidden = NO;
                    weakSelf.rootScrollView.scrollEnabled = NO;
                    weakSelf.rootScrollView.contentOffset = CGPointMake(0, 0);
                    weakSelf.foundflowView.hidden = YES;
                    //                    self.foundflowView.hidden = YES;
                    //                    _contentLabel.hidden = YES;
                    
                }
                //                [weakSelf.dataTableView reloadData];
            }else if([[responseObject objectForKey:@"code"] isEqualToString:@"0001"]){
                NSLog(@"%@",responseObject);
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:@"您的可用积分不足，去赚取更多积分吧～"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"去赚取" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          //响应事件
                                                                          [weakSelf gainGoal];                                NSLog(@"action = %@", action);
                                                                          
                                                                      }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * action) {
                                                                         //响应事件
                                                                         NSLog(@"action = %@", action);
                                                                     }];
                
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
            [BHToast showMessage:[responseObject objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requestData{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
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
    methodName = kGetKlineUrl;
    
    WS(weakSelf)
    
    NSLog(@"******start******");
    NSLog(@"param======>%@",param);
    if (self.loginBGView.hidden) {
        NMShowLoadIng;
    }
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        NMRemovLoadIng;
        NSLog(@"******end******");
        [_activityView stopAnimating];
        if (IsSafeDictionary(responseObject)) {
            
            [weakSelf dealKlineData:responseObject];
            
        }
    } failure:^(NSError *error) {
        [_activityView stopAnimating];
        NMRemovLoadIng;
        RequestError(error);
        //        NSLog(@"error-------->%@",error);
        
    }];
}

-(void)dealKlineData:(NSDictionary *)dataDict{
    NSArray * kDataArr = [[dataDict objectForKey:@"data"] objectForKey:@"kline"];
    if (kDataArr.count > 0) {
        self.end = [NSString stringWithFormat:@"%@",[[kDataArr firstObject] objectForKey:@"date"]];
        clockCount = 3;
        //开启定时器
        [self.timer setFireDate:[NSDate distantPast]];
    }
    
    
    NSMutableArray * arry = [NSMutableArray arrayWithCapacity:0];
    [kDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZTYChartModel * model = [[ZTYChartModel alloc] init];
        model.x = idx;
        [model initBaseDataWithDict:obj];
        [arry addObject:model];
    }];
    
    [arry addObjectsFromArray:self.dataSource];
    self.dataSource = arry.mutableCopy;
    
    NSArray *quotaDataArray = [ZTYDataReformator initializeQuotaDataWithArray:self.dataSource];
    
    self.KLineDataArray = quotaDataArray;
    [self reloadData:quotaDataArray reload:_isrelaod];
    
    [self updateAfterGetKlineData:dataDict];
    if (self.dataSource.count > 0) {
        ZTYChartModel * lastModel = [self.dataSource lastObject];
        self.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
        clockCount = 3;
        //开启定时器
        [self.timer setFireDate:[NSDate distantPast]];
        
    }
    
    if ([self.ktype isEqualToString:@"1h"] && [self.base isEqualToString:@"BTC"]) {
        NSString * dataKey = [NSString stringWithFormat:@"contract-KEY"];
        [BTESaveDataUtil achiveKlineDataDict:dataDict key:dataKey];
    }
}

//- (void)startRequestRestranceBurnedLine:(NSArray *)array{
//
//    NSString * startTime = [NSString stringWithFormat:@"%@",[[array firstObject] objectForKey:@"date"]];
//    NSString * endTime = [NSString stringWithFormat:@"%@",[[array lastObject] objectForKey:@"date"]];
//
//    [self requestResistanceStart:startTime end:endTime];
//    [self requestVolumeStart:startTime end:endTime];
//    [self requestAbnormityLineStart:startTime end:endTime];
//}

//- (void)requestExchangeData{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//
//
//    //    param[@"exchange"] = @"okex";
//    //    param[@"symbol"] = @"btc";
//    //    param[@"pair"] = @"btc/usdt";
////    if (self.desListModel.symbol.length) {
////        param[@"base"] = self.desListModel.symbol;
////    }
////    if (self.base.length) {
////        param[@"base"] = self.base;
////    }
//
//    NSString * methodName = @"";
//    if (User.userToken) {
//        [param setObject:User.userToken forKey:@"bte-token"];
//    }
//    methodName = kGetCurrencyUrl;
//    [_exchangeArray removeAllObjects];
//    WS(weakSelf)
//    NMShowLoadIng;  //@"http://47.94.217.12:18081/app/api/exchange/info"
//    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
//        NMRemovLoadIng;
//
//        if (IsSafeDictionary(responseObject)) {
//            NSArray * dataArr = [responseObject objectForKey:@"data"];
//
//            [dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                ExchangeModel * model = [[ExchangeModel alloc] init];
//                [model initwidthDict:obj];
//                [self.exchangeArray addObject:model];
//            }];
//            //            _exchangeTableView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 264);
//            _exchangeTableView.hidden = NO;
//            [self updateBtnStatus:508 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
//            [_exchangeTableView reloadData];
//        }
//    } failure:^(NSError *error) {
//        NMRemovLoadIng;
//        //        RequestError(error);
//    }];
//
//}

- (void)requestLastModelData{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.ktype;
    param[@"size"] = @"2"; //
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
    
    NSString * methodName = kGetKlineUrl;
    //    NSLog(@"kGetKLineData====>%@",kGetKLineData);
    WS(weakSelf)
    //    NMRemovLoadIng;
    //    NMShowLoadIng; //@"http://47.94.217.12:18081/app/api/kline/line"
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        
        if (IsSafeDictionary(responseObject)) {
            
            
            //            if (kDataArr.count > 0) {
            
            [self dealLastKlineData:responseObject];
            
            
            
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)dealLastKlineData:(NSDictionary *)dataDict{
    
    NSArray * kDataArr = [[dataDict objectForKey:@"data"] objectForKey:@"kline"];
    
    ZTYChartModel * preLastModel = [self.KLineDataArray lastObject];
    
    NSMutableArray * newArray = [NSMutableArray array];
    [newArray addObjectsFromArray:self.KLineDataArray];
    for (NSInteger idx = 0; idx < kDataArr.count; idx ++) {
        
        NSDictionary * obj = kDataArr[idx];
        if ([[obj objectForKey:@"date"] integerValue] > [preLastModel.timestamp integerValue]) {
            ZTYChartModel * model = [[ZTYChartModel alloc] init];
            model.x = idx;
            [model initBaseDataWithDict:obj];
            [newArray addObject:model];
            [self.dataSource addObject:model];
            
            NSArray *QuotaDataArray = [ZTYDataReformator initializeQuotaLastDataWithArray:newArray];
            _isfreshing = YES;
            self.KLineDataArray = QuotaDataArray;
            
            
            if (self.candleChartView.currentStartIndex >= QuotaDataArray.count - self.candleChartView.displayCount - 2) {
                [self reloadData:QuotaDataArray reload:0];
            }else{
                [self reloadData:QuotaDataArray reload:2];
            }
            
            
            
        }else if([[obj objectForKey:@"date"] integerValue] == [preLastModel.timestamp integerValue]){
            //                    [_dataSource removeLastObject];
            
            ZTYChartModel * LastModel = [self.KLineDataArray lastObject];
            
            [LastModel initBaseDataWithDict:obj];
            
            ZTYChartModel * model = [self.dataSource lastObject];
            [model initBaseDataWithDict:obj];
            
            NSArray *QuotaDataArray = [ZTYDataReformator initializeQuotarefreshLastDataWithArray:newArray];
            _isfreshing = YES;
            self.KLineDataArray = QuotaDataArray;
            [self reloadData:QuotaDataArray reload:2];
        }else{
            
            
        }
    }
    
    [self updateAfterGetKlineData:dataDict];
    
    [self updateLatestTextLine];
    
    if (self.KLineDataArray.count > 0) {
        ZTYChartModel * lastModel = [self.KLineDataArray lastObject];
        self.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
    }
}

- (void)updateAfterGetKlineData:(NSDictionary *)dataDict{
    [self updateHeadData:[[dataDict objectForKey:@"data"] objectForKey:@"ticker"]];
    self.latesetClose = [[[[dataDict objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
   
}

- (void)getContractList{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WS(weakSelf)
    
    
    NSString * methodName = kGetCurrencyUrl;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        
        if (IsSafeDictionary(responseObject)) {
            
            
            [weakSelf finishRequestContractlist:responseObject];
//            [weakSelf afterRequestContractList];
            
        }
    } failure:^(NSError *error) {
        RequestError(error);
    }];
}

- (void)finishRequestContractlist:(NSDictionary *)datadict{
    NSArray * dataArr = [datadict objectForKey:@"data"];
    
    if (dataArr.count > 0) {
        [self.exchangeArray removeAllObjects];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ExchangeModel * model = [[ExchangeModel alloc] init];
            [model initwidthDict:obj];
            [self.exchangeArray addObject:model];
        }];
        
        NSDictionary * firstDict = [dataArr firstObject];
        self.base = [firstDict objectForKey:@"baseAsset"];
        self.quote = [firstDict objectForKey:@"quoteAsset"];
        self.exchange = [firstDict objectForKey:@"exchange"];
        self.name = [firstDict objectForKey:@"name"];
        if (dataArr.count < 10) {
            _exchangeTableView.height = dataArr.count * 48;
        }
        [self updateBtnStatus:508 title:[NSString stringWithFormat:@"%@",self.name] imageHide:NO hideBackColor:[UIColor whiteColor]];
        
        UILabel * exchangeLabel = [_headView viewWithTag:719];
        exchangeLabel.text = [NSString stringWithFormat:@"%@",self.exchange];
        
        self.exchangeTableView.hidden = YES;
        [self resetData];
        [self requestData];
        [self requestAbnormity];
    }
    
    
}

- (void)afterRequestContractList{
    _exchangeTableView.hidden = YES;
    [self resetData];
    [self requestData];
    [self requestAbnormity];
    
    
}

// 异常订单
- (void)requestAbnormityLineStart:(NSString *)start end:(NSString *)end{
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
    
    if (start.length) {
        param[@"start"] = start;
    }
    
    if (end.length) {
        param[@"end"] = end;
    }
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    
    param[@"size"] = @"500";
    param[@"type"] = self.ktype;
    
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    NSString * methodName = kGetAbnormityLineUrl;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            
            if (dataArr.count > 0) {
//                [weakSelf joinOrderInKline:dataArr];
            }
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

//- (void)joinOrderInKline:(NSArray *)array{
//
//    for (ZTYChartModel * candleModel in self.KLineDataArray) {
//        for (NSDictionary * dict in array) {
//            /*
//             大单异动-k线数据 ： orderType字段枚举
//             buy托单／cancelbuy撤销托单
//             sell压单／cancelsell撤销压单
//             buyburned 多单爆仓／sellburned 空单爆仓
//             */
//            if ([[dict objectForKey:@"datetime"] integerValue] == [candleModel.timestamp integerValue]) {
//                NSArray * orders = [dict objectForKey:@"orders"];
//                for (NSDictionary * subDict in orders) {
//
//                    if ([[subDict objectForKey:@"orderType"] isEqualToString:@"sell"]  ) {
//                        candleModel.resistance = [[subDict objectForKey:@"price"] doubleValue];
//                        candleModel.resistanceCount = [[subDict objectForKey:@"count"] integerValue];
//                        candleModel.resistanceType = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"orderType"]];
//                    }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"buyburned"]||[[subDict objectForKey:@"orderType"] isEqualToString:@"sellburned"]){
//                        candleModel.burned = [[subDict objectForKey:@"price"] doubleValue];
//                        candleModel.burnedCount = [[subDict objectForKey:@"count"] integerValue];
//                        candleModel.burnedType = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"orderType"]];
//                    }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"buy"] ){
//                        candleModel.support = [[subDict objectForKey:@"price"] doubleValue];
//                        candleModel.supportCount = [[subDict objectForKey:@"count"] integerValue];
//                        candleModel.supportType = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"orderType"]];
//                    }
//
//                }
//
//            }
//        }
//    }
//
//    [_candleChartView reloadAtCurrentIndex];
//
//}

// 大单异动
- (void)requestAbnormity{
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
    
    //    if (self.start.length) {
    //        param[@"start"] = self.start;
    //    }
    NSString * methodName = kGetAbnormityUrl;
    [_bottomDict removeAllObjects];
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            [_bottomDict removeAllObjects];
            UITableView * tableview = [weakSelf.itemScrollview viewWithTag:(400 +weakSelf.bottomType)];
            [tableview reloadData];
            //            [_dataTableView reloadData];
            //             {
            
            [_bottomDict setObject:dataArr forKey:AbnormityKey];
            
            
            CGFloat tableheight = [BTEBigOrderTableViewCell cellHeight] * dataArr.count;
            [weakSelf updateTableScrollviewPosition:tableheight];
            
            
            //            }
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

// 钱包
- (void)requestTxs{
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
    
    //    if (self.start.length) {
    //        param[@"start"] = self.start;
    //    }
    NSString * methodName = kGetTxsUrl;
    [_bottomDict removeAllObjects];
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [[responseObject objectForKey:@"data"] objectForKey:@"details"];
            [_bottomDict removeAllObjects];
            UITableView * tableview = [weakSelf.itemScrollview viewWithTag:(400 +weakSelf.bottomType)];
            [tableview reloadData];
            //            [_dataTableView reloadData];
            //             {
            
            [_bottomDict setObject:dataArr forKey:WalletKey];
            
            
            CGFloat tableheight = [BTEWalletTableViewCell cellHeight] * dataArr.count;
            [weakSelf updateTableScrollviewPosition:tableheight];
            
            
            //            }
            
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
    
    if (self.quote.length) {
        param[@"quote"] = self.quote;
    }
    
    if (self.exchange.length) {
        param[@"exchange"] = self.exchange;
    }
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    NSString * methodName = kGetDepthUrl;
    [_bottomDict removeAllObjects];
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            [_bottomDict removeAllObjects];
            //            [_dataTableView reloadData];
            UITableView * tableview = [weakSelf.itemScrollview viewWithTag:(400 +weakSelf.bottomType)];
            [tableview reloadData];
            //            if (dataArr.count > 0) {
            
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
            
            CGFloat tableheight = [BTEOrderDeepTableViewCell cellHeight] * dataArr.count;
            [weakSelf updateTableScrollviewPosition:tableheight];
            
            //            }
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
            UITableView * tableview = [weakSelf.itemScrollview viewWithTag:(400 +weakSelf.bottomType)];
            [tableview reloadData];
            
            [_bottomDict setObject:dataArr forKey:BurnedKey];
            
            CGFloat tableheight = [BTEBigOrderTableViewCell cellHeight] * dataArr.count;
            [weakSelf updateTableScrollviewPosition:tableheight];
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)updateTableScrollviewPosition:(CGFloat)height{
    if (_bottomType == BottomTypeOrderNone) {
        
        if (height <= KlineTopViewHeight) {
            height = KlineTopViewHeight;
        }
        _itemScrollview.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeigth , SCREEN_WIDTH, height);
        _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight + height + bottomHeigth );
    }else{
        
        if (height <= KlineTopViewHeight - tableFootAndHeadHeight) {
            height = KlineTopViewHeight - tableFootAndHeadHeight;
        }
        UITableView * tableview = [_itemScrollview viewWithTag:(400 + _bottomType)];
        tableview.frame = CGRectMake(_bottomType * SCREEN_WIDTH, 0, SCREEN_WIDTH, height+tableFootAndHeadHeight);
        _itemScrollview.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeigth, SCREEN_WIDTH, height + tableFootAndHeadHeight);
        
        _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headerHeight + self.ChartHeight + height + bottomHeigth + tableFootAndHeadHeight);
        [tableview reloadData];
    }
    
}

- (void)requestResistanceStart:(NSString *)start end:(NSString *)end{
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
    
    if (start.length) {
        param[@"start"] = start;
    }
    
    if (end.length) {
        param[@"end"] = end;
    }
    
    param[@"type"] = self.ktype;
    param[@"size"] = @"500";
    
    NSString * methodName = kGetResistanceLineUrl;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            
            if (dataArr.count > 0) {
                [weakSelf joinResistanceInKline:dataArr];
            }
            
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)joinResistanceInKline:(NSArray *)array{
    NSUInteger idx = 0;
    for (ZTYChartModel * model in _KLineDataArray) {
        
        for (NSDictionary * dict in array) {
            
            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"timestamp"]] isEqualToString:model.timestamp]) {
                
                model.sellPrice5 = [[dict objectForKey:@"sellPrice5"] doubleValue];
                model.sellCumulativeAmount5 = [[dict objectForKey:@"sellCumulativeAmount5"] doubleValue];
                
                model.buyPrice5 = [[dict objectForKey:@"buyPrice5"] doubleValue];
                model.buyCumulativeAmount5 = [[dict objectForKey:@"buyCumulativeAmount5"] doubleValue];
                
                break;
                
            }
        }
        idx ++;
    }
    
    [self reloadData:self.KLineDataArray reload:2];
    
}

- (void)requestVolumeStart:(NSString *)start end:(NSString *)end{
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
    
    if (start.length) {
        param[@"start"] = start;
    }
    
    if (end.length) {
        param[@"end"] = end;
    }
    
    param[@"type"] = self.ktype;
    param[@"size"] = @"500";
    
    NSString * methodName = kGetVolumeUrl;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            
            if (dataArr.count > 0) {
                [weakSelf joinVolumInKline:dataArr];
            }
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)joinVolumInKline:(NSArray *)array{
    for (NSDictionary * dict in array) {
        for (ZTYChartModel * model in self.KLineDataArray) {
            if ([[dict objectForKey:@"datetime"] integerValue] == [model.timestamp integerValue]) {
                
                model.sellCount = [[dict objectForKey:@"sellCount"] integerValue];
                model.buyCount = [[dict objectForKey:@"buyCount"] integerValue];
                model.count = [[dict objectForKey:@"count"] integerValue];
                break;
            }
            
        }
    }
    [_candleChartView reloadAtCurrentIndex];
}

- (void)requestLatestfoundFlow{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.base.length) {
        param[@"baseAsset"] = self.base;
    }
    
    NSString * methodName = kGetLatestflowUrl;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * dataDict = [responseObject objectForKey:@"data"];
            //            [weakSelf updateLatestFoundflow:dataDict];
            
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
}

- (void)requestHistoryfoundFlow{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.base.length) {
        param[@"base"] = self.base;
    }
    
    NSString * methodName = kGetHistoryflowUrl;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * dataDict = [responseObject objectForKey:@"data"];
            [weakSelf updateFoundflow:dataDict];
            
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
    }];
}

#pragma mark -- 头部数据更新
- (void)updateHeadData:(NSDictionary *)dict{
    double airValue = [[dict objectForKey:@"airIndex"] doubleValue];
    UILabel *airLabel = [_headView viewWithTag:717];
    airLabel.text = [NSString stringWithFormat:@"%.2f",airValue];
    ZTYArrowLine *arrowRightLine = [_headView viewWithTag:715];
    CGFloat ydistance = 52 - airValue * 52 / 100.0;
    CGFloat xdistance = 5 * ydistance / 52.0;
    arrowRightLine.frame = CGRectMake(SCREEN_WIDTH - 16 + xdistance - 12, 23 + ydistance - 3, 12, 6);
    
    UILabel * onedayLabel = [_headView viewWithTag:710];
    
    NSString * onedaytext = [NSString stringWithFormat:@"24h量/额:%@张/%@",[self caculateValue:[[dict objectForKey:@"vol"] doubleValue]],[NSString stringWithFormat:@"%@元",[self caculateValue:[[dict objectForKey:@"amountVol"] doubleValue]]]];
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
    
    self.title = [NSString stringWithFormat:@"%@(%@)",self.name,priceStr];
    
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
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kLineBGView).offset(headerHeight);
        make.left.equalTo(self.kLineBGView);
        make.right.equalTo(self.kLineBGView).offset(-57);
        make.height.equalTo(@(self.ChartHeight));
    }];
}

- (void)addCandleChartView
{
    _candleChartView = [ZTYContractChartView new];
    [_scrollView addSubview:_candleChartView];
    _candleChartView.mainquotaName = MainViewQuotaNameWithNone;
    _candleChartView.mainchartType = MainChartcenterViewTypeKline;
    _candleChartView.delegate = self;
    _currentZoom = -.001f;
    _candleChartView.lineCount = 6;
    [_candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.height.equalTo(@((self.ChartHeight)*CandleScale));
        make.top.equalTo(_scrollView);
    }];
    
    _candleChartView.candleSpace = 2;
    _candleChartView.displayCount = 120;
    _displayCount = _candleChartView.displayCount;
    _candleChartView.lineWidth = 1*widthradio;
    UITapGestureRecognizer * candleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(candleClick:)];
    [_candleChartView addGestureRecognizer:candleTap];
    
    _candleChartView.showOrder = YES;
    
    CGFloat percandlePriceHeight = (self.ChartHeight * CandleScale) / 6.0;
    self.distrabuteView = [[ZTYTradeDistrabuteView alloc] initWithFrame:CGRectMake(0, percandlePriceHeight, SCREEN_WIDTH - 57, percandlePriceHeight * 4) showCount:50];
    [self.candleChartView addSubview:self.distrabuteView];
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
    _volumeView.showbuySell = 3;
    _volumeView.lineWidth = BoxborderWidth; //1 *widthradio;
}

- (void)addPriceView
{
    CGFloat percandlePriceHeight = (self.ChartHeight * CandleScale) / 6.0;
    _candlePrice = [ZYWPriceView new];
    _candlePrice.backgroundColor = [UIColor whiteColor];
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
    [rightLine setNounlinewidthNouns:@[@(percandlePriceHeight),@(percandlePriceHeight * 2),@(percandlePriceHeight * 3),@(percandlePriceHeight * 4),@(percandlePriceHeight * 5),@(self.ChartHeight * (CandleScale + VolumeScale) + 7 + 5),@(self.ChartHeight * CandleScale + self.ChartHeight * VolumeScale * 0.5),@(self.ChartHeight * (CandleScale + VolumeScale) + (self.ChartHeight * QuotaScale - 12) * 0.5 + 5),@(self.ChartHeight -12)]];
    [self.kLineBGView addSubview:rightLine];
    
}

- (void)addRootTableView{
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HOME_INDICATOR_HEIGHT - NAVIGATION_HEIGHT)];
    _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
    _rootScrollView.delegate = self;
    _rootScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rootScrollView];
}

- (void)addLoginView{
    
    // CGRectMake(0, 90 + 32, SCREEN_WIDTH, self.ChartHeight + 22 + 28)
    self.loginBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HeadTopHeight, SCREEN_WIDTH, self.ChartHeight + 22)];

    self.loginBGView.backgroundColor = [UIColor colorWithHexString:@"EDF0F2" alpha:0.97];
    //    self.loginBGView.image = [UIImage imageNamed:@"blurshadow"];
    self.loginBGView.userInteractionEnabled = YES;
    [self.kLineBGView addSubview:self.loginBGView];
    
    UILabel * introlationLabel = [self createLabelTitle:@"深度挖掘合约交易数据，技术派合约玩家的必备工具。已有1000人在使用。" frame:CGRectMake(39, 100, SCREEN_WIDTH - 39 * 2, 44)];
    introlationLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    introlationLabel.numberOfLines = 2;
    introlationLabel.textAlignment = NSTextAlignmentCenter;
    introlationLabel.tag = 334;
    [self.loginBGView addSubview:introlationLabel];
    
    UIButton * openBtn = [self createBtn:@"开启合约狗" frame:CGRectMake(90, 100 + 30 + 44, SCREEN_WIDTH - 180, 40)];
    openBtn.backgroundColor = [UIColor colorWithHexString:@"308CDD"];
    [openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    openBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [openBtn addTarget:self action:@selector(openContract) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBGView addSubview:openBtn];
    
    
    UIButton * aboutBtn = [self createBtn:@"关于合约狗？" frame:CGRectMake(16, 100 + 44 + 40 + 30 + 20, SCREEN_WIDTH - 32, 12)];
    [aboutBtn setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
    aboutBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [aboutBtn addTarget:self action:@selector(aboutContract) forControlEvents:UIControlEventTouchUpInside];
    //    [self.loginBGView addSubview:aboutBtn];
    
    UILabel * noteLabel = [self createLabelTitle:@"使用合约狗将每天消耗24积分，当前您有1234积分。" frame:CGRectMake(0, self.ChartHeight - 30, SCREEN_WIDTH, 20)];
    noteLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    noteLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.8];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.tag = 333;
    noteLabel.hidden = YES;
    [self.loginBGView addSubview:noteLabel];
    
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
    self.kLineBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.ChartHeight + headerHeight + bottomHeigth)];
    self.kLineBGView.backgroundColor = [UIColor whiteColor];
    [self.rootScrollView addSubview:self.kLineBGView];
    //    _dataTableView.tableHeaderView = self.kLineBGView;
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
    
    //    [_candleChartView hideDialogs];
    
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
    self.verticalView.backgroundColor = [UIColor colorWithHexString:@"E5E5EE"];//[UIColor colorWithHexString:@"666666"];
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
    
    self.latestlineView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, -SCREEN_HEIGHT, SCREEN_WIDTH - 5, 15)];
    [self.kLineBGView addSubview:self.latestlineView];
    
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
        
        ZYWCandlePostionModel *model = self.candleChartView.currentDisplayArray.lastObject;
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
    //    _KLineDataArray = array;
    self.candleChartView.dataArray = array.mutableCopy;
    _quotaChartView.dataArray = array.mutableCopy;
    _volumeView.dataArray = array.mutableCopy;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reload == 1)
            {
                self.candleChartView.reloadIndex = 1;
                [self.candleChartView reload];
                
            }else if (reload == 2){
                self.candleChartView.reloadIndex = 2;
                [self.candleChartView reloadAtCurrentIndex];
            }
            else if(reload == 3)
            {
                self.candleChartView.reloadIndex = 3;
                [self.candleChartView reloadAddLineAtCurrentIndex];
                
            }else{
                self.candleChartView.reloadIndex = 0;
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
//- (void)displayLastModel:(ZYWCandleModel *)kLineModel
//{
//    [self updatShowData:kLineModel];
//}

- (void)updatShowData:(ZTYChartModel *)kLineModel{
    [self updateLatestTextLine];
    if (_isfreshing == YES) {
        //        _isfreshing = NO;
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
        
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 4, 0, imageSize.width + 4);
        button.imageEdgeInsets = UIEdgeInsetsMake(14,width, 9, -width);
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
        CGFloat width = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
        exchangeLabel.backgroundColor = backColor;
        if (self.exchangeTableView.hidden) {
            CGSize imageSize = button.imageView.bounds.size;
            CGFloat left = (button.frame.size.width - width - imageSize.width - 4) * 0.5;
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
    NSString * roseDropStr = [NSString stringWithFormat:@"涨幅:%.2f%%  振幅:%.2f%%",dr,dx];
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:roseDropStr];
    if (dr < 0) {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF4040"] range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"%.2f%%",dr]]];
    }else{
        [att addAttribute:NSForegroundColorAttributeName value:RoseColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"%.2f%%",dr]]];
    }
    _roseDropLabel.attributedText = att;
}


- (void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count
{
    [self showIndexLineView:leftPostion startIndex:index count:count];
    if (_candleChartView.currentDisplayArray.count > 0) {
        
        [self updatShowData:_candleChartView.currentDisplayArray.lastObject];
    }
    
}

//static int n = 25;
//- (void)createDistrabuteView{
//    CGFloat percandlePriceHeight = (self.ChartHeight * CandleScale) / 6.0;
//
//    CGFloat distrViewH = (percandlePriceHeight * 4 - (n + 1)* 1) / (n * 1.0);
//    for (int i = 0; i < n; i ++) {
//
//        ZTYDistrabuteView * distrabuteView = [[ZTYDistrabuteView alloc] initWithFrame:CGRectMake(0, 0 + percandlePriceHeight + (distrViewH + 1) * i, 0, distrViewH)];
//        //[self distrabuteView:CGRectMake(0, headerHeight + percandlePriceHeight + (distrViewH + 1) * i, 10, distrViewH)];
//        distrabuteView.tag = 5000+i;
//        [self.candleChartView addSubview:distrabuteView];
//
//    }
//}
//
//- (void)showDistrabute:(NSArray *)dataArr max:(CGFloat)maxValue min:(CGFloat)minvalue left:(CGFloat)left{
//
//    NSDictionary * distrabuteDict =  [BTECalculateDistrabutionValue getDictwithKlineArray:dataArr max:maxValue min:minvalue count:n];
//    double max = [[distrabuteDict objectForKey:@"max"] doubleValue];
//    int maxindex = [[distrabuteDict objectForKey:@"maxindex"] intValue];
//    if (!isinf(max)){
//        for (int i = 0; i < n; i ++) {
//            BTEDistributionModel * model = [distrabuteDict objectForKey:[NSString stringWithFormat:@"distribution%d",i]];
//            ZTYDistrabuteView * view = [self.kLineBGView viewWithTag:5000 + i];
//            CGRect tempframe = view.frame;
//            tempframe.origin.x = left;
//            tempframe.size.width = 300 * model.distribution / max;
//            if (!isnan(model.distribution)) {
//                view.frame = tempframe;
//            }
//            if (i == maxindex) {
//                [view hideLine:NO];
//            }else{
//                [view hideLine:YES];
//            }
//        }
//    }
//}
//
//- (UIView *)distrabuteView:(CGRect)frame{
//    UIView * view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor colorWithHexString:@"D5E3FF"];
//    view.alpha = 0.5;
//    return view;
//}

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
    
    if (_volumeView.showbuySell == 2) {
        _volumePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumeView.maxY/1000.0];
        _volumePrice.middlePriceLabel.text = [NSString stringWithFormat:@"%.2fk",0.0];
        _volumePrice.minPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumeView.maxY/1000.0];
    }else if (_volumeView.showbuySell == 3){
        _volumePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumeView.maxY/1000.0];
        _volumePrice.middlePriceLabel.text = [NSString stringWithFormat:@"%.2fk",0.0];
        _volumePrice.minPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumeView.maxY/1000.0];
    }
    else{
        _volumePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumeView.maxY/1000.0];
        
        _volumePrice.middlePriceLabel.text = [NSString stringWithFormat:@"%.2fk",((self.volumeView.maxY - self.volumeView.minY) * 0.5 + self.volumeView.minY)/1000.0];
        _volumePrice.minPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumeView.minY/1000.0];
    }
    
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
        _exchangeTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 107, 26 + 28 + 0.5, 91, 48 * 10) style:UITableViewStylePlain];
        _exchangeTableView.delegate = self;
        _exchangeTableView.dataSource = self;
        _exchangeTableView.rowHeight = 48;
        _exchangeTableView.hidden = YES;
        _exchangeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _exchangeTableView.userInteractionEnabled = NO;
        _exchangeTableView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        _exchangeTableView.tableFooterView = [UIView new];
    }
    return _exchangeTableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == _exchangeTableView) {
        ExchangeModel * model = [_exchangeArray objectAtIndex:indexPath.row];
        
        
        UILabel * exchangeLabel = [_headView viewWithTag:719];
        exchangeLabel.text = model.exchange;
        
        self.exchange = model.exchange;
        self.base = model.baseAsset;
        self.quote = model.quoteAsset;
        self.name = model.name;
        
        self.end = nil;
        self.title = self.base;
        
        [self resetData];
        _exchangeTableView.hidden = YES;
        [self updateBtnStatus:508 title:[NSString stringWithFormat:@"%@",model.name] imageHide:NO hideBackColor:[UIColor whiteColor]];
        
        [self requestData];
        
        if (self.loginBGView.hidden) {
            //            [self requestLatestfoundFlow];
            [self requestHistoryfoundFlow];
        }
    }
    
    
}

- (void)resetData{
    self.end = nil;
    self.start = nil;
    _isrelaod = 0;
    self.KLineDataArray = nil;
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    _candleChartView.commentArr = @[].copy;
    [_dataSource removeAllObjects];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _exchangeTableView || _bottomType == BottomTypeChatView) {
        return 0;
    }else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _exchangeTableView || _bottomType == BottomTypeChatView) {
        return [UIView new];
    }else{
        
        if (_bottomType == BottomTypeOrderChange) {
            BTEOrderHeadView * headview = [[BTEOrderHeadView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 40)];
            NSArray * titles = @[@"时间",@"方向",@"类型",@"价格",@"数量"];
            [headview setTitles:titles];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = LineBGColor;
            [headview addSubview:line];
            return headview;
        }else if (_bottomType == BottomTypeSuperDeep){
            UIView *percentView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 40)];
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
            
        }else if (_bottomType == BottomTypeTxs){
            UIView *percentView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 40)];
            percentView.backgroundColor = [UIColor whiteColor];
            NSArray * percentTitles = @[@"时间",@"类型",@"大额转账数量"];
            NSUInteger index = 0;
            CGFloat labelW = (SCREEN_WIDTH - 32) / 3.0;
            for (NSString * title in percentTitles) {
                
                CGRect frame = CGRectMake( 16 + labelW * index , 0, labelW, 40);
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
            BTEOrderHeadView * headview = [[BTEOrderHeadView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 40)];
            NSArray * titles = @[@"时间",@"方向",@"价格",@"数量",@"成交状态"];
            [headview setTitles:titles];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = LineBGColor;
            [headview addSubview:line];
            return headview;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _exchangeTableView) {
        return self.exchangeArray.count;
    }else{
        
        if (self.loginBGView.hidden) {
            NSArray * arr;
            if (_bottomType == BottomTypeOrderChange) {
                arr = [_bottomDict objectForKey:AbnormityKey];
            }else if (_bottomType == BottomTypeSuperDeep){
                arr = [_bottomDict objectForKey:DepthKey];
            }else if (_bottomType == BottomTypeOrderBreak){
                arr = [_bottomDict objectForKey:BurnedKey];
            }else if(_bottomType == BottomTypeTxs){
                arr = [_bottomDict objectForKey:WalletKey];
            }else{
                arr = @[];
            }
            return arr.count;
        }else{
            return 0;
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_exchangeTableView == tableView) {
        ExchangeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"exchange"];
        if (!cell) {
            cell =[[ExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"exchange"];
        }
        ExchangeModel * model = [self.exchangeArray objectAtIndex:indexPath.row];
        [cell configwidthModel:model];
        if (self.base == model.baseAsset && self.quote == model.quoteAsset && self.exchange == model.exchange && self.name == model.name) {
            cell.backgroundColor = [UIColor colorWithHexString:@"5cacf3" alpha:1];
        }else{
            cell.backgroundColor = [UIColor colorWithHexString:@"308cdd" alpha:1];
        }
        
        return cell;
    }else{
        
        
        if (_bottomType == BottomTypeOrderChange) {
            BTEBigOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AbnormityKey];
            if (!cell) {
                cell = [[BTEBigOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AbnormityKey];
            }
            NSArray * arr = [_bottomDict objectForKey:AbnormityKey];
            [cell configWithDict:arr[indexPath.row] isBurnedOrder:NO base:self.base];
            return cell;
        }else if (_bottomType == BottomTypeSuperDeep){
            BTEOrderDeepTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DepthKey];
            if (!cell) {
                cell = [[BTEOrderDeepTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DepthKey];
            }
            NSArray * arr = [_bottomDict objectForKey:DepthKey];
            
            [cell configDict:arr[indexPath.row] maxMindict:_bottomDict];
            return cell;
        }else if (_bottomType == BottomTypeTxs){
            BTEWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:WalletKey];
            if (!cell) {
                cell = [[BTEWalletTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WalletKey];
            }
            NSArray * arr = [_bottomDict objectForKey:WalletKey];
            
            [cell configDict:arr[indexPath.row]];
            return cell;
        }
        else{
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
        }else if (_bottomType == BottomTypeChatView){
            return 50;
        }else if (_bottomType == BottomTypeTxs){
            return [BTEWalletTableViewCell cellHeight];
        }else{
            return [BTEBigOrderTableViewCell cellHeight];
        }
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (_exchangeTableView == tableView) {
//        return 0;
//    }else{
//        if (_bottomType == BottomTypeSuperDeep) {
//            return 68 + [BTEOrderDeepTableViewCell cellHeight];
//        }else{
//            return 68;
//        }
//    }
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (_bottomType == BottomTypeSuperDeep) {
//        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 68 + [BTEOrderDeepTableViewCell cellHeight])];
//
//        UIView * logView = [self logBottomView];
//        logView.frame = CGRectMake(0, [BTEOrderDeepTableViewCell cellHeight], SCREEN_WIDTH, 68);
//        [bottomView addSubview:logView];
//        return bottomView;
//    }else{
//        return [self logBottomView];
//    }
//}

#pragma mark -- 初始化
- (UILabel *)createLabelTitle:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    label.adjustsFontSizeToFitWidth=YES;
    label.minimumScaleFactor=0.5;
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

- (UIView *)foundflowView{
    if (!_foundflowView) {
        
        _foundflowView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, foundHeight)];
        _foundflowView.backgroundColor = [UIColor whiteColor];
        [_itemScrollview addSubview:_foundflowView];
        
        ZTYFoundHeader * latestfoudHead = [[ZTYFoundHeader alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 14)];
        [self.foundflowView addSubview:latestfoudHead];
        [latestfoudHead setUpTitle:@"全网实时资金流向" right:@"单位：￥"];
        
        CGFloat lineW = (SCREEN_WIDTH - 32 - 2.5) / 4.0;
        UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(16, 50 + (44 + 0.5) * 4, SCREEN_WIDTH - 32, 0.5)];
        lineview.backgroundColor = LineBGColor;
        [self.foundflowView addSubview:lineview];
        
        UIView * ver2Lineview = [[UIView alloc] initWithFrame:CGRectMake(16 + (lineW + 0.5) * 4 , 50 , 0.5, (44 + 0.5) * 4)];
        ver2Lineview.backgroundColor = LineBGColor;
        [self.foundflowView addSubview:ver2Lineview];
        NSArray * headArr = @[@"时间",@"买入",@"卖出",@"净流入"];
        for (int i = 0; i < 4; i ++) {
            
            for (int j = 0; j < 4; j ++) {
                UILabel * label = [self createLabelTitle:[NSString stringWithFormat:@""] frame:CGRectMake(16 + 0.5 + j * (lineW + 0.5), 50 + 0.5 + i * (44+ 0.5), lineW, 44)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
                [self.foundflowView addSubview:label];
                label.tag = i * 10 + j;
                if (i == 0) {
                    label.text = headArr[j];
                    label.backgroundColor = [UIColor colorWithHexString:@"EDF0F2"];
                }else{
                    if (j == 1) {
                        label.textColor = [UIColor colorWithHexString:@"228B22"];
                    }
                    if (j == 2) {
                        label.textColor = [UIColor colorWithHexString:@"FF4040"];
                    }
                    if (j == 3) {
                        label.textColor = [UIColor colorWithHexString:@"FF4040"];
                    }
                }
            }
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(16, 50 + (44 + 0.5) * i, SCREEN_WIDTH - 32, 0.5)];
            view.backgroundColor = LineBGColor;
            [self.foundflowView addSubview:view];
            UIView * verLineview = [[UIView alloc] initWithFrame:CGRectMake(16 + (lineW + 0.5) * i, 50 , 0.5, 44 * 4 + 2)];
            verLineview.backgroundColor = LineBGColor;
            [self.foundflowView addSubview:verLineview];
        }
        
        UIView * histroryLine = [[UIView alloc] initWithFrame:CGRectMake(0, 248, SCREEN_WIDTH, 0.5)];
        histroryLine.backgroundColor = LineBGColor;
        [self.foundflowView addSubview:histroryLine];
        ZTYFoundHeader * historyfoudHead = [[ZTYFoundHeader alloc] initWithFrame:CGRectMake(0, 268, SCREEN_WIDTH, 14)];
        [self.foundflowView addSubview:historyfoudHead];
        [historyfoudHead setUpTitle:@"历史资金流向" right:@""];
        
        UIScrollView * scrollView = [UIScrollView new];
        [self.foundflowView addSubview:scrollView];
        scrollView.backgroundColor =  [UIColor whiteColor];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.foundflowView).offset(302);
            make.left.equalTo(self.foundflowView).offset(44);
            make.right.equalTo(self.foundflowView).offset(0);
            make.height.equalTo(@(170));
        }];
        //        UIView * klineview = [[UIView alloc] initWithFrame:CGRectMake(44, 301.5, SCREEN_WIDTH - 44, 0.5)];
        //        klineview.backgroundColor = LineBGColor;
        //        [self.foundflowView addSubview:klineview];
        ZTYCommonChartView * candle = [ZTYCommonChartView new];
        [scrollView addSubview:candle];
        
        candle.mainchartType = MainChartcenterViewTypeKline;
        candle.lineCount = 3;
        [candle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scrollView);
            make.left.equalTo(scrollView);
            make.right.equalTo(scrollView);
            make.height.equalTo(@(170));
        }];
        candle.backgroundColor = [UIColor whiteColor];
        candle.candleSpace = 2;
        candle.displayCount = 120;
        candle.lineWidth = 1*widthradio;
        _candle = candle;
        
        
        
        UILabel * maxPLabel = [self createLabelTitle:@"" frame:CGRectMake(0, 302, 40, 10)];
        maxPLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        maxPLabel.tag = 300;
        [self.foundflowView addSubview:maxPLabel];
        
        UILabel * maxMPLabel = [self createLabelTitle:@"" frame:CGRectMake(0, 302 + (170 - 15) * 0.33 - 5, 40, 10)];
        maxMPLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        maxMPLabel.tag = 301;
        [self.foundflowView addSubview:maxMPLabel];
        
        UILabel * minMPLabel = [self createLabelTitle:@"" frame:CGRectMake(0, 302 + (170 - 15) * 0.66 - 5, 40, 10)];
        minMPLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        minMPLabel.tag = 302;
        [self.foundflowView addSubview:minMPLabel];
        
        UILabel * minPLabel = [self createLabelTitle:@"" frame:CGRectMake(0, 302 + (170 - 15) - 10, 40, 10)];
        minPLabel.tag = 303;
        minPLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        [self.foundflowView addSubview:minPLabel];
        
        //        UIView * bottomBGView = [self logBottomView];
        //        [self.foundflowView addSubview:bottomBGView];
        //        = [[UIView alloc] initWithFrame:CGRectMake(0, foundHeight, SCREEN_WIDTH, 68)];
        //        bottomBGView.backgroundColor = [UIColor colorWithHexString:@"EDF0F2"];
        //        [self.foundflowView addSubview:bottomBGView];
        //
        //        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 209) * 0.5, 20, 209, 27)];
        //        imageView.image = [UIImage imageNamed:@"bteBTLog"];
        //        [bottomBGView addSubview:imageView];
    }
    return _foundflowView;
}

- (void)getFoundKlineData:(NSArray*)dataArr{
    
    _candle.dataArray = dataArr.mutableCopy;
    [_candle stockFill];
    
    UILabel * maxPLabel = [self.foundflowView viewWithTag:300];
    
    UILabel * maxMPLabel = [self.foundflowView viewWithTag:301];
    
    UILabel * minMPLabel = [self.foundflowView viewWithTag:302];
    
    UILabel * minPLabel = [self.foundflowView viewWithTag:303];
    
    
    double maxValue = _candle.maxY;
    double minValue = _candle.minY;
    
    maxPLabel.text = [self formatwithNum:maxValue];
    
    maxMPLabel.text = [self formatwithNum:((maxValue - minValue) * 0.6666 + minValue)];
    minMPLabel.text = [self formatwithNum:((maxValue - minValue)* 0.3333 + minValue)];
    minPLabel.text = [self formatwithNum:minValue];
    
}

- (void)updateLatestFoundflow:(NSDictionary *)dict{
    NSArray * timeArr = [dict objectForKey:@"time"];
    int i = 1;
    for (NSDictionary * subdict in timeArr) {
        
        UILabel * timelabel = [self.foundflowView viewWithTag:(i * 10)];
        timelabel.text = [subdict objectForKey:@"name"];
        
        UILabel * buylabel = [self.foundflowView viewWithTag:(i * 10 + 1)];
        buylabel.text = [subdict objectForKey:@"buy"];
        
        UILabel * sellLabel = [self.foundflowView viewWithTag:(i * 10 + 2)];
        sellLabel.text = [subdict objectForKey:@"sell"];
        
        UILabel * netlabel = [self.foundflowView viewWithTag:(i * 10 + 3)];
        netlabel.text = [subdict objectForKey:@"net"];
        i ++;
    }
}

- (void)updateFoundflow:(NSDictionary *)dict{
    
    NSArray * timeArr = [dict objectForKey:@"trade"];
    int i = 1;
    for (NSDictionary * subdict in timeArr) {
        
        UILabel * timelabel = [self.foundflowView viewWithTag:(i * 10)];
        timelabel.text = [subdict objectForKey:@"name"];
        
        UILabel * buylabel = [self.foundflowView viewWithTag:(i * 10 + 1)];
        buylabel.text = [NSString stringWithFormat:@"%@",[self formatwithNum:[[subdict objectForKey:@"buy"] doubleValue]]];//[subdict objectForKey:@"buy"];
        
        UILabel * sellLabel = [self.foundflowView viewWithTag:(i * 10 + 2)];
        sellLabel.text = [NSString stringWithFormat:@"%@",[self formatwithNum:[[subdict objectForKey:@"sell"] doubleValue]]];
        
        UILabel * netlabel = [self.foundflowView viewWithTag:(i * 10 + 3)];
        netlabel.text = [NSString stringWithFormat:@"%@",[self formatwithNum:[[subdict objectForKey:@"net"] doubleValue]]];
        
        if ([[subdict objectForKey:@"net"] doubleValue] > 0) {
            netlabel.textColor = [UIColor colorWithHexString:@"228B22"];
        }else{
            
            netlabel.textColor = [UIColor colorWithHexString:@"FF4040"];
        }
        i ++;
    }
    
    NSArray * klineArr = [dict objectForKey:@"kline"];
    
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    for (NSArray * subArr in klineArr) {
        ZTYChartModel * model = [[ZTYChartModel alloc] init];
        [model initBaseDataWithArray:subArr];
        [dataArray addObject:model];
    }
//    for (int i = 0; i < klineArr.count; i ++) {
//        NSArray * subArr = klineArr[klineArr.count - 1 - i];
//        ZTYChartModel * model = [[ZTYChartModel alloc] init];
//        [model initBaseDataWithArray:subArr];
//        [dataArray addObject:model];
//    }
    
    if (dataArray.count < 100) {
        _candle.displayCount = dataArray.count < MinCount?MinCount:dataArray.count;
    }
    [self getFoundKlineData:dataArray];
    
    
}

- (NSString *)formatwithNum:(double )number{
    //    double number = [num doubleValue];
    if(number == 0){
        return @"0";
    }else if (ABS(number) >= 1000000000000){
        return [NSString stringWithFormat:@"%.2f万亿",number / 1000000000000.0];
    }else if (ABS(number) >= 100000000.0){
        return [NSString stringWithFormat:@"%.2f亿",number / 100000000.0];
    }else if (ABS(number) > 10000 ) {
        return [NSString stringWithFormat:@"%.2f万",number / 10000.0];
    }
    else{
        return [NSString stringWithFormat:@"%.2f",number];
    }
}

- (UIView *)logBottomView{
    UIView * bottomBGView = [[UIView alloc] initWithFrame:CGRectMake(0, foundHeight, SCREEN_WIDTH, 68)];
    bottomBGView.backgroundColor = [UIColor colorWithHexString:@"EDF0F2"];
    [self.foundflowView addSubview:bottomBGView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 290) * 0.5, 20, 290, 27)];
    imageView.image = [UIImage imageNamed:@"bteBTLog"];
    [bottomBGView addSubview:imageView];
    return bottomBGView;
}

#pragma mark Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 分享
- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"kshare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (void)shareAlert
{
    
    [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:kGetcontractDogUrl sharetitle:nil shareDesc:nil shareType:UMS_SHARE_TYPE_IMAGE captionImg:[ZTYScreenshot screenshotImage] currentVc:self];
    
}

- (void)dealloc{
    NSLog(@"合约狗dealloc");
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
                
                [[EMClient sharedClient] loginWithUsername:User.hxuserName password:User.hxuserPassword completion:^(NSString *aUsername, EMError *aError) {
                    if (!aError) {
                        [self setUnreadMessageCountByChatRoomId];
                        [self gotoChatRoomTopWith:self.chatRoomId];
                    }else{
                        NSLog(@"---loginWithUsername--password---aerror--->%@",aError.errorDescription);
                    }
                }];
            }else{
                [self setUnreadMessageCountByChatRoomId];
                NSLog(@"isAutoLogin---true----->%d",isAutoLogin);
                [self gotoChatRoomTopWith:self.chatRoomId];
            }
        }else{
            [self gotoChatRoomTopWith:self.chatRoomId];
//            AddNickHeaderView *v = [[AddNickHeaderView alloc] initAddNickHeadView];
//            v.roomName = @"FUTURE";
//            [v setConfirmCallBack:^(BOOL isComplete, NSString *chatRoomId) {
//                if (isComplete) {
//                    NSLog(@"isComplete----chatRoomId---->%@",chatRoomId);
//                    self.chatRoomId = chatRoomId;
//                    [self setUnreadMessageCountByChatRoomId];
//                    [self gotoChatRoomTopWith:chatRoomId];
//                    loginUserFlag = 1;
//                }else{
//                    [self recoverOriginStatus];
//                }
//            }];
            
        }
        self.assistiveBtn.userInteractionEnabled = YES;
    }else{
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            if (isComplete) {
                [self getUserInfo];

            }else{
                [self recoverOriginStatus];
            }
        }];
        self.assistiveBtn.userInteractionEnabled = YES;
        return;
    }
}

- (void)recoverOriginStatus{
    NSInteger tag = 900 + _tempbottomType;
    //    if (_tempbottomType == BottomTypeOrderChange) {
    //        tag = 900;
    //    }else if (_tempbottomType == BottomTypeSuperDeep){
    //        tag = 901;
    //    }else if (_tempbottomType == BottomTypeOrderBreak){
    //        tag = 902;
    //    }else if (_tempbottomType == BottomTypeFoundFlow){
    //        tag = 903;
    //    }
    UIButton * btn = [self.bottomView viewWithTag:tag];
    [self itemTabelChose:btn];
}

#pragma 切换到聊天会话页面 更加群里ID 去进入相对应的群组
//-(void)gotoChatRoomTopWith:(NSString *)chatRoomStr{
//    NSLog(@"gotoChatRoomTopWith----->%d",chatRoomStr);
//    CGFloat tableBtnHeight = 42;
//
//
//    self.itemScrollview.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeigth , SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
//
//    _rootScrollView.contentOffset = CGPointMake(0, self.ChartHeight + headerHeight + 8);
//    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:chatRoomStr conversationType:EMConversationTypeGroupChat];
//    [self addChildViewController:chatController];
//    chatController.base = self.base;
//    chatController.quote = self.quote;
//    chatController.exchange = self.exchange;
//    [chatController startChat];
//    [self.itemScrollview addSubview:chatController.view];
//
//    chatController.view.frame = CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
//
//    chatController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//
//    chatController.chatdelegate = self;
//    self.topImageView.hidden = YES;
//    self.assistiveBtn.userInteractionEnabled = YES;
//}

-(void)gotoChatRoomTopWith:(NSString *)chatRoomStr{
    CGFloat tableBtnHeight = 42;
    
    _itemScrollview.frame = CGRectMake(0, headerHeight + self.ChartHeight+bottomHeigth , SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
    _rootScrollView.contentOffset = CGPointMake(0, self.ChartHeight + headerHeight + 8);
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:chatRoomStr conversationType:EMConversationTypeGroupChat];
    
    chatController.base = self.base;
    chatController.quote = self.quote;
    chatController.exchange = self.exchange;
    
    chatController.view.frame = CGRectMake(SCREEN_WIDTH * 5, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - tableBtnHeight);
    
    chatController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.itemScrollview addSubview:chatController.view];
    
    [self addChildViewController:chatController];
    chatController.chatdelegate = self;
    
    self.chatVC = chatController;
    self.assistiveBtn.userInteractionEnabled = YES;
    
    self.topImageView.hidden = YES;
}

- (void)gotoSuperViewTop {
    UIButton * button = [self.bottomView viewWithTag:900];
    [self itemTabelChose:button];
    [self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma 根据群组ID获取聊会会话页面未读消息数
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
        
    }
}


#pragma 获取该账户是否注册绑定了环信服务器
- (void)getWhetherRegisterHX{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kWhetherRegisterHX;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            loginUserFlag = [responseObject[@"data"][@"loginUserVO"] integerValue];
//            if (loginUserFlag) {
                [self AddUserAndRoomHX];
//            }
        }
    } failure:^(NSError *error) {
        RequestError(error);
    }];
}

#pragma 添加该账户到环信服务器 获取环信账号密码 已经群组的聊天室ID
- (void)AddUserAndRoomHX{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"FUTURE" forKey:@"roomName"];
    [pramaDic setObject:nickNameStr forKey:@"nickName"];
    [pramaDic setObject:headPicStr forKey:@"headImage"];
    methodName = kAddUserAndRoom;
    NSLog(@"AddUserAndRoomHX--pramaDic-->%@",pramaDic);
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"AddUserAndRoomHX--responseObject-->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            User.hxuserName =  responseObject[@"data"][@"result"][@"userId"];
            User.hxuserPassword = responseObject[@"data"][@"result"][@"password"];
            User.nickName = responseObject[@"data"][@"result"][@"nickName"];
            self.chatRoomId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupid"]];
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
    
    
    self.badgeView = [[JSBadgeView alloc] initWithParentView:self.hiddenImageView alignment:JSBadgeViewAlignmentTopRight];
    self.badgeView.badgeBackgroundColor = BHHexColor(@"F01313");
    self.badgeView.badgeOverlayColor =  BHHexColor(@"F01313");//没有反光面
    self.badgeView.badgeStrokeColor = BHHexColor(@"F01313");//外圈的颜色，默认是白色
}

-(void)p_clickBtn{
    
    UIButton * button = [self.bottomView viewWithTag:905];
    [self itemTabelChose:button];
    
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
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:@"FUTURE" forKey:@"base"];
    methodName = kGetRoomInfo;
    NSLog(@"GetRoomInfo---pramaDic----->%@",pramaDic);
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"GetRoomInfo-------->%@",responseObject);
        //        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            [weakSelf dealChatdata:responseObject];
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
    }];
}

- (void)dealChatdata:(NSDictionary *)dataDict{
    NSNumber * countNumber = dataDict[@"data"][@"result"];
    self.chatOnLineNumStr = [NSString stringWithFormat:@"在线人数%@",countNumber];
    UILabel * countlabel = [self.bottomView viewWithTag:222];
    countlabel.text = [NSString stringWithFormat:@"%@人",countNumber];
    UILabel * fcountlabel = [self.floatBottomView viewWithTag:222];
    fcountlabel.text = [NSString stringWithFormat:@"%@人",countNumber];
    self.chatOnLineNumStrLabel.text = self.chatOnLineNumStr;
    NSLog(@"self.chatOnLineNumStr-------->%@",self.chatOnLineNumStr);
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

@end

