//
//  BTEAmountViewController.h
//  BTE
//
//  Created by wangli on 2018/4/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"

@interface BTEAmountViewController : BHBaseController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView *setTableView;//可用余额
@property(nonatomic, strong) UILabel *detailLabel1;//详情
@property(nonatomic, strong) UILabel *detailLabel2;//详情
@property(nonatomic, strong) UILabel *detailLabel3;//详情
@property(nonatomic, strong) UILabel *detailLabel4;//详情
@property (nonatomic,strong) NSString *legalBalance;//美元
@property (nonatomic,strong) NSString *balance;//btc
@end
