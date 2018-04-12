//
//  BTEFreandCountViewController.m
//  BTE
//
//  Created by wangli on 2018/4/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEFreandCountViewController.h"

@interface BTEFreandCountViewController ()

@end

@implementation BTEFreandCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KBGColor;
    self.title = @"邀请结果";
    [self creatView];
    [self getUserInvateFrend];
}

- (void)creatView
{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 315) / 2, 30, 315, 416)];
    bgImage.image = [UIImage imageNamed:@"bg_image_invate"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((bgImage.width - 250) / 2, 35, 250, 16)];
    titleLabel1.font = UIFontRegularOfSize(16);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您已成功邀请%ld位好友",_dataArr.count]];
    
    [str addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308cdd") range:NSMakeRange(6,str.length - 9)];
    [str addAttribute:NSFontAttributeName value:UIFontRegularOfSize(20) range:NSMakeRange(6,str.length - 9)];
    titleLabel1.attributedText = str;
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor = BHHexColor(@"626A75");
    [bgImage addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(54, 123, 100, 12)];
    titleLabel2.text = @"用户";
    titleLabel2.font = UIFontRegularOfSize(12);
    titleLabel2.alpha = 0.6;
    titleLabel2.textColor = BHHexColor(@"626A75");
    [bgImage addSubview:titleLabel2];
    
    UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake((bgImage.width - 69 - 100), titleLabel2.top, 100, 12)];
    titleLabel3.text = @"注册时间";
    titleLabel3.textAlignment = NSTextAlignmentRight;
    titleLabel3.font = UIFontRegularOfSize(12);
    titleLabel3.alpha = 0.6;
    titleLabel3.textColor = BHHexColor(@"626A75");
    [bgImage addSubview:titleLabel3];
    
    _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 135, bgImage.width, bgImage.height - 137) style:UITableViewStylePlain];
    _setTableView.backgroundColor = [UIColor clearColor];
    _setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    _setTableView.bounces = NO;
    _setTableView.showsVerticalScrollIndicator = NO;
    [bgImage addSubview:_setTableView];
    
    
}

//获取邀请好友结果
- (void)getUserInvateFrend
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kGetUserInvateFrendCount;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            _dataArr = [responseObject objectForKey:@"data"];
            [weakSelf.setTableView reloadData];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您已成功邀请%ld位好友",_dataArr.count]];
            
            [str addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"308cdd") range:NSMakeRange(6,str.length - 9)];
            [str addAttribute:NSFontAttributeName value:UIFontRegularOfSize(20) range:NSMakeRange(6,str.length - 9)];
            titleLabel1.attributedText = str;
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
    }];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22 + 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, 20, 100, 14)];
    label.font = UIFontRegularOfSize(14);
    label.text = [_dataArr[indexPath.row] objectForKey:@"tel"];
    label.textColor = BHHexColor(@"626A75");
    [cell.contentView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((315 - 26 - 160), 20, 160, 14)];
    label1.font = UIFontRegularOfSize(14);
    label1.text = [_dataArr[indexPath.row] objectForKey:@"date"];
    label1.textAlignment = NSTextAlignmentRight;
    label1.textColor = BHHexColor(@"626A75");
    [cell.contentView addSubview:label1];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
