//
//  IDFVTools.h
//  BTE
//
//  Created by wangli on 2018/5/14.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IDFVTools : NSObject
+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

+ (NSString *)getIDFV;
@end
