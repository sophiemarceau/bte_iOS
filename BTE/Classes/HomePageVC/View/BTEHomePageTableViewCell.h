//
//  BTEHomePageTableViewCell.h
//  BTE
//
//  Created by wangli on 2018/3/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDesListModel.h"
@interface BTEHomePageTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *iconImage;//图片
@property(nonatomic, strong) UILabel *subTitleLabel1;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel2;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel3;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel4;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel5;//副标题
@property(nonatomic, strong) UIView *buttonView;//背景视图
@property(nonatomic, strong) UIView *lineView;//分割线视图
//刷新数据UI
-(void)setCellWithModel:(HomeDesListModel *)model;
@end
