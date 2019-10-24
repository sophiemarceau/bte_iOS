//
//  BTESaveDataUtil.h
//  BTE
//
//  Created by wanmeizty on 21/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTESaveDataUtil : NSObject

//+ (void)saveKlineData:(NSDictionary *)dataDict key:(NSString *)dataKey;
//+ (NSDictionary *)gotDataDictKey:(NSString *)dataKey;
//
+ (void)save:(NSDictionary *)personInfo key:(NSString *)dataKey;
+ (NSDictionary *)read:(NSString *)dataKey;

+ (void)achiveKlineDataDict:(NSDictionary *)dataDict key:(NSString *)dataKey;
+ (NSDictionary *)unachiverKlineDataKey:(NSString *)dataKey;
@end
