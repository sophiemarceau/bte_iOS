//
//  BTECalculateDistrabutionValue.m
//  BTE
//
//  Created by wanmeizty on 18/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTECalculateDistrabutionValue.h"
#import "ZTYChartModel.h"
@implementation BTECalculateDistrabutionValue
+ (NSDictionary *)getDictwithKlineArray:(NSArray *)array max:(CGFloat)max min:(CGFloat)min count:(int)count{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
    CGFloat highest = max;
    CGFloat lowest = min;
    CGFloat step = (highest - lowest)/ (count * 1.0);
    for (int i = 0; i < count; i ++) {
        
        BTEDistributionModel * distribution = [[BTEDistributionModel alloc] init];
        distribution.high = max - step * i;
        distribution.low = max - step * (i + 1);
        distribution.step = step;
        distribution.distribution = 0;
        [dict setObject:distribution forKey:[NSString stringWithFormat:@"distribution%d",i]];
    }
    
    for (ZTYChartModel * model in array) {
        for (int i = 0; i < count; i ++) {
            
            BTEDistributionModel * distribution = [dict objectForKey:[NSString stringWithFormat:@"distribution%d",i]];
            [self updateDistrabute:distribution Low:model.low high:model.high volume:model.volumn.doubleValue];

        }
    }
    double value = 0;
    int index = 0;
    for (int i = 0; i < count; i ++ ) {
        BTEDistributionModel * model = [dict objectForKey:[NSString stringWithFormat:@"distribution%d",i]];
        if (model.distribution > value) {
            value = model.distribution;
            index = i;
        }
    }
    [dict setObject:@(value) forKey:@"max"];
    [dict setObject:@(index) forKey:@"maxindex"];
    return dict;
}

+ (void)updateDistrabute:(BTEDistributionModel *)distribution Low:(double)low high:(double)high volume:(double)volume{
    double diviser = 0;

    if (distribution.low > low) {
        
        if (distribution.low < high) {
            if (distribution.high > high) {
                // 上少
                diviser = volume / (high - low)*(high - distribution.low);
            }else{
                diviser = volume / (high - low)*distribution.step;
            }
        }else{
            diviser = 0;
        }
        
    }else{
        
        if (distribution.high > low) {
            if (distribution.high > high) {
                diviser = volume / (high - low)*(high - low);
            }else{
                diviser = volume / (high - low)*(distribution.high - low);
            }
            
        }else{
            diviser = 0;
        }
    }
    
    if (!isnan(diviser)) {
        distribution.distribution += diviser;
    }
}

@end
