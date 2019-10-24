//
//  BTEKlineChatViewController.m
//  BTE
//
//  Created by wanmeizty on 2018/7/16.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEKlineChatViewController.h"

#import "ZXQuotaDataReformer.h"
#import "ZTYMainChartView.h"
#import "ZTYLineTextView.h"
#import "ZTYCandlePosionModel.h"
#import "ZYWPriceView.h"
#import "ZTYNounLine.h"
#import "ZTYCalCuteNumber.h"
#import "UILabel+leftAndRight.h"

@interface BTEKlineChatViewController ()<ZTYChartProtocol>

@property (nonatomic,strong) UIView * KlineBgView,* topBoxView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) ZTYMainChartView * candleChartView;
@property (nonatomic,strong) ZYWPriceView * candlePrice;

@property (nonatomic,strong) UILabel * roseDropLabel;
@property (nonatomic,strong) UILabel * descLabel;

@property (nonatomic,strong) UIView * ktypeBGView,*mainQuotaTypeBGView;
@property (nonatomic,strong) UIView * headView;
@property (nonatomic,strong) UILabel * headLabel;

@property (nonatomic,strong) UIView * verticalView;
@property (nonatomic,strong) UILabel * verticalLabel;
@property (nonatomic,strong) ZTYLineTextView * latestLinetextView;

@property (nonatomic,assign) CGFloat latesetClose;

@property (nonatomic,copy) NSString * start;
@property (nonatomic,copy) NSString * end;
@property (nonatomic,assign) int isrelaod;
@property (nonatomic,strong) NSString * ktype;
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,strong) NSArray * klineTypes;

@property (nonatomic,strong) NSTimer * timer;


@property (nonatomic, assign) NSUInteger zoomRightIndex;
@property (nonatomic, assign) CGFloat currentZoom;
@property (nonatomic, assign) NSInteger displayCount;


@end

@implementation BTEKlineChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@行情讨论",self.base];
    
    self.dataSource = [NSMutableArray array];
    _ktype = @"1h";
    _isrelaod = 0;
    
    [self addSubViews];
    [self addHiddeView];
    
    [self initCrossLine];
    
    [self requestData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startClock) userInfo:nil repeats:YES];
    
    //  关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    // Do any additional setup after loading the view.
}

#pragma mark -- 刷新倒计时
static int clockCount = 3;
- (void)startClock{
    //    NSString * title = self.desListModel.symbol;
    //    if (self.base.length > 0) {
    //        title = self.base;
    //    }
    //    self.title = [NSString stringWithFormat:@"%@(%d)",title,clockCount];
    clockCount --;
    if (clockCount <= -1) {
        [self requestLastModelData];
        clockCount = 3;
    }
}

- (void)addHiddeView{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self.view addSubview:self.headView];
    
    self.headLabel = [self createLabelTitle:@"btc" frame:CGRectMake(16, 0, SCREEN_WIDTH - 32 - 40, 40)];
    self.headLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.headView addSubview:self.headLabel];
    
    UIButton * spreadBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 20, 10, 20, 20)];
    spreadBtn.tag = 201;
    [spreadBtn setImage:[UIImage imageNamed:@"kline_spread"] forState:UIControlStateNormal];
    [spreadBtn addTarget:self action:@selector(showKline:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:spreadBtn];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = LineBGColor;
    [self.headView addSubview:line];
    
}

- (void)addSubViews{
    
    [self addBGview];
    [self addScrollView];
    [self addCandleChartView];
    [self addTopBoxView];
    [self addPriceView];
    [self addBottomView];
    [self addChartTitle];
    [self addGestureToCandleView];
    
}

- (void)addBottomView{
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 140 - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = KBGColor;
    [self.KlineBgView addSubview:line];
    
    NSArray * arr = @[@"1小时",@"MA"];
    for (int i = 0; i < 2; i ++) {
        //        UIButton * btn = [self createBtn:arr[i] frame:CGRectMake(btnW * i, 103, btnW, 12)];
        //        [headView addSubview:btn];
        
        UIButton * btn = [self createBtnTiltle:arr[i] frame:CGRectMake((KbtnWidth + intalval) * i + 16, 120, KbtnWidth, 20)];
        [btn addTarget:self action:@selector(seletItem:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 500 + i;
        [self.KlineBgView addSubview:btn];
        
    }
    
    UIButton * foldBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 20, 120, 20, 20)];
    foldBtn.tag = 200;
    [foldBtn setImage:[UIImage imageNamed:@"kline_fold"] forState:UIControlStateNormal];
    [foldBtn addTarget:self action:@selector(showKline:) forControlEvents:UIControlEventTouchUpInside];
    [self.KlineBgView addSubview:foldBtn];
    
}

- (void)showKline:(UIButton *)btn{
    if (btn.tag == 200) {
        self.KlineBgView.hidden = YES;
        self.headView.hidden = NO;
    }else{
        self.KlineBgView.hidden = NO;
        self.headView.hidden = YES;
    }
}

- (void)seletItem:(UIButton *)btn{
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
    //    _verticalLabel.hidden = YES;
    _verticalView.hidden = YES;
    //    _lineTextView.hidden = YES;
}

- (NSArray *)klineTypes{
    if (!_klineTypes) {
        _klineTypes = @[@"分时",@"1分",@"5分",@"15分",@"30分",@"1小时",@"4小时",@"1天",@"1周",@"1月"];
    }
    return _klineTypes;
}

- (UIView *)ktypeBGView{
    if (!_ktypeBGView) {
        
        int count = 5.0;
        _ktypeBGView = [[UIView alloc] initWithFrame:CGRectMake(16, 140, (KbtnWidth + 10)* count, 35 * 2)];
        _ktypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.view addSubview:_ktypeBGView];
        _ktypeBGView.hidden = YES;
        
        
        for (int index = 0; index < self.klineTypes.count; index ++) {
            
            UIButton * btn = [self createBtn:self.klineTypes[index] frame:CGRectMake((KbtnWidth+ 10) * (index %count) + 5, (index / count) * 35, KbtnWidth, 28)];
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
    
    
    //    [self resetData];
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
        _mainQuotaTypeBGView = [[UIView alloc] initWithFrame:CGRectMake(16 + (KbtnWidth + intalval), 140, KbtnWidth, quotaArr.count * btnH)];
        _mainQuotaTypeBGView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.view addSubview:_mainQuotaTypeBGView];
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

- (void)addBGview{
    self.KlineBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    self.KlineBgView.hidden = YES;
    [self.view addSubview:self.KlineBgView];
}

- (void)addScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 57, 120)];
    [self.KlineBgView addSubview:_scrollView];
    
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    
}

- (void)addCandleChartView
{
    _candleChartView = [[ZTYMainChartView alloc] init];
    [_scrollView addSubview:_candleChartView];
    _candleChartView.mainquotaName = MainViewQuotaNameWithMA;
    _candleChartView.mainchartType = MainChartcenterViewTypeKline;
    _candleChartView.delegate = self;
    _candleChartView.NoBottm = YES;
    _candleChartView.lineCount = 5;
    [_candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.height.equalTo(@(120));
        make.top.equalTo(_scrollView);
    }];
    
    
    _candleChartView.candleSpace = 2;
    _candleChartView.displayCount = 160;
    _displayCount = _candleChartView.displayCount;
    _candleChartView.lineWidth = 1*widthradio;
    UITapGestureRecognizer * candleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(candleClick:)];
    [_candleChartView addGestureRecognizer:candleTap];
}

- (void)addTopBoxView
{
    _topBoxView = [UIView new];
    [self.KlineBgView addSubview:_topBoxView];
    _topBoxView.userInteractionEnabled = NO;
    _topBoxView.layer.borderWidth = 0;
    _topBoxView.layer.borderColor = [UIColor blackColor].CGColor;
    [_topBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(BoxborderWidth);
        make.left.equalTo(_scrollView.mas_left).offset(-BoxborderWidth);
        make.right.equalTo(_scrollView.mas_right).offset(BoxborderWidth);
        make.height.equalTo(@(120));
    }];
    
}

- (void)addGestureToCandleView
{
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    [self.candleChartView addGestureRecognizer:longPressGesture];
    
    UIPinchGestureRecognizer *  pinchPressGesture= [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchesView:)];
    [self.scrollView addGestureRecognizer:pinchPressGesture];
    
}

- (void)initCrossLine
{
    
    self.verticalView = [UIView new];
    self.verticalView.clipsToBounds = YES;
    [self.scrollView addSubview:self.verticalView];
    self.verticalView.backgroundColor = LineBGColor;//[UIColor colorWithHexString:@"666666"];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_candleChartView);
        make.width.equalTo(@(0.5));
        make.height.equalTo(@(120));
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
        make.top.equalTo(@(120 - 12));
        make.width.equalTo(@(100));
        make.height.equalTo(@(12));
        make.left.equalTo(@(0));
    }];
    
    self.latestLinetextView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, -SCREEN_HEIGHT, SCREEN_WIDTH - 5, 20)];
    [self.KlineBgView addSubview:self.latestLinetextView];
    
    self.verticalView.hidden = YES;
    self.verticalLabel.hidden = YES;
}

- (void)addPriceView
{
    CGFloat percandlePriceHeight = 120 / 5.0;
    _candlePrice = [ZYWPriceView new];
    [self.KlineBgView addSubview:_candlePrice];
    [_candlePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBoxView).offset(percandlePriceHeight);
        make.height.equalTo(@(percandlePriceHeight * 4));
        make.right.equalTo(self.KlineBgView).offset(8);
        make.left.equalTo(_topBoxView.mas_right).offset(9);
    }];
    
    ZTYNounLine * rightLine = [[ZTYNounLine alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 57, percandlePriceHeight, 9, percandlePriceHeight * 4)];
    rightLine.lineWidth = 1;
    rightLine.strokeColor = LineBGColor;//[UIColor lightGrayColor];
    [rightLine setNounlinewidthNouns:@[@(0),@(percandlePriceHeight),@(percandlePriceHeight * 2),@(percandlePriceHeight * 3)]];
    [self.KlineBgView addSubview:rightLine];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 120 - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = KBGColor;
    [self.KlineBgView addSubview:line];
    
}

#pragma mark -- 当前K线数据指标值显示
- (void)addChartTitle{
    
    UILabel * label = [self createLabelTitle:@"" frame:CGRectMake(0, 2, SCREEN_HEIGHT, 10)];
    label.font = [UIFont fontWithName:@"DINAlternate-Bold" size:10];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    [self.KlineBgView addSubview:label];
    _descLabel = label;
    
    
    UILabel * riseDropLabel = [self createLabelTitle:@"涨幅：+0.27%  振幅：0.44%" frame:CGRectMake(10,  12, SCREEN_WIDTH - 32, 10)];
    riseDropLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:riseDropLabel.text];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[riseDropLabel.text rangeOfString:@"+0.27%"]];
    riseDropLabel.attributedText = att;
    _roseDropLabel = riseDropLabel;
    
    [self.KlineBgView addSubview:riseDropLabel];
}


#pragma mark -- 请求数据
- (void)requestData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    self.candleChartView.isFreshing = NO;
    param[@"type"] = self.ktype;
    param[@"size"] = @"400";
    
    
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
    
    
    //
    NSLog(@"param======>%@",param);
    //    NMShowLoadIng;  //@"http://47.94.217.12:18081/app/api/kline/line" //
    [BTERequestTools requestWithURLString:kGetKLineData parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            
            NSLog(@"responseObject======>%@",responseObject);
            NSArray * kDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"kline"];
            if (kDataArr.count > 0) {
                
                self.end = [NSString stringWithFormat:@"%@",[[kDataArr firstObject] objectForKey:@"date"]];
                
                clockCount = 3;
                //开启定时器
                [weakSelf.timer setFireDate:[NSDate distantPast]];
                
            }
            
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
            
            NSArray *QuotaDataArray = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            [weakSelf reloadData:QuotaDataArray reload:_isrelaod];
            
            
            if (self.dataSource.count > 0) {
                ZTYChartModel * lastModel = [self.dataSource lastObject];
                
                // ZYWCandleModel * firstModel = [self.dataSource lastObject];
                self.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
                // self.end = [NSString stringWithFormat:@"%ld",firstModel.timestamp];
                clockCount = 3;
                //开启定时器
                [weakSelf.timer setFireDate:[NSDate distantPast]];
                
            }
            
            weakSelf.latesetClose = [[[[responseObject objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
            
            [weakSelf updateLatestTextLine];
            
            NSDictionary * tickerDict = [[responseObject objectForKey:@"data"] objectForKey:@"ticker"];
            
            [weakSelf updateHeader:tickerDict];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)updateHeader:(NSDictionary *)tickerDict{
    
    
    NSString * priceStr = [NSString stringWithFormat:@"$%@",[ZTYCalCuteNumber calculateBesideLing:[[tickerDict objectForKey:@"price"] doubleValue]]];
    
    NSString * changestr = @"";
    UIColor * changeColor = DropColor;
    if ([[tickerDict objectForKey:@"change"] floatValue] < 0) {
        changestr = [NSString stringWithFormat:@"%.2f%%",[[tickerDict objectForKey:@"change"] floatValue] * 100];
        changeColor = [UIColor colorWithHexString:@"FF4040"];
    }else{
        changestr = [NSString stringWithFormat:@"+%.2f%%",[[tickerDict objectForKey:@"change"] floatValue] * 100];
        changeColor = RoseColor;
    }
    
    NSString * headStr = [NSString stringWithFormat:@"%@：%@  %@",self.base,priceStr,changestr];
    NSMutableAttributedString * cnyatt = [[NSMutableAttributedString alloc] initWithString:headStr];
    NSRange range = [headStr rangeOfString:[NSString stringWithFormat:@"%@",changestr]];
    [cnyatt addAttribute:NSForegroundColorAttributeName value:changeColor range:range];
    [cnyatt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:10] range:range];
    
    NSRange range2 = [headStr rangeOfString:[NSString stringWithFormat:@"%@",priceStr]];
    [cnyatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF4040"] range:range2];
    [cnyatt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:16] range:range2];
    
    self.headLabel.attributedText = cnyatt;
}

- (void)requestLastModelData{
    
    self.candleChartView.isFreshing = YES;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.ktype;
    param[@"size"] = @"5"; //
    
    if (self.base.length > 0) {
        param[@"base"] = self.base;//@"btc";
    }
    
    
    if (self.exchange.length > 0) {
        param[@"exchange"] = self.exchange;
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
                    
                    ZTYChartModel * LastModel = [self.dataSource lastObject];
                    [LastModel initBaseDataWithDict:obj];
                }
                
            }];
            
            NSArray *QuotaDataArray = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            [self reloadData:QuotaDataArray reload:2];
            
            
            
            self.latesetClose = [[[[responseObject objectForKey:@"data"] objectForKey:@"ticker"] objectForKey:@"close"] floatValue];
            
            [weakSelf updateLatestTextLine];
            
            NSDictionary * tickerDict = [[responseObject objectForKey:@"data"] objectForKey:@"ticker"];
            
            [weakSelf updateHeader:tickerDict];
            
            if (self.dataSource.count > 0) {
                ZTYChartModel * lastModel = [self.dataSource lastObject];
                
                self.start = [NSString stringWithFormat:@"%@",lastModel.timestamp];
            }
            
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        //        RequestError(error);
    }];
    
}

- (void)reloadData:(NSArray *)array reload:(int)reload
{
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

- (void)updateLatestTextLine{
    
    //    if (self.latesetClose) {
    [self.latestLinetextView setText:[NSString stringWithFormat:@"  %@  ",[ZTYCalCuteNumber calculate:self.latesetClose]]];
    CGFloat pointY = [_candleChartView getPointYculateValue:self.latesetClose];
    if (pointY < 0 ) {
        pointY = 20;
    }
    
    if ( pointY > 120) {
        pointY = 120;
    }
    [self.latestLinetextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pointY - 10);
    }];
    //    }
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
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin));
        }];
        
        [self.verticalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin - 50));
        }];
        
        self.verticalView.hidden = NO;
        
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
    
    //    [self hiddenAllChoseBGView];
    
    CGFloat xPositoin = location.x; // + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f
    CGFloat yPositoin = location.y; //+ self.candleChartView.topMargin
    [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(xPositoin));
    }];
    [self.verticalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(xPositoin - 50));
    }];
    
    
    self.verticalView.hidden = NO;
    //    self.lineTextView.hidden = NO;
    self.verticalLabel.hidden = NO;
}

//- (void)hiddenAllChoseBGView{
//    _ktypeBGView.hidden = YES;
//    [self updateBtnStatus:500 title:@"" imageHide:NO];
//    _mainQuotaTypeBGView.hidden = YES;
//    [self updateBtnStatus:501 title:@"" imageHide:NO];
//}

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
#pragma mark -- 附图代理
/**
 点按手势获得当前k线下标以及模型
 
 @param kLineModeIndex 当前k线在可视范围数组的位置下标
 @param kLineModel   k线模型
 */
- (void)tapCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)index price:(CGFloat)price{
    
    self.verticalLabel.text = [NSString stringWithFormat:@"%@",kLineModel.timeStr];
    [self updateDeslAndRosedrop:kLineModel];
}

#pragma mark -- 主图代理
- (void)displayLastModel:(ZTYChartModel *)kLineModel
{
    
    [self updateDeslAndRosedrop:kLineModel];
    [self updateLatestTextLine];
    
}

- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)startIndex
{
    
    _verticalLabel.text = [NSString stringWithFormat:@"%@",kLineModel.timeStr];
    [self updateDeslAndRosedrop:kLineModel];
}

- (void)updateDeslAndRosedrop:(ZTYChartModel *)kLineModel{
    
    NSString * descText = [NSString stringWithFormat:@"  %@ 开：%@ 高：%@ 低：%@ 收：%@  ",kLineModel.timeString,[ZTYCalCuteNumber calculateBesideLing:kLineModel.open],[ZTYCalCuteNumber calculateBesideLing:kLineModel.high],[ZTYCalCuteNumber calculateBesideLing:kLineModel.low],[ZTYCalCuteNumber calculateBesideLing:kLineModel.close]];
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
}

/**
 加载更多数据
 */
- (void)displayMoreData{
    
    NSLog(@"正在加载更多....");
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

#pragma mark -- 初始化
- (UILabel *)createLabelTitle:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    return label;
}

- (UIButton *)createBtnTiltle:(NSString *)title frame:(CGRect)frame{
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    btn.titleLabel.font =  font;
    [btn setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
    
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
    
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(5,  5+ width, 0,  - 5 - width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    return btn;
}

- (void)updateBtnStatus:(NSInteger)tag title:(NSString *)title imageHide:(BOOL) isHidden hideBackColor:(UIColor *)backColor{
    
    UIButton * button = [self.KlineBgView viewWithTag:tag];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
        button.imageEdgeInsets = UIEdgeInsetsMake(5,  5+ width, 0,  - 5 - width);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        
    }else{
        if (isHidden) {
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            button.backgroundColor = backColor;//[UIColor colorWithHexString:@"308cdd"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
            CGFloat width = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
            
            button.imageEdgeInsets = UIEdgeInsetsMake(5,  5+ width, 0,  - 5 - width);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        }
    }
    
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

