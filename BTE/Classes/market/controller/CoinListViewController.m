//
//  CoinListViewController.m
//  BTE
//
//  Created by sophie on 2018/11/7.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "CoinListViewController.h"
#import "HotTableViewCell.h"
#import "menuVIew.h"
#import "CoinTableViewCell.h"
#import "BTESortView.h"
/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,sortType) {
    /**
     *  涨幅榜
     */
    changeAscType = 1,
    /**
     *  跌幅榜📉
     */
    changeDescType = 2,
    /**
     *  资金流入
     */
    moneyIncomeType = 3,
    
    /**
     *  资金流出
     */
    moneyOutGoType = 4,
    
};
@interface CoinListViewController ()<UITableViewDelegate,UITableViewDataSource,menuViewDelegate>{
    int current_page,total_count;
    sortType flagIndex;
}
@property (nonatomic, strong) menuVIew *menuSelectView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *listView;
@end
@implementation CoinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"币种列表";
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    [self initSubviews];
    flagIndex = changeAscType;
    [self requestData];
}

-(void)requestData{
    current_page = 0;
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:@"0" forKey:@"pageNo"];
    if (flagIndex == changeAscType) {
        [pramaDic setObject:@"10" forKey:@"pageSize"];
        [pramaDic setObject:@"change" forKey:@"sort"];
        [pramaDic setObject:@"desc" forKey:@"sortType"];
        [pramaDic setObject:@"" forKey:@"exchange"];
        methodName = kCoinList;
    }
    if (flagIndex == changeDescType) {
        [pramaDic setObject:@"10" forKey:@"pageSize"];
        [pramaDic setObject:@"change" forKey:@"sort"];
        [pramaDic setObject:@"asc" forKey:@"sortType"];
        [pramaDic setObject:@"" forKey:@"exchange"];
        methodName = kCoinList;
    }
    // 资金流入流出排名 desc 资金流流入 asc 资金流流出
    if (flagIndex == moneyIncomeType) {
        [pramaDic setObject:@"10" forKey:@"size"];
        [pramaDic setObject:@"desc" forKey:@"sort"];
        methodName = TradeFlowRank;
    }
    // 资金流入流出排名 desc 资金流流入 asc 资金流流出
    if (flagIndex == moneyOutGoType) {
       
        [pramaDic setObject:@"10" forKey:@"size"];
        [pramaDic setObject:@"asc" forKey:@"sort"];
        methodName = TradeFlowRank;
    }
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypePost success:^(id responseObject) {
        [self.listView.mj_header endRefreshing];
        [self.listView.mj_footer endRefreshing];
        NMRemovLoadIng;
        NSLog(@"methodName----->%@------->%@",methodName,responseObject);
        if (IsSafeDictionary(responseObject)) {
            int nextPage = [[[responseObject objectForKey:@"data"] objectForKey:@"nextPage"] intValue];
            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            if (array != nil && array.count > 0) {
                [self.listArray removeAllObjects];
                [self.listArray addObjectsFromArray:array];
                [self.listView reloadData];
            }
            if (nextPage == -1) {
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.listView.mj_header endRefreshing];
        [self.listView.mj_footer endRefreshing];
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)giveMeMoreData{
    current_page++;
    NSString *page = [NSString stringWithFormat:@"%d",current_page];
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:page forKey:@"pageNo"];
    if (flagIndex == changeAscType) {
        [pramaDic setObject:@"10" forKey:@"pageSize"];
        [pramaDic setObject:@"change" forKey:@"sort"];
        [pramaDic setObject:@"desc" forKey:@"sortType"];
        [pramaDic setObject:@"" forKey:@"exchange"];
        methodName = kCoinList;
    }
    if (flagIndex == changeDescType) {
        [pramaDic setObject:@"10" forKey:@"pageSize"];
        [pramaDic setObject:@"change" forKey:@"sort"];
        [pramaDic setObject:@"asc" forKey:@"sortType"];
        [pramaDic setObject:@"" forKey:@"exchange"];
        methodName = kCoinList;
    }
    // 资金流入流出排名 desc 资金流流入 asc 资金流流出
    if (flagIndex == moneyIncomeType) {
        
        [pramaDic setObject:@"10" forKey:@"size"];
        [pramaDic setObject:@"desc" forKey:@"sort"];
        methodName = TradeFlowRank;
    }
    // 资金流入流出排名 desc 资金流流入 asc 资金流流出
    if (flagIndex == moneyOutGoType) {
        
        [pramaDic setObject:@"10" forKey:@"size"];
        [pramaDic setObject:@"asc" forKey:@"sort"];
        methodName = TradeFlowRank;
    }
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypePost success:^(id responseObject) {
        [self.listView.mj_footer endRefreshing];
         NSLog(@"methodName----->%@------->%@",methodName,responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            int nextPage = [[[responseObject objectForKey:@"data"] objectForKey:@"nextPage"] intValue];
            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            if (array != nil && array.count > 0) {
                [self.listArray addObjectsFromArray:array];
            }
            [self.listView reloadData];
            if (nextPage == -1) {
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.listView.mj_footer endRefreshing];
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//-(void)sortClick:(UIButton *)sender{
//    NSLog(@"sortClick");
//    sender.selected = !sender.selected;
//
//
//    if (sender.selected) {
//
//        self.sortType = @"desc";
//    }else{
//
//        self.sortType = @"asc";
//    }
//    [self.sortBtn changeStatus:btn.selected];
//    [self requestData];
//}

-(void)initSubviews{
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.menuSelectView];
    UIView *tableHeaderView = [self createTableHeadView:YES frame:CGRectMake(0, self.menuSelectView.bottom, SCREEN_WIDTH, 34)];
    [self.view addSubview:tableHeaderView];
    [self.view addSubview:self.listView];
}

-(UIView *)menuSelectView{
    if (_menuSelectView == nil) {
        _menuSelectView = [[menuVIew alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) WithArray:@[@"涨幅榜",@"跌幅榜",@"资金流入",@"资金流出"]];
        _menuSelectView.delegate = self;
    }
    return _menuSelectView;
}

-(UITableView *)listView{
    if (_listView == nil) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.menuSelectView.bottom +34 , SCREEN_WIDTH, SCREEN_HEIGHT  - NAVIGATION_HEIGHT - 50 -34)];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = KBGCell;
        _listView.rowHeight = [CoinTableViewCell cellHeight];
        //也可以让分割线消失
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        WS(weakSelf)
        _listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (User.userToken) {
                [weakSelf requestData];
            }
        }];
        MJRefreshBackNormalFooter *allfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (User.userToken) {
                [weakSelf giveMeMoreData];
            }
        }];
        _listView.mj_footer = allfooter;
        _listView.mj_footer.ignoredScrollViewContentInsetBottom = HOME_INDICATOR_HEIGHT;
    }
    return _listView;
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"market"];
    if (!cell) {
        cell = [[CoinTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"market"];
    }
    NSDictionary *celldict = [self.listArray objectAtIndex:indexPath.row];
    NSString *flagStr = [NSString stringWithFormat:@"%lu",(unsigned long)flagIndex];
    
    cell.flagStr = flagStr;
    [cell configwidth:celldict];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MessageItem *selectMessageItem = self.listArray[indexPath.row];
//
//    NSString *urlStr =  stringFormat(selectMessageItem.redirectUrl);
//    if([urlStr isEqualToString:@""]){
//        selectMessageItem.isShow = !selectMessageItem.isShow;
//        [self.listArray replaceObjectAtIndex:indexPath.row withObject:selectMessageItem];
//        [self.listView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
//    }else{
//        SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
//        webVc.urlString = [NSString stringWithFormat:@"%@",selectMessageItem.redirectUrl];
//        webVc.isHiddenLeft = NO;
//        webVc.isHiddenBottom = NO;
//        [self.navigationController pushViewController:webVc animated:YES];
//    }
}


-(void)menuViewDidSelect:(NSInteger)number{
    NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)number]);
    
    if (number == 1) {
        flagIndex = changeAscType;
    }
    if (number == 2) {
        flagIndex = changeDescType;
    }
    if (number == 3) {
        flagIndex = moneyIncomeType;
    }
    if (number == 4) {
        flagIndex = moneyOutGoType;
    }
    [self requestData];
}

- (UIView *)createTableHeadView:(BOOL)sortShow frame:(CGRect)frame{
    UIView * tablewHeadview = [[UIView alloc] initWithFrame:frame];
    //    UILabel * baseLabel = [self createLabelTitle:@"币种" frame:CGRectMake(16, 0, 80, 34)];
    //    baseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    //    [tablewHeadview addSubview:baseLabel];
    BTESortView * amountBtn = [[BTESortView alloc] initWithFrame:CGRectMake(16, 0, 82, 34) withTitle:@"币种/成交额" canSort:NO position:NSTextAlignmentLeft];
//    [amountBtn setTitle:@"币种/成交额"];
//    [amountBtn sortShow:sortShow];
    [amountBtn changeStatus:NO];
//    [amountBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    amountBtn.tag = 30;
    [tablewHeadview addSubview:amountBtn];
    
    
    UILabel * priceLabel = [self createLabelTitle:@"价格" frame:CGRectMake(218, 0, 26, 34)];
    priceLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [tablewHeadview  addSubview:priceLabel];
    
    BTESortView *descBtn = [[BTESortView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 72 - 16, 0, 72, 34) withTitle:@"24h涨跌幅" canSort:NO position:NSTextAlignmentRight];
//    [descBtn setTitle:@"24h涨跌幅"];
//    [descBtn sortShow:sortShow];
    
    [descBtn changeStatus:NO];
//    [descBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    descBtn.tag = 31;
    [tablewHeadview addSubview:descBtn];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = LineBGColor;
    [tablewHeadview addSubview:line];
    UIView * bline = [[UIView alloc] initWithFrame:CGRectMake(0, 33.5, SCREEN_WIDTH, 0.5)];
    bline.backgroundColor = LineBGColor;
    [tablewHeadview addSubview:bline];
    return tablewHeadview;
}

#pragma mark -- 初始化
- (UILabel *)createLabelTitle:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    return label;
}


@end
