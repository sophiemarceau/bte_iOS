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
- (void)doTapChange:(NSString *)name;//选择币种
- (void)jumpToDetail:(NSString *)name;
@end
@interface BTEHomePageTableView : UIView<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    BOOL _isShow; // 市场分析是否展开
    float defaultHeight;//四行文字默认高度
    float defaultScrollHeight;//滚动视图默认高度
    float fixedHeight;//其它固定高度 此处市场分析高度
    float btnHeight;//更多箭头高度
    
    HomeDesListModel *headModel;
    HomeDescriptionModel *descriptionModel;
    NSArray *_dataSource;
    NSArray *productList;
    HomeProductInfoModel *productInfoModel;
    
}
@property (nonatomic,retain) UITableView *homePageTableView;//市场分析视图
/**
 加载的webView
 */
@property (nonatomic, strong) UIWebView * webView;
/**
 加载的URL
 */
@property (nonatomic, copy)NSString * urlString;
@property(nonatomic,weak) id <HomePageTableViewDelegate>delegate;

@property(nonatomic, strong) UIImageView *iconImage;//图片
@property(nonatomic, strong) UIImageView *iconImage1;//图片
@property(nonatomic, strong) UILabel *subTitleLabel1;//副标题
//@property(nonatomic, strong) UILabel *subTitleLabel2;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel3;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel4;//副标题
@property(nonatomic, strong) UILabel *subTitleLabel5;//副标题
@property(nonatomic, strong) UIView *buttonView;//背景视图



//刷新数据UI
-(void)refreshUi:(NSArray *)model productList:(NSArray *)productListModel model1:(HomeDescriptionModel *)DescriptionModel model2:(HomeProductInfoModel *)ProductInfoModel currentCurrencyType:(NSString *)currentCurrencyType;
@end
