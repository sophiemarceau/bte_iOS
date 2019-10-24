//
//  BTEAccountDetailsModel.h
//  BTE
//
//  Created by wangli on 2018/3/9.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Details.h"
@interface BTEAccountDetailsModel : NSObject
@property(nonatomic,copy)NSString * productId;//
@property(nonatomic,copy)NSString * productBatchId;//
@property(nonatomic,copy)NSString * productBatchName;
@property(nonatomic,copy)NSString * assetType;//
@property(nonatomic,copy)NSString * productNetValue;
@property(nonatomic,strong)   NSMutableArray<Details *> *details;
+ (NSDictionary *)modelContainerPropertyGenericClass;
@end
