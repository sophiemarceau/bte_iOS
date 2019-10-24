//
//  ExchangeModel.h
//  BTE
//
//  Created by wanmeizty on 2018/6/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeModel : NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * exchange;
@property (nonatomic,copy) NSString * symbol;
@property (nonatomic,copy) NSString * baseAsset;
@property (nonatomic,copy) NSString * quoteAsset;
-(void)initwidthDict:(NSDictionary *)dict;
@end
