//
//  BTELeftView.m
//  BTE
//
//  Created by wangli on 2018/4/2.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTELeftView.h"
#import "LeftViewTableViewCell.h"
@interface BTELeftView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, copy) ActivateNowCallBack activateNowCallBack;
@property (nonatomic, copy) CalcelCallBack cancelCallBack;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSArray* array;
@property(nonatomic,strong)NSArray* arrayImage;
@end
@implementation BTELeftView
/**
 弹窗 左视图
 */
+ (void)popActivateNowCallBack:(ActivateNowCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack
{
    BTELeftView *actView = [[BTELeftView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    actView.activateNowCallBack = activateNowCallBack;
    actView.cancelCallBack = cancelCallBack;
    actView.backgroundColor = kColorRgba(255, 255, 255, 0.1);
    [[UIApplication sharedApplication].keyWindow addSubview:actView];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, SCREEN_HEIGHT)];
    bgImage.image = [UIImage imageNamed:@"context_left_view"];
    [actView addSubview:bgImage];
    
    
    UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake((bgImage.width - 100) / 2, bgImage.height - 12 - 40, 100, 12)];
    titleLabel3.text = [NSString stringWithFormat:@"当前版本 v%@",kCurrentVersion];
    titleLabel3.font = UIFontRegularOfSize(12);
    titleLabel3.textColor = BHHexColor(@"9ECDF7");
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:titleLabel3];
    
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake((bgImage.width - 100) / 2, bgImage.height - 12 - 24, 100, 12)];
    titleLabel4.text = @"©bte.top";
    titleLabel4.font = UIFontRegularOfSize(10);
    titleLabel4.textColor = BHHexColor(@"9AD0FF");
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:titleLabel4];
    
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:actView action:@selector(doTapChange)];
    tap.delegate=actView;
    [actView addGestureRecognizer:tap];
    
    
    
    actView.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, SCREEN_HEIGHT) style:UITableViewStylePlain];
    actView.tableView.backgroundColor = [UIColor clearColor];
    actView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    actView.tableView.delegate = actView;
    actView.tableView.dataSource = actView;
    [actView addSubview:actView.tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actView.tableView.width, 205)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(115.2, 50.2, 69.4, 69.4)];
    logoImage.image = [UIImage imageNamed:@"logo_left_view"];
    [headView addSubview:logoImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 135, 100, 17)];
    titleLabel.text = @"比特易";
    titleLabel.font = UIFontRegularOfSize(17);
    titleLabel.textColor = BHHexColor(@"ffffff");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = logoImage.centerX;
    [headView addSubview:titleLabel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:MobilePhoneNum];
    UILabel *_subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(93, 155, 150, 32)];
    if (phoneNum &&phoneNum.length > 6) {
        
        if ([phoneNum rangeOfString:@"@"].location == NSNotFound) {
            NSLog(@"string 不存在 @");
            _subTitleLabel1.text = [NSString stringWithFormat:@"%@****%@",[phoneNum substringWithRange:NSMakeRange(0,3)],[phoneNum substringWithRange:NSMakeRange(phoneNum.length - 4,4)]];
        } else {
            NSLog(@"string 包含 @ location = %ld",[phoneNum rangeOfString:@"@"].location);
            _subTitleLabel1.text = [NSString stringWithFormat:@"%@****%@",[phoneNum substringWithRange:NSMakeRange(0,1)],[phoneNum substringWithRange:NSMakeRange([phoneNum rangeOfString:@"@"].location - 1,phoneNum.length - [phoneNum rangeOfString:@"@"].location + 1)]];
        }
    } else
    {
        _subTitleLabel1.text = @"点击登录";
        _subTitleLabel1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:actView action:@selector(login)];
        tap1.delegate=actView;
        [_subTitleLabel1 addGestureRecognizer:tap1];
    }
    _subTitleLabel1.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel1.centerX = logoImage.centerX;
    _subTitleLabel1.font = UIFontRegularOfSize(16);
    _subTitleLabel1.textColor = BHHexColor(@"9AD0FF");
    [headView addSubview:_subTitleLabel1];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(27, 205, 257, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.alpha = 0.1;
    [headView addSubview:lineView];
    actView.tableView.tableHeaderView = headView;
    
    actView.array = @[@"首页",@"行情数据",@"撸庄狗",@"策略",@"个人中心"];
    actView.arrayImage = @[@"home page",@"market",@"left_cell_dog",@"strategy",@"personal"];
    
    [UIView animateWithDuration:0.1 animations:^{
        actView.left = 0;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    LeftViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[LeftViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.iconImage.image = [UIImage imageNamed:self.arrayImage[indexPath.row]];
    cell.subTitleLabel1.text = self.array[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.activateNowCallBack) {
        self.activateNowCallBack(indexPath.row);
        [self doTapChange];
    }
}

- (void)doTapChange
{
    [UIView animateWithDuration:0.1 animations:^{
        self.left = -SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)login
{
    if (self.activateNowCallBack) {
        // 4 代表 跳转到 个人中心 如果没有登录 会弹出登录页面来
        self.activateNowCallBack(4);
        [self doTapChange];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]){
        
        return NO;
        
    }
    return YES;
}


- (void)dealloc
{
    
}

@end
