//
//  TaskItem.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/10/31.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskItem : NSObject
@property (nonatomic, copy)   NSString *bindWx;
@property (nonatomic, copy)   NSString *invite;
@property (nonatomic, copy)   NSString *followWx;
@property (nonatomic, copy)   NSString *feedback;
@property (nonatomic, copy)   NSString *read;
@property (nonatomic, copy)   NSString *reportStatus;
@property (nonatomic, copy)   NSString *share;
@property (nonatomic, copy)   NSString *reportUrl;
@property (nonatomic, copy)   NSString *sign;
@property (nonatomic, copy)   NSString *join;
@end

NS_ASSUME_NONNULL_END
