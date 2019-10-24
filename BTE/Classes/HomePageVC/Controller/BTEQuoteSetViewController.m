//
//  BTEQuoteSetViewController.m
//  BTE
//
//  Created by wanmeizty on 2018/7/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEQuoteSetViewController.h"

@interface BTEQuoteSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@end

@implementation BTEQuoteSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"指标设置";

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.dataSource = @[@[@"MA 移动平均线",@"EMA 平滑移动平均线",@"BOLL 布林线",@"SAR 停损点转向指标"],@[@"MACD 指数平滑移动平均线",@"KDJ 随机指标",@"RSI 相对强弱指标"]];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"quote"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"quote"];
    }
    NSArray * arr = self.dataSource[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
