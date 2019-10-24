//
//  BHCheckVersionTool.m
//  BitcoinHeadlines
//
//  Created by 张竟巍 on 2017/12/27.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHVersionTool.h"
#import "BTEUpgradeViewController.h"
#import "PhoneInfo.h"
@implementation BHVersionTool
+ (void)requestAppVersion:(UIViewController *)viewController {
//      NSLog(@"---版本更新------returnm-----%@",kCurrentVersion);
    PhoneInfo * phone = [[PhoneInfo alloc] init];
    
    [YQNetworking getWithUrl:kAppVersion refreshRequest:NO cache:NO params:@{@"type":@"1",@"version":kCurrentVersion,@"channel":@"ios",@"sdkVersionName":phone.phoneVersion,@"Model":phone.platform,@"Brand":@"iphone"} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
    } successBlock:^(id response) {
//        NSLog(@"---MobileTradeNum-----%@",response);
        BHVersionItem * appItem = [BHVersionItem yy_modelWithDictionary:response[@"data"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:appItem.trade forKey:MobileTradeNum];
        [defaults synchronize];
        
        if (appItem && !STRISEMPTY(appItem.update) && [appItem.update integerValue] == 1) {
            BTEUpgradeViewController *alterViewVC = [[BTEUpgradeViewController alloc] init];
            alterViewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            //把当前控制器作为背景
            alterViewVC.definesPresentationContext = YES;
            //设置模态视图弹出样式
            alterViewVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            alterViewVC.url = appItem.url;
            alterViewVC.force = appItem.force;
            alterViewVC.name = appItem.name;
            alterViewVC.desc = appItem.desc;
            [viewController presentViewController:alterViewVC animated:YES completion:nil];
        }
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
//    NSLog(@"size is %lu",[YQNetworking totalCacheSize]);
    
//    [BTERequestTools requestWithURLString:kAppVersion parameters:@{@"type":@"1",@"version":kCurrentVersion} type:1 success:^(id responseObject) {
//        NSLog(@"--------%@",responseObject);
//        BHVersionItem * appItem = [BHVersionItem yy_modelWithDictionary:responseObject[@"data"]];
//        if (appItem && !STRISEMPTY(appItem.update) && [appItem.update integerValue] == 1) {
//            BTEUpgradeViewController *alterViewVC = [[BTEUpgradeViewController alloc] init];
//            alterViewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            //把当前控制器作为背景
//            alterViewVC.definesPresentationContext = YES;
//            //设置模态视图弹出样式
//            alterViewVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//            alterViewVC.url = appItem.url;
//            alterViewVC.force = appItem.force;
//            alterViewVC.name = appItem.name;
//            alterViewVC.desc = appItem.desc;
//            [viewController presentViewController:alterViewVC animated:YES completion:nil];
//        }
//    } failure:^(NSError *error) {
//
//    }];
    
}

@end

@implementation BHVersionItem




@end
