//
//  BTEBaseModel.m
//  BTE
//
//  Created by wanmeizty on 1/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEBaseModel.h"

@implementation BTEBaseModel
- (NSString *)getdict:(NSDictionary *)dict key:(NSString *)key{
    if ([[dict objectForKey:key] isEqual:[NSNull null]] || [dict objectForKey:key] == nil || dict == nil) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
    }
}
@end
