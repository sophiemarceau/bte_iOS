//
//  ZYWMacdModel.h
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWMacdModel : NSObject

@property(assign, nonatomic) double dea;
@property(assign, nonatomic) double diff;
@property(assign, nonatomic) double macd;
@property(copy,   nonatomic) NSString *date;
@property (assign, nonatomic) BOOL isDrawDate;
@property (nonatomic,assign) CGFloat left;

- (id)initWithDea:(double)dea diff:(double)diff macd:(double)macd date:(NSString *)date;

@end
