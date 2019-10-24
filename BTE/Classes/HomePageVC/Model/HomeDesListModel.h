//
//  HomeDesListModel.h
//  BTE
//
//  Created by wangli on 2018/3/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDesListModel : NSObject
@property(nonatomic,copy)NSString * date;//
@property(nonatomic,copy)NSString * price;//
@property(nonatomic,copy)NSString * change;//
@property(nonatomic,copy)NSString * trend;//
@property(nonatomic,copy)NSString * operation;//
@property(nonatomic,copy)NSString * exchange;//
@property(nonatomic,copy)NSString * queto;//
@property(nonatomic,copy)NSString * symbol;//
@property(nonatomic,copy)NSString * icon;//
@property(nonatomic,copy)NSString * quote;///quote
@property(nonatomic,copy)NSString * cnyPrice;

@property(nonatomic,copy)NSString * notice;

@property (assign,nonatomic) BOOL isRead; // 判断点评是否阅读
@property(nonatomic,assign)NSString *highequallowFlag;
/*
change = 2.78,
trend = 强势上涨,
operation = 及时买入,
symbol = LTC,
exchange = okex,
price = 97.72,
date = 2018-06-19,
queto = USDT,
icon = http://47.94.217.12:18081/app/images/icon/ltc.png,
 */
- (void)initDict:(NSDictionary *)dict;
@end
