//
//  BTEInviteFriendViewController.m
//  BTE
//
//  Created by wangli on 2018/4/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEInviteFriendViewController.h"
#import "BTEFreandCountViewController.h"
@interface BTEInviteFriendViewController ()

@end

@implementation BTEInviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGColor;
    self.title = @"邀请好友";
    self.shareType = UMS_SHARE_TYPE_WEB_LINK;//web链接
    self.sharetitle = @"我正在用比特易，最专业的数字货币市场分析平台";
    self.shareDesc = @"比特易，专业数字货币市场分析平台，软银中国战略投资，区块链市场数据分析工具。";
    _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    _setTableView.backgroundColor = KBGColor;
    _setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _setTableView.delegate = self;
//    _setTableView.dataSource = self;
    _setTableView.bounces = NO;
    _setTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_setTableView];
    [self setTableHeadView];
    [self setTableFooterView];
    [self getUserInvateFrend];
}


//设置头部视图
- (void)setTableHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 416 + 30)];
    headView.backgroundColor = KBGColor;
    
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 315) / 2, 30, 315, 416)];
    bgImage.image = [UIImage imageNamed:@"bg_image_invate"];
    bgImage.userInteractionEnabled = YES;
    [headView addSubview:bgImage];
    
    UIImageView *bgImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(30.2, 20.2, 43.6, 43.6)];
    bgImage1.image = [UIImage imageNamed:@"icon_bg_invate"];
    [bgImage addSubview:bgImage1];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(81, 46, SCREEN_WIDTH - 150, 16)];
    titleLabel1.text = @"我的邀请码";
    titleLabel1.font = UIFontMediumOfSize(16);
//    titleLabel1.alpha = 0.5;
    titleLabel1.centerY = bgImage1.centerY;
    titleLabel1.textColor = BHHexColor(@"626A75");
    [bgImage addSubview:titleLabel1];
    
    //Base64字符串转UIImage图片：
    if (_dicInvate) {
        
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 26, SCREEN_WIDTH - 150, 14)];
//        titleLabel.text = [NSString stringWithFormat:@"%@的二维码",[_dicInvate objectForKey:@"tel"]];
//        titleLabel.font = UIFontRegularOfSize(16);
//        titleLabel.textColor = BHHexColor(@"626A75");
//        [bgImage addSubview:titleLabel];
        
        
        NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:[_dicInvate objectForKey:@"base64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
        UIImageView *bgImage2 = [[UIImageView alloc] initWithFrame:CGRectMake((bgImage.width - 228.9) / 2, 112, 228.9, 228.9)];
        [bgImage2 setImage:decodedImage];
        [bgImage addSubview:bgImage2];
    }

    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake((bgImage.width - 150) / 2, 364, 150, 50);
    [commitButton setTitle:@"查看邀请结果" forState:UIControlStateNormal];
    [commitButton setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(checkOut) forControlEvents:UIControlEventTouchUpInside];
    commitButton.titleLabel.font = UIFontRegularOfSize(14);
    [bgImage addSubview:commitButton];
    
    
    self.setTableView.tableHeaderView = headView;
}

//设置尾部视图
- (void)setTableFooterView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37 + 80)];
    headView.backgroundColor = [UIColor clearColor];
    
    float width = (SCREEN_WIDTH - 20 * 2 - 44 * 5) / 4;
    
    UIButton *commitButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton1.frame = CGRectMake(20, 37, 44, 44);
    commitButton1.tag = 101;
    [commitButton1 setImage:[UIImage imageNamed:@"bg_weixin_invate"] forState:UIControlStateNormal];
    [commitButton1 addTarget:self action:@selector(shareEnent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:commitButton1];
    
    UIButton *commitButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton2.frame = CGRectMake(commitButton1.right + width, 37, commitButton1.width, commitButton1.width);
    commitButton2.tag = 102;
    [commitButton2 setImage:[UIImage imageNamed:@"bg_freand_invate"] forState:UIControlStateNormal];
    [commitButton2 addTarget:self action:@selector(shareEnent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:commitButton2];
    
    UIButton *commitButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton4.frame = CGRectMake(commitButton2.right + width, 37, commitButton1.width, commitButton1.width);
    commitButton4.tag = 104;
    [commitButton4 setImage:[UIImage imageNamed:@"share_qq_bg"] forState:UIControlStateNormal];
    [commitButton4 addTarget:self action:@selector(shareEnent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:commitButton4];
    
    UIButton *commitButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton5.frame = CGRectMake(commitButton4.right + width, 37, commitButton1.width, commitButton1.width);
    commitButton5.tag = 105;
    [commitButton5 setImage:[UIImage imageNamed:@"share_qqzone_bg"] forState:UIControlStateNormal];
    [commitButton5 addTarget:self action:@selector(shareEnent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:commitButton5];
    
    UIButton *commitButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton3.frame = CGRectMake(commitButton5.right + width, 37, commitButton1.width, commitButton1.width);
    commitButton3.tag = 103;
    [commitButton3 setImage:[UIImage imageNamed:@"bg_weibo_invate"] forState:UIControlStateNormal];
    [commitButton3 addTarget:self action:@selector(shareEnent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:commitButton3];
    
    UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(14, commitButton1.bottom + 8, 60, 13)];
    labelTitle3.textColor = BHHexColor(@"626A75");
    labelTitle3.textAlignment = NSTextAlignmentCenter;
    labelTitle3.centerX = commitButton1.centerX;
    labelTitle3.text = @"微信";
    labelTitle3.font = UIFontRegularOfSize(12);
    [headView addSubview:labelTitle3];
    
    UILabel *labelTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(14, labelTitle3.top, 60, 13)];
    labelTitle4.textColor = BHHexColor(@"626A75");
    labelTitle4.textAlignment = NSTextAlignmentCenter;
    labelTitle4.centerX = commitButton2.centerX;
    labelTitle4.text = @"朋友圈";
    labelTitle4.font = UIFontRegularOfSize(12);
    [headView addSubview:labelTitle4];
    
    UILabel *labelTitle5 = [[UILabel alloc] initWithFrame:CGRectMake(14, labelTitle3.top, 60, 13)];
    labelTitle5.textColor = BHHexColor(@"626A75");
    labelTitle5.textAlignment = NSTextAlignmentCenter;
    labelTitle5.centerX = commitButton3.centerX;
    labelTitle5.text = @"微博";
    labelTitle5.font = UIFontRegularOfSize(12);
    [headView addSubview:labelTitle5];
    
    UILabel *labelTitle6 = [[UILabel alloc] initWithFrame:CGRectMake(14, labelTitle3.top, 60, 13)];
    labelTitle6.textColor = BHHexColor(@"626A75");
    labelTitle6.textAlignment = NSTextAlignmentCenter;
    labelTitle6.centerX = commitButton4.centerX;
    labelTitle6.text = @"QQ";
    labelTitle6.font = UIFontRegularOfSize(12);
    [headView addSubview:labelTitle6];
    
    UILabel *labelTitle7 = [[UILabel alloc] initWithFrame:CGRectMake(14, labelTitle3.top, 60, 13)];
    labelTitle7.textColor = BHHexColor(@"626A75");
    labelTitle7.textAlignment = NSTextAlignmentCenter;
    labelTitle7.centerX = commitButton5.centerX;
    labelTitle7.text = @"QQ空间";
    labelTitle7.font = UIFontRegularOfSize(12);
    [headView addSubview:labelTitle7];
    
    self.setTableView.tableFooterView = headView;
}

-(void)shareEnent:(UIButton *)sender
{
    if (_dicInvate) {
        if (sender.tag == 101) {//微信
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:[_dicInvate objectForKey:@"url"] sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self shareButtonTag:101];
        } else if (sender.tag == 102)//朋友圈
        {
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:[_dicInvate objectForKey:@"url"] sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self shareButtonTag:102];
        } else if (sender.tag == 103)//微博
        {
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:[_dicInvate objectForKey:@"url"] sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self shareButtonTag:103];
        } else if (sender.tag == 104)//QQ
        {
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:[_dicInvate objectForKey:@"url"] sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self shareButtonTag:104];
        } else if (sender.tag == 105)//QQ空间
        {
            [BTEShareView popShareViewCallBack:nil imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:[_dicInvate objectForKey:@"url"] sharetitle:self.sharetitle shareDesc:self.shareDesc shareType:self.shareType currentVc:self shareButtonTag:105];
        }
    }
}

//获取邀请好友信息
- (void)getUserInvateFrend
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:kGetUserInvateFrendUrl forKey:@"url"];
    
    methodName = kGetUserInvateFrend;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
//        NSLog(@"kGetUserInvateFrend-------->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            _dicInvate = [responseObject objectForKey:@"data"];
            [weakSelf setTableHeadView];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)checkOut
{
    BTEFreandCountViewController *freandVc = [[BTEFreandCountViewController alloc] init];
    [self.navigationController pushViewController:freandVc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if (self.fromVCType == FromScroeVC) {
//         self.tabBarController.tabBar.hidden = YES;
//    }
//    if (self.fromVCType == FromPersonVC) {
//        self.tabBarController.tabBar.hidden = NO;
//    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
