//
//  BTEFullScreenKlineViewController.m
//  BTE
//
//  Created by wanmeizty on 2018/5/21.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEFullScreenKlineViewController.h"

#import "ZTYChartModel.h"
#import "ZTYQuoteChartView.h"
//#import "ZYWCalcuteTool.h"
#import "ZYWPriceView.h"

#import "ZTYChartProtocol.h"
//#import "ZYWCandlePostionModel.h"
#import "ZTYCandlePosionModel.h"
//#import "BTEFSKLineViewController.h"
#import "BTEFullScreenKlineViewController.h"
//#import "ZXQuotaDataReformer.h"
#import "ZTYDataReformator.h"
//#import "ZTYMainKChartView.h"
#import "ZTYMainView.h"
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
#import "SecondaryLevelWebViewController.h"
#import "BTELoginVC.h"
#import "BTESaveDataUtil.h"
//#import "ZTYDistrabuteView.h"
//#import "BTECalculateDistrabutionValue.h"
#import "ZTYTradeDistrabuteView.h"
#define ScrollScale 1.00
#define CandleScale 0.55
#define VolumeScale 0.18
#define QuotaScale 0.27


#define commentWidth 48

#define headerHeight 68





@interface BTEFullScreenKlineViewController ()<UITableViewDelegate,UITableViewDataSource,ZTYChartProtocol>
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
@property (nonatomic,strong) UIView * ktypeBGView,*mainQuotaTypeBGView,*fitureQuotaBGView;
@property (nonatomic,strong) UILabel * descLabel,*roseDropLabel,*mainTextLabel,*volumTextLabel,*fitureTextLabel;

@property (nonatomic,strong) UILabel * verticalLabel;
@property (nonatomic,strong) UIView *verticalView;
@property (nonatomic,strong) UIView *leavView;
//@property (nonatomic,strong) ZTYLineTextView * lineTextView;
@property (nonatomic,strong) ZTYLineTextView * latestLinetextView;

@property (nonatomic,strong) ZTYChartModel * latestModel;
@property (nonatomic,assign) CGFloat latesetClose;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString * ktype;
@property (nonatomic,copy) NSString * end;

@property (nonatomic,copy) NSString * start;
@property (nonatomic,assign) CGFloat ChartHeight;
@property (nonatomic,assign) int isrelaod; // 加载更多刷新

@property (nonatomic,strong) NSArray * klineTypes;


@property (nonatomic,strong) UITableView * exchangeTableView;
@property (nonatomic,strong) NSMutableArray * exchangeArray;

@property (nonatomic,strong) UIButton * combtn;


@property (nonatomic,strong) NSTimer * timer;


@property (nonatomic,strong) NSArray * optionArray;
@property (nonatomic,copy) NSString * optionId;
@property (assign,nonatomic) CGFloat changeWidth;
@end

@implementation BTEFullScreenKlineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self statusHide];

    [self initData];
    
    [self addSubViews];
    [self addBottomViews];
    [self addPriceView];
    [self initCrossLine];
    [self addChartTitle];
    [self addActivityView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    
    UITapGestureRecognizer *  tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.kLineBGView addGestureRecognizer:tap];
    
    [self requestData];
    [self getSelfSelectList];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startClock) userInfo:nil repeats:YES];
    
    //  关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    
    [self getLocalData];
}

- (void)getLocalData{
    NSString * dataKey = [NSString stringWithFormat:@"commont-%@-KEY",self.base];
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

- (void)initData{
    _isrelaod = 0;
    self.ktype = @"1h";
    self.ChartHeight = (SCREEN_WIDTH - headerHeight)* ScrollScale;
    _exchangeArray = [NSMutableArray array];
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
    clockCount --;
    if (clockCount < 0) {
        [self requestLastModelData];
        clockCount = 3;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.timer) {
        clockCount = 3;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startClock) userInfo:nil repeats:YES];
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
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

// 顶部视图
- (void)addHeaderView{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 24 + 44)];
    [self.kLineBGView addSubview:_headView];
    
    
    NSString * priceAndPer = [NSString stringWithFormat:@"%@  %.2f%%",[ZTYCalCuteNumber calculate:[self.desListModel.price floatValue]],[self.desListModel.change floatValue]];
    NSString * descStr = [NSString stringWithFormat:@"%@",priceAndPer];
    
    
    UILabel * descLabel = [self createLabelTitle:descStr frame:CGRectMake(122, 0, 200, 44)];
    //    descLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:30];
    //    descLabel.textColor = [UIColor colorWithHexString:@"FF4040"];
    [_headView addSubview:descLabel];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:descLabel.text];
    //    NSRange range = [descLabel.text rangeOfString:[NSString stringWithFormat:@"%@",self.model.symbol]];
    //    [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:12] range:range];
    NSRange range1 = [descLabel.text rangeOfString:priceAndPer];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF4040"] range:range1];
    descLabel.tag = 900;
    descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];;
    descLabel.textColor = [UIColor colorWithHexString:@"FF4040"];
    descLabel.attributedText = attributeString;
    
    //    UILabel * infoLabel = [self createLabelTitle:@"高13.2987  低11.0900  24H17883370" frame:CGRectMake(SCREEN_WIDTH * 0.5, 0, SCREEN_WIDTH * 0.5 - 46, 44)];
    //    infoLabel.textAlignment = NSTextAlignmentRight;
    //    [_headView addSubview:infoLabel];
    
    
    
    
    UIButton * halfBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 44, 0, 44, 44)];
    [halfBtn setImage:[UIImage imageNamed:@"retract"] forState:UIControlStateNormal];
    [halfBtn setImageEdgeInsets:UIEdgeInsetsMake(17, 17, 17, 17)];
    [halfBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:halfBtn];
    
    
    UIButton * selectSelf = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 44 - 22 - commentWidth , 7, 32, 30)];
    [selectSelf addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
//    [selectSelf setImage:[UIImage imageNamed:@"select_add"] forState:UIControlStateNormal];
//    [selectSelf setImage:[UIImage imageNamed:@"select_sub"] forState:UIControlStateSelected];
    selectSelf.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [selectSelf setTitle:@"+自选" forState:UIControlStateNormal];
    [selectSelf setTitle:@"-自选" forState:UIControlStateSelected];
    [selectSelf setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateSelected];
    [selectSelf setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
    selectSelf.tag = 509;
    [_headView addSubview:selectSelf];
    
    NSString * pair = @"okex RUFF/USDT";
    if (self.desListModel.symbol.length>0 && self.desListModel.quote.length > 0 && self.desListModel.exchange.length > 0) {
        pair = [NSString stringWithFormat:@"%@ %@/%@",self.desListModel.exchange,self.desListModel.symbol,self.desListModel.quote];
    }
    if (self.base.length > 0 && self.quote.length >0) {
        pair = [NSString stringWithFormat:@"%@ %@/%@",self.exchange,self.base,self.quote];
    }
    
    UIButton * exchangeBtn = [self createBtnTiltle:pair frame:CGRectMake(10, 0, 102, 44)];
    [exchangeBtn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
    exchangeBtn.tag = 503;
    [_headView addSubview:exchangeBtn];
    
    
    CGFloat width = [pair sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]}].width;
    self.changeWidth = width;
    exchangeBtn.frame = CGRectMake(10, 0, width, 44);
    [self updateBtnStatus:503 title:pair imageHide:NO color:[UIColor whiteColor]];
    
    //    UILabel * exchangeLabel = [_headView viewWithTag:800];
    //    exchangeLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"exchange"]];
    
    UIButton *noteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 44 - 24, 7 , 24, 30) ];
    //    [noteBtn setImage:[UIImage imageNamed:@"full_screen"] forState:UIControlStateNormal];
    [noteBtn setTitle:@"盯盘" forState:UIControlStateNormal];
    [noteBtn setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
    [noteBtn addTarget:self action:@selector(noteclick:) forControlEvents:UIControlEventTouchUpInside];
    noteBtn.tag = 666;
    noteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_headView addSubview:noteBtn];
    
    NSArray * arr = @[@"1小时",@"MA",@"MACD"];
    for (int i = 0; i < 3; i ++) {
        
        UIButton * btn = [self createBtnTiltle:arr[i] frame:CGRectMake((KbtnWidth +intalval) * i + SCREEN_HEIGHT - 44 - 30 - commentWidth - (KbtnWidth + intalval)* 3 + intalval, 0, KbtnWidth, 44)];
        [btn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 500 + i;
        [_headView addSubview:btn];
        
    }
    
    
    UIView * infoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_HEIGHT, 24)];
    infoBGView.backgroundColor = KBGColor;
    [_headView addSubview:infoBGView];
    
    UILabel * label = [self createLabelTitle:@"2018-05-18 11:00   涨幅:0.27%   振幅:0.44%   开:7991.19   高:8019.17   低:7984.21   收:8009.00" frame:CGRectMake(16, 0, SCREEN_HEIGHT - 32, 24)];
    //    label.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    label.backgroundColor = KBGColor;
    label.font = [UIFont fontWithName:@"DINAlternate-Bold" size:10]; //[UIFont fontWithName:@"PingFangSC-Regular" size:10];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    [infoBGView addSubview:label];
    _descLabel = label;
    
}


- (void)addQuotaBorderView
{
    UIView *bottomLineView = [UIView new];
    [self.kLineBGView addSubview:bottomLineView];
    bottomLineView.userInteractionEnabled = NO;
    bottomLineView.backgroundColor = LineBGColor;
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight + headerHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.kLineBGView).offset(1);
        make.height.equalTo(@(1));
    }];
    
    UIView * volumeBottomLine = [UIView new];
    [self.kLineBGView addSubview:volumeBottomLine];
    volumeBottomLine.userInteractionEnabled = NO;
    volumeBottomLine.backgroundColor = LineBGColor;
    [volumeBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight * (CandleScale + VolumeScale) + headerHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.kLineBGView).offset(1);
        make.height.equalTo(@(1));
    }];
    
    UIView * mainViewBottomLine = [UIView new];
    [self.kLineBGView addSubview:mainViewBottomLine];
    mainViewBottomLine.userInteractionEnabled = NO;
    mainViewBottomLine.backgroundColor = LineBGColor;
    [mainViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight * (CandleScale) + headerHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.kLineBGView).offset(1);
        make.height.equalTo(@(1));
    }];
}

#pragma mark --event
- (void)close{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)comment:(UIButton *)btn{
    
    [self hiddenAllChoseBGView];
    _combtn.selected = !_combtn.selected;
    if (_combtn.selected) {
        
        
        _candleChartView.firstCommentShow = YES;
        self.ktype = @"1h";
        [self resetData];
        [self requestData];
        for (int i = 0; i < 10; i ++) {
            UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
            button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        }
        UIButton * hourBtn = [_ktypeBGView viewWithTag:2005];
        hourBtn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
        
        [self updateBtnStatus:500 title:@"1小时" imageHide:NO color:[UIColor whiteColor]];
        
        _candleChartView.isNotComment = NO;
        [_candleChartView showCommentBtns];
        
    }else{
        _candleChartView.isNotComment = YES;
        [_candleChartView hideCommentBtns];
    }
}

#pragma mark --按钮点击事件处理
- (void)changeBtn:(UIButton *)btn{
    if (_exchangeArray.count > 0) {
        //        _exchangeTableView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 264);
        _exchangeTableView.hidden = NO;
        [self updateBtnStatus:503 title:@"" imageHide:YES hideBackColor:[UIColor colorWithHexString:@"308cdd"]];
        [_exchangeTableView reloadData];
    }else{
        //        [self requestExchangeData];
    }
}

- (void)noteclick:(UIButton *)btn{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@?base=%@&quote=%@&exchange=%@", kAppKlineNoteAddress,self.base,self.quote,self.exchange];
    SecondaryLevelWebViewController * vc = [[SecondaryLevelWebViewController alloc] init];
    vc.urlString = urlStr;
    vc.isHiddenLeft = NO;
    vc.isHiddenBottom = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    BHNavigationController * navc = [[BHNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

// 全屏模式
- (void)clickFullScreen:(UIButton *)btn{
    if (btn.tag == 444) {
        BTEFullScreenKlineViewController * fvc = [[BTEFullScreenKlineViewController alloc] init];
        fvc.desListModel = self.desListModel;
        fvc.base = self.base;
        fvc.exchange = self.exchange;
        fvc.quote = self.quote;
        [self presentViewController:fvc animated:NO completion:nil];
    }else{
        
        [self hiddenAllChoseBGView];
        
        _combtn.selected = !_combtn.selected;
        if (_combtn.selected) {
            
            self.ktype = @"1h";
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
            [_candleChartView showCommentBtns];
            
        }else{
            _candleChartView.isNotComment = YES;
            [_candleChartView hideCommentBtns];
        }
        
        
    }
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
        _exchangeTableView.hidden = YES;
        [self updateBtnStatus:503 title:@"" imageHide:NO hideBackColor:[UIColor whiteColor]];
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
        
        // 交易所切换
        if (self.exchangeTableView.hidden) {
            if (_exchangeArray.count > 0) {
                self.exchangeTableView.hidden = NO;
                [self updateBtnStatus:503 title:@"" imageHide:YES color:[UIColor colorWithHexString:@"308cdd"]];
            }else{
                [self requestExchangeData];
            }
        }else{
            self.exchangeTableView.hidden = YES;
            [self updateBtnStatus:503 title:@"" imageHide:NO color:[UIColor whiteColor]];
        }
        
    }else if (btn.tag == 509){
        if (btn.selected == YES) {
            [self delSelfSelect];
        }else{
            [self addSelfSelect];
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
        CGFloat btnH = 44;
        _ktypeBGView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 3 * (KbtnWidth + intalval) -44 - 30 - commentWidth  + intalval, 44, KbtnWidth * 4, btnH * 3)];
        _ktypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_ktypeBGView];
        _ktypeBGView.hidden = YES;
        
        
        for (int index = 0; index < self.klineTypes.count; index ++) {
            
            UIButton * btn = [self createBtn:self.klineTypes[index] frame:CGRectMake((KbtnWidth+ 10) * (index %3) + 5, (index / 3) * 35, KbtnWidth, 28)];
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
    _combtn.selected = NO;
    
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
        CGFloat btnH = 44;
        NSArray * quotaArr = @[@"MA",@"EMA",@"BOLL",@"SAR",@"关闭"];
        _mainQuotaTypeBGView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - (KbtnWidth + intalval) * 2 -44 - 30 - commentWidth + intalval,44, KbtnWidth, quotaArr.count * btnH)];
        _mainQuotaTypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_mainQuotaTypeBGView];
        _mainQuotaTypeBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, 0 + index * btnH, KbtnWidth, btnH)];
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
        _fitureQuotaBGView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - (KbtnWidth + intalval)  - commentWidth - 44 - 30 + intalval,44, KbtnWidth, quotaArr.count * btnH)];
        _fitureQuotaBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.kLineBGView addSubview:_fitureQuotaBGView];
        _fitureQuotaBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, index * btnH, KbtnWidth, btnH)];
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
    
    _exchangeTableView.hidden = YES;
    [self updateBtnStatus:503 title:[NSString stringWithFormat:@"%@ %@/%@",self.exchange,self.base?self.base:self.desListModel.symbol,self.quote?self.quote:self.desListModel.quote] imageHide:NO hideBackColor:[UIColor whiteColor]];
}

#pragma mark -- 请求数据
- (void)requestData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    self.candleChartView.isFreshing = NO;
    param[@"type"] = self.ktype;
    param[@"size"] = @"400";
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
    }
    methodName = kGetKLineData;
    
    WS(weakSelf)
    
    if (!_activityView.animating) {
        //        NMShowLoadIng;
        
    }else{
        self.candleChartView.isFreshing = YES;
    }
    //
    NSLog(@"param======>%@",param);
    //    NMShowLoadIng;  //@"http://47.94.217.12:18081/app/api/kline/line" //
    [BTERequestTools requestWithURLString:kGetKLineData parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        [_activityView stopAnimating];
        if (IsSafeDictionary(responseObject)) {
            
            NSLog(@"responseObject======>%@",responseObject);
            NSArray * kDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"kline"];
            if (kDataArr.count > 0) {
                
                self.end = [NSString stringWithFormat:@"%@",[[kDataArr firstObject] objectForKey:@"date"]];
                
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
            
            if (self.dataSource.count > 0 && arry.count > 0 ) {
                ZTYChartModel * first = [self.dataSource firstObject];
                ZTYChartModel * last = [arry lastObject];
                first.preKlineModel = last;
            }
            [arry addObjectsFromArray:self.dataSource];
            self.dataSource = arry.mutableCopy;
            
//            NSArray *QuotaDataArray = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            NSArray *QuotaDataArray = [ZTYDataReformator initializeQuotaDataWithArray:self.dataSource];
            [weakSelf reloadData:QuotaDataArray reload:_isrelaod];
            
            
            if (self.dataSource.count > 0) {
                ZTYChartModel * lastModel = [self.dataSource lastObject];
                
                //                ZYWCandleModel * firstModel = [self.dataSource lastObject];
                self.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
                //                self.end = [NSString stringWithFormat:@"%ld",firstModel.timestamp];
                clockCount = 3;
                //开启定时器
                [weakSelf.timer setFireDate:[NSDate distantPast]];
                
            }
            
            if ([weakSelf.ktype isEqualToString:@"1h"] && _combtn.selected == YES) {
                [weakSelf getKlineComment];
            }
            
            if ([weakSelf.ktype isEqualToString:@"1h"]) {
                NSString * dataKey = [NSString stringWithFormat:@"commont-%@-KEY",self.base];
                [BTESaveDataUtil achiveKlineDataDict:responseObject key:dataKey];
            }
        }
    } failure:^(NSError *error) {
        [_activityView stopAnimating];
        //        NMRemovLoadIng;
        //        RequestError(error);
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
    
    [BTERequestTools requestWithURLString:kGetExchangeData parameters:param type:1 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            
            [dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ExchangeModel * model = [[ExchangeModel alloc] init];
                [model initwidthDict:obj];
                [self.exchangeArray addObject:model];
            }];
            [self updateBtnStatus:503 title:@"" imageHide:YES color:[UIColor colorWithHexString:@"308cdd"]];
            self.exchangeTableView.hidden = NO;
            [_exchangeTableView reloadData];
        }
    } failure:^(NSError *error) {
        
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
    
    NSLog(@"requestLastModelData:param====>%@",param);
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
            NSLog(@"\n requestLastModelData====>%@",responseObject);
            
            __block ZTYChartModel * preLastModel = [self.dataSource lastObject];
            
            [kDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                
                if ([[obj objectForKey:@"date"] integerValue] > [preLastModel.timestamp integerValue]) {
                    ZTYChartModel * model = [[ZTYChartModel alloc] init];
                    model.x = idx;
                    model.preKlineModel = preLastModel;
                    [model initBaseDataWithDict:obj];
                    [_dataSource addObject:model];
                    
                    preLastModel = model;
                }else if([[obj objectForKey:@"date"] integerValue] == [preLastModel.timestamp integerValue]){
                    [_dataSource removeLastObject];
                    ZTYChartModel * LastModel = [self.dataSource lastObject];
                    ZTYChartModel * model = [[ZTYChartModel alloc] init];
                    model.x = idx;
                    model.preKlineModel = LastModel;
                    [model initBaseDataWithDict:obj];
                    [_dataSource addObject:model];
                    
                    preLastModel = model;
                    
                }else{
                    
                    
                }
                
                
            }];
            
            
            
//            NSArray *QuotaDataArray = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            NSArray *QuotaDataArray = [ZTYDataReformator initializeQuotaDataWithArray:self.dataSource];
            [self reloadData:QuotaDataArray reload:2];
            
            
            
            self.latesetClose = [[[[responseObject objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
            //                [self.latestLinetextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:self.latesetClose]]];
            [weakSelf updateLatestTextLine];
            
            
            if (self.dataSource.count > 0) {
                ZTYChartModel * lastModel = [self.dataSource lastObject];
                
                self.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
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
    
    if (self.dataSource.count > 0) {
        ZTYChartModel * first = [self.dataSource firstObject];
        param[@"startTime"] = first.timestamp;
        
        ZTYChartModel * last = [self.dataSource lastObject];
        param[@"endTime"] = last.timestamp;
        
    }
    
    WS(weakSelf)
    
    NSLog(@"param======>%@",param);
    //    NMShowLoadIng;  //@"@"http://47.94.217.12:18081/app/api/klineComment/getHourShortComment"" //
    [BTERequestTools requestWithURLString:kGetKlineCommentList parameters:param type:2 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            
            NSLog(@"responseObject====>%@",responseObject);
            NSArray * list = [responseObject objectForKey:@"data"];
            
            if (list.count > 0) {
                NSMutableArray * tempArr = [NSMutableArray array];
                for (int index = 0; index < list.count; index ++) {
                    
                    NSDictionary * dict = [list objectAtIndex:(list.count - 1 - index)];
                    ZTYKlineComment * comment = [[ZTYKlineComment alloc] initWidthDict:dict];
                    [tempArr addObject:comment];
                }
                
                //                [self.commentArr addObjectsFromArray:tempArr];
                _combtn.selected = YES;
                _combtn.hidden = NO;
                
                NSArray * commentarr =  [tempArr sortedArrayUsingComparator:^NSComparisonResult(ZTYKlineComment * comment1, ZTYKlineComment * comment2) {
                    //                    return NSOrderedDescending;
                    if (comment1.klineDateTime.integerValue < comment2.klineDateTime.integerValue) {
                        return NSOrderedDescending;
                    }else{
                        return NSOrderedAscending;
                    }
                    
                }];
                
                weakSelf.candleChartView.isNotComment = NO;
                weakSelf.candleChartView.commentArr = commentarr.mutableCopy;
                [weakSelf.candleChartView showCommentBtns];
            }else{
                _combtn.hidden = YES;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getSelfSelectList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"token"];
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    
    WS(weakSelf)
    
    [BTERequestTools requestWithURLString:kGetOptionalList parameters:param type:3 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            
            
            _optionArray =[[responseObject objectForKey:@"data"] objectForKey:@"result"]; NSLog(@"responseObject====>%@",responseObject);
            
            [weakSelf performSelectorOnMainThread:@selector(dealOptionData) withObject:nil waitUntilDone:NO];
            
            
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)dealOptionData{
    
    WS(weakSelf)
    
    [_optionArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict objectForKey:@"base"] isEqualToString:self.base] && [[dict objectForKey:@"exchange"] isEqualToString:self.exchange] && [[dict objectForKey:@"quote"] isEqualToString:self.quote] ) {
            UIButton * btn = [weakSelf.headView viewWithTag:509];
            btn.selected = YES;
            weakSelf.optionId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            *stop = YES;
        }
    }];
}

- (void)addSelfSelect{
    
    
    if (!User.isLogin) {
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            
        }];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    if (self.base.length > 0 && self.exchange.length > 0 && self.quote.length > 0) {
        param[@"base"] = self.base;//@"btc";
        param[@"quote"] = self.quote; //@"btc/usdt";
        param[@"exchange"] = self.exchange;
    }
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    
    //    exchange=okex&base=BTC&quote=USDT
    
    WS(weakSelf)
    // http://47.94.217.12:18081/app/api/market/addOptional?exchange=okex&base=BTC&quote=USDT
    [BTERequestTools requestWithURLString:kGetAddOptional parameters:param type:3 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            
            
            UIButton * btn = [weakSelf.headView viewWithTag:509];
            btn.selected = YES;
            [BHToast showMessage:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] showTime:1.2 finished:nil withDirection:YES];
            
            
            [weakSelf getSelfSelectList];
            NSLog(@"responseObject====>%@",responseObject);
            
        }
    } failure:^(NSError *error) {
        
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
                
                [BHToast showMessage:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] showTime:1.2 finished:nil withDirection:YES];
            }
            
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark -- 头部数据更新
//- (void)updateHeadData:(NSDictionary *)dict{
//    UILabel * onedayLabel = [_headView viewWithTag:710];
//
//    NSString * onedaytext = [NSString stringWithFormat:@"24h量/额：%@/%@",[self caculateValue:[[dict objectForKey:@"vol"] doubleValue]],[NSString stringWithFormat:@"%@%@",[self caculateValue:[[dict objectForKey:@"amountVol"] doubleValue]],[dict objectForKey:@"pair"]]];
//    //    [onedayLabel setTitle:@"24h量/额：" value:onedaytext];
//    onedayLabel.text = onedaytext;
//
//    NSString * priceStr = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculateBesideLing:[[dict objectForKey:@"price"] doubleValue]]];
//
//    UILabel *pricelabel = [_headView viewWithTag:712];
//    pricelabel.text = priceStr;
//
//    CGFloat width = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:30]}].width ;
//    pricelabel.frame = CGRectMake(16, 16, width, 30);
//
//    UILabel *verbPriceLabel = [_headView viewWithTag:718];
//    verbPriceLabel.text = [NSString stringWithFormat:@"≈%.2lfCNY",[[dict objectForKey:@"cnyPrice"] doubleValue]];
//
//    UILabel *cnylabel = [_headView viewWithTag:711];
//
//    NSString * changestr = @"";
//
//    UIColor * changeColor = DropColor;
//    if ([[dict objectForKey:@"change"] floatValue] < 0) {
//        changestr = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"change"] floatValue] * 100];
//        changeColor = [UIColor colorWithHexString:@"FF4040"];
//    }else{
//        changestr = [NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"change"] floatValue] * 100];
//        changeColor = RoseColor;
//    }
//    NSString * cnyStr = [NSString stringWithFormat:@"%@%%",changestr];
//    NSMutableAttributedString * cnyatt = [[NSMutableAttributedString alloc] initWithString:cnyStr];
//    NSRange range = [cnyStr rangeOfString:[NSString stringWithFormat:@"%@%%",changestr]];
//    //    [cnyatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff4040"] range:range];
//
//    [cnyatt addAttribute:NSForegroundColorAttributeName value:changeColor range:range];
//    cnylabel.attributedText = cnyatt;
//
//    CGFloat cynwidth = [cnyStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]}].width + 20;
//    cnylabel.frame = CGRectMake(16 + width + 8, 16 + 18, cynwidth, 12);
//
//}

- (void)updateHeadData:(NSDictionary *)dict{
    
    NSString * changeString = [NSString stringWithFormat:@"%@ %@/%@",[dict objectForKey:@"exchange"],[dict objectForKey:@"symbol"],[dict objectForKey:@"pair"]];
    CGFloat width = [changeString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]}].width;
    UIButton * btn = [_headView viewWithTag:503];
    btn.frame = CGRectMake(10, 0, width, 44);
    self.exchangeTableView.width = width;
    self.changeWidth = width;
//    [self updateBtnStatus:503 title:changeString imageHide:NO color:[UIColor whiteColor]];
    
    //    UILabel * exchangeLabel = [_headView viewWithTag:800];
    //    exchangeLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"exchange"]];
    
    NSMutableAttributedString * attring = [[NSMutableAttributedString alloc] initWithString:changeString];
    
    NSRange rang = [changeString rangeOfString:[dict objectForKey:@"pair"]];
    [attring addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:10] range:rang];
    btn.titleLabel.attributedText = attring;
    
    
    NSString * changestr = @"";
    
    UIColor * changeColor = DropColor;
    if ([[dict objectForKey:@"change"] floatValue] < 0) {
        changestr = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"change"] floatValue] * 100];
        changeColor = [UIColor colorWithHexString:@"FF4040"];
    }else{
        changestr = [NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"change"] floatValue] * 100];
        changeColor = RoseColor;
    }
    
    NSString * cnyStr = [NSString stringWithFormat:@"%@%%",changestr];
    
    NSString * priceAndPer = [NSString stringWithFormat:@"%@ %@ ≈%@CNY",[ZTYCalCuteNumber calculateBesideLing:[[dict objectForKey:@"price"] doubleValue]],cnyStr,[dict objectForKey:@"cnyPrice"]];
    
    NSMutableAttributedString * cnyatt = [[NSMutableAttributedString alloc] initWithString:priceAndPer];
    NSRange range = [priceAndPer rangeOfString:[NSString stringWithFormat:@"%@",cnyStr]];
    [cnyatt addAttribute:NSForegroundColorAttributeName value:changeColor range:range];
    //    [cnyatt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:12] range:range];
    
    NSRange range2 = [priceAndPer rangeOfString:[NSString stringWithFormat:@"≈%@CNY",[dict objectForKey:@"cnyPrice"]]];
    [cnyatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:range2];
    //    [cnyatt addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"PingFangSC-Medium" size:14] range:range2];
    
    UILabel * changeLabel = [_headView viewWithTag:900];
    
    CGFloat cccwidth = [priceAndPer sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]}].width;
    changeLabel.frame = CGRectMake(width + 10, 0, cccwidth, 44);
    changeLabel.attributedText = cnyatt;
    
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
    _candleChartView = [ZTYMainView new];
    [_scrollView addSubview:_candleChartView];
    _candleChartView.mainquotaName = MainViewQuotaNameWithMA;
    _candleChartView.mainchartType = MainChartcenterViewTypeKline;
    _candleChartView.firstCommentShow = YES;
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
    _candleChartView.displayCount = CandleCount;
    _displayCount = _candleChartView.displayCount;
    _candleChartView.lineWidth = 1*widthradio;
    UITapGestureRecognizer * candleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(candleClick:)];
    [_candleChartView addGestureRecognizer:candleTap];
    
    CGFloat percandlePriceHeight = (self.ChartHeight * CandleScale) / 6.0;
    self.distrabuteView = [[ZTYTradeDistrabuteView alloc] initWithFrame:CGRectMake(0, percandlePriceHeight, SCREEN_HEIGHT - 57, percandlePriceHeight * 4) showCount:25];
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
        make.top.equalTo(_scrollView.mas_top).offset(BoxborderWidth);
        make.left.equalTo(_scrollView.mas_left).offset(-BoxborderWidth);
        make.right.equalTo(_scrollView.mas_right).offset(BoxborderWidth);
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
    
    
    ZTYNounLine * rightLine = [[ZTYNounLine alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 57, headerHeight, 9, self.ChartHeight)];
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
    [self addTopBoxView];
    [self addVolumView];
    [self addQuotaBorderView];
    [self addGestureToCandleView];
}

- (void)addKLineBGView{
    self.kLineBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
    [self.view addSubview:self.kLineBGView];
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
    self.verticalView.backgroundColor = LineBGColor;//[UIColor colorWithHexString:@"666666"];
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
    
    self.latestLinetextView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, -SCREEN_HEIGHT, SCREEN_HEIGHT - 5, 15)];
    [self.kLineBGView addSubview:self.latestLinetextView];
    
    //    self.lineTextView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_HEIGHT - 5, 20)];
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
//#pragma mark -- 交易分布
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
//        [_candleChartView addSubview:distrabuteView];
//
//    }
//
//}
//
//- (void)showDistrabute:(NSArray *)dataArray max:(CGFloat)maxvalue min:(CGFloat)minvalue left:(CGFloat)left{
//
//    NSDictionary * distrabuteDict =  [BTECalculateDistrabutionValue getDictwithKlineArray:dataArray max:maxvalue min:minvalue count:n];
//    double max = [[distrabuteDict objectForKey:@"max"] doubleValue];
//    int maxindex = [[distrabuteDict objectForKey:@"maxindex"] intValue];
//    if (!isinf(max)){
//        for (int i = 0; i < n; i ++) {
//            BTEDistributionModel * model = [distrabuteDict objectForKey:[NSString stringWithFormat:@"distribution%d",i]];
//            ZTYDistrabuteView * view = [self.kLineBGView viewWithTag:5000 + i];
//            CGRect tempframe = view.frame;
//            tempframe.origin.x = left;
//            tempframe.size.width = SCREEN_WIDTH * 0.6 * model.distribution / max;
//            if (!isnan(model.distribution) && max != 0) {
//                view.frame = tempframe;
//            }
//
//            if (i == maxindex ) {
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
//    //    view.alpha = 0.5;
//    return view;
//}

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
    [self updateDeslAndRosedrop:kLineModel];
    [self upddateChartViewModel:kLineModel];
    [self upddateQuotaViewModel:kLineModel];
    
}

- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)startIndex
{
    
    _verticalLabel.text = [NSString stringWithFormat:@"%@",kLineModel.timeStr];
    //    [_lineTextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:kLineModel.close]]];
    [self updateDeslAndRosedrop:kLineModel];
    [self upddateChartViewModel:kLineModel];
    [self upddateQuotaViewModel:kLineModel];
}


- (void)updateBtnStatus:(NSInteger)tag title:(NSString *)title imageHide:(BOOL) isHidden color:(UIColor*)showbackColor{
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
            button.backgroundColor = showbackColor;//[UIColor colorWithHexString:@"1e2237"];
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
    
    if (tag == 503) {
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
        if (self.exchange == nil || self.changeWidth == 0) {
            self.changeWidth = 102;
        }
        _exchangeTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 44,self.changeWidth, 48 * 6) style:UITableViewStylePlain];
        _exchangeTableView.delegate = self;
        _exchangeTableView.dataSource = self;
        _exchangeTableView.rowHeight = 48;
        _exchangeTableView.bounces = NO;
        _exchangeTableView.hidden = YES;
        _exchangeTableView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        _exchangeTableView.tableFooterView = [UIView new];
        [self.view addSubview:_exchangeTableView];
    }
    return _exchangeTableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExchangeModel * model = [_exchangeArray objectAtIndex:indexPath.row];
    //    UIButton * btn = [_headView viewWithTag:503];
    //    [btn setTitle:[NSString stringWithFormat:@"%@/%@",model.baseAsset,model.quoteAsset] forState:UIControlStateNormal];
    [self updateBtnStatus:503 title:[NSString stringWithFormat:@"%@  %@/%@",model.exchange,model.baseAsset,model.quoteAsset] imageHide:NO color:[UIColor whiteColor]];
    UILabel * exchangeNameLabel = [_headView viewWithTag:800];
    exchangeNameLabel.text = model.exchange;
    
    self.exchange = model.exchange;
    self.base = model.baseAsset;
    self.quote = model.quoteAsset;
    [self resetData];
    _exchangeTableView.hidden = YES;
    [self requestData];
    
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
    [_dataSource removeAllObjects];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.exchangeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
//    [cell configwidthModel:model width:SCREEN_WIDTH];
    return cell;
    
}

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

// 屏幕旋转
- (void)statusHide{
    self.view.transform = CGAffineTransformIdentity;
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    //设置bounds
    self.view.bounds = CGRectMake(0, 0, SCREEN_HEIGHT , SCREEN_WIDTH);
    
    //旋转view
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
//    //设置状态栏方向，超级重要。（只有设置了这个方向，才能改变弹出键盘的方向）
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//    //设置状态栏横屏
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//    //    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:@(UIInterfaceOrientationLandscapeRight)];
//    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

