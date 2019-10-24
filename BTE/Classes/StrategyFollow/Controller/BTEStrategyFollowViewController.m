//
//  BTEStrategyFollowViewController.m
//  BTE
//
//  Created by wangli on 2018/3/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEStrategyFollowViewController.h"
#import "HomeProductInfoModel.h"
#import "SecondaryLevelWebViewController.h"
//#import "SecondLevelWebViewController.h"
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
    self.navigationItem.title = @"策略服务";
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
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
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
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)jumpToDetail:(HomeProductInfoModel *)model
{
    SecondaryLevelWebViewController *strategyDetail= [[SecondaryLevelWebViewController alloc] init];
    
    strategyDetail.urlString = [NSString stringWithFormat:@"%@%@",kAppStrategyAddress,model.id];
    strategyDetail.isHiddenLeft = YES;
    strategyDetail.isHiddenBottom = YES;
    strategyDetail.productInfoModel = model;
    [self.navigationController pushViewController:strategyDetail animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 强制显示tabbar
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
}

-(void)viewDidDisappear:(BOOL)animated{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
