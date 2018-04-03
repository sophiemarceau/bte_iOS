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
        [self setTableFooterView];
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
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    headView.backgroundColor = KBGColor;

    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 124) / 2, 29, 124, 25)];
    image1.image = [UIImage imageNamed:@"bottom_sb_bluerun"];
    [headView addSubview:image1];
    self.strategyFollowTableView.tableFooterView = headView;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDetail:)]) {
        HomeProductInfoModel *model = _dataSource[indexPath.row];
        [self.delegate jumpToDetail:model];
    }
}

@end
