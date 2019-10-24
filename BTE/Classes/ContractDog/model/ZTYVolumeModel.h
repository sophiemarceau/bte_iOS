//
//  ZTYVolumeModel.h
//  BTE
//
//  Created by wanmeizty on 2018/7/26.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTYVolumeModel : NSObject

@property (nonatomic,copy) NSString * datetime;
@property (nonatomic,copy) NSString * count;
@property (nonatomic,copy) NSString * buyCount;
@property (nonatomic,copy) NSString * sellCount;
@property (nonatomic,copy) NSString * netCount;
@property (nonatomic,copy) NSString * amount;
@property (nonatomic,copy) NSString * buyAmount;
@property (nonatomic,copy) NSString * sellAmount;
@property (nonatomic,copy) NSString * netAmount;
@end
