//
//  BTEMarketViewController.m
//  BTE
//
//  Created by wanmeizty on 8/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEMarketViewController.h"

#import "UserStatistics.h"
#import "BTEShareView.h"
#import "BTEMarketTableViewCell.h"
#import "BTESortView.h"
#import "BTEKlineViewController.h"
#import "BTECurrencyTableViewCell.h"
#import "TestJSObject.h"
#import "ZTYCommonChartView.h"
#import "BTEOrderHeadView.h"
#import "ZTYExchangeTableViewCell.h"
#import "ZTYFlowRankTableViewCell.h"
#import "ZTYSortHeadView.h"
#import "ZTYCoinTableViewCell.h"

@interface BTEMarketViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView * headview;

@property (assign,nonatomic) NSInteger pageNo;
@property (strong,nonatomic) UITableView * markTableView;
@property (strong,nonatomic) NSMutableArray * marketList;
@property (strong,nonatomic) NSMutableArray * marketFlowArray;
@property (strong,nonatomic) NSMutableArray * exchangeArray;

@property (strong,nonatomic) NSArray * curencyArray;
@property (strong,nonatomic) BTESortView * sortBtn;
@property (strong,nonatomic) UITextField * searchText;
@property (strong,nonatomic) UIView * nodataView;
@property (copy,nonatomic) NSString * sortType;
@property (copy,nonatomic) NSString * sort;
@property (assign,nonatomic) int sectionIndex;// 0资金流入  1涨跌幅

@property (strong,nonatomic) UIScrollView * scrollView;

@property (strong,nonatomic) ZTYCommonChartView * candleView;
@property (strong,nonatomic) UIView * marketHeadView;
@property (strong,nonatomic) UIScrollView * marketSelelctView;
@property (copy,nonatomic) NSString * base;
@property (strong,nonatomic) UIView * mainCurrencyView;
@property (strong,nonatomic) NSArray * itemArray;
@property (assign,nonatomic) NSInteger currentItemIndex;

@end

@implementation BTEMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sortType = @"desc";

    self.sort = @""; // 排序字段 amount price hot air change
    self.sectionIndex = 0;
    self.pageNo = 0;
    _currentItemIndex = 0;

//    [self createScrollView];
//    [self createheadView];
//    [self creareWebView];
//    [self createTableView];

    self.marketList = [[NSMutableArray alloc] init];
    self.marketFlowArray = [[NSMutableArray alloc] init];
    self.exchangeArray = [[NSMutableArray alloc] init];
    
    [self requestNavigateList];
    [self createNavigate];
    [self createScrollView];
   
    [self requestMarketListDataWithPage:1];
    
    
}

- (void)requestNavigateList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString * methodName = @"";
    methodName = MarketNavigateList;
    [param setObject:[NSString stringWithFormat:@"%ld",self.pageNo] forKey:@"pageNo"];
    [param setObject:self.sortType forKey:@"sort"];
    [param setObject:@"10" forKey:@"size"];
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:param type:4 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            
            [self performSelectorOnMainThread:@selector(updateHeadview:) withObject:responseObject waitUntilDone:YES];
        }
    } failure:^(NSError *error) {
        
        RequestError(error);
        //        NSLog(@"error-------->%@",error);
        
    }];
}

- (void)requestdataList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString * methodName = @"";
    methodName = Summary24List;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:param type:4 success:^(id responseObject) {
        
        if (IsSafeDictionary(responseObject)) {
            
        }
    } failure:^(NSError *error) {
        
        RequestError(error);
        //        NSLog(@"error-------->%@",error);
        
    }];
}

- (void)updateHeadview:(NSDictionary *)dataDict{
    [self.headview removeAllSubviews];
    [self.headview removeFromSuperview];
    
    NSArray * dataArray = [dataDict objectForKey:@"data"];
    self.itemArray = dataArray;
    self.headview = [self createSelectBtnItems:self.itemArray frame:CGRectMake(0, 0, SCREEN_WIDTH, 40) basetag:200];
    [self.view addSubview:self.headview];
    NSDictionary * dict = [dataArray firstObject];
    
    [self createTableView];
    
    if ([[dict objectForKey:@"chn_name"] isEqualToString:@"市场"]) {
        [self requestHistoryfoundFlow];
        [self requestFlowRank:self.pageNo];
        [self requestExchangeList];
    }else{
        
    }
}

- (void)createNavigate{
    UIButton * searchview = [[UIButton alloc] initWithFrame:CGRectMake(16, 7, SCREEN_WIDTH - 32, 30)];
    searchview.backgroundColor = [UIColor colorWithHexString:@"626A75" alpha:0.06];
    [searchview addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    searchview.layer.cornerRadius = 11;
    searchview.layer.masksToBounds = YES;
    
    
    UITextField * searchText = [[UITextField alloc] initWithFrame:CGRectMake(14 + 15 + 19, 7, searchview.width - 38 - 14, 17)];
    searchText.keyboardType = UIKeyboardTypeASCIICapable;
    searchText.placeholder = @"请输入您要搜索的币种";
    searchText.enabled = NO;
    [searchview addSubview:searchText];
    
    
    UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 7.5, 15, 15)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"marketSearch"] forState:UIControlStateNormal];
    [searchview addSubview:searchBtn];
    self.navigationItem.titleView = searchview;

}

// 点击搜索栏
- (void)searchClick{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestHistoryfoundFlow];
    [self requestFlowRank:self.pageNo];
    [self requestExchangeList];
}

#pragma mark -- 请求数据
- (void)requestMarketListDataWithPage:(NSInteger)page{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",self.pageNo] forKey:@"pageNo"];
    //sortType    排序方式 desc asc
    [param setObject:self.sortType forKey:@"sortType"];
    //sort 排序字段 amount price hot air change
    [param setObject:self.sort forKey:@"sort"];
    [param setObject:@"10" forKey:@"size"];
    methodName = allMarketList;
    
    WS(weakSelf)
    
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            
            NSArray * array = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            
            
            
            if (array.count > 0) {
                if (weakSelf.pageNo == 1) {
                    [self.marketList removeAllObjects];
                }
                [self.marketList addObjectsFromArray:array];
                
            }
            if (self.marketList.count == 0) {
                self.nodataView.hidden = NO;
            }else{
                self.nodataView.hidden = YES;
            }
            
            UITableView * tableview = [self.scrollView viewWithTag:_currentItemIndex + 2000];

            [tableview reloadData];
            
        }
    } failure:^(NSError *error) {
        
        RequestError(error);
        //        NSLog(@"error-------->%@",error);
        
    }];
}

// 主流币种推荐列表
- (void)requestMainstreamListData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    
    methodName = optionMainstreamList;
    
    WS(weakSelf)
    
    [BTERequestTools requestWithURLString:methodName parameters:param type:4 success:^(id responseObject) {
        
        if (IsSafeDictionary(responseObject)) {
            NSArray * dataArr = [responseObject objectForKey:@"data"];
            self.curencyArray = dataArr;
            [self createCurrencyBtn];
        }
    } failure:^(NSError *error) {
        
        RequestError(error);
        //        NSLog(@"error-------->%@",error);
        
    }];
}

- (void)requestHistoryfoundFlow{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    if (self.base) {
        param[@"base"] = self.base;
    }
    
    NSString * methodName = currencyFoundFlowList;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            
            [weakSelf updateFoundflow:responseObject];
            
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
    }];
}

// 资金流入流出排名
- (void)requestFlowRank:(NSInteger)pageNo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    self.sectionIndex = 0;
    [param setObject:[NSString stringWithFormat:@"%ld",pageNo] forKey:@"pageNo"];
    [param setObject:@"10" forKey:@"size"];
    [param setObject:self.sortType forKey:@"sort"];
    // desc 倒序 asc 正序
    NSString * methodName = TradeFlowRank;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            
            
            NSDictionary * dataDict = [responseObject objectForKey:@"data"];
            NSArray * dataArray = [dataDict objectForKey:@"list"];
            [self.marketFlowArray removeAllObjects];
            [self.marketFlowArray addObjectsFromArray:dataArray];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.markTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
    }];
}

// 资金流入流出排名
- (void)requestRankList:(NSInteger)pageNo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    self.sectionIndex = 1;
    [param setObject:[NSString stringWithFormat:@"%ld",pageNo] forKey:@"pageNo"];
    [param setObject:@"10" forKey:@"size"];
    [param setObject:self.sortType forKey:@"sort"];
    // desc 倒序 asc 正序
    NSString * methodName = RiseRankList;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * dataDict = [responseObject objectForKey:@"data"];
            NSArray * dataArray = [dataDict objectForKey:@"list"];
            [self.marketFlowArray removeAllObjects];
            [self.marketFlowArray addObjectsFromArray:dataArray];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.markTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
    }];
}

- (void)requestExchangeList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = SummaryList;
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:param type:4 success:^(id responseObject) {
        //        NMRemovLoadIng;
        
        if (IsSafeDictionary(responseObject)) {
            
            NSArray * dataArray = [responseObject objectForKey:@"data"];
            [self.exchangeArray removeAllObjects];
            [self.exchangeArray addObjectsFromArray:dataArray];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.markTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.markTableView) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.markTableView) {
        if (section == 0) {
            if (self.marketFlowArray.count <= 5) {
                return self.marketFlowArray.count;
            }else{
                return 5;
            }
        }else if (section == 1){
            return self.exchangeArray.count;
        }else{
            return 0;
        }
    }else{
        
        id title = self.itemArray[_currentItemIndex];
        if ([title isKindOfClass:[NSDictionary class]]) {
            title = [title objectForKey:@"chn_name"];
        }
        if ([title isEqualToString:@"币种"]) {
            return self.marketList.count;
        }else if ([title isEqualToString:@"热度指数"]){
            return 0;
        }else if ([title isEqualToString:@"空气指数"]){
            return 0;
        }else if ([title isEqualToString:@"板块"]){
            return 0;
        }else if ([title isEqualToString:@"平台"]){
            return 0;
        }else{
            return 0;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if(tableView == self.markTableView){
        
        NSDictionary * celldict = [self.marketList objectAtIndex:indexPath.row];
        HomeDesListModel * delistModel = [[HomeDesListModel alloc] init];
        [delistModel initDict:celldict];
        [self goToKLineVC:delistModel];
    }else{
        
        NSDictionary * celldict = [self.marketList objectAtIndex:indexPath.row];;
        HomeDesListModel * delistModel = [[HomeDesListModel alloc] init];
        [delistModel initDict:celldict];
        [self goToKLineVC:delistModel];
    }
    
}

- (void)goToKLineVC:(HomeDesListModel *)delistModel{
    [UserStatistics sendEventToServer:@"进入K线"];
    BTEKlineViewController *homePageVc= [[BTEKlineViewController alloc] init];
    homePageVc.desListModel = delistModel;
    [self.navigationController pushViewController:homePageVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.markTableView){
        if (indexPath.section == 0) {
            if (self.sectionIndex == 0) {
                return [ZTYFlowRankTableViewCell cellHeigth];
            }else{
                return [BTEMarketTableViewCell cellHeight];
            }
        }else if (indexPath.section == 1){
            return [ZTYExchangeTableViewCell cellHeigth];
        }else{
            return 0;
        }
    }
    else{
        id title = self.itemArray[_currentItemIndex];
        if ([title isKindOfClass:[NSDictionary class]]) {
            title = [title objectForKey:@"chn_name"];
        }
        if ([title isEqualToString:@"币种"]) {
            return [ZTYCoinTableViewCell cellHeight];
        }else if ([title isEqualToString:@"热度指数"]){
            return 0;
        }else if ([title isEqualToString:@"空气指数"]){
            return 0;
        }else if ([title isEqualToString:@"板块"]){
            return 0;
        }else if ([title isEqualToString:@"平台"]){
            return 0;
        }else{
            return 0;
        }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.markTableView){
        
        if (indexPath.section == 0) {
            if (self.sectionIndex ==  0) {
                ZTYFlowRankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"marketFlow"];
                if (!cell) {
                    cell = [[ZTYFlowRankTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"marketFlow"];
                }
                NSDictionary * celldict = [self.marketFlowArray objectAtIndex:indexPath.row];
                
                [cell configwithDict:celldict];
                return cell;
            }else{
                BTEMarketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"marketRose"];
                if (!cell) {
                    cell = [[BTEMarketTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"marketRose"];
                }
                NSDictionary * celldict = [self.marketFlowArray objectAtIndex:indexPath.row];
                
                [cell configwidth:celldict];
                return cell;
            }
        }else if (indexPath.section == 1){
            
            ZTYExchangeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"exchange"];
            if (!cell) {
                cell = [[ZTYExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"exchange"];
            }
            NSDictionary * dict = self.exchangeArray[indexPath.row];
            [cell configwithDict:dict];
            return cell;
        }else{
            return [[BTEMarketTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"marketExchange"];
        }
        
    }
    else{
        NSInteger index = tableView.tag - 2000;
        id title = self.itemArray[index];
        if ([title isKindOfClass:[NSDictionary class]]) {
            title = [title objectForKey:@"chn_name"];
        }
        
        if ([title isEqualToString:@"币种"]) {
            ZTYCoinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"marketRose"];
            if (!cell) {
                cell = [[ZTYCoinTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"marketRose"];
            }
            NSDictionary * celldict = [self.marketList objectAtIndex:indexPath.row];
            [cell configwidth:celldict];
            return cell;
        }else if ([title isEqualToString:@"热度指数"]){
            
        }else if ([title isEqualToString:@"空气指数"]){
            
        }else if ([title isEqualToString:@"板块"]){
            
        }else if ([title isEqualToString:@"平台"]){
            ZTYExchangeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"exchange"];
            if (!cell) {
                cell = [[ZTYExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"exchange"];
            }
            NSDictionary * dict = self.exchangeArray[indexPath.row];
            [cell configwithDict:dict];
            return cell;
        }
        BTEMarketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"market"];
        if (!cell) {
            cell = [[BTEMarketTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"market"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.markTableView){
        if (section == 0) {
            return 123;
        }else{
            return 0;
        }
        //        return 123;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (tableView == self.markTableView){
        return 0.01;
    }
    else{
        id title = self.itemArray[_currentItemIndex];
        if ([title isKindOfClass:[NSDictionary class]]) {
            title = [title objectForKey:@"chn_name"];
        }
        if ([title isEqualToString:@"币种"]) {
            return 34;
        }else if ([title isEqualToString:@"热度指数"]){
            return 34 + 62;
        }else if ([title isEqualToString:@"空气指数"]){
            return 34;
        }else if ([title isEqualToString:@"板块"]){
            return 34;
        }else if ([title isEqualToString:@"平台"]){
            return 34;
        }else{
            return 0.01;
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.markTableView){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    else{
        id title = self.itemArray[_currentItemIndex];
        if ([title isKindOfClass:[NSDictionary class]]) {
            title = [title objectForKey:@"chn_name"];
        }
        if ([title isEqualToString:@"币种"]) {
            NSArray * sorttitles = @[@"币种/成交额",@"价格",@"24h涨跌幅"];
            NSArray * canSorts = @[@(YES),@(NO),@(YES)];
            NSArray * sortAlgins = @[@(NSTextAlignmentLeft),@(NSTextAlignmentRight),@(NSTextAlignmentRight)];
            ZTYSortHeadView * tablewHeadview = [[ZTYSortHeadView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 34) sortTitles:sorttitles isCanSorts:canSorts aligns:sortAlgins];
            return tablewHeadview;
        }else if ([title isEqualToString:@"热度指数"]){
            UIView * tablewHeadview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34 + 62)];
            UILabel * noteLabel = [self createLabelTitle:@"热度指数是比热易独家推出的市场热度指标，客观结合大数据分析，第一时间发掘热门投资币种，数值越大，热度最高。" frame:CGRectMake(16, 12, SCREEN_WIDTH - 32, 40)];
            noteLabel.numberOfLines = 2;
            [tablewHeadview addSubview:noteLabel];
            
            NSArray * sorttitles = @[@"币种/成交额",@"价格/涨跌",@"热度指数"];
            NSArray * canSorts = @[@(YES),@(NO),@(YES)];
            NSArray * sortAlgins = @[@(NSTextAlignmentLeft),@(NSTextAlignmentRight),@(NSTextAlignmentRight)];
            ZTYSortHeadView * Headview = [[ZTYSortHeadView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 34) sortTitles:sorttitles isCanSorts:canSorts aligns:sortAlgins];
            [tablewHeadview addSubview:Headview];
            
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 61.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = LineBGColor;
            [tablewHeadview addSubview:line];
            return tablewHeadview;
        }else if ([title isEqualToString:@"空气指数"]){
            NSArray * sorttitles = @[@"币种/成交额",@"价格",@"净成交额(24h)"];
            NSArray * canSorts = @[@(NO),@(NO),@(NO)];
            NSArray * sortAlgins = @[@(NSTextAlignmentLeft),@(NSTextAlignmentRight),@(NSTextAlignmentRight)];
            ZTYSortHeadView * tablewHeadview = [[ZTYSortHeadView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 34) sortTitles:sorttitles isCanSorts:canSorts aligns:sortAlgins];
            return tablewHeadview;
        }else if ([title isEqualToString:@"板块"]){
            NSArray * sorttitles = @[@"币种/成交额",@"价格",@"净成交额(24h)"];
            NSArray * canSorts = @[@(NO),@(NO),@(NO)];
            NSArray * sortAlgins = @[@(NSTextAlignmentLeft),@(NSTextAlignmentRight),@(NSTextAlignmentRight)];
            ZTYSortHeadView * tablewHeadview = [[ZTYSortHeadView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 34) sortTitles:sorttitles isCanSorts:canSorts aligns:sortAlgins];
            return tablewHeadview;
        }else if ([title isEqualToString:@"平台"]){
            NSArray * sorttitles = @[@"币种/成交额",@"价格",@"净成交额(24h)"];
            NSArray * canSorts = @[@(NO),@(NO),@(NO)];
            NSArray * sortAlgins = @[@(NSTextAlignmentLeft),@(NSTextAlignmentRight),@(NSTextAlignmentRight)];
            ZTYSortHeadView * tablewHeadview = [[ZTYSortHeadView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 34) sortTitles:sorttitles isCanSorts:canSorts aligns:sortAlgins];
            return tablewHeadview;
        }else{
            return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.markTableView && section == 0){
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 123)];
        UIButton *moreBtn = [self createBtn:@"查看更多" frame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [moreBtn setImage:[UIImage imageNamed:@"centerArrow"] forState:UIControlStateNormal];
        [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -moreBtn.imageView.width - 7, 0, moreBtn.imageView.width + 7)];
        [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, moreBtn.titleLabel.width, 0, -moreBtn.titleLabel.width)];
        moreBtn.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:moreBtn];
        
        UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 38 + 35)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel * headLabel = [self createLabelTitle:@"交易平台" frame:CGRectMake(16, 0, SCREEN_WIDTH, 38)];
        headLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [headView addSubview:headLabel];
        
        UIView * theadview = [[UIView alloc] initWithFrame:CGRectMake(0, 38.5, SCREEN_WIDTH, 34)];
        NSArray * titles = @[@"交易所",@"成交额",@"资金流向",@"空气指数"];
        
        CGFloat titleWidth = (SCREEN_WIDTH - 32)/ (titles.count * 1.0);
        for (int i = 0; i < titles.count; i ++) {
            UILabel * label = [self createLabelTitle:titles[i] frame:CGRectMake(16 + i * titleWidth, 0, titleWidth, 34)];
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
            }else if (i == titles.count - 1){
                
                label.textAlignment = NSTextAlignmentRight;
            }else{
                label.textAlignment = NSTextAlignmentRight;
            }
            [theadview addSubview:label];
        }
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 38.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = LineBGColor;
        [headView addSubview:line];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 38 + 34.5, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = LineBGColor;
        [headView addSubview:line2];
        
        [headView addSubview:theadview];
        
        [bgView addSubview:headView];
        return bgView;
    }else{
        return [UIView new];
    }
}

- (void)createScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
}

- (UIScrollView *)createSelectBtnItems:(NSArray *)titles frame:(CGRect)frame basetag:(int)baseTag{
    UIScrollView * headView = [[UIScrollView alloc] initWithFrame:frame];
    CGFloat btnWidth = (frame.size.width) / (titles.count * 1.0);
    if (titles.count > 5) {
        btnWidth = SCREEN_WIDTH / 5.0;
        headView.contentSize = CGSizeMake(btnWidth * titles.count, 0);
    }
    
    for (int index = 0; index < titles.count; index ++) {
        id title = titles[index];
        if ([title isKindOfClass:[NSDictionary class]]) {
            title = [title objectForKey:@"chn_name"];
        }
        UIButton * btn = [self createBtn:title frame:CGRectMake(btnWidth * index, 0, btnWidth, 38)];
        [btn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = baseTag + index;
        if (index == 0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"308cdd"] forState:UIControlStateNormal];
        }
        [headView addSubview:btn];
        
        
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((btnWidth - 14) * 0.5, 39, 14, 1)];
    lineView.tag = 233;
    lineView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
    [headView addSubview:lineView];
    return headView;

}

- (void)createTableView{
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.itemArray.count, 0);
    
    for (int i = 0; i < self.itemArray.count; i ++) {
        NSDictionary * dict = self.itemArray[i];
        
        if ([[dict objectForKey:@"url"] length] > 0) {
            
            UIWebView * webview = [[UIWebView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 49)];
            NSURL *  url = [NSURL URLWithString:[dict objectForKey:@"url"]];
            NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
            [webview loadRequest:request];
            webview.tag = 2000 + i;
            [self.scrollView addSubview:webview];
            
        }else{
            if ([[dict objectForKey:@"chn_name"] isEqualToString:@"市场"]) {
                
                self.markTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i , 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 49) style:UITableViewStyleGrouped];
                self.markTableView.delegate = self;
                self.markTableView.dataSource = self;
                self.markTableView.tableFooterView = [UIView new];
                self.markTableView.rowHeight = [BTEMarketTableViewCell cellHeight];
                self.marketHeadView = [self createmarketHeadview];
                self.markTableView.tableHeaderView = self.marketHeadView;
                self.markTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                [self.scrollView addSubview:self.markTableView];
            }else{
//                UIView * optionView = [self createTableHeadView:NO frame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, 34)];
//                [self.scrollView addSubview:optionView];
                UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 0 - 49 - 40) style:UITableViewStylePlain];
                tableview.delegate = self;
                tableview.dataSource = self;
                tableview.tableHeaderView = [UIView new];
                tableview.tableFooterView = [UIView new];
                tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
                tableview.rowHeight = [BTEMarketTableViewCell cellHeight];
                tableview.tag = 2000 + i;
                [self.scrollView addSubview:tableview];
            }

        }
        
        
        
        
        
        //        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //
        //        }];
        //        tableview.mj_header = header;
        //
        //        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //
        //        }];
        //        tableview.mj_footer = footer;
    }
    UIView * nodataBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 34 - 49 - 44)];
    self.nodataView = nodataBGView;
    nodataBGView.hidden = YES;
    [self.view addSubview:nodataBGView];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 181)*0.5, (nodataBGView.height - 165) * 0.5 - 40, 181, 165)];
    imgView.image = [UIImage imageNamed:@"nodata"];
    [nodataBGView addSubview:imgView];
    
    
    UILabel * nodataLabel = [self createLabelTitle:@"没有数据" frame:CGRectMake(0, imgView.bottom + 40, SCREEN_WIDTH, 20)];
    nodataLabel.textAlignment = NSTextAlignmentCenter;
    nodataLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    nodataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [nodataBGView addSubview:nodataLabel];
    
}

- (void)sortClick:(UIButton *)btn{
    
    self.pageNo = 0;
    if (btn.selected) {
        btn.selected = NO;
        self.sortType = @"desc";
    }else{
        btn.selected = YES;
        self.sortType = @"asc";
    }
    [self.sortBtn changeStatus:btn.selected];
    [self requestMarketListDataWithPage:self.pageNo];
}

- (void)clearBtnSelect{
    for (int i = 200; i < (200 + _itemArray.count); i ++) {
        UIButton * button = [self.headview viewWithTag:i];
        [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    }
    UIView * line = [self.headview viewWithTag:233];
    line.x = SCREEN_WIDTH;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSLog(@"减速结束 %f",(long)scrollView.contentOffset.x/scrollView.bounds.size.width);
        NSInteger count = (long)scrollView.contentOffset.x/scrollView.bounds.size.width;
        UIButton * button = [self.headview viewWithTag:200 + count];
        [self headClick:button];
    }
}

- (void)headClick:(UIButton *)btn{
    if (btn.tag < 400) {
        [self clearBtnSelect];
        [btn setTitleColor:[UIColor colorWithHexString:@"308cdd"] forState:UIControlStateNormal];
        UIView * line = [self.headview viewWithTag:233];
        
        CGFloat btnWidth = (self.headview.width) / (_itemArray.count * 1.0);
        if (_itemArray.count > 5) {
            btnWidth = SCREEN_WIDTH / 5.0;
            
        }
        
        if (btn.tag > 204) {
            CGPoint contentOffset = self.headview.contentOffset;
            contentOffset.x = (btn.tag-204) * btnWidth;
            [self.headview setContentOffset:contentOffset animated:NO];
        }else{
            CGPoint contentOffset = self.headview.contentOffset;
            contentOffset.x = 0;
            [self.headview setContentOffset:contentOffset animated:NO];
        }
        line.x = (btnWidth - 14) * 0.5 + btnWidth * (btn.tag - 200);
        
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.x = (btn.tag-200) * SCREEN_WIDTH;
        [self.scrollView setContentOffset:contentOffset animated:YES];
        
        self.nodataView.hidden = YES;
        _currentItemIndex = btn.tag - 200;
        id title = self.itemArray[_currentItemIndex];
        if ([title isKindOfClass:[NSDictionary class]]) {
            title = [title objectForKey:@"chn_name"];
        }
        
        if ([title isEqualToString:@"币种"]) {
//            if (self.marketList.count == 0) {
                [self requestMarketListDataWithPage:1];
//            }else{
//                self.nodataView.hidden = YES;
//                UITableView * tableview = [self.scrollView viewWithTag:2000 + _currentItemIndex];
//                [tableview reloadData];
//            }
        }else if ([title isEqualToString:@"热度指数"]){
            
        }else if ([title isEqualToString:@"空气指数"]){
            
        }else if ([title isEqualToString:@"板块"]){
            
            //            [self.sortBtn sortShow:YES];
            if (self.marketList.count == 0) {
                [self requestMarketListDataWithPage:1];
            }else{
                self.nodataView.hidden = YES;
            }
        }else if (btn.tag == 202){
            
            //            [self.sortBtn sortShow:NO];
        }else if ([title isEqualToString:@"平台"]){
            
        }else if ([title isEqualToString:@"市场"]){

            
        }
        
    }else{
        for (int i = 400; i < 404; i ++) {
            UIButton * button = [self.marketSelelctView viewWithTag:i];
            [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor colorWithHexString:@"308cdd"] forState:UIControlStateNormal];
        UIView * line = [self.marketSelelctView viewWithTag:233];
        CGFloat labelWidth = (SCREEN_WIDTH)/4.0;
        line.x = (labelWidth - 14) * 0.5 + labelWidth * (btn.tag - 400);
        
        // desc 倒序 asc 正序
        if (btn.tag == 400) {
            self.sortType = @"desc";
            [self requestFlowRank:0];
        }else if (btn.tag == 401){
            self.sortType = @"asc";
            [self requestFlowRank:0];
        }else if (btn.tag == 402){
            self.sortType = @"asc";
            [self requestRankList:0];
        }else if (btn.tag == 403){
            self.sortType = @"desc";
            [self requestRankList:0];
        }
    }
}

- (UIButton *)createBtn:(NSString *)title frame:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [btn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    return btn;
}

#pragma mark - Navigation
- (UIBarButtonItem *)creatRightBarItem {
    UIImage *buttonNormal = [[UIImage imageNamed:@"Group 24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(shareAlert)];
    return leftItem;
}

- (void)shareAlert{
    [UserStatistics sendEventToServer:@"积分页点击右上角分享"];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:kAppBTEH5AnalyzeAddress sharetitle:@"比特易-数字货币市场专业分析平台" shareDesc:@"比特易是业界领先的数字货币市场专业分析平台，软银中国资本(SBCVC)、蓝驰创投(BlueRun Ventures)战略投资，区块链市场数据分析工具。" shareType:UMS_SHARE_TYPE_WEB_LINK currentVc:self];
    });
}
#pragma mark --k线相关
- (UIView *)createmarketHeadview{
    
    UIView * marketHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 343 + 34)];
    marketHeadView.backgroundColor = [UIColor whiteColor];
    CGFloat top = 100;
    CGFloat candelHeight = 180;
    
    UIButton* selectBtn = [self createBtn:@"全网资金流向" frame:CGRectMake(0, 0, (SCREEN_WIDTH - 32) * 0.5, 25)];
    selectBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    selectBtn.tag = 900;
    [selectBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.backgroundColor = backBlue;
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    UIButton* propertyBtn = [self createBtn:@"BTC全网资金流向" frame:CGRectMake((SCREEN_WIDTH - 32) * 0.5, 0, (SCREEN_WIDTH - 32) * 0.5, 25)];
    propertyBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    propertyBtn.tag = 901;
    [self changeBtn:propertyBtn statusShowImg:1];
    [propertyBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 32, 25)];
    titleView.layer.borderColor = backBlue.CGColor;
    titleView.layer.borderWidth = 1;
    //    titleView.layer.cornerRadius = 5;
    //    titleView.layer.masksToBounds = YES;
    [titleView addSubview:selectBtn];
    [titleView addSubview:propertyBtn];
    [marketHeadView addSubview:titleView];
    
    UILabel * dateTitleLabel = [self createLabelTitle:@"昨日有效资金流向" frame:CGRectMake(16, 57, SCREEN_WIDTH - 32, 10)];
    dateTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    dateTitleLabel.textAlignment = NSTextAlignmentRight;
    dateTitleLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    [marketHeadView addSubview:dateTitleLabel];
    
    UILabel * foundLabel = [self createLabelTitle:@"+1,434万元" frame:CGRectMake(16, 57 + 18, SCREEN_WIDTH - 32, 10)];
    foundLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];;
    foundLabel.textAlignment = NSTextAlignmentRight;
    foundLabel.textColor = [UIColor colorWithHexString:@"228B22" alpha:1];
    foundLabel.tag = 800;
    [marketHeadView addSubview:foundLabel];
    CGFloat letfWidth = 50;
    UIScrollView * scrollView = [UIScrollView new];
    [marketHeadView addSubview:scrollView];
    scrollView.backgroundColor =  [UIColor whiteColor];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(marketHeadView).offset(top);
        make.left.equalTo(marketHeadView).offset(letfWidth);
        make.right.equalTo(marketHeadView).offset(0);
        make.height.equalTo(@(candelHeight));
    }];
    
    ZTYCommonChartView * candleView = [ZTYCommonChartView new];
    [scrollView addSubview:candleView];
    candleView.mainchartType = MainChartcenterViewTypeKline;
    candleView.lineCount = 3;
    [candleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(scrollView);
        make.right.equalTo(scrollView);
        make.height.equalTo(@(candelHeight));
    }];
    candleView.backgroundColor = [UIColor whiteColor];
    candleView.candleSpace = 2;
    candleView.displayCount = 120;
    candleView.lineWidth = 1*widthradio;
    self.candleView = candleView;
    
    
    
    UILabel * maxPLabel = [self createLabelTitle:@"" frame:CGRectMake(0, top, letfWidth, 10)];
    maxPLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    maxPLabel.tag = 300;
    maxPLabel.textColor = [UIColor colorWithHexString:@"525866"];
    [marketHeadView addSubview:maxPLabel];
    
    UILabel * maxMPLabel = [self createLabelTitle:@"" frame:CGRectMake(0, top + (candelHeight - 15) * 0.33 - 5, letfWidth, 10)];
    maxMPLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    maxMPLabel.tag = 301;
    maxMPLabel.textColor = [UIColor colorWithHexString:@"525866"];
    [marketHeadView addSubview:maxMPLabel];
    
    UILabel * minMPLabel = [self createLabelTitle:@"" frame:CGRectMake(0, top + (candelHeight - 15) * 0.66 - 5, letfWidth, 10)];
    minMPLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    minMPLabel.tag = 302;
    minMPLabel.textColor = [UIColor colorWithHexString:@"525866"];
    [marketHeadView addSubview:minMPLabel];
    
    UILabel * minPLabel = [self createLabelTitle:@"" frame:CGRectMake(0, top + (candelHeight - 15) - 10, letfWidth, 10)];
    minPLabel.tag = 303;
    minPLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    minPLabel.textColor = [UIColor colorWithHexString:@"525866"];
    [marketHeadView addSubview:minPLabel];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, top + candelHeight + 10, SCREEN_WIDTH, 6)];
    lineView.backgroundColor = KBGColor;
    [marketHeadView addSubview:lineView];
    
    NSArray * titles = @[@"资金流入",@"资金流出",@"涨幅榜",@"跌幅榜"];
    self.marketSelelctView = [self createSelectBtnItems:titles frame:CGRectMake(0, top + candelHeight + 10 + 6, SCREEN_WIDTH, 50) basetag:400];
    [marketHeadView addSubview:self.marketSelelctView];
    
    NSArray * sorttitles = @[@"币种/成交额",@"价格",@"净成交额(24h)"];
    NSArray * canSorts = @[@(NO),@(NO),@(NO)];
    NSArray * sortAlgins = @[@(NSTextAlignmentLeft),@(NSTextAlignmentRight),@(NSTextAlignmentRight)];
    ZTYSortHeadView * sortheadview = [[ZTYSortHeadView alloc] initWithFrame:CGRectMake(0, top + candelHeight + 10 + 6 + 50, SCREEN_WIDTH, 34) sortTitles:sorttitles isCanSorts:canSorts aligns:sortAlgins];
    [marketHeadView addSubview:sortheadview];
    return marketHeadView;
}

- (void)selectItem:(UIButton *)btn{
    if (btn.tag == 900) {
        self.base = nil;
        [self requestHistoryfoundFlow];
    }else{
        
        if (self.mainCurrencyView.hidden) {
            self.mainCurrencyView.hidden = NO;
            if (self.curencyArray.count > 0) {
                [self createCurrencyBtn];
            }else{
                [self requestMainstreamListData];
            }
        }else{
            self.mainCurrencyView.hidden = YES;
        }
        
        
        UIButton * properyBtn = [self.marketHeadView viewWithTag:901];
        [self changeBtn:properyBtn statusShowImg:0];
    }
}

- (void)updateFoundflow:(NSDictionary *)dict{
    
    NSArray * klineArr = [dict objectForKey:@"data"];
    
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    for (NSArray * subArr in klineArr) {
        ZTYChartModel * model = [[ZTYChartModel alloc] init];
        [model initBaseDataWithArray:subArr];
        [dataArray addObject:model];
    }
    
    if (dataArray.count < 100) {
        _candleView.displayCount = dataArray.count < MinCount?MinCount:dataArray.count;
    }
    [self getFoundKlineData:dataArray];
    
    
}

- (void)getFoundKlineData:(NSArray*)dataArr{
    if (dataArr.count > 0) {
        ZTYChartModel * model = [dataArr lastObject];
        UILabel * foundLabel = [self.marketHeadView viewWithTag:800];
        foundLabel.text = [NSString stringWithFormat:@"%@",[self formatwithNum:model.close - model.open]];
    }
    _candleView.dataArray = dataArr.mutableCopy;
    [_candleView stockFill];
    
    UILabel * maxPLabel = [self.marketHeadView viewWithTag:300];
    
    UILabel * maxMPLabel = [self.marketHeadView viewWithTag:301];
    
    UILabel * minMPLabel = [self.marketHeadView viewWithTag:302];
    
    UILabel * minPLabel = [self.marketHeadView viewWithTag:303];
    
    
    double maxValue = _candleView.maxY;
    double minValue = _candleView.minY;
    
    maxPLabel.text = [self formatwithNum:maxValue];
    
    maxMPLabel.text = [self formatwithNum:((maxValue - minValue) * 0.6666 + minValue)];
    minMPLabel.text = [self formatwithNum:((maxValue - minValue)* 0.3333 + minValue)];
    minPLabel.text = [self formatwithNum:minValue];
    
}

- (NSString *)formatwithNum:(double )number{
    //    double number = [num doubleValue];
    if(number == 0){
        return @"0";
    }else if (ABS(number) >= 1000000000000){
        return [NSString stringWithFormat:@"%.2f万亿",number / 1000000000000.0];
    }else if (ABS(number) >= 100000000.0){
        return [NSString stringWithFormat:@"%.2f亿",number / 100000000.0];
    }else if (ABS(number) > 10000 ) {
        return [NSString stringWithFormat:@"%.2f万",number / 10000.0];
    }
    else{
        return [NSString stringWithFormat:@"%.2f",number];
    }
}

- (UIView *)mainCurrencyView{
    if (!_mainCurrencyView) {
        _mainCurrencyView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5, 16 + 25, SCREEN_WIDTH * 0.5 - 16, 25 * 4)];
        _mainCurrencyView.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self.marketHeadView addSubview:_mainCurrencyView];
        _mainCurrencyView.hidden = YES;
    }
    return _mainCurrencyView;
}

- (void)createCurrencyBtn{
    [_mainCurrencyView removeAllSubviews];
    
    for (int index = 0; index < _curencyArray.count; index ++) {
        NSDictionary * subdict = _curencyArray[index];
        NSString * title = [NSString stringWithFormat:@"%@全网资金流向",[subdict objectForKey:@"base"]];
        UIButton* btn = [self createBtn:title frame:CGRectMake(0, 0 + index * 25, SCREEN_WIDTH * 0.5 - 16, 25)];
        btn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        btn.tag = 2600 + index;
        //        [self changeBtn:btn statusShowImg:NO];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.width - 5, 0, btn.imageView.width + 5)];
        btn.backgroundColor = backBlue;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseCurrency:) forControlEvents:UIControlEventTouchUpInside];
        [_mainCurrencyView addSubview:btn];
        if ([self.base isEqualToString:[subdict objectForKey:@"base"]]) {
            btn.backgroundColor = [UIColor colorWithHexString:@"5cacf3"];
        }
        
    }
}

- (void)chooseCurrency:(UIButton *)btn{
    
    NSDictionary * subdict = _curencyArray[btn.tag - 2600];
    self.base = [subdict objectForKey:@"base"];
    NSString * title = [NSString stringWithFormat:@"%@全网资金流向",[subdict objectForKey:@"base"]];
    [self requestHistoryfoundFlow];
    UIButton* propertyBtn = [self.marketHeadView viewWithTag:901];
    [propertyBtn setTitle:title forState:UIControlStateNormal];
    
    [self changeBtn:propertyBtn statusShowImg:2];
    _mainCurrencyView.hidden = YES;
}

- (void)changeBtn:(UIButton *)button statusShowImg:(int)hasImgIndex{
    if (hasImgIndex == 1) {
        [button setImage:[UIImage imageNamed:@"sort_down"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.width, 0, button.imageView.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.width+10, 0, -button.titleLabel.width - 10)];
        button.backgroundColor = [UIColor yellowColor];
    }if (hasImgIndex == 2) {
        [button setImage:[UIImage imageNamed:@"sort_down_gray"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.width, 0, button.imageView.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.width+10, 0, -button.titleLabel.width - 10)];
        button.backgroundColor = backBlue;
    }else{
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = backBlue;
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.width, 0, btn.imageView.width)];
        //        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.width, 0, -btn.titleLabel.width)];
    }
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

//- (NSArray *)itemArray{
//    if (!_itemArray) {
//        _itemArray = @[@"市场",@"币种",@"热度指数",@"空气指数",@"板块",@"平台"];
//    }
//    return _itemArray;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

