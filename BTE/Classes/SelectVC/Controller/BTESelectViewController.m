//
//  BTESelectViewController.m
//  BTE
//
//  Created by wanmeizty on 22/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTESelectViewController.h"
#import "BTESortView.h"
#import "ZTYCoinTableViewCell.h"
#import "BTEKlineViewController.h"
#import "UserStatistics.h"
#import "HomeDesListModel.h"
#import "BTELoginVC.h"
#import "TestJSObject.h"
#import "BTESearchViewController.h"
#import "SecondaryLevelWebViewController.h"
#import "ZTYSortHeadView.h"


@interface BTESelectViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UIButton * selectBtn;
@property (strong,nonatomic) UIButton * propertyBtn;
@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) UITableView * tableview;
@property (strong,nonatomic) NSArray * optionList;
@property (strong,nonatomic) UIWebView * webview;

@end

@implementation BTESelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigate];
    
    self.view.backgroundColor = backBlue;
    [self createScrollView];
    [self createAddOptionView];
    [self createSubViews];
    [self requestOptionListData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:NotificationRefreshTradeList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeb) name:NotificationRefreshWebBassets object:nil];
    // Do any additional setup after loading the view.
}

- (void)update{
    [self requestOptionListData];
}

- (void)updateWeb{
    [self.webview reload];
    
}

- (void)createNavigate{
    self.navigationItem.titleView = [self createTitleView];
    
}

- (void)disback{
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.webview reload];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kAppAssetsAddress]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    [self requestOptionListData];
}

#pragma mark -- 请求网络
- (void)requestOptionListData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    
    methodName = optionMarketList;
    
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        [self.tableview.mj_header endRefreshing];
        if (IsSafeDictionary(responseObject)) {
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"-1"]) {
                User.isLogin = NO;
                self.tableview.hidden = YES;
            }else{
                NSDictionary * data = [responseObject objectForKey:@"data"];
                
                
                self.optionList = [NSArray arrayWithArray:[data objectForKey:@"result"]];
                if (self.optionList.count == 0 ) {
                    self.tableview.hidden = YES;
                }else{
                    self.tableview.hidden = NO;
                }
                [self.tableview reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        
        RequestError(error);
        //        NSLog(@"error-------->%@",error);
        
    }];
}

#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.optionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZTYCoinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"market"];
    if (!cell) {
        cell = [[ZTYCoinTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"market"];
    }
    NSDictionary * celldict = [self.optionList objectAtIndex:indexPath.row];
    [cell configwidth:celldict];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * celldict  = [self.optionList objectAtIndex:indexPath.row];;
    
    HomeDesListModel * delistModel = [[HomeDesListModel alloc] init];
    [delistModel initDict:celldict];
    [self goToKLineVC:delistModel];
}

- (void)goToKLineVC:(HomeDesListModel *)delistModel{
    [UserStatistics sendEventToServer:@"进入K线"];
    BTEKlineViewController *homePageVc= [[BTEKlineViewController alloc] init];
    homePageVc.desListModel = delistModel;
    [self.navigationController pushViewController:homePageVc animated:YES];
}

#pragma mark -- webview 代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // 请求的地址
    NSString *url = request.URL.absoluteString;
    NSLog(@"url--->%@",url);
    // 判断url是否是我们在webViewDidFinishLoad中给轮播图增加的自定义方法
    // 如果是，在判断中增加自己的跳转操作
    if ([url isEqualToString:@"tz:newTab"]) {
        NSLog(@"跳转到新tab页面");
    
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx{
    TestJSObject *testJO=[TestJSObject new];
    testJO.delegate = self;
    ctx[@"bteApp"]=testJO;
    ctx[@"viewController"] = self;
    ctx.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"JSContext------>异常信息：%@", exceptionValue);
    };
}

-(void)go2PageVc:(NSDictionary *)obj{
    NSLog(@"%@",obj);
    if (obj != nil) {
        NSString *action = [obj objectForKey:@"action"];
        dispatch_async(dispatch_get_main_queue(), ^{

            if ([action isEqualToString:@"addAseets"]) {
                SecondaryLevelWebViewController * secondvc = [[SecondaryLevelWebViewController alloc] init];
                secondvc.urlString = [NSString stringWithFormat:@"%@",[obj objectForKey:@"jsonStr"]];
                secondvc.isHiddenLeft = YES;
                secondvc.isHiddenBottom = NO;
                secondvc.isFromReviewLuZDog = YES;
                [self.navigationController pushViewController:secondvc animated:YES];
            }
                                                              
            
        });
    }
}

- (void)createAddOptionView{
    UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 88) * 0.5, (SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 34 - 49 - 88) * 0.5 , 88, 88)];
    [addBtn addTarget:self action:@selector(addOption) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:addBtn];
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 64, 64)];
    imageview.layer.borderColor = backBlue.CGColor;
    imageview.layer.borderWidth = 1;
    imageview.layer.cornerRadius = 5;
    imageview.layer.masksToBounds = YES;
    [addBtn addSubview:imageview];
    
    CGFloat lineW = 2;
    UIView * lineS = [[UIView alloc] initWithFrame:CGRectMake((64 - lineW) * 0.5, (64 - 25) * 0.5, lineW, 25)];
    lineS.backgroundColor = backBlue;
    [imageview addSubview:lineS];
    
    UIView * lineH = [[UIView alloc] initWithFrame:CGRectMake((64 - 25) * 0.5, (64 - lineW) * 0.5, 25, lineW)];
    lineH.backgroundColor = backBlue;
    [imageview addSubview:lineH];
    
    UILabel * bottomLabel = [self createLabelTitle:@"点击添加自选" frame:CGRectMake(0, 74, 88, 14)];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.textColor = backBlue;
    bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [addBtn addSubview:bottomLabel];
}

- (void)createSubViews{
    
    UIView * headView = [self createTableHeadView:NO frame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    [self.scrollView addSubview:headView];
    
    UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 34 - 49) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview = tableview;
    UIButton * footBtn =  [self createBtn:CGRectMake(0, 0, SCREEN_WIDTH, 44) title:@"+添加自选"];
    footBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [footBtn setTitleColor:backBlue forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(addOption) forControlEvents:UIControlEventTouchUpInside];
    footBtn.backgroundColor = [UIColor whiteColor];
    self.tableview.tableFooterView = footBtn;//[UIView new];
    tableview.rowHeight = [ZTYCoinTableViewCell cellHeight];
    self.tableview.backgroundColor = KBGColor;
    [self.scrollView addSubview:tableview];
    
    WS(weakSelf)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestOptionListData];
    }];
    self.tableview.mj_header = header;
    
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 49)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kAppAssetsAddress]];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"https://m.baidu.com"]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    self.webview.delegate = self;
    [self.webview loadRequest:request];
    self.webview.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.webview];
}

- (void)createScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
}

- (UIView *)createTableHeadView:(BOOL)sortShow frame:(CGRect)frame{
//    UIView * tablewHeadview = [[UIView alloc] initWithFrame:frame];
////    UILabel * baseLabel = [self createLabelTitle:@"币种" frame:CGRectMake(16, 0, 80, 34)];
////    baseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
////    [tablewHeadview addSubview:baseLabel];
//    BTESortView * amountBtn = [[BTESortView alloc] initWithFrame:CGRectMake(16, 0, 72, 34) withTitle:@"币种/成交额" canSort:sortShow position:NSTextAlignmentLeft];
////    [amountBtn setTitle:@"币种/成交额"];
////    [amountBtn sortShow:sortShow];
//    [amountBtn changeStatus:NO];
//
//    [amountBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
//    amountBtn.tag = 30;
//    [tablewHeadview addSubview:amountBtn];
//
//
//    UILabel * priceLabel = [self createLabelTitle:@"价格" frame:CGRectMake(172, 0, 50, 34)];
//    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//    [tablewHeadview addSubview:priceLabel];
//
//    BTESortView *descBtn = [[BTESortView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 72 - 16, 0, 72, 34) withTitle:@"24h涨幅" canSort:sortShow position:NSTextAlignmentRight];
////    BTESortView *descBtn = [[BTESortView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 49 - 16, 0, 49, 34)];
////    [descBtn setTitle:@"24h涨幅"];
////    [descBtn sortShow:sortShow];
//    [descBtn changeStatus:NO];
//    [descBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
//    descBtn.tag = 31;
//    [tablewHeadview addSubview:descBtn];
//
//    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    line.backgroundColor = LineBGColor;
//    [tablewHeadview addSubview:line];
//    UIView * bline = [[UIView alloc] initWithFrame:CGRectMake(0, 33.5, SCREEN_WIDTH, 0.5)];
//    bline.backgroundColor = LineBGColor;
//    [tablewHeadview addSubview:bline];
//    return tablewHeadview;
    NSArray * sorttitles = @[@"币种/成交额",@"价格",@"净成交额(24h)"];
    NSArray * canSorts = @[@(NO),@(NO),@(NO)];
    NSArray * sortAlgins = @[@(NSTextAlignmentLeft),@(NSTextAlignmentRight),@(NSTextAlignmentRight)];
    ZTYSortHeadView * tablewHeadview = [[ZTYSortHeadView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 34) sortTitles:sorttitles isCanSorts:canSorts aligns:sortAlgins];
    return tablewHeadview;
}

- (UIView *)createTitleView{
    
    UIButton* selectBtn = [self createBtn:CGRectMake(0, 0, 110, 30) title:@"我的自选"];
    [selectBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.backgroundColor = backBlue;
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectBtn = selectBtn;
    
    UIButton* propertyBtn = [self createBtn:CGRectMake(110, 0, 110, 30) title:@"我的资产"];
    [propertyBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    self.propertyBtn = propertyBtn;
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 220) * 0.5, 6, 220, 30)];
    titleView.layer.borderColor = backBlue.CGColor;
    titleView.layer.borderWidth = 1;
    titleView.layer.cornerRadius = 5;
    titleView.layer.masksToBounds = YES;
    [titleView addSubview:selectBtn];
    [titleView addSubview:propertyBtn];

    return titleView;
}

- (void)sortClick:(BTESortView *)sender{
    if (sender.tag == 30) {
        
    }else{
        
    }
}

- (void)addOption{
    if (!User.isLogin) {
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            
        }];
        return;
    }else{
        BTESearchViewController * searchVC = [[BTESearchViewController alloc] init];
        searchVC.optionList = self.optionList;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSLog(@"减速结束 %f",(long)scrollView.contentOffset.x/scrollView.bounds.size.width);
        NSInteger count = (long)scrollView.contentOffset.x/scrollView.bounds.size.width;
        UIButton * button;
        if (count == 0) {
            button = self.selectBtn;
        }else{
            button = self.propertyBtn;
        }
        [self selectItem:button];
    }
}

- (void)selectItem:(UIButton *)button{
    // 我的自选
    if (button == self.selectBtn) {
        self.selectBtn.backgroundColor = backBlue;
        [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.propertyBtn.backgroundColor = [UIColor whiteColor];
        [self.propertyBtn setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
        
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.x = 0;
        [self.scrollView setContentOffset:contentOffset animated:YES];
        
    }else{
        
        self.propertyBtn.backgroundColor = backBlue;
        [self.propertyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectBtn.backgroundColor = [UIColor whiteColor];
        [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
        
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.x = SCREEN_WIDTH;
        [self.scrollView setContentOffset:contentOffset animated:YES];
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

- (UIButton *)createBtn:(CGRect)frame title:(NSString *)title{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
    return button;
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
