//
//  PersonalCenterViewController.m
//  BTE
//
//  Created by sophie on 2018/10/8.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "BTEFeedBackViewController.h"
#import "YUFoldingTableView.h"
#import "YUCustomHeaderView.h"
#import "PersonalSettingViewController.h"
#import "BTELoginVC.h"
#import "StrageyHeaderView.h"
#import "FollowHeaderView.h"
#import "NormalITableItem.h"
#import "NormalTableCellTableViewCell.h"
#import "inviteTableViewCell.h"
#import "StraegyItem.h"
#import "StraegyTableViewCell.h"
#import "BTEBtcAccount.h"
#import "BTELegalAccount.h"
#import "BTEAccountDetailsModel.h"
#import "SecondaryLevelWebViewController.h"
#import "ServicesSetViewController.h"

@interface PersonalCenterViewController () <UITableViewDelegate,UITableViewDataSource>{
    UIView *navView;
    UIView *menuView,*contentView;
    UIImageView *lineView;
    UIImageView *blueLineView;
    NSString *telStr ,*nickNameStr,*emailStr,*headPicStr;
    UILabel *nickNameLabel;
    UIImageView *headerImageView;
    BTELegalAccount *legalAccountModel;
    BTEBtcAccount *btcAccountModel;
    
    NSString *holdCountStr,*settleCountStr;
    NSString *friendsStr;
    NSString *assetNumStr;
    UILabel *descriptionLabel;
    UIImageView *arrowImageView;
    UIView *accountView;
    UILabel *contenttitleLabel;
    UIImageView *contentViewarrowImageView;
    UIButton *followButton;
    UIButton *personalView;
    UILabel  *hiddenTitleLabel;
    UILabel  *hiddendesLabel;
    NSString *pointStr;
    UIButton *hiddenbtn;
}
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UITableView *foldFooterTableView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, assign) Boolean selectFlag;
@property (nonatomic, assign) Boolean selectHistrategyFlag;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *strategyArray;
@property (nonatomic, strong) NSMutableArray *historyStrategyArray;
@property (nonatomic, strong) NSMutableArray *accountArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *btnViewsArray;
@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initSubViews];
    if (User.userToken) {
        [self getMyAccountLoginStatus];
    }
}

-(void)initData{
    self.selectFlag = NO;
    self.selectHistrategyFlag = NO;
    [self.listArray removeAllObjects];
    self.listArray = [NSMutableArray arrayWithCapacity:0];
}

-(void)initSubViews{
    [self initNavView];
    [self initTalbeHeaderView];
    [self initFoldingTableView];
}

-(void)initNavView{
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_HEIGHT)];
    [self.view addSubview:navView];
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_HEIGHT-STATUS_BAR_HEIGHT)];
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.font = [UIFont systemFontOfSize:18];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.text = @"个人中心";
    [navView addSubview:navTitleLabel];
    navView.backgroundColor = BHHexColor(@"#168CF0");
}

-(void)initTalbeHeaderView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.listView];
    self.listView.hidden = YES;

    personalView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    personalView.backgroundColor = BHHexColor(@"#168CF0");
    
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 60 -32 - 24, 32, 32)];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = 16;
    headerImageView.layer.borderColor = BHHexColorAlpha(@"626A75",0.5).CGColor;
    [personalView addSubview:headerImageView];
    
    nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 60-17-31, SCREEN_WIDTH/2, 17)];
    nickNameLabel.textColor = [UIColor whiteColor];
    [personalView addSubview:nickNameLabel];
    arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowPersonal"]];
    arrowImageView.frame = CGRectMake(SCREEN_WIDTH - 8- 17, 60 -14 -35, 8, 14);
    [personalView addSubview:arrowImageView];
    [personalView addTarget:self action:@selector(gotoPersonalVc) forControlEvents:UIControlEventTouchUpInside];
    
    accountView = [[UIView alloc] initWithFrame:CGRectMake(0, personalView.bottom+16, SCREEN_WIDTH, 124)];
    accountView.backgroundColor =  BHHexColor(@"#FAFAFA");
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH -16, 16)];
    accountLabel.text = @"我的账户";
    accountLabel.textAlignment = NSTextAlignmentLeft;
    accountLabel.font = UIFontMediumOfSize(16);
    accountLabel.textColor = BHHexColor(@"#626A75");
    [accountView addSubview:accountLabel];
    
    UIButton *btn;
    UILabel *desLabel;
    UILabel *titleLabel;
    UIView *verticalLine;
    self.btnViewsArray = [NSMutableArray array];
    self.accountArray = [NSMutableArray array];
    for(int i = 0; i < 3 ;i++){
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        verticalLine = [[UIView alloc] init];
        titleLabel = [[UILabel alloc] init];
        desLabel = [[UILabel alloc] init];
        btn.frame = CGRectMake(i*(SCREEN_WIDTH  )/3, SCALE_W(32), (SCREEN_WIDTH)/3, SCALE_W(124-32));
        [accountView addSubview:btn];
        btn.backgroundColor = [UIColor clearColor];
        
        titleLabel.frame = CGRectMake(SCALE_W(0) , SCALE_W(28), SCREEN_WIDTH/3, SCALE_W(14));
        titleLabel.font = UIFontRegularOfSize(SCALE_W(14));
        titleLabel.textColor = BHHexColor(@"626A75");
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleLabel];
        if (i == 0) {
            titleLabel.text = @"积分";
        }
        if (i == 1) {
            titleLabel.text = @"BTC";
        }
        if (i == 2) {
            titleLabel.text = @"USDT";
        }
        desLabel.frame = CGRectMake(SCALE_W(0), SCALE_W(50),SCREEN_WIDTH/3,SCALE_W(20));
        [btn addSubview:desLabel];
        desLabel.backgroundColor  = [UIColor clearColor];
        desLabel.textAlignment = NSTextAlignmentLeft;
        desLabel.font = UIFontSemiboldOfSize(SCALE_W(20));
        desLabel.textColor = BHHexColor(@"#168CF0");
        desLabel.textAlignment = NSTextAlignmentCenter;
        [self.accountArray addObject:desLabel];
        
        if(i < 2){
            verticalLine.frame = CGRectMake(btn.frame.size.width - 1, SCALE_W(30), 1, SCALE_W(32));
            verticalLine.backgroundColor = [UIColor colorWithHexString:@"D8E0E9"];
        }
        [btn addSubview:verticalLine];
        if (i == 0) {
            [btn addTarget:self action:@selector(gotoScoresList) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.btnViewsArray addObject:btn];
    }
    
    hiddenbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenbtn.frame = CGRectMake(0, SCALE_W(32), (SCREEN_WIDTH), SCALE_W(124-32));
    [hiddenbtn addTarget:self action:@selector(gotoScoresList) forControlEvents:UIControlEventTouchUpInside];
    hiddenTitleLabel = [[UILabel alloc] init];
    hiddenTitleLabel.frame = CGRectMake(SCALE_W(0) , SCALE_W(28), SCREEN_WIDTH, SCALE_W(14));
    hiddenTitleLabel.font = UIFontRegularOfSize(SCALE_W(14));
    hiddenTitleLabel.textColor = BHHexColor(@"626A75");
    hiddenTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    hiddendesLabel = [[UILabel alloc] init];
    hiddendesLabel.frame = CGRectMake(SCALE_W(0), SCALE_W(50),SCREEN_WIDTH,SCALE_W(20));
    hiddendesLabel.backgroundColor  = [UIColor clearColor];
    hiddendesLabel.textAlignment = NSTextAlignmentLeft;
    hiddendesLabel.font = UIFontSemiboldOfSize(SCALE_W(20));
    hiddendesLabel.textColor = BHHexColor(@"#168CF0");
    hiddendesLabel.textAlignment = NSTextAlignmentCenter;
    hiddenTitleLabel.text = @"积分";
    
    [accountView addSubview:hiddenbtn];
    [hiddenbtn addSubview:hiddenTitleLabel];
    [hiddenbtn addSubview:hiddendesLabel];
    
    hiddendesLabel.hidden = YES;
    hiddenTitleLabel.hidden = YES;
    hiddenbtn.hidden = YES;

}

-(void)gotoScoresList{
    SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
    webVc.urlString = [NSString stringWithFormat:@"%@?point=%@",kAppIntegralListAddress,pointStr];
    webVc.isHiddenLeft = NO;
    webVc.isHiddenBottom = NO;
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)initFoldingTableView{
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = BHHexColor(@"FAFAFA");
    
    contenttitleLabel = [[UILabel alloc] init];
    contenttitleLabel.frame = CGRectMake(16, 0, SCREEN_WIDTH/3, 44);
    contenttitleLabel.textColor = BHHexColor(@"626A75");
    contenttitleLabel.font = UIFontRegularOfSize(16);
    contenttitleLabel.text = @"我的跟随";
    [contentView addSubview:contenttitleLabel];

    descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.font = UIFontRegularOfSize(14);
    descriptionLabel.textColor = BHHexColor(@"626A75");
    [contentView addSubview:descriptionLabel];

    contentViewarrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"centerArrow"]];
    contentViewarrowImageView.frame =CGRectMake(SCREEN_WIDTH -8 -16, 16, 8, 14);
    [contentView addSubview:contentViewarrowImageView];
    
    followButton =[UIButton buttonWithType:UIButtonTypeCustom];
    followButton.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    [contentView addSubview:followButton];
    [followButton addTarget:self action:@selector(showFollowList) forControlEvents:UIControlEventTouchUpInside];

    menuView = [UIView new];
    NSArray *array = @[@"当前策略",@"历史策略"];
    self.buttonArray = [NSMutableArray array];
    UIButton *strageyButton;
   
    for (int i = 0; i < array.count; i++) {
        strageyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        strageyButton.tag = 3333300+i;
        [strageyButton setTitle:array[i] forState:UIControlStateNormal];
        strageyButton.titleLabel.font = UIFontRegularOfSize(14);
        
        [strageyButton addTarget:self action:@selector(selectButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [strageyButton setBackgroundColor:BHHexColor(@"FAFAFA")];
            [strageyButton setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
        }else{
            [strageyButton setBackgroundColor:KBGColor];
            [strageyButton setTitleColor:BHHexColorAlpha(@"626A75", 0.5) forState:UIControlStateNormal];
        }
        [self.buttonArray addObject:strageyButton];
        [menuView addSubview:strageyButton];
    }
    blueLineView = [[UIImageView alloc] init];
    blueLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 1);
    blueLineView.backgroundColor = BHHexColor(@"#168CF0");
    blueLineView.hidden =YES;
    [menuView addSubview:blueLineView];
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = KBGColor;
    [self.bgView addSubview:personalView];
    [self.bgView addSubview:accountView];
    [self.bgView addSubview:contentView];
    [self.bgView addSubview:menuView];
    
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, accountView.bottom+16);
    contentView.frame = CGRectMake(0, accountView.bottom+16, SCREEN_WIDTH, 0);
    menuView.frame = CGRectMake(0, contentView.bottom, SCREEN_WIDTH, 0);
}

-(void)showFollowList{
    self.selectFlag = !self.selectFlag;
    if (self.selectFlag) {
        for (int i = 0; i < 2; i++) {
            UIButton *tempButton =(UIButton *) self.buttonArray[i];
            tempButton.frame = CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, 38);
        }
        blueLineView.hidden = NO;
        menuView.frame = CGRectMake(0, contentView.bottom, SCREEN_WIDTH, 38);
        
        [self.listArray removeAllObjects];
        
        if (self.selectHistrategyFlag) {
            if (self.historyStrategyArray.count <= 0) {
                [self.listArray addObject:@"1"];
            }else{
                [self.listArray addObjectsFromArray:self.historyStrategyArray];
            }
        }else{
            [self.listArray addObjectsFromArray:self.strategyArray];
        }
        
        [UIView animateWithDuration:0.2  animations:^{
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformRotate(transform, M_PI_2);
            contentViewarrowImageView.transform = transform;
        } completion:^(BOOL finished) {}];
    }else{
        for (int i = 0; i < 2; i++) {
            UIButton *tempButton =(UIButton *) self.buttonArray[i];
            tempButton.frame = CGRectMake(SCREEN_WIDTH/2*i, 0, 0, 0);
        }
        blueLineView.hidden = YES;
        menuView.frame = CGRectMake(0, contentView.bottom, SCREEN_WIDTH, 0);
        [self.listArray removeAllObjects];
        [UIView animateWithDuration:0.2  animations:^{
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformRotate(transform, 2*M_PI);
            contentViewarrowImageView.transform = transform;
        } completion:^(BOOL finished) {}];
     }
    [self.listView reloadData];
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, menuView.bottom );
    [self.listView setTableHeaderView:self.bgView];
}

-(void)selectButtonOnclick:(UIButton *)sender{
    for (UIButton *btn in self.buttonArray) {
        [btn setBackgroundColor:KBGColor];
        [btn setTitleColor:BHHexColorAlpha(@"626A75", 0.5) forState:UIControlStateNormal];
    }
    
    for (UIButton *btn in self.buttonArray) {
        if (btn.tag == sender.tag) {
            [btn setBackgroundColor:BHHexColor(@"FAFAFA")];
            [btn setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
        }
    }
    if (sender.tag == 3333300) {
        blueLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 1);
        self.selectHistrategyFlag = NO;
    }else {
        blueLineView.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 1);
        self.selectHistrategyFlag = YES;
    }
    
    [self.listArray removeAllObjects];
    if (self.selectHistrategyFlag) {
        
        if (self.historyStrategyArray.count <= 0) {
            [self.listArray addObject:@"1"];
        }else{
            [self.listArray addObjectsFromArray:self.historyStrategyArray];
        }
//        if (self.listArray.count <= 0) {
//            self.grayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130+16);
//            UIImageView *redView = [[UIImageView alloc] init];
//            redView.backgroundColor = [UIColor redColor];
//            redView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
//            [self.grayView addSubview:redView];
//            [self.foldFooterTableView setTableHeaderView:self.grayView];
//            [self.listView setTableFooterView:self.foldFooterTableView];
//        }else{
//            self.grayView.frame = CGRectMake(0, 0, SCREEN_WIDTH,16);
//            [self.grayView removeAllSubviews];
//            [self.foldFooterTableView setTableHeaderView:self.grayView];
//            [self.listView setTableFooterView:self.foldFooterTableView];
//        }
    }else{
//        self.grayView.frame = CGRectMake(0, 0, SCREEN_WIDTH,16);
//        [self.grayView removeAllSubviews];
//        [self.foldFooterTableView setTableHeaderView:self.grayView];
//        [self.listView setTableFooterView:self.foldFooterTableView];
        [self.listArray addObjectsFromArray:self.strategyArray];
    }
    [self.listView reloadData];
}

-(UITableView *)listView{
    if (_listView == nil) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT, self.view.bounds.size.width, SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT)];
         _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = KBGColor;
        _listView.tag =1000001;
        WS(weakSelf)
        self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (User.userToken) {
                [self getMyAccountLoginStatus];
            }else{
                [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                    if (isComplete) {
                        [weakSelf update];
                    } else {
                        [weakSelf.tabBarController setSelectedIndex:0];
                    }
                }];
            }
        }];
    }
    return _listView;
}

-(UITableView *)foldFooterTableView{
    if (_foldFooterTableView == nil) {
        _foldFooterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 390)];
        _foldFooterTableView.dataSource = self;
        _foldFooterTableView.delegate = self;
        _foldFooterTableView.backgroundColor = KBGColor;
        
        _foldFooterTableView.tag =1000001;
        self.grayView = [UIView new];
        self.grayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 16);
        [_foldFooterTableView setTableHeaderView:self.grayView];
        
        UIView *quitBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 92)];
        quitBgView.backgroundColor = KBGColor;
        UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, 48)];
        [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        quitButton.titleLabel.font =  UIFontRegularOfSize(16);
        [quitButton setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
        [quitButton addTarget:self action:@selector(quitOnclick) forControlEvents:UIControlEventTouchUpInside];
        [quitButton setBackgroundColor:BHHexColor(@"FAFAFA")];
        [quitBgView addSubview:quitButton];
        [_foldFooterTableView setTableFooterView:quitBgView];
    }
    return _foldFooterTableView;
}

-(void)quitOnclick{
    NSString *message = NSLocalizedString(@"确定要退出登录吗？",nil);
    //    NSString *title = @"提示";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //    //改变title的大小和颜色
    //    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:title];
    //    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    //    [titleAtt addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, title.length)];
    //    [alertController setValue:titleAtt forKey:@"attributedTitle"];
    //改变message的大小和颜色
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
    [messageAtt addAttribute:NSFontAttributeName value:UIFontRegularOfSize(14) range:NSMakeRange(0, message.length)];
    [messageAtt addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"626A75") range:NSMakeRange(0, message.length)];
    [alertController setValue:messageAtt forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        methodName = kAcountUserLogout;
        
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NMRemovLoadIng;
            //退出成功删除手机号
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:MobilePhoneNum];
            //删除本地登录信息
            [User removeLoginData];
            //发送通知告诉web token变动
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
            [weakSelf.tabBarController setSelectedIndex:0];
            [weakSelf initData];
            [weakSelf initSubViewWhitQuitApp];
            [self.listView reloadData];
            
            [self.listView setContentOffset:CGPointMake(0,0) animated:NO];
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error-------->%@",error);
        }];
    }];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)initSubViewWhitQuitApp{
    contenttitleLabel.frame = CGRectMake(16, 0, SCREEN_WIDTH/3, 44);
    contentViewarrowImageView.frame =CGRectMake(SCREEN_WIDTH -8 -16, 16, 8, 14);
    followButton.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    blueLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 1);
    blueLineView.hidden =YES;
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, accountView.bottom+16);
    contentView.frame = CGRectMake(0, accountView.bottom+16, SCREEN_WIDTH, 0);
    menuView.frame = CGRectMake(0, contentView.bottom, SCREEN_WIDTH, 0);
}

-(void)gotoPersonalVc{
    PersonalSettingViewController *invateVc = [[PersonalSettingViewController alloc] init];
    [self.navigationController pushViewController:invateVc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (User.userToken) {
        [self getMyAccountLoginStatus];
    }else{
        WS(weakSelf)
        [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
            if (isComplete) {
                [self update];
            } else {
                [weakSelf.tabBarController setSelectedIndex:0];
            }
        }];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)update{
    NSInteger hiddenFlag = [[[NSUserDefaults standardUserDefaults] objectForKey:MobileTradeNum] integerValue];
    if (User.userToken &&  hiddenFlag == 1) {
        for (UIButton *btn in self.btnViewsArray) {
            btn.hidden =NO;
        }
        hiddendesLabel.hidden = YES;
        hiddenTitleLabel.hidden = YES;
        hiddenbtn.hidden = YES;
    }else{
        for (UIButton *btn in self.btnViewsArray) {
            btn.hidden =YES;
        }
        hiddendesLabel.hidden = NO;
        hiddenTitleLabel.hidden = NO;
        hiddenbtn.hidden = NO;
    }
    [self getUserInfo];
    [self getMyAccountInfo];
    [self getMyAccountCurrentInfo];
    [self getMyAccountSettleInfo];
}

#pragma mark -getMyAccountLoginStatus
- (void)getMyAccountLoginStatus{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetUserLoginInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 0) {//未登录
            [BTELoginVC OpenLogin:self callback:^(BOOL isComplete) {
                if (isComplete) {
                    //登录成功刷新我的账户页面
                    [weakSelf update];
                } else{
                    [weakSelf.tabBarController setSelectedIndex:0];
                }
            }];
        } else if (IsSafeDictionary(responseObject) && [[responseObject objectForKey:@"data"] integerValue] == 1)//已登录
        {
            [weakSelf update];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark -获取当前账de当前策略信息
- (void)getMyAccountCurrentInfo{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken && ![User.userToken isEqualToString:@""]) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    } else {
        return;
    }
    methodName = kAcountHoldInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        NSLog(@"kAcountHoldInfo-------->%@",responseObject);
        NSArray *array = [NSArray yy_modelArrayWithClass:[BTEAccountDetailsModel class] json:responseObject[@"data"][@"details"]];
        [weakSelf.strategyArray removeAllObjects];
        for (BTEAccountDetailsModel *detailModel in array) {
              NSArray *detailArray = detailModel.details;
            for (Details *tempdetail in detailArray) {
                tempdetail.productName = detailModel.productBatchName;
                tempdetail.assetType = detailModel.assetType;
                [weakSelf.strategyArray addObject:tempdetail];
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark -获取当前账户de历史策略信息
- (void)getMyAccountSettleInfo{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kAcountSettleInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"kAcountSettleInfo-------->%@",responseObject);
        NMRemovLoadIng;
        NSArray *array = [NSArray yy_modelArrayWithClass:[BTEAccountDetailsModel class] json:responseObject[@"data"][@"details"]];
        
        [weakSelf.historyStrategyArray removeAllObjects];
        for (BTEAccountDetailsModel *detailModel in array) {
            NSArray *detailArray = detailModel.details;
            for (Details *tempdetail in detailArray) {
                tempdetail.productName = detailModel.productBatchName;
                tempdetail.assetType = detailModel.assetType;
                [weakSelf.historyStrategyArray addObject:tempdetail];
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark -获取账户基本信息
- (void)getMyAccountInfo{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    [pramaDic setObject:User.userToken forKey:@"bte-token"];
    methodName = kAcountInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
//    self.isloginAndGetMyAccountInfo = @"1";
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        NSLog(@"kAcountInfo-------->%@",responseObject);
        //登录成功并获取到了账户信息
        legalAccountModel = [BTELegalAccount yy_modelWithDictionary:responseObject[@"data"][@"legalAccount"]];
        btcAccountModel = [BTEBtcAccount yy_modelWithDictionary:responseObject[@"data"][@"btcAccount"]];
        pointStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"point"]];
        holdCountStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"holdCount"]];
        settleCountStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"settleCount"]];
        friendsStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"friends"]];
        assetNumStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalAsset"]];
        [self.foldFooterTableView reloadData];
        [self.listView reloadData];
        for (int i =0 ; i < weakSelf.accountArray.count; i++) {
            UILabel *tempLabel = self.accountArray[i];
            if (i == 0) {
               hiddendesLabel.text = tempLabel.text = pointStr;
            }
            if (i == 1) {
                if (btcAccountModel.balance && [btcAccountModel.balance floatValue] != 0) {
                    tempLabel.text = [NSString stringWithFormat:@"%@",btcAccountModel.balance];
                } else
                {
                    tempLabel.text = @"0";
                }
            }
            if (i == 2) {
                if (legalAccountModel.legalBalance && [legalAccountModel.legalBalance floatValue] != 0) {
                    tempLabel.text = [NSString stringWithFormat:@"$%@",legalAccountModel.legalBalance];
                } else {
                    tempLabel.text = @"0";
                }
            }
        }

        if ([holdCountStr intValue] != 0) {
            contentView.frame = CGRectMake(0, accountView.bottom+16, SCREEN_WIDTH, 44);
            followButton.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
            contenttitleLabel.hidden = NO;
            contentViewarrowImageView.hidden = NO;
            followButton.hidden = NO;
            
            descriptionLabel.text = [NSString stringWithFormat:@"当前%@笔",holdCountStr];
            [descriptionLabel sizeToFit];
            descriptionLabel.frame = CGRectMake(SCREEN_WIDTH - descriptionLabel.bounds.size.width - 16 -8 -10, (44 - descriptionLabel.bounds.size.height)/2.0, descriptionLabel.bounds.size.width, descriptionLabel.bounds.size.height);
      
            if (self.selectFlag) {
                for (int i = 0; i < 2; i++) {
                    UIButton *tempButton =(UIButton *) self.buttonArray[i];
                    tempButton.frame = CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, 38);
                }
                blueLineView.hidden = NO;
                menuView.frame = CGRectMake(0, contentView.bottom, SCREEN_WIDTH, 38);
                [self.listArray removeAllObjects];
                if (self.selectHistrategyFlag) {
                    if (self.historyStrategyArray.count <= 0) {
                        [self.listArray addObject:@"1"];
                    }else{
                        [self.listArray addObjectsFromArray:self.historyStrategyArray];
                    }
                }else{
                    [self.listArray addObjectsFromArray:self.strategyArray];
                }
                [self.listView reloadData];
                
            }else{
                for (int i = 0; i < 2; i++) {
                    UIButton *tempButton =(UIButton *) self.buttonArray[i];
                    tempButton.frame = CGRectMake(SCREEN_WIDTH/2*i, 0, 0, 0);
                }
                blueLineView.hidden = YES;
                menuView.frame = CGRectMake(0, contentView.bottom, SCREEN_WIDTH, 0);
                
                [self.listArray removeAllObjects];
                [self.listView reloadData];
            }
            self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, menuView.bottom);
        }else{
            self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, accountView.bottom);
            contentView.frame = CGRectMake(0, accountView.bottom+16, SCREEN_WIDTH, 0);
            contenttitleLabel.hidden = YES;
            contentViewarrowImageView.hidden = YES;
            followButton.hidden = YES;
        }
        [self.listView setTableHeaderView:self.bgView];
        [self.listView setTableFooterView:self.foldFooterTableView];
        self.listView.hidden = NO;
        [weakSelf.listView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.listView.mj_header endRefreshing];
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}


#pragma mark -获取登录用户的个人信息
- (void)getUserInfo{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        [pramaDic setObject:User.userToken forKey:@"token"];
    }
    methodName = kGetUserInfoV2;
    
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"kGetUserInfoV2-------->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (data) {
                telStr =  stringFormat([data objectForKey:@"tel"]);
                nickNameStr = stringFormat([data objectForKey:@"name"]);
                emailStr = stringFormat([data objectForKey:@"email"]);
                headPicStr = stringFormat([data objectForKey:@"avator"]);
                if (![nickNameStr isEqualToString:@""]) {
                    if ([telStr isEqualToString:nickNameStr]) {
                        nickNameLabel.text = nickNameStr = [NSString stringWithFormat:@"%@****%@",[nickNameStr substringToIndex:4],[nickNameStr substringFromIndex:7]];
                    }else{
                        if ([nickNameStr isValidateEmail]) {
                            NSArray *emailArray = [emailStr componentsSeparatedByString:@"@"];
                            if (emailArray != nil && emailArray.count >0 ) {
                                NSInteger length = [emailArray[0] length];
                                NSString *emailStr = [NSString stringWithFormat:@"%@****%@",[emailArray[0] substringToIndex:1],
                                                      [nickNameStr substringFromIndex:length - 1]];
                                nickNameLabel.text = nickNameStr = emailStr;
                            }
                        }else{
                            nickNameLabel.text = nickNameStr;
                        }
                    }
                }else{
                    NSArray *emailArray = [emailStr componentsSeparatedByString:@"@"];
                    if (emailArray != nil && emailArray.count >0 ) {
                        NSInteger length = [emailArray[0] length];
                        NSString *emailStr = [NSString stringWithFormat:@"%@****%@@%@",[emailArray[0] substringToIndex:1],
                                              [nickNameStr substringFromIndex:length - 1],emailArray[1]];
                        nickNameLabel.text =  nickNameStr = emailStr;
                    }
                }
                if (![headPicStr isEqualToString:@""]) {
                }else{
                    headPicStr= @"https://file.bte.top/common/avatar/1.png";
                }
                [headerImageView sd_setImageWithURL:[NSURL URLWithString:headPicStr] placeholderImage:nil options:SDWebImageRefreshCached];
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
       
        NormalITableItem *temp0 = [[NormalITableItem alloc] init];
        temp0.valueLabelStr = @"";
        temp0.functionValue =@"服务设置";
        NormalITableItem *temp1= [[NormalITableItem alloc] init];
        temp1.valueLabelStr = @"";
        temp1.functionValue =@"加入官方群";
        NormalITableItem *temp2 = [[NormalITableItem alloc] init];
        temp2.valueLabelStr = @"";
        temp2.functionValue =@"我的邀请";
        NormalITableItem *temp3 = [[NormalITableItem alloc] init];
        temp3.valueLabelStr = @"";
        temp3.functionValue =@"意见反馈";
        NormalITableItem *temp4 = [[NormalITableItem alloc] init];
        temp4.valueLabelStr = @"";
        temp4.functionValue =@"关于";
        
        [_dataArray addObject:temp0];
        [_dataArray addObject:temp1];
        [_dataArray addObject:temp2];
        [_dataArray addObject:temp3];
        [_dataArray addObject:temp4];
    }
    return _dataArray;
}

-(NSMutableArray *)strategyArray{
    if (_strategyArray == nil) {
        _strategyArray = [[NSMutableArray alloc] init];
    }
    return _strategyArray;
}

-(NSMutableArray *)historyStrategyArray{
    if (_historyStrategyArray == nil) {
        _historyStrategyArray = [[NSMutableArray alloc] init];
    }
    return _historyStrategyArray;
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.listView) {
        return self.listArray.count;
    }else if(tableView == self.foldFooterTableView){
        return self.dataArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.listView) {
        return 130;
    }else if(tableView == self.foldFooterTableView){
        if (indexPath.row == 1) {
            return 60;
        }else{
            return 44;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    if (tableView == self.foldFooterTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (indexPath.row == 1) {
            if(cell == nil){
                cell = [[inviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            NormalITableItem *temp = self.dataArray[indexPath.row];
            inviteTableViewCell *tempcell = (inviteTableViewCell *)cell;
            tempcell.separatorInset =  UIEdgeInsetsMake(0, SCREEN_WIDTH , 0, 0);
            [tempcell setNormalTableItem:temp];
        }else{
            if(cell == nil){
                cell = [[NormalTableCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            NormalITableItem *temp = self.dataArray[indexPath.row];
            NormalTableCellTableViewCell *tempcell = (NormalTableCellTableViewCell *)cell;
//            if (indexPath.row == 0) {
//                if ([assetNumStr intValue] != 0) {
//                    temp.valueLabelStr = [NSString stringWithFormat:@"¥%@", [self countNumAndChangeformat:assetNumStr]];
//                }else{
//                    temp.valueLabelStr = @"";
//                }
//            }
            if (indexPath.row == 2) {
                if ([friendsStr intValue] != 0) {
                    temp.valueLabelStr = [NSString stringWithFormat:@"%@个好友",friendsStr];
                }else{
                    temp.valueLabelStr = @"";
                }
            }
            [tempcell setNormalTableItem:temp];

        }
    }
    
    if (tableView == self.listView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StraegyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        StraegyTableViewCell *tempcell =  (StraegyTableViewCell *)cell;
        
        if(self.selectHistrategyFlag){
            if (self.historyStrategyArray.count <=0) {
                tempcell.redimageView.hidden = NO;
            }else{
                tempcell.redimageView.hidden = YES;
                Details *cellModel = self.listArray[indexPath.row];
                [tempcell setNormalTableItem:cellModel];
            }
            tempcell.arrowImageView.hidden = YES;
        }else{
            tempcell.redimageView.hidden = YES;
            tempcell.arrowImageView.hidden = NO;
            Details *cellModel = self.listArray[indexPath.row];
            [tempcell setNormalTableItem:cellModel];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.foldFooterTableView) {
//        if (indexPath.row == 0) {
//            SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
//            webVc.urlString = [NSString stringWithFormat:@"%@",kAppAssetsAddress];
//            webVc.isHiddenLeft = NO;
//            webVc.isHiddenBottom = NO;
//            [self.navigationController pushViewController:webVc animated:YES];
//        }
        if (indexPath.row == 0) {
//            SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
//            webVc.urlString = [NSString stringWithFormat:@"%@",kAppserviceSettingAddress];
//            webVc.isHiddenLeft = NO;
//            webVc.isHiddenBottom = NO;
            ServicesSetViewController *serviceSetVc = [[ServicesSetViewController alloc] init];
            [self.navigationController pushViewController:serviceSetVc animated:YES];
        }
        if (indexPath.row == 1) {
            SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
            webVc.urlString = [NSString stringWithFormat:@"%@",kAppAddGroupAddress];
            webVc.isHiddenLeft = NO;
            webVc.isHiddenBottom = NO;
            [self.navigationController pushViewController:webVc animated:YES];
        }
        if (indexPath.row == 2) {
            SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
            webVc.urlString = [NSString stringWithFormat:@"%@",kAppInviteResultAddress];
            webVc.isHiddenLeft = NO;
            webVc.isHiddenBottom = NO;
            [self.navigationController pushViewController:webVc animated:YES];
        }
        if (indexPath.row == 3) {
            BTEFeedBackViewController *invateVc = [[BTEFeedBackViewController alloc] init];
            [self.navigationController pushViewController:invateVc animated:YES];
        }
        if (indexPath.row == 4) {
            SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
            webVc.urlString = [NSString stringWithFormat:@"%@",kAppAboutAddress];
            webVc.isHiddenLeft = NO;
            webVc.isHiddenBottom = NO;
            [self.navigationController pushViewController:webVc animated:YES];
        }
    }
}

//金钱每三位加一个逗号，经过封装的一个方法直接调用即可，传一个你需要加，号的字符串就好了
-(NSString *)countNumAndChangeformat:(NSString *)num
{
    if([num rangeOfString:@"."].location !=NSNotFound) //这个判断是判断有没有小数点如果有小数点，需特别处理，经过处理再拼接起来
    {
        NSString *losttotal = [NSString stringWithFormat:@"%.2f",[num floatValue]];//小数点后只保留两位
        NSArray *array = [losttotal componentsSeparatedByString:@"."];
        //小数点前:array[0]
        //小数点后:array[1]
        int count = 0;
        num = array[0];
        long long int a = num.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        NSMutableString *newString = [NSMutableString string];
        newString =[NSMutableString stringWithFormat:@"%@.%@",newstring,array[1]];
        return newString;
    }else {
        int count = 0;
        long long int a = num.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        return newstring;
    }
}
@end
