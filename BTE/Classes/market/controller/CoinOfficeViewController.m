//
//  CoinOfficeViewController.m
//  BTE
//
//  Created by sophie on 2018/11/14.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "CoinOfficeViewController.h"
#import "BTESortView.h"
#import "CoinTableViewCell.h"
#import "BTEMarketTableViewCell.h"

@interface CoinOfficeViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    int current_page,total_count;
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIWebView *webview;
@property(nonatomic,strong)UITableView *listView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation CoinOfficeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"平台详情";
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    [self initSubViews];
    self.exchangeStr = @"";
    [self requestData];
}

-(void)requestData{
    current_page = 0;
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:@"0" forKey:@"pageNo"];
    [pramaDic setObject:@"10" forKey:@"pageSize"];
    [pramaDic setObject:@"change" forKey:@"sort"];
    [pramaDic setObject:@"desc" forKey:@"sortType"];
    [pramaDic setObject:self.exchangeStr forKey:@"exchange"];
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
    [pramaDic setObject:@"0" forKey:@"pageNo"];
    [pramaDic setObject:@"10" forKey:@"pageSize"];
    [pramaDic setObject:@"change" forKey:@"sort"];
    [pramaDic setObject:@"desc" forKey:@"sortType"];
    [pramaDic setObject:self.exchangeStr forKey:@"exchange"];
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


//- (UIView *)createTitleView{
//
//    UIButton* selectBtn = [self createBtn:CGRectMake(0, 0, 110, 30) title:@"我的自选"];
//    [selectBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
//    selectBtn.backgroundColor = backBlue;
//    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.selectBtn = selectBtn;
//
//    UIButton* propertyBtn = [self createBtn:CGRectMake(110, 0, 110, 30) title:@"我的资产"];
//    [propertyBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
//    self.propertyBtn = propertyBtn;
//
//    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 220) * 0.5, 6, 220, 30)];
//    titleView.layer.borderColor = backBlue.CGColor;
//    titleView.layer.borderWidth = 1;
//    titleView.layer.cornerRadius = 5;
//    titleView.layer.masksToBounds = YES;
//    [titleView addSubview:selectBtn];
//    [titleView addSubview:propertyBtn];
//
//    return titleView;
//}

//- (void)selectItem:(UIButton *)button{
//    // 我的自选
//    if (button == self.selectBtn) {
//        self.selectBtn.backgroundColor = backBlue;
//        [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.propertyBtn.backgroundColor = [UIColor whiteColor];
//        [self.propertyBtn setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
//
//        CGPoint contentOffset = self.scrollView.contentOffset;
//        contentOffset.x = 0;
//        [self.scrollView setContentOffset:contentOffset animated:YES];
//
//    }else{
//
//        self.propertyBtn.backgroundColor = backBlue;
//        [self.propertyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.selectBtn.backgroundColor = [UIColor whiteColor];
//        [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
//
//        CGPoint contentOffset = self.scrollView.contentOffset;
//        contentOffset.x = SCREEN_WIDTH;
//        [self.scrollView setContentOffset:contentOffset animated:YES];
//    }
//
//
//}
-(void)initSubViews{
    self.view.backgroundColor = KBGCell;
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"概览",@"交易对",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake((SCREEN_WIDTH - 220)/2, 16, 220  , 30); // 0.3642*CFW
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor = KBGCell;
    
    //    segmentedControl.layer.masksToBounds = YES;               //    默认为no，不设置则下面一句无效
    //
    //    segmentedControl.layer.cornerRadius = 8;               //    设置圆角大小，同UIView
    //
    //    segmentedControl.layer.borderWidth = 1.5;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    
    segmentedControl.layer.borderColor = BHColorBlue.CGColor; //     边框颜色
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = BHColorBlue;
    //    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],} forState:UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:BHHexColorAlpha(@"626A75", 0.6),NSFontAttributeName:UIFontRegularOfSize(13)} forState:UIControlStateNormal];
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    [self.view addSubview:self.scrollView];
}


-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    //我定义了一个 NSInteger tag，是为了记录我当前选择的是分段控件的左边还是右边。
    NSInteger selecIndex = sender.selectedSegmentIndex;
     CGPoint contentOffset = self.scrollView.contentOffset;
    switch(selecIndex){
        case 0:
//            leftTable.hidden = NO;
//            rightTable.hidden = YES;
            sender.selectedSegmentIndex=0;
            contentOffset.x = 0;
          
            [self.scrollView setContentOffset:contentOffset animated:YES];
//            tag = 0;
//            [leftTable reloadData];
            break;
            
        case 1:
//            leftTable.hidden = YES;
//            rightTable.hidden = NO;
            sender.selectedSegmentIndex = 1;
            contentOffset.x = SCREEN_WIDTH;
            [self.scrollView setContentOffset:contentOffset animated:YES];
//            tag=1;
//            [rightTable reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.listArray.count;
//    return 10;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return  64;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTEMarketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"market"];
    if (!cell) {
        cell = [[BTEMarketTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"market"];
    }
    NSDictionary * celldict = [self.listArray objectAtIndex:indexPath.row];
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

- (UIScrollView *)scrollView{
    if(_scrollView == nil){
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 62, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - 62)];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        self.scrollView.delegate = self;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.pagingEnabled = YES;
        [self.scrollView addSubview:self.webview];
        [self.scrollView addSubview:self.listView];
    }
    return _scrollView;
}


-(UIWebView *)webview{
    if(_webview == nil){
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height)];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kAppAssetsAddress]];
        //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"https://m.baidu.com"]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        _webview.delegate = self;
        [_webview loadRequest:request];
       _webview.backgroundColor = [UIColor whiteColor];
    }
    return _webview;
}

-(UITableView *)listView{
    if(_listView == nil){
        UIView  *listHeaderView = [self createTableHeadView:NO frame:CGRectMake(SCREEN_WIDTH, 0,SCREEN_WIDTH, 34)];
        listHeaderView.backgroundColor = KBGCell;
        [self.scrollView addSubview:listHeaderView];
        
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, listHeaderView.height, SCREEN_WIDTH,self.scrollView.height -listHeaderView.height) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.tableFooterView = [UIView new];
        _listView.rowHeight = [CoinTableViewCell cellHeight];
        _listView.backgroundColor = KBGColor;

        WS(weakSelf)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestData];
        }];
        _listView.mj_header = header;
        
        MJRefreshBackNormalFooter *allfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf giveMeMoreData];
        }];
        _listView.mj_footer = allfooter;
        _listView.mj_footer.ignoredScrollViewContentInsetBottom = HOME_INDICATOR_HEIGHT;
    }
    return _listView;
}

- (UIView *)createTableHeadView:(BOOL)sortShow frame:(CGRect)frame{
    UIView *tablewHeadview = [[UIView alloc] initWithFrame:frame];
    //    UILabel * baseLabel = [self createLabelTitle:@"币种" frame:CGRectMake(16, 0, 80, 34)];
    //    baseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    //    [tablewHeadview addSubview:baseLabel];
    BTESortView * amountBtn = [[BTESortView alloc] initWithFrame:CGRectMake(16, 0, 82, 34) withTitle:@"币种/成交额" canSort:sortShow position:NSTextAlignmentLeft];
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
    
    BTESortView *descBtn = [[BTESortView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 72 - 16, 0, 72, 34) withTitle:@"24h涨跌幅" canSort:sortShow position:NSTextAlignmentRight];
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

- (UILabel *)createLabelTitle:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    return label;
}
@end
