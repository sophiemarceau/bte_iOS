//
//  SecondLevelWebViewController.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/26.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseWebVC.h"
#import "HomeProductInfoModel.h"
#import "HomeDesListModel.h"
#import "HomeDescriptionModel.h"
#import "BTELoginVC.h"
#import "BTEShareView.h"
#import "BTEInviteFriendViewController.h"
#import "HomeDogCountModel.h"
#import "BTEKlineViewController.h"
#import "JPUSHService.h"
@interface SecondLevelWebViewController : BHBaseWebVC
@property (nonatomic,strong) HomeProductInfoModel *productInfoModel;//策略跟随列表model
@property (nonatomic,strong) HomeDesListModel * desListModel;//市场分析列表model
@property (nonatomic,strong) NSString *ActivityId;//活动页ID

//分享需要的参数
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;

/**
  默认不是 Present 出来的 ViewContrller 默认值是 NO
 
 */
@property (nonatomic, assign) BOOL isPresentVCFlag;



@property(nonatomic,assign) BOOL isFromReviewLuZDog;
@end
