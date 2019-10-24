//
//  BTECalculateDistrabutionValue.h
//  BTE
//
//  Created by wanmeizty on 18/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTEDistributionModel.h"

@interface BTECalculateDistrabutionValue : NSObject
+ (NSDictionary *)getDictwithKlineArray:(NSArray *)array max:(CGFloat)max min:(CGFloat)min count:(int)count;
@end
