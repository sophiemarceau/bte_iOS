//
//  NSDate+Categoey.h
//  BitcoinHeadlines
//
//  Created by 奥卡姆 on 2017/12/28.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Categoey)

/**
 字符串转换成 Date

 @param dateString 时间字符串
 @return  date
 */
+ (NSDate *)stringTransToDate:(NSString *)dateString;

/**
 比较两个 年月日 时间前后

 @param oneDay  oneday
 @param anotherDay anotherDay
 @return 1 前者大于后者 0 相等 -1 前者小于后者
 */
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

+ (NSString*)getWeekDay:(NSString*)currentStr;

@end
