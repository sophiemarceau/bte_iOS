//
//  ZTYKlineComment.h
//  BTE
//
//  Created by wanmeizty on 2018/6/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTYKlineComment : NSObject
@property (nonatomic,copy) NSString * symbol;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * exchange;
@property (nonatomic,copy) NSString * klineDateTime;
@property (nonatomic,copy) NSString * klineDate;
@property (nonatomic,copy) NSString * createTime;
@property (nonatomic,copy) NSString * pair;
@property (nonatomic,copy) NSString * createrId;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,assign) BOOL markerPlace;
@property (nonatomic,assign) BOOL isShow;
- (instancetype)initWidthDict:(NSDictionary *)dict;
- (NSComparisonResult)compare:(ZTYKlineComment *)other;
@end
