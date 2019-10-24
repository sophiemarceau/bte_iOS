//
//  UserStatistics.m
//  BTE
//
//  Created by sophie on 2018/7/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "UserStatistics.h"
#import <UMAnalytics/MobClick.h>

@implementation UserStatistics

+ (void)configure
{
    
}

#pragma mark -- 页面统计部分

+ (void)enterPageViewWithPageID:(NSString *)pageID
{
    //进入页面
    NSLog(@"enterPageViewWithPageID---------模拟发送[进入页面]事件给服务端，页面ID:%@", pageID);
    [MobClick beginLogPageView:pageID]; //("Pagename"为页面名称，可自定义)
    
//    if ([pageID isEqualToString:@"PAGE_EVENT_TradePage"]) {
//        [MobClick event:@"点击行情tab"];
//    }
}

+ (void)leavePageViewWithPageID:(NSString *)pageID
{
    //离开页面
    NSLog(@"leavePageViewWithPageID---------模拟发送[离开页面]事件给服务端，页面ID:%@", pageID);
    [MobClick endLogPageView:pageID]; //("Pagename"为页面名称，可自定义)
}


#pragma mark -- 自定义事件统计部分


+ (void)sendEventToServer:(NSString *)eventId
{
    //在这里发送event统计信息给服务端
    NSLog(@"sendEFventToServer---------模拟发送点击统计事件给服务端，事件ID: %@", eventId);
    
    [MobClick event:eventId];
    
}


+ (void)sendEventToServer:(NSString *)eventId WithRow:(NSString *)rowStr
{
    //在这里发送event统计信息给服务端
    NSLog(@"sendEventToServer---------模拟发送点击统计事件给服务端，事件ID: %@---rowStr--->%@", eventId,rowStr);
    
    [MobClick event:eventId label:rowStr];
    
}
@end
