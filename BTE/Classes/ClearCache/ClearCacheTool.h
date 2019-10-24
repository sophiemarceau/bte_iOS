//
//  ClearCacheTool.h
//  BTE
//
//  Created by wangli on 2018/5/9.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClearCacheTool : NSObject
/**
 *  获取缓存大小
 */
+ (NSString *)getCacheSize;


/**
 *  清理缓存
 */
+ (BOOL)clearCaches;
@end
