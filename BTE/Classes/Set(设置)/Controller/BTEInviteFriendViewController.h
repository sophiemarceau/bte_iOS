//
//  BTEInviteFriendViewController.h
//  BTE
//
//  Created by wangli on 2018/4/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
#import "BTEShareView.h"
typedef NS_ENUM(NSUInteger, FromVCType)
{
    FromPersonVC,
    FromScroeVC,
};
@interface BTEInviteFriendViewController : BHBaseController
@property (nonatomic,retain) UITableView *setTableView;//邀请好友
@property (nonatomic,strong) NSDictionary *dicInvate;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;
@property (nonatomic, assign) FromVCType fromVCType;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@end
