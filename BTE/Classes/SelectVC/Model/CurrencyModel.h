//
//  CurrencyModel.h
//  BTE
//
//  Created by wanmeizty on 25/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyModel : NSObject
@property (copy,nonatomic) NSString * base;
@property (copy,nonatomic) NSString * exchange;
@property (copy,nonatomic) NSString * quote;
@property (copy,nonatomic) NSString * quoteCn;
@property (assign,nonatomic) NSInteger index;
@property (assign,nonatomic) BOOL status;
- (void)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)modelIntoDict;
@end

NS_ASSUME_NONNULL_END
