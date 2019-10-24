//
//  HomeDesListModel.m
//  BTE
//
//  Created by wangli on 2018/3/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "HomeDesListModel.h"

@implementation HomeDesListModel

- (void)initDict:(NSDictionary *)dict{
    
    self.quote = [dict objectForKey:@"quote"];
    self.cnyPrice = [dict objectForKey:@"cnyPrice"];
    self.exchange = [dict objectForKey:@"exchange"];
    self.change = [dict objectForKey:@"change"];
    self.symbol = [dict objectForKey:@"base"];
    self.price = [dict objectForKey:@"price"];
    self.quote = [dict objectForKey:@"quote"];
    
}

@end
