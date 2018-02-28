//
//  WLTextField.h
//  文本框输入长度限制
//
//  Created by 王俨 on 16/11/23.
//  Copyright © 2016年 wangyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHTextField : UITextField

@property (nonatomic, assign) IBInspectable NSInteger lengthLimit;
@property (nonatomic, assign, getter=isSafety)   IBInspectable BOOL safety;
@property (nonatomic, assign, getter=isPhoneField) IBInspectable BOOL phoneField;
@property (nonatomic, assign, getter=isBankCardField) IBInspectable BOOL bankCardField;
@property (nonatomic, assign, getter=isIdCardField) IBInspectable BOOL idCardField;



@property (nonatomic, assign) IBInspectable NSInteger placeholderFontSize;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@end
