//
//  TTJPushNoticeManager.m
//  noMiss
//
//  Created by wy on 15/10/24.
//  Copyright (c) 2015年 北京币易有限公司. All rights reserved.
//

#import "TTJPushNoticeManager.h"
#import "BTELoginVC.h"
#import "BTEKlineViewController.h"
#import "SecondaryLevelWebViewController.h"
//#import "SecondLevelWebViewController.h"
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
-(void)jpushwithParam:(NSDictionary *)dict WithVC:(UIViewController *)controller;{
    [controller.tabBarController setSelectedIndex:0];
    return;
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if (dict == nil) { //返回首页
//        [controller.tabBarController setSelectedIndex:0];
//        return;
//    }
//    //type  dog 首页
////    if ([[dict objectForKey:@"type"] isEqualToString:@"dog"]) {
////        [controller.navigationController popToRootViewControllerAnimated:NO];
////        [controller.tabBarController setSelectedIndex:0];
////    }
//
//
//    //type  report市场分析详情
//    if ([[dict objectForKey:@"target"] isEqualToString:@"report"]) {
//        SecondaryLevelWebViewController *homePageVc= [[SecondaryLevelWebViewController alloc] init];
//        homePageVc.urlString = [NSString stringWithFormat:@"%@%@",kAppDetailDealAddress,[dict objectForKey:@"id"]];
//        homePageVc.isHiddenLeft = YES;
//        homePageVc.isHiddenBottom = YES;
//        [controller.navigationController pushViewController:homePageVc animated:YES];
//        return;
//    }
//
////     //type 撸庄狗
////    if ([[dict objectForKey:@"type"] isEqualToString:@"feature_lz_dog"]) {
////        SecondaryLevelWebViewController *luzhuangDogVC= [[SecondaryLevelWebViewController alloc] init];
////        luzhuangDogVC.urlString = [NSString stringWithFormat:@"%@",kAppBTEH5DogAddress];
////        luzhuangDogVC.isHiddenLeft = YES;
////        luzhuangDogVC.isHiddenBottom = YES;
////        [controller.navigationController pushViewController:luzhuangDogVC animated:YES];
////    }
//
////    //type 波段狗
////    if ([[dict objectForKey:@"type"] isEqualToString:@"feature_band_dog"]) {
////        NSString *baseAssetStr = [dict objectForKey:@"baseAsset"];
////        SecondaryLevelWebViewController *bandDogVc= [[SecondaryLevelWebViewController alloc] init];
////        bandDogVc.urlString = [NSString stringWithFormat:@"%@?name=%@",kAppBrandDogAddress,baseAssetStr];
////        bandDogVc.isHiddenLeft = YES;
////        bandDogVc.isHiddenBottom = YES;
////        [controller.navigationController pushViewController:bandDogVc animated:YES];
////    }
//
//    //type 周报
//    if ([[dict objectForKey:@"target"] isEqualToString:@"weekPaper"]) {
//        SecondaryLevelWebViewController *weekPaperVc= [[SecondaryLevelWebViewController alloc] init];
//        weekPaperVc.urlString = kAppBTEH5featureReportAddress;
//        weekPaperVc.isHiddenLeft = YES;
//        weekPaperVc.isHiddenBottom = YES;
//        [controller.navigationController pushViewController:weekPaperVc animated:YES];
//        return;
//    }
//    //type 推送一些活动的 url到webview容器里去展示
//    if ([[dict objectForKey:@"target"] isEqualToString:@"promotion"]) {
//        SecondaryLevelWebViewController *weekPaperVc= [[SecondaryLevelWebViewController alloc] init];
//        weekPaperVc.urlString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url"]];
//        weekPaperVc.isHiddenLeft = YES;
//        weekPaperVc.isHiddenBottom = YES;
//        [controller.navigationController pushViewController:weekPaperVc animated:YES];
//        return;
//    }
//
//
////    if ([[dict objectForKey:@"type"] isEqualToString:@"sendKlinePush"]) {
////        SecondaryLevelWebViewController *homePageVc= [[SecondaryLevelWebViewController alloc] init];
////        homePageVc.urlString = [NSString stringWithFormat:@"%@%@",kAppDetailDealAddress,[dict objectForKey:@"id"]];
////        homePageVc.isHiddenLeft = YES;
////        homePageVc.isHiddenBottom = YES;
////        [controller.navigationController pushViewController:homePageVc animated:YES];
////    }
//
//    //type k线短评
////    if ([[dict objectForKey:@"type"] isEqualToString:@"kLineShortComment"]) {
////        BTEKlineViewController *homePageVc= [[BTEKlineViewController alloc] init];
////        NSString * quote = [dict objectForKey:@"pair"];
////        if ([dict objectForKey:@"quote"]) {
////            quote = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quote"]];
////        }
////        NSDictionary *data = @{
////                                @"quote": quote,
////                                @"exchange":  [dict objectForKey:@"exchange"],
////                                @"base":  [dict objectForKey:@"symbol"],
////                                };
////        NSLog(@"data===push===>%@",data);
////        NSLog(@"data===push====dict------>%@",dict);
////        HomeDesListModel * delistModel = [[HomeDesListModel alloc] init];
////        [delistModel initDict:data];
////        homePageVc.desListModel = delistModel;
////        [controller.navigationController pushViewController:homePageVc animated:YES];
////    }
//
//    if ([dict objectForKey:@"title"] && [[dict objectForKey:@"title"] isEqualToString:@"设备登录异常"])//后台
//    {
//        [BTELoginVC OpenLogin:controller callback:^(BOOL isComplete) {
//            if (isComplete) {
//                //登录成功刷新我的账户页面
//                //获取账户基本信息
//                //                    _islogin = YES;
//                [controller.tabBarController setSelectedIndex:0];
//            } else
//            {
//                [controller.tabBarController setSelectedIndex:0];
//            }
//        }];
//        return;
//    }
//
//    if ([[dict objectForKey:@"target"] isEqualToString:@"staredog"]) {
//        BTEKlineViewController *homePageVc= [[BTEKlineViewController alloc] init];
//        NSString * quote;
//        if ([dict objectForKey:@"quoteAsset"]) {
//            quote = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quoteAsset"]];
//        }
//        NSDictionary *data = @{
//                               @"quote": quote,
//                               @"exchange": [dict objectForKey:@"exchange"],
//                               @"base":  [dict objectForKey:@"baseAsset"],
//                               };
//        HomeDesListModel * delistModel = [[HomeDesListModel alloc] init];
//        [delistModel initDict:data];
//        homePageVc.desListModel = delistModel;
//        [controller.navigationController pushViewController:homePageVc animated:YES];
//        return;
//    }
//
//    [controller.navigationController popToRootViewControllerAnimated:NO];
//    [controller.tabBarController setSelectedIndex:0];
    
//    [controller.tabBarController setSelectedIndex:0];
//    return;
}

@end
