//
//  BTEFSKLineViewController.h
//  BTE
//
//  Created by wanmeizty on 2018/6/4.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
#import "HomeDesListModel.h"

@interface BTEFSKLineViewController : BHBaseController
@property (assign, nonatomic)UIInterfaceOrientation orientation;
@property (nonatomic,strong) HomeDesListModel * model;
@property (nonatomic,copy) NSString * base;
@property (nonatomic,copy) NSString * quote;
@property (nonatomic,copy) NSString * exchange;

@end
