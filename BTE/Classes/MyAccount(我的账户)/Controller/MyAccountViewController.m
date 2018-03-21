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
@interface MyAccountViewController ()<MyAccountTableViewDelegate,UIAlertViewDelegate>
{
    BTEAllAmountModel *amountModel;
    BTELegalAccount *legalAccountModel;
    BTEBtcAccount *btcAccountModel;
    BTEStatisticsModel *statisticsModel;
    //设置状态栏颜色
    UIView *_statusBarView;
}
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"我的账户";
    self.view.backgroundColor = [UIColor whiteColor];
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
    [self hudShow:self.view msg:@"请稍后"];
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 0) {//未登录
            [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                if (isComplete) {
                    //登录成功刷新我的账户页面
                    //获取账户基本信息
                    [weakSelf getMyAccountInfo];
                } else
                {
                    [self.tabBarController setSelectedIndex:0];
                }
            }];
        } else if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 1)//已登录
        {
            //获取账户基本信息
            [self getMyAccountInfo];
        }
    } failure:^(NSError *error) {
        [weakSelf hudClose];
        RequestError(error);
    }];
}




//当前跟投 已结束策略 按钮切换事件
-(void)switchButton:(NSInteger)type//type 1 当前跟投 2 已结束策略
{
    if (type == 1) {
        [self getMyAccountCurrentInfo];
    } else
    {
        [self getMyAccountSettleInfo];
    }
}
-(void)logout//退出登录
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"你确定要退出登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    [alertview show];
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
        [self hudShow:self.view msg:@"请稍后"];
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            [weakSelf hudClose];
            self.isloginAndGetMyAccountInfo = @"0";
            //删除本地登录信息
            [User removeLoginData];
            //发送通知告诉web token变动
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
            [self.tabBarController setSelectedIndex:0];
        } failure:^(NSError *error) {
            [weakSelf hudClose];
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
    [self hudShow:self.view msg:@"请稍后"];
    self.isloginAndGetMyAccountInfo = @"1";
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        //登录成功并获取到了账户信息
        self.isloginAndGetMyAccountInfo = @"1";
        amountModel = [BTEAllAmountModel yy_modelWithDictionary:responseObject[@"data"]];
        legalAccountModel = [BTELegalAccount yy_modelWithDictionary:responseObject[@"data"][@"legalAccount"]];
        btcAccountModel = [BTEBtcAccount yy_modelWithDictionary:responseObject[@"data"][@"btcAccount"]];
        [weakSelf getMyAccountCurrentInfo];
    } failure:^(NSError *error) {
        [weakSelf hudClose];
        self.isloginAndGetMyAccountInfo = @"0";
        RequestError(error);
    }];
}
#pragma mark -获取当前跟投份额信息
- (void)getMyAccountCurrentInfo
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:User.userToken forKey:@"bte-token"];
    methodName = kAcountHoldInfo;
    
    WS(weakSelf)
    [self hudShow:self.view msg:@"请稍后"];
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        statisticsModel = [BTEStatisticsModel yy_modelWithDictionary:responseObject[@"data"][@"statistics"]];
        NSArray *detailsList = [NSArray yy_modelArrayWithClass:[BTEAccountDetailsModel class] json:responseObject[@"data"][@"details"]];
        //刷新tableview
        [weakSelf.myAccountTableView refreshUi:detailsList model1:amountModel model2:legalAccountModel model3:btcAccountModel model4:statisticsModel type:1];
    } failure:^(NSError *error) {
        [weakSelf hudClose];
        RequestError(error);
    }];
}

#pragma mark -获取当前跟投份额信息
- (void)getMyAccountSettleInfo
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:User.userToken forKey:@"bte-token"];
    methodName = kAcountSettleInfo;
    
    WS(weakSelf)
    [self hudShow:self.view msg:@"请稍后"];
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        statisticsModel = [BTEStatisticsModel yy_modelWithDictionary:responseObject[@"data"][@"statistics"]];
        NSArray *detailsList = [NSArray yy_modelArrayWithClass:[BTEAccountDetailsModel class] json:responseObject[@"data"][@"details"]];
        //刷新tableview
        [weakSelf.myAccountTableView refreshUi:detailsList model1:amountModel model2:legalAccountModel model3:btcAccountModel model4:statisticsModel type:2];
    } failure:^(NSError *error) {
        [weakSelf hudClose];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //设置状态栏颜色
    _statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    self.view.bounds.size.width, 20)];
    _statusBarView.backgroundColor = [BHHexColor hexColor:@"63B0F3"];
    [self.view addSubview:_statusBarView];

    if ([self.isloginAndGetMyAccountInfo isEqualToString:@"0"]) {
        //获取登录状态
        [self getMyAccountLoginStatus];
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
