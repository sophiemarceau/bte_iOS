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
        [self addSubview:_myAccountTableView];
        [self setTableHeadView];
        [self setTableFooterView];
//        [self.myAccountTableView reloadData];
    }
    return self;
}

//设置头部视图
- (void)setTableHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160 + 101)];
    headView.backgroundColor = KBGColor;
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    bgImageView.image = [UIImage imageNamed:@"pic_account_bg"];
    [headView addSubview:bgImageView];
    
    labelRefresh = [[UILabel alloc] initWithFrame:CGRectMake(50, -50, SCREEN_WIDTH - 100, 20)];
    labelRefresh.text = @"下拉刷新";
    labelRefresh.textAlignment = NSTextAlignmentCenter;
    labelRefresh.font = UIFontRegularOfSize(13);
    labelRefresh.textColor = BHHexColor(@"ffffff");
    labelRefresh.hidden = YES;
    [headView addSubview:labelRefresh];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 7, 32, 32)];
    iconImageView.image = [UIImage imageNamed:@"bte_logo_account"];
    [headView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, SCREEN_WIDTH - 100, 20)];
    titleLabel.text = @"我的账户";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = UIFontRegularOfSize(18);
    titleLabel.textColor = BHHexColor(@"ffffff");
    [headView addSubview:titleLabel];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24 + 30, SCREEN_WIDTH, 14)];
    _titleLabel.text = @"账户可用余额（合计）";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = UIFontRegularOfSize(12);
    _titleLabel.textColor = BHHexColor(@"ffffff");
    [headView addSubview:_titleLabel];
    
    _subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 51 + 30, SCREEN_WIDTH, 24)];
    if (amountModel.allAmount) {
        _subTitleLabel1.text = [NSString stringWithFormat:@"$%@",amountModel.allAmount];
    } else
    {
        _subTitleLabel1.text = @"$0";
    }
    _subTitleLabel1.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel1.font = UIFontRegularOfSize(30);
    _subTitleLabel1.textColor = BHHexColor(@"ffffff");
    [headView addSubview:_subTitleLabel1];
    
    UIView *headWhiteBgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 12 * 2, 82)];
    headWhiteBgView.backgroundColor = [UIColor whiteColor];
    headWhiteBgView.centerY = bgImageView.bottom;
    headWhiteBgView.layer.masksToBounds = YES;
    headWhiteBgView.layer.cornerRadius = 5;
    [headView addSubview:headWhiteBgView];
    
    
    _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, headWhiteBgView.width / 2, 20)];
    _detailLabel1.text = @"美元";
    _detailLabel1.font = UIFontRegularOfSize(14);
    _detailLabel1.textColor = BHHexColor(@"292C33");
    _detailLabel1.textAlignment = NSTextAlignmentCenter;
    [headWhiteBgView addSubview:_detailLabel1];
    
    _detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _detailLabel1.width, 20)];
    _detailLabel2.text = @"BTC";
    _detailLabel2.left = _detailLabel1.right;
    _detailLabel2.textAlignment = NSTextAlignmentCenter;
    _detailLabel2.font = UIFontRegularOfSize(14);
    _detailLabel2.textColor = BHHexColor(@"292C33");
    [headWhiteBgView addSubview:_detailLabel2];
    
    _detailLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, _detailLabel1.width, 24)];
    if (legalAccountModel.legalBalance) {
        _detailLabel3.text = [NSString stringWithFormat:@"$%@",legalAccountModel.legalBalance];
    } else
    {
        _detailLabel3.text = @"$0";
    }
    _detailLabel3.textAlignment = NSTextAlignmentCenter;
    _detailLabel3.font = [UIFont systemFontOfSize:20];
    _detailLabel3.textColor = BHHexColor(@"44A0F1");
    [headWhiteBgView addSubview:_detailLabel3];
    
    _detailLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, _detailLabel1.width, 24)];
    if (btcAccountModel.balance) {
        _detailLabel4.text = [NSString stringWithFormat:@"%@($%@)",btcAccountModel.balance,btcAccountModel.legalBalance];
    } else
    {
        _detailLabel4.text = @"$0";
    }
    _detailLabel4.left = _detailLabel3.right;
    _detailLabel4.textAlignment = NSTextAlignmentCenter;
    _detailLabel4.font = [UIFont systemFontOfSize:20];
    _detailLabel4.textColor = BHHexColor(@"44A0F1");
    [headWhiteBgView addSubview:_detailLabel4];
    
    
    
    UIView *headButtonWhiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height - 47, SCREEN_WIDTH, 44)];
    headButtonWhiteBgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:headButtonWhiteBgView];
    
    _commitButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton1.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, 41);
    _commitButton1.tag = 101;
    [_commitButton1 setTitle:@"当前跟投份额" forState:UIControlStateNormal];
    [_commitButton1 setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
    [_commitButton1 addTarget:self action:@selector(switchButton:) forControlEvents:UIControlEventTouchUpInside];
    _commitButton1.titleLabel.font = UIFontRegularOfSize(16);
    [headButtonWhiteBgView addSubview:_commitButton1];
    
    _commitButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton2.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 41);
    _commitButton2.tag = 102;
    [_commitButton2 setTitle:@"已结束策略" forState:UIControlStateNormal];
    [_commitButton2 setTitleColor:BHHexColor(@"525866") forState:UIControlStateNormal];
    [_commitButton2 addTarget:self action:@selector(switchButton:) forControlEvents:UIControlEventTouchUpInside];
    _commitButton2.titleLabel.font = UIFontRegularOfSize(16);
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
        [_commitButton2 setTitleColor:BHHexColor(@"525866") forState:UIControlStateNormal];
        _lineLabel1.hidden = NO;
        _lineLabel2.hidden = YES;
    } else
    {
        [_commitButton1 setTitleColor:BHHexColor(@"525866") forState:UIControlStateNormal];
        [_commitButton2 setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
        _lineLabel1.hidden = YES;
        _lineLabel2.hidden = NO;
    }
    
    
    self.myAccountTableView.tableHeaderView = headView;
}

//设置尾部视图
- (void)setTableFooterView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 92)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:bgView];
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [commitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [commitButton setTitleColor:BHHexColor(@"9CA1A9") forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    commitButton.titleLabel.font = UIFontRegularOfSize(16);
    [bgView addSubview:commitButton];
    
    self.myAccountTableView.tableFooterView = headView;
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

//刷新数据UI
-(void)refreshUi:(NSArray *)model model1:(BTEAllAmountModel *)allAmountModel model2:(BTELegalAccount *)legalAccount model3:(BTEBtcAccount *)btcAccount model4:(BTEStatisticsModel *)statisticModel type:(NSInteger)typeValue;
{
    _dataSource = model;
    amountModel = allAmountModel;
    legalAccountModel = legalAccount;
    btcAccountModel = btcAccount;
    statisticsModel = statisticModel;
    type = typeValue;
    [self setTableHeadView];
    [self.myAccountTableView reloadData];
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (_dataSource.count == 0) {
            return 240;
        }
        return 78;
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
            cell.backgroundColor = BHHexColor(@"ffffff");
            UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 168) / 2, 60, 168, 112)];
            bgImage.image = [UIImage imageNamed:@"bte_account_bgkong"];
            [cell.contentView addSubview:bgImage];
            return cell;
        }
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BHHexColor(@"ffffff");
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, 80, 14)];
        label.font = UIFontRegularOfSize(12);
        label.text = @"投资额";
        label.textColor = BHHexColor(@"9CA1A9");
        label.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label.left, 46, label.width, label.height)];
        label1.font = UIFontRegularOfSize(12);
        label1.text = [NSString stringWithFormat:@"%@BTC",statisticsModel.purchaseAmount];
        label1.textColor = BHHexColor(@"292C33");
        label1.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(175, label.top, label.width, label.height)];
        label2.font = UIFontRegularOfSize(12);
        label2.text = @"当前额";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.centerX = SCREEN_WIDTH / 2;
        label2.textColor = BHHexColor(@"9CA1A9");
        label2.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label1.top, label2.width, label2.height)];
        label3.font = UIFontRegularOfSize(12);
        label3.text = [NSString stringWithFormat:@"%@BTC",statisticsModel.currentAmount];
        label3.centerX = label2.centerX;
        label3.textAlignment = NSTextAlignmentCenter;
        label3.textColor = BHHexColor(@"292C33");
        label3.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(7, label.top, label.width, label.height)];
        label4.font = UIFontRegularOfSize(12);
        label4.text = @"收益";
        label4.textColor = BHHexColor(@"9CA1A9");
        label4.right = SCREEN_WIDTH - 16;
        label4.textAlignment = NSTextAlignmentRight;
        label4.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(7, label1.top, label4.width, label4.height)];
        label5.font = UIFontRegularOfSize(12);
        
        
        if ([statisticsModel.ror integerValue] > 0) {
            label5.text = [NSString stringWithFormat:@"+%@%%",statisticsModel.ror];
            label5.textColor = BHHexColor(@"1BAC75");
        } else if ([statisticsModel.ror integerValue] < 0)
        {
            label5.text = [NSString stringWithFormat:@"%@%%",statisticsModel.ror];
            label5.textColor = BHHexColor(@"FF6B28");
        } else
        {
            label5.text = [NSString stringWithFormat:@"%@%%",statisticsModel.ror];
            label5.textColor = BHHexColor(@"292C33");
        }
        label5.textAlignment = NSTextAlignmentRight;
        label5.right = label4.right;
        label5.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label5];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 77, SCREEN_WIDTH, 1)];
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
    CGPoint offset = scrollView.contentOffset;
    //判断是否改变
    if (offset.y < 0) {
        CGRect rect = bgImageView.frame;
        //我们只需要改变图片的y值和高度即可
        rect.origin.y = offset.y;
        rect.size.height = 160 - offset.y;
        bgImageView.frame = rect;
        if (offset.y < -30) {
            labelRefresh.hidden = NO;
        } else
        {
            labelRefresh.hidden = YES;
        }
    }
}

@end
