//
//  BTEHomePageTableView.h
//  BTE
//
//  Created by wangli on 2018/3/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDescriptionModel.h"
#import "HomeDesListModel.h"
#import "HomeProductModel.h"
#import "HomeProductInfoModel.h"
@protocol HomePageTableViewDelegate <NSObject>
//当前跟投 已结束策略 按钮切换事件
//-(void)switchButton:(NSInteger)type;//type 1 当前跟投 2 已结束策略
//-(void)logout;//退出登录
//-(void)jumpToDetails:(NSString *)productId;//
@end
@interface BTEHomePageTableView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isShow; // 市场分析是否展开
    float defaultHeight;//四行文字默认高度
    float fixedHeight;//其它固定高度 此处市场分析高度
    float btnHeight;//更多箭头高度
    
    
    HomeDescriptionModel *descriptionModel;
    NSArray *_dataSource;
    NSArray *productList;
    HomeProductInfoModel *productInfoModel;
    
}
@property (nonatomic,retain) UITableView *homePageTableView;//市场分析视图
@property(nonatomic,weak) id <HomePageTableViewDelegate>delegate;

//刷新数据UI
-(void)refreshUi:(NSArray *)model productList:(NSArray *)productListModel model1:(HomeDescriptionModel *)DescriptionModel model2:(HomeProductInfoModel *)ProductInfoModel;
@end
