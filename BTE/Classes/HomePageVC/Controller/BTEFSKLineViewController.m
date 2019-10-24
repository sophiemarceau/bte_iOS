//
//  BTEFSKLineViewController.m
//  BTE
//
//  Created by wanmeizty on 2018/6/4.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEFSKLineViewController.h"

#import "ZTYMainKChartView.h"
#import "ZTYVolumCahrtView.h"
#import "ZTYQuotaChartView.h"

#import "ZYWPriceView.h"

#import "ZXQuotaDataReformer.h"

#import "ZYWCandlePostionModel.h"

#import "ZTYLineTextView.h"
#import "ZYWCalcuteTool.h"
#import "ZTYNounLine.h"

#import "ExchangeTableViewCell.h"

#import "UILabel+leftAndRight.h"

#import "ZTYCalCuteNumber.h"

#import "ZTYKlineComment.h"
//#define bottomBtnH 32

//#define ChartHeight 408
#define CandleScale 0.54
#define VolumeScale 0.18
#define QuotaScale 0.27

//#define MinCount 30
//#define MaxCount 210

#define HeadHeight 68

#define btnWidth 49
#define intalval 5

#define commentWidth 0
//#define QuotaViewHeight

@interface BTEFSKLineViewController ()<ZTYChartProtocol,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic,strong) ZTYMainKChartView * candleChartView;
@property (nonatomic,strong) ZTYVolumCahrtView * volumView;
@property (nonatomic,strong) ZTYQuotaChartView * quotaChartView;

@property (nonatomic,strong) ZYWPriceView * candlePrice;
@property (nonatomic,strong) ZYWPriceView * quotaPrice,*volumePrice;

@property (nonatomic,strong) ZTYLineTextView * lineTextView;
@property (nonatomic,strong) ZTYLineTextView * latestLinetextView;

@property (nonatomic,strong) UIView * headView,*verticalView,*leavView,*topBoxView,*bottomView;
@property (nonatomic,strong) UIView * ktypeBGView,*mainQuotaTypeBGView,*fitureQuotaBGView;

@property (nonatomic,strong) UITableView * exchangeTableView;
@property (nonatomic,strong) NSMutableArray * exchangeArray;

@property (nonatomic,strong) UIActivityIndicatorView * activityView;

@property (nonatomic,strong) UILabel * descLabel,*mainTextLabel,*volumTextLabel,*fitureTextLabel,*verticalLabel;

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * end;
@property (nonatomic,copy) NSString * start;
@property (nonatomic,assign) int isrelaod;

@property (nonatomic, assign) NSUInteger zoomRightIndex;
@property (nonatomic, assign) CGFloat currentZoom;
@property (nonatomic, assign) NSInteger displayCount;
@property (nonatomic,assign) CGFloat ChartHeight;

@property (nonatomic,strong) NSTimer * timer;


@property (nonatomic,strong) ZTYChartModel * latestModel;
@property (nonatomic,assign) CGFloat latesetClose;

@property (nonatomic,strong) UIButton * combtn;

@property (nonatomic,strong) NSMutableArray * commentArr;

@end

@implementation BTEFSKLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self statusHide];
    
    
    _isrelaod = 0;
    self.type = @"1h";
    _exchangeArray = [NSMutableArray array];
    self.commentArr = [NSMutableArray array];
    self.ChartHeight = SCREEN_WIDTH - HeadHeight -1;
    
    [self createView];
    [self initCrossLine];
    [self addActivityView];
    [self requestData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(requestLastModelData) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
    // 关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 关闭定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)requestLastModelData{
    
    self.candleChartView.isFreshing = YES;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.type;
    param[@"size"] = @"5"; //
    //    param[@"client"] = @"ios";
    //    param[@"exchange"] = @"okex";
    //    param[@"symbol"] = @"btc";
    //    param[@"pair"] = @"btc/usdt";
    
    if (self.model.symbol.length > 0) {
        param[@"base"] = self.model.symbol;//@"btc";
    }
    
    if (self.base.length > 0) {
        param[@"base"] = self.base;//@"btc";
    }
    
    if (self.model.exchange.length > 0) {
        param[@"exchange"] = self.model.exchange;
    }
    
    if (self.exchange.length > 0) {
        param[@"exchange"] = self.exchange;
    }
    
    if (self.model.quote.length > 0) {
        param[@"quote"] = self.model.quote;
    }
    
    if (self.quote.length > 0) {
        param[@"quote"] = self.quote; //@"btc/usdt";
    }
    if (self.start) {
        param[@"start"] = self.start;
        //转为字符型
    }
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    
    
    WS(weakSelf)
    //    NMRemovLoadIng;
    //    NMShowLoadIng; //@"http://47.94.217.12:18081/app/api/kline/line"
    [BTERequestTools requestWithURLString:kGetKLineData parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        //        [_activityView stopAnimating];
        if (IsSafeDictionary(responseObject)) {
            NSArray * kDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"kline"];
            //            if (kDataArr.count > 0) {
            self.start = [NSString stringWithFormat:@"%@",[[kDataArr lastObject] objectForKey:@"date"]];
            
            __block ZTYChartModel * preLastModel = [self.dataSource lastObject];
            [weakSelf updateHeadData:[[responseObject objectForKey:@"data"] objectForKey:@"ticker"]];
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
            
            NSArray *QuotaDataArray = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            [self reloadData:QuotaDataArray reload:2];
            
            ZTYChartModel * latestModel = [_dataSource lastObject];
            
            self.latestModel = latestModel;
            
            self.latesetClose = [[[[responseObject objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
            
            [self updateLatestTextLine];
            
            //                CGFloat pointY = [_candleChartView getPointYculateValue:latestModel.open];
            //                if (pointY < HeadHeight ) {
            //                    pointY = 0;
            //                }
            //
            //                if (pointY > self.ChartHeight * CandleScale) {
            //                    pointY = self.ChartHeight * CandleScale;
            //                }
            //                [self.latestLinetextView mas_updateConstraints:^(MASConstraintMaker *make) {
            //                    make.top.mas_equalTo(pointY - 10 + HeadHeight );
            //                }];
            
            //            }
            
        }
        
    } failure:^(NSError *error) {
        
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)updateLatestTextLine{
    
    //    if (self.latestModel) {
    [self.latestLinetextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:self.latesetClose]]];
    CGFloat pointY = [_candleChartView getPointYculateValue:self.latesetClose];
    if (pointY < 0 ) {
        pointY = 20;
    }
    
    if ( pointY > self.ChartHeight * CandleScale) {
        pointY = self.ChartHeight * CandleScale;
    }
    [self.latestLinetextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pointY - 10 + HeadHeight);
    }];
    //    }
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
    
    //设置状态栏方向，超级重要。（只有设置了这个方向，才能改变弹出键盘的方向）
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    //设置状态栏横屏
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    //    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:@(UIInterfaceOrientationLandscapeRight)];
    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)createView{
    [self addHeadview];
    [self createScrollView];
    [self addCandleView];
    
    [self addVolumView];
    
    // 添加蜡烛图边框
    [self addTopBoxView];
    
    // 添加指标背景
    [self addQuotaBGView];
    
    // 添加右侧价格数据
    [self addPriceView];
    
    [self addQuotaView];
    
    // 添加指标边框
    [self addQuotaBorderView];
    
    [self addChartTitle];
    // 添加手势
    [self addGestureToCandleView];
    
    
    
}

- (void)addChartTitle{
    
    _mainTextLabel = [self createLabelTitle:@"" frame:CGRectMake(5, HeadHeight + 2, SCREEN_HEIGHT - 62, 10)];
    _mainTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.view addSubview:_mainTextLabel];
    _mainTextLabel.hidden = YES;
    
    _volumTextLabel = [self createLabelTitle:@"" frame:CGRectMake(5, HeadHeight + 2+ self.ChartHeight * CandleScale, SCREEN_HEIGHT - 62, 10)];
    _volumTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.view addSubview:_volumTextLabel];
    _volumTextLabel.hidden = YES;
    
    _fitureTextLabel = [self createLabelTitle:@"" frame:CGRectMake(5, HeadHeight + 2 + self.ChartHeight * (CandleScale + VolumeScale), SCREEN_HEIGHT - 62, 10)];
    _fitureTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
    _fitureTextLabel.adjustsFontSizeToFitWidth=YES;
    _fitureTextLabel.minimumScaleFactor=0.5;
    [self.view addSubview:_fitureTextLabel];
}

//- (void)upddateChartViewModel:(ZYWCandleModel *)model{
//
//    _volumTextLabel.text = [NSString stringWithFormat:@"量:%ld",model.volumn.integerValue];
//    _volumTextLabel.hidden = NO;
//    if (_candleChartView.mainquotaName == MainViewQuotaNameWithBOLL) {
//
//        _mainTextLabel.hidden = NO;
//
//        NSString * title = [NSString stringWithFormat:@"BOLL(20,2) BOLL:%.2f UB:%.2f LB:%.2f",model.BOLL_MB.floatValue,model.BOLL_UP.floatValue,model.BOLL_DN.floatValue];
//        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
//
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2DB52D"] range:[title rangeOfString:[NSString stringWithFormat:@"BOLL:%.2f",model.BOLL_MB.floatValue]]];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"D89640"] range:[title rangeOfString:[NSString stringWithFormat:@"UB:%.2f",model.BOLL_UP.floatValue]]];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"E08FE0"] range:[title rangeOfString:[NSString stringWithFormat:@"LB:%.2f",model.BOLL_DN.floatValue]]];
//        _mainTextLabel.attributedText = attr;
//
//    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithMA){
//        _mainTextLabel.hidden = NO;
//
//        NSString * title = [NSString stringWithFormat:@"MA(5,10,30) MA5:%.2f MA10:%.2f MA30:%.2f",model.MA5.floatValue,model.MA10.floatValue,model.MA30.floatValue];
//        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FBC170"] range:[title rangeOfString:[NSString stringWithFormat:@"MA5:%.2f",model.MA5.floatValue]]];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor magentaColor] range:[title rangeOfString:[NSString stringWithFormat:@"MA10:%.2f",model.MA10.floatValue]]];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"AED3E3"] range:[title rangeOfString:[NSString stringWithFormat:@"MA30:%.2f",model.MA30.floatValue]]];
//        _mainTextLabel.attributedText = attr;
//    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithNone){
//        _mainTextLabel.hidden = YES;
//    }
//}


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
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"58bcb8"] range:[title rangeOfString:[NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculateBesideLing:model.ParOpen]]]];
        
        _mainTextLabel.attributedText = attr;
    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithNone){
        _mainTextLabel.hidden = YES;
    }
}

- (void)addQuotaBGView
{
    _bottomView = [UIView new];
    [_scrollView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_bottom).offset(self.ChartHeight * (CandleScale + VolumeScale));
        make.left.right.equalTo(_scrollView);
        make.height.equalTo(@(self.ChartHeight * QuotaScale));
    }];
    [_bottomView layoutIfNeeded];
    
    
}

- (void)addQuotaBorderView
{
    UIView *bottomLineView= [UIView new];
    [self.view addSubview:bottomLineView];
    bottomLineView.userInteractionEnabled = NO;
    bottomLineView.backgroundColor = LineBGColor;
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight + HeadHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.view).offset(1);
        make.height.equalTo(@(1));
    }];
    
    UIView * volumeBottomLine = [UIView new];
    [self.view addSubview:volumeBottomLine];
    volumeBottomLine.userInteractionEnabled = NO;
    volumeBottomLine.backgroundColor = LineBGColor;
    [volumeBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight * (CandleScale + VolumeScale) + HeadHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.view).offset(1);
        make.height.equalTo(@(1));
    }];
    
    UIView * mainViewBottomLine = [UIView new];
    [self.view addSubview:mainViewBottomLine];
    mainViewBottomLine.userInteractionEnabled = NO;
    mainViewBottomLine.backgroundColor = LineBGColor;
    [mainViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight * (CandleScale) + HeadHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.view).offset(1);
        make.height.equalTo(@(1));
    }];
    
    
    
}

- (void)addQuotaView
{
    _quotaChartView = [ZTYQuotaChartView new];
    [_bottomView addSubview:_quotaChartView];
    _quotaChartView.delegate = self;
    _quotaChartView.quotaName = FigureViewQuotaNameWithMACD;
    _quotaChartView.lineWidth = BoxborderWidth;
    [_quotaChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomView);
        make.left.right.equalTo(_bottomView);
    }];
    
    UITapGestureRecognizer * quotaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quotaClick:)];
    [_quotaChartView addGestureRecognizer:quotaTap];
}

- (void)addTopBoxView
{
    _topBoxView = [UIView new];
    [self.view addSubview:_topBoxView];
    _topBoxView.userInteractionEnabled = NO;
    _topBoxView.layer.borderWidth = 0;//1*widthradio;
    _topBoxView.layer.borderColor = BoxborderColor.CGColor;//[UIColor blackColor].CGColor;
    [_topBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(1*heightradio);
        make.left.equalTo(_scrollView.mas_left).offset(-1*widthradio);
        make.right.equalTo(_scrollView.mas_right).offset(1*widthradio);
        //        make.height.equalTo(@(candelH));
        make.bottom.equalTo(_scrollView.mas_bottom).offset(1*widthradio);
    }];
}

- (void)createScrollView{
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.mas_equalTo( SCREEN_HEIGHT - 57);
        make.height.mas_equalTo(self.ChartHeight);
    }];
}

// 添加蜡烛图
- (void)addCandleView{
    _candleChartView = [ZTYMainKChartView new];
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
}

// 成交量
- (void)addVolumView{
    
    _volumView = [[ZTYVolumCahrtView alloc] init];
    [_scrollView addSubview:_volumView];
    [_volumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView).offset(self.ChartHeight * CandleScale);
        make.left.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.height.equalTo(@(self.ChartHeight * VolumeScale));
        
    }];
    _volumView.candleSpace = 2;
    _volumView.displayCount = CandleCount;
    _volumView.lineWidth = BoxborderWidth; //1 *widthradio;
    
    
    UITapGestureRecognizer * volumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(volumTap:)];
    [_volumView addGestureRecognizer:volumTap];
    
    //    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, self.ChartHeight * CandleScale, _scrollView.width, 1)];
    //    line.backgroundColor = [UIColor colorWithHexString:@"626A75"];
    //    [_scrollView addSubview:line];
}




- (void)addHeadview{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 24 + 44)];
    [self.view addSubview:_headView];
    
    
    NSString * priceAndPer = [NSString stringWithFormat:@"%@  %.2f%%",[ZTYCalCuteNumber calculate:[self.model.price floatValue]],[self.model.change floatValue]];
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
    
    
    UIButton *commentBtn = [self createImageBtn:CGRectMake(SCREEN_HEIGHT - 44 - (60), 7, 60, 30) img:@"kcomment" title:@"分析" titleW:48];
    [commentBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor colorWithHexString:@"308cdd"] forState:UIControlStateSelected];
    [commentBtn setImage:[UIImage imageNamed:@"kcomment_sel"] forState:UIControlStateSelected];
    commentBtn.selected = YES;
    [_headView addSubview:commentBtn];
    commentBtn.hidden =YES;
    _combtn = commentBtn;
    
    //    NSString * exchangeStr = @"OKEx";
    //    if (self.model.exchange.length>0) {
    //        exchangeStr = self.model.exchange;
    //    }
    //    if (self.exchange.length > 0) {
    //        exchangeStr = self.exchange;
    //    }
    //
    //    UILabel * exchangeNameLabel = [self createLabelTitle:exchangeStr frame:CGRectMake(SCREEN_HEIGHT - 50 - (btnWidth + intalval)* 3 - 81 - intalval - 60 - 10, 0, 60, 44)];
    //    exchangeNameLabel.textAlignment = NSTextAlignmentRight;
    //    exchangeNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    //    exchangeNameLabel.tag = 800;
    //    [_headView addSubview:exchangeNameLabel];
    
    NSString * pair = @"okex RUFF/USDT";
    if (self.model.symbol.length>0 && self.model.quote.length > 0 && self.model.exchange.length > 0) {
        pair = [NSString stringWithFormat:@"%@ %@/%@",self.model.exchange,self.model.symbol,self.model.quote];
    }
    if (self.base.length > 0 && self.quote.length >0) {
        pair = [NSString stringWithFormat:@"%@ %@/%@",self.exchange,self.base,self.quote];
    }
    
    UIButton * exchangeBtn = [self createBtnTiltle:pair frame:CGRectMake(10, 0, 102, 44)];
    [exchangeBtn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
    exchangeBtn.tag = 503;
    [_headView addSubview:exchangeBtn];
    
    
    CGFloat width = [pair sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]}].width;
    
    exchangeBtn.frame = CGRectMake(10, 0, width, 44);
    [self updateBtnStatus:503 title:pair imageHide:NO color:[UIColor whiteColor]];
    
    //    UILabel * exchangeLabel = [_headView viewWithTag:800];
    //    exchangeLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"exchange"]];
    
    
    NSArray * arr = @[@"1小时",@"MA",@"MACD"];
    for (int i = 0; i < 3; i ++) {
        
        UIButton * btn = [self createBtnTiltle:arr[i] frame:CGRectMake((btnWidth +intalval) * i + SCREEN_HEIGHT - 44  - commentWidth - (btnWidth + intalval)* 3 + intalval, 0, btnWidth, 44)];
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

- (void)comment:(UIButton *)btn{
    
    [self hiddenAllChoseBGView];
    _combtn.selected = !_combtn.selected;
    if (_combtn.selected) {
        
        [self.commentArr removeAllObjects];
        _candleChartView.firstCommentShow = YES;
        self.type = @"1h";
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

- (void)addPriceView
{
    CGFloat perCandlepriceHeight = self.ChartHeight * CandleScale / 6.0;
    _candlePrice = [ZYWPriceView new];
    [self.view addSubview:_candlePrice];
    [_candlePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBoxView).offset(perCandlepriceHeight - 5);
        make.height.equalTo(@(perCandlepriceHeight * 4 + 10));
        make.right.equalTo(self.view).offset(8);
        make.left.equalTo(_topBoxView.mas_right).offset(9);
    }];
    
    _volumePrice = [ZYWPriceView new];
    [self.view addSubview:_volumePrice];
    [_volumePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBoxView).offset(self.ChartHeight * CandleScale);
        make.height.equalTo(@(self.ChartHeight * VolumeScale));
        make.right.equalTo(self.view).offset(8);
        make.left.equalTo(_topBoxView.mas_right).offset(9);
    }];
    
    _quotaPrice = [ZYWPriceView new];
    [self.view addSubview:_quotaPrice];
    [_quotaPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBoxView).offset(self.ChartHeight * (CandleScale + VolumeScale) + 5);
        make.height.equalTo(@(self.ChartHeight * QuotaScale - 12));
        make.right.equalTo(self.view).offset(8);
        make.left.equalTo(_topBoxView.mas_right).offset(9);
    }];
    
    ZTYNounLine * nounLine = [[ZTYNounLine alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 57, 24 + 44, 9, self.ChartHeight)];
    nounLine.strokeColor = LineBGColor;
    [self.view addSubview:nounLine];
    [nounLine setNounlinewidthNouns:@[@(perCandlepriceHeight),@(perCandlepriceHeight * 2),@(perCandlepriceHeight * 3),@(perCandlepriceHeight * 4),@(perCandlepriceHeight * 5),@(self.ChartHeight * (CandleScale + VolumeScale) + 12),@(self.ChartHeight * (CandleScale + VolumeScale) + (self.ChartHeight * QuotaScale - 12 ) * 0.5 + 5),@(self.ChartHeight -12 - 3)]];
}

#pragma mark 十字线

- (void)initCrossLine
{
    self.verticalView = [UIView new];
    self.verticalView.clipsToBounds = YES;
    [self.scrollView addSubview:self.verticalView];
    self.verticalView.backgroundColor = LineBGColor; //[UIColor colorWithHexString:@"666666"];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView);
        make.width.equalTo(@(_candleChartView.lineWidth));
        make.height.equalTo(_scrollView);
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
    self.verticalLabel.hidden = YES;
    [self.verticalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.ChartHeight - 12));
        make.width.equalTo(@(100));
        make.height.equalTo(@(12));
        make.left.equalTo(@(0));
    }];
    
    
    self.latestLinetextView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, -SCREEN_HEIGHT, SCREEN_HEIGHT - 5, 20)];
    [self.view addSubview:self.latestLinetextView];
    
    self.lineTextView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_HEIGHT - 5, 20)];
    [self.lineTextView setBackGroudImage:@"textLineLatest"];
    [self.lineTextView setTextColor:[UIColor blackColor]];
    [self.view addSubview:self.lineTextView];
    
    self.lineTextView.hidden = YES;
    self.verticalLabel.hidden = YES;
    self.verticalView.hidden = YES;
    
}

- (void)addActivityView
{
    _activityView = [UIActivityIndicatorView new];
    [self.view addSubview:_activityView];
    //    _activityView.hidesWhenStopped = YES;
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)addGestureToCandleView
{
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    [self.candleChartView addGestureRecognizer:longPressGesture];
    
    UIPinchGestureRecognizer *pinchPressGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.scrollView addGestureRecognizer:pinchPressGesture];
    
    UITapGestureRecognizer * tapgeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapclick)];
    [self.scrollView addGestureRecognizer:tapgeture];
    
}

-(void)tapclick{
    [self hiddenAllChoseBGView];
}

- (void)quotaClick:(UITapGestureRecognizer *)tapgesture{
    
    if ([self judgeLineHideOrShow]) {
        CGPoint location = [tapgesture locationInView:self.quotaChartView];
        //        [self.quotaChartView getTapModelPostionWithPostion:location];
        CGPoint newLocation = [self.quotaChartView getTapModelPostionWithPostion:location];
        CGFloat xPositoin = newLocation.x + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f ;
        CGPoint point = CGPointMake(xPositoin, newLocation.y);
        [self updateCrossline:point linetextTop:(self.ChartHeight * (CandleScale + VolumeScale))];
    }
    //    CGFloat xPositoin = location.x; // + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f
    //    CGFloat yPositoin = location.y; //+ self.candleChartView.topMargin
    //    [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(@(xPositoin));
    //    }];
    //    [self.verticalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(@(xPositoin - 50));
    //    }];
    //
    //    [self.lineTextView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(yPositoin - 10 + HeadHeight + (self.ChartHeight * (CandleScale + VolumeScale)));
    //    }];
    //
    //    self.verticalView.hidden = NO;
    //    self.lineTextView.hidden = NO;
    //    self.verticalLabel.hidden = NO;
}

- (void)volumTap:(UITapGestureRecognizer *)tapgesture{
    
    if ([self judgeLineHideOrShow]) {
        CGPoint location = [tapgesture locationInView:self.volumView];
        //        [self.volumView getTapModelPostionWithPostion:location];
        
        CGPoint newLocation = [self.volumView getTapModelPostionWithPostion:location];
        CGFloat xPositoin = newLocation.x + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f ;
        CGPoint point = CGPointMake(xPositoin, newLocation.y);
        [self updateCrossline:point linetextTop:(self.ChartHeight * CandleScale)];
    }
    
}

- (void)candleTap:(UITapGestureRecognizer *)tapgesture{
    
    if ([self judgeLineHideOrShow]) {
        
        CGPoint location = [tapgesture locationInView:self.candleChartView];
        //        [self.candleChartView getTapModelPostionWithPostion:location];
        
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
    
    [self.lineTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yPositoin - 10 + HeadHeight + top);
    }];
    
    self.verticalView.hidden = NO;
    //    self.lineTextView.hidden = NO;
    self.verticalLabel.hidden = NO;
}

- (BOOL)judgeLineHideOrShow{
    
    if (self.verticalView.hidden || self.verticalLabel.hidden) {
        return YES;
    }else{
        self.verticalView.hidden = YES;
        self.lineTextView.hidden = YES;
        self.verticalLabel.hidden = YES;
        return NO;
    }
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
        //        [_quotaView layoutIfNeeded];
        
        //        [self.leavView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(yPositoin);
        //        }];
        //
        //        [self.verPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.mas_equalTo(@(yPositoin + 177));
        //        }];
        
        [self.lineTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(yPositoin - 10 + HeadHeight);
        }];
        
        [self.verticalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin - 50));
        }];
        
        self.verticalLabel.hidden = NO;
        self.verticalView.hidden = NO;
        //        self.leavView.hidden = NO;
        //        self.verPriceLabel.hidden = NO;
        self.lineTextView.hidden = NO;
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        if(self.verticalView)
        {
            self.verticalView.hidden = YES;
        }
        
        //        if(self.leavView)
        //        {
        //            self.leavView.hidden = YES;
        //            self.verPriceLabel.hidden = YES;
        //        }
        if(self.lineTextView)
        {
            self.lineTextView.hidden = YES;
            
        }
        if (self.verticalLabel) {
            self.verticalLabel.hidden = YES;
        }
        oldPositionX = 0;
        self.scrollView.scrollEnabled = YES;
    }
}

#pragma mark 缩放手势
- (void)pinchGesture:(UIPinchGestureRecognizer*)pinchPress
{
    if (pinchPress.numberOfTouches < 2)
    {
        _candleChartView.kvoEnable = YES;
        _scrollView.scrollEnabled = YES;
        return;
    }
    
    switch (pinchPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            _scrollView.scrollEnabled = NO;
            _candleChartView.kvoEnable = NO;
        }break;
        case UIGestureRecognizerStateEnded:
        {
            _scrollView.scrollEnabled = YES;
            _candleChartView.kvoEnable = YES;
        }break;
        default:
            break;
    }
    
    CGFloat scale = pinchPress.scale;
    CGFloat originScale= 1.0;
    CGFloat minScale = 0.03;
    NSInteger displayCount = self.candleChartView.displayCount;
    CGFloat diffScale = scale - originScale;
    if (fabs(diffScale) > minScale)
    {
        CGPoint point1 = [pinchPress locationOfTouch:0 inView:self.scrollView];
        CGPoint point2 = [pinchPress locationOfTouch:1 inView:self.scrollView];
        CGFloat pinCenterX = (point1.x + point2.x) / 2;
        
        NSLog(@"yyyyy-----%f---%f",point1.y,point2.y);
        NSLog(@"xxxxx-----%f---%f",point1.x,point2.x);
        CGFloat scrollViewPinCenterX =  pinCenterX;
        NSInteger pinCenterLeftCount = scrollViewPinCenterX / (_candleChartView.candleWidth + _candleChartView.candleSpace);
        pinCenterLeftCount = _candleChartView.currentStartIndex;
        CGFloat newDisplayCount = diffScale > 0 ? (displayCount - 1) : (1 + displayCount);
        
        if (newDisplayCount+pinCenterLeftCount > _candleChartView.dataArray.count)
        {
            newDisplayCount = _candleChartView.dataArray.count - pinCenterLeftCount;
        }
        
        if (newDisplayCount < MinCount && scale >=1)
        {
            newDisplayCount = MinCount;
        }
        
        if (newDisplayCount > MaxCount && scale < 1)
        {
            newDisplayCount = MaxCount;
        }
        
        _candleChartView.displayCount = (NSInteger)newDisplayCount;
        [_candleChartView calcuteCandleWidth];
        [_candleChartView updateWidth];
        
        CGFloat newPinCenterX = pinCenterLeftCount * _candleChartView.candleWidth + (pinCenterLeftCount) * _candleChartView.candleSpace;
        CGFloat newOffsetX = newPinCenterX;
        _scrollView.contentOffset = CGPointMake(newOffsetX > 0 ? newOffsetX : 0, 0);
        _candleChartView.contentOffset = _scrollView.contentOffset.x;
        [_candleChartView drawKLine];
    }
}

#pragma mark -- deal data
- (void)requestData{
    
    self.candleChartView.isFreshing = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.type;
    param[@"size"] = @"500";
    
    if (self.model.symbol.length > 0) {
        param[@"base"] = self.model.symbol;//@"btc";
    }
    
    if (self.base.length > 0) {
        param[@"base"] = self.base;//@"btc";
    }
    if (self.model.exchange.length > 0) {
        param[@"exchange"] = self.model.exchange;
    }
    if (self.exchange.length > 0) {
        param[@"exchange"] = self.exchange;
    }
    
    
    if (self.model.quote.length > 0) {
        param[@"quote"] = self.model.quote;
    }
    
    if (self.quote.length > 0) {
        param[@"quote"] = self.quote; //@"btc/usdt";
    }
    
    //    param[@"exchange"] = self.exchange;
    //    param[@"symbol"] = self.symbol;
    //    param[@"pair"] = self.pair;
    if (self.end) {
        [param setObject:self.end forKey:@"end"];
    }
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    
    if (_activityView.animating) {
        self.candleChartView.isFreshing = YES;
    }
    
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:kGetKLineData parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        [_activityView stopAnimating];
        if (IsSafeDictionary(responseObject)) {
            NSArray * kDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"kline"];
            if (kDataArr.count > 0) {
                //                self.start = [[kDataArr lastObject] objectForKey:@"date"];
                if (self.start.integerValue < [[NSString stringWithFormat:@"%@",[[kDataArr lastObject] objectForKey:@"date"]] integerValue]) {
                    self.start = [NSString stringWithFormat:@"%@",[[kDataArr lastObject] objectForKey:@"date"]];
                }
                self.end = [[kDataArr firstObject] objectForKey:@"date"];
                //开启定时器
                [weakSelf.timer setFireDate:[NSDate distantPast]];
            }
            
            weakSelf.latesetClose = [[[[responseObject objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
            [weakSelf updateHeadData:[[responseObject objectForKey:@"data"] objectForKey:@"ticker"]];
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
            
            NSArray * QuotaDataArr = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            [weakSelf reloadData:QuotaDataArr reload:_isrelaod];
            
            if (self.dataSource.count > 0) {
                ZTYChartModel * lastModel = [self.dataSource lastObject];
                
                self.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
                //                self.end = [NSString stringWithFormat:@"%ld",firstModel.timestamp];
                
                //开启定时器
                [weakSelf.timer setFireDate:[NSDate distantPast]];
                
            }
            
            //            if ([self.type isEqualToString:@"1h"] && _combtn.selected == YES) {
            //                [weakSelf getKlineComment];
            //            }
        }
    } failure:^(NSError *error) {
        [_activityView stopAnimating];
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

//- (void)getKlineComment{
//
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//
//    if (self.model.symbol.length > 0) {
//        param[@"symbol"] = self.model.symbol;//@"btc";
//    }
//
//    if (self.base.length > 0) {
//        param[@"symbol"] = self.base;//@"btc";
//    }
//
//
//    if (self.model.quote.length > 0) {
//        param[@"pair"] = self.model.quote;
//    }
//
//    if (self.quote.length > 0) {
//        param[@"pair"] = self.quote; //@"btc/usdt";
//    }
//
//    WS(weakSelf)
//
//    NSLog(@"param======>%@",param);
//    //    NMShowLoadIng;  //@"@"http://47.94.217.12:18081/app/api/klineComment/getHourShortComment"" //
//    [BTERequestTools requestWithURLString:kGetKlineCommentList parameters:param type:2 success:^(id responseObject) {
//        if (IsSafeDictionary(responseObject)) {
//
//            NSLog(@"responseObject====>%@",responseObject);
//            NSArray * list = [responseObject objectForKey:@"data"];
//
//            NSMutableArray * tempArr = [NSMutableArray array];
//            for (int index = 0; index < list.count; index ++) {
//
//                NSDictionary * dict = [list objectAtIndex:(list.count - 1 - index)];
//                ZTYKlineComment * comment = [[ZTYKlineComment alloc] initWidthDict:dict];
//                [tempArr addObject:comment];
//            }
//
//            [self.commentArr addObjectsFromArray:tempArr];
//            _combtn.selected = YES;
//            weakSelf.candleChartView.isNotComment = NO;
//            weakSelf.candleChartView.commentArr = self.commentArr.mutableCopy;
//            [weakSelf.candleChartView showCommentBtns];
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}

- (void)getKlineComment{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.model.symbol.length > 0) {
        param[@"symbol"] = self.model.symbol;//@"btc";
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
    //    if (self.desListModel.quote.length > 0) {
    //        param[@"pair"] = self.desListModel.quote;
    //    }
    //
    //    if (self.quote.length > 0) {
    //        param[@"pair"] = self.quote; //@"btc/usdt";
    //    }
    
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

- (void)updateHeadData:(NSDictionary *)dict{
    
    NSString * changeString = [NSString stringWithFormat:@"%@ %@/%@",[dict objectForKey:@"exchange"],[dict objectForKey:@"symbol"],[dict objectForKey:@"pair"]];
    CGFloat width = [changeString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]}].width;
    UIButton * btn = [_headView viewWithTag:503];
    btn.frame = CGRectMake(10, 0, width, 44);
    [self updateBtnStatus:503 title:changeString imageHide:NO color:[UIColor whiteColor]];
    
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

- (void)reloadData:(NSArray *)array reload:(int)reload
{
    
    _quotaChartView.dataArray = array.mutableCopy;
    _volumView.dataArray = array.mutableCopy;
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

- (void)displayMoreData
{
    NSLog(@"正在加载更多....");
    [_activityView startAnimating];
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

#pragma delegate -- 蜡烛图的代理事件
/**
 取得当前屏幕内模型数组的开始下标以及个数
 
 @param leftPostion 当前屏幕最右边的位置
 @param index 下标
 @param count 个数
 */
-(void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count{
    
    
    [self showIndexLineView:leftPostion startIndex:index count:count];
}

/**
 长按手势获得当前k线下标以及模型
 
 @param kLineModeIndex 当前k线在可视范围数组的位置下标
 @param kLineModel   k线模型
 */
- (void)tapCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)index price:(CGFloat)price{
    [self updateDeslAndRosedrop:kLineModel];
    //    NSDictionary * quotaDict = [_quotaChartView getCandleModelWithIndex:kLineModeIndex];
    //    [self upddateQuotaViewDict:quotaDict];
    
    [self upddateQuotaViewModel:kLineModel];
    [self upddateChartViewModel:kLineModel];
    self.verticalLabel.text = [NSString stringWithFormat:@"%@",kLineModel.timeStr];
    [_lineTextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:price]]];
}

- (void)upddateQuotaViewModel:(ZTYChartModel *)model{
    
    _latestModel = model;
    _fitureTextLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    if (_quotaChartView.quotaName == FigureViewQuotaNameWithMACD) {
        _fitureTextLabel.hidden = NO;
        NSString * title = [NSString stringWithFormat:@"MACD(12,26,9) DIF:%@ DEA:%@ MACD:%@",[ZTYCalCuteNumber calculateBesideLing:model.DIF.doubleValue],[ZTYCalCuteNumber calculateBesideLing:model.DEA.doubleValue],[ZTYCalCuteNumber calculateBesideLing:model.MACD.doubleValue]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        
        //        if ([[dict valueForKey:@"key3"] floatValue]<0) {
        //            [attr addAttribute:NSForegroundColorAttributeName value:RoseColor range:[title rangeOfString:[NSString stringWithFormat:@"MACD:%@",[dict valueForKey:@"key1"]]]];
        //        }else{
        //            [attr addAttribute:NSForegroundColorAttributeName value:DropColor range:[title rangeOfString:[NSString stringWithFormat:@"MACD:%@",[dict valueForKey:@"key1"]]]];
        //        }
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

/**
 长按手势获得当前k线下标以及模型
 
 @param kLineModeIndex 当前k线在可视范围数组的位置下标
 @param kLineModel   k线模型
 */
-(void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)index{
    //    [_lineTextView setText:[NSString stringWithFormat:@"%.2f",kLineModel.close]];
    //    _descLabel.text = [NSString stringWithFormat:@"%@  涨幅:+0.27%%  振幅:0.44%%  开%.2f  高%.2f 低%.2f 收%.2f",kLineModel.timeStr,kLineModel.open,kLineModel.high,kLineModel.low,kLineModel.close];
    
    [self updateDeslAndRosedrop:kLineModel];
    //    NSDictionary * quotaDict = [_quotaChartView getCandleModelWithIndex:kLineModeIndex];
    //    [self upddateQuotaViewDict:quotaDict];
    [self upddateQuotaViewModel:kLineModel];
    [self upddateChartViewModel:kLineModel];
}

/**
 返回当前屏幕最后一根k线模型
 
 @param kLineModel k线模型
 */
-(void)displayLastModel:(ZTYChartModel *)kLineModel{
    //    [_lineTextView setText:[NSString stringWithFormat:@"%.2f",kLineModel.close]];
    //    _descLabel.text = [NSString stringWithFormat:@"%@  涨幅:+0.27%%  振幅:0.44%%  开%.2f  高%.2f 低%.2f 收%.2f",kLineModel.timeStr,kLineModel.open,kLineModel.high,kLineModel.low,kLineModel.close];
    [self updateLatestTextLine];
    [self upddateQuotaViewModel:kLineModel];
    [self updateDeslAndRosedrop:kLineModel];
    [self upddateChartViewModel:kLineModel];
}

- (void)updateDeslAndRosedrop:(ZTYChartModel *)kLineModel{
    [_lineTextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:kLineModel.close]]];
    
    CGFloat dr = roundf(((kLineModel.close - kLineModel.preKlineModel.close) / kLineModel.preKlineModel.close )* 100000.0 + 0.5) / 1000.0;
    CGFloat dx = roundf((kLineModel.high / kLineModel.low - 1.0) * 100000.0 + 0.5)/1000.0;
    
    
    
    
    
    NSString * roseDropStr = [NSString stringWithFormat:@"%@  涨幅：%.2f%% 振幅：%.2f%%  开：%@  高：%@ 低：%@ 收：%@",kLineModel.timeStr,dr,dx,[ZTYCalCuteNumber calculateBesideLing:kLineModel.open],[ZTYCalCuteNumber calculateBesideLing:kLineModel.high],[ZTYCalCuteNumber calculateBesideLing:kLineModel.low],[ZTYCalCuteNumber calculateBesideLing:kLineModel.close]];
    
    if (dr > 0) {
        roseDropStr = [NSString stringWithFormat:@"%@  涨幅：+%.2f%% 振幅：%.2f%%  开：%@  高：%@ 低：%@ 收：%@",kLineModel.timeStr,dr,dx,[ZTYCalCuteNumber calculateBesideLing:kLineModel.open],[ZTYCalCuteNumber calculateBesideLing:kLineModel.high],[ZTYCalCuteNumber calculateBesideLing:kLineModel.low],[ZTYCalCuteNumber calculateBesideLing:kLineModel.close]];
    }
    //
    //    if (dx > 0) {
    //        roseDropStr = [NSString stringWithFormat:@"%@  涨幅：%.2f%% 振幅：+%.2f%%  开：%@  高：%@ 低：%@ 收：%@",kLineModel.timeStr,dr,dx,[ZTYCalCuteNumber calculateBesideLing:kLineModel.open],[ZTYCalCuteNumber calculateBesideLing:kLineModel.high],[ZTYCalCuteNumber calculateBesideLing:kLineModel.low],[ZTYCalCuteNumber calculateBesideLing:kLineModel.close]];
    //    }
    //
    //    if (dr > 0 && dx > 0) {
    //        roseDropStr = [NSString stringWithFormat:@"%@  涨幅：+%.2f%% 振幅：+%.2f%%  开：%@  高：%@ 低：%@ 收：%@",kLineModel.timeStr,dr,dx,[ZTYCalCuteNumber calculateBesideLing:kLineModel.open],[ZTYCalCuteNumber calculateBesideLing:kLineModel.high],[ZTYCalCuteNumber calculateBesideLing:kLineModel.low],[ZTYCalCuteNumber calculateBesideLing:kLineModel.close]];
    //    }
    
    //    NSString * descText = [NSString stringWithFormat:@"%@ 开：%.2f 高：%.2f 低：%.2f 收：%.2f",kLineModel.timeString,kLineModel.open,kLineModel.high,kLineModel.low,kLineModel.close];
    NSArray * descTitles = @[@"涨幅：",@"振幅：",@"开：",@"高：",@"低：",@"收："];
    [_descLabel setText:roseDropStr titles:descTitles date:kLineModel.timeString dr:dr dx:dx];
    
    
    //    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:roseDropStr];
    //    UIColor * lightColor = [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0];
    //    [att addAttribute:NSForegroundColorAttributeName value:lightColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"开："]]];
    //    [att addAttribute:NSForegroundColorAttributeName value:lightColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"高："]]];
    //    [att addAttribute:NSForegroundColorAttributeName value:lightColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"低："]]];
    //    [att addAttribute:NSForegroundColorAttributeName value:lightColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"收："]]];
    //
    //    if (dr < 0) {
    //        [att addAttribute:NSForegroundColorAttributeName value:RoseColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"%.2f%%",dr]]];
    //    }else{
    //        [att addAttribute:NSForegroundColorAttributeName value:DropColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"%.2f%%",dr]]];
    //    }
    //    _descLabel.attributedText = att;
}

//-(void)displayQuotaLastDict:(NSDictionary *)dict{
//    [self upddateQuotaViewDict:dict];
//}

- (void)showIndexLineView:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count
{
    
    
    _volumView.candleSpace = _candleChartView.candleSpace;
    _volumView.candleWidth = _candleChartView.candleWidth;
    _volumView.leftPostion = leftPostion;
    _volumView.startIndex = index;
    _volumView.displayCount = count;
    [_volumView stockFill];
    
    CGFloat maxValue = _candleChartView.maxY;
    CGFloat minValue = _candleChartView.minY;
    //    _candlePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:maxValue]];
    //    _candlePrice.maxMiddlePriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:((maxValue - minValue) * 0.75 + minValue)]];
    //    _candlePrice.middlePriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:((maxValue - minValue)* 0.5 + minValue)]];
    //    _candlePrice.minMiddlePriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:((maxValue - minValue)* 0.25 + minValue)]];
    //    _candlePrice.minPriceLabel.text = [NSString stringWithFormat:@"%@",[ZTYCalCuteNumber calculate:minValue]];
    
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
    _volumePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumView.maxY/1000.0];
    _volumePrice.minPriceLabel.text = [NSString stringWithFormat:@"%.2fk",self.volumView.minY/1000.0];
    
    
    
    
    
}

#pragma mark -- 设置主图指标、附图指标、K线类型选择
- (void)selectTypeItem:(UIButton *)btn{
    
    [self hideBesides:btn.tag];
    
    if (btn.tag == 500) {
        // K线
        if (self.ktypeBGView.hidden) {
            self.ktypeBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:500 title:@"" imageHide:YES color:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            self.ktypeBGView.hidden = YES;
            [self updateBtnStatus:500 title:@"" imageHide:NO color:[UIColor whiteColor]];
        }
        
    }else if(btn.tag == 501){
        // 主图指标
        if (self.mainQuotaTypeBGView.hidden) {
            self.mainQuotaTypeBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:501 title:@"" imageHide:YES color:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            self.mainQuotaTypeBGView.hidden = YES;
            [self updateBtnStatus:501 title:@"" imageHide:NO color:[UIColor whiteColor]];
        }
        
    }else if(btn.tag == 502){
        // 附图指标
        if (self.fitureQuotaBGView.hidden) {
            self.fitureQuotaBGView.hidden = NO;
            _scrollView.scrollEnabled = NO;
            [self updateBtnStatus:502 title:@"" imageHide:YES color:[UIColor colorWithHexString:@"308cdd"]];
        }else{
            self.fitureQuotaBGView.hidden = YES;
            [self updateBtnStatus:502 title:@"" imageHide:NO color:[UIColor whiteColor]];
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
    }
}

- (void)requestExchangeData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    //    param[@"exchange"] = @"okex";
    
    if (self.model.symbol.length) {
        param[@"base"] = self.model.symbol;
    }
    if (self.base.length) {
        param[@"base"] = self.base;
    }
    //    param[@"symbol"] = @"btc";
    //    param[@"pair"] = @"btc/usdt";
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kGetExchangeData;
    [_exchangeArray removeAllObjects];
    WS(weakSelf)
    //    NMShowLoadIng;  //@"http://47.94.217.12:18081/app/api/exchange/info"
    [BTERequestTools requestWithURLString:kGetExchangeData parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
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
        
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (UITableView *)exchangeTableView{
    if (!_exchangeTableView) {
        
        _exchangeTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 44,375, 264) style:UITableViewStylePlain];
        _exchangeTableView.delegate = self;
        _exchangeTableView.dataSource = self;
        _exchangeTableView.tableFooterView = [UIView new];
        _exchangeTableView.rowHeight = 44;
        _exchangeTableView.bounces = NO;
        _exchangeTableView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.view addSubview:_exchangeTableView];
    }
    return _exchangeTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _exchangeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExchangeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"exchange"];
    if (!cell) {
        cell = [[ExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"exchange"];
    }
    ExchangeModel * model =[_exchangeArray objectAtIndex:indexPath.row];
    [cell configwidthModel:model width:375];
    return cell;
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
    [_dataSource removeAllObjects];
}

- (UIView *)ktypeBGView{
    if (!_ktypeBGView) {
        
        CGFloat btnH = 44;
        _ktypeBGView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 3 * (btnWidth + intalval) -44 - commentWidth  + intalval, 44, btnWidth * 4, btnH * 3)];
        _ktypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.view addSubview:_ktypeBGView];
        _ktypeBGView.hidden = YES;
        
        NSArray *ktypes = @[@"分时",@"1分",@"5分",@"15分",@"30分",@"1小时",@"4小时",@"1天",@"1周",@"1月"];
        for (int index = 0; index < ktypes.count; index ++) {
            
            UIButton * btn = [self createBtn:ktypes[index] frame:CGRectMake(btnWidth * (index %4), (index / 4) * btnH, btnWidth, btnH)];
            [btn addTarget:self action:@selector(choseKtypeItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2000 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_ktypeBGView addSubview:btn];
            if ([ktypes[index] isEqualToString:@"1小时"]) {
                btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
            }
        }
    }
    return _ktypeBGView;
}

- (void)choseKtypeItem:(UIButton *)btn{
    
    for (int i = 0; i < 7; i ++) {
        UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    [self updateBtnStatus:500 title:btn.titleLabel.text imageHide:NO color:[UIColor whiteColor]];
    _ktypeBGView.hidden = YES;
    NSArray * types= @[@"1m",@"1m",@"5m",@"15m",@"30m",@"1h",@"4h",@"1d",@"1w",@"1mo"];
    _type = types[btn.tag -2000];
    self.end = nil;
    _isrelaod = 0;
    _combtn.selected = NO;
    
    [self.commentArr removeAllObjects];
    _candleChartView.firstCommentShow = YES;
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    [_dataSource removeAllObjects];
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
        NSArray * quotaArr = @[@"MA",@"BOLL",@"EMA",@"SAR",@"关闭"];
        _mainQuotaTypeBGView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - (btnWidth + intalval) * 2 -44 - commentWidth + intalval,44, btnWidth, quotaArr.count * btnH)];
        _mainQuotaTypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.view addSubview:_mainQuotaTypeBGView];
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
    
    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [_mainQuotaTypeBGView viewWithTag:2100 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
    
    if ([btn.titleLabel.text isEqualToString:@"关闭"]) {
        [self updateBtnStatus:501 title:@"主指标" imageHide:NO color:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithNone;
        [_candleChartView reloadAtCurrentIndex];
    }else if([btn.titleLabel.text isEqualToString:@"BOLL"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO color:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithBOLL;
        [_candleChartView reloadAtCurrentIndex];
    }else if ([btn.titleLabel.text isEqualToString:@"MA"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO color:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithMA;
        [_candleChartView reloadAtCurrentIndex];
    }else if ([btn.titleLabel.text isEqualToString:@"SAR"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO color:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithSAR;
        [_candleChartView reloadAtCurrentIndex];
    }else if ([btn.titleLabel.text isEqualToString:@"EMA"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO color:[UIColor whiteColor]];
        _candleChartView.mainquotaName = MainViewQuotaNameWithEMA;
        [_candleChartView reloadAtCurrentIndex];
    }
    
    _mainQuotaTypeBGView.hidden = YES;
}

-(UIView *)fitureQuotaBGView{
    if (!_fitureQuotaBGView) {
        CGFloat btnH = 44;
        NSArray * quotaArr = @[@"MACD",@"KDJ",@"RSI"];
        _fitureQuotaBGView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - (btnWidth + intalval)  - commentWidth - 44 + intalval,44, btnWidth, quotaArr.count * btnH)];
        _fitureQuotaBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.view addSubview:_fitureQuotaBGView];
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
        [self updateBtnStatus:tag title:@"指标" imageHide:NO color:[UIColor whiteColor]];
        _quotaChartView.quotaName = MainViewQuotaNameWithNone;
        [_quotaChartView stockFill];
    }else if([quotaBtn.titleLabel.text isEqualToString:@"MACD"]){
        [self updateBtnStatus:tag title:title imageHide:NO color:[UIColor whiteColor]];
        _quotaChartView.quotaName = FigureViewQuotaNameWithMACD;
        [_quotaChartView stockFill];
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"KDJ"]){
        [self updateBtnStatus:tag title:title imageHide:NO color:[UIColor whiteColor]];
        _quotaChartView.quotaName = FigureViewQuotaNameWithKDJ;
        [_quotaChartView stockFill];
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"RSI"]){
        [self updateBtnStatus:tag title:title imageHide:NO color:[UIColor whiteColor]];
        _quotaChartView.quotaName = FigureViewQuotaNameWithRSI;
        [_quotaChartView stockFill];
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"WR"]){
        [self updateBtnStatus:tag title:title imageHide:NO color:[UIColor whiteColor]];
        _quotaChartView.quotaName = FigureViewQuotaNameWithWR;
        [_quotaChartView stockFill];
    }
    
    [self upddateQuotaViewModel:_latestModel];
    _fitureQuotaBGView.hidden = YES;
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

- (void)hiddenAllChoseBGView{
    _ktypeBGView.hidden = YES;
    [self updateBtnStatus:500 title:@"" imageHide:NO color:[UIColor whiteColor]];
    _mainQuotaTypeBGView.hidden = YES;
    [self updateBtnStatus:501 title:@"" imageHide:NO color:[UIColor whiteColor]];
    _fitureQuotaBGView.hidden = YES;
    [self updateBtnStatus:502 title:@"" imageHide:NO color:[UIColor whiteColor]];
    
    _exchangeTableView.hidden = YES;
    [self updateBtnStatus:503 title:@"" imageHide:NO color:[UIColor whiteColor]];
}

- (void)hideBesides:(NSInteger)tag{
    
    if (tag != 500) {
        _ktypeBGView.hidden = YES;
        [self updateBtnStatus:500 title:@"" imageHide:NO color:[UIColor whiteColor]];
    }
    if (tag !=501) {
        _mainQuotaTypeBGView.hidden = YES;
        [self updateBtnStatus:501 title:@"" imageHide:NO color:[UIColor whiteColor]];
    }
    if (tag != 502) {
        _fitureQuotaBGView.hidden = YES;
        [self updateBtnStatus:502 title:@"" imageHide:NO color:[UIColor whiteColor]];
    }
    if (tag != 503) {
        _exchangeTableView.hidden = YES;
        [self updateBtnStatus:503 title:@"" imageHide:NO color:[UIColor whiteColor]];
    }
    _verticalLabel.hidden = YES;
    _verticalView.hidden = YES;
    _lineTextView.hidden = YES;
}

#pragma mark -- event
- (void)close{
    [self dismissViewControllerAnimated:NO completion:nil];
}

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


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)dealloc{
    NSLog(@"dealloc");
}

////支持旋转
//-(BOOL)shouldAutorotate{
//    return YES;
//}
//
////支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//     return UIInterfaceOrientationMaskLandscapeRight;
// }
//
////一开始的方向  很重要
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeRight;
//}



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

