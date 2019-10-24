//
//  HomeProductInfoModel.h
//  BTE
//
//  Created by wangli on 2018/3/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeProductInfoModel : NSObject
@property(nonatomic,copy)NSString * id;//
@property(nonatomic,copy)NSString * name;//
@property(nonatomic,copy)NSString * type;//
@property(nonatomic,copy)NSString * desc;//
@property(nonatomic,copy)NSString * period;//
@property(nonatomic,copy)NSString * status;//
@property(nonatomic,copy)NSString * riskValue;//
@property(nonatomic,copy)NSString * riskLevel;//
@property(nonatomic,copy)NSString * ror;//
@property(nonatomic,copy)NSString * userCount;//
@property(nonatomic,copy)NSString * amount;//
@property(nonatomic,copy)NSString * dayMaxIncrease;//
@property(nonatomic,copy)NSString * weekMaxIncrease;//
@property(nonatomic,copy)NSString * monthMaxIncrease;//
@property(nonatomic,copy)NSString * requestTimes;//
@end
