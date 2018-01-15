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

@property (nonatomic, copy) NSString * desc; //升级描述信息
@property (nonatomic, copy) NSString * url; //下载地址
@property (nonatomic, copy) NSString * force; //是否强制升级 0否 1是
@property (nonatomic, copy) NSString * currentVersion; //版本
@property (nonatomic, copy) NSString * update; //服务器版本 0 相同 1不同需升级
@property (nonatomic, copy) NSString * name; //应用名

@end

