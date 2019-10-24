//
//  UILabel+leftAndRight.h
//  BTE
//
//  Created by wanmeizty on 2018/6/14.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (leftAndRight)

- (void)setTitle:(NSString *)title value:(NSString *)value;
- (void)setTitles:(NSArray *)titles value:(NSString *)string;
- (void)setText:(NSString *)text titles:(NSArray *)titles;
- (void)setText:(NSString *)text titles:(NSArray *)titles date:(NSString *)dateStr;
- (void)setText:(NSString *)text titles:(NSArray *)titles date:(NSString *)dateStr dr:( double)dr dx:(double)dx;
@end
