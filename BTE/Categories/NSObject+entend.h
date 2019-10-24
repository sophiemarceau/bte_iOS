//
//  NSObject+entend.h
//  WangliBank
//
//  Created by xuehan on 16/1/8.
//  Copyright (c) 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (entend)
/**
 *  返回格式化后的数字,目的是返回末尾没有0的小数值,最多保留两位小数
 *
 *  @param value 要格式化的float值
 *
 *  @return 返回格式化后的 数字 字符串
 */
- (NSString *)formatWithValue:(double)value;
/**
 *  返回格式化后的数字,目的是返回末尾没有0的小数值,最多保留三位小数
 *
 *  @param value 要格式化的float值
 *
 *  @return 返回格式化后的 数字 字符串
 */
- (NSString *)formatWithValuetThree:(double)value;

/// 如果是0 最后样式为0.00
- (NSString *)formatWithValueZero:(double)value;



/**
 返回格式化后的100或者1000的倍数
 @param value 输入数值
 @param hundredOrThousand 100或者1000
 @param remain_amount 可投金额
 @param limit_per_user 有无限额
 @param limit_amount  限额
 @return 100的倍数
 */
- (double)formatWithValueMultiple:(double)value forHundredOrThousand:(int)hundredOrThousand remainAmount:(double)remain_amount limitPerUser:(int)limit_per_user limitAmount:(double)limit_amount;

/**
 传入总金额返回一个数组 用于购买界面的滑动刻度尺(固定数组长度)

 @param total_amount 总金额
 @param minValue 数组最小值

 @return
 */
- (NSArray*)formatWithValuetotalAmount:(double)total_amount minValue:(NSString*)minValue;
/**
 传入总金额返回一个数组 用于购买界面的滑动刻度尺(固定数组长度)
 
 @param total_amount 总金额
 @param minValue 数组最小值
 
 @return
 */

- (NSUInteger)sizeAtPath:(NSString*)folderPath;

@end
