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
#import <JhtMarquee/JhtVerticalMarquee.h>
#import "HomeDogCountModel.h"
#import "HomeBannerModel.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "AtmosphereModel.h"

@protocol HomePageTableViewDelegate <NSObject>
//当前跟投 已结束策略 按钮切换事件
//-(void)switchButton:(NSInteger)type;//type 1 当前跟投 2 已结束策略
- (void)doTapChange:(NSString *)name;//选择币种
- (void)jumpToDetail:(HomeDesListModel *)model;
- (void)jumpToDetails:(HomeDescriptionModel *)model;
- (void)jumpToStrategyFollow:(HomeProductInfoModel *)productModel;
- (void)jumpToTradeDataPage;
- (void)jumpToDogPage;
- (void)jumpToBandDogPage;
- (void)closeGonggao;//关闭公告
- (void)jumpToStrategyList;
- (void)hidden;
- (void)jumpToChatPage;
- (void)onclickMarketflashStatistic;//点击市场快讯统计
- (void)jumpToContractDogPage;
- (void)jumpToResearchDogPage;
- (void)jumpToStareDogPage;
- (void)jumpToChainCheckPage;
- (void)gotoAtmosphereVc:(int)vctag;//跳空气H5
- (void)bannberJumpToWebView:(NSString *)urlStr;//轮播图跳转
@end
@interface BTEHomePageTableView : UIView<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
{
    BOOL _isShow; // 市场分析是否展开
    float defaultHeight;//四行文字默认高度
    float defaultScrollHeight;//滚动视图默认高度
    float fixedHeight;//其它固定高度 此处市场分析高度
    float btnHeight;//更多箭头高度
    
    HomeDesListModel *headModel;
    HomeDescriptionModel *descriptionModel;
    HomeDogCountModel *luzdogCountModel,*banddogyModel,*startdogModel,*researchdoyModel,*contractdogModel,*lianchachaModel;
    AtmosphereModel *atmosphereModel;
    NSString *bandDogCountStr,*contractDogCountStr ,*researchDogCountStr,*angencyCountStr;
    
    
    NSArray *productList;
//    HomeProductInfoModel *productInfoModel;
    NSArray <HomeProductInfoModel *>*productInfoArray;
    NSArray <HomeBannerModel *>*bannerArray;
    NSArray *anouncement;
    // 上下滚动的跑马灯
    JhtVerticalMarquee *_verticalMarquee;
    // 是否暂停了上下滚动的跑马灯
    BOOL _isPauseV;
    
    UIImageView *newImageView ;
    NSString *btcStr;
    NSString *ethStr;
    NSString *eosStr;
    NSString *bchStr;
}
@property (nonatomic, strong) NSArray *dataSource;
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

@property (nonatomic, strong) TYCyclePagerView *bannrView;
@property (nonatomic, strong) UIView *atmosphereView;
@property (nonatomic, strong) UIView *marketView;
@property (nonatomic,strong) UILabel *marketTitleLabel,*marketDateLabel;

@property (nonatomic, strong) NSMutableArray *btnViewsArray,*accountArray;

//刷新数据UI
//-(void)refreshUi:(NSArray *)model productList:(NSArray *)productListModel model1:(HomeDescriptionModel *)DescriptionModel model2:(NSArray <HomeProductInfoModel *>*)productInfoModelList currentCurrencyType:(NSString *)currentCurrencyType anouncement:(NSArray *)announcement dogViewCount:(HomeDogCountModel *)dogCountModel WithBandDogCount:(NSString *)BandDogCountStr WithContractDoyCount:(NSString *)contractDogCountStr WithResearchDogCountStr:(NSString *)researchDogCountStr WithBannerArray:(NSArray<HomeBannerModel *>*)bannerList WithAgencyCountStr:(NSString *)AgencyCountStr;

-(void)refreshUi:(NSArray *)model productList:(NSArray *)productListModel model1:(HomeDescriptionModel *)DescriptionModel model2:(NSArray <HomeProductInfoModel *>*)productInfoModelList currentCurrencyType:(NSString *)currentCurrencyType anouncement:(NSArray *)announcement dogViewCount:(HomeDogCountModel *)dogCountModel WithBandDog:(HomeDogCountModel *)bandDog WithContractDog:(HomeDogCountModel *)contractDog WithResearchDog:(HomeDogCountModel *)researchDog WithBannerArray:(NSArray<HomeBannerModel *>*)bannerList WithStartDog:(HomeDogCountModel *)stareDog WithAtmosphereData:(AtmosphereModel *)atmoModel Withlianchacha:(HomeDogCountModel *)lianchachaModel;
//为了 实时更新币价
-(void)updateCoin:(NSArray *)coinArray;


//为了 更新主页的更新提示
-(void)pushAttention:(NSString *)eventTypeStr;

-(void)pushAttentioncoinString:(NSString *)coinString;
@end
