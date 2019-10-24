//
//  BTEFullScreenKlineViewController.h
//  BTE
//
//  Created by wanmeizty on 2018/5/21.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
#import "HomeDesListModel.h"

@interface BTEFullScreenKlineViewController : BHBaseController
@property (assign, nonatomic)UIInterfaceOrientation orientation;
@property (nonatomic,strong) HomeDesListModel * desListModel;
@property (nonatomic,copy) NSString * base;
@property (nonatomic,copy) NSString * quote;
@property (nonatomic,copy) NSString * exchange;
@end
