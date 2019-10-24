//
//  UILabel+category.h
//  NovartisPPH
//
//  Created by liuchang on 13-10-11.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (category)


+(UILabel *)valueLabelFrame:(CGRect)aFrame textColor:(UIColor *)aColor textFont:(UIFont *)aFont textAlignment:(NSTextAlignment)alignment text:(NSString*)text;
// quick method for add attribute at some range in label
- (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range string:(NSString *)str;

+ (instancetype)labelWithText:(NSString *)text
                         font:(CGFloat)fontSize
                        color:(UIColor *)color;

/// 创建light的字体
+ (instancetype)labelWithText:(NSString *)text
                         font:(CGFloat)fontSize
                  isLightFont:(BOOL)isLightFont
                        color:(UIColor *)color;

/**
 首页外接字体前后不一致处理方法（ eg: 处理百分号大小）

 @param fontName 外接字体
 @param pattern The regular expression pattern to compile.
 @param fontSize
 @param percentSize
 */
- (void)handlePercentWith:(NSString*)fontName string:(NSString*)string pattern:(NSString*)pattern fontSize:(CGFloat)fontSize percentSize:(CGFloat)percentSize;


@end
