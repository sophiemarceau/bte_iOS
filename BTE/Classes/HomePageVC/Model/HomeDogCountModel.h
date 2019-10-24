//
//  HomeDogCountModel.h
//  BTE
//
//  Created by sophie on 2018/6/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDogCountModel : NSObject
@property(nonatomic,copy)NSString *dogName;
@property(nonatomic,copy)NSString * income;//收益
@property(nonatomic,copy)NSString * userCount;//已有人数
@property(nonatomic,copy)NSString * recentCount;//近期可撸币种
@property(nonatomic,copy)NSString * notice;//是否显示内个更新的红点
@property(nonatomic,copy)NSString *agencyCount;
@end
