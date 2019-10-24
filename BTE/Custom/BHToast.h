//
//  WLToast.h
//  WangliBank
//
//  Created by xuehan on 16/6/17.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHToast : NSObject

/**
 *  显示黑条提示,默认展示1.2s
 *
 *  Note: 如果顶层window是键盘，会放在键盘之上
 *
 *  @param message 要提示的消息
 */
+ (void)showMessage:(NSString *)message;
/**
 *  显示黑条提示
 *
 *  @param message  要提示的消息
 *  @param duration 消息展示时间
 */
+ (void)showMessage:(NSString *)message showTime:(NSTimeInterval)duration;

+ (void)showMessage:(NSString *)message
           showTime:(NSTimeInterval)duration
           finished:(void(^)())finished;
+ (void)showMessage:(NSString *)message
           showTime:(NSTimeInterval)duration
           finished:(void(^)())finished withDirection:(BOOL)isLeftRight;
@end
