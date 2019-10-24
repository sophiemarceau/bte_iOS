//
//  ZTYTestViewController.m
//  BTE
//
//  Created by wanmeizty on 2018/5/31.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYTestViewController.h"

//#import "ZYWCandleChartView.h"
#import "ZTYChartModel.h"
//#import "ZYWTecnnicalView.h"
#import "ZYWMacdView.h"
#import "ZYWCalcuteTool.h"
#import "ZYWKdjLineView.h"
#import "ZYWWrLineView.h"
#import "ZYWPriceView.h"
#import "ZYWQuotaView.h"
#import "ZTYChartProtocol.h"
#import "ZYWCandlePostionModel.h"

#import "ZTYRSILineView.h"
#import "BTEFSKLineViewController.h"
#import "ZXQuotaDataReformer.h"

#import "ZTYMainKChartView.h"
#import "ZTYVolumCahrtView.h"
#import "ZTYLineTextView.h"

typedef enum
{
    MACD = 1,
    KDJ,
    WR,
    RSI
}DataLineType;

#define ScrollScale 1.00
#define CandleChartScale 0.60
#define TechnicalViewScale 0.18
#define BottomViewScale 0.22

#define MinCount 20
#define MaxCount 240

#define headHeight (167 + 64+32)
#define QuotaY 131

#define btnWidth 60

@interface ZTYTestViewController ()
<ZTYChartProtocol>

@property (nonatomic,strong) ZYWQuotaView *quotaView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) ZTYMainKChartView *candleChartView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) ZTYChartModel *model;
@property (nonatomic,strong) UIView *topBoxView;
@property (nonatomic,strong) UIView *bottomBoxView;
//@property (nonatomic,strong) ZYWTecnnicalView *technicalView;
@property (nonatomic,strong) ZTYVolumCahrtView * volumeView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,assign) DataLineType type;
@property (nonatomic,strong) ZYWMacdView *macdView;
@property (nonatomic,strong) ZYWKdjLineView *kdjLineView;
@property (nonatomic,strong) ZYWWrLineView *wrLineView;
@property (nonatomic,strong) ZTYRSILineView * rsiLineView;
@property (nonatomic,strong) ZYWPriceView *topPriceView;
@property (nonatomic,strong) ZYWPriceView *bottomPriceView;
@property (nonatomic,strong) ZYWPriceView *volumePrice;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchPressGesture;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong) UIView *verticalView;
@property (nonatomic,strong) UIView *leavView;
@property (nonatomic,strong) BTEFSKLineViewController *screenVC;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic,strong) ZTYLineTextView * lineTextView;

@property (nonatomic,strong) UIView * kLineBGView;

@property (nonatomic, assign) NSUInteger zoomRightIndex;
@property (nonatomic, assign) CGFloat currentZoom;
@property (nonatomic, assign) NSInteger displayCount;

@property (nonatomic,strong) UIView * headView;
@property (nonatomic,strong) UIView * ktypeBGView,*mainQuotaTypeBGView,*fitureQuotaBGView;
@property (nonatomic,strong) UILabel * descLabel,*roseDropLabel,*mainTextLabel,*volumTextLabel,*fitureTextLabel;

@property (nonatomic,copy) NSString * ktype;
@property (nonatomic,copy) NSString * end;
@property (nonatomic,assign) int isreload;

@end

@implementation ZTYTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title  = @"K线图";
    _isreload = 0;
    self.ktype = @"1h";
    _type = MACD;
    [self addSubViews];
    [self addBottomViews];
    [self initCrossLine];
    [self addPriceView];
    [self addChartTitle];
    [self addActivityView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    
    [self requestData];
    
}

// K线相关
- (void)addChartTitle{
    
    _mainTextLabel = [self createLabelTitle:@"" frame:CGRectMake(5, 2, SCREEN_WIDTH - 62, 10)];
    _mainTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.kLineBGView addSubview:_mainTextLabel];
    _mainTextLabel.hidden = YES;
    
    _volumTextLabel = [self createLabelTitle:@"" frame:CGRectMake(5,2+ (DEVICE_HEIGHT - headHeight)*CandleChartScale, SCREEN_WIDTH - 62, 10)];
    _volumTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.kLineBGView addSubview:_volumTextLabel];
    _volumTextLabel.hidden = YES;
    
    _fitureTextLabel = [self createLabelTitle:@"" frame:CGRectMake(5,  2 +(DEVICE_HEIGHT - headHeight)*(CandleChartScale + TechnicalViewScale), SCREEN_WIDTH - 62, 10)];
    _fitureTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.kLineBGView addSubview:_fitureTextLabel];
}

- (void)upddateChartViewModel:(ZTYChartModel *)model{
    
    
    _volumTextLabel.text = [NSString stringWithFormat:@"VOL:%ld",model.volumn.integerValue];
    _volumTextLabel.hidden = NO;
    
    if (_candleChartView.mainquotaName == MainViewQuotaNameWithBOLL) {
        
        _mainTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"BOLL(20,2) MB:%.2f UP:%.2f DN:%.2f",model.BOLL_MB.floatValue,model.BOLL_UP.floatValue,model.BOLL_DN.floatValue];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:[title rangeOfString:[NSString stringWithFormat:@"MB:%.2f",model.BOLL_MB.floatValue]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor magentaColor] range:[title rangeOfString:[NSString stringWithFormat:@"UP:%.2f",model.BOLL_UP.floatValue]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[title rangeOfString:[NSString stringWithFormat:@"DN:%.2f",model.BOLL_DN.floatValue]]];
        _mainTextLabel.attributedText = attr;
        
    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithMA){
        _mainTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"MA5:%.2f MA10:%.2f MA30:%.2f",model.MA5.floatValue,model.MA10.floatValue,model.MA30.floatValue];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:[title rangeOfString:[NSString stringWithFormat:@"MA5:%.2f",model.MA5.floatValue]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor magentaColor] range:[title rangeOfString:[NSString stringWithFormat:@"MA10:%.2f",model.MA10.floatValue]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[title rangeOfString:[NSString stringWithFormat:@"MA30:%.2f",model.MA30.floatValue]]];
        _mainTextLabel.attributedText = attr;
    }else if (_candleChartView.mainquotaName == MainViewQuotaNameWithNone){
        _mainTextLabel.hidden = YES;
    }
}

- (void)upddateQuotaViewDict:(NSDictionary *)dict{
    
    if (_type == MACD) {
        _fitureTextLabel.hidden = NO;
        NSString * title = [NSString stringWithFormat:@"MACD:%@ DIFF:%@ DEA:%@",[dict valueForKey:@"key1"],[dict valueForKey:@"key2"],[dict valueForKey:@"key3"]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        
        if ([[dict valueForKey:@"key3"] floatValue]>0) {
            [attr addAttribute:NSForegroundColorAttributeName value:RoseColor range:[title rangeOfString:[NSString stringWithFormat:@"MACD:%@",[dict valueForKey:@"key1"]]]];
        }else{
            [attr addAttribute:NSForegroundColorAttributeName value:DropColor range:[title rangeOfString:[NSString stringWithFormat:@"MACD:%@",[dict valueForKey:@"key1"]]]];
        }
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[title rangeOfString:[NSString stringWithFormat:@"DIFF:%@",[dict valueForKey:@"key2"]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[title rangeOfString:[NSString stringWithFormat:@"DEA:%@",[dict valueForKey:@"key3"]]]];
        _fitureTextLabel.attributedText = attr;
        
    }else if (_type == KDJ){
        _fitureTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"K:%@ D:%@ J:%@",[dict valueForKey:@"key1"],[dict valueForKey:@"key2"],[dict valueForKey:@"key3"]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[title rangeOfString:[NSString stringWithFormat:@"K:%@",[dict valueForKey:@"key1"]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[title rangeOfString:[NSString stringWithFormat:@"D:%@",[dict valueForKey:@"key2"]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[title rangeOfString:[NSString stringWithFormat:@"J:%@",[dict valueForKey:@"key3"]]]];
        _fitureTextLabel.attributedText = attr;
    }else if (_type == RSI){
        _fitureTextLabel.hidden = NO;
        NSString * title = [NSString stringWithFormat:@"RSI6:%@ RSI12:%@ RSI24:%@",[dict valueForKey:@"key1"],[dict valueForKey:@"key2"],[dict valueForKey:@"key3"]];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[title rangeOfString:[NSString stringWithFormat:@"RSI6:%@",[dict valueForKey:@"key1"]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[title rangeOfString:[NSString stringWithFormat:@"RSI12:%@",[dict valueForKey:@"key2"]]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[title rangeOfString:[NSString stringWithFormat:@"RSI24:%@",[dict valueForKey:@"key3"]]]];
        _fitureTextLabel.attributedText = attr;
    }else if (_type == WR){
        _fitureTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"WR:%@",[dict valueForKey:@"key1"]];
        _fitureTextLabel.textColor = [UIColor redColor];
        _fitureTextLabel.text = title;
    }
}

// 顶部视图
- (void)addHeaderView{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 131 + 36)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    _headView = headView;
    
    UILabel *pricelabel = [self createLabelTitle:[NSString stringWithFormat:@"$%.2f",[self.desListModel.price floatValue]] frame:CGRectMake(16, 16, 150, 30)];
    pricelabel.tag = 712;
    pricelabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:30];
    pricelabel.textColor = [UIColor colorWithHexString:@"FF4040"];
    [headView addSubview:pricelabel];
    
    NSString * changeStr = [NSString stringWithFormat:@"%.2f%%", [self.desListModel.change floatValue]];
    UILabel *cnylabel = [self createLabelTitle:[NSString stringWithFormat:@"≈81.11CNY  %@",changeStr] frame:CGRectMake(16, 58, 150, 12)];
    cnylabel.tag = 711;
    NSMutableAttributedString * attubustr = [[NSMutableAttributedString alloc] initWithString:cnylabel.text];
    NSRange range1 = [cnylabel.text rangeOfString:changeStr];
    [attubustr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF4040"] range:range1];
    cnylabel.attributedText = attubustr;
    [headView addSubview:cnylabel];
    
    UILabel * onedayLabel = [self createLabelTitle:@"24h量：23万  24h额：11亿美元" frame:CGRectMake(16, 80, 200, 12)];
    onedayLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    onedayLabel.tag = 710;
    [headView addSubview:onedayLabel];
    
    UIView * horizenLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 14, 1, 79)];
    horizenLine.backgroundColor = LineBGColor;
    [headView addSubview:horizenLine];
    
    NSArray * lefts = @[@"高",@"开",@"低",@"收"];
    for (int i = 0; i < lefts.count; i ++) {
        //        UILabel * rightValueLabel = [self createLabelTitle:@"12.2987" frame:CGRectMake(SCREEN_WIDTH - 91, 11 + 25 * i, 75, 25)];
        //        rightValueLabel.tag = 200 + i;
        //        rightValueLabel.textAlignment = NSTextAlignmentRight;
        //        [headView addSubview:rightValueLabel];
        UILabel * leftLabel = [self createLabelTitle:[NSString stringWithFormat:@"%@：%@",lefts[i],@"12.2987"] frame:CGRectMake(SCREEN_WIDTH - 89, 14 + (12 + 10) * i, 90, 12)];
        leftLabel.textColor = backBlue;
        [headView addSubview:leftLabel];
        leftLabel.tag = 700 + i;
        leftLabel.font =  [UIFont fontWithName:@"DINAlternate-Bold" size:14];
    }
    
    CGFloat left = 7.8 + 8.5 + 40 + 24;
    
    UIButton *fullBtn = [[UIButton alloc] init];
    [fullBtn setTitle:@"全屏" forState:UIControlStateNormal];
    [fullBtn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    [fullBtn setImage:[UIImage imageNamed:@"full_screen"] forState:UIWindowLevelNormal];
    fullBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    fullBtn.frame = CGRectMake(SCREEN_WIDTH - left, 101, 7.8 + 8.5  + 24, 30);
    fullBtn.showsTouchWhenHighlighted = YES;
    fullBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    // 重点位置开始
    fullBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 24 + 7.8, 0, -24 - 7.8);
    fullBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -8.5, 0, 8.5);
    // 重点位置结束
    fullBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [fullBtn addTarget:self action:@selector(clickFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:fullBtn];
    
    //    _ktypeBtnView = [[ZTYKTypeBtnView alloc] initWithFrame:CGRectMake(16, 87, SCREEN_WIDTH - left - 10 - 16, 32) types:self.ktypes];
    //    _ktypeBtnView.delegate = self;
    //    [headView addSubview:_ktypeBtnView];
    //    CGFloat btnW = 60;//(SCREEN_WIDTH - (7.8 + 8.5 + 40 + 24) - 10) / 3.0;
    NSArray * arr = @[@"分时",@"主指标",@"MACD"];
    for (int i = 0; i < 3; i ++) {
        //        UIButton * btn = [self createBtn:arr[i] frame:CGRectMake(btnW * i, 103, btnW, 12)];
        //        [headView addSubview:btn];
        UIButton * btn = [self createBtnTiltle:arr[i] frame:CGRectMake((btnWidth + 10) * i + 16, 103, btnWidth, 28)];
        [btn addTarget:self action:@selector(selectTypeItem:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 500 + i;
        [headView addSubview:btn];
        
    }
    //    UIView * verticalLine = [[UIView alloc] initWithFrame:CGRectMake((btnW - 16) * 0.5, 129, 16, 2)];
    //    verticalLine.backgroundColor = backBlue;
    //    [headView addSubview:verticalLine];
    //    verticalLine.tag = 999;
    
    UIView * infoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 131, SCREEN_WIDTH, 36)];
    infoBGView.backgroundColor = [UIColor colorWithHexString:@"E8ECEF"];
    [headView addSubview:infoBGView];
    
    UILabel * descLabel = [self createLabelTitle:@"2018-05-18 11:00 开7991.19  高8019.17 低7984.21 收8009.00" frame:CGRectMake(16, 4, SCREEN_WIDTH - 32, 14)];
    descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [infoBGView addSubview:descLabel];
    _descLabel = descLabel;
    
    UILabel * riseDropLabel = [self createLabelTitle:@"涨幅+0.27%  振幅0.44%" frame:CGRectMake(16, 18, SCREEN_WIDTH - 32, 14)];
    riseDropLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:riseDropLabel.text];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[riseDropLabel.text rangeOfString:@"+0.27%"]];
    riseDropLabel.attributedText = att;
    _roseDropLabel = riseDropLabel;
    
    [infoBGView addSubview:riseDropLabel];
    
}


- (void)addQuotaBorderView
{
    UIView *bottomLineView = [UIView new];
    [self.kLineBGView addSubview:bottomLineView];
    bottomLineView.userInteractionEnabled = NO;
    bottomLineView.backgroundColor = LineBGColor;
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(DEVICE_HEIGHT - headHeight));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.kLineBGView).offset(1);
        make.height.equalTo(@(1));
    }];
    
    UIView * volumeBottomLine = [UIView new];
    [self.kLineBGView addSubview:volumeBottomLine];
    volumeBottomLine.userInteractionEnabled = NO;
    volumeBottomLine.backgroundColor = LineBGColor;
    [volumeBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@((DEVICE_HEIGHT - headHeight) * (CandleChartScale + TechnicalViewScale)));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.kLineBGView).offset(1);
        make.height.equalTo(@(1));
    }];
    
    UIView * mainViewBottomLine = [UIView new];
    [self.kLineBGView addSubview:mainViewBottomLine];
    mainViewBottomLine.userInteractionEnabled = NO;
    mainViewBottomLine.backgroundColor = LineBGColor;
    [mainViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@((DEVICE_HEIGHT - headHeight) * (CandleChartScale) ));
        make.left.equalTo(_scrollView.mas_left).offset(-1);
        make.right.equalTo(self.kLineBGView).offset(1);
        make.height.equalTo(@(1));
    }];
    
    UIView * rightLine = [UIView new];
    rightLine.backgroundColor = LineBGColor;
    [self.kLineBGView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_scrollView);
        make.width.equalTo(@(1));
        make.left.equalTo(_scrollView.mas_right);
    }];
}

- (void)updateHeadData:(NSDictionary *)dict{
    
    NSLog(@"Tickers====>%@",dict);
    
    UILabel * onedayLabel = [_headView viewWithTag:710];
    
    onedayLabel.text = [NSString stringWithFormat:@"24h量：%@  24h额：%@美元",[self caculateValue:[[dict objectForKey:@"vol"] doubleValue]],[self caculateValue:[[dict objectForKey:@"amountVol"] doubleValue]]];
    UILabel * hight = [_headView viewWithTag:700];
    UILabel * open = [_headView viewWithTag:701];
    UILabel * low = [_headView viewWithTag:702];
    UILabel * close = [_headView viewWithTag:703];
    hight.text = [NSString stringWithFormat:@"高：%.2lf",[[dict objectForKey:@"high"] doubleValue]];
    open.text = [NSString stringWithFormat:@"开：%.2lf",[[dict objectForKey:@"open"] doubleValue]];
    low.text = [NSString stringWithFormat:@"低：%.2lf",[[dict objectForKey:@"low"] doubleValue]];
    close.text = [NSString stringWithFormat:@"收：%.2lf",[[dict objectForKey:@"close"] doubleValue]];
    
    UILabel *cnylabel = [_headView viewWithTag:711];
    //    cnylabel.text = [NSString stringWithFormat:@"≈%.2lfCNY  %@",[[dict objectForKey:@"cnyPrice"] doubleValue],[dict objectForKey:@"change"]];
    NSString * cnyStr = [NSString stringWithFormat:@"≈%.2lfCNY  %@%%",[[dict objectForKey:@"cnyPrice"] doubleValue],[dict objectForKey:@"change"]];
    NSMutableAttributedString * cnyatt = [[NSMutableAttributedString alloc] initWithString:cnyStr];
    NSRange range = [cnyStr rangeOfString:[NSString stringWithFormat:@"%@%%",[dict objectForKey:@"change"]]];
    [cnyatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff4040"] range:range];
    cnylabel.attributedText = cnyatt;
    
    UILabel *pricelabel = [_headView viewWithTag:712];
    pricelabel.text = [NSString stringWithFormat:@"$%@",[self caculateValue:[[dict objectForKey:@"price"] doubleValue]]];
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

#pragma mark --event

// 全屏模式
- (void)clickFullScreen{
    BTEFSKLineViewController * fvc = [[BTEFSKLineViewController alloc] init];
    fvc.model = self.desListModel;
    [self presentViewController:fvc animated:NO completion:nil];
    //    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

#pragma mark -- 设置主图指标、附图指标、K线类型选择
- (void)selectTypeItem:(UIButton *)btn{
    
    [self hiddenAllChoseBGView];
    
    if (btn.tag == 500) {
        // K线
        self.ktypeBGView.hidden = NO;
        _scrollView.scrollEnabled = NO;
        [self updateBtnStatus:500 title:@"" imageHide:YES];
        
    }else if(btn.tag == 501){
        // 主图指标
        self.mainQuotaTypeBGView.hidden = NO;
        _scrollView.scrollEnabled = NO;
        [self updateBtnStatus:501 title:@"" imageHide:YES];
    }else if(btn.tag == 502){
        // 附图指标
        self.fitureQuotaBGView.hidden = NO;
        _scrollView.scrollEnabled = NO;
        [self updateBtnStatus:502 title:@"" imageHide:YES];
    }
}



- (UIView *)ktypeBGView{
    if (!_ktypeBGView) {
        
        CGFloat btnH = 28;
        _ktypeBGView = [[UIView alloc] initWithFrame:CGRectMake(16, 131, btnWidth * 3, 28 * 3)];
        _ktypeBGView.backgroundColor = [UIColor colorWithHexString:@"1e2237"];
        [self.view addSubview:_ktypeBGView];
        _ktypeBGView.hidden = YES;
        NSArray *ktypes = @[@"分时",@"1分",@"5分",@"15分",@"1小时",@"4小时",@"1天"];
        for (int index = 0; index < ktypes.count; index ++) {
            
            UIButton * btn = [self createBtn:ktypes[index] frame:CGRectMake(btnWidth * (index %3), (index / 3) * btnH, btnWidth, btnH)];
            [btn addTarget:self action:@selector(choseKtypeItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2000 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_ktypeBGView addSubview:btn];
            if (index == 0) {
                btn.backgroundColor = [UIColor colorWithHexString:@"0d67e9"];
            }
        }
    }
    return _ktypeBGView;
}

- (void)choseKtypeItem:(UIButton *)btn{
    
    for (int i = 0; i < 7; i ++) {
        UIButton * button = [_ktypeBGView viewWithTag:2000 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"1e2237"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"0d67e9"];
    
    [self updateBtnStatus:500 title:btn.titleLabel.text imageHide:NO];
    _ktypeBGView.hidden = YES;
    _ktype = btn.titleLabel.text;
    _isreload = 0;
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
        NSArray * quotaArr = @[@"BOLL",@"MA",@"关闭"];
        _mainQuotaTypeBGView = [[UIView alloc] initWithFrame:CGRectMake(16 + (btnWidth + 10), 131, btnWidth, quotaArr.count * btnH)];
        _mainQuotaTypeBGView.backgroundColor = [UIColor colorWithHexString:@"1e2237"];
        [self.view addSubview:_mainQuotaTypeBGView];
        _mainQuotaTypeBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, 0 + index * btnH, btnWidth, btnH)];
            [btn addTarget:self action:@selector(chosequptaItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2100 + index;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_mainQuotaTypeBGView addSubview:btn];
            if (index == quotaArr.count - 1) {
                btn.backgroundColor = [UIColor colorWithHexString:@"0d67e9"];
            }
        }
    }
    return _mainQuotaTypeBGView;
}

- (void)chosequptaItem:(UIButton *)btn{
    
    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [_mainQuotaTypeBGView viewWithTag:2100 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"1e2237"];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"0d67e9"];
    
    if ([btn.titleLabel.text isEqualToString:@"关闭"]) {
        [self updateBtnStatus:501 title:@"主指标" imageHide:NO];
        _candleChartView.mainquotaName = MainViewQuotaNameWithNone;
        [_candleChartView stockFill];
    }else if([btn.titleLabel.text isEqualToString:@"BOLL"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO];
        _candleChartView.mainquotaName = MainViewQuotaNameWithBOLL;
        [_candleChartView stockFill];
    }else if ([btn.titleLabel.text isEqualToString:@"MA"]){
        [self updateBtnStatus:501 title:btn.titleLabel.text imageHide:NO];
        _candleChartView.mainquotaName = MainViewQuotaNameWithMA;
        [_candleChartView stockFill];
    }
    
    _mainQuotaTypeBGView.hidden = YES;
}

-(UIView *)fitureQuotaBGView{
    if (!_fitureQuotaBGView) {
        
        CGFloat btnH = 40;
        NSArray * quotaArr = @[@"MACD",@"KDJ",@"RSI",@"WR"];
        _fitureQuotaBGView = [[UIView alloc] initWithFrame:CGRectMake(16 + (btnWidth + 10) * 2, 131, btnWidth, quotaArr.count * btnH)];
        _fitureQuotaBGView.backgroundColor = [UIColor colorWithHexString:@"1e2237"];
        [self.view addSubview:_fitureQuotaBGView];
        _fitureQuotaBGView.hidden = YES;
        
        for (int index = 0; index < quotaArr.count; index ++) {
            UIButton * btn = [self createBtn:quotaArr[index] frame:CGRectMake(0, index * btnH, btnWidth, btnH)];
            btn.tag = 2200 + index;
            [btn addTarget:self action:@selector(choseFitureQuotaItem:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_fitureQuotaBGView addSubview:btn];
            if (index == 0) {
                btn.backgroundColor = [UIColor colorWithHexString:@"0d67e9"];
            }
        }
    }
    return _fitureQuotaBGView;
}

- (void)choseFitureQuotaItem:(UIButton *)quotaBtn{
    
    
    for (int i = 0; i < 4; i ++) {
        UIButton * button = [_fitureQuotaBGView viewWithTag:2200 + i];
        button.backgroundColor = [UIColor colorWithHexString:@"1e2237"];
    }
    quotaBtn.backgroundColor = [UIColor colorWithHexString:@"0d67e9"];
    
    NSInteger tag = 502;
    NSString *title = quotaBtn.titleLabel.text;
    if ([quotaBtn.titleLabel.text isEqualToString:@"关闭"]) {
        [self updateBtnStatus:tag title:@"指标" imageHide:NO];
        //        _quotaChartView.quotaName = MainViewQuotaNameWithNone;
        //        [_quotaChartView stockFill];
    }else if([quotaBtn.titleLabel.text isEqualToString:@"MACD"]){
        [self updateBtnStatus:tag title:title imageHide:NO];
        //        _quotaChartView.quotaName = FigureViewQuotaNameWithMACD;
        //        [_quotaChartView stockFill];
        _type = MACD;
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"KDJ"]){
        [self updateBtnStatus:tag title:title imageHide:NO];
        //        _quotaChartView.quotaName = FigureViewQuotaNameWithKDJ;
        //        [_quotaChartView stockFill];
        _type = KDJ;
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"RSI"]){
        [self updateBtnStatus:tag title:title imageHide:NO];
        //        _quotaChartView.quotaName = FigureViewQuotaNameWithRSI;
        //        [_quotaChartView stockFill];
        _type = RSI;
    }else if ([quotaBtn.titleLabel.text isEqualToString:@"WR"]){
        [self updateBtnStatus:tag title:title imageHide:NO];
        //        _quotaChartView.quotaName = FigureViewQuotaNameWithWR;
        //        [_quotaChartView stockFill];
        _type = WR;
    }
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
}

#pragma mark -- deal data
- (void)requestData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.ktype;
    param[@"size"] = @"400";
    self.candleChartView.isFreshing = NO;
    
    //    param[@"client"] = @"ios";
    //    param[@"exchange"] = self.exchange;
    
    
    if (self.desListModel.symbol.length > 0) {
        param[@"base"] = self.desListModel.symbol;//@"btc";
    }
    
    
    
    if (self.desListModel.exchange.length > 0) {
        param[@"exchange"] = self.desListModel.exchange;
    }
    
    
    
    if (self.desListModel.quote.length > 0) {
        param[@"quote"] = self.desListModel.quote;
    }
    
    
    //    if (self.start) {
    //        param[@"start"] = self.start;
    //        //转为字符型
    //    }
    if (self.end) {
        [param setObject:self.end forKey:@"end"];
    }
    
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
    }
    
    if (!_activityView.animating) {
        
    }else{
        self.candleChartView.isFreshing = YES;
    }
    
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:kGetKLineData parameters:param type:1 success:^(id responseObject) {
        //        NMRemovLoadIng;
        [_activityView stopAnimating];
        if (IsSafeDictionary(responseObject)) {
            NSArray * kDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"kline"];
            if (kDataArr.count >0) {
                self.end = [[kDataArr firstObject] objectForKey:@"date"];
                //                self. = [[kDataArr lastObject] objectForKey:@"date"];
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
            
            //            for (int i = 0; i < kDataArr.count; i ++) {
            //                NSDictionary * obj = kDataArr[kDataArr.count - i-1];
            //                ZYWCandleModel * model = [[ZYWCandleModel alloc] init];
            //                model.x = i;
            //                model.preKlineModel = preModel;
            //                [model initBaseDataWithDict:obj];
            //                [arry addObject:model];
            //                preModel = model;
            //            }
            if (self.dataSource.count > 0 && arry.count > 0 ) {
                ZTYChartModel * first = [self.dataSource firstObject];
                ZTYChartModel * last = [arry lastObject];
                first.preKlineModel = last;
            }
            [arry addObjectsFromArray:self.dataSource];
            self.dataSource = arry.mutableCopy;
            //            [self.dataSource addObjectsFromArray:[[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:arry]];
            NSArray *QuotaDataArray = [[ZXQuotaDataReformer sharedInstance] initializeQuotaDataWithArray:self.dataSource];
            [self reloadData:QuotaDataArray reload:_isreload];
            
        }
    } failure:^(NSError *error) {
        [_activityView stopAnimating];
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
    
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

- (void)addQuotaView
{
    _quotaView = [ZYWQuotaView new];
    _quotaView.backgroundColor = RoseColor;
    [self.kLineBGView addSubview:_quotaView];
    [_quotaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.right.equalTo(self.kLineBGView);
        make.height.equalTo(@(100));
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
        make.top.equalTo(@(0));
        make.left.equalTo(self.kLineBGView);
        make.right.equalTo(self.kLineBGView).offset(-57);
        make.height.equalTo(@((DEVICE_HEIGHT - headHeight)*ScrollScale));
    }];
}

- (void)addCandleChartView
{
    _candleChartView = [ZTYMainKChartView new];
    [_scrollView addSubview:_candleChartView];
    _candleChartView.mainquotaName = MainViewQuotaNameWithMA;
    _candleChartView.mainchartType = MainChartcenterViewTypeKline;
    _candleChartView.delegate = self;
    _currentZoom = -.001f;
    [_candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.height.equalTo(@((DEVICE_HEIGHT - headHeight)*CandleChartScale));
        make.top.equalTo(_scrollView);
    }];
    
    _candleChartView.candleSpace = 2;
    _candleChartView.displayCount = 160;
    _displayCount = _candleChartView.displayCount;
    _candleChartView.lineWidth = 1*widthradio;
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
        make.height.equalTo(@((DEVICE_HEIGHT - headHeight)*CandleChartScale));
    }];
}

- (void)addTechnicalView
{
    //    _technicalView = [ZYWTecnnicalView new];
    //    [self.view addSubview:_technicalView];
    //    _technicalView.delagate = self;
    //
    //    [_technicalView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_candleChartView.mas_bottom);
    //        make.left.right.equalTo(_scrollView);
    //        make.height.equalTo(@((DEVICE_HEIGHT-headHeight)*TechnicalViewScale));
    //    }];
    //
    //    [_technicalView.macdButton setTitle:@"MACD" forState:UIControlStateNormal];
    //    [_technicalView.wrButton setTitle:@"WR" forState:UIControlStateNormal];
    //    [_technicalView.kdjButton setTitle:@"KDJ" forState:UIControlStateNormal];
    
    _volumeView = [[ZTYVolumCahrtView alloc] init];;
    [_scrollView addSubview:_volumeView];
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_candleChartView.mas_bottom);
        make.left.right.equalTo(_scrollView);
        make.height.equalTo(@((DEVICE_HEIGHT-headHeight)*TechnicalViewScale));
    }];
    
    _volumeView.candleSpace = 2;
    _volumeView.displayCount = 50;
    _volumeView.lineWidth = BoxborderWidth; //1 *widthradio;
}

- (void)addBottomView
{
    _bottomView = [UIView new];
    [_scrollView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_volumeView.mas_bottom).offset(1*widthradio);
        make.left.right.equalTo(_candleChartView);
        make.height.equalTo(@((DEVICE_HEIGHT- headHeight)*BottomViewScale));
    }];
    [_bottomView layoutIfNeeded];
}

- (void)addBottomBoxView
{
    _bottomBoxView = [UIView new];
    [self.kLineBGView addSubview:_bottomBoxView];
    _bottomBoxView.userInteractionEnabled = NO;
    _bottomBoxView.layer.borderWidth = 0*widthradio;
    _bottomBoxView.layer.borderColor = [UIColor blackColor].CGColor;
    [_bottomBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top).offset(-1*heightradio);
        make.left.equalTo(_scrollView.mas_left).offset(-1*widthradio);
        make.right.equalTo(_scrollView.mas_right).offset(1*widthradio);
        make.height.equalTo(@((DEVICE_HEIGHT - headHeight)*BottomViewScale));
    }];
}

- (void)addPriceView
{
    _topPriceView = [ZYWPriceView new];
    [self.kLineBGView addSubview:_topPriceView];
    
    [_topPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_topBoxView);
        make.right.equalTo(self.kLineBGView);
        make.left.equalTo(_scrollView.mas_right);
    }];
    
    
    _volumePrice = [ZYWPriceView new];
    [self.kLineBGView addSubview:_volumePrice];
    
    [_volumePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBoxView).offset((DEVICE_HEIGHT-headHeight)*CandleChartScale);
        make.height.equalTo(@((DEVICE_HEIGHT-headHeight)*TechnicalViewScale));
        make.right.equalTo(self.kLineBGView);
        make.left.equalTo(_scrollView.mas_right);
    }];
    
    _bottomPriceView = [ZYWPriceView new];
    [self.kLineBGView addSubview:_bottomPriceView];
    
    [_bottomPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomView);
        make.right.equalTo(self.kLineBGView);
        make.left.equalTo(_scrollView.mas_right);
    }];
}

- (void)addSubViews
{
    //    [self addQuotaView];
    [self addKLineBGView];
    [self addHeaderView];
    [self addScrollView];
    [self addCandleChartView];
    [self addTopBoxView];
    [self addTechnicalView];
    [self addBottomView];
    [self addBottomBoxView];
    [self addQuotaBorderView];
    [self addGestureToCandleView];
}

- (void)addKLineBGView{
    self.kLineBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 167, SCREEN_WIDTH, SCREEN_HEIGHT - headHeight)];
    [self.view addSubview:self.kLineBGView];
}

#pragma mark 添加手势

- (void)addGestureToCandleView
{
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    [self.candleChartView addGestureRecognizer:longPressGesture];
    
    UIPinchGestureRecognizer *  pinchPressGesture= [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchesView:)];
    [self.scrollView addGestureRecognizer:pinchPressGesture];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    _tapGesture.numberOfTapsRequired = 2;
    [self.candleChartView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *  tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapClick{
    [self hiddenAllChoseBGView];
}

#pragma mark 指标视图

- (void)addBottomViews
{
    _macdView = [ZYWMacdView new];
    [_bottomView addSubview:_macdView];
    _macdView.lineWidth = 1*widthradio;
    [_macdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomView);
        make.left.right.equalTo(_bottomView);
    }];
    
    _kdjLineView = [ZYWKdjLineView new];
    [_bottomView addSubview:_kdjLineView];
    _kdjLineView.lineWidth = 1*widthradio;
    [_kdjLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomView);
        make.left.right.equalTo(_bottomView);
    }];
    _kdjLineView.hidden = YES;
    
    _wrLineView = [ZYWWrLineView new];
    [_bottomView addSubview:_wrLineView];
    _wrLineView.lineWidth = 1*widthradio;
    [_wrLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomView);
        make.left.right.equalTo(_bottomView);
    }];
    _wrLineView.hidden = YES;
    
    _rsiLineView = [ZTYRSILineView new];
    [_bottomView addSubview:_rsiLineView];
    _rsiLineView.lineWidth = 1*widthradio;
    [_rsiLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomView);
        make.left.right.equalTo(_bottomView);
    }];
    _rsiLineView.hidden = YES;
}

#pragma mark 十字线

- (void)initCrossLine
{
    self.verticalView = [UIView new];
    self.verticalView.clipsToBounds = YES;
    [self.scrollView addSubview:self.verticalView];
    self.verticalView.backgroundColor = [UIColor colorWithHexString:@"666666"];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBoxView);
        make.width.equalTo(@(_candleChartView.lineWidth));
        make.bottom.equalTo(_macdView);
        make.left.equalTo(@(0));
    }];
    
    //    self.leavView = [UIView new];
    //    self.leavView.clipsToBounds = YES;
    //    [self.scrollView addSubview:self.leavView];
    //    self.leavView.backgroundColor = [UIColor colorWithHexString:@"666666"];;
    //    [self.leavView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(@(0));
    //        make.left.equalTo(self.kLineBGView);
    //        make.right.equalTo(self.candleChartView);
    //        make.height.equalTo(@(_candleChartView.lineWidth));
    //    }];
    
    self.lineTextView = [[ZTYLineTextView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 5, 20)];
    [self.kLineBGView addSubview:self.lineTextView];
    
    self.lineTextView.hidden = YES;
    self.leavView.hidden = YES;
    self.verticalView.hidden = YES;
}

#pragma mark 指标切换代理

- (void)didSelectButton:(UIButton *)button index:(NSInteger)index
{
    if (index == 1)
    {
        _type = MACD;
    }
    
    else if (index == 2)
    {
        _type = WR;
    }
    
    else
    {
        _type = KDJ;
    }
    
    [self showIndexLineView:self.candleChartView.leftPostion startIndex:self.candleChartView.currentStartIndex count:self.candleChartView.displayCount];
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
        CGFloat yPositoin = point.y +_candleChartView.topMargin;
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin));
        }];
        [_quotaView layoutIfNeeded];
        
        //        [self.leavView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(yPositoin);
        //        }];
        
        [self.lineTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(yPositoin - 10);
        }];
        self.lineTextView.hidden = NO;
        self.verticalView.hidden = NO;
        self.leavView.hidden = NO;
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        if(self.verticalView)
        {
            self.verticalView.hidden = YES;
        }
        
        if(self.leavView)
        {
            self.leavView.hidden = YES;
        }
        
        if (self.lineTextView) {
            self.lineTextView.hidden = YES;
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
        
        ZYWCandlePostionModel *model = self.candleChartView.currentPostionArray.lastObject;
        _zoomRightIndex = model.localIndex + 1;
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

#pragma mark 横屏手势

- (void)tapGesture:(UITapGestureRecognizer*)tapGesture
{
    _screenVC = [BTEFSKLineViewController new];
    _screenVC.model = self.desListModel;
    [self presentViewController:_screenVC animated:NO completion:nil];
}

- (void)reloadData:(NSMutableArray*)array reload:(BOOL)reload
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _macdView.dataArray = computeMACDData(array).mutableCopy;
        _kdjLineView.dataArray = computeKDJData(array).mutableCopy;
        _wrLineView.dataArray = computeWRData(array,10).mutableCopy;
        _rsiLineView.dataArray = array.mutableCopy;
        _volumeView.dataArray = array.mutableCopy;
        for (NSInteger i = 0;i<array.count;i++)
        {
            ZTYChartModel *model = array[i];
            if (i % 16 == 0)
            {
                model.isDrawDate = YES;
            }
            
            else
            {
                model.isDrawDate = NO;
            }
        }
        
        self.candleChartView.dataArray = array;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reload)
            {
                [self.candleChartView reload];
            }
            
            else
            {
                [self.candleChartView stockFill];
            }
        });
    });
}

#pragma mark candleLineDelegeta

- (void)displayQuotaLastObj:(NSObject *)model{
    [self dealShowQutadataWidthModel:model];
}

- (void)dealShowQutadataWidthModel:(NSObject *)mode{
    if (_type == MACD && [mode isKindOfClass:[ZYWMacdModel class]]) {
        ZYWMacdModel * model = (ZYWMacdModel *)mode;
        _fitureTextLabel.hidden = NO;
        
        NSString * title = [NSString stringWithFormat:@"MACD(12,26,9) DIF:%.2f DEA:%.2f MACD:%.2f",model.diff,model.dea,model.macd];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"DF8ADF"] range:[title rangeOfString:[NSString stringWithFormat:@"MACD:%.2f",model.macd]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ACD2E5"] range:[title rangeOfString:[NSString stringWithFormat:@"DIF:%.2f",model.diff]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F0BC79"] range:[title rangeOfString:[NSString stringWithFormat:@"DEA:%.2f",model.dea]]];
        _fitureTextLabel.attributedText = attr;
    }else if (_type == RSI){
        ZTYChartModel * model = (ZTYChartModel *)mode;
        _fitureTextLabel.hidden = NO;
        NSString * title = [NSString stringWithFormat:@"RSI(6,12,24) RSI6:%.2f RSI12:%.2f RSI24:%.2f",model.RSI_6.floatValue,model.RSI_12.floatValue,model.RSI_24.floatValue];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"B2DBEF"] range:[title rangeOfString:[NSString stringWithFormat:@"RSI6:%.2f",model.RSI_6.floatValue]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FDC071"] range:[title rangeOfString:[NSString stringWithFormat:@"RSI12:%.2f",model.RSI_12.floatValue]]];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"EA9BEA"] range:[title rangeOfString:[NSString stringWithFormat:@"RSI24:%.2f",model.RSI_24.floatValue]]];
        _fitureTextLabel.attributedText = attr;
    }
}

- (void)displayLastModel:(ZTYChartModel *)kLineModel
{
    //    _quotaView.model = kLineModel;
    [self updateDeslAndRosedrop:kLineModel];
    [self upddateChartViewModel:kLineModel];
    if (_type == RSI) {
        [self dealShowQutadataWidthModel:kLineModel];
    }
}

- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)startIndex
{
    //    _quotaView.model = kLineModel;
    if (_type == MACD) {
        
    }else if (_type == KDJ){
        
    }else if (_type == RSI){
        [self dealShowQutadataWidthModel:kLineModel];
    }
    [self updateDeslAndRosedrop:kLineModel];
    [self upddateChartViewModel:kLineModel];
}


- (void)updateDeslAndRosedrop:(ZTYChartModel *)kLineModel{
    [_lineTextView setText:[NSString stringWithFormat:@"%.2f",kLineModel.close]];
    _descLabel.text = [NSString stringWithFormat:@"%@ 开%.2f  高%.2f 低%.2f 收%.2f",kLineModel.timeStr,kLineModel.open,kLineModel.high,kLineModel.low,kLineModel.close];
    
    CGFloat dr = roundf(((kLineModel.close - kLineModel.preKlineModel.close) / kLineModel.preKlineModel.close )* 100000.0 + 0.5) / 1000.0;
    CGFloat dx = roundf((kLineModel.high / kLineModel.low - 1.0) * 100000.0 + 0.5)/1000.0;
    NSString * roseDropStr = [NSString stringWithFormat:@"涨幅:%.2f%% 振幅：%.2f%%",dr,dx];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:roseDropStr];
    if (dr < 0) {
        [att addAttribute:NSForegroundColorAttributeName value:RoseColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"%.2f%%",dr]]];
    }else{
        [att addAttribute:NSForegroundColorAttributeName value:DropColor range:[roseDropStr rangeOfString:[NSString stringWithFormat:@"%.2f%%",dr]]];
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
    
    _topPriceView.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.candleChartView.maxY];
    _topPriceView.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",(self.candleChartView.maxY - self.candleChartView.minY)/2 + self.candleChartView.minY];
    _topPriceView.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.candleChartView.minY];
    
    _volumePrice.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.volumeView.maxY];
    _volumePrice.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.volumeView.minY];
    
    if (_type == MACD)
    {
        [_kdjLineView setHidden:YES];
        [_wrLineView setHidden:YES];
        [_rsiLineView setHidden:YES];
        [_macdView setHidden:NO];
        _macdView.candleSpace = _candleChartView.candleSpace;
        _macdView.candleWidth = _candleChartView.candleWidth;
        _macdView.leftPostion = leftPostion;
        _macdView.startIndex = index;
        _macdView.displayCount = count;
        [_macdView stockFill];
        
        _bottomPriceView.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.macdView.maxY];
        _bottomPriceView.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",(self.macdView.maxY - self.macdView.minY)/2 + self.macdView.minY];
        _bottomPriceView.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.macdView.minY];
    }
    
    else  if (_type == WR)
    {
        [_kdjLineView setHidden:YES];
        [_macdView setHidden:YES];
        [_rsiLineView setHidden:YES];
        [_wrLineView setHidden:NO];
        _wrLineView.candleSpace = _candleChartView.candleSpace;
        _wrLineView.candleWidth = _candleChartView.candleWidth;
        _wrLineView.leftPostion = leftPostion;
        _wrLineView.startIndex = index;
        _wrLineView.displayCount = count;
        [_wrLineView stockFill];
        
        _bottomPriceView.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.wrLineView.maxY];
        _bottomPriceView.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",(self.wrLineView.maxY - self.wrLineView.minY)/2 + self.wrLineView.minY];
        _bottomPriceView.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.wrLineView.minY];
    }
    
    else if(_type == KDJ)
    {
        [_kdjLineView setHidden:NO];
        [_macdView setHidden:YES];
        [_rsiLineView setHidden:YES];
        [_wrLineView setHidden:YES];
        _kdjLineView.candleSpace = _candleChartView.candleSpace;
        _kdjLineView.candleWidth = _candleChartView.candleWidth;
        _kdjLineView.leftPostion = leftPostion;
        _kdjLineView.startIndex = index;
        _kdjLineView.displayCount = count;
        [_kdjLineView stockFill];
        
        _bottomPriceView.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.kdjLineView.maxY];
        _bottomPriceView.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",(self.kdjLineView.maxY - self.kdjLineView.minY)/2 + self.kdjLineView.minY];
        _bottomPriceView.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.kdjLineView.minY];
    }else if (_type == RSI){
        [_kdjLineView setHidden:YES];
        [_macdView setHidden:YES];
        [_wrLineView setHidden:YES];
        [_rsiLineView setHidden:NO];
        _rsiLineView.candleSpace = _candleChartView.candleSpace;
        _rsiLineView.candleWidth = _candleChartView.candleWidth;
        _rsiLineView.leftPostion = leftPostion;
        _rsiLineView.startIndex = index;
        _rsiLineView.displayCount = count;
        [_rsiLineView stockFill];
        
        _bottomPriceView.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.rsiLineView.maxY];
        _bottomPriceView.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",(self.rsiLineView.maxY - self.rsiLineView.minY)/2 + self.wrLineView.minY];
        _bottomPriceView.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.rsiLineView.minY];
    }
}

//- (void)displayMoreData
//{
//    _isreload = 1;
//    NSLog(@"正在加载更多....");
//    [_activityView startAnimating];
//    __weak typeof(self) this = self;
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [this loadMoreData];
//    });
//}
//
//- (void)loadMoreData
//{
////    NSMutableArray *tempArray = _candleChartView.dataArray.mutableCopy;
////    for (NSInteger i = 0; i < _candleChartView.dataArray.count; i++) {
////        ZYWCandleModel *model = _candleChartView.dataArray[i];
////        [tempArray addObject:model];
////    }
////    [self reloadData:tempArray reload:YES];
//    [self requestData];
//
//    [_activityView stopAnimating];
//}

- (UIButton *)createBtn:(NSString *)title frame:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = frame;
    //    [btn setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [btn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    return btn;
}

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
    
    //    btn.titleLabel.backgroundColor = [UIColor yellowColor];
    //    btn.imageView.backgroundColor = [UIColor greenColor];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
    //    CGSize titleSize = btn.titleLabel.bounds.size;
    CGSize imageSize = btn.imageView.bounds.size;
    btn.imageEdgeInsets = UIEdgeInsetsMake(14,width, 9, -width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 4, 0, imageSize.width + 4);
    return btn;
}

#pragma mark 屏幕相关

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(void)dealloc{
    NSLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

