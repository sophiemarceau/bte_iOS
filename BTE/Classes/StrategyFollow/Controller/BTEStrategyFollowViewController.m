//
//  BTEStrategyFollowViewController.m
//  BTE
//
//  Created by wangli on 2018/3/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEStrategyFollowViewController.h"
#import "HomeProductInfoModel.h"
#import "BTEHomeWebViewController.h"
@interface BTEStrategyFollowViewController ()
{
    NSInteger pageNo;
    NSMutableArray *dataArray;
}
@end

@implementation BTEStrategyFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"策略跟随";
    dataArray = [[NSMutableArray alloc] init];
    if (self.strategyFollowTableView == nil) {
        self.strategyFollowTableView = [[BTEStrategyFollowTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_HEIGHT)];
                self.strategyFollowTableView.delegate = self;
//        self.strategyFollowTableView.strategyFollowTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        }];
        pageNo = 0;
        WS(weakSelf)
        self.strategyFollowTableView.strategyFollowTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf getMoreData];
        }];
    }
    
    [self.view addSubview:self.strategyFollowTableView];
    
    //获取最新的策略列表
    [self getlatestsStrategyList];
}

#pragma mark - 上拉加载更多
- (void)getMoreData
{
    pageNo++;
    [self getlatestsStrategyList];
}

-(void)getlatestsStrategyList
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:[NSNumber numberWithInteger:pageNo] forKey:@"pageNo"];
    methodName = kGetlatestProductList;
    
    WS(weakSelf)
    [self hudShow:self.view msg:@"请稍后"];
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        if (IsSafeDictionary(responseObject)) {
           NSArray *productList = [NSArray yy_modelArrayWithClass:[HomeProductInfoModel class] json:responseObject[@"data"][@"details"]];
            [dataArray addObjectsFromArray:productList];
            [weakSelf.strategyFollowTableView refreshUi:dataArray];
            
            if ([responseObject[@"data"][@"nextPage"] integerValue] == -1) {
                [weakSelf.strategyFollowTableView.strategyFollowTableView.mj_footer endRefreshingWithNoMoreData];
            } else
            {
                [weakSelf.strategyFollowTableView.strategyFollowTableView.mj_footer endRefreshing];
            }
            
        }
    } failure:^(NSError *error) {
        [weakSelf.strategyFollowTableView.strategyFollowTableView.mj_footer endRefreshing];
        [weakSelf hudClose];
        RequestError(error);
    }];
}

- (void)jumpToDetail:(HomeProductInfoModel *)model
{
    BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
    
    homePageVc.urlString = [NSString stringWithFormat:@"%@/%@",kAppStrategyAddress,model.id];
    homePageVc.isHiddenLeft = YES;
    homePageVc.isHiddenBottom = NO;
    homePageVc.productInfoModel = model;
    [self.navigationController pushViewController:homePageVc animated:YES];
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
