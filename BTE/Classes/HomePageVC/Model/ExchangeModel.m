//
//  ExchangeModel.m
//  BTE
//
//  Created by wanmeizty on 2018/6/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ExchangeModel.h"

@implementation ExchangeModel

-(void)initwidthDict:(NSDictionary *)dict{
    self.baseAsset = [dict objectForKey:@"baseAsset"];
    self.exchange = [dict objectForKey:@"exchange"];
    self.quoteAsset = [dict objectForKey:@"quoteAsset"];
    self.symbol = [dict objectForKey:@"symbol"];
    self.name = [dict objectForKey:@"name"];
}
@end
