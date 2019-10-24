//
//  DigItem.h
//  BTE
//
//  Created by sophie on 2018/10/31.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DigItem : NSObject
@property (nonatomic, copy)   NSString *bindWxPower;
@property (nonatomic, copy)   NSString *start;
@property (nonatomic, copy)   NSString *followWxPower;
@property (nonatomic, copy)   NSString *invitePower;
@property (nonatomic, copy)   NSString *sharePower;
@property (nonatomic, copy)   NSString *signPower;
@property (nonatomic, copy)   NSString *regPower;
@property (nonatomic, copy)   NSString *feedbackPower;
@property (nonatomic, copy)   NSString *rule;
@property (nonatomic, copy)   NSString *shareMaxPower;
@property (nonatomic, copy)   NSString *end;
@property (nonatomic, copy)   NSString *readPower;
@property (nonatomic, copy)   NSString *inviteMaxPower;
@property (nonatomic, copy)   NSString *status;

@property (nonatomic, copy)   NSString *signMaxPower;
@end

NS_ASSUME_NONNULL_END
