//
//  MyAccountViewController.h
//  BTE
//
//  Created by wangli on 2018/3/8.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
#import "BTEMyAccountTableView.h"
typedef void (^CallRefreshBlock)(void);
@interface MyAccountViewController : BHBaseController
@property (nonatomic,retain) BTEMyAccountTableView *myAccountTableView;//我的账户视图
@property (nonatomic,copy) CallRefreshBlock callRefreshBlock;
@end
