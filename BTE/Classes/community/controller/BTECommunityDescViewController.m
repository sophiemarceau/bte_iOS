//
//  BTECommunityDescViewController.m
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTECommunityDescViewController.h"
#import "BTELeftImgRightlabelView.h"
#import "FormatUtil.h"
#import "BTEEidtView.h"
#import "AnswerModel.h"
#import "CommontAndAnwerModel.h"
#import "CommontAndAnswerTableViewCell.h"
#import "ZTYScreenshot.h"
#import "BTEShareView.h"
#import "BTELoginVC.h"
#import "BTEReplyListViewController.h"
#import "ZTYInputTextView.h"

@interface BTECommunityDescViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (strong,nonatomic) UIView * itemView;
@property (strong,nonatomic) UIView * headView;
@property (strong,nonatomic) NSMutableArray * dataArray;
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) ZTYInputTextView * inputView;
@property (strong,nonatomic) CommontAndAnwerModel * currentModel;

@end

@implementation BTECommunityDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(disback)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self requestdetail:self.model.commontId freshIndex:-1];
    [self createView];
    
    // Do any additional setup after loading the view.
}

- (void)disback{
    if (self.fresh) {
        self.fresh();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)requestdetail:(NSString *)postId freshIndex:(NSInteger)freshindex{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [param setObject:postId forKey:@"postId"];
    methodName = ComunityDetailUrl;
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:param type:4 success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        if (IsSafeDictionary(responseObject)) {
            
            [weakSelf dealDetail:responseObject freshIndex:freshindex];
        }
        
        
    } failure:^(NSError *error) {
        
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
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"0000"]) {
                [self.tableView.mj_header beginRefreshing];
            }else{
                [BHToast showMessage:[responseObject objectForKey:@"data"]];
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
        RequestError(error);
        
    }];
}

- (void)requestReplyText:(NSString *)text{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [param setObject:self.currentModel.replyPostId forKey:@"postReplyId"];
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
                [self goLogin:@"您还没有登录，请登录后评论"];
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

- (void)requestIssueText:(NSString *)text{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString * methodName = @"";
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [param setObject:self.model.commontId forKey:@"postId"];
    [param setObject:text forKey:@"content"];
    methodName = ComunityAddCommontUrl;
    WS(weakSelf)
    [self.inputView hiddenKeyboard];
    [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
        
        
        if (IsSafeDictionary(responseObject)) {
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"-1"]) {
                [self goLogin:@"您还没有登录，请登录后评论"];
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

- (void)dealDetail:(NSDictionary *)responseObject freshIndex:(NSInteger)freshindex{
    
    
    NSDictionary * dataDict = [responseObject objectForKey:@"data"];
    [self.model initWidthDict:[dataDict objectForKey:@"post"]];
    
    UILabel * authorLabel = [self.headView viewWithTag:600];
    authorLabel.text = [NSString stringWithFormat:@"%@.%@",self.model.userName,self.model.postTime];
    UILabel * commontLabel = [self.headView viewWithTag:601];
    commontLabel.text = self.model.content;
    commontLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    CGSize size = [FormatUtil getsizeWithText:self.model.content font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] width:(SCREEN_WIDTH - 32)];
    commontLabel.height = size.height;
    
    self.itemView.y = size.height + 32;
    
    self.headView.height = size.height + 32 + 52 +40;
    
    BTELeftImgRightlabelView * shareBtn = [self.itemView viewWithTag:602];
    if (self.model.shareCount.integerValue > 0) {
        [shareBtn setUpImg:@"community_share" title:[NSString stringWithFormat:@" %@",self.model.shareCount]];
    }else{
        [shareBtn setUpImg:@"community_share" title:@"分享"];
    }
    
    BTELeftImgRightlabelView * priaseBtn = [self.itemView viewWithTag:603];
    if ([self.model.hasLike boolValue]) {
        [priaseBtn setUpImg:@"community_priaseed" title:self.model.likeCount];
        priaseBtn.selected = YES;
    }else{
        if (self.model.likeCount.integerValue > 0) {
            [priaseBtn setUpImg:@"community_priase" title:[NSString stringWithFormat:@" %@",self.model.likeCount]];
        }else{
            [priaseBtn setUpImg:@"community_priase" title:@"点赞"];
        }
        
        priaseBtn.selected = NO;
    }
    
    if (freshindex == -1) {
        
        
        [self.dataArray removeAllObjects];
        NSArray * list = [dataDict objectForKey:@"postReply"];
        for (NSDictionary * dict in list) {
            CommontAndAnwerModel * model = [[CommontAndAnwerModel alloc] init];
            [model initWidthDict:dict];
            [self.dataArray addObject:model];
        }
        
        UILabel * commontNumLabel = [self.itemView viewWithTag:604];
        commontNumLabel.text = [NSString stringWithFormat:@"%ld条评论",self.dataArray.count];
        [self.tableView reloadData];
    }else{
        
        NSArray * list = [dataDict objectForKey:@"postReply"];
        if (self.dataArray.count > freshindex && list.count > freshindex) {
            CommontAndAnwerModel * freshmodel = self.dataArray[freshindex];
            NSDictionary * subdict = list[freshindex];
            if ([freshmodel.replyPostId integerValue] == [[subdict objectForKey:@"replyPostId"] integerValue]) {
                [freshmodel initWidthDict:subdict];
                
                NSIndexPath * indexpath = [NSIndexPath indexPathForRow:freshindex inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
        }
        
        
        
    }
    
}

- (void)btnClick:(BTELeftImgRightlabelView *)btn{
    if (btn.tag == 602) {
        UIImage * img = [ZTYScreenshot getCapture:self.model];
        [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:kGetcontractDogUrl sharetitle:nil shareDesc:nil shareType:UMS_SHARE_TYPE_IMAGE captionImg:img currentVc:self shareCompelete:^(BOOL isSuccess) {
            [self requestShare:self.model.commontId];
        }];
    }else if (btn.tag == 603){
        if (User.isLogin) {
            
            
            if (!btn.selected) {
                BTELeftImgRightlabelView * priaseBtn = [self.itemView viewWithTag:603];
                NSString * praiseNum = @" 1";
                NSString * text = [priaseBtn getTextstring];
                if (![text isEqualToString:@" 点赞"]) {
                    praiseNum = [NSString stringWithFormat:@"%ld",[text integerValue] + 1];
                }
                [priaseBtn setUpImg:@"community_priaseed" title:praiseNum];
                btn.selected = YES;
            }
            [self requestPriaseId:self.model.commontId];
        }else{
            [self goLogin:@"您还没有登录，请登录后点赞"];
        }
        
        
    }
}

- (void)createView{
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40 + 52 + 75 + 32)];
    
    UILabel * authorLabel = [self createLabelTitle:@"" frame:CGRectMake(16, 16, SCREEN_WIDTH, 10)];
    authorLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    authorLabel.tag = 600;
    [self.headView addSubview:authorLabel];
    
    UILabel * commontLabel = [self createLabelTitle: self.model.content frame:CGRectMake(16, 32, SCREEN_WIDTH - 32, 75)];
    commontLabel.numberOfLines = 0;
    commontLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    CGSize size = [FormatUtil getsizeWithText:self.model.content font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] width:(SCREEN_WIDTH - 32)];
    commontLabel.height = size.height;
    commontLabel.tag = 601;
    [self.headView addSubview:commontLabel];
    
    
    self.itemView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height + 32, SCREEN_WIDTH, 40 + 52)];
    [self.headView addSubview:self.itemView];
    
    BTELeftImgRightlabelView * shareBtn = [[BTELeftImgRightlabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 95 - 16, 0, 40, 40)];
    [shareBtn setUpImg:@"community_share" title:self.model.shareCount];
    shareBtn.tag = 602;
    [shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.itemView addSubview:shareBtn];
    
    BTELeftImgRightlabelView * priaseBtn = [[BTELeftImgRightlabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 56, 0, 40, 40)];
    [priaseBtn setUpImg:@"community_priase" title:self.model.likeCount];
    priaseBtn.tag = 603;
    [priaseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.itemView addSubview:priaseBtn];
    
    UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 6)];
    lineview.backgroundColor = KBGColor;
    [self.itemView addSubview:lineview];
    
    UILabel * commontNumLabel = [self createLabelTitle:@"" frame:CGRectMake(16, 46, SCREEN_WIDTH - 32, 46)];
    commontNumLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    commontNumLabel.tag = 604;
    [self.itemView addSubview:commontNumLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 56 - HOME_INDICATOR_HEIGHT - NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    WS(weakSelf)
    MJRefreshNormalHeader *allheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestdetail:weakSelf.model.commontId freshIndex:-1];
    }];
    self.tableView.mj_header = allheader;

    ZTYInputTextView * inputView = [[ZTYInputTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 56 - HOME_INDICATOR_HEIGHT - NAVIGATION_HEIGHT, SCREEN_WIDTH, 56)];
    [inputView setPlaceholderstr:@"发表我的评论"];
    self.inputView = inputView;

    inputView.finishBlock = ^(NSString * _Nonnull text) {
        if (weakSelf.currentModel == nil) {
            [weakSelf requestIssueText:text];
        }else{
            [weakSelf requestReplyText:text];
        }


    };
    inputView.beginBlock = ^{
        if (!User.isLogin) {
            [weakSelf goLogin:@"您还没有登录，请登录后评论"];
        }
    };
    [self.view addSubview:inputView];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.headView addGestureRecognizer:tap];

}

-(void)tap{
    _currentModel = nil;
    [self.inputView setPlaceholderstr:@"发表我的评论"];
    [self.inputView hiddenKeyboard];
}

- (void)lookClick:(UIButton *)btn{
    CommontAndAnwerModel * model = self.dataArray[btn.tag];
    BTEReplyListViewController * replyVC = [[BTEReplyListViewController alloc] init];
    replyVC.commontModel = model;
    WS(weakSelf)
    replyVC.fresh = ^{
        [weakSelf requestdetail:self.model.commontId freshIndex:btn.tag];
    };
    [self.navigationController pushViewController:replyVC animated:YES];
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
    CommontAndAnswerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ac"];
    if (!cell) {
        cell = [[CommontAndAnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ac"];
    }
    CommontAndAnwerModel * model = self.dataArray[indexPath.row];
    [cell configwithModel:model readShow:self.isRead];
    
    cell.lookReplyBtn.tag = indexPath.row;
    [cell.lookReplyBtn addTarget:self action:@selector(lookClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommontAndAnwerModel * model = self.dataArray[indexPath.row];
    if (model.postReplyItemList.count > 0) {
        return model.height + 45 + 54;
    }else{
        return model.height + 45 + 16;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.inputView.isEdit) {
        _currentModel = nil;
        [self.inputView setPlaceholderstr:@"发表我的评论"];
        [self.inputView hiddenKeyboard];
    }else{
        CommontAndAnwerModel * model = self.dataArray[indexPath.row];
        _currentModel = model;
        [self.inputView setPlaceholderstr:[NSString stringWithFormat:@"回复 %@",_currentModel.userName]];
        [self.inputView beginEidt];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
