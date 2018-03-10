//
//  BTEMyAccountTableViewCell.h
//  BTE
//
//  Created by wangli on 2018/3/8.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTEAccountDetailsModel.h"

@protocol JumpToDetailDelegate <NSObject>
//跳转投资详情页
-(void)jumpToDetail:(NSString *)productId;//
@end

@interface BTEMyAccountTableViewCell : UITableViewCell
{
    BTEAccountDetailsModel *_model;
}
@property(nonatomic, strong) UILabel *titleLabel;//标题
@property(nonatomic, strong) UILabel *subTitleLabel1;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel2;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel3;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel4;//副标题
@property(nonatomic, strong) UILabel *detailLabel1;//详情
@property(nonatomic, strong) UILabel *detailLabel2;//详情
@property(nonatomic, strong) UILabel *detailLabel3;//详情
@property(nonatomic, strong) UILabel *detailLabel4;//详情
@property(nonatomic, strong) UILabel *subDetailLabel1;//副详情
@property(nonatomic, strong) UILabel *subDetailLabel2;//副详情
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, weak) id <JumpToDetailDelegate>delegate;
//刷新数据UI
-(void)setCellWithModel:(BTEAccountDetailsModel *)model;
@end
