//
//  BTEFreandCountViewController.h
//  BTE
//
//  Created by wangli on 2018/4/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"

@interface BTEFreandCountViewController : BHBaseController<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel1;
}
@property (nonatomic,retain) UITableView *setTableView;//邀请好友
@property (nonatomic,retain) NSArray *dataArr;
@end
