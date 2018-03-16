//
//  BTEMyAccountTableView.h
//  BTE
//
//  Created by wangli on 2018/3/8.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTEAllAmountModel.h"
#import "BTELegalAccount.h"
#import "BTEBtcAccount.h"
#import "BTEStatisticsModel.h"
#import "BTEAccountDetailsModel.h"
#import "BTEMyAccountTableViewCell.h"
@protocol MyAccountTableViewDelegate <NSObject>
//当前跟投 已结束策略 按钮切换事件
-(void)switchButton:(NSInteger)type;//type 1 当前跟投 2 已结束策略
-(void)logout;//退出登录
-(void)jumpToDetails:(NSString *)productId;//
@end
@interface BTEMyAccountTableView : UIView<UITableViewDelegate,UITableViewDataSource,JumpToDetailDelegate,UIScrollViewDelegate>
{
    BTEAllAmountModel *amountModel;
    BTELegalAccount *legalAccountModel;
    BTEBtcAccount *btcAccountModel;
    BTEStatisticsModel *statisticsModel;
    NSInteger type;//1 当前跟投 2结束跟投
    UIImageView *bgImageView;
    UILabel *labelRefresh;
}
@property (nonatomic,retain) UITableView *myAccountTableView;//我的账户视图
@property(nonatomic,weak) id <MyAccountTableViewDelegate>delegate;
@property (nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) UILabel *titleLabel;//标题
@property(nonatomic, strong) UILabel *subTitleLabel1;//副标题
@property(nonatomic, strong) UILabel *detailLabel1;//详情
@property(nonatomic, strong) UILabel *detailLabel2;//详情
@property(nonatomic, strong) UILabel *detailLabel3;//详情
@property(nonatomic, strong) UILabel *detailLabel4;//详情
@property(nonatomic, strong) UIButton *commitButton1;//当前跟投
@property(nonatomic, strong) UIButton *commitButton2;//已结束策略
@property(nonatomic, strong) UILabel *lineLabel1;//下划线
@property(nonatomic, strong) UILabel *lineLabel2;//下划线
//刷新数据UI
-(void)refreshUi:(NSArray *)model model1:(BTEAllAmountModel *)allAmountModel model2:(BTELegalAccount *)legalAccount model3:(BTEBtcAccount *)btcAccount model4:(BTEStatisticsModel *)statisticModel type:(NSInteger)typeValue;
@end
