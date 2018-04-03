//
//  BTELeftView.m
//  BTE
//
//  Created by wangli on 2018/4/2.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTELeftView.h"
@interface BTELeftView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) ActivateNowCallBack activateNowCallBack;
@property (nonatomic, copy) CalcelCallBack cancelCallBack;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSArray* array;
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
    actView.backgroundColor = kColorRgba(0, 0, 0, 0.1);
    [[UIApplication sharedApplication].keyWindow addSubview:actView];
    
    //点击手势
    UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:actView action:@selector(doTapChange)];
    [actView addGestureRecognizer:r5];
    
    
    
    actView.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 240, SCREEN_HEIGHT) style:UITableViewStylePlain];
    actView.tableView.backgroundColor = [UIColor yellowColor];
    actView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    actView.tableView.delegate = actView;
    actView.tableView.dataSource = actView;
    [actView addSubview:actView.tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actView.tableView.width, 60)];
    headView.backgroundColor = [UIColor redColor];
    actView.tableView.tableHeaderView = headView;
    
    actView.array = @[@"🏠市场分析",@"💰策略跟随",@"🐷我的账户"];
    
    
    [UIView animateWithDuration:1 animations:^{
        actView.left = 0;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UIColor *color = [[UIColor alloc]initWithRed:220/255.0 green:230/255.0 blue:240/255.0 alpha:0.5];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = color;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    cell.textLabel.highlightedTextColor = [UIColor greenColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    AppDelegate* GHDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
//    ViewController1_1* vc = [[ViewController1_1 alloc] init];
//
//    //通过GHDelegate.tabBar.selectedIndex获得当前tabbaritem对应的nav,进行页面跳转
//    NSArray *arrControllers = GHDelegate.tabBar.viewControllers;
//
//    if (GHDelegate.tabBar.selectedIndex==0) {
//        UINavigationController* nav = (UINavigationController* )[arrControllers objectAtIndex:0];
//        //隐藏sideMenuViewController
//        [self.sideMenuViewController hideMenuViewController];
//        //隐藏底部
//        vc.hidesBottomBarWhenPushed = YES;
//        [nav pushViewController:vc animated:YES];
//    }else{
//        UINavigationController* nav = (UINavigationController* )[arrControllers objectAtIndex:1];
//        [self.sideMenuViewController hideMenuViewController];
//        vc.hidesBottomBarWhenPushed = YES;
//        [nav pushViewController:vc animated:YES];
//    }
    
}

- (void)doTapChange
{
    [UIView animateWithDuration:1 animations:^{
        self.left = -SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}






// 取消
- (void)cancelbuttondismiss {
    if (self.cancelCallBack) {
        self.cancelCallBack();
    }
    [self removeFromSuperview];
}
// 立即激活
- (void)confirmbuttondismiss {
    if (self.activateNowCallBack) {
        self.activateNowCallBack();
    }
    [self removeFromSuperview];
}

- (void)dealloc
{
    
}

@end
