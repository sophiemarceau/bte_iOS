//
//  BTEHomePageViewController.h
//  BTE
//
//  Created by wangli on 2018/1/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
#import "BTEHomePageTableView.h"
@interface BTEHomePageViewController : BHBaseController<HomePageTableViewDelegate>
@property (nonatomic,retain) BTEHomePageTableView *homePageTableView;//市场分析视图



@property (nonatomic, strong) UIViewController *luzDogVc;
@property (nonatomic, strong) UIViewController *brandDogVc;
@property (nonatomic, strong) UIViewController *contractDogVc;
@property (nonatomic, strong) UIViewController *researchDogVc;
@end
