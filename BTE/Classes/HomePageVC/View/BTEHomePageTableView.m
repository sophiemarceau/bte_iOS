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
@implementation BTEHomePageTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _homePageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _homePageTableView.backgroundColor = KBGColor;
        _homePageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homePageTableView.delegate = self;
        _homePageTableView.dataSource = self;
        defaultHeight = 68;
        fixedHeight = 52;
        btnHeight = 20;
        defaultScrollHeight = 70 + 80;
        _isShow = NO;//初始化不展开
        [self addSubview:_homePageTableView];
        [self setTableFooterView];
    }
    return self;
}

//设置头部视图
- (void)setTableHeadView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 + 185)];
    bgView.backgroundColor = BHHexColor(@"fafafa");
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 14, 17, 17)];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:headModel.icon] placeholderImage:nil];
    [bgView addSubview:_iconImage];
    
    _subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(38, 14, 75, 17)];
    _subTitleLabel1.text = [NSString stringWithFormat:@"%@行情",headModel.symbol];
    
    _subTitleLabel1.font = UIFontMediumOfSize(17);
    _subTitleLabel1.textColor = BHHexColor(@"626A75");
    [bgView addSubview:_subTitleLabel1];

    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(105, 10, 36, 30);
//    sureButton.backgroundColor = [UIColor redColor];
    [sureButton addTarget:self action:@selector(TapChange:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureButton];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(111, 24, 6, 6)];
    arrowImage.image = [UIImage imageNamed:@"home_arrow_bg"];
    arrowImage.userInteractionEnabled = YES;
    [bgView addSubview:arrowImage];
    
    _subTitleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 110, 20)];
    _subTitleLabel3.left = SCREEN_WIDTH - _subTitleLabel3.width - 16;
    _subTitleLabel3.textAlignment = NSTextAlignmentRight;
    _subTitleLabel3.text = [NSString stringWithFormat:@"$%@",headModel.price];
    
    _subTitleLabel3.font = UIFontRegularOfSize(20);
    _subTitleLabel3.textColor = BHHexColor(@"228B22");
    [bgView addSubview:_subTitleLabel3];
    
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
    
    self.urlString = [NSString stringWithFormat:@"%@/%@",kAppMarketAnalysisAddress,headModel.symbol];
    [bgView addSubview:self.webView];
    self.homePageTableView.tableHeaderView = bgView;
}

#pragma mark - webView
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,44,SCREEN_WIDTH,185)];
        _webView.backgroundColor = KBGColor;
        _webView.delegate = self;
    }
    //请求
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

- (void)TapChange:(UITapGestureRecognizer *)taps
{
    if (self.delegate && headModel.symbol && [self.delegate respondsToSelector:@selector(doTapChange:)]) {
        [self.delegate doTapChange:headModel.symbol];
    }
}

//设置尾部视图
- (void)setTableFooterView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 189)];
    headView.backgroundColor = KBGColor;
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 29, 74, 74)];
    image1.image = [UIImage imageNamed:@"erweima"];
    [headView addSubview:image1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 106, 80, 14)];
    titleLabel.text = @"打开微信,扫一扫";
    titleLabel.font = UIFontRegularOfSize(10);
    titleLabel.textColor = BHHexColor(@"AEAEAE");
    [headView addSubview:titleLabel];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(126, 31, 22, 12)];
    image2.image = [UIImage imageNamed:@"home_dibu_logo"];
    [headView addSubview:image2];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(151, 24, 195, 25)];
    titleLabel1.text = @"玩转比特币 多看比特易";
    titleLabel1.font = UIFontRegularOfSize(14);
    titleLabel1.textColor = BHHexColor(@"626A75");
    [headView addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(126, 53, SCREEN_WIDTH - 126 - 18, 25)];
    titleLabel2.text = @"比特易是业界领先的数字货币市场专业分析平台，我们提供专业数字货币市场分析工具和风险管理策略，帮您有效控制数字货币投资风险。";
    titleLabel2.font = UIFontRegularOfSize(12);
    titleLabel2.numberOfLines = 0;
    titleLabel2.textColor = BHHexColor(@"626A75");
    titleLabel2.alpha = 0.8;
    [titleLabel2 sizeToFit];
    [headView addSubview:titleLabel2];
    
    
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 124) / 2, 145, 124, 25)];
    image3.image = [UIImage imageNamed:@"bottom_sb_bluerun"];
    [headView addSubview:image3];
    
    self.homePageTableView.tableFooterView = headView;
}

//刷新数据UI
-(void)refreshUi:(NSArray *)model productList:(NSArray *)productListModel model1:(HomeDescriptionModel *)DescriptionModel model2:(HomeProductInfoModel *)ProductInfoModel currentCurrencyType:(NSString *)currentCurrencyType
{
    _dataSource = model;
    productList = productListModel;
    descriptionModel = DescriptionModel;
    productInfoModel = ProductInfoModel;
    headModel = model[0];//默认第一个
    if (currentCurrencyType) {
        for (HomeDesListModel *tempModel in model) {
            if ([tempModel.symbol isEqualToString:currentCurrencyType]) {
                headModel = tempModel;
            }
        }
    }
    if (headModel) {
        [self setTableHeadView];
    }
    [self.homePageTableView reloadData];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count] + 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 16;
    } else if ([_dataSource count] > 0 && indexPath.row >= 1 && indexPath.row <= [_dataSource count])
    {
        return 72;
    } else if (indexPath.row == [_dataSource count] + 1)
    {
        return [self cellHeight];
    }
    else if (indexPath.row == [_dataSource count] + 2)
    {
        return 16;
    }
    else if (indexPath.row == [_dataSource count] + 3)
    {
        return 53 + defaultScrollHeight + 16;
    } else if (indexPath.row == [_dataSource count] + 4)
    {
        return 16;
    } else
    {
        CGRect rect = [productInfoModel.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 160, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontRegularOfSize(12)} context:nil];
        return 124 + 48 + 78 + rect.size.height;
    }
}

- (float)cellHeight
{
    NSString * contentStr= descriptionModel.desc;
    CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 32, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    if (rect.size.height > defaultHeight) {
        if (_isShow) {//是否展开
            return fixedHeight + btnHeight + rect.size.height;
        }else{
            return fixedHeight + btnHeight + defaultHeight;
        }
    } else {
        return fixedHeight + rect.size.height;
    }
    
    return 168;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == [_dataSource count] + 2 || indexPath.row == [_dataSource count] + 4) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGColor;
        return cell;
    } else if ([_dataSource count] > 0 && indexPath.row >= 1 && indexPath.row <= [_dataSource count])
    {
        static NSString *CellIdentifier = @"Cell";
        BTEHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[BTEHomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCellWithModel:_dataSource[indexPath.row - 1]];
        return cell;
    } else if (indexPath.row == [_dataSource count] + 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH - 32, 168)];
        bgView.height = [self cellHeight];
        bgView.backgroundColor = BHHexColor(@"fafafa");
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4;
        [cell.contentView addSubview:bgView];
        
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, 16, 16)];
        image1.image = [UIImage imageNamed:@"home_market analysis"];
        [bgView addSubview:image1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 22, 80, 18)];
        titleLabel.text = @"市场分析";
        titleLabel.font = UIFontMediumOfSize(17);
        titleLabel.textColor = BHHexColor(@"626A75");
        [bgView addSubview:titleLabel];
        
        
        NSString * contentStr= descriptionModel.desc;
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 32, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, SCREEN_WIDTH - 32, rect.size.height)];
        contentLabel.text = descriptionModel.desc;
        if (_isShow) {
            
        } else
        {
            contentLabel.height = defaultHeight;
        }
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = BHHexColor(@"626A75");
        [bgView addSubview:contentLabel];
        
        if (rect.size.height > defaultHeight) {
            
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.width - 10 - 16, bgView.height - 5 - 10, 10, 5)];
            
            [bgView addSubview:arrowImage];
            if (_isShow) {//是否展开
                arrowImage.image = [UIImage imageNamed:@"home_retract"];
            }else{
                arrowImage.image = [UIImage imageNamed:@"home_more"];
            }
        }
       
        return cell;
    } else if (indexPath.row == [_dataSource count] + 3)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        
        
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 18, 16, 18)];
        image1.image = [UIImage imageNamed:@"home_Market news"];
        [cell.contentView addSubview:image1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 17, 80, 18)];
        titleLabel.text = @"市场快讯";
        titleLabel.font = UIFontMediumOfSize(17);
        titleLabel.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:titleLabel];
        
        //创建轮播器控件
        LBBannerView *bannerView = [[LBBannerView alloc] initViewWithFrame:CGRectMake(0, 53, SCREEN_WIDTH, defaultScrollHeight) autoPlayTime:5.0f imagesArray:productList clickCallBack:^(float height) {
            NSLog(@"点击了第%f张图片",height);
            defaultScrollHeight = height;
            [self.homePageTableView beginUpdates];
            [self.homePageTableView endUpdates];
        }];
        
        [cell.contentView addSubview:bannerView];
        
        
        return cell;
    } else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BHHexColor(@"ffffff");
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 22, 16, 16)];
        image1.image = [UIImage imageNamed:@"home_Strategy follow"];
        [cell.contentView addSubview:image1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 80, 20)];
        titleLabel.text = @"策略跟随";
        titleLabel.font = UIFontMediumOfSize(17);
        titleLabel.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:titleLabel];
        
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 48, SCREEN_WIDTH - 32, 38)];
        titleLabel1.text = @"通过领先的交易跟随技术，一键跟随专业团队交易策略，投资数字货币更简单。";
        titleLabel1.numberOfLines = 0;
        titleLabel1.font = UIFontRegularOfSize(12);
        titleLabel1.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:titleLabel1];
        
        CGRect rect = [productInfoModel.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 160, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontRegularOfSize(12)} context:nil];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 94, SCREEN_WIDTH - 36, 48 + 78 + rect.size.height)];
        bgView.backgroundColor = BHHexColor(@"EDF0F2");
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4;
        [cell.contentView addSubview:bgView];
        
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 28, 32, 36)];
        if ([productInfoModel.type isEqualToString:@"日内策略"]) {
            image2.image = [UIImage imageNamed:@"ic_rinei"];
        } else if ([productInfoModel.type isEqualToString:@"中期策略"])
        {
            image2.image = [UIImage imageNamed:@"ic_zhonhqi"];
        } else
        {
            image2.image = [UIImage imageNamed:@"ic_changqi"];
        }
        
        [bgView addSubview:image2];
        
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(64, 24, SCREEN_WIDTH - 160, 20)];
        titleLabel2.text = productInfoModel.name;
        titleLabel2.font = UIFontMediumOfSize(16);
        titleLabel2.textColor = BHHexColor(@"525866");
        [bgView addSubview:titleLabel2];
        
        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(64, 48, SCREEN_WIDTH - 160, rect.size.height)];
        titleLabel3.text = productInfoModel.desc;
        titleLabel3.font = UIFontRegularOfSize(12);
        titleLabel3.alpha = 0.8;
        titleLabel3.numberOfLines = 0;
        titleLabel3.textColor = BHHexColor(@"525866");
        [bgView addSubview:titleLabel3];
        
        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 25, 24, 24)];
        bgView1.backgroundColor = [UIColor clearColor];
        bgView1.left = bgView.width - 24 - 16;
        bgView1.layer.masksToBounds = YES;
        bgView1.layer.cornerRadius = 4;
        bgView1.layer.borderWidth = 2;
        if ([productInfoModel.riskLevel integerValue] == 1) {
            bgView1.layer.borderColor = BHHexColor(@"A3D97D").CGColor;
        } else if ([productInfoModel.riskLevel integerValue] == 2)
        {
            bgView1.layer.borderColor = BHHexColor(@"FE413F").CGColor;
        } else
        {
            bgView1.layer.borderColor = BHHexColor(@"FF6B28").CGColor;
        }
        [bgView addSubview:bgView1];
        
        UILabel *titleLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        titleLabel7.textAlignment = NSTextAlignmentCenter;
        titleLabel7.text = productInfoModel.riskValue;
        titleLabel7.font = UIFontRegularOfSize(20);
        if ([productInfoModel.riskLevel integerValue] == 1) {
            titleLabel7.textColor = BHHexColor(@"A3D97D");
        } else if ([productInfoModel.riskLevel integerValue] == 2)
        {
            titleLabel7.textColor = BHHexColor(@"FE413F");
        } else
        {
            titleLabel7.textColor = BHHexColor(@"FF6B28");
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
        titleLabel6.text = @"累计收益率：";
        titleLabel6.font = UIFontRegularOfSize(14);
        titleLabel6.textColor = BHHexColor(@"626A75");
        [bgView addSubview:titleLabel6];
        
        UILabel *titleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(16, bgView2.bottom + 10, 160, 20)];
        titleLabel5.left = bgView.width - 160 - 16;
        titleLabel5.textAlignment = NSTextAlignmentRight;
        titleLabel5.font = UIFontRegularOfSize(20);
        [bgView addSubview:titleLabel5];
        
        
        if ([productInfoModel.ror integerValue] > 0) {
            titleLabel5.text = [NSString stringWithFormat:@"+%@%%",productInfoModel.ror];
            titleLabel5.textColor = BHHexColor(@"1BAC75");
        } else if ([productInfoModel.ror integerValue] < 0)
        {
            titleLabel5.text = [NSString stringWithFormat:@"%@%%",productInfoModel.ror];
            titleLabel5.textColor = BHHexColor(@"FF6B28");
        } else
        {
            titleLabel5.text = [NSString stringWithFormat:@"%@%%",productInfoModel.ror];
            titleLabel5.textColor = BHHexColor(@"292C33");
        }

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_dataSource count] > 0 && indexPath.row >= 1 && indexPath.row <= [_dataSource count])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDetail:)]) {
            HomeDesListModel *model = _dataSource[indexPath.row - 1];
            [self.delegate jumpToDetail:model];
        }
    }
    
    
    
    if (indexPath.row == [_dataSource count] + 1) {
        NSString *contentStr = descriptionModel.desc;
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        if (rect.size.height > defaultHeight) {
            _isShow = !_isShow;
            [self.homePageTableView reloadData];
        }
    }
    
   if (indexPath.row == [_dataSource count] + 5)
   {
       if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToStrategyFollow:)]) {
           [self.delegate jumpToStrategyFollow:productInfoModel.id];
       }
   }
}


@end
