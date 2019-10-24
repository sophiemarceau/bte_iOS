//
//  UITextField+WLB.m
//  WangliBank
//
//  Created by xiafan on 11/5/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UITextField+WLB.h"

@implementation UITextField (WLB)

+ (UITextField *)secureTextFieldWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder delegate:(id)delegate
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    
    {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75.f, frame.size.height)];
        titleLab.text = title;
        titleLab.textColor = [UIColor darkGrayColor];
        titleLab.font = [UIFont systemFontOfSize:16.f];
        textField.leftView = titleLab;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    textField.font = [UIFont systemFontOfSize:16.f];
    textField.secureTextEntry = YES;
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = delegate;
    
    return textField;
}

@end
