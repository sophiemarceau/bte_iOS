//
//  BTECommunityDescViewController.h
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
#import "BTECommontModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTECommunityDescViewController : BHBaseController
@property (strong,nonatomic) BTECommontModel * model;
@property (assign,nonatomic) BOOL isRead; // 消息中心判断是否未读
@property (copy,nonatomic) void (^fresh)(void);
@end

NS_ASSUME_NONNULL_END
