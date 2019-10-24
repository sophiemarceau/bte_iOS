//
//  BTEReplyListViewController.m
//  BTE
//
//  Created by wanmeizty on 5/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEReplyListViewController.h"
#import "CommontAndAnswerTableViewCell.h"
#import "ZTYInputTextView.h"
#import "BTELoginVC.h"
#import "FormatUtil.h"

@interface BTEReplyListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) ZTYInputTextView * inputView;
@property (copy,nonatomic) NSString * postReplyItmeId;
@property (strong,nonatomic) CommontAndAnwerModel * currentModel;
@property (strong,nonatomic) NSMutableArray * dataArray;
@property (assign,nonatomic) NSInteger pageNo;
@property (strong,nonatomic) UIView * headview;
@end

@implementation BTEReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentModel = self.commontModel;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(disback)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self createHeadView];
    // Do any additional setup after loading the view.
}

-(void)disback{
    if (self.fresh) {
        self.fresh();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestReplyList:0];
}



- (void)requestReplyList:(NSInteger)pageNo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    
    if (![self.commontModel.replyPostId isEqualToString:@""]) {
        [param setObject:self.commontModel.replyPostId forKey:@"postReplyId"];
    }else{
        [param setObject:self.commontModel.postReplyId forKey:@"postReplyId"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",pageNo] forKey:@"pageNo"];
    [param setObject:@"10" forKey:@"pageSize"];
    methodName = ComunityReplyListUrl;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (IsSafeDictionary(responseObject)) {
            
            if (pageNo == 0) {
                [self.dataArray removeAllObjects];
            }
            [weakSelf dealReplyData:responseObject];
        }
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        RequestError(error);
        
    }];
}

-(void)dealReplyData:(NSDictionary *)responseObject{
    NSDictionary * dataDict = [responseObject objectForKey:@"data"];
    NSDictionary * postReply = [dataDict objectForKey:@"postReply"];
    
    if (postReply != nil) {
        NSString * icon = [postReply objectForKey:@"icon"];
        UIImageView * iconView = [self.headview viewWithTag:11];
        [iconView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"community_headlog"]];
        
        
        UILabel *nameLabel = [self.headview viewWithTag:12];
        nameLabel.text = [postReply objectForKey:@"userName"];
        
        NSString * content = [postReply objectForKey:@"content"];
        UILabel *commontLabel = [self.headview viewWithTag:13];
        commontLabel.text = content;
        commontLabel.height = self.commontModel.height;
        self.headview.height = 45 + 20 + [FormatUtil getsizeWithText:content font:commontLabel.font width:(SCREEN_WIDTH - 32)].height;
    }
    
    NSArray * list = [dataDict objectForKey:@"postReplyItemlist"];
    
    for (NSDictionary * dict in list) {
        CommontAndAnwerModel * model = [[CommontAndAnwerModel alloc] init];
        [model initWidthDict:dict];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

- (void)requestReplyText:(NSString *)text{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    if (![self.commontModel.replyPostId isEqualToString:@""]) {
        [param setObject:self.commontModel.replyPostId forKey:@"postReplyId"];
    }else{
        [param setObject:self.commontModel.postReplyId forKey:@"postReplyId"];
    }
    if ([self.currentModel.postReplyItemId isEqualToString:@""]) {
        [param setObject:@"0" forKey:@"postReplyItemId"];
    }else{
        [param setObject:self.currentModel.postReplyItemId forKey:@"postReplyItemId"];
        
    }
    
    [param setObject:text forKey:@"content"];
    methodName = ComunityReplyCommontUrl;
    WS(weakSelf)
    [self.inputView hiddenKeyboard];
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"-1"]) {
                [weakSelf goLogin:@"您还没有登录，请登录后评论"];
            }else if([[responseObject objectForKey:@"code"] isEqualToString:@"0000"]){
                [self.tableView.mj_header beginRefreshing];
            }else{
                [BHToast showMessage:[responseObject objectForKey:@"message"]];
            }
        }
        
        
    } failure:^(NSError *error) {
        
        RequestError(error);
        
    }];
}

- (void)createHeadView{
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 161)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    self.headview = headView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [headView addGestureRecognizer:tap];
    
    UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 35, 35)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.commontModel.icon] placeholderImage:[UIImage imageNamed:@"community_headlog"]];
    iconView.tag = 11;
    [headView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 21, 200, 14)];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    nameLabel.textColor = backBlue;
    nameLabel.text = self.commontModel.userName;
    nameLabel.tag = 12;
    [headView addSubview:nameLabel];
    
    UILabel *commontLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 45, SCREEN_WIDTH - 16 - 61, 42)];
    commontLabel.numberOfLines = 0;
    commontLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    commontLabel.text = self.commontModel.content;
    commontLabel.height = self.commontModel.height;
    commontLabel.tag = 13;
    [headView addSubview:commontLabel];
    
    headView.height = 45 + 20 + self.commontModel.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 56 - HOME_INDICATOR_HEIGHT - NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = headView;
    self.tableView.backgroundColor = KBGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    WS(weakSelf)
    MJRefreshNormalHeader *commontheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo = 0;
        [weakSelf requestReplyList:weakSelf.pageNo];
    }];
    self.tableView.mj_header = commontheader;
    
    MJRefreshBackNormalFooter *commontfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestReplyList:++weakSelf.pageNo];
    }];
    self.tableView.mj_footer = commontfooter;
    
    ZTYInputTextView * inputView = [[ZTYInputTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 56 - HOME_INDICATOR_HEIGHT - NAVIGATION_HEIGHT, SCREEN_WIDTH, 56)];
    self.inputView = inputView;
    [self.view addSubview:inputView];
    inputView.finishBlock = ^(NSString * _Nonnull text) {
        [weakSelf requestReplyText:text];
    };
    inputView.beginBlock = ^{
        if (!User.isLogin) {
            [weakSelf goLogin:@"您还没有登录，请登录后回复"];
        }
    };
    
}

- (void)goLogin:(NSString *)msg{
    
    [self.inputView hiddenKeyboard];
    WS(weakSelf)
    [self alertTitle:@"" msg:msg sureTitle:@"去登录" cansleTitle:@"取消" sureblock:^{
        [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
            
            if (isComplete) {
                
            }
        }];
    } cancelBlock:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommontAndAnswerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"caa"];
    if (!cell) {
        cell = [[CommontAndAnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"caa"];
    }
    CommontAndAnwerModel * model = self.dataArray[indexPath.row];
    [cell configwithCommontAndAnswerModel:model isRead:self.isread];
    return cell;
}

-(void)tap{
    _currentModel = self.commontModel;
    [self.inputView setPlaceholderstr:@"回复评论"];
    [self.inputView hiddenKeyboard];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"isEdit===>%d",self.inputView.isEdit);
    if (self.inputView.isEdit) {
        _currentModel = self.commontModel;
        [self.inputView setPlaceholderstr:@"回复评论"];
        [self.inputView hiddenKeyboard];
    }else{
        CommontAndAnwerModel * model = self.dataArray[indexPath.row];
        [self.inputView setPlaceholderstr:[NSString stringWithFormat:@"回复 %@",model.sendUserName]];
        _currentModel = model;
        [self.inputView beginEidt];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommontAndAnwerModel * model = self.dataArray[indexPath.row];
    return model.height + 45 + 16;
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
