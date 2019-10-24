//
//  BTEKlineViewController.h
//  BTE
//
//  Created by wanmeizty on 2018/5/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"

#import "HomeDesListModel.h"

@interface BTEKlineViewController : BHBaseController
@property (nonatomic,strong) HomeDesListModel * desListModel;
@property (assign,nonatomic) BOOL isRead;
@end
