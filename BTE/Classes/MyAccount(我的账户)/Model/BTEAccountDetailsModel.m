//
//  BTEAccountDetailsModel.m
//  BTE
//
//  Created by wangli on 2018/3/9.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEAccountDetailsModel.h"

@implementation BTEAccountDetailsModel

//相当于泛型说明
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"details" : [Details class]};
}
@end
