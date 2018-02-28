//
//  WLTextField.m
//  文本框输入长度限制
//
//  Created by 王俨 on 16/11/23.
//  Copyright © 2016年 wangyan. All rights reserved.
//

#import "BHTextField.h"
#import "NSString+category.h"

@interface BHTextField ()

@property (nonatomic, copy) NSMutableString *originText;  ///< 原本的文字内容 [暂未用到]

@end

@implementation BHTextField


- (void)awakeFromNib {
    [super awakeFromNib];
    // xib中设置会导致输入汉字偏移
    self.borderStyle = UITextBorderStyleNone;
    [self addNotification];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addNotification];
        
    }
    return self;
}


- (NSMutableString *)originText {
    if (!_originText) {
        _originText = [NSMutableString string];
    }
    return _originText;
}



- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wy_textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)wy_textFieldChanged:(NSNotification *)n {
    if (!self.isFirstResponder) return;
    
    [self wy_lengthLimt];
    [self wy_phoneSpace];
    [self wy_bankCardSpace];
}

- (void)wy_bankCardSpace {
    if (!self.isBankCardField) return;
    
    self.text = [self.text addTrimString];
}

- (void)wy_phoneSpace {
    if (!self.isPhoneField) return;
    
    self.text = [self.text addPhoneSpace];
}

- (void)wy_lengthLimt {
    if (self.lengthLimit == 0) return;
    
    NSString *inputMode = [self.textInputMode primaryLanguage];
    if ([inputMode isEqualToString:@"zh-Hans"]) { // 当前中文输入
        UITextRange *selectedRange = [self markedTextRange];
        // 获取当前输入高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (!position) { // 没有高亮选择的文字，则进行文本校验
            if ([self.text trimString].length > self.lengthLimit) {
                if (self.isPhoneField || self.isBankCardField || self.isIdCardField) {
                    self.text = [self.text substringToIndex:self.text.length - 1];
                } else {
                    self.text = [self.text substringToIndex:self.lengthLimit];
                }
            }
        }
        return;
    }
    
    if ([self.text trimString].length > self.lengthLimit) {
        self.text = [self.text substringToIndex:self.text.length - 1];
    }
}

#pragma mark - setter
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderFontSize:(NSInteger)placeholderFontSize {
    _placeholderFontSize = placeholderFontSize;
    
    [self setValue:[UIFont systemFontOfSize:placeholderFontSize] forKeyPath:@"_placeholderLabel.font"];
}


#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
