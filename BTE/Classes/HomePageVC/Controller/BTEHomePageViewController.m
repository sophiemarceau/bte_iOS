//
//  BTEHomePageViewController.m
//  BTE
//
//  Created by wangli on 2018/1/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEHomePageViewController.h"
#import "BTEShareView.h"
#import "HomeDescriptionModel.h"
#import "HomeDesListModel.h"
#import "HomeProductModel.h"
#import "HomeProductInfoModel.h"
#import "BTEHomeWebViewController.h"
@interface BTEHomePageViewController ()
{
    HomeDescriptionModel *descriptionModel;
    NSArray *detailsList;
    NSArray *productList;
    HomeProductInfoModel *productInfoModel;
}
//分享需要的参数
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;
@property (nonatomic, copy) ShareViewCallBack shareViewCallBack;
@end

@implementation BTEHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"比特易";
    self.navigationItem.rightBarButtonItem = [self creatRightBarItem];
    self.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
    self.sharetitle = @"比特易-领先的数字货币市场专业分析平台";
    self.shareDesc = @"玩转比特币，多看比特易，聪明的投资者都在这里！";
    self.shareUrl = kAppBTEH5AnalyzeAddress;
    
    if (self.homePageTableView == nil) {
        self.homePageTableView = [[BTEHomePageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_HEIGHT)];
        self.homePageTableView.delegate = self;
    }
    
    [self.view addSubview:self.homePageTableView];
    
    //获取最新的推荐列表
    [self getlatestsStatus];
    
}
#pragma mark - 获取最新的推荐列表
- (void)getlatestsStatus
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetlatestInfo;
    
    WS(weakSelf)
    [self hudShow:self.view msg:@"请稍后"];
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        if (IsSafeDictionary(responseObject)) {
            HomeDescriptionModel *descModel = [[HomeDescriptionModel alloc] init];
            descModel.desc = responseObject[@"data"][@"description"];
            descriptionModel = descModel;
            detailsList = [NSArray yy_modelArrayWithClass:[HomeDesListModel class] json:responseObject[@"data"][@"list"]];
            [weakSelf getlatestsNews];
        }
    } failure:^(NSError *error) {
        [weakSelf hudClose];
        RequestError(error);
    }];
}

//获取最近的10条新闻快讯
- (void)getlatestsNews
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetlatestNewsInfo;
    
    WS(weakSelf)
    [self hudShow:self.view msg:@"请稍后"];
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        if (IsSafeDictionary(responseObject)) {
            productList = [NSArray yy_modelArrayWithClass:[HomeProductModel class] json:responseObject[@"data"]];
            [weakSelf getlatestsProduct];
        }
    } failure:^(NSError *error) {
        [weakSelf hudClose];
        RequestError(error);
    }];
}

//获取首页策略信息
- (void)getlatestsProduct
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetlatestProductInfo;
    
    WS(weakSelf)
    [self hudShow:self.view msg:@"请稍后"];
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        if (IsSafeDictionary(responseObject)) {
            productInfoModel = [HomeProductInfoModel yy_modelWithDictionary:responseObject[@"data"]];
            //刷新tableview
            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModel];
        }
    } failure:^(NSError *error) {
        [weakSelf hudClose];
        RequestError(error);
    }];
}

- (void)jumpToDetail:(NSString *)name
{
    BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
    
    homePageVc.urlString = [NSString stringWithFormat:@"%@/%@",kAppDealAddress,name];
    homePageVc.isHiddenLeft = YES;
    homePageVc.isHiddenBottom = NO;
    [self.navigationController pushViewController:homePageVc animated:YES];
}


#pragma mark - 分享
- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"share_button_image"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (void)shareAlert
{
    [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"AppIcon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
