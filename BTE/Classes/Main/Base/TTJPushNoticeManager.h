//
//  TTJPushNoticeManager.h
//  noMiss
//
//  Created by wy on 15/10/24.
//  Copyright (c) 2015年 北京币易有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
/**
 *  极光推送调整管理内
 */
@interface TTJPushNoticeManager : NSObject

//控制器
//@property (nonatomic,strong) UIViewController *controller;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) UIViewController *jumpVc;
/**
 *  单例，管理推送，实现各种跳转
 *
 *  @return <#return value description#>
 */
+(instancetype)shareManger;

-(void)jpushwithParam:(NSDictionary *)dict WithVC:(UIViewController *)controller;


@end
