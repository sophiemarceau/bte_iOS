//
//  MissionViewController.m
//  BTE
//
//  Created by sophie on 2018/10/25.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "MissionViewController.h"
#import "SecondaryLevelWebViewController.h"
#import "TaskItem.h"
#import "InfoObject.h"
#import "WXApiManager.h"

@interface MissionViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>{
    TaskItem *taskItem;
}
@property(nonatomic,strong)UITableView *listView;
@end

@implementation MissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApiManager sharedManager].delegate = self;
    self.title = @"固定任务";
    [self initData];
    [self initSubViews];
    
}

-(void)initData{
    
}

-(void)initSubViews{
    [self.view addSubview:self.listView];
}

-(UITableView *)listView{
    if (_listView == nil) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCREEN_HEIGHT - NAVIGATION_HEIGHT )];
        _listView.dataSource = self;
        _listView.delegate = self;
        [_listView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _listView.backgroundColor = KBGColor;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        headView.backgroundColor =KBGColor;
        [_listView setTableHeaderView:headView] ;
    }
    return _listView;
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        return 56;
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 16, 16)];
        [cell.contentView addSubview:iconImageView];
        iconImageView.image = [UIImage imageNamed:@"WeChat"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"绑定微信";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = BHHexColor(@"626A75");
        label.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:label];
        [label sizeToFit];
        label.frame = CGRectMake(42, 0, label.width, 50);
        
        UILabel *valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right +12, 0, SCREEN_WIDTH/2, 50)];
        valuelabel.text = @"+5";
        valuelabel.textAlignment = NSTextAlignmentLeft;
        valuelabel.textColor = BHHexColor(@"626A75");
        valuelabel.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:valuelabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        
        
        
        UILabel *typelabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 16, 0, 50, 50)];
        if ([taskItem.bindWx intValue] !=0 ) {
            typelabel.text = @"去完成";
            typelabel.textColor = BHColorBlue;
        }else{
            typelabel.text = @"已完成";
            typelabel.textColor = BHHexColor(@"626A75");
        }
        
        typelabel.textAlignment = NSTextAlignmentRight;
        
        typelabel.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:typelabel];
        
        return cell;
    }else if(indexPath.row == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 16, 16)];
        [cell.contentView addSubview:iconImageView];
        iconImageView.image = [UIImage imageNamed:@"guanzhu"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"关注公众号";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = BHHexColor(@"626A75");
        label.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:label];
        [label sizeToFit];
        label.frame = CGRectMake(42, 0, label.width, 50);
        
        UILabel *valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right +12, 0, SCREEN_WIDTH/2, 50)];
        valuelabel.text = @"+5";
        valuelabel.textAlignment = NSTextAlignmentLeft;
        valuelabel.textColor = BHHexColor(@"626A75");
        valuelabel.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:valuelabel];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        
        UILabel *typelabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 16, 0, 50, 50)];
        
        if ([taskItem.followWx intValue] !=0 ) {
            typelabel.text = @"去完成";
            typelabel.textColor = BHColorBlue;
        }else{
            typelabel.text = @"已完成";
            typelabel.textColor = BHHexColor(@"626A75");
        }
        typelabel.textAlignment = NSTextAlignmentRight;
        typelabel.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:typelabel];
        return cell;
    }else if (indexPath.row == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGColor;
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = KBGCell;
        bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        [cell.contentView addSubview:bgView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 16, 16)];
        [bgView addSubview:iconImageView];
        iconImageView.image = [UIImage imageNamed:@"加入官方群"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"加入官方群";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = BHHexColor(@"626A75");
        label.font = UIFontRegularOfSize(14);
        [bgView addSubview:label];
        [label sizeToFit];
        label.frame = CGRectMake(42, 0, label.width, 50);
        
        UILabel *valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right +12, 0, SCREEN_WIDTH/2, 50)];
        valuelabel.text = @"+5";
        valuelabel.textAlignment = NSTextAlignmentLeft;
        valuelabel.textColor = BHHexColor(@"626A75");
        valuelabel.font = UIFontRegularOfSize(14);
        [bgView addSubview:valuelabel];
        
        UILabel *typelabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 16, 0, 50, 50)];
        if ([taskItem.join intValue] !=0 ) {
            typelabel.text = @"去完成";
            typelabel.textColor = BHColorBlue;
        }else{
            typelabel.text = @"已完成";
            typelabel.textColor = BHHexColor(@"626A75");
        }
        typelabel.textAlignment = NSTextAlignmentRight;
        typelabel.textColor = BHColorBlue;
        typelabel.font = UIFontRegularOfSize(14);
        [bgView addSubview:typelabel];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 16, 16)];
        [cell.contentView addSubview:iconImageView];
        iconImageView.image = [UIImage imageNamed:@"diaoyan"];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = UIFontRegularOfSize(14);
        label.text = @"用户调研";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        [label sizeToFit];
        label.frame = CGRectMake(42, 0, label.width, 50);
        
        UILabel *valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right +12, 0, SCREEN_WIDTH/2, 50)];
        valuelabel.text = @"+5";
        valuelabel.textAlignment = NSTextAlignmentLeft;
        valuelabel.textColor = BHHexColor(@"626A75");
        valuelabel.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:valuelabel];
        
        UILabel *typelabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 16, 0, 50, 50)];
        
        typelabel.textAlignment = NSTextAlignmentRight;
        typelabel.textColor = BHColorBlue;
        if ([taskItem.feedback intValue] !=0 ) {
            typelabel.text = @"去完成";
            typelabel.textColor = BHColorBlue;
        }else{
            typelabel.text = @"已完成";
            typelabel.textColor = BHHexColor(@"626A75");
        }
        typelabel.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:typelabel];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
       [self getAuthWithUserInfoFromWechat];
    } else if (indexPath.row == 1){
        SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
        webVc.urlString = [NSString stringWithFormat:@"%@",kAppOfficialAccountsAddress];
        webVc.isHiddenLeft = NO;
        webVc.isHiddenBottom = NO;
        [self.navigationController pushViewController:webVc animated:YES];
    }else if (indexPath.row == 2){
        SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
        webVc.urlString = [NSString stringWithFormat:@"%@",kAppjoinGroupAddress];
        webVc.isHiddenLeft = NO;
        webVc.isHiddenBottom = NO;
        [self.navigationController pushViewController:webVc animated:YES];
    }else if(indexPath.row == 3){
        SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
        webVc.urlString = [NSString stringWithFormat:@"%@",kAppuserResearchAddress];
        webVc.isHiddenLeft = NO;
        webVc.isHiddenBottom = NO;
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

- (void)getAuthWithUserInfoFromWechat{
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = WechatStatueStr;
        [WXApi sendReq:req];
    } else {
        [BHToast showMessage:@"请您先安装微信"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDigInfo];
}

//挖矿 用户挖矿账户及任务状态信息
-(void)getDigInfo{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"terminal"];
    methodName = kGetDigInfo;
    
    //    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:1 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSLog(@"getDigInfo-->%@",responseObject);
            taskItem = [TaskItem yy_modelWithDictionary:responseObject[@"data"][@"task"]];
            InfoObject *infoObject = [InfoObject yy_modelWithDictionary:responseObject[@"data"][@"info"]];
            [self.listView reloadData];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    // 向微信请求授权后,得到响应结果
    if ([response.state isEqualToString:WechatStatueStr] && response.errCode == WXSuccess) {
        //        NSLog(@"code-------->%@",response.code);
        //        NSLog(@"errStr-------->%@",response.errStr);
        
        //接口调用
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString *methodName = @"";
        if (User.userToken) {
            [pramaDic setObject:User.userToken forKey:@"bte-token"];
            [pramaDic setObject:User.userToken forKey:@"token"];
        }
        [pramaDic setObject:response.code forKey:@"code"];
        methodName = kGetWXBind;
        NSLog(@"pramaDic-------->%@",pramaDic);
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NSLog(@"kGetWXBind-------->%@",responseObject);
            NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {
                NSDictionary * data = [responseObject objectForKey:@"data"];
                if (data) {
                    [weakSelf getDigInfo];
                }
//                AddAttentionView *v = [[AddAttentionView alloc] initAlertView];
//                [v setConfirmCallBack:^(BOOL isComplete, NSString *returnStr) {
//                    if (isComplete) {
//
//                    }
//                }];
            }
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error----kGetWXBind---->%@",error);
        }];
    }
}
@end
