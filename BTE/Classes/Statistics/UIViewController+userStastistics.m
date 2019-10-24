//
//  UIViewController+userStastistics.m
//  BTE
//
//  Created by sophie on 2018/7/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "UIViewController+userStastistics.h"
#import "HookUtility.h"
#import "UserStatistics.h"
#import "BTEHomeWebViewController.h"
#import "SecondaryLevelWebViewController.h"
@implementation UIViewController (userStastistics)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swiz_viewWillAppear:);
        [HookUtility swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
        
        SEL originalSelector2 = @selector(viewWillDisappear:);
        SEL swizzledSelector2 = @selector(swiz_viewWillDisappear:);
        [HookUtility swizzlingInClass:[self class] originalSelector:originalSelector2 swizzledSelector:swizzledSelector2];
    });
}

#pragma mark - Method Swizzling

- (void)swiz_viewWillAppear:(BOOL)animated
{
    //插入需要执行的代码
    [self inject_viewWillAppear];
    [self swiz_viewWillAppear:animated];
}

- (void)swiz_viewWillDisappear:(BOOL)animated
{
    [self inject_viewWillDisappear];
    [self swiz_viewWillDisappear:animated];
}

//利用hook 统计所有页面的停留时长
- (void)inject_viewWillAppear
{
    NSString *pageID = [self pageEventID:YES];
    if (pageID) {
//        [UserStatistics sendEventToServer:pageID];
        [UserStatistics enterPageViewWithPageID:pageID];
    }
}

- (void)inject_viewWillDisappear
{
    NSString *pageID = [self pageEventID:NO];
    if (pageID) {
//        [UserStatistics sendEventToServer:pageID];
         [UserStatistics leavePageViewWithPageID:pageID];
    }
}


- (NSString *)pageEventID:(BOOL)bEnterPage
{
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
//     NSLog(@"selfClassName------->%@",selfClassName);
    if([selfClassName isEqualToString:@"SecondaryLevelWebViewController"]){
        SecondaryLevelWebViewController *tempVc = (SecondaryLevelWebViewController *)self;
//        NSLog(@"urlString------->%@",tempVc.urlString);
        if([tempVc.urlString isEqualToString:kAppBTEH5MyAccountAddress]){
            selfClassName =  @"MyAccountViewController";
        }
        if([tempVc.urlString isEqualToString:kAppBTEH5TradDataAddress]){
            selfClassName =  @"TradeViewController";
        }
        if([tempVc.urlString isEqualToString:kAppBTEH5DogAddress]){
            selfClassName =  @"LuDogViewController";
        }
    }
//    NSLog(@"classname---selfClassName---->%@",selfClassName);
    return configDict[selfClassName][@"PageEventIDs"][bEnterPage ? @"Enter" : @"Leave"];
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GlobalUserConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}
@end
