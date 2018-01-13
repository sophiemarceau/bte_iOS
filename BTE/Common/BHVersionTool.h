//
//  BHCheckVersionTool.h
//  BitcoinHeadlines
//
//  Created by 张竟巍 on 2017/12/27.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BHVersionItem;
@interface BHVersionTool : NSObject

/**
 判断版本升级

 @param viewController 当前控制器
 */
+ (void)requestAppVersion:(UIViewController *)viewController;

@end

@interface BHVersionItem : NSObject

@property (nonatomic, copy) NSString * message; //升级提示信息
@property (nonatomic, copy) NSString * url; //下载地址
@property (nonatomic, copy) NSString * is_update; //是否强制升级
@property (nonatomic, copy) NSString * version; //版本
@property (nonatomic, copy) NSString * is_open; //备用 隐藏开关，0关闭app其它功能打开工具功能，1开启app功能关闭工具功能

@end

