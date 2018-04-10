//
//  BTESetViewController.h
//  BTE
//
//  Created by wangli on 2018/4/10.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"

@interface BTESetViewController : BHBaseController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView *setTableView;//我的设置
@end
