//
//  SecondaryLevelWebViewController.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/8/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BaseWebViewController.h"
#import "HomeProductInfoModel.h"
#import "HomeDesListModel.h"
#import "HomeDescriptionModel.h"
#import "BTELoginVC.h"
#import "BTEShareView.h"
#import "BTEInviteFriendViewController.h"
#import "HomeDogCountModel.h"
#import "BTEKlineViewController.h"
#import "JPUSHService.h"
#import "SharePicView.h"

@interface SecondaryLevelWebViewController : BaseWebViewController{
    //设置状态栏颜色
    UIView *_statusBarView;
}
@property (nonatomic,strong) HomeProductInfoModel *productInfoModel;//策略跟随列表model
@property (nonatomic,strong) HomeDesListModel * desListModel;//市场分析列表model
@property (nonatomic,strong) NSString *ActivityId;//活动页ID

//分享需要的参数
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;

@property (nonatomic, strong) NSString *invteCodeStr;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;

/**
 默认不是 Present 出来的 ViewContrller 默认值是 NO
 
 */
@property (nonatomic,assign) BOOL isPresentVCFlag;
@property (nonatomic,assign) BOOL isFromReviewLuZDog;
@end
