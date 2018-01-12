//
//  UILabel+category.m
//  NovartisPPH
//
//  Created by liuchang on 13-10-11.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UILabel+category.h"
#import <objc/runtime.h>
#import "UIFont+extension.h"


@implementation UILabel (category)

+(UILabel *)valueLabelFrame:(CGRect)aFrame textColor:(UIColor *)aColor textFont:(UIFont *)aFont textAlignment:(NSTextAlignment)alignment text:(NSString*)text
{
    UILabel* actnameSLabel = [[UILabel alloc] initWithFrame:aFrame];
    actnameSLabel.backgroundColor = [UIColor clearColor];
    actnameSLabel.textColor = aColor;
    actnameSLabel.textAlignment = alignment;
    actnameSLabel.font = aFont;
    actnameSLabel.text = text;
    return actnameSLabel;
}

- (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range string:(NSString *)str{
    if (str) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
        [attString addAttributes:attrs range:range];
        self.attributedText = [attString copy];
    }
    
}

+ (instancetype)labelWithText:(NSString *)text
                         font:(CGFloat)fontSize
                        color:(UIColor *)color {
   
    return [self labelWithText:text font:fontSize isLightFont:NO color:color];
}

/// 创建light的字体
+ (instancetype)labelWithText:(NSString *)text
                         font:(CGFloat)fontSize
                  isLightFont:(BOOL)isLightFont
                        color:(UIColor *)color {
    
    UILabel *label = [self new];
    label.text = text;
    label.textColor = color;
    if (isLightFont) {
        label.font = [UIFont wy_fontOfSize:fontSize];
    } else {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    [label sizeToFit];
    
    return label;
}


#pragma mark - 首页外接字体前后不一致处理方法（ eg: 处理百分号大小）
- (void)handlePercentWith:(NSString*)fontName string:(NSString*)string pattern:(NSString*)pattern fontSize:(CGFloat)fontSize percentSize:(CGFloat)percentSize{
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:string];
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:NULL];
    NSArray *results = [regularExpression matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    [attrStrM addAttribute:NSFontAttributeName value:[UIFont fontWithName:fontName size:fontSize] range:NSMakeRange(0, string.length)];
    
    for (NSTextCheckingResult *checkingResult in results) {
        NSRange range = [checkingResult rangeAtIndex:0];
        [attrStrM addAttribute:NSFontAttributeName value:[UIFont fontWithName:fontName size:percentSize] range:range];

    }
    self.attributedText = attrStrM.copy;
}



@end
