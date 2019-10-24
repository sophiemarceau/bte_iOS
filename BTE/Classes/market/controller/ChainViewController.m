//
//  ChainViewController.m
//  BTE
//
//  Created by sophie on 2018/11/14.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "ChainViewController.h"
#import "ChainView.h"
#import "CoinTableViewCell.h"
#import "BTESortView.h"

@interface ChainViewController () <UITableViewDelegate,UITableViewDataSource>{
    int current_page,total_count;
    int flagIndex;
    UIView *listHeaderView ;
}

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *listView;
@property(nonatomic,strong)ChainView *chainHead1View;
@property(nonatomic,strong)ChainView *chainHead2View;

@end

@implementation ChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.industryName = @"底层公链";
    self.title =@"板块详情";
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    [self initSubviews];
    [self requestData];
}

-(void)initSubviews{
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = KBGColor;
    UIView *headBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 144)];
    headBgView.backgroundColor =KBGCell;
    
    self.chainHead1View = [[ChainView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 36) WithNameArray:@[@"总计",@"上涨",@"下跌",@"平均涨跌幅"]];
    self.chainHead1View.tag = 100;
    [headBgView addSubview:self.chainHead1View];
    self.chainHead2View = [[ChainView alloc] initWithFrame:CGRectMake(0, self.chainHead1View.bottom +26, SCREEN_WIDTH, 36) WithNameArray:@[@"成交额",@"资金流向",@"热力指数",@"空气指数"]];
    self.chainHead2View.tag = 101;
    [headBgView addSubview:self.chainHead2View];
    [self.view addSubview:headBgView];
    
    listHeaderView = [self createTableHeadView:NO frame:CGRectMake(0, headBgView.bottom+6,SCREEN_WIDTH, 34)];
    listHeaderView.backgroundColor =KBGCell;
    [self.view addSubview:listHeaderView];
    [self.view addSubview:self.listView];
}

-(void)requestData{
    current_page = 0;
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:self.industryName forKey:@"industryName"];
    [pramaDic setObject:@"0" forKey:@"pageNo"];
    [pramaDic setObject:@"10" forKey:@"pageSize"];
    [pramaDic setObject:@"change" forKey:@"sort"];
    [pramaDic setObject:@"desc" forKey:@"sortType"];

    methodName = kPlateDetail;

    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypePost success:^(id responseObject) {
        [self.listView.mj_header endRefreshing];
        [self.listView.mj_footer endRefreshing];
        NMRemovLoadIng;
        NSLog(@"methodName----->%@------->%@",methodName,responseObject);
        if (IsSafeDictionary(responseObject)) {
            total_count = [[[responseObject objectForKey:@"data"] objectForKey:@"totalNum"] intValue];
            NSString  *amount  = [[responseObject objectForKey:@"data"] objectForKey:@"amount"];
            NSString  *netAmount  = [[responseObject objectForKey:@"data"]
          objectForKey:@"netAmount"];
            NSString  *averageChange  =   [[responseObject objectForKey:@"data"] objectForKey:@"averageChange"];
            NSString  *hotIndex  =    [[responseObject objectForKey:@"data"] objectForKey:@"hotIndex"];
            NSString  *downNum  =    [[responseObject objectForKey:@"data"] objectForKey:@"downNum"];
            NSString  *airIndex  =    [[responseObject objectForKey:@"data"] objectForKey:@"airIndex"];
            NSString  *upNum  =   [[responseObject objectForKey:@"data"] objectForKey:@"upNum"];
            NSString  *totalNum  =     [[responseObject objectForKey:@"data"] objectForKey:@"totalNum"];
            NSArray *tempArray = @[totalNum,upNum,downNum,averageChange];
            [self.chainHead1View setValueForName:tempArray];
            NSArray *temp1Array =  @[amount,netAmount,hotIndex,airIndex];
            [self.chainHead2View setValueForName:temp1Array];

            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"currencyList"] ;
            if (array != nil && array.count > 0) {
                [self.listArray removeAllObjects];
                [self.listArray addObjectsFromArray:array];
                [self.listView reloadData];
            }
            if (self.listArray.count == total_count || self.listArray.count == 0) {
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

    [pramaDic setObject:self.industryName forKey:@"industryName"];
    [pramaDic setObject:page forKey:@"pageNo"];
    [pramaDic setObject:@"10" forKey:@"pageSize"];
    [pramaDic setObject:@"change" forKey:@"sort"];
    [pramaDic setObject:@"desc" forKey:@"sortType"];
    methodName = kPlateDetail;

    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:1 success:^(id responseObject) {
        [self.listView.mj_footer endRefreshing];
        NSLog(@"kMessageCenterList----giveMeMoreData---->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            total_count = [[[responseObject objectForKey:@"data"] objectForKey:@"totalNum"] intValue];
            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"currencyList"];
            if (array != nil && array.count > 0) {
                [self.listArray addObjectsFromArray:array];
            }
            [self.listView reloadData];
            if (self.listArray.count == total_count || self.listArray.count == 0) {
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

-(void)sortClick:(UIButton *)sender{
    
}

-(UITableView *)listView{
    if (_listView == nil) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, listHeaderView.bottom  , SCREEN_WIDTH, SCREEN_HEIGHT  - NAVIGATION_HEIGHT - listHeaderView.bottom)];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = KBGCell;
        _listView.rowHeight = [CoinTableViewCell cellHeight];
        //也可以让分割线消失
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        WS(weakSelf)
        _listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
             [weakSelf requestData];
        }];
        MJRefreshBackNormalFooter *allfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
             [weakSelf giveMeMoreData];
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

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return  64;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"market"];
    if (!cell) {
        cell = [[CoinTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"market"];
    }
    NSDictionary *celldict = [self.listArray objectAtIndex:indexPath.row];
    [cell setFlagStr:@"5"];
    [cell configwidth:celldict];
    return cell;
    //    static NSString *CellIdentifier = @"Cell";
    //    HotTableViewCell *cell;
    //    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        cell = [[HotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    //    NSDictionary * dic = @{@"coin":@"etc",@"money":@"7546",@"price":@"6450.34",@"hot":@"99.34",@"percent":@"-99.34"};
    //    [cell setDataDiction:dic];
    //    return cell;
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
    flagIndex = (int)number;
    //    [self loadDataWithFlagindex:flagIndex];
}

- (UIView *)createTableHeadView:(BOOL)sortShow frame:(CGRect)frame{
    UIView * tablewHeadview = [[UIView alloc] initWithFrame:frame];
    //    UILabel * baseLabel = [self createLabelTitle:@"币种" frame:CGRectMake(16, 0, 80, 34)];
    //    baseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    //    [tablewHeadview addSubview:baseLabel];
    BTESortView * amountBtn = [[BTESortView alloc] initWithFrame:CGRectMake(16, 0, 82, 34) withTitle:@"币种/成交额" canSort:sortShow position:NSTextAlignmentLeft];
//    [amountBtn setTitle:@"币种/成交额"];
//    [amountBtn sortShow:sortShow];
    [amountBtn changeStatus:NO];
    
    [amountBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    amountBtn.tag = 30;
    [tablewHeadview addSubview:amountBtn];
    
    
    UILabel * priceLabel = [self createLabelTitle:@"价格" frame:CGRectMake(218, 0, 26, 34)];
    priceLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [tablewHeadview  addSubview:priceLabel];
    
    BTESortView *descBtn = [[BTESortView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 72 - 16, 0, 72, 34) withTitle:@"24h涨跌幅" canSort:sortShow position:NSTextAlignmentRight];
//    [descBtn setTitle:@"24h涨跌幅"];
//    [descBtn sortShow:sortShow];
    [descBtn changeStatus:NO];
    [descBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
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
