//
//  BTESetViewController.m
//  BTE
//
//  Created by wangli on 2018/4/10.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTESetViewController.h"
#import "WLActivateAlertView.h"
#import "BTEInviteFriendViewController.h"
@interface BTESetViewController ()

@end

@implementation BTESetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGColor;
    self.title = @"设置";
    
    _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT) style:UITableViewStylePlain];
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
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
    headView.backgroundColor = KBGColor;
    self.setTableView.tableHeaderView = headView;
}

//设置尾部视图
- (void)setTableFooterView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 92)];
    headView.backgroundColor = [UIColor clearColor];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = KBGCell;
    [headView addSubview:bgView];
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [commitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [commitButton setTitleColor:BHHexColor(@"525866") forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    commitButton.titleLabel.font = UIFontRegularOfSize(16);
    commitButton.titleLabel.alpha = 0.6;
    [bgView addSubview:commitButton];

    self.setTableView.tableFooterView = headView;
}

#pragma mark - 退出登录
-(void)logout//退出登录
{
    NSString *message = NSLocalizedString(@"确定要退出登录吗？",nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //改变message的大小和颜色
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
    [messageAtt addAttribute:NSFontAttributeName value:UIFontRegularOfSize(14) range:NSMakeRange(0, message.length)];
    [messageAtt addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"626A75") range:NSMakeRange(0, message.length)];
    [alertController setValue:messageAtt forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        methodName = kAcountUserLogout;
        
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NMRemovLoadIng;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:MobilePhoneNum];
            //删除本地登录信息
            [User removeLoginData];
            //发送通知告诉web token变动
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
            [weakSelf.navigationController popViewControllerAnimated:NO];
            
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
        }];
    }];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 80, 16)];
        label.font = UIFontRegularOfSize(16);
        label.text = @"关注微信";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 16 - 8 - 16, 15, 120, 14)];
        label1.font = UIFontRegularOfSize(14);
        label1.text = @"bte-top";
        label1.textAlignment = NSTextAlignmentRight;
        label1.alpha = 0.5;
        label1.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label1];
        
        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
        [cell.contentView addSubview:arrImage];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 43, SCREEN_WIDTH - 16 * 2, 1)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        return cell;
    } else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 80, 16)];
        label.font = UIFontRegularOfSize(16);
        label.text = @"邀请好友";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 16 - 8 - 16, 15, 120, 14)];
//        label1.font = UIFontRegularOfSize(14);
//        label1.text = @"bte-top";
//        label1.textAlignment = NSTextAlignmentRight;
//        label1.alpha = 0.5;
//        label1.textColor = BHHexColor(@"626A75");
//        [cell.contentView addSubview:label1];
        
        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
        [cell.contentView addSubview:arrImage];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 43, SCREEN_WIDTH - 16 * 2, 1)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        return cell;
    }else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 80, 16)];
        label.font = UIFontRegularOfSize(16);
        label.text = @"客服电话";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 16 - 8 - 16, 15, 120, 14)];
        label1.font = UIFontRegularOfSize(14);
        label1.text = @"010-85112088";
        label1.textAlignment = NSTextAlignmentRight;
        label1.alpha = 0.5;
        label1.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label1];
        
        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
        [cell.contentView addSubview:arrImage];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 43, SCREEN_WIDTH - 16 * 2, 1)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        return cell;
    }else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 80, 16)];
        label.font = UIFontRegularOfSize(16);
        label.text = @"当前版本";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 16, 15, 120, 14)];
        label1.font = UIFontRegularOfSize(14);
        label1.text = [NSString stringWithFormat:@"v%@",kCurrentVersion];
        label1.textAlignment = NSTextAlignmentRight;
        label1.alpha = 0.5;
        label1.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label1];
        
//        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
//        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
//        [cell.contentView addSubview:arrImage];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"bte-top";
        [WLActivateAlertView popActivateNowCallBack:^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
            } else
            {
                [BHToast showMessage:@"您还未安装微信！"];
            }
        } cancelCallBack:^{
           
        }];

    } else if (indexPath.row == 1)
    {
        BTEInviteFriendViewController *invateVc = [[BTEInviteFriendViewController alloc] init];
        [self.navigationController pushViewController:invateVc animated:YES];
    }else if (indexPath.row == 2)
    {
        NSString *telNum = [NSString stringWithFormat:@"tel://01085112088"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
