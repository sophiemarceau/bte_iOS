//
//  BTEMyAccountTableView.m
//  BTE
//
//  Created by wangli on 2018/3/8.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEMyAccountTableView.h"
@implementation BTEMyAccountTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _myAccountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _myAccountTableView.backgroundColor = KBGColor;
        _myAccountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myAccountTableView.delegate = self;
        _myAccountTableView.dataSource = self;
        _myAccountTableView.bounces = NO;
        _myAccountTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_myAccountTableView];
    }
    return self;
}

//设置头部视图
- (void)setTableHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 262.5 + 48)];
    headView.backgroundColor = KBGColor;
    
//    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 162.5)];
//    bgImageView.image = [UIImage imageNamed:@"pic_account_bg"];
//    [headView addSubview:bgImageView];
    
    titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104)];
    titleBgView.backgroundColor = BHHexColor(@"1389EF");
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)BHHexColor(@"53AFFF").CGColor, (__bridge id)BHHexColor(@"1389EF").CGColor];
//    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 104);
    [titleBgView.layer addSublayer:gradientLayer];
    
    [headView addSubview:titleBgView];
    
    labelRefresh = [[UILabel alloc] initWithFrame:CGRectMake(50, -50, SCREEN_WIDTH - 100, 20)];
    labelRefresh.text = @"下拉刷新";
    labelRefresh.textAlignment = NSTextAlignmentCenter;
    labelRefresh.font = UIFontRegularOfSize(13);
    labelRefresh.textColor = BHHexColor(@"ffffff");
    labelRefresh.hidden = YES;
    [headView addSubview:labelRefresh];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 48, 31.7, 31.7)];
    iconImageView.image = [UIImage imageNamed:@"bte_logo_account"];
    [headView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, SCREEN_WIDTH - 100, 20)];
    titleLabel.text = @"我的账户";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = UIFontMediumOfSize(18);
    titleLabel.textColor = BHHexColor(@"ffffff");
    [headView addSubview:titleLabel];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:MobilePhoneNum];
    NSString *phoneString = [NSString stringWithFormat:@"%@****%@",[phoneNum substringWithRange:NSMakeRange(0,3)],[phoneNum substringWithRange:NSMakeRange(7,4)]];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(57, 56, SCREEN_WIDTH - 100, 17)];
    if (phoneNum) {
        titleLabel2.text = phoneString;
    } else
    {
        titleLabel2.text = @"*******";
    }
    
    titleLabel2.font = UIFontRegularOfSize(17);
    titleLabel2.textColor = BHHexColor(@"ffffff");
    [headView addSubview:titleLabel2];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 57, 8, 14)];
    arrowImageView.image = [UIImage imageNamed:@"arrowImageView_icon"];
    [headView addSubview:arrowImageView];
    
    UIButton *arrowButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton1.frame = CGRectMake(0, 54, SCREEN_WIDTH, 30);
//    arrowButton1.backgroundColor = [UIColor redColor];
    [arrowButton1 addTarget:self action:@selector(setButton:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:arrowButton1];
    
    
    
    
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 124)];
    whiteBgView.backgroundColor = KBGCell;
    [headView addSubview:whiteBgView];
    
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, SCREEN_WIDTH - 100, 20)];
    titleLabel1.text = @"账户可用余额";
    titleLabel1.font = UIFontMediumOfSize(14);
    titleLabel1.textColor = BHHexColor(@"626A75");
    [whiteBgView addSubview:titleLabel1];
    
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.frame = CGRectMake(SCREEN_WIDTH - 58, 10, 48, 30);
    [arrowButton setTitle:@"充值" forState:UIControlStateNormal];
    [arrowButton setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(jumpToCharge:) forControlEvents:UIControlEventTouchUpInside];
    arrowButton.titleLabel.font = UIFontRegularOfSize(14);
    [whiteBgView addSubview:arrowButton];
    if ([defaults objectForKey:MobileTradeNum] && [[defaults objectForKey:MobileTradeNum] integerValue] == 0) {
        arrowButton.hidden = YES;
    } else
    {
        arrowButton.hidden = NO;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        
        [whiteBgView addGestureRecognizer:tapGesturRecognizer];
    }
    
    _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 57, (SCREEN_WIDTH - 40) / 2, 14)];
    _detailLabel1.text = @"美元";
    _detailLabel1.alpha = 0.8;
    _detailLabel1.font = UIFontRegularOfSize(14);
    _detailLabel1.textColor = BHHexColor(@"626A75");
    [whiteBgView addSubview:_detailLabel1];
    
    UIView *vicLine = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 2) / 2, 62, 2, 32)];
    vicLine.backgroundColor = BHHexColor(@"E6EBF0");
    vicLine.alpha = 0.6;
    [whiteBgView addSubview:vicLine];
    
    _detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(vicLine.right + 25, _detailLabel1.top, _detailLabel1.width, _detailLabel1.height)];
    _detailLabel2.text = @"BTC";
    _detailLabel2.alpha = 0.8;
    _detailLabel2.font = UIFontRegularOfSize(14);
    _detailLabel2.textColor = BHHexColor(@"626A75");
    [whiteBgView addSubview:_detailLabel2];
    
    _detailLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(_detailLabel1.left, _detailLabel1.bottom + 8, _detailLabel1.width, 20)];
    if (legalAccountModel.legalBalance && [legalAccountModel.legalBalance floatValue] != 0) {
        _detailLabel3.text = [NSString stringWithFormat:@"$%@",legalAccountModel.legalBalance];
    } else
    {
        _detailLabel3.text = @"0";
    }
    _detailLabel3.font = UIFontDINAlternateOfSize(20);
    _detailLabel3.textColor = BHHexColor(@"308CDD");
    [whiteBgView addSubview:_detailLabel3];
    
    _detailLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(_detailLabel2.left, _detailLabel3.top, _detailLabel1.width, 20)];
    if (btcAccountModel.balance && [btcAccountModel.balance floatValue] != 0) {
        _detailLabel4.text = [NSString stringWithFormat:@"%@",btcAccountModel.balance];
    } else
    {
        _detailLabel4.text = @"0";
    }
    _detailLabel4.font = UIFontDINAlternateOfSize(20);
    _detailLabel4.textColor = BHHexColor(@"308CDD");
    [whiteBgView addSubview:_detailLabel4];

    UIView *headButtonWhiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height - 47, SCREEN_WIDTH, 48)];
    headButtonWhiteBgView.backgroundColor = BHHexColor(@"fafafa");
    [headView addSubview:headButtonWhiteBgView];
    
    UIView *horiLine = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height - 1, SCREEN_WIDTH, 1)];
    horiLine.backgroundColor = KBGColor;
    [headView addSubview:horiLine];
    
    
    _commitButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton1.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, 45);
    _commitButton1.tag = 101;
    [_commitButton1 setTitle:@"当前跟投份额" forState:UIControlStateNormal];
    [_commitButton1 setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
    [_commitButton1 addTarget:self action:@selector(switchButton:) forControlEvents:UIControlEventTouchUpInside];
    _commitButton1.titleLabel.font = UIFontRegularOfSize(14);
    [headButtonWhiteBgView addSubview:_commitButton1];
    
    _commitButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton2.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 45);
    _commitButton2.tag = 102;
    [_commitButton2 setTitle:@"已结束策略" forState:UIControlStateNormal];
    [_commitButton2 setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
    [_commitButton2 addTarget:self action:@selector(switchButton:) forControlEvents:UIControlEventTouchUpInside];
    _commitButton2.titleLabel.font = UIFontRegularOfSize(14);
    [headButtonWhiteBgView addSubview:_commitButton2];
    
    _lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 80, 3)];
    _lineLabel1.backgroundColor= BHHexColor(@"44A0F1");
    _lineLabel1.centerX = _commitButton1.centerX;
    [headButtonWhiteBgView addSubview:_lineLabel1];
    
    _lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 80, 3)];
    _lineLabel2.backgroundColor= BHHexColor(@"44A0F1");
    _lineLabel2.centerX = _commitButton2.centerX;
    _lineLabel2.hidden = YES;
    [headButtonWhiteBgView addSubview:_lineLabel2];
    
    
    if (type != 2) {
        [_commitButton1 setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
        [_commitButton2 setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
        _lineLabel1.hidden = NO;
        _lineLabel2.hidden = YES;
    } else
    {
        [_commitButton1 setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
        [_commitButton2 setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
        _lineLabel1.hidden = YES;
        _lineLabel2.hidden = NO;
    }
    
    
    self.myAccountTableView.tableHeaderView = headView;
}

-(void)doTapChange
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doTapChange)]) {
        [self.delegate doTapChange];
    }
}

//设置尾部视图
- (void)setTableFooterView
{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 92)];
//    headView.backgroundColor = [UIColor clearColor];
//
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, 50)];
//    bgView.backgroundColor = KBGCell;
//    [headView addSubview:bgView];
//    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    commitButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//    [commitButton setTitle:@"退出登录" forState:UIControlStateNormal];
//    [commitButton setTitleColor:BHHexColor(@"525866") forState:UIControlStateNormal];
//    [commitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
//    commitButton.titleLabel.font = UIFontRegularOfSize(16);
//    commitButton.titleLabel.alpha = 0.6;
//    [bgView addSubview:commitButton];
//
//    self.myAccountTableView.tableFooterView = headView;
}



#pragma mark - 跳转设置
- (void)setButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToSet)]) {
        [self.delegate jumpToSet];
    }
}

#pragma mark - 充值跳转
- (void)jumpToCharge:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToCharge)]) {
        [self.delegate jumpToCharge];
    }
}

#pragma mark - 退出登录
- (void)commit:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(logout)]) {
        [self.delegate logout];
    }
}
#pragma mark - 切换按钮
- (void)switchButton:(UIButton *)sender
{
    if (sender.tag == 101) {
        [_commitButton1 setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
        [_commitButton2 setTitleColor:BHHexColor(@"525866") forState:UIControlStateNormal];
        _lineLabel1.hidden = NO;
        _lineLabel2.hidden = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(switchButton:)]) {
            [self.delegate switchButton:1];
        }
    } else
    {
        [_commitButton1 setTitleColor:BHHexColor(@"525866") forState:UIControlStateNormal];
        [_commitButton2 setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
        _lineLabel1.hidden = YES;
        _lineLabel2.hidden = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(switchButton:)]) {
            [self.delegate switchButton:2];
        }
    }
}
//跳转投资详情页
-(void)jumpToDetail:(NSString *)productId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDetails:)]) {
        [self.delegate jumpToDetails:productId];
    }
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToAmount)]) {
        [self.delegate jumpToAmount];
    }
}

//刷新数据UI
-(void)refreshUi:(NSArray *)model model1:(NSString *)allAmountModel model2:(BTELegalAccount *)legalAccount model3:(BTEBtcAccount *)btcAccount model4:(BTEStatisticsModel *)statisticModel type:(NSInteger)typeValue islogin:(BOOL)islogin;
{
    _dataSource = model;
    amountModel = allAmountModel;
    legalAccountModel = legalAccount;
    btcAccountModel = btcAccount;
    statisticsModel = statisticModel;
    type = typeValue;
    _islogin = islogin;
    [self setTableHeadView];
    if (_islogin) {
        [self setTableFooterView];
    } else
    {
        self.myAccountTableView.tableFooterView = nil;
    }
    
    [self.myAccountTableView reloadData];
//    [self.myAccountTableView setContentOffset:CGPointMake(0,0)animated:YES];
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (_dataSource.count == 0) {
            return SCREEN_HEIGHT - TAB_BAR_HEIGHT - 197 - 16 - 48;
        }
        return 89;
    } else
    {
        return 146;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        if (_dataSource.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = KBGCell;
            UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 168) / 2, 60, 168, 112)];
            bgImage.image = [UIImage imageNamed:@"bte_account_bgkong"];
            [cell.contentView addSubview:bgImage];
            return cell;
        }
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 25, 80, 14)];
        label.font = UIFontRegularOfSize(12);
        label.text = @"投资额";
        label.alpha = 0.6;
        label.textColor = BHHexColor(@"626A75");
        label.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label.left, 53, label.width, label.height)];
        label1.font = UIFontDINAlternateOfSize(14);
        label1.text = [NSString stringWithFormat:@"%@BTC",statisticsModel.purchaseAmount];
        label1.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(175, label.top, label.width, label.height)];
        label2.font = UIFontRegularOfSize(12);
        if (type == 2) {
            label2.text = @"退出额";
        } else
        {
            label2.text = @"当前额";
        }
        
        label2.textAlignment = NSTextAlignmentCenter;
        label2.centerX = SCREEN_WIDTH / 2;
        label2.textColor = BHHexColor(@"626A75");
        label2.alpha = 0.6;
        label2.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label1.top, label2.width, label2.height)];
        label3.font = UIFontDINAlternateOfSize(14);
        label3.text = [NSString stringWithFormat:@"%@BTC",statisticsModel.currentAmount];
        label3.centerX = label2.centerX;
        label3.textAlignment = NSTextAlignmentCenter;
        label3.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(7, label.top, label.width, label.height)];
        label4.font = UIFontRegularOfSize(12);
        label4.text = @"收益";
        label4.textColor = BHHexColor(@"626A75");
        label4.alpha = 0.6;
        label4.right = SCREEN_WIDTH - 16;
        label4.textAlignment = NSTextAlignmentRight;
        label4.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(7, label1.top, label4.width, label4.height)];
        label5.font = UIFontDINAlternateOfSize(14);
        
        
        if ([statisticsModel.ror integerValue] > 0) {
            label5.text = [NSString stringWithFormat:@"+%@%%",statisticsModel.ror];
            label5.textColor = BHHexColor(@"228B22");
        } else if ([statisticsModel.ror integerValue] < 0)
        {
            label5.text = [NSString stringWithFormat:@"%@%%",statisticsModel.ror];
            label5.textColor = BHHexColor(@"FF6B28");
        } else
        {
            label5.text = [NSString stringWithFormat:@"%@%%",statisticsModel.ror];
            label5.textColor = BHHexColor(@"626A75");
        }
        label5.textAlignment = NSTextAlignmentRight;
        label5.right = label4.right;
        [cell.contentView addSubview:label5];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 1)];
        lineLabel.backgroundColor = kColorRgba(0, 0, 0, 0.1);
        [cell.contentView addSubview:lineLabel];
        return cell;
    } else
    {
        static NSString *CellIdentifier = @"Cell";
        BTEMyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[BTEMyAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCellWithModel:_dataSource[indexPath.row - 1]];
        cell.delegate = self;
        if (indexPath.row == _dataSource.count) {
            cell.lineView.hidden = YES;
        } else
        {
            cell.lineView.hidden = NO;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"跳转借款详情");
//    if (self.delegate && [self.delegate respondsToSelector:@selector(JumpToLoanDetails:)]) {
//        WLMyRepayMentListModel *model = _dataSource[indexPath.row];
//        [self.delegate JumpToLoanDetails:[model.id integerValue]];
//    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取偏移量
//    CGPoint offset = scrollView.contentOffset;
//    //判断是否改变
//    if (offset.y < 0) {
//        CGRect rect = titleBgView.frame;
//        //我们只需要改变图片的y值和高度即可
//        rect.origin.y = offset.y;
//        rect.size.height = 104 - offset.y;
//        titleBgView.frame = rect;
////        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, rect.size.height);
//        if (offset.y < -30) {
//            labelRefresh.hidden = NO;
//        } else
//        {
//            labelRefresh.hidden = YES;
//        }
//    } else
//    {
//        titleBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 104);
//    }
}

@end
