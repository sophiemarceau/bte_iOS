//
//  UserStatistics.h
//  BTE
//
//  Created by sophie on 2018/7/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStatistics : NSObject
+ (void)configure;
+ (void)enterPageViewWithPageID:(NSString *)pageID;
+ (void)leavePageViewWithPageID:(NSString *)pageID;
+ (void)sendEventToServer:(NSString *)eventId;
+ (void)sendEventToServer:(NSString *)eventId WithRow:(NSString *)rowStr;
@end
