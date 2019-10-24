//
//  Details.h
//  BTE
//
//  Created by sophie on 2018/10/11.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Details : NSObject
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString * ror;//
@property (nonatomic, copy) NSString *principal;


@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *assetType;
@end

NS_ASSUME_NONNULL_END
