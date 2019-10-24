//
//  CurrencyModel.m
//  BTE
//
//  Created by wanmeizty on 25/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "CurrencyModel.h"

@implementation CurrencyModel

- (void)initWithDict:(NSDictionary *)dict{
    self.base = [NSString stringWithFormat:@"%@",[dict objectForKey:@"base"]];
    self.exchange = [NSString stringWithFormat:@"%@",[dict objectForKey:@"exchange"]];
    self.quote = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quote"]];
    self.quoteCn = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quoteCn"]];
    self.status = NO;//[[dict objectForKey:@"status"] boolValue];
}

- (NSDictionary *)modelIntoDict{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:self.base forKey:@"base"];
    [dict setObject:self.exchange forKey:@"exchange"];
    [dict setObject:self.quote forKey:@"quote"];
    [dict setObject:[NSNumber numberWithBool:self.status] forKey:@"status"];
    return dict;
}

@end
