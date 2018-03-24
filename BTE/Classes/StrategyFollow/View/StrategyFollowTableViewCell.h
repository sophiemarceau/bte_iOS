//
//  StrategyFollowTableViewCell.h
//  BTE
//
//  Created by wangli on 2018/3/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeProductInfoModel.h"
@interface StrategyFollowTableViewCell : UITableViewCell
@property(nonatomic, strong) UIView *bgView;//图片
@property(nonatomic, strong) UIImageView *image2;//副标题
@property(nonatomic, strong) UILabel *titleLabel2;//副标题
@property(nonatomic, strong) UILabel *titleLabel3;//副标题
@property(nonatomic, strong) UIView *bgView1;//副标题
@property(nonatomic, strong) UILabel *titleLabel7;//副标题
@property(nonatomic, strong) UILabel *titleLabel4;//背景视图
@property(nonatomic, strong) UILabel *titleLabel5;//分割线视图
//刷新数据UI
-(void)setCellWithModel:(HomeProductInfoModel *)productInfoModel;
@end
