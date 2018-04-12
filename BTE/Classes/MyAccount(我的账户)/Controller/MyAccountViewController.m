//
//  MyAccountViewController.m
//  BTE
//
//  Created by wangli on 2018/3/8.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "MyAccountViewController.h"
#import "BTEAllAmountModel.h"
#import "BTELegalAccount.h"
#import "BTEBtcAccount.h"
#import "BTEStatisticsModel.h"
#import "BTEAccountDetailsModel.h"
#import "BTEHomeWebViewController.h"
#import "BTELoginVC.h"
#import "BTESetViewController.h"
#import "BTEAmountViewController.h"
@interface MyAccountViewController ()<MyAccountTableViewDelegate,UIAlertViewDelegate>
{
    NSString *amountModel;
    BTELegalAccount *legalAccountModel;
    BTEBtcAccount *btcAccountModel;
    BTEStatisticsModel *statisticsModel;
    NSArray *detailsList;
    //设置状态栏颜色
    UIView *_statusBarView;
    BOOL _islogin;
}
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"我的账户";
    self.view.backgroundColor = KBGColor;
//    self.navigationItem.leftBarButtonItem = [self createLeftBarItem];
    
    if (self.myAccountTableView == nil) {
        self.myAccountTableView = [[BTEMyAccountTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT)];
        self.myAccountTableView.delegate = self;
    }
    
    [self.view addSubview:self.myAccountTableView];
    //初始化为0
    self.isloginAndGetMyAccountInfo = @"0";
}


- (void)getMyAccountLoginStatus
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetUserLoginInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 0) {//未登录
            _islogin = NO;
            //刷新tableview
            [weakSelf.myAccountTableView refreshUi:nil model1:nil model2:nil model3:nil model4:nil type:1 islogin:_islogin];
            
            WS(weakSelf)
            [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                if (isComplete) {
                    //登录成功刷新我的账户页面
                    //获取账户基本信息
                    _islogin = YES;
                    [weakSelf getMyAccountInfo];
                } else
                {
                    [weakSelf.tabBarController setSelectedIndex:0];
                }
            }];
            
        } else if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 1)//已登录
        {
            //获取账户基本信息
            _islogin = YES;
            [weakSelf getMyAccountInfo];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
    }];
}

-(void)doTapChange
{
    WS(weakSelf)
    [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
        if (isComplete) {
            //登录成功刷新我的账户页面
            //获取账户基本信息
            _islogin = YES;
            [weakSelf getMyAccountInfo];
        } else
        {
//            [weakSelf.tabBarController setSelectedIndex:0];
        }
    }];

}
-(void)jumpToAmount
{
    BTEAmountViewController *amountVc = [[BTEAmountViewController alloc] init];
    amountVc.balance = btcAccountModel.balance;
    amountVc.legalBalance = legalAccountModel.legalBalance;
    [self.navigationController pushViewController:amountVc animated:YES];
}

//当前跟投 已结束策略 按钮切换事件
-(void)switchButton:(NSInteger)type//type 1 当前跟投 2 已结束策略
{
    if (User.userToken) {
        if (type == 1) {
            [self getMyAccountCurrentInfo];
        } else
        {
            [self getMyAccountSettleInfo];
        }
    }
}
-(void)logout//退出登录
{
    NSString *message = NSLocalizedString(@"确定要退出登录吗？",nil);
//    NSString *title = @"提示";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    //改变title的大小和颜色
//    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:title];
//    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
//    [titleAtt addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, title.length)];
//    [alertController setValue:titleAtt forKey:@"attributedTitle"];
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
            weakSelf.isloginAndGetMyAccountInfo = @"0";
            
            //退出成功删除手机号
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:MobilePhoneNum];
            //删除本地登录信息
            [User removeLoginData];
            //发送通知告诉web token变动
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
            [weakSelf.tabBarController setSelectedIndex:0];
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
        }];
    }];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"确定要退出登录吗？" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
//    [alertview show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//继续播放
    {
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        methodName = kAcountUserLogout;
        
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NMRemovLoadIng;
            weakSelf.isloginAndGetMyAccountInfo = @"0";
            
            //退出成功删除手机号
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:MobilePhoneNum];
            //删除本地登录信息
            [User removeLoginData];
            //发送通知告诉web token变动
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
            [weakSelf.tabBarController setSelectedIndex:0];
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
        }];
    }
}


//跳转投资详情
-(void)jumpToDetails:(NSString *)productId
{
    BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
    
    homePageVc.urlString = [NSString stringWithFormat:@"%@/%@",kAppStrategyAddress,productId];
    homePageVc.isHiddenLeft = YES;
    homePageVc.isHiddenBottom = NO;
    [self.navigationController pushViewController:homePageVc animated:YES];
}

#pragma mark -获取账户基本信息
- (void)getMyAccountInfo
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:User.userToken forKey:@"bte-token"];
    methodName = kAcountInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    self.isloginAndGetMyAccountInfo = @"1";
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        //登录成功并获取到了账户信息
        self.isloginAndGetMyAccountInfo = @"1";
        legalAccountModel = [BTELegalAccount yy_modelWithDictionary:responseObject[@"data"][@"legalAccount"]];
        btcAccountModel = [BTEBtcAccount yy_modelWithDictionary:responseObject[@"data"][@"btcAccount"]];
        [weakSelf getMyAccountCurrentInfo];
//        [weakSelf getMyAccountCurrentPhone];
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        self.isloginAndGetMyAccountInfo = @"0";
        RequestError(error);
    }];
}
#pragma mark -获取当前跟投份额信息
- (void)getMyAccountCurrentInfo
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken && ![User.userToken isEqualToString:@""]) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    } else
    {
        return;
    }
    methodName = kAcountHoldInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        statisticsModel = [BTEStatisticsModel yy_modelWithDictionary:responseObject[@"data"][@"statistics"]];
        detailsList = [NSArray yy_modelArrayWithClass:[BTEAccountDetailsModel class] json:responseObject[@"data"][@"details"]];
        //刷新tableview
        [weakSelf.myAccountTableView refreshUi:detailsList model1:amountModel model2:legalAccountModel model3:btcAccountModel model4:statisticsModel type:1 islogin:_islogin];
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
    }];
}

#pragma mark -获取当前账户电话号码
- (void)getMyAccountCurrentPhone
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken && ![User.userToken isEqualToString:@""]) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    } else
    {
        return;
    }
    methodName = kAcountPhoneNum;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        NSLog(@"-----------%@",responseObject[@"data"][@"tel"]);
        amountModel = responseObject[@"data"][@"tel"];
        //刷新tableview
        [weakSelf.myAccountTableView refreshUi:detailsList model1:amountModel model2:legalAccountModel model3:btcAccountModel model4:statisticsModel type:1 islogin:_islogin];
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
    }];
}

#pragma mark -获取当前跟投份额信息
- (void)getMyAccountSettleInfo
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kAcountSettleInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        statisticsModel = [BTEStatisticsModel yy_modelWithDictionary:responseObject[@"data"][@"statistics"]];
        detailsList = [NSArray yy_modelArrayWithClass:[BTEAccountDetailsModel class] json:responseObject[@"data"][@"details"]];
        //刷新tableview
        [weakSelf.myAccountTableView refreshUi:detailsList model1:amountModel model2:legalAccountModel model3:btcAccountModel model4:statisticsModel type:2 islogin:_islogin];
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
    }];
}


//- (UIBarButtonItem *)createLeftBarItem{
//    UIImage * image = [UIImage imageNamed:@"nav_back"];
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:image forState:UIControlStateNormal];
//    [btn setImage:image forState:UIControlStateHighlighted];
//    btn.bounds = CGRectMake(0, 0, 60, 40);
//    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, - btn.width + MIN(image.size.width, 14), 0, 0);
//    return [[UIBarButtonItem alloc]initWithCustomView:btn];
//}
//返回
//-(void)backAction:(UIBarButtonItem *)sender {
//    if (self.callRefreshBlock) {
//        self.callRefreshBlock();
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)jumpToSet
{
    BTESetViewController *setVc = [[BTESetViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}

-(void)jumpToCharge
{
    BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
    homePageVc.urlString = kApprechargeAddress;
    homePageVc.isHiddenLeft = YES;
    homePageVc.isHiddenBottom = NO;
    [self.navigationController pushViewController:homePageVc animated:YES];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:MobilePhoneNum];
    if ([self.isloginAndGetMyAccountInfo isEqualToString:@"0"]) {
        //获取登录状态
        [self getMyAccountLoginStatus];
    } else if ([self.isloginAndGetMyAccountInfo isEqualToString:@"1"] && phoneNum == nil)//退出登录处理
    {
        self.isloginAndGetMyAccountInfo = @"0";
        [self.tabBarController setSelectedIndex:0];
    }
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
