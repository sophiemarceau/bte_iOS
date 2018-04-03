//
//  BTEStrategyFollowTableView.h
//  BTE
//
//  Created by wangli on 2018/3/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeProductInfoModel.h"
@protocol StrategyFollowTableViewDelegate <NSObject>
//当前跟投 已结束策略 按钮切换事件
//-(void)switchButton:(NSInteger)type;//type 1 当前跟投 2 已结束策略
//-(void)logout;//退出登录
- (void)jumpToDetail:(HomeProductInfoModel *)model;
@end
@interface BTEStrategyFollowTableView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataSource;
}
@property (nonatomic,retain) UITableView *strategyFollowTableView;//市场分析视图
@property(nonatomic,weak) id <StrategyFollowTableViewDelegate>delegate;

//刷新数据UI
-(void)refreshUi:(NSArray *)model;
@end
