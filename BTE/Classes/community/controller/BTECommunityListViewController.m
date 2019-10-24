//
//  BTECommunityListViewController.m
//  BTE
//
//  Created by wanmeizty on 26/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTECommunityListViewController.h"
#import "BTEEidtView.h"
#import "BTECommontModel.h"
#import "BTECommontTableViewCell.h"
#import "BTEEidtViewController.h"
#import "BTECommunityDescViewController.h"
#import "BTENewsViewController.h"
#import "BTEShareView.h"
#import "ZTYScreenshot.h"
#import "BTELoginVC.h"

@interface BTECommunityListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) NSMutableArray * dataArray;
@property (assign,nonatomic) NSInteger pageNo;
@property (strong,nonatomic) UILabel * totalLabel;
@property (assign,nonatomic) BOOL ispartfresh;
@end

@implementation BTECommunityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.dataArray = [[NSMutableArray alloc] init];
    [self requestList:0 freshIndex:-1];
    [self createNavigate];
    [self addViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_ispartfresh) {
        [self.tableView.mj_header beginRefreshing];
    }
//    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
//    item.badgeValue=[NSString stringWithFormat:@"%d",10];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.ispartfresh = NO;
}

- (void)requestList:(NSInteger)pageNo freshIndex:(NSInteger)freshIndex{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    if (freshIndex == -1) {
        [param setObject:[NSString stringWithFormat:@"%ld",pageNo] forKey:@"pageNo"];
    }else{
        [param setObject:[NSString stringWithFormat:@"%ld",freshIndex/10] forKey:@"pageNo"];
    }
    
    [param setObject:@"10" forKey:@"pageSize"];
    methodName = ComunityCommontListUrl;
    
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (IsSafeDictionary(responseObject)) {
            
            NSDictionary * dataDict = [responseObject objectForKey:@"data"];
            NSInteger total = [[dataDict objectForKey:@"total"] integerValue];
            if (total > 0) {
                self.totalLabel.text = [NSString stringWithFormat:@"%ld",total];
                self.totalLabel.hidden = NO;
            }else{
                self.totalLabel.hidden = YES;
            }
            NSArray * list = [dataDict objectForKey:@"postlist"];
            if (freshIndex == -1) {
                if (pageNo == 0) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary * dict in list) {
                    BTECommontModel * model = [[BTECommontModel alloc] init];
                    [model initWidthDict:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }else{
                
                if (self.dataArray.count > freshIndex) {
                    BTECommontModel *freshmodel = self.dataArray[freshIndex];
                    for (NSDictionary * subdict in list) {
                        if ([freshmodel.commontId integerValue] == [[subdict objectForKey:@"id"] integerValue]) {
                            [freshmodel initWidthDict:subdict];
                            
                            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:freshIndex inSection:0];
                            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                            break;
                        }
                    }
                    
                }
                
            }
        }
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
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

- (void)requestUserLoginStatus{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    methodName = kGetUserLoginInfo;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        
        if (IsSafeDictionary(responseObject)) {
            
            if ([[responseObject objectForKey:@"data"] boolValue]) {
                BTENewsViewController * newvc = [[BTENewsViewController alloc] init];
                [weakSelf.navigationController pushViewController:newvc animated:YES];
            }else{
                [weakSelf goLogin:@"你还没有登录，请先登录后进入消息中心"];
            }

        }

        
    } failure:^(NSError *error) {

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
            
            if ([[responseObject objectForKey:@"code"] integerValue] != 0) {
                [BHToast showMessage:[responseObject objectForKey:@"data"]];
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
        RequestError(error);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTECommontTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commont"];
    if (!cell) {
        cell = [[BTECommontTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"commont"];
    }
    BTECommontModel * model = self.dataArray[indexPath.row];
    
    [cell configNoReadwithModel:model];
    WS(weakSelf)
    cell.btnClick = ^(NSInteger index) {
        if (index == 0) {
            
            UIImage * img = [ZTYScreenshot getCapture:model];
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:kGetcontractDogUrl sharetitle:nil shareDesc:nil shareType:UMS_SHARE_TYPE_IMAGE captionImg:img currentVc:weakSelf shareCompelete:^(BOOL isSuccess) {
                [weakSelf requestShare:model.commontId];
            }];
        }else if (index == 1){
            BTECommontModel * model = self.dataArray[indexPath.row];
            BTECommunityDescViewController * descVC = [[BTECommunityDescViewController alloc] init];
            descVC.model = model;
            descVC.fresh = ^{
                weakSelf.ispartfresh = YES;
                [weakSelf requestList:weakSelf.pageNo freshIndex:indexPath.row];
            };
            [self.navigationController pushViewController:descVC animated:YES];
        }else{
            if (!User.isLogin) {
                [self goLogin:@"您还没有登录，请登录后点赞"];
            }else{
                [weakSelf requestPriaseId:model.commontId];
            }
            
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTECommontModel * model = self.dataArray[indexPath.row];
    return (model.heigth + 30 + 40);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BTECommontModel * model = self.dataArray[indexPath.row];
    BTECommunityDescViewController * descVC = [[BTECommunityDescViewController alloc] init];
    descVC.model = model;
    WS(weakSelf)
    descVC.fresh = ^{
        weakSelf.ispartfresh = YES;
        [weakSelf requestList:weakSelf.pageNo freshIndex:indexPath.row];
    };
    [self.navigationController pushViewController:descVC animated:YES];
}

- (void)goLogin:(NSString *)msg{
    WS(weakSelf)
    
    [self alertTitle:@"" msg:msg sureTitle:@"去登录" cansleTitle:@"取消" sureblock:^{
        [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
            
            if (isComplete) {
                
            }
        }];
    } cancelBlock:^{
        
    }];
}

- (void)addViews{
    
    BTEEidtView * editView = [[BTEEidtView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [editView addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT - 50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = KBGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    WS(weakSelf)
    MJRefreshNormalHeader *allheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo = 0;
        [weakSelf requestList:weakSelf.pageNo freshIndex:-1];
    }];
    self.tableView.mj_header = allheader;
    
    MJRefreshBackNormalFooter *allfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestList:++weakSelf.pageNo freshIndex:-1];
    }];
    self.tableView.mj_footer = allfooter;
}

- (void)edit:(BTEEidtView *)btn{
    BTEEidtViewController * editVC = [[BTEEidtViewController alloc] init];
    editVC.distrubBlock = ^{
        [BHToast showMessage:[NSString stringWithFormat:@"系统审核后将发布在社区"]];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)news{
    [self requestUserLoginStatus];
}

- (void)createNavigate{
    
    UIButton * homeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [homeButton setImage:[UIImage imageNamed:@"community_news"] forState:UIControlStateNormal];
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton addTarget:self action:@selector(news) forControlEvents:UIControlEventTouchUpInside];
    CGFloat width = 22;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(44 - 18 - 18 * 0.5 + 2, (44 - width - 18) * 0.5, width, 16)];
    label.text = @"10";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor=[UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius=8;
    label.layer.masksToBounds =YES;
    label.hidden = YES;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
    self.totalLabel = label;
    [homeButton addSubview:label];
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = homeButtonItem;

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
