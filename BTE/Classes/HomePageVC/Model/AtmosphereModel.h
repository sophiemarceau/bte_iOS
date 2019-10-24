//
//  AtmosphereModel.h
//  BTE
//
//  Created by sophie on 2018/10/16.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AtmosphereModel : NSObject
@property(nonatomic,copy)NSString *airIndex;//空气指数
@property(nonatomic,copy)NSString *amount;//交易规模
@property(nonatomic,copy)NSString *netAmount;//资金流向
@end

NS_ASSUME_NONNULL_END
