//
//  TTJPushNoticeManager.m
//  noMiss
//
//  Created by wy on 15/10/24.
//  Copyright (c) 2015年 北京币易有限公司. All rights reserved.
//

#import "TTJPushNoticeManager.h"
#import "BTEHomeWebViewController.h"
@interface TTJPushNoticeManager ()


@end

@implementation TTJPushNoticeManager
+(instancetype)shareManger;
{
    static TTJPushNoticeManager *managerJ = nil;
    static dispatch_once_t predicate ;
    dispatch_once(&predicate, ^{
        managerJ = [[self alloc] init];
    });
    
    return managerJ;
}


-(void)jpushwithParam:(NSDictionary *)dict WithVC:(UIViewController *)controller;
{
    /*
     
     收到通知:{
     "_j_business" = 1;
     "_j_msgid" = 36028798247780287;
     "_j_uid" = 17044088536;
     aps =     {
     alert = "\U6d4b\U8bd5Notification\U901a\U77e5";
     badge = 0;
     sound = "";
     };
     id = 1;
     title = "\U6d4b\U8bd5\U901a\U77e5";
     type = report;
     }

     */
    
    
    
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    
    //type  report市场分析详情
    if ([[dict objectForKey:@"type"] isEqualToString:@"report"]) {
        
        BTEHomeWebViewController *homePageVc= [[BTEHomeWebViewController alloc] init];
        
        homePageVc.urlString = [NSString stringWithFormat:@"%@/%@",kAppDetailDealAddress,[dict objectForKey:@"id"]];
        homePageVc.isHiddenLeft = YES;
        homePageVc.isHiddenBottom = NO;
//        homePageVc.descriptionModel = model;
        [controller.navigationController pushViewController:homePageVc animated:YES];
        
    }
}

@end
