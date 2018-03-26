//
//  BTEStrategyFollowViewController.h
//  BTE
//
//  Created by wangli on 2018/3/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
#import "BTEStrategyFollowTableView.h"
@interface BTEStrategyFollowViewController : BHBaseController<StrategyFollowTableViewDelegate>
@property (nonatomic,retain) BTEStrategyFollowTableView *strategyFollowTableView;//策略跟随视图
@end
