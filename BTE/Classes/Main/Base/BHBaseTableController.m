//
//  BHBaseTableController.m
//  BitcoinHeadlines
//
//  Created by 张竟巍 on 2017/12/23.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHBaseTableController.h"

@interface BHBaseTableController ()

@end

@implementation BHBaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSources = self.dataSources.count > 0 ? self.dataSources : @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    self.currPage = 1;
}
- (void)createTableViewStyle:(UITableViewStyle)style{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT) style:style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = BHColorGray_line;
        _tableView.backgroundColor = BHColorBgGray_VC;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    if (![self.view.subviews containsObject:_tableView]) {
        [self.view addSubview:_tableView];
    }else{
        [_tableView reloadData];
    }
}
#pragma mark - tableView delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"Identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
#pragma mark - 刷新处理
- (void)addHeaderRefesh:(BOOL)isRightNow Block:(MJRefreshComponentRefreshingBlock)block{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //默认页数从1开始。。需要跟服务器保持一致
        self.currPage = 1;
        if (block) {
            block();
        }
        //加载所有数据之后下拉刷新重置底部状态
        if (self.tableView.mj_footer && self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
            self.tableView.mj_footer.state = MJRefreshStateIdle;
        }
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    if (isRightNow) {
        [header beginRefreshing];
    }
    // 设置header
    self.tableView.mj_header = header;
    
}

-(void)addFooterRefesh:(MJRefreshComponentRefreshingBlock)block{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currPage ++;
        if (block) {
            block();
        }
    }];
}

- (void)endRefesh:(BOOL)isHeader{
    if (isHeader) {
        if (self.tableView.mj_header) {
            [self.tableView.mj_header endRefreshing];
        }
    }else{
        if (self.tableView.mj_footer) {
            [self.tableView.mj_footer endRefreshing];
        }
    }
}

-(void)noHasMoreData{
    if (self.tableView.mj_footer) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

@end
