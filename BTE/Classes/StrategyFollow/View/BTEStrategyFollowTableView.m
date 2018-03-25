//
//  BTEStrategyFollowTableView.m
//  BTE
//
//  Created by wangli on 2018/3/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEStrategyFollowTableView.h"
#import "StrategyFollowTableViewCell.h"
@implementation BTEStrategyFollowTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _strategyFollowTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _strategyFollowTableView.backgroundColor = KBGCell;
        _strategyFollowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _strategyFollowTableView.delegate = self;
        _strategyFollowTableView.dataSource = self;
        [self addSubview:_strategyFollowTableView];
//        [self setTableHeadView];
//        [self setTableFooterView];
    }
    return self;
}

//设置头部视图
- (void)setTableHeadView
{
    
}

//设置尾部视图
- (void)setTableFooterView
{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 143)];
//    headView.backgroundColor = KBGColor;
//
//    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 29, 74, 74)];
//    image1.image = [UIImage imageNamed:@"erweima"];
//    [headView addSubview:image1];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 106, 80, 14)];
//    titleLabel.text = @"打开微信,扫一扫";
//    titleLabel.font = UIFontRegularOfSize(10);
//    titleLabel.textColor = BHHexColor(@"AEAEAE");
//    [headView addSubview:titleLabel];
//
//    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(126, 31, 22, 12)];
//    image2.image = [UIImage imageNamed:@"home_dibu_logo"];
//    [headView addSubview:image2];
//
//    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(151, 24, 195, 25)];
//    titleLabel1.text = @"玩转比特币 多看比特易";
//    titleLabel1.font = UIFontRegularOfSize(14);
//    titleLabel1.textColor = BHHexColor(@"696969");
//    [headView addSubview:titleLabel1];
//
//    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(126, 53, SCREEN_WIDTH - 126 - 18, 25)];
//    titleLabel2.text = @"比特易是业界领先的数字货币市场专业分析平台，我们提供专业数字货币市场分析工具和风险管理策略，帮您有效控制数字货币投资风险。";
//    titleLabel2.font = UIFontRegularOfSize(10);
//    titleLabel2.numberOfLines = 0;
//    titleLabel2.textColor = BHHexColor(@"525866");
//    [titleLabel2 sizeToFit];
//    [headView addSubview:titleLabel2];
//    self.strategyFollowTableView.tableFooterView = headView;
}

//刷新数据UI
-(void)refreshUi:(NSArray *)model
{
    _dataSource = model;
    [self setTableHeadView];
    [self.strategyFollowTableView reloadData];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeight:_dataSource[indexPath.row]];
}

- (float)cellHeight:(HomeProductInfoModel *)productInfoModel
{
        CGRect rect = [productInfoModel.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 160, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontRegularOfSize(14)} context:nil];
    
    
    return 48 + 46 + 23 + rect.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    StrategyFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[StrategyFollowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCellWithModel:_dataSource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
