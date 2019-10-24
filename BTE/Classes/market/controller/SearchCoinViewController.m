//
//  SearchCoinViewController.m
//  BTE
//
//  Created by sophie on 2018/11/15.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "SearchCoinViewController.h"
#import "BTESortView.h"
#import "CoinTableViewCell.h"
#import "WLNetworkReloaderView.h"
#import "UITableView+WLEmptyPlaceHolder.h"

@interface SearchCoinViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIView *searchBgView;
    UIView *bgview;
    int current_page,total_count;
    NSString *coinNameStr;
}
@property(nonatomic,strong)UIView *searchBar;
@property(nonatomic,strong)UIImageView *searchImageView;
@property(nonatomic,strong)UITextField *searchtextField;
@property(nonatomic,strong)UIView *verticalLineView;
@property(nonatomic,strong)UIButton *cancelButton;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic,strong)  WLNetworkReloaderView *networkIndicatorView;
@end

@implementation SearchCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    coinNameStr = @"";
    self.view.backgroundColor = KBGCell;
    
    bgview = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH , NAVIGATION_HEIGHT - STATUS_BAR_HEIGHT)];
    bgview.backgroundColor = KBGCell;
    [self.view addSubview:bgview];
    
    searchBgView = [[UIView alloc] initWithFrame:CGRectMake(16, (bgview.height - 30)/2,304,30)];
    searchBgView.layer.masksToBounds = YES;
    searchBgView.layer.cornerRadius = 15;
    searchBgView.backgroundColor = BHHexColorAlpha(@"626A75", 0.09);
    [bgview addSubview:searchBgView];
    [searchBgView addSubview:self.searchImageView];
    [bgview addSubview:self.cancelButton];

    self.verticalLineView =  [[UIView alloc] initWithFrame:CGRectMake(self.searchImageView.right +7, (searchBgView.height - 18)/2, 1, 18)];
    self.verticalLineView.backgroundColor = BHHexColorAlpha(@"626A75", 0.6);
    [searchBgView addSubview:self.verticalLineView];
    [searchBgView addSubview:self.searchtextField];

    UIView *tableHeaderView = [self createTableHeadView:YES frame:CGRectMake(0, bgview.bottom, SCREEN_WIDTH, 34)];
    [self.view addSubview:tableHeaderView];
    [self.view addSubview:self.listView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"点击了搜索");
    NSString *coinStr = textField.text;
    if (![coinStr isEqualToString:@""]) {
        coinNameStr = coinStr;
        [self requestData];
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)cancelOnclick:(id)sender{
    [self.searchtextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestData{
    current_page = 0;
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:@"0" forKey:@"pageNo"];
    
    [pramaDic setObject:@"10" forKey:@"pageSize"];
    [pramaDic setObject:@"change" forKey:@"sort"];
    [pramaDic setObject:@"desc" forKey:@"sortType"];
    [pramaDic setObject:@"" forKey:@"exchange"];
    methodName = kCoinList;
    
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
    
    [pramaDic setObject:@"10" forKey:@"pageSize"];
    [pramaDic setObject:@"change" forKey:@"sort"];
    [pramaDic setObject:@"desc" forKey:@"sortType"];
    [pramaDic setObject:@"" forKey:@"exchange"];
    methodName = kCoinList;
    
    
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

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     [tableView tableViewDisplayView:self.networkIndicatorView ifNecessaryForRowCount:self.listArray.count];
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"market"];
    if (!cell) {
        cell = [[CoinTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"market"];
    }
    NSDictionary *celldict = [self.listArray objectAtIndex:indexPath.row];
//    NSString *flagStr = [NSString stringWithFormat:@"%lu",(unsigned long)flagIndex];
//    
//    cell.flagStr = flagStr;
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

-(UITextField *)searchtextField{
    if(_searchtextField == nil){
        _searchtextField = [[UITextField alloc] initWithFrame:CGRectMake(self.verticalLineView.right+12, 0, 267-18,  searchBgView.height)];
        _searchtextField.placeholder = @"请输入您要搜索的币种";
        _searchtextField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
        _searchtextField.delegate = self;//设置代理
    }
    return _searchtextField;
}

-(UIImageView *)searchImageView{
    if (_searchImageView == nil) {
        _searchImageView = [[UIImageView alloc] init];
        _searchImageView.image = [UIImage imageNamed:@"marketSearch"];
        _searchImageView.frame = CGRectMake(14, (searchBgView.height - 12)/2, 12,12 );
    }
    return _searchImageView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(UIButton *)cancelButton{
    if(_cancelButton == nil){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = UIFontRegularOfSize(14);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setTitleColor:backBlue forState:UIControlStateNormal];
        _cancelButton.frame = CGRectMake(SCREEN_WIDTH -50-3, 0, 50, NAVIGATION_HEIGHT -STATUS_BAR_HEIGHT) ;
        [_cancelButton addTarget:self  action:@selector(cancelOnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
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

-(UITableView *)listView{
    if (_listView == nil) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, bgview.bottom + 34  , SCREEN_WIDTH, SCREEN_HEIGHT  - NAVIGATION_HEIGHT  - 34)];
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

- (WLNetworkReloaderView *) networkIndicatorView{
    if(_networkIndicatorView == nil) {
        _networkIndicatorView = [[WLNetworkReloaderView alloc] initWithFrame:self.listView.bounds];
    }
    return _networkIndicatorView;
}
@end
