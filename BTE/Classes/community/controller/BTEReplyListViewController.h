//
//  BTEReplyListViewController.h
//  BTE
//
//  Created by wanmeizty on 5/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
#import "CommontAndAnwerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTEReplyListViewController : BHBaseController
@property (strong,nonatomic) CommontAndAnwerModel * commontModel;
@property (assign,nonatomic) BOOL isread; // 消息中心判断是否未读
@property (copy,nonatomic) void (^fresh)(void);
@end

NS_ASSUME_NONNULL_END
