//
//  BTEHomePageTableView.m
//  BTE
//
//  Created by wangli on 2018/3/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEHomePageTableView.h"
#import "BTEHomePageTableViewCell.h"
#import "LBBannerView.h"
#import "UserStatistics.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)
#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@implementation BTEHomePageTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        btcStr = ethStr = eosStr =bchStr= @"";
        _dataSource = nil;
        _homePageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _homePageTableView.backgroundColor = KBGColor;
        _homePageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homePageTableView.delegate = self;
        _homePageTableView.dataSource = self;
        defaultHeight = 68;
        fixedHeight = 52;
        btnHeight = 20;
        defaultScrollHeight = 149.00f;
        _isShow = NO;//初始化不展开
        [self addSubview:_homePageTableView];
       
//
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(subEventHandle:)
//                                                     name:RESUME_ANIMATIONS
//                                                   object:nil];
    }
    return self;
}

-(UILabel *)marketDateLabel{
    if (_marketDateLabel == nil) {
        _marketDateLabel = [[UILabel alloc] init];
        _marketDateLabel.frame = CGRectMake(60,39, SCREEN_WIDTH-60-50, SCALE_W(16));
        _marketDateLabel.textColor = BHHexColor(@"979DA5");
        _marketDateLabel.font = UIFontLightOfSize(12);
    }
    return _marketDateLabel;
}

-(UILabel *)marketTitleLabel{
    if (_marketTitleLabel == nil) {
        _marketTitleLabel = [[UILabel alloc] init];
        _marketTitleLabel.frame = CGRectMake(60,16, SCREEN_WIDTH-60-50, SCALE_W(16));
        _marketTitleLabel.textColor = BHHexColor(@"626A75");
        _marketTitleLabel.font = UIFontMediumOfSize(16);
    }
    return _marketTitleLabel;
}

-(UIView *)marketView{
    if (_marketView == nil) {
        _marketView = [UIView new];
        _marketView.frame = CGRectMake(0, 0 , SCREEN_WIDTH, 66);
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marketAnalysisIcon"]];
        iconImageView.frame = CGRectMake(16, 16, SCALE_W(34), SCALE_W(36));
        [_marketView addSubview:iconImageView];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more-1"]];
        arrowImageView.frame = CGRectMake(SCREEN_WIDTH - 6.5 - 16, 26, 6.5, 13);
        [_marketView addSubview:arrowImageView];
        [_marketView addSubview:self.marketTitleLabel];
        [_marketView addSubview:self.marketDateLabel];
        _marketView.backgroundColor = BHHexColor(@"FAFAFA");
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 66);
        [btn addTarget:self action:@selector(gotoDetailMarket:) forControlEvents:UIControlEventTouchUpInside];
        [_marketView addSubview:btn];
    }
    return _marketView;
}

-(UIView *)atmosphereView{
    if(_atmosphereView == nil ){
        _atmosphereView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 86)];
        _atmosphereView.backgroundColor = BHHexColor(@"F9F9FA");
        UIButton *btn;
        UILabel *desLabel;
        UILabel *titleLabel;
        UIView *verticalLine;
        self.btnViewsArray = [NSMutableArray array];
        self.accountArray = [NSMutableArray array];
        for(int i = 0; i < 3 ;i++){
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            verticalLine = [[UIView alloc] init];
            titleLabel = [[UILabel alloc] init];
            desLabel = [[UILabel alloc] init];
            btn.frame = CGRectMake(i*(SCREEN_WIDTH  )/3, 0, (SCREEN_WIDTH)/3, 86);
            [_atmosphereView addSubview:btn];
            btn.backgroundColor = [UIColor clearColor];
            
            titleLabel.frame = CGRectMake(SCALE_W(0) , SCALE_W(22), SCREEN_WIDTH/3, SCALE_W(14));
            titleLabel.font = UIFontRegularOfSize(SCALE_W(14));
            titleLabel.textColor = BHHexColor(@"626A75");
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:titleLabel];
            if (i == 0) {
                titleLabel.text = @"空气指数";
            }
            if (i == 1) {
                titleLabel.text = @"交易规模";
            }
            if (i == 2) {
                titleLabel.text = @"资金流向";
            }
            desLabel.frame = CGRectMake(SCALE_W(0), SCALE_W(48),SCREEN_WIDTH/3,SCALE_W(18));
            [btn addSubview:desLabel];
            desLabel.backgroundColor  = [UIColor clearColor];
            desLabel.textAlignment = NSTextAlignmentLeft;
            desLabel.font = UIFontDINAlternateOfSize(SCALE_W(18));
            desLabel.textColor = BHHexColor(@"FF4040");
            desLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.accountArray addObject:desLabel];
            
            if(i < 2){
                verticalLine.frame = CGRectMake((SCREEN_WIDTH  )/3-1, SCALE_W(34), 1, SCALE_W(30));
                verticalLine.backgroundColor = [UIColor colorWithHexString:@"D8E0E9"];
            }
            [btn addSubview:verticalLine];
            btn.tag = i;
            [btn addTarget:self action:@selector(gotoAtmospereVc:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.btnViewsArray addObject:btn];
        }
    }
    return _atmosphereView;
}

#pragma mark - webView
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALE_W(272));
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.backgroundColor = BHHexColor(@"F9F9FA");
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled =NO;
    }
    //请求
    self.urlString = kHomePageHeaderH5Url;
    if (self.urlString || ![self.urlString isEqualToString:@""]) {
        NSURL *URL = [NSURL URLWithString:self.urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        [_webView loadRequest:request];
    }
    return _webView;
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    if (!webView.isLoading)
//    {
//        NSString *bodyHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
//    }
//}

-(void)gotoAtmospereVc:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoAtmosphereVc:)]) {
        [self.delegate gotoAtmosphereVc:(int)(sender.tag)];
    }
}

-(void)gotoDetailMarket:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDetails:)]) {
        [self.delegate jumpToDetails:descriptionModel];
    }
}

- (void)TapChange:(UITapGestureRecognizer *)taps{
    if (self.delegate && headModel.symbol && [self.delegate respondsToSelector:@selector(doTapChange:)]) {
        [self.delegate doTapChange:headModel.symbol];
    }
}

- (void)gotoTradeDataPage:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToTradeDataPage)]) {
        [self.delegate jumpToTradeDataPage];
    }
}

- (void)trademoreButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToTradeDataPage)]) {
        [self.delegate jumpToTradeDataPage];
    }
}

- (void)gotoKPage:(UIButton *)sender{
    sender.enabled = NO;
    if (_dataSource && _dataSource.count > 0 ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDetail:)]) {
            HomeDesListModel *model = [_dataSource objectAtIndex:sender.tag];
            model.isRead = sender.selected;
            [self.delegate jumpToDetail:model];
        }
    }
    sender.enabled = YES;
}

- (void)gotoDogPageButton:(UIButton *)sender{
    sender.enabled = NO;
    [self setPageTag:sender.tag];
    sender.enabled = YES;
}

-(void)gotoDogPage:(UITapGestureRecognizer *)sender{
    sender.enabled = NO;
    [self setPageTag:sender.view.tag];
    sender.enabled = YES;
}

-(void)setPageTag:(NSUInteger)index{
    if (index == 100001) {
       
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            newImageView.hidden = YES;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDogPage)]) {
            [self.delegate jumpToDogPage];
        }
    }
    if (index == 100002) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToBandDogPage)]) {
            [self.delegate jumpToBandDogPage];
            
        }
    }
    if (index == 100003) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToContractDogPage)]) {
            [self.delegate jumpToContractDogPage];
        }
    }
    if (index == 100004) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToResearchDogPage)]) {
            [self.delegate jumpToResearchDogPage];
        }
    }
    if (index == 100005) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToStareDogPage)]) {
            [self.delegate jumpToStareDogPage];
        }
    }
    
    if (index == 100006) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToChainCheckPage)]) {
            [self.delegate jumpToChainCheckPage];
        }
    }
}

//- (void)gotoDogPage{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDogPage)]) {
//        [self.delegate jumpToDogPage];
//    }
//}

//- (void)gotobandratioDogPage{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToBandDogPage)]) {
//        [self.delegate jumpToBandDogPage];
//    }
//}

//- (void)gotoContractDogPage{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToContractDogPage)]) {
//        [self.delegate jumpToContractDogPage];
//    }
//}
//- (void)gotoresearchDogPage{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToResearchDogPage)]) {
//        [self.delegate jumpToResearchDogPage];
//    }
//}
- (void)tapJump{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToChatPage)]) {
        [self.delegate jumpToChatPage];
    }
}

- (void)onclickMarketFlash{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onclickMarketflashStatistic)]) {
        [self.delegate onclickMarketflashStatistic];
    }
}

//设置头部视图
- (void)setTableHeadView{
    UIView *bgView;
    bgView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //    [self.webView sizeThatFits:CGSizeMake(SCREEN_WIDTH,SCALE_W(272))];
    if(bannerArray && bannerArray.count > 0){
        [bgView addSubview:self.atmosphereView];
        
        UIView *bannerBgView = [UIView new];
        bannerBgView.backgroundColor =  BHHexColor(@"FAFAFA");
        bannerBgView.frame = CGRectMake(0, self.atmosphereView.bottom +6, SCREEN_WIDTH, 51);
        
        TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
        pagerView.layout.layoutType = TYCyclePagerTransformLayoutCoverflow;
        pagerView.frame = CGRectMake(0, 2, SCREEN_WIDTH, (46));
        pagerView.layer.borderWidth = 0;
        //    pagerView.isInfiniteLoop = YES;
        pagerView.autoScrollInterval = 6.0;
        pagerView.dataSource = self;
        pagerView.delegate = self;
        [pagerView setNeedUpdateLayout];
        // registerClass or registerNibr
        [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
        _bannrView = pagerView;
        
        [bannerBgView addSubview:_bannrView];
        [bgView addSubview:bannerBgView];
        [bgView addSubview:self.marketView];
        
        self.marketView.frame = CGRectMake(0, bannerBgView.bottom +6, SCREEN_WIDTH, self.marketView.frame.size.height);
        bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.marketView.bottom + 6);
    }else{
        bgView = [[UIView alloc] initWithFrame:CGRectZero];
        [bgView addSubview:self.atmosphereView];
        [bgView addSubview:self.marketView];
        self.marketView.frame = CGRectMake(0, self.atmosphereView.bottom +6, SCREEN_WIDTH, self.marketView.frame.size.height);
        bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.marketView.bottom + 6);
    }
    [self.bannrView reloadData];
    bgView.backgroundColor = KBGColor;
    self.homePageTableView.tableHeaderView = bgView;
    
    self.marketTitleLabel.text = descriptionModel.title;
    self.marketDateLabel.text = descriptionModel.date;
    
    //    NSString *requestParams = [NSString stringWithFormat:@"?base=%@&quote=%@&exchange=%@",headModel.symbol,headModel.quote,headModel.exchange];
    
    //    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 17, 17)];
    //    [_iconImage sd_setImageWithURL:[NSURL URLWithString:headModel.icon] placeholderImage:nil];
    //    [bgView addSubview:_iconImage];
    //
    //    _subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(38, 12, 75, 17)];
    //    _subTitleLabel1.text = [NSString stringWithFormat:@"%@行情",headModel.symbol];
    //
    //    _subTitleLabel1.font = UIFontMediumOfSize(17);
    //    _subTitleLabel1.textColor = BHHexColor(@"626A75");
    //    [bgView addSubview:_subTitleLabel1];
    //
    //    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    sureButton.frame = CGRectMake(38, 10, 136, 30);
    ////    sureButton.backgroundColor = [UIColor redColor];
    //    [sureButton addTarget:self action:@selector(TapChange:) forControlEvents:UIControlEventTouchUpInside];
    //    [bgView addSubview:sureButton];
    //
    //    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(111, 18, 9, 9)];
    //    arrowImage.image = [UIImage imageNamed:@"home_arrow_bg"];
    //    [bgView addSubview:arrowImage];
    //
    //    _subTitleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 110, 20)];
    //    _subTitleLabel3.left = SCREEN_WIDTH - _subTitleLabel3.width - 16;
    //    _subTitleLabel3.textAlignment = NSTextAlignmentRight;
    //    NSString *priceString = [NSString stringWithFormat:@"%.2f",[headModel.price floatValue]];
    //    _subTitleLabel3.text = [NSString stringWithFormat:@"$%@",priceString];
    //
    //    _subTitleLabel3.font = UIFontDINAlternateOfSize(20);
    //    _subTitleLabel3.textColor = BHHexColor(@"228B22");
    //    [bgView addSubview:_subTitleLabel3];
    
    //    _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, _subTitleLabel3.bottom + 5, 50, 16)];
    //    _buttonView.backgroundColor = [UIColor whiteColor];
    //    _buttonView.layer.masksToBounds = YES;
    //    _buttonView.layer.cornerRadius = 2;
    //    _buttonView.right = SCREEN_WIDTH - 52;
    //    [bgView addSubview:_buttonView];
    
    
    //    _subTitleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];
    //    _subTitleLabel5.textAlignment = NSTextAlignmentCenter;
    //    _subTitleLabel5.font = UIFontRegularOfSize(12);
    //    _subTitleLabel5.textColor = BHHexColor(@"FFFFFF");
    //    [_buttonView addSubview:_subTitleLabel5];
    //
    //
    //    if ([headModel.change floatValue] > 0) {
    //        _subTitleLabel5.text = [NSString stringWithFormat:@"+%.2f",[headModel.change floatValue]];
    //    } else
    //    {
    //        _subTitleLabel5.text = [NSString stringWithFormat:@"%.2f",[headModel.change floatValue]];
    //    }
    //
    //    if ([headModel.change floatValue] > 0) {
    //        _buttonView.backgroundColor = BHHexColor(@"228B22");
    //    } else if ([headModel.change floatValue] < 0)
    //    {
    //        _buttonView.backgroundColor = BHHexColor(@"FF4040");
    //    } else
    //    {
    //        _buttonView.backgroundColor = BHHexColor(@"228B22");
    //    }
    
    //    _subTitleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(124, 38, 40, 12)];
    //    _subTitleLabel4.alpha = 0.6;
    //    _subTitleLabel4.text = @"(24h)";
    //    _subTitleLabel4.textAlignment = NSTextAlignmentRight;
    //    _subTitleLabel4.font = UIFontRegularOfSize(12);
    //    _subTitleLabel4.textColor = BHHexColor(@"525866");
    //    _subTitleLabel4.right = SCREEN_WIDTH - 21;
    //    [bgView addSubview:_subTitleLabel4];
    
    
    
    //    self.homePageTableView.tableHeaderView = bgView;
}

//设置尾部视图
- (void)setTableFooterView{
    UIView *footerView = [UIView new];
    UIView *headView;
    CGFloat reloadHeight = (CGFloat)(6+50 + defaultScrollHeight + 23);
    
    UIView *marketMessageView = [[UIView alloc] init];
    marketMessageView.backgroundColor = BHHexColor(@"F9F9FA");
    
    UIView *grayView = [UIView new];
    grayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
    grayView.backgroundColor = KBGColor;
    [marketMessageView addSubview:grayView];
    
//    UIImageView *image11 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 6+16, 18, 18)];
//    image11.image = [UIImage imageNamed:@"home_shichangkuaixun"];
//    [marketMessageView addSubview:image11];
    
    UILabel *messagetitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 6+18, 80, 18)];
    messagetitleLabel.text = @"市场快讯";
    messagetitleLabel.font = UIFontMediumOfSize(14);
    messagetitleLabel.textColor = BHHexColor(@"626A75");
    [marketMessageView addSubview:messagetitleLabel];
    marketMessageView.frame = CGRectMake(0, 0, SCREEN_WIDTH,reloadHeight );
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, marketMessageView.bottom, SCREEN_WIDTH, 187)];
    headView.backgroundColor = KBGColor;
    
    //    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 151)];
    //    bgView.backgroundColor = KBGCell;
    //    [headView addSubview:bgView];
    //
    //    UILabel *titleLabels = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, SCREEN_WIDTH, 17)];
    //    titleLabels.text = @"软银中国资本&蓝驰创投A轮战略投资";
    //    titleLabels.font = UIFontRegularOfSize(17);
    //    titleLabels.textAlignment = NSTextAlignmentCenter;
    //    titleLabels.textColor = BHHexColor(@"525866");
    //    [bgView addSubview:titleLabels];
    //
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(81, 123.1, 203, 34)];
    image3.image = [UIImage imageNamed:@"logo"];
    [headView addSubview:image3];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 20, 66, 66)];
    image1.image = [UIImage imageNamed:@"qr"];
    [headView addSubview:image1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 89, 70, 10)];
    titleLabel.text = @"打开微信扫一扫";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = image1.centerX;
    titleLabel.font = UIFontRegularOfSize(10);
    titleLabel.textColor = BHHexColor(@"AEAEAE");
    [headView addSubview:titleLabel];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(104, 21, 22, 12)];
    image2.image = [UIImage imageNamed:@"home_dibu_logo"];
    [headView addSubview:image2];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(129, 20, 195, 14)];
    titleLabel1.text = @"区块链市场数据分析工具";
    titleLabel1.font = UIFontRegularOfSize(14);
    titleLabel1.textColor = BHHexColor(@"626A75");
    [headView addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(104, 39, SCREEN_WIDTH - 104 - 16, 25)];
    titleLabel2.text = @"比特易是业界领先的区块链市场数据分析工具,\n我们提供专业的市场数据和指标工具,\n帮您控制投资风险，辅助投资决策。";
    titleLabel2.font = UIFontLightOfSize(12);
    titleLabel2.numberOfLines = 0;
    titleLabel2.textColor = BHHexColorAlpha(@"626A75", 0.8);
    BHHexColor(@"626A75");
    titleLabel2.alpha = 0.8;
    [titleLabel2 sizeToFit];
    [headView addSubview:titleLabel2];
    
    //创建轮播器控件
    LBBannerView *bannerView = [[LBBannerView alloc] initViewWithFrame:CGRectMake(0, 6+50, SCREEN_WIDTH, defaultScrollHeight) autoPlayTime:5.0f imagesArray:productList clickCallBack:^(float height) {
        [UserStatistics sendEventToServer:@"首页点击市场快讯"];
        defaultScrollHeight = height;
        CGFloat reloadHeight = (CGFloat)(6+50 + defaultScrollHeight + 23);
        marketMessageView.frame = CGRectMake(0, 0, SCREEN_WIDTH,reloadHeight );
        headView.frame = CGRectMake(0, reloadHeight, SCREEN_WIDTH, 187);
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, reloadHeight+187);

        [self onclickMarketFlash];
        [self.homePageTableView beginUpdates];
        [self.homePageTableView setTableFooterView:footerView];
        self.homePageTableView.tableFooterView.height = reloadHeight+187;
        [self.homePageTableView endUpdates];
        
    }];
    
    [marketMessageView addSubview:bannerView];
    [footerView addSubview:headView];
    [footerView addSubview:marketMessageView];
    footerView.backgroundColor = KBGColor;
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, reloadHeight+187);
    self.homePageTableView.tableFooterView = footerView;
    
}


-(void)updateCoin:(NSArray *)coinArray{
    if(coinArray && (![coinArray isEqual:[NSNull null]]) && coinArray != nil){
        _dataSource = coinArray;
        [self judagementFlag];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        
        [self.homePageTableView beginUpdates];
         [self.homePageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.homePageTableView endUpdates];
    }
}


-(void)pushAttentioncoinString:(NSString *)coinString{
    for (HomeDesListModel *temp in _dataSource) {
        if ([temp.symbol isEqualToString:coinString]) {
            temp.notice =@"0";
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.homePageTableView beginUpdates];
    [self.homePageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.homePageTableView endUpdates];
}

-(void)pushAttention:(NSString *)eventTypeStr{
    NSLog(@"pushAttention");
    
    if ([eventTypeStr isEqualToString:@"lz_dog"]) {//撸庄狗
        luzdogCountModel.notice = @"0";
//        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if([eventTypeStr isEqualToString:@"band_dog"]) {//波段狗
         banddogyModel.notice = @"0";
//         indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if([eventTypeStr isEqualToString:@"future_dog"]) {//合约狗
         contractdogModel.notice = @"0";
//         indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if([eventTypeStr isEqualToString:@"research_dog"]) {//研究狗
         researchdoyModel.notice = @"0";
//         indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if([eventTypeStr isEqualToString:@"strategy_dog"]) {//盯盘狗
//         indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
         startdogModel.notice = @"0";
    }
   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.homePageTableView beginUpdates];
    [self.homePageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.homePageTableView endUpdates];
}

-(void)judagementFlag{
    for (HomeDesListModel *temp in _dataSource) {
        if ([temp.symbol isEqualToString:@"BTC"]) {
            if ([btcStr isEqualToString:@""]) {
                temp.highequallowFlag = @"1";
            }else{
                if ([btcStr floatValue] >= [temp.price floatValue]) {
                    temp.highequallowFlag = @"-1";
                }else{
                    temp.highequallowFlag = @"1";
                }
            }
            btcStr = temp.price;
        }
        if ([temp.symbol isEqualToString:@"ETH"]) {
            if ([ethStr isEqualToString:@""]) {
                temp.highequallowFlag = @"0";
            }else{
                if ([ethStr floatValue] >= [temp.price floatValue]) {
                    temp.highequallowFlag = @"-1";
                }else{
                    temp.highequallowFlag = @"1";
                }
            }
            ethStr = temp.price;
        }
        if ([temp.symbol isEqualToString:@"BCH"]) {
            if ([bchStr isEqualToString:@""]) {
                temp.highequallowFlag = @"1";
            }else{
                if ([bchStr floatValue] >= [temp.price floatValue]) {
                    temp.highequallowFlag = @"-1";
                }else{
                    temp.highequallowFlag = @"1";
                }
            }
            bchStr = temp.price;
        }
        if ([temp.symbol isEqualToString:@"EOS"]) {
            if ([eosStr isEqualToString:@""]) {
                temp.highequallowFlag = @"1";
            }else{
                if ([eosStr floatValue] >= [temp.price floatValue]) {
                    temp.highequallowFlag = @"-1";
                }else{
                    temp.highequallowFlag = @"1";
                }
            }
            eosStr = temp.price;
        }
    }
}

-(void)refreshUi:(NSArray *)model productList:(NSArray *)productListModel model1:(HomeDescriptionModel *)DescriptionModel model2:(NSArray <HomeProductInfoModel *>*)productInfoModelList currentCurrencyType:(NSString *)currentCurrencyType anouncement:(NSArray *)announcement dogViewCount:(HomeDogCountModel *)dogCountModel WithBandDog:(HomeDogCountModel *)bandDog WithContractDog:(HomeDogCountModel *)contractDog WithResearchDog:(HomeDogCountModel *)researchDog WithBannerArray:(NSArray<HomeBannerModel *>*)bannerList WithStartDog:(HomeDogCountModel *)stareDog WithAtmosphereData:(AtmosphereModel *)atmoModel Withlianchacha:(HomeDogCountModel *)lianchacha{
    
    if(model && (![model isEqual:[NSNull null]]) && model != nil){
        _dataSource = model;
        [self judagementFlag];
    }
    
    if (productListModel) {
        productList = productListModel;
        [self setTableFooterView];
    }
    descriptionModel = DescriptionModel;
    productInfoArray = productInfoModelList;
    bannerArray = bannerList;
    anouncement = announcement;
    headModel = model[0];//默认第一个
    
    if (dogCountModel){
        luzdogCountModel = dogCountModel;
    }
    
    if (bandDog){
        banddogyModel = bandDog;
    }
    
    if (contractDog){
        contractdogModel = contractDog;
    }
    
    if (researchDog){
        researchdoyModel = researchDog;
    }
    
    if (stareDog){
        startdogModel = stareDog;
    }
    
    if (lianchacha) {
        lianchachaModel = lianchacha;
    }
    
    if (atmoModel) {
        atmosphereModel = atmoModel;
        if (atmosphereModel.amount) {
            
            if(self.accountArray !=nil && self.accountArray.count > 0){
                for(int i = 0; i < self.accountArray.count ;i++){
                    
                    UILabel *desLabel = self.accountArray[i];
                    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                    if (i == 0) {
                        
                        NSString *tempStr = [[[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",[atmosphereModel.airIndex floatValue]]] decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
                        
                        desLabel.text =tempStr;
                    }
                    if (i == 1) {
                        NSString *numStr = [NSString stringWithFormat:@"%.0f",[atmosphereModel.amount floatValue]];
//                        NSString *tempStr = [[[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f",[atmosphereModel.amount floatValue]]] decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
                        NSMutableAttributedString *string;
                        if (numStr.length > 8) {//亿
                            string =  [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%.2f亿",[numStr floatValue]/100000000]];
                            
                        }else if (numStr.length > 4 && (numStr.length) <= 8) {//万
                            string =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"%.2f万",[numStr floatValue]/100000000]];
                            
                            
                        }else {
                            string =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"%.2f",[numStr floatValue]]];
                            
                        }
                        [string addAttribute:NSFontAttributeName value:UIFontDINAlternateOfSize(SCALE_W(16)) range:NSMakeRange(string.length-1, 1)];
                        desLabel.attributedText = string;
                    }
                    if (i == 2) {
//                        desLabel.text = [[[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",[atmosphereModel.netAmount floatValue]]] decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
                        NSString *numStr = [NSString stringWithFormat:@"%.0f",[atmosphereModel.netAmount floatValue]];
                        //                        NSString *tempStr = [[[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f",[atmosphereModel.amount floatValue]]] decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
                         NSMutableAttributedString *string;
                        if (numStr.length > 8) {//亿
                            string =  [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%.2f亿",[numStr floatValue]/100000000]];
                            
                        }else if (numStr.length > 4 && (numStr.length) <= 8) {//万
                            string =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"%.2f万",[numStr floatValue]/100000000]];
                            
                            
                        }else {
                            string =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"%.2f",[numStr floatValue]]];
                            
                        }
                        [string addAttribute:NSFontAttributeName value:UIFontDINAlternateOfSize(SCALE_W(16)) range:NSMakeRange(string.length-1, 1)];
                        desLabel.attributedText = string;
                    }
                }
            }
        }

    }
    
    
    
   
    if (currentCurrencyType) {
        for (HomeDesListModel *tempModel in model) {
            if ([tempModel.symbol isEqualToString:currentCurrencyType]) {
                headModel = tempModel;
            }
        }
    }
    
    [self setTableHeadView];
    [self.homePageTableView reloadData];
}

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return bannerArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    //    cell.backgroundColor = _datas[index];
    //    cell.label.text = [NSString stringWithFormat:@"index->%ld",index];
    HomeBannerModel *bannerModel = (HomeBannerModel *) bannerArray[index];
    
    [cell.bannerImageView sd_setImageWithURL: [NSURL URLWithString:bannerModel.url]];
    //    NSURL *URL =
    //    [NSURL URLWithString:@"https://mobike.com/cn/"];
    //    [NSURL URLWithString:bannerModel.url];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    //    [cell.webView loadRequest:request];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH -32, SCALE_W(46));
    layout.itemSpacing = SCALE_W(16);
    //layout.minimumAlpha = 0.3;
    //    layout.itemHorizontalCenter = YES;
    layout.layoutType = TYCyclePagerTransformLayoutCoverflow;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    //    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    //    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}
- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    NSLog(@"didSelectedItemCell->  %ld",index);
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannberJumpToWebView:)]) {
        HomeBannerModel *bannerModel = (HomeBannerModel *) bannerArray[index];
        
        [self.delegate bannberJumpToWebView:bannerModel.target];
    }
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (productInfoArray && productInfoArray.count > 0) {
        return 1 + 3 + productInfoArray.count ;
    }else{
        return 1 + 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 32;
        //公告如果存在
//        if (anouncement && anouncement.count > 0) {
//            return 48 + 28;
//        } else
//        {//公告如果不存在 就只保留缝隙
//            return 28;
//        }
    } else if (indexPath.row == 1){//币的列表
        return SCALE_W(77);
    } else if (indexPath.row == 1 + 1){//撸庄狗 机器狗 消息狗 盯盘狗 合约狗 研究狗
        return 50 + SCALE_W(288);
//    } else if (indexPath.row == 1 + 2){//市场分析
//        return 4 + 40 + 6 +78 + [self cellHeight] + 42 + 14;
//    } else if (indexPath.row == 1 + 2){//市场快讯
//       CGFloat reloadHeight = (CGFloat)(6+50 + defaultScrollHeight + 30);
////        NSLog(@"row--------------------------->%f",reloadHeight);
//        return reloadHeight;
    } else if (indexPath.row == 1+ 2){//政策服务 的列表头
        //如果政策列表有数据 并且 打开了开关 则有 列表头
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:MobileTradeNum] integerValue] == 1 && productInfoArray && productInfoArray.count > 0 && User.userToken) {
            return 59;
        }
        else//如果不是
        {
            return 0.000001;
        }
    }  else{//政策服务
        HomeProductInfoModel *productInfo = productInfoArray[indexPath.row - 4];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (User.userToken && [[defaults objectForKey:MobileTradeNum] integerValue] == 1 ) {
            CGRect rect = [productInfo.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 160, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontRegularOfSize(12)} context:nil];
            return 50 + rect.size.height + 78 +22;
        }
        else
        {
            return 0.000001;
        }
    }
}

- (float)cellHeight
{
    NSString * contentStr= descriptionModel.summary;
    CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16 * 4, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontLightOfSize(13)} context:nil];
    if (rect.size.height > 0) {
        return rect.size.height;
    }
    else
    {
        return 49;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BHHexColor(@"F9F9FA");
        
        UIView *tradDatabgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        tradDatabgView.backgroundColor = BHHexColor(@"F9F9FA");
        
        [cell.contentView addSubview:tradDatabgView];
//        if (anouncement && anouncement.count > 0) {
//            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, 40)];
//            bgView.backgroundColor = BHHexColor(@"F9F9FA");
//            [cell.contentView addSubview:bgView];
//
//            UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 12, 16, 16)];
//            image1.image = [UIImage imageNamed:@"Image_guanggao"];
//            [bgView addSubview:image1];
//
////            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 14, 40, 13)];
////            titleLabel.text = @"公告：";
////            titleLabel.font = UIFontRegularOfSize(13);
////            titleLabel.textColor = BHHexColor(@"FF6B28");
////            [bgView addSubview:titleLabel];
//
//
//            // 添加上下滚动的跑马灯
//            [self addVerticalMarquee:bgView];
//            UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            okButton.frame = CGRectMake(SCREEN_WIDTH - 16 - 16, 12, 16, 16);
//            [okButton setImage:[UIImage imageNamed:@"Image_guangao_guanbi"] forState:UIControlStateNormal];
//            [okButton addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
//            [bgView addSubview:okButton];
//            tradDatabgView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 28);
//        }else {
//            tradDatabgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28);
//        }
        
        
//        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 0.5)];
//        lineImageView.backgroundColor = BHHexColor(@"E6EBF0");
//        [tradDatabgView addSubview:lineImageView];
        
//        UIImageView *marketDataImageview = [[UIImageView alloc] initWithFrame:CGRectMake(16.7, 12, 16, 16)];
//        marketDataImageview.backgroundColor = BHHexColor(@"F9F9FA");
//        marketDataImageview.image = [UIImage imageNamed:@"home_hangqingshuju"];
//        [tradDatabgView addSubview:marketDataImageview];
        
        UILabel *marketDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 90, 14)];
        marketDataLabel.text = @"市场数据";
        marketDataLabel.font = UIFontMediumOfSize(14);
        marketDataLabel.textColor = BHHexColor(@"626A75");
        [tradDatabgView addSubview:marketDataLabel];
       
//        UIButton *magnifierImageview = [UIButton buttonWithType:UIButtonTypeCustom];
//        magnifierImageview.frame = CGRectMake(SCREEN_WIDTH -14 - 16.8, 13, 14, 14);
//        [magnifierImageview setImage:[UIImage imageNamed:@"magnifier"] forState:UIControlStateNormal];
//        [tradDatabgView addSubview:magnifierImageview];
//
//        UIButton *magnifierButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        magnifierButton.frame = CGRectMake(SCREEN_WIDTH-(28+29), 0, 28+29, 40);
//        [magnifierButton setBackgroundColor:[UIColor clearColor]];
//        [magnifierButton addTarget:self action:@selector(gotoTradeDataPage:) forControlEvents:UIControlEventTouchUpInside];
//        [tradDatabgView addSubview:magnifierButton];
        
//        UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(tradDatabgView.width - 6.5 - 17.8, 12.5, 6.5, 13)];
//        image3.image = [UIImage imageNamed:@"home_more-1"];
//        [tradDatabgView addSubview:image3];
        
//        UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(20+32), 15, 20, 10)];
//        moreLabel.text = @"更多";
//        moreLabel.textAlignment = NSTextAlignmentRight;
//        moreLabel.font = UIFontRegularOfSize(10);
//        moreLabel.textColor = BHHexColor(@"626A75");
//        [tradDatabgView addSubview:moreLabel];
        
//        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        moreButton.frame = CGRectMake(SCREEN_WIDTH-(28+29), 0, 28+29, 38);
//        [moreButton setBackgroundColor:[UIColor clearColor]];
//        [moreButton addTarget:self action:@selector(trademoreButton) forControlEvents:UIControlEventTouchUpInside];
//        [tradDatabgView addSubview:moreButton];
//
//
//        UIButton *tradButton = [UIButton buttonWithType:UIButtonTypeCustom];
//         tradButton.frame = CGRectMake(0 ,0, SCREEN_WIDTH, 38);
//        [tradButton setBackgroundColor:[UIColor clearColor]];
//        [tradButton addTarget:self action:@selector(trademoreButton) forControlEvents:UIControlEventTouchUpInside];
//         [tradDatabgView addSubview:tradButton];
//
//        UIView *lineView = [[UIView alloc] init];
//        lineView.frame = CGRectMake(0, SCALE_W(38) -1, SCREEN_WIDTH, 0.5);
//        lineView.backgroundColor = BHHexColor(@"E6EBF0");
//        [cell.contentView addSubview:lineView];
        return cell;
    }
    
    else if (indexPath.row == 1)
    {//4种核心币 btc eth bch eos
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =BHHexColor(@"F9F9FA");
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32 ,SCALE_W(71))];
        [cell.contentView addSubview:bgview];
        bgview.backgroundColor = BHHexColor(@"FAFAFA");
        if (_dataSource && [_dataSource count] >0 ) {
            UIButton *btn;
            UILabel *desLabel;
            UILabel *titleLabel;
            UIView *buttonView;
            UILabel *subTitleLabel5;
            UIView *verticalLine;
            UIImageView *commentImageView;
            for(int i = 0; i < _dataSource.count ;i++){
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
               
                verticalLine = [[UIView alloc] init];
                titleLabel = [[UILabel alloc] init];
                desLabel = [[UILabel alloc] init];
                buttonView = [[UIView alloc] init];
                commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ping"]];
                if(i== 0){
                    btn.frame = CGRectMake(
                                           0,
                                           0,
                                            SCALE_W(80),
                                           SCALE_W(71)
                                           );
                }
                if(i== 1){
                    btn.frame = CGRectMake(
                                           SCALE_W(80),
                                           0,
                                           SCALE_W(88),
                                           SCALE_W(71)
                                           );
                }
                if(i== 2){
                    btn.frame = CGRectMake(
                                           SCALE_W(80+88),
                                           0,
                                           SCALE_W(89),
                                           SCALE_W(71)
                                           );
                }
                if(i== 3){
                    btn.frame = CGRectMake(
                                           SCALE_W(80+88+89),
                                           0,
                                           SCALE_W(90),
                                           SCALE_W(71)
                                           );
                }
//                btn.frame = CGRectMake(
//                                       i*(SCREEN_WIDTH-32)/4,
//                                       0,
//                                       (SCREEN_WIDTH-32)/4,
//                                       SCALE_W(71)
//                                       );
                [bgview addSubview:btn];


                titleLabel.frame = CGRectMake(SCALE_W(14) , SCALE_W(18), SCALE_W(30), SCALE_W(12));
                
                titleLabel.font = UIFontMediumOfSize(SCALE_W(12));
                titleLabel.textColor = BHHexColor(@"626A75");
                titleLabel.textAlignment = NSTextAlignmentLeft;
                [btn addSubview:titleLabel];

                desLabel.frame = CGRectMake(SCALE_W(14) , SCALE_W(35),SCALE_W( 84), SCALE_W(18));
                [btn addSubview:desLabel];
                desLabel.backgroundColor  = [UIColor clearColor];
                desLabel.textAlignment = NSTextAlignmentLeft;
                desLabel.font = UIFontDINAlternateOfSize(SCALE_W(18));
                desLabel.textColor =  BHHexColorAlpha(@"626A75",0.8);
//                BHHexColor(@"525866");

                desLabel.textAlignment = NSTextAlignmentLeft;

                buttonView.frame = CGRectMake(btn.frame.size.width - SCALE_W(43 + 9), SCALE_W(22), SCALE_W(43), SCALE_W(8));
                [btn addSubview:buttonView];
//                buttonView.backgroundColor = [UIColor blackColor];

                subTitleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(0), SCALE_W(0), SCALE_W(43), SCALE_W(8))];
                subTitleLabel5.text = @"-2.39%";
                subTitleLabel5.backgroundColor = [UIColor clearColor];
                subTitleLabel5.textAlignment = NSTextAlignmentRight;
                subTitleLabel5.font = UIFontRegularOfSize(SCALE_W(8));
                subTitleLabel5.textColor = [UIColor whiteColor];
                [buttonView addSubview:subTitleLabel5];
                if(i == 0){
                    titleLabel.frame = CGRectMake(0 , SCALE_W(18), SCALE_W(30), SCALE_W(12));
                    desLabel.frame = CGRectMake(0 , SCALE_W(35),SCALE_W( 84), SCALE_W(18));
                }
                
//                btn.backgroundColor = [UIColor blackColor];
//                if (i == 0) {
//                    btn.backgroundColor = [UIColor blueColor];
//                }
//                if (i == 1) {
//                    btn.backgroundColor = [UIColor redColor];
//                }
//                if (i == 2) {
//                    btn.backgroundColor = [UIColor orangeColor];
//                }
//                if (i == 3) {
//                    btn.backgroundColor = [UIColor purpleColor];
//                }
                if(i < 3){
                    verticalLine.frame = CGRectMake(btn.frame.size.width - 1, SCALE_W(21), 1, SCALE_W(30));
                    verticalLine.backgroundColor = [UIColor colorWithHexString:@"D8E0E9"];
                }
                [btn addSubview:verticalLine];
                HomeDesListModel *model =(HomeDesListModel *) _dataSource[i];
                titleLabel.text = model.symbol;
                NSString *price = [NSString positiveFormat:model.price];
                desLabel.text = [NSString stringWithFormat:@"%@",price];
                //    _subTitleLabel4.text = model.operation;

                if ([model.change floatValue] > 0) {
                    subTitleLabel5.text = [NSString stringWithFormat:@"+%.2f%%",[model.change floatValue]];
                } else
                {
                    subTitleLabel5.text = [NSString stringWithFormat:@"%.2f%%",[model.change floatValue]];
                }

                if ([model.change floatValue] >= 0) {
                    subTitleLabel5.textColor = BHHexColorAlpha(@"228B22",0.8);
                    desLabel.textColor = BHHexColorAlpha(@"228B22",0.8);
                } else if ([model.change floatValue] < 0)
                {
                    subTitleLabel5.textColor =BHHexColor(@"FF4040");
                    desLabel.textColor = BHHexColor(@"FF4040");
//                    BHHexColorAlpha(@"FF4040",0.8);
                }

                btn.tag = i;
                [btn addTarget:self action:@selector(gotoKPage:) forControlEvents:UIControlEventTouchUpInside];

                commentImageView.frame = CGRectMake( SCALE_W(14) + SCALE_W(24),SCALE_W(7),SCALE_W(24), SCALE_W(13));
                [btn addSubview:commentImageView];
                if ([model.notice intValue] > 0) {
                    commentImageView.hidden = NO;
                    btn.selected = NO;
                }else{
                    commentImageView.hidden = YES;
                    btn.selected = YES;
                }
                
                
//                 subTitleLabel5.textColor = [UIColor whiteColor];
            }
        }
        UIView *grayView = [[UIView alloc] init];
        grayView.frame = CGRectMake(0,SCALE_W(71), SCREEN_WIDTH, SCALE_W(6));
        grayView.backgroundColor =KBGColor;
        [cell.contentView addSubview:grayView];
//        KBGColor;
//        static NSString *CellIdentifier = @"Cell";
//        BTEHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if(cell == nil)
//        {
//            cell = [[BTEHomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//        [cell setCellWithModel:_dataSource[indexPath.row - 1]];
        return cell;
    }
    else if (indexPath.row == 1 + 1)
    {//工具 撸庄狗 波段狗 合约狗 研究狗
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BHHexColor(@"F9F9FA");

        UIView *toolBG = [[UIView alloc] init];
        toolBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//        UIImageView *toolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.7, 16, 16, 16)];
//        toolImageView.backgroundColor = BHHexColor(@"F9F9FA");
//        toolImageView.image = [UIImage imageNamed:@"home_gongju"];
//        [toolBG addSubview:toolImageView];

        UILabel *toolLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 90, 15)];
        toolLabel.text = @"工具插件";
        toolLabel.font = UIFontMediumOfSize(14);
        toolLabel.textColor = BHHexColor(@"626A75");
        [toolBG addSubview:toolLabel];
        [cell.contentView addSubview:toolBG];
        
        UILabel *tImageView = [[UILabel alloc] initWithFrame:CGRectMake(88,19, SCALE_W(57), SCALE_W(13))];
        
        tImageView.backgroundColor = BHHexColorAlpha(@"626A75", 0.2);
        tImageView.layer.masksToBounds = YES;
        tImageView.layer.cornerRadius = SCALE_W(13)/2;
        tImageView.font = UIFontRegularOfSize(SCALE_W(9));
        tImageView.text =@"第三方开发";
        tImageView.textColor =[UIColor whiteColor];
        tImageView.textAlignment = NSTextAlignmentCenter;
        [toolBG addSubview:tImageView];
       

        UIView *contractDogView = [self setAllKindsOfDogWithIcon:@"heyueIcon" WithFeature:@"合约狗"];
        [cell.contentView addSubview:contractDogView];

        UIView *brandDogView = [self setAllKindsOfDogWithIcon:@"boduanIcon" WithFeature:@"波段狗"];
        [cell.contentView addSubview:brandDogView];

        UIView *luzDogView = [self setAllKindsOfDogWithIcon:@"luzhuangIcon" WithFeature:@"撸庄狗"];
        [cell.contentView addSubview:luzDogView];

        UIView *stareDogView = [self setAllKindsOfDogWithIcon:@"盯盘" WithFeature:@"盯盘狗"];
        [cell.contentView addSubview:stareDogView];

        UIView *researchDogView = [self setAllKindsOfDogWithIcon:@"yanjiuDogIcon" WithFeature:@"研究狗"];
        [cell.contentView addSubview:researchDogView];
        
        UIView *moreDogView = [self setAllKindsOfDogWithIcon:@"chainCheckIcon" WithFeature:@"链查查"];
        [cell.contentView addSubview:moreDogView];
        
        contractDogView.frame = CGRectMake(16, toolBG.bottom, contractDogView.width, contractDogView.height);
        
        luzDogView.frame = CGRectMake(contractDogView.right + 11, toolBG.bottom , brandDogView.width, brandDogView.height);
        
        brandDogView.frame =  CGRectMake(16,  contractDogView.bottom +12, luzDogView.width, luzDogView.height);
        
        stareDogView.frame =  CGRectMake(contractDogView.right + 11, contractDogView.bottom +12, luzDogView.width, luzDogView.height);
        
        researchDogView.frame = CGRectMake(16,brandDogView.bottom +12, researchDogView.width, researchDogView.height);
        
        moreDogView.frame = CGRectMake(contractDogView.right + 11,brandDogView.bottom +12, moreDogView.width, moreDogView.height);
        
       
//
//        UIView *bgpart3View = [[UIView alloc] initWithFrame:CGRectMake(0, researchDogView.bottom +9, SCREEN_WIDTH, 44)];
//        bgpart3View.backgroundColor = BHHexColor(@"FAFAFA");
//        [cell.contentView addSubview:bgpart3View];
//
//        UIImageView *contractIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCALE_W(16.8), SCALE_W(15), SCALE_W(14), SCALE_W(14))];
//        contractIconImageView.image = [UIImage imageNamed:@"jiqiIcon"];
//        [bgpart3View addSubview:contractIconImageView];
//
//        UILabel *contractdogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(33.6), SCALE_W(16), SCALE_W(39), SCALE_W(15))];
//        contractdogtitleLabel.text = @"机器狗";
//        contractdogtitleLabel.font = UIFontMediumOfSize(SCALE_W(13));
//        contractdogtitleLabel.textColor = BHHexColor(@"626A75");
//        [bgpart3View addSubview:contractdogtitleLabel];
//
//        UIImageView *messagedogIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCALE_W(87.8), SCALE_W(15), SCALE_W(14), SCALE_W(14))];
//        messagedogIconImageView.image = [UIImage imageNamed:@"Group 38"];
//        [bgpart3View addSubview:messagedogIconImageView];
//
//        UILabel *messagetitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(104.6), SCALE_W(16), SCALE_W(39), SCALE_W(15))];
//        messagetitleLabel.text = @"消息狗";
//        messagetitleLabel.font = UIFontMediumOfSize(SCALE_W(13));
//        messagetitleLabel.textColor = BHHexColor(@"626A75");
//        [bgpart3View addSubview:messagetitleLabel];

//        UIImageView *researchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCALE_W(159.6), SCALE_W(15), SCALE_W(14), SCALE_W(14))];
//        researchIconImageView.image = [UIImage imageNamed:@"Group 36"];
//        [bgpart3View addSubview:researchIconImageView];
//
//        UILabel *researcdogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(175.6), SCALE_W(16), SCALE_W(39), SCALE_W(15))];
//        researcdogtitleLabel.text = @"盯盘狗";
//        researcdogtitleLabel.font = UIFontMediumOfSize(SCALE_W(13));
//        researcdogtitleLabel.textColor = BHHexColor(@"626A75");
//        [bgpart3View addSubview:researcdogtitleLabel];


//        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(158) , SCALE_W(17), SCALE_W(133), SCALE_W(12))];
//        subLabel.text = [NSString stringWithFormat:@"更多功能正在开发中…"];
//        subLabel.font = UIFontRegularOfSize(SCALE_W(12));
//        subLabel.textColor = BHHexColor(@"626A75");
//        [bgpart3View addSubview:subLabel];
//
//        UIView *lineView = [[UIView alloc] init];
//        lineView.frame = CGRectMake(0, 559+44 - 1, SCREEN_WIDTH, 1);
//        lineView.backgroundColor = BHHexColor(@"E6EBF0");
//        [cell.contentView addSubview:lineView];
        
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 311)];
//        bgView.backgroundColor = BHHexColor(@"FAFAFA");
//        [cell.contentView addSubview:bgView];
//
//        UIView *dogbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 311)];
//        dogbgView.backgroundColor = BHHexColor(@"FAFAFA");
//        [bgView addSubview:dogbgView];
//
//        UIView *bandratiodogbgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 311)];
//        bandratiodogbgView.backgroundColor = BHHexColor(@"FAFAFA");
//        [bgView addSubview:bandratiodogbgView];
//
//
//        UIImageView *dogIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 11, 25, 18)];
//        dogIconImageView.image = [UIImage imageNamed:@"撸庄狗"];
//        [dogbgView addSubview:dogIconImageView];
//
//
//
//        UILabel *dogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 11, 60, 18)];
//        dogtitleLabel.text = @"撸庄狗";
//        dogtitleLabel.font = UIFontMediumOfSize(17);
//        dogtitleLabel.textColor = BHHexColor(@"626A75");
//        [dogbgView addSubview:dogtitleLabel];
//
//        UILabel *dogsubLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH/2 - 32, 60)];
//        dogsubLabel.textColor = BHHexColor(@"626A75");
//        dogsubLabel.font = UIFontRegularOfSize(12);
//        if (homedogCountModel){
//            NSString *temppercentStr = [NSString stringWithFormat:@"%.2f", [homedogCountModel.income floatValue]];
//            NSMutableAttributedString *dogsubStr =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"撸庄狗是通过人工智能实时预判小币种短线拉升迹象的智能工具；近30天累计收益%@%@", temppercentStr,@"%"]];
//            //修改颜色
//            NSLog(@"length------>%ld",homedogCountModel.userCount.length);
//            [dogsubStr addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"228B22")range:NSMakeRange(dogsubStr.length - temppercentStr.length - 1, temppercentStr.length + 1)];
//            dogsubLabel.attributedText = dogsubStr;
//
//        }
//        dogsubLabel.numberOfLines = 0;
//        [dogsubLabel sizeToFit];
//        [dogbgView addSubview:dogsubLabel];
//
//        [self setAnimationRoundAddSuperView:dogbgView WithDogIconImageVewStr:@"luzhuang"];
//
//        UILabel *dogdescLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 215, SCREEN_WIDTH/2 - 70 , 40)];
//        dogdescLabel.font = UIFontMediumOfSize(14);
//        dogdescLabel.textColor = BHHexColor(@"626A75");
//        if (homedogCountModel){
//            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"近期可撸%@个币种已有%@人开撸",homedogCountModel.recentCount,homedogCountModel.userCount]];
//            //修改颜色
//            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(4, homedogCountModel.recentCount.length)];
//            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(string.length - 3 -homedogCountModel.userCount.length , homedogCountModel.userCount.length)];
//
//            dogdescLabel.attributedText = string;
//        }
//        dogdescLabel.textAlignment = NSTextAlignmentLeft;
//        dogdescLabel.numberOfLines = 2;
//        [dogbgView addSubview:dogdescLabel];
//
//        UIButton *masturbationDogButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        masturbationDogButton.frame = CGRectMake(53, 265, SCREEN_WIDTH/2 - 53*2, 30);
//        masturbationDogButton.layer.masksToBounds = YES;
//        masturbationDogButton.layer.cornerRadius = 4;
//        [masturbationDogButton setTitle:@"去撸庄" forState:UIControlStateNormal];
//        [masturbationDogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        masturbationDogButton.titleLabel.font  = UIFontMediumOfSize(15);
//        [masturbationDogButton setBackgroundColor:BHHexColor(@"308CDD")];
//        [masturbationDogButton addTarget:self action:@selector(gotoDogPage) forControlEvents:UIControlEventTouchUpInside];
//        [dogbgView addSubview:masturbationDogButton];
//
//        UIImageView *bandratioIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 18, 18)];
//        bandratioIconImageView.image = [UIImage imageNamed:@"波段狗"];
//        [bandratiodogbgView addSubview:bandratioIconImageView];
//
//        UILabel *bandratiodogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 11, 60, 18)];
//        bandratiodogtitleLabel.text = @"波段狗";
//        bandratiodogtitleLabel.font = UIFontMediumOfSize(17);
//        bandratiodogtitleLabel.textColor = BHHexColor(@"626A75");
//        [bandratiodogbgView addSubview:bandratiodogtitleLabel];
//
//        UILabel *bandratiodogsubLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH/2 - 32, 45)];
//        bandratiodogsubLabel.text = @"实时提供主流币种买点/卖点提示，是短线/合约玩家的必备利器。";
//        bandratiodogsubLabel.font = UIFontRegularOfSize(12);
//        bandratiodogsubLabel.textColor = BHHexColor(@"626A75");
//        bandratiodogsubLabel.numberOfLines = 0;
//        [bandratiodogsubLabel sizeToFit];
//        [bandratiodogbgView addSubview:bandratiodogsubLabel];
//
//        [self setAnimationRoundAddSuperView:bandratiodogbgView WithDogIconImageVewStr:@"boduan"];
//
//        UILabel *bandratiodescLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 225, (SCREEN_WIDTH/2 - 32), 20)];
//        bandratiodescLabel.font = UIFontMediumOfSize(14);
//        bandratiodescLabel.textColor = BHHexColor(@"626A75");
//
//        if (bandDogCountStr){
//            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@人正在做波段",bandDogCountStr]];
//            //修改颜色
//            NSLog(@"length------>%ld",homedogCountModel.userCount.length);
//            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(0, bandDogCountStr.length)];
//
//            bandratiodescLabel.attributedText = string;
//        }
//        bandratiodescLabel.textAlignment = NSTextAlignmentCenter;
//        bandratiodescLabel.numberOfLines = 2;
//        [bandratiodogbgView addSubview:bandratiodescLabel];
//
//        UIButton *bandratioDogButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        bandratioDogButton.frame = CGRectMake(53, 265, SCREEN_WIDTH/2 - 53*2, 30);
//        bandratioDogButton.layer.masksToBounds = YES;
//        bandratioDogButton.layer.cornerRadius = 4;
//        [bandratioDogButton setTitle:@"做波段" forState:UIControlStateNormal];
//        [bandratioDogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        bandratioDogButton.titleLabel.font  = UIFontMediumOfSize(15);
//        [bandratioDogButton setBackgroundColor:BHHexColor(@"308CDD")];
//        [bandratioDogButton addTarget:self action:@selector(gotobandratioDogPage) forControlEvents:UIControlEventTouchUpInside];
//        [bandratiodogbgView addSubview:bandratioDogButton];
//
//        UIButton *dogButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        dogButton.frame = CGRectMake(0, 0, dogbgView.frame.size.width, dogbgView.frame.size.height);
//        [dogButton setBackgroundColor:[UIColor clearColor]];
//        [dogButton addTarget:self action:@selector(gotoDogPage) forControlEvents:UIControlEventTouchUpInside];
//        [dogbgView addSubview:dogButton];
//
//        UIButton *bandratioDogBGButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        bandratioDogBGButton.frame = CGRectMake(0, 0, bandratiodogbgView.frame.size.width, bandratiodogbgView.frame.size.height);
//        [bandratioDogBGButton setBackgroundColor:[UIColor clearColor]];
//        [bandratioDogBGButton addTarget:self action:@selector(gotobandratioDogPage) forControlEvents:UIControlEventTouchUpInside];
//        [bandratiodogbgView addSubview:bandratioDogBGButton];
//
//        UIImageView *verticalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 1, bgView.frame.size.height)];
//        verticalImageView.image = [UIImage imageNamed:@"dashed"];
//        [bgView addSubview:verticalImageView];
//
//        UIView *bgpart2View = [[UIView alloc] initWithFrame:CGRectMake(0, 8+ bgView.frame.size.height +8, SCREEN_WIDTH, 311)];
//        bgpart2View.backgroundColor = BHHexColor(@"FAFAFA");
//        [cell.contentView addSubview:bgpart2View];
//
//
//
//        UIView *machinedogbgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 311)];
//        machinedogbgView.backgroundColor = BHHexColor(@"FAFAFA");
//        [bgpart2View addSubview:machinedogbgView];
//
//        UIView *staredogBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 311)];
//        bandratiodogbgView.backgroundColor = BHHexColor(@"FAFAFA");
//        [bgpart2View addSubview:staredogBgView];
//
//        UIImageView *verticalImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 1, 311)];
//        verticalImageView2.image = [UIImage imageNamed:@"dashed"];
//        [bgpart2View addSubview:verticalImageView2];
//
//        UIImageView *machinedogIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 18, 18)];
//        machinedogIconImageView.image = [UIImage imageNamed:@"Group 35"];
//        [machinedogbgView addSubview:machinedogIconImageView];
//
//        UILabel *machinedogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 12, 60, 18)];
//        machinedogtitleLabel.text = @"合约狗";
//        machinedogtitleLabel.font = UIFontMediumOfSize(17);
//        machinedogtitleLabel.textColor = BHHexColor(@"626A75");
//        [machinedogbgView addSubview:machinedogtitleLabel];
//
//        UIImageView *betaIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(92, 16, 18, 9)];
//        betaIconImageView.image = [UIImage imageNamed:@"beta"];
//        [machinedogbgView addSubview:betaIconImageView];
//
//        UILabel *machinedogsubLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH/2 - 16, 45)];
//        machinedogsubLabel.text = [NSString stringWithFormat:@"深度挖掘合约交易数据，技术派合约玩家的必备工具。"];
//        machinedogsubLabel.font = UIFontRegularOfSize(12);
//        machinedogsubLabel.textColor = BHHexColor(@"626A75");
//        machinedogsubLabel.numberOfLines = 0;
//        [machinedogsubLabel sizeToFit];
//        [machinedogbgView addSubview:machinedogsubLabel];

////        [self setAnimationRoundAddSuperView:machinedogbgView WithDogIconImageVewStr:@"contractDog"];
////
////        UILabel *contractodescLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 225, (SCREEN_WIDTH/2 - 32), 20)];
////        contractodescLabel.font = UIFontMediumOfSize(14);
////        contractodescLabel.textColor = BHHexColor(@"626A75");
////
////        if (contractDogCountStr){
////            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@人正在做合约",contractDogCountStr]];
////            //修改颜色
////            NSLog(@"length------>%ld",contractDogCountStr.length);
////            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(0, contractDogCountStr.length)];
////
////            contractodescLabel.attributedText = string;
////        }
////        contractodescLabel.textAlignment = NSTextAlignmentCenter;
////        contractodescLabel.numberOfLines = 2;
////        [machinedogbgView addSubview:contractodescLabel];
////
////        UIButton *doContractButton = [UIButton buttonWithType:UIButtonTypeCustom];
////        doContractButton.frame = CGRectMake(53, 265, SCREEN_WIDTH/2 - 53*2, 30);
////        doContractButton.layer.masksToBounds = YES;
////        doContractButton.layer.cornerRadius = 4;
////        [doContractButton setTitle:@"做合约" forState:UIControlStateNormal];
////        [doContractButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////        doContractButton.titleLabel.font  = UIFontMediumOfSize(15);
////        [doContractButton setBackgroundColor:BHHexColor(@"308CDD")];
////        [machinedogbgView addSubview:doContractButton];
//
//                UIImageView *bandratiodogImageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 125)/2, 109, 125, 125)];
//                bandratiodogImageview.image = [UIImage imageNamed:@"Group 22 Copy"];
//                [machinedogbgView addSubview:bandratiodogImageview];
//
//                UILabel *bandratiodogdescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 229,(SCREEN_WIDTH/2), 14)];
//                bandratiodogdescLabel.text = @"即将上线 敬请期待";
//                bandratiodogdescLabel.font = UIFontMediumOfSize(14);
//                bandratiodogdescLabel.textColor = BHHexColor(@"626A75");
//                bandratiodogdescLabel.textAlignment = NSTextAlignmentCenter;
//                [machinedogbgView addSubview:bandratiodogdescLabel];
////                bandratiodogdescLabel.userInteractionEnabled = YES;
////                UITapGestureRecognizer *tapShareView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapJump)];
////                [bandratiodogdescLabel addGestureRecognizer:tapShareView];
//
//
////                UIButton *doContractButton = [UIButton buttonWithType:UIButtonTypeCustom];
////                doContractButton.frame = CGRectMake(53, 265, SCREEN_WIDTH/2 - 53*2, 30);
////                doContractButton.layer.masksToBounds = YES;
////                doContractButton.layer.cornerRadius = 4;
////                [doContractButton setTitle:@"做合约" forState:UIControlStateNormal];
////                [doContractButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////                doContractButton.titleLabel.font  = UIFontMediumOfSize(15);
////                [doContractButton setBackgroundColor: [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.2/1.0]];
////                [machinedogbgView addSubview:doContractButton];
//
//
//
//
//        UIImageView *staredogIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 18, 18)];
//        staredogIconImageView.image = [UIImage imageNamed:@"yanjiu."];
//        [staredogBgView addSubview:staredogIconImageView];
//
//        UIImageView *betaIconImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(92, 16, 18, 9)];
//        betaIconImageView2.image = [UIImage imageNamed:@"beta"];
//        [staredogBgView addSubview:betaIconImageView2];
//
//        [self setAnimationRoundAddSuperView:staredogBgView WithDogIconImageVewStr:@"researchDog"];
//
//        UILabel *staredogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 12, 60, 18)];
//        staredogtitleLabel.text = @"研究狗";
//        staredogtitleLabel.font = UIFontMediumOfSize(17);
//        staredogtitleLabel.textColor = BHHexColor(@"626A75");
//        [staredogBgView addSubview:staredogtitleLabel];
//
//        UILabel *stardogsubLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH/2 - 32, 45)];
//        stardogsubLabel.text = @"为您提供区块链领域最权威的研究报告。";
//        stardogsubLabel.font = UIFontRegularOfSize(12);
//        stardogsubLabel.textColor = BHHexColor(@"626A75");
//        stardogsubLabel.numberOfLines = 0;
//        [stardogsubLabel sizeToFit];
//        [staredogBgView addSubview:stardogsubLabel];
//
//        UILabel *researchdescLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 225, (SCREEN_WIDTH/2 - 32), 20)];
//        researchdescLabel.font = UIFontMediumOfSize(14);
//        researchdescLabel.textColor = BHHexColor(@"626A75");
//
//        if (researchDogCountStr){
//            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@篇研究报告",researchDogCountStr]];
//            //修改颜色
//            NSLog(@"length------>%ld",researchDogCountStr.length);
//            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(0, researchDogCountStr.length)];
//
//            researchdescLabel.attributedText = string;
//        }
//        researchdescLabel.textAlignment = NSTextAlignmentCenter;
//        researchdescLabel.numberOfLines = 2;
//        [staredogBgView addSubview:researchdescLabel];
//
//        UIButton *researchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        researchButton.frame = CGRectMake(53, 265, SCREEN_WIDTH/2 - 53*2, 30);
//        researchButton.layer.masksToBounds = YES;
//        researchButton.layer.cornerRadius = 4;
//        [researchButton setTitle:@"看报告" forState:UIControlStateNormal];
//        [researchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        researchButton.titleLabel.font  = UIFontMediumOfSize(15);
//        [researchButton setBackgroundColor:BHHexColor(@"308CDD")];
//        [staredogBgView addSubview:researchButton];
//
////        UIButton *machinedogbgButton = [UIButton buttonWithType:UIButtonTypeCustom];
////        machinedogbgButton.frame = CGRectMake(0, 0, dogbgView.frame.size.width, dogbgView.frame.size.height);
////        [machinedogbgButton setBackgroundColor:[UIColor clearColor]];
////        [machinedogbgButton addTarget:self action:@selector(gotoContractDogPage) forControlEvents:UIControlEventTouchUpInside];
////        [machinedogbgView addSubview:machinedogbgButton];
//
//        UIButton *staredogButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        staredogButton.frame = CGRectMake(0, 0, bandratiodogbgView.frame.size.width, bandratiodogbgView.frame.size.height);
//        [staredogButton setBackgroundColor:[UIColor clearColor]];
//        [staredogButton addTarget:self action:@selector(gotoresearchDogPage) forControlEvents:UIControlEventTouchUpInside];
//        [staredogBgView addSubview:staredogButton];
//
//
//        UIView *bgpart3View = [[UIView alloc] initWithFrame:CGRectMake(0, bgpart2View.bottom +8, SCREEN_WIDTH, 44)];
//        bgpart3View.backgroundColor = BHHexColor(@"FAFAFA");
//        [cell.contentView addSubview:bgpart3View];
//
//        UIImageView *contractIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.8, 15, 14, 14)];
//        contractIconImageView.image = [UIImage imageNamed:@"jiqiIcon"];
//        [bgpart3View addSubview:contractIconImageView];
//
//        UILabel *contractdogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(33.6, 16, 39, 15)];
//        contractdogtitleLabel.text = @"机器狗";
//        contractdogtitleLabel.font = UIFontMediumOfSize(13);
//        contractdogtitleLabel.textColor = BHHexColor(@"626A75");
//        [bgpart3View addSubview:contractdogtitleLabel];
//
//        UIImageView *messagedogIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(87.8, 15, 14, 14)];
//        messagedogIconImageView.image = [UIImage imageNamed:@"Group 38"];
//        [bgpart3View addSubview:messagedogIconImageView];
//
//        UILabel *messagetitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(104.6, 16, 39, 15)];
//        messagetitleLabel.text = @"消息狗";
//        messagetitleLabel.font = UIFontMediumOfSize(13);
//        messagetitleLabel.textColor = BHHexColor(@"626A75");
//        [bgpart3View addSubview:messagetitleLabel];
//
//        UIImageView *researchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(159.6, 15, 14, 14)];
//        researchIconImageView.image = [UIImage imageNamed:@"Group 36"];
//        [bgpart3View addSubview:researchIconImageView];
//
//        UILabel *researcdogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(175.6, 16, 39, 15)];
//        researcdogtitleLabel.text = @"盯盘狗";
//        researcdogtitleLabel.font = UIFontMediumOfSize(13);
//        researcdogtitleLabel.textColor = BHHexColor(@"626A75");
//        [bgpart3View addSubview:researcdogtitleLabel];
//
//
//        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -133 -13, 17, 133, 12)];
//        subLabel.text = [NSString stringWithFormat:@"更多功能正在开发中…"];
//        subLabel.font = UIFontRegularOfSize(12);
//        subLabel.textColor = BHHexColor(@"626A75");
//        [bgpart3View addSubview:subLabel];

        return cell;
//    }
//    else if (indexPath.row == 1 + 2)
//    {//市场分析
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = BHHexColor(@"F9F9FA");
//
//        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 40 + 4+ 6, (SCREEN_WIDTH - 32), 78 + [self cellHeight] + 42 )];
//        bgView1.backgroundColor = BHHexColor(@"EDF0F2");
//
//        bgView1.layer.cornerRadius = 4;
//        bgView1.layer.shadowColor = BHHexColor(@"000000").CGColor;
//        bgView1.layer.shadowRadius = 4;
//        bgView1.layer.shadowOpacity = 0.1;
//        bgView1.layer.shadowOffset = CGSizeMake(1,1);
//        [cell.contentView addSubview:bgView1];
//
//        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 16, 16)];
//        image1.image = [UIImage imageNamed:@"home_shichangfenxi"];
//        [cell.contentView addSubview:image1];
//
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 16 , 80, 18)];
//        titleLabel.text = @"市场分析";
//        titleLabel.font = UIFontRegularOfSize(15);
//        titleLabel.textColor = BHHexColor(@"626A75");
//        [cell.contentView addSubview:titleLabel];
//
//        UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(bgView1.width - 10 - 17, 14, 10, 19)];
//        image3.image = [UIImage imageNamed:@"home_shichangfenxi_more"];
//        [bgView1 addSubview:image3];
//
//        UILabel *contentLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(16), SCALE_W(16), bgView1.width - SCALE_W(16)  -SCALE_W(10) - SCALE_W(17), SCALE_W(18))];
//        contentLabelTitle.text = descriptionModel.title;
//        contentLabelTitle.font = UIFontMediumOfSize(SCALE_W(16));
//        contentLabelTitle.textColor = BHHexColor(@"626A75");
//        [bgView1 addSubview:contentLabelTitle];
//
//        UILabel *contentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 49, SCREEN_WIDTH - 16 * 4, 12)];
//
//        contentLabel1.text = descriptionModel.date;
//        contentLabel1.font = UIFontLightOfSize(12);
//        contentLabel1.textColor = BHHexColorAlpha(@"626A75", 0.8);
//        [bgView1 addSubview:contentLabel1];
//
//        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 78, SCREEN_WIDTH - 16 * 4, [self cellHeight])];
//        contentLabel.text = descriptionModel.summary;
//        contentLabel.font = UIFontLightOfSize(13);
//        contentLabel.numberOfLines = 0;
//        contentLabel.textColor = BHHexColorAlpha(@"626A75", 0.8);
////        BHHexColor(@"626A75");
//        [contentLabel sizeToFit];
//        [bgView1 addSubview:contentLabel];
//
//        if (descriptionModel.tag && ![descriptionModel.tag isEqualToString:@""]) {
//            NSArray *array = [descriptionModel.tag componentsSeparatedByString:@","];
//            if (array.count > 0) {
//                for (int i = 0; i < array.count; i++)
//                {
//                    if (![array[i] isEqualToString:@""]) {
//                        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 + (28 + 6) * i, contentLabel.bottom + 10, 28, 16)];
//                        tagLabel.text = array[i];
//                        tagLabel.font = UIFontMediumOfSize(11);
//                        tagLabel.textAlignment = NSTextAlignmentCenter;
//                        //                    if ([array[i] isEqualToString:@"BTC"]) {
//                        //                       tagLabel.textColor = BHHexColor(@"FF8E00");
//                        //                    } else if ([array[i] isEqualToString:@"LTC"])
//                        //                    {
//                        //                        tagLabel.textColor = BHHexColor(@"CCC6C6");
//                        //                    } else if ([array[i] isEqualToString:@"ETH"])
//                        //                    {
//                        //                        tagLabel.textColor = BHHexColor(@"5A5A5A");
//                        //                    } else if ([array[i] isEqualToString:@"ETC"])
//                        //                    {
//                        //                        tagLabel.textColor = BHHexColor(@"579270");
//                        //                    } else if ([array[i] isEqualToString:@"BCH"])
//                        //                    {
//                        tagLabel.textColor = BHHexColor(@"ffffff");
//                        //                    }
//                        tagLabel.backgroundColor = BHHexColor(@"308CDD");
//                        [bgView1 addSubview:tagLabel];
//                    }
//                }
//            }
//        }
//
//        UILabel *contentLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, contentLabel1.top, 66, 12)];
//        if (descriptionModel.pv) {
//            contentLabel2.text = [NSString stringWithFormat:@"%@次浏览",descriptionModel.pv];
//        }
//        contentLabel2.font = UIFontLightOfSize(12);
//        contentLabel2.textColor = BHHexColor(@"626A75");
//        [contentLabel2 sizeToFit];
//        contentLabel2.right = bgView1.width - 16;
//        contentLabel2.centerY = contentLabel1.centerY;
//        [bgView1 addSubview:contentLabel2];
//
//        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 88 - 15 - 32, contentLabel1.top + 1, 15, 10)];
//        image2.image = [UIImage imageNamed:@"eye_icon_home"];
//        image2.right = contentLabel2.left - 6;
//        image2.centerY = contentLabel1.centerY;
//        [bgView1 addSubview:image2];
//
//        [cell.contentView addSubview:bgView1];
//        return cell;
//    }else if (indexPath.row == 1 + 2){//市场快讯
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = BHHexColor(@"F9F9FA");
//
//        UIView *grayView = [UIView new];
//        grayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
//        grayView.backgroundColor = [UIColor blueColor];
//        [cell.contentView addSubview:grayView];
////        KBGColor;
//
//        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 6+16, 18, 18)];
//        image1.image = [UIImage imageNamed:@"home_shichangkuaixun"];
//        [cell.contentView addSubview:image1];
//
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 6+18, 80, 18)];
//        titleLabel.text = @"市场快讯";
//        titleLabel.font = UIFontMediumOfSize(14);
//        titleLabel.textColor = BHHexColor(@"626A75");
//        [cell.contentView addSubview:titleLabel];
//
//
//
//        //创建轮播器控件
//        LBBannerView *bannerView = [[LBBannerView alloc] initViewWithFrame:CGRectMake(0, 6+50, SCREEN_WIDTH, defaultScrollHeight) autoPlayTime:5.0f imagesArray:productList clickCallBack:^(float height) {
//            [UserStatistics sendEventToServer:@"首页点击市场快讯"];
//            defaultScrollHeight = height;
//            [self.homePageTableView  beginUpdates];
//            [self.homePageTableView  endUpdates];
//            [self onclickMarketFlash];
//        }];
//
//        [cell.contentView addSubview:bannerView];
//
//
//        return cell;
    } else if(indexPath.row == 1 + 2){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BHHexColor(@"F9F9FA");
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (9));
        
        lineView.backgroundColor = KBGColor;
        [cell.contentView addSubview:lineView];

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, (9), SCREEN_WIDTH, 50)];
        bgView.backgroundColor = BHHexColor(@"F9F9FA");
        [cell addSubview:bgView];
//
//        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 16, 16)];
//        image1.image = [UIImage imageNamed:@"home_celuegensui-1"];
//        [bgView addSubview:image1];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 80, 15)];
        titleLabel.text = @"策略服务";
        titleLabel.font = UIFontMediumOfSize(14);
        titleLabel.textColor = BHHexColor(@"626A75");
        [bgView addSubview:titleLabel];

//        UIView *lineView = [[UIView alloc] init];
//        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
//        lineView.backgroundColor = BHHexColor(@"E6EBF0");
//        [bgView addSubview:lineView];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:MobileTradeNum] integerValue] == 1) {
            UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.width - 16.2 - 6.5, 18.7, 6.5, 14)];
            image3.image = [UIImage imageNamed:@"home_shichangfenxi_more-1"];
            [bgView addSubview:image3];

//            UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(28+29), 13, 28, 14)];
//            moreLabel.text = @"更多";
//            moreLabel.textAlignment = NSTextAlignmentRight;
//            moreLabel.font = UIFontRegularOfSize(14);
//            moreLabel.textColor = BHHexColor(@"626A75");
//            [bgView addSubview:moreLabel];

            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            moreButton.frame = CGRectMake(SCREEN_WIDTH-(28+29), 0, 28+29, 50);
            [moreButton setBackgroundColor:[UIColor clearColor]];
            [moreButton addTarget:self action:@selector(moreButton) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:moreButton];
            
            
            UIButton *stragymoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            stragymoreButton.frame = CGRectMake(0 ,0, SCREEN_WIDTH, 50);
            [stragymoreButton setBackgroundColor:[UIColor clearColor]];
            [stragymoreButton addTarget:self action:@selector(moreButton) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:stragymoreButton];
        }
        return cell;
    }
    else
    {//策略服务
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BHHexColor(@"F9F9FA");

        HomeProductInfoModel *productInfo = productInfoArray[indexPath.row - 4];
        CGRect rect = [productInfo.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 160, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontRegularOfSize(12)} context:nil];

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH - 32, 50 + rect.size.height + 78 )];
        bgView.backgroundColor = BHHexColor(@"EDF0F2");
//        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4;
        [cell.contentView addSubview:bgView];
        bgView.layer.shadowColor = BHHexColor(@"000000").CGColor;
        bgView.layer.shadowRadius = 4;
        bgView.layer.shadowOpacity = 0.1;
        bgView.layer.shadowOffset = CGSizeMake(0,1);
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 28, 32, 36)];
        if ([productInfo.type isEqualToString:@"日内策略"]) {
            image2.image = [UIImage imageNamed:@"ic_rinei"];
        } else if ([productInfo.type isEqualToString:@"中期策略"])
        {
            image2.image = [UIImage imageNamed:@"ic_zhonhqi"];
        } else
        {
            image2.image = [UIImage imageNamed:@"ic_changqi"];
        }

        [bgView addSubview:image2];

        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(64, 24, SCREEN_WIDTH - 160, 20)];
        titleLabel2.text = productInfo.name;
        titleLabel2.font = UIFontMediumOfSize(16);
        titleLabel2.textColor = BHHexColor(@"525866");
        [bgView addSubview:titleLabel2];

        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(64, 48, SCREEN_WIDTH - 160, rect.size.height)];
        titleLabel3.text = productInfo.desc;
        titleLabel3.font = UIFontLightOfSize(12);
        titleLabel3.alpha = 0.8;
        titleLabel3.numberOfLines = 0;
        titleLabel3.textColor = BHHexColorAlpha(@"626A75", 0.8);
        [bgView addSubview:titleLabel3];

        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 25, 24, 24)];
        bgView1.backgroundColor = [UIColor clearColor];
        bgView1.left = bgView.width - 24 - 16;
        bgView1.layer.masksToBounds = YES;
        bgView1.layer.cornerRadius = 4;
        bgView1.layer.borderWidth = 2;
        if ([productInfo.riskLevel integerValue] == 1) {
            bgView1.layer.borderColor = BHHexColor(@"A3D97D").CGColor;
        } else if ([productInfo.riskLevel integerValue] == 2)
        {
            bgView1.layer.borderColor = BHHexColor(@"FF7C08").CGColor;
        } else
        {
            bgView1.layer.borderColor = BHHexColor(@"FE413F").CGColor;
        }
        [bgView addSubview:bgView1];

        UILabel *titleLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        titleLabel7.textAlignment = NSTextAlignmentCenter;
        titleLabel7.text = productInfo.riskValue;
        titleLabel7.font = UIFontRegularOfSize(20);
        if ([productInfo.riskLevel integerValue] == 1) {
            titleLabel7.textColor = BHHexColor(@"A3D97D");
        } else if ([productInfo.riskLevel integerValue] == 2)
        {
            titleLabel7.textColor = BHHexColor(@"FF7C08");
        } else
        {
            titleLabel7.textColor = BHHexColor(@"FE413F");
        }

        [bgView1 addSubview:titleLabel7];

        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(64, 56, 60, 14)];
        titleLabel4.left = bgView.width - 60 - 16;
        titleLabel4.textAlignment = NSTextAlignmentRight;
        titleLabel4.text = @"风险";
        titleLabel4.font = UIFontRegularOfSize(12);
        titleLabel4.textColor = BHHexColor(@"626A75");
        [bgView addSubview:titleLabel4];

        UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(16, titleLabel3.bottom + 31, bgView.width - 32, 1)];
        bgView2.backgroundColor = BHHexColor(@"E6EBF0");
        [bgView addSubview:bgView2];


        UILabel *titleLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(16, bgView2.bottom + 13, 160, 14)];
        titleLabel6.text = @"累计收益率";
        titleLabel6.font = UIFontRegularOfSize(14);
        titleLabel6.textColor = BHHexColor(@"626A75");
        [bgView addSubview:titleLabel6];

        UILabel *titleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(16, bgView2.bottom + 10, 160, 20)];
        titleLabel5.left = bgView.width - 160 - 16;
        titleLabel5.textAlignment = NSTextAlignmentRight;
        titleLabel5.font = UIFontRegularOfSize(20);
        [bgView addSubview:titleLabel5];


        if ([productInfo.ror integerValue] > 0) {
            titleLabel5.text = [NSString stringWithFormat:@"+%@%%",productInfo.ror];
            titleLabel5.textColor = BHHexColor(@"228B22");
        } else if ([productInfo.ror integerValue] < 0)
        {
            titleLabel5.text = [NSString stringWithFormat:@"%@%%",productInfo.ror];
            titleLabel5.textColor = BHHexColor(@"FF4040");
        } else
        {
            titleLabel5.text = [NSString stringWithFormat:@"%@%%",productInfo.ror];
            titleLabel5.textColor = BHHexColor(@"626A75");
        }

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideWebTip];
//    if ([_dataSource count] > 0 && indexPath.row >= 1 && indexPath.row <= [_dataSource count])
//    {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDetail:)]) {
//            HomeDesListModel *model = _dataSource[indexPath.row - 1];
//            [self.delegate jumpToDetail:model];
//        }
//    }
//
//
//
//    if (indexPath.row == 1 + 2) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDetails:)]) {
//            [self.delegate jumpToDetails:descriptionModel];
//        }
//    }
//
//
//
//   NSLog(@"indexPath.row ------->%ld",indexPath.row);

   if (indexPath.row >=  4 )
   {
       HomeProductInfoModel *productInfo = productInfoArray[indexPath.row - 4];
       if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToStrategyFollow:)]) {
           [self.delegate jumpToStrategyFollow:productInfo];
       }
   }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hidden)]) {
        [self.delegate hidden];
    }
}

- (void)closeButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeGonggao)]) {
        [self.delegate closeGonggao];
    }
}

- (void)moreButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToStrategyList)]) {
        [self.delegate jumpToStrategyList];
    }
}

#pragma mark 上下滚动的跑马灯
/** 添加上下滚动的跑马灯 */
- (void)addVerticalMarquee:(UIView *)bgView {
    _verticalMarquee = [[JhtVerticalMarquee alloc]  initWithFrame:CGRectMake(49, 0, SCREEN_WIDTH - 80, 40)];
    [bgView addSubview:_verticalMarquee];
    _verticalMarquee.verticalTextColor = BHHexColor(@"FF6B28");
    _verticalMarquee.verticalTextFont = UIFontRegularOfSize(13);
    
//    NSString *str = @"谁曾在谁的花季里停留，温暖了想念";
//    // 创建NSMutableAttributedString
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
//    // 设置字体和设置字体的范围
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0f] range:NSMakeRange(0, 3)];
//    // 添加文字颜色
//    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 2)];
//    // 添加文字背景颜色
//    [attrStr addAttribute:NSBackgroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(7, 2)];
//    // 添加下划线
//    [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(11, 5)];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    if (anouncement.count > 0) {
        for (int i = 0; i < anouncement.count; i++) {
            [arr addObject:[anouncement[i] objectForKey:@"title"]];
        }
    }
//    NSArray *soureArray = @[@"谁曾在谁的花季里停留，温暖了想念谁曾在谁的花季里停留，温暖了想念",@"谁曾在谁的花季里停留",@"谁曾在谁的花季里停留",@"谁曾在谁的花季里停留"];
    
    //    _verticalMarquee.isCounterclockwise = YES;
    _verticalMarquee.sourceArray = arr;
    [_verticalMarquee scrollWithCallbackBlock:^(JhtVerticalMarquee *view, NSInteger currentIndex) {
//        NSLog(@"滚动到第 %ld 条数据", (long)currentIndex);
    }];
    
    // 开始滚动
    if (arr.count > 1) {
        [_verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
    }
}


#pragma mark -- 隐藏webview中的显示的数据tip
- (void)hideWebTip{
    //    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('highcharts-label')[0].style.display='none'"];// focus()
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('highcharts-label')[0].style.visible='hidden'"];// focus()
}

- (void)subEventHandle:(NSNotification *)obj{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 + 1 inSection:0];
    [_homePageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RESUME_ANIMATIONS object:nil];
}


-(void)setAnimationRoundAddSuperView:(UIView *)superView WithDogIconImageVewStr:(NSString *)dogIconNameStr{
    UIImageView *dogbgImageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3, 48, 48)];
    dogbgImageview.layer.masksToBounds = YES;
    dogbgImageview.layer.cornerRadius = 48 / 2;
    dogbgImageview.backgroundColor = BHHexColorAlpha(@"0078F1", 0.13);
    [superView addSubview:dogbgImageview];
    
    UIImageView *dogImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    dogImageview.image = [UIImage imageNamed:dogIconNameStr];
    [dogbgImageview addSubview:dogImageview];
    
    
    CAShapeLayer *layer0bg =[CAShapeLayer layer];
    layer0bg.lineWidth = 1;
    layer0bg.fillColor = [UIColor clearColor].CGColor;
    layer0bg.strokeColor = BHHexColor(@"dbe0e7").CGColor;
    layer0bg.frame = CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3, 48, 48);
    layer0bg.lineCap = kCALineCapRound;
    
    UIBezierPath *path0bg = [UIBezierPath bezierPathWithArcCenter:CGPointMake(48/2, 48/2) radius:48/2 startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    layer0bg.path = path0bg.CGPath;
    [superView.layer addSublayer:layer0bg];
    
    CAShapeLayer *layer0 =[CAShapeLayer layer];
    layer0.lineWidth = 3;
    layer0.fillColor = [UIColor clearColor].CGColor;
    layer0.strokeColor = BHHexColor(@"FB9549").CGColor;;
    layer0.frame = CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3,  48, 48);
    layer0.lineCap = kCALineCapRound;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(48/2, 48/2) radius:48/2 startAngle:DEGREES_TO_RADIANS(135) endAngle:DEGREES_TO_RADIANS(195) clockwise:YES];
    layer0.path = path.CGPath;
    [superView.layer addSublayer:layer0];
    
    
    //旋转
    CABasicAnimation *rotaAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotaAni.fromValue = @(DEGREES_TO_RADIANS(0));
    rotaAni.toValue = @(DEGREES_TO_RADIANS(360));
    rotaAni.autoreverses = YES;
    rotaAni.removedOnCompletion = NO;
    rotaAni.fillMode = kCAFillModeForwards;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.repeatCount = INFINITY;
    group.duration = 2;
    group.animations = @[
                         rotaAni,
                         ];
    [layer0 addAnimation:group forKey:nil];
    
    
    CAShapeLayer *layer1bg =[CAShapeLayer layer];
    layer1bg.lineWidth = 1;
    layer1bg.fillColor = [UIColor clearColor].CGColor;
    layer1bg.strokeColor = BHHexColor(@"dbe0e7").CGColor;
    
    layer1bg.frame = CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3,  48, 48);
    layer1bg.lineCap = kCALineCapRound;
    
    UIBezierPath *path1bg = [UIBezierPath bezierPathWithArcCenter:CGPointMake(48/2, 48/2) radius: 48/2+6 startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    layer1bg.path = path1bg.CGPath;
    [superView.layer addSublayer:layer1bg];
    
    CAShapeLayer *layer1 =[CAShapeLayer layer];
    layer1.lineWidth = 3;
    layer1.fillColor = [UIColor clearColor].CGColor;
    layer1.strokeColor = BHHexColor(@"6FCC4F").CGColor;
    layer1.frame = CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3,  48, 48);
    layer1.lineCap = kCALineCapRound;
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(48/2, 48/2) radius: 48/2+6 startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(150) clockwise:YES];
    layer1.path = path1.CGPath;
    [superView.layer addSublayer:layer1];
    
    //旋转圈
    CABasicAnimation *rotaAni1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotaAni1.fromValue = @(DEGREES_TO_RADIANS(360));
    rotaAni1.toValue = @(DEGREES_TO_RADIANS(0));
    rotaAni1.autoreverses = YES;
    rotaAni1.removedOnCompletion = NO;
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.repeatCount = INFINITY;
    group1.duration = 2;
    group1.animations = @[
                          rotaAni1,
                          ];
    [layer1 addAnimation:group1 forKey:nil];
    
    CAShapeLayer *layer3bg =[CAShapeLayer layer];
    layer3bg.lineWidth = 1;
    layer3bg.fillColor = [UIColor clearColor].CGColor;
    layer3bg.strokeColor =  BHHexColor(@"dbe0e7").CGColor;
    layer3bg.frame = CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3,  48, 48);
    layer3bg.lineCap = kCALineCapRound;
    
    UIBezierPath *path3bg = [UIBezierPath bezierPathWithArcCenter:CGPointMake(48/2, 48/2) radius:78/2 startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    layer3bg.path = path3bg.CGPath;
    [superView.layer addSublayer:layer3bg];
    
    CAShapeLayer *layer3 =[CAShapeLayer layer];
    layer3.lineWidth = 3;
    layer3.fillColor = [UIColor clearColor].CGColor;
    layer3.strokeColor = BHHexColor(@"8CA4FB").CGColor;
    layer3.frame = CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3,  48, 48);
    layer3.lineCap = kCALineCapRound;
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(48/2, 48/2) radius:78/2 startAngle:DEGREES_TO_RADIANS(-10) endAngle:DEGREES_TO_RADIANS(110) clockwise:YES];
    layer3.path = path3.CGPath;
    [superView.layer addSublayer:layer3];
    
    CABasicAnimation *rotaAni3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotaAni3.fromValue = @(DEGREES_TO_RADIANS(0));
    rotaAni3.toValue = @(DEGREES_TO_RADIANS(360));
    rotaAni3.autoreverses = YES;
    rotaAni3.removedOnCompletion = NO;
    CAAnimationGroup *group3 = [CAAnimationGroup animation];
    group3.repeatCount = INFINITY;
    group3.duration = 2;
    group3.animations = @[
                          rotaAni3,
                          ];
    
    
    [layer3 addAnimation:group3 forKey:nil];
    
    CAShapeLayer *layer4bg =[CAShapeLayer layer];
    layer4bg.lineWidth = 1;
    layer4bg.fillColor = [UIColor clearColor].CGColor;
    layer4bg.strokeColor =  BHHexColor(@"dbe0e7").CGColor;
    layer4bg.frame = CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3,  48, 48);
    layer4bg.lineCap = kCALineCapRound;
    
    UIBezierPath *path4bg = [UIBezierPath bezierPathWithArcCenter:CGPointMake(48/2, 48/2) radius:98/2 startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    layer4bg.path = path4bg.CGPath;
    [superView.layer addSublayer:layer4bg];
    
    CAShapeLayer *layer4 =[CAShapeLayer layer];
    layer4.lineWidth = 3;
    layer4.fillColor = [UIColor clearColor].CGColor;
    layer4.strokeColor = BHHexColor(@"16A5FC").CGColor;
    layer4.frame = CGRectMake((SCREEN_WIDTH/2 - 48)/2, 131.3,  48, 48);
    layer4.lineCap = kCALineCapRound;
    
    UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(48/2, 48/2) radius:98/2 startAngle:DEGREES_TO_RADIANS(-125) endAngle:DEGREES_TO_RADIANS(35) clockwise:YES];
    layer4.path = path4.CGPath;
    [superView.layer addSublayer:layer4];
    
    
    CABasicAnimation *rotaAni4 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotaAni4.fromValue = @(DEGREES_TO_RADIANS(360));
    rotaAni4.toValue = @(DEGREES_TO_RADIANS(0));
    rotaAni4.autoreverses = YES;
    rotaAni4.removedOnCompletion = NO;
    CAAnimationGroup *group4 = [CAAnimationGroup animation];
    group4.repeatCount = INFINITY;
    group4.duration = 2;
    group4.animations = @[
                          rotaAni4,
                          ];
    [layer4 addAnimation:group4 forKey:nil];
}

-(UIView *)setAllKindsOfDogWithIcon:(NSString *)iconImageStr WithFeature:(NSString *)dogStr{
    UIView *dogBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCALE_W(166), SCALE_W(82))];
    dogBgView.backgroundColor = BHHexColor(@"FFFFFF");
    dogBgView.userInteractionEnabled = YES;
    dogBgView.layer.cornerRadius = 3;
    dogBgView.layer.shadowColor = BHHexColor(@"000000").CGColor;
    dogBgView.layer.shadowRadius = 3;
    dogBgView.layer.shadowOpacity = 0.1;
    dogBgView.layer.shadowOffset = CGSizeMake(0,1);
    
    
//    if([dogStr isEqualToString:@"链查查"]){
//        dogBgView.tag = 100006;
//        UIImageView *iconImageView1 = [[UIImageView alloc] init];
//        iconImageView1.image = [UIImage imageNamed:iconImageStr];
//        iconImageView1.frame = CGRectMake(dogBgView.frame.size.width -SCALE_W(34)-SCALE_W(10), SCALE_W(14), SCALE_W(34), SCALE_W(34));
//        [dogBgView addSubview:iconImageView1];
//
//
//        UILabel *contractdogtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(14), SCALE_W(22), SCALE_W(100), SCALE_W(15))];
//        contractdogtitleLabel.text = @"机器狗、消息狗";
//        contractdogtitleLabel.font = UIFontMediumOfSize(SCALE_W(13));
//        contractdogtitleLabel.textColor = BHHexColor(@"626A75");
//        [dogBgView addSubview:contractdogtitleLabel];
//
//
//        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(14), SCALE_W(48), dogBgView.width -SCALE_W(14)-SCALE_W(12), SCALE_W(12))];
//                subLabel.text = [NSString stringWithFormat:@"更多功能正在开发中…"];
//                subLabel.font = UIFontRegularOfSize(12);
//                subLabel.textColor = BHHexColorAlpha(@"626A75", 0.6);
//        [dogBgView addSubview:subLabel];
//        return dogBgView;
//    }
    
    UITapGestureRecognizer *dogBgViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDogPage:)];
    [dogBgView addGestureRecognizer:dogBgViewtap];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:iconImageStr];
    iconImageView.frame = CGRectMake(dogBgView.frame.size.width -SCALE_W(34)-SCALE_W(10), SCALE_W(14), SCALE_W(34), SCALE_W(34));
    [dogBgView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(SCALE_W(14), (13), SCALE_W(55), SCALE_W(16));
    titleLabel.text = dogStr;
    titleLabel.font = UIFontMediumOfSize(SCALE_W(16));
    titleLabel.textColor = BHHexColor(@"626A75");
    [dogBgView addSubview:titleLabel];
    
    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.font = UIFontRegularOfSize(SCALE_W(10));
    subLabel.textColor = BHHexColorAlpha(@"626A75", 0.6);
    subLabel.frame = CGRectMake(SCALE_W(14), 38, dogBgView.width -SCALE_W(14+44), SCALE_W(10));
    [dogBgView addSubview:subLabel];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.frame = CGRectMake(SCALE_W(14), SCALE_W(65),  dogBgView.width -SCALE_W(14), SCALE_W(10));
    desLabel.font = UIFontRegularOfSize(SCALE_W(10));
    desLabel.textAlignment = NSTextAlignmentLeft;
    desLabel.textColor = BHHexColorAlpha(@"626A75", 0.8);
//    BHHexColor(@"626A75");
    [dogBgView addSubview:desLabel];
    
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = BHHexColor(@"E6EBF0");
    lineImageView.frame = CGRectMake(0, 56, dogBgView.frame.size.width, 0.5);
    [dogBgView addSubview:lineImageView];
//    UIButton *dogButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    dogButton.frame = CGRectMake(dogBgView.right - 70 - 22, 53, 70, 24);
//    [dogButton setBackgroundColor:BHHexColor(@"308CDD")];
//    dogButton.layer.cornerRadius = 12;
//    [dogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    dogButton.titleLabel.font = UIFontRegularOfSize(12);
//    [dogButton addTarget:self action:@selector(gotoDogPageButton:) forControlEvents:UIControlEventTouchUpInside];
//
//    [dogBgView addSubview:dogButton];
    
    UIImageView *cycleImv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 6, 6)];
    cycleImv.backgroundColor = BHHexColor(@"FF4040");
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cycleImv.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cycleImv.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = cycleImv.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    cycleImv.layer.mask = maskLayer;
    [dogBgView addSubview:cycleImv];
    cycleImv.hidden = YES;
    if([dogStr isEqualToString:@"撸庄狗"]){
        // 判断是不是第一次启动APP
        newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
        newImageView.image = [UIImage imageNamed:@"newIcon"];
        [dogBgView addSubview:newImageView];
        newImageView.hidden = YES;
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
             newImageView.hidden = NO;
        }

        
        
        dogBgView.tag = 100001;
//        dogButton.tag = 100001;
        desLabel.text = @"人工智能实时预判拉盘、出货";
//        [dogButton setTitle:@"去撸庄" forState:UIControlStateNormal];
       
        if (luzdogCountModel){
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"本周开撸%@次 收益%@%@",luzdogCountModel.recentCount,luzdogCountModel.income,@"%"]];
            //修改颜色
            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(4, luzdogCountModel.recentCount.length)];
            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(4 + luzdogCountModel.recentCount.length + 4   , luzdogCountModel.income.length )];
            subLabel.attributedText = string;
            if ([luzdogCountModel.notice intValue] > 0) {
                cycleImv.hidden = NO;;
            }
        }
    }
    
    if([dogStr isEqualToString:@"波段狗"]){
        dogBgView.tag = 100002;
//        dogButton.tag = 100002;
        desLabel.text = @"主流币种实时买点/卖点智能提示";
//        [dogButton setTitle:@"做波段" forState:UIControlStateNormal];

        if (banddogyModel){
             NSString *coutstr = [self countNumAndChangeformat:banddogyModel.userCount];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@人正在使用",coutstr]];
            //修改颜色
//            NSLog(@"length------>%ld",homedogCountModel.userCount.length);
            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(0, coutstr.length)];

            subLabel.attributedText = string;
            if ([banddogyModel.notice intValue] > 0) {
                cycleImv.hidden = NO;;
            }
        }
        
    }
    if([dogStr isEqualToString:@"合约狗"]){
        dogBgView.tag = 100003;
//        dogButton.tag = 100003;
        desLabel.text = @"深度挖掘交易数据，技术派必备";
//        [dogButton setTitle:@"做合约" forState:UIControlStateNormal];
        if (contractdogModel){
            NSString *coutstr = [self countNumAndChangeformat:contractdogModel.userCount];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@人正在使用",coutstr]];
            //修改颜色
//            NSLog(@"length------>%ld",contractDogCountStr.length);
            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(0, coutstr.length)];
            subLabel.attributedText = string;
            cycleImv.hidden = NO;;
            
        }
    }
    if([dogStr isEqualToString:@"研究狗"]){
        dogBgView.tag = 100004;
//        dogButton.tag = 100004;
        desLabel.text = @"汇聚区块链领域最新研究报告";
//        [dogButton setTitle:@"读报告" forState:UIControlStateNormal];
        if (researchdoyModel){
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@家机构 %@篇报告",researchdoyModel.agencyCount,researchdoyModel.recentCount]];
            //修改颜色
//            NSLog(@"length------>%ld",researchDogCountStr.length);
            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(0, researchdoyModel.agencyCount.length)];
             [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange( string.length - 3 -researchdoyModel.recentCount.length, researchdoyModel.recentCount.length)];
            subLabel.attributedText = string;
            if ([researchdoyModel.notice intValue] > 0) {
                cycleImv.hidden = NO;;
            }
        }
        
    }
    
    if ([dogStr isEqualToString:@"盯盘狗"]) {
        dogBgView.tag = 100005;
//        dogButton.tag = 100005;
        desLabel.text = @"多种智能指标为您实时盯盘";
//        [dogButton setTitle:@"去盯盘" forState:UIControlStateNormal];
        if (startdogModel){
            NSString *coutstr = [self countNumAndChangeformat:startdogModel.userCount];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"已累计盯盘%@次",coutstr]];
            //修改颜色
            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(5, coutstr.length)];
            subLabel.attributedText = string;
            if ([startdogModel.notice intValue] > 0) {
                cycleImv.hidden = NO;;
            }
        }
    }
    
    if ([dogStr isEqualToString:@"链查查"]) {
        dogBgView.tag = 100006;
        //        dogButton.tag = 100005;
        desLabel.text = @"跟踪区块链行业信息";
        //        [dogButton setTitle:@"去盯盘" forState:UIControlStateNormal];
        if (lianchachaModel){
            NSString *coutstr = [self countNumAndChangeformat:lianchachaModel.userCount];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"已关联项目%@个",coutstr]];
            //修改颜色
            [string addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308CDD")range:NSMakeRange(5, coutstr.length)];
            subLabel.attributedText = string;
            if ([lianchachaModel.notice intValue] > 0) {
                cycleImv.hidden = NO;;
            }
        }
    }
    return dogBgView;
}






//金钱每三位加一个逗号，经过封装的一个方法直接调用即可，传一个你需要加，号的字符串就好了
-(NSString *)countNumAndChangeformat:(NSString *)num
{
    if([num rangeOfString:@"."].location !=NSNotFound) //这个判断是判断有没有小数点如果有小数点，需特别处理，经过处理再拼接起来
    {
        NSString *losttotal = [NSString stringWithFormat:@"%.2f",[num floatValue]];//小数点后只保留两位
        NSArray *array = [losttotal componentsSeparatedByString:@"."];
        //小数点前:array[0]
        //小数点后:array[1]
        int count = 0;
        num = array[0];
        long long int a = num.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        NSMutableString *newString = [NSMutableString string];
        newString =[NSMutableString stringWithFormat:@"%@.%@",newstring,array[1]];
        return newString;
    }else {
        int count = 0;
        long long int a = num.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        return newstring;
    }
}
@end
