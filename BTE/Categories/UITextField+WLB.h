//
//  UITextField+WLB.h
//  WangliBank
//
//  Created by xiafan on 11/5/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (WLB)

/**
 * secure input
 * e.g. 密码: *******
 */
+ (UITextField *)secureTextFieldWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder delegate:(id)delegate;
@end
