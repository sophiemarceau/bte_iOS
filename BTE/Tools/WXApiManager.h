//
//  WXApiManager.h
//  BTE
//
//  Created by sophie on 2018/9/25.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvAuthResponse:(SendAuthResp *_Nullable)response;

@end
NS_ASSUME_NONNULL_BEGIN

@interface WXApiManager : NSObject<WXApiDelegate>
@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;
@end

NS_ASSUME_NONNULL_END
