//
//  InfoObject.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/10/31.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoObject : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *signStatus;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *openTime;
@property (nonatomic, copy) NSString *totalPower;
@property (nonatomic, copy) NSString *digStartTime;
@property (nonatomic, copy) NSString *digEndTime;
@property (nonatomic, copy) NSString *inviteCount;
@property (nonatomic, copy) NSString *totalIncome;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *id;
@end

NS_ASSUME_NONNULL_END
