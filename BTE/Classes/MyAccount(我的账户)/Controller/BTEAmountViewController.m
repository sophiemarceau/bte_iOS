//
//  BTEAmountViewController.m
//  BTE
//
//  Created by wangli on 2018/4/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEAmountViewController.h"
#import "BTEHomeWebViewController.h"
@interface BTEAmountViewController ()
{
    //设置状态栏颜色
    UIView *_statusBarView;
}
@end

@implementation BTEAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KBGColor;
    _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _setTableView.backgroundColor = KBGColor;
    _setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    _setTableView.bounces = NO;
    _setTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_setTableView];
    [self setTableHeadView];
    [self setTableFooterView];
}
//设置头部视图
- (void)setTableHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    headView.backgroundColor = KBGColor;
    
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    bgImage.image = [UIImage imageNamed:@"pic_account_bg"];
    bgImage.userInteractionEnabled = YES;
    [headView addSubview:bgImage];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(0, 0, 45, 44);
    [commitButton setImage:[UIImage imageNamed:@"Image_back_white"] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    [bgImage addSubview:commitButton];
    
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, 13, 200, 18)];
    titleLabel1.text = @"账户可用余额";
    titleLabel1.font = UIFontRegularOfSize(18);
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor = BHHexColor(@"ffffff");
    [bgImage addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 50, SCREEN_WIDTH - 100, 16)];
    titleLabel2.text = @"账户可用余额";
    titleLabel2.font = UIFontRegularOfSize(16);
    titleLabel2.textColor = BHHexColor(@"ffffff");
    [bgImage addSubview:titleLabel2];
    
    _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 100, 100, 14)];
    _detailLabel1.text = @"美元";
    _detailLabel1.font = UIFontRegularOfSize(14);
    _detailLabel1.textColor = BHHexColor(@"ffffff");
    [bgImage addSubview:_detailLabel1];
    
    UIView *vicLine = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 2) / 2, 115, 2, 32)];
    vicLine.backgroundColor = BHHexColor(@"E6EBF0");
    vicLine.alpha = 0.6;
    [bgImage addSubview:vicLine];
    
    _detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(vicLine.right + 25, _detailLabel1.top, _detailLabel1.width, _detailLabel1.height)];
    _detailLabel2.text = @"BTC";
    _detailLabel2.font = UIFontRegularOfSize(14);
    _detailLabel2.textColor = BHHexColor(@"ffffff");
    [bgImage addSubview:_detailLabel2];
    
    _detailLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(_detailLabel1.left, _detailLabel1.bottom + 8, _detailLabel1.width, 20)];
    if (self.legalBalance && [self.legalBalance floatValue] != 0) {
        _detailLabel3.text = [NSString stringWithFormat:@"$%@",self.legalBalance];
    } else
    {
        _detailLabel3.text = @"0";
    }
    _detailLabel3.font = [UIFont systemFontOfSize:20];
    _detailLabel3.textColor = BHHexColor(@"ffffff");
    [bgImage addSubview:_detailLabel3];
    
    _detailLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(_detailLabel2.left, _detailLabel3.top, _detailLabel1.width, 20)];
    if (self.balance && [self.balance floatValue] != 0) {
        _detailLabel4.text = [NSString stringWithFormat:@"%@",self.balance];
    } else
    {
        _detailLabel4.text = @"0";
    }
    _detailLabel4.font = [UIFont systemFontOfSize:20];
    _detailLabel4.textColor = BHHexColor(@"ffffff");
    [bgImage addSubview:_detailLabel4];
    
    self.setTableView.tableHeaderView = headView;
}

//设置尾部视图
- (void)setTableFooterView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 15, 15)];
    bgImage.image = [UIImage imageNamed:@"prompt_account_amount"];
    bgImage.userInteractionEnabled = YES;
    [headView addSubview:bgImage];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(39, 22, 200, 12)];
    titleLabel1.text = @"目前仅支持BTC ,详情可咨询客服电话";
    titleLabel1.font = UIFontRegularOfSize(12);
    titleLabel1.alpha = 0.5;
    titleLabel1.textColor = BHHexColor(@"626A75");
    [headView addSubview:titleLabel1];
    
    self.setTableView.tableFooterView = headView;
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 14, 80, 16)];
        label.font = UIFontRegularOfSize(16);
        label.text = @"充值";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 14, 22, 16)];
        titleImage.image = [UIImage imageNamed:@"recharge_amount"];
        [cell.contentView addSubview:titleImage];
        
        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
        [cell.contentView addSubview:arrImage];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 43, SCREEN_WIDTH - 16 * 2, 1)];
//        lineView.backgroundColor = BHHexColor(@"E6EBF0");
//        [cell.contentView addSubview:lineView];
        return cell;
    } else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 14, 80, 16)];
        label.font = UIFontRegularOfSize(16);
        label.text = @"提现";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 14, 22, 16)];
        titleImage.image = [UIImage imageNamed:@"withdraw_deposit"];
        [cell.contentView addSubview:titleImage];
        
        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
        [cell.contentView addSubview:arrImage];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 43, SCREEN_WIDTH - 16 * 2, 1)];
//        lineView.backgroundColor = BHHexColor(@"E6EBF0");
//        [cell.contentView addSubview:lineView];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
        homePageVc.urlString = kApprechargeAddress;
        homePageVc.isHiddenLeft = YES;
        homePageVc.isHiddenBottom = NO;
        [self.navigationController pushViewController:homePageVc animated:YES];
    } else if (indexPath.row == 1)
    {
      
    }
}

- (void)backEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //设置状态栏颜色
    _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    self.view.bounds.size.width, 20)];
    _statusBarView.backgroundColor = [BHHexColor hexColor:@"53AFFF"];
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)BHHexColor(@"53AFFF").CGColor, (__bridge id)BHHexColor(@"1389EF").CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [_statusBarView.layer addSublayer:gradientLayer];
    [self.view addSubview:_statusBarView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_statusBarView removeFromSuperview];
    
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
