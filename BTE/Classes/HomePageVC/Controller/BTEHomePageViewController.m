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
#import "BTECurrencyTypePickerView.h"
#import "BTELeftView.h"
@interface BTEHomePageViewController ()
{
    HomeDescriptionModel *descriptionModel;
    NSArray *detailsList;
    NSArray *productList;
    HomeProductInfoModel *productInfoModel;
    NSString *currentCurrencyType;//记录当前展示币种
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
    [self customtitleView];
    self.navigationItem.rightBarButtonItem = [self creatRightBarItem];
    self.navigationItem.leftBarButtonItem = [self creatLeftBarItem];
    self.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
    self.sharetitle = @"比特易—数字货币分析平台";
    self.shareDesc = @"比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，玩转比特币，多看比特易。";
    self.shareUrl = kAppBTEH5AnalyzeAddress;
    
    if (self.homePageTableView == nil) {
        self.homePageTableView = [[BTEHomePageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_HEIGHT)];
        self.homePageTableView.delegate = self;
    }
    
    [self.view addSubview:self.homePageTableView];
    
    //获取最新的推荐列表
    [self getlatestsStatus];
    [self getlatestsNews];
    [self getlatestsProduct];
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
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            HomeDescriptionModel *descModel = [[HomeDescriptionModel alloc] init];
            descModel.desc = responseObject[@"data"][@"description"];
            descriptionModel = descModel;
            detailsList = [NSArray yy_modelArrayWithClass:[HomeDesListModel class] json:responseObject[@"data"][@"list"]];
            //刷新tableview
            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModel currentCurrencyType:currentCurrencyType];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
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
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            productList = [NSArray yy_modelArrayWithClass:[HomeProductModel class] json:responseObject[@"data"]];
            //刷新tableview
            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModel currentCurrencyType:currentCurrencyType];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
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
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            productInfoModel = [HomeProductInfoModel yy_modelWithDictionary:responseObject[@"data"]];
            //刷新tableview
            [weakSelf.homePageTableView refreshUi:detailsList productList:productList model1:descriptionModel model2:productInfoModel currentCurrencyType:currentCurrencyType];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
    }];
}

- (void)jumpToDetail:(HomeDesListModel *)model
{
    BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
    
    homePageVc.urlString = [NSString stringWithFormat:@"%@/%@",kAppDealAddress,model.symbol];
    homePageVc.isHiddenLeft = YES;
    homePageVc.isHiddenBottom = NO;
    homePageVc.desListModel = model;
    [self.navigationController pushViewController:homePageVc animated:YES];
}

- (void)jumpToStrategyFollow:(NSString *)productId
{
    BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
    
    homePageVc.urlString = [NSString stringWithFormat:@"%@/%@",kAppStrategyAddress,productId];
    homePageVc.isHiddenLeft = YES;
    homePageVc.isHiddenBottom = NO;
    [self.navigationController pushViewController:homePageVc animated:YES];
}

- (void)doTapChange:(NSString *)name//选择币种
{
    WS(weakSelf)
    [BTECurrencyTypePickerView provincePickerViewWithArray:detailsList WithProvince:name ProvinceBlock:^(NSInteger rowIndex) {
        //获取最新的推荐列表
        HomeDesListModel *tempModel = detailsList[rowIndex];
        currentCurrencyType = tempModel.symbol;
        [weakSelf getlatestsStatus];
    }];
}

#pragma mark - 分享
- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"share_button_image"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (UIBarButtonItem *)creatLeftBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"share_button_image"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(showLeftView)];
    return leftItem;
}

- (void)shareAlert
{
    [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"AppIcon"] shareUrl:self.shareUrl sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self];
}

- (void)showLeftView
{
    [BTELeftView popActivateNowCallBack:nil cancelCallBack:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
