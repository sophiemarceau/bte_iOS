//
//  BTENewsViewController.m
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTENewsViewController.h"
#import "BTECommontModel.h"
#import "BTECommontTableViewCell.h"
#import "BTECommunityDescViewController.h"
#import "BTEAnswerTableViewCell.h"
#import "ZTYScreenshot.h"
#import "BTEShareView.h"
#import "CommontAndAnwerModel.h"
#import "CommontAndAnswerTableViewCell.h"
#import "BTEReplyListViewController.h"

@interface BTENewsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong,nonatomic) UIButton * distribuBtn;
@property (strong,nonatomic) UIButton * commontBtn;
@property (strong,nonatomic) UIScrollView * scrollview;
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) NSMutableArray * dataArray;
@property (strong,nonatomic) UITableView * commontTabelview;
@property (strong,nonatomic) NSMutableArray * commontArray;
@property (assign,nonatomic) NSInteger pageNo;
@end

@implementation BTENewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.commontArray = [NSMutableArray arrayWithCapacity:0];
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部已读" style:UIBarButtonItemStylePlain target:self action:@selector(allread)];
    self.navigationItem.rightBarButtonItem = homeButtonItem;
    [self createHeadView];
    
    [self addSubviews];
//    [self requestMyIssueList:0];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSInteger count = (long)self.scrollview.contentOffset.x/self.scrollview.bounds.size.width;
    if (count > 0) {
        [self requestMyCommontList:0];
    }else{
        [self requestMyIssueList:0];
    }
}

- (void)createHeadView{
    UIButton* distribuBtn = [self createBtn:CGRectMake(0, 0, 110, 30) title:@"我发布的"];
    [distribuBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    distribuBtn.backgroundColor = backBlue;
    [distribuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.distribuBtn = distribuBtn;
    
    UILabel *distibuteLabel = [self createLabel:CGRectMake(83, 2, 22, 16)];
    [distribuBtn addSubview:distibuteLabel];
    
    UIButton* commontBtn = [self createBtn:CGRectMake(110, 0, 110, 30) title:@"我评论的"];
    [commontBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    self.commontBtn = commontBtn;
    
    UILabel *commontLabel = [self createLabel:CGRectMake(83, 2, 22, 16)];
    [commontBtn addSubview:commontLabel];
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.view addSubview:headView];
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 220) * 0.5, 10, 220, 30)];
    titleView.layer.borderColor = backBlue.CGColor;
    titleView.layer.borderWidth = 1;
    titleView.layer.cornerRadius = 5;
    titleView.layer.masksToBounds = YES;
    [titleView addSubview:distribuBtn];
    [titleView addSubview:commontBtn];
    [headView addSubview:titleView];
}


- (void)addSubviews{
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT)];
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.scrollview.delegate = self;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.backgroundColor = KBGColor;
    [self.view addSubview:self.scrollview];
    
    UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scrollview.height) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.tableFooterView = [UIView new];
    tableview.backgroundColor = KBGColor;
    [self.scrollview addSubview:tableview];
    self.tableView = tableview;
    
    UITableView * commontTableview = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollview.height) style:UITableViewStylePlain];
    commontTableview.delegate = self;
    commontTableview.dataSource = self;
    commontTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    commontTableview.tableFooterView = [UIView new];
    commontTableview.backgroundColor = KBGColor;
    [self.scrollview addSubview:commontTableview];
    self.commontTabelview = commontTableview;
    
    WS(weakSelf)
    MJRefreshNormalHeader *issueheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo = 0;
        [weakSelf requestMyIssueList:weakSelf.pageNo];
    }];
    self.tableView.mj_header = issueheader;
    
    MJRefreshBackNormalFooter *issuefooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMyIssueList:++weakSelf.pageNo];
    }];
    self.tableView.mj_footer = issuefooter;
    
    MJRefreshNormalHeader *commontheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo = 0;
        [weakSelf requestMyCommontList:weakSelf.pageNo];
    }];
    self.commontTabelview.mj_header = commontheader;
    
    MJRefreshBackNormalFooter *commontfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMyCommontList:++weakSelf.pageNo];
    }];
    self.commontTabelview.mj_footer = commontfooter;
    
    
    
}

- (void)selectItem:(UIButton *)button{
    self.pageNo = 0;
    if (button == self.distribuBtn) {
        self.distribuBtn.backgroundColor = backBlue;
        [self.distribuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commontBtn.backgroundColor = [UIColor whiteColor];
        [self.commontBtn setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
        
        CGPoint contentOffset = self.scrollview.contentOffset;
        contentOffset.x = 0;
        [self.scrollview setContentOffset:contentOffset animated:YES];

        [self requestMyIssueList:self.pageNo];
    }else{

        self.commontBtn.backgroundColor = backBlue;
        [self.commontBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.distribuBtn.backgroundColor = [UIColor whiteColor];
        [self.distribuBtn setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
        
        CGPoint contentOffset = self.scrollview.contentOffset;
        contentOffset.x = SCREEN_WIDTH;
        [self.scrollview setContentOffset:contentOffset animated:YES];
        [self requestMyCommontList:self.pageNo];
    }
}

- (void)dealUnread:(NSDictionary *)dict{
    UILabel *myReleaseLabel = [self.distribuBtn viewWithTag:99];
    UILabel *myCommnetLabel = [self.commontBtn viewWithTag:99];
    if ([[dict objectForKey:@"myCommnetCount"] integerValue] > 0) {
        myCommnetLabel.hidden = NO;
        myCommnetLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"myCommnetCount"]];
    }else{
        myCommnetLabel.hidden = YES;
    }
    if ([[dict objectForKey:@"myReleaseCount"] integerValue] > 0) {
        myReleaseLabel.hidden = NO;
        myReleaseLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"myReleaseCount"]];
    }else{
        myReleaseLabel.hidden = YES;
    }
    
    
}

- (void)allread{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    NSInteger count = (long)self.scrollview.contentOffset.x/self.scrollview.bounds.size.width;
    if (count > 0) {
        [param setObject:@"2" forKey:@"readType"];
    }else{
        [param setObject:@"1" forKey:@"readType"];
    }
    
    methodName = ComunityReadallUrl;
    
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        
       
        if (IsSafeDictionary(responseObject)) {
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"0000"]) {
                if (count > 0) {
                    UILabel *myCommnetLabel = [self.commontBtn viewWithTag:99];
                    myCommnetLabel.hidden = YES;
                }else{
                    UILabel *myReleaseLabel = [self.distribuBtn viewWithTag:99];
                    myReleaseLabel.hidden = YES;
                }
            }
        }
        
        
    } failure:^(NSError *error) {
        
        RequestError(error);
        
    }];
}

- (void)requestMyIssueList:(NSInteger)pageNo{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [param setObject:[NSString stringWithFormat:@"%ld",pageNo] forKey:@"pageNo"];
    [param setObject:@"10" forKey:@"pageSize"];
    methodName = ComunityMyIssueListUrl;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (IsSafeDictionary(responseObject)) {
            
            NSDictionary * dataDict = [responseObject objectForKey:@"data"];
            [weakSelf dealUnread:dataDict];
            NSArray * list = [dataDict objectForKey:@"myRelease"];
            if (pageNo == 0) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dict in list) {
                BTECommontModel * model = [[BTECommontModel alloc] init];
                [model initWidthDict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        RequestError(error);
        
    }];
}

- (void)requestMyCommontList:(NSInteger)pageNo{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [param setObject:[NSString stringWithFormat:@"%ld",pageNo] forKey:@"pageNo"];
    [param setObject:@"10" forKey:@"pageSize"];
    methodName = ComunityMyCommontListUrl;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        
        [self.commontTabelview.mj_footer endRefreshing];
        [self.commontTabelview.mj_header endRefreshing];
        if (IsSafeDictionary(responseObject)) {
            
            NSDictionary * dataDict = [responseObject objectForKey:@"data"];
            [weakSelf dealUnread:dataDict];
            NSArray * list = [dataDict objectForKey:@"myComment"];
            if (pageNo == 0) {
                [self.commontArray removeAllObjects];
            }
            for (NSDictionary * dict in list) {
                CommontAndAnwerModel * model = [[CommontAndAnwerModel alloc] init];
                [model initWidthDict:dict];
                [self.commontArray addObject:model];
            }
            [self.commontTabelview reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [self.commontTabelview.mj_footer endRefreshing];
        [self.commontTabelview.mj_header endRefreshing];
        RequestError(error);
        
    }];
}

- (void)requestPriaseId:(NSString *)postId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [param setObject:postId forKey:@"postId"];
    methodName = ComunityPriaseUrl;
    
    [BTERequestTools requestWithURLString:methodName parameters:param type:4 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            
            if (![[responseObject objectForKey:@"code"] isEqualToString:@"0000"]) {
                [BHToast showMessage:[responseObject objectForKey:@"data"]];
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
        RequestError(error);
        
    }];
}


- (void)requestShare:(NSString *)postId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [param setObject:postId forKey:@"postId"];
    methodName = ComunityShareUrl;
    
    [BTERequestTools requestWithURLString:methodName parameters:param type:4 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            
            if (![[responseObject objectForKey:@"code"] isEqualToString:@"0000"]) {
                [BHToast showMessage:[responseObject objectForKey:@"data"]];
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
        RequestError(error);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return self.dataArray.count;
    }else{
        return self.commontArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        BTECommontTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commont"];
        if (!cell) {
            cell = [[BTECommontTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"commont"];
        }
        BTECommontModel * model = self.dataArray[indexPath.row];
        [cell configwithModel:model];
        WS(weakSelf)
        cell.btnClick = ^(NSInteger index) {
            if (index == 0) {
                
                UIImage * img = [ZTYScreenshot getCapture:model];
                [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:kGetcontractDogUrl sharetitle:nil shareDesc:nil shareType:UMS_SHARE_TYPE_IMAGE captionImg:img currentVc:weakSelf shareCompelete:^(BOOL isSuccess) {
                    [weakSelf requestShare:model.commontId];
                }];
            }else if (index == 1){
                BTECommontModel * model = weakSelf.dataArray[indexPath.row];
                BTECommunityDescViewController * descVC = [[BTECommunityDescViewController alloc] init];
                descVC.model = model;
                [weakSelf.navigationController pushViewController:descVC animated:YES];
            }else{
                [weakSelf requestPriaseId:model.commontId];
                
            }
        };
        return cell;
    }else{
        BTEAnswerTableViewCell * ancell = [tableView dequeueReusableCellWithIdentifier:@"answer"];
        if (!ancell) {
            ancell = [[BTEAnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"answer"];
        }
        [ancell configWithAnswer:self.commontArray[indexPath.row]];
        return ancell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView == tableView) {
        BTECommontModel * model = self.dataArray[indexPath.row];
        return (model.heigth + 30 + 40);
    }else{
        CommontAndAnwerModel * model = self.commontArray[indexPath.row];
        return (model.heightOfw32 + 16 + 45 + model.lastReplyContentHeight + 23);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableView == tableView) {
        BTECommontModel * model = self.dataArray[indexPath.row];
        BTECommunityDescViewController * descVC = [[BTECommunityDescViewController alloc] init];
        descVC.model = model;
        descVC.isRead = YES;
        [self.navigationController pushViewController:descVC animated:YES];
    }else{
        CommontAndAnwerModel * model = self.commontArray[indexPath.row];
        BTEReplyListViewController * replyVC = [[BTEReplyListViewController alloc] init];
        replyVC.commontModel = model;
        replyVC.isread = YES;
        [self.navigationController pushViewController:replyVC animated:YES];
    }
    
}

#pragma mark -- scrollview代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollview) {
        NSLog(@"减速结束 %f",(long)scrollView.contentOffset.x/scrollView.bounds.size.width);
        NSInteger count = (long)scrollView.contentOffset.x/scrollView.bounds.size.width;
        UIButton * button;
        if (count == 0) {
            button = self.distribuBtn;
        }else{
            button = self.commontBtn;
        }
        [self selectItem:button];
    }
}

- (UIButton *)createBtn:(CGRect)frame title:(NSString *)title{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
    return button;
}

- (UILabel *)createLabel:(CGRect)frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = @"10";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor=[UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = frame.size.height * 0.5;
    label.layer.masksToBounds =YES;
    label.tag = 99;
    label.hidden = YES;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
    return label;
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
