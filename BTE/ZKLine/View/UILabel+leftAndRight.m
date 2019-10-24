//
//  UILabel+leftAndRight.m
//  BTE
//
//  Created by wanmeizty on 2018/6/14.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "UILabel+leftAndRight.h"

@implementation UILabel (leftAndRight)

- (void)setTitle:(NSString *)title value:(NSString *)value{
//    NSString * left = [NSString stringWithFormat:@"%@",title];
    NSString * text =[NSString stringWithFormat:@"%@%@",title,value];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:text];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:1/1.0] range:[text rangeOfString:value]];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0] range:[text rangeOfString:title]];
    self.attributedText = att;
}

- (void)setTitles:(NSArray *)titles value:(NSString *)string{
   
    self.textColor = [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:1/1.0];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:string];
    for (NSString *title in titles) {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0] range:[string rangeOfString:title]];
    }
    
    
    self.attributedText = att;
}

- (void)setText:(NSString *)text titles:(NSArray *)titles{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *title in titles) {
//        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:[text rangeOfString:title]];
        
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:10] range:[text rangeOfString:title]];
    }
    self.attributedText = att;
}

- (void)setText:(NSString *)text titles:(NSArray *)titles date:(NSString *)dateStr{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *title in titles) {
        //        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:[text rangeOfString:title]];
        
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:10] range:[text rangeOfString:title]];
    }
    
    if (dateStr.length > 0) {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0] range:[text rangeOfString:dateStr]];
    }
    self.attributedText = att;
}

- (void)setText:(NSString *)text titles:(NSArray *)titles date:(NSString *)dateStr dr:(double)dr dx:(double)dx{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *title in titles) {
        //        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:[text rangeOfString:title]];
        
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:10] range:[text rangeOfString:title]];
    }
    
    if (dateStr.length > 0) {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:0.6/1.0] range:[text rangeOfString:dateStr]];
    }
    
//    if (dx < 0) {
//        
//        [att addAttribute:NSForegroundColorAttributeName value:DropColor range:[text rangeOfString:[NSString stringWithFormat:@"%.2f%%",dx]]];
//    }{
//        [att addAttribute:NSForegroundColorAttributeName value:RoseColor range:[text rangeOfString:[NSString stringWithFormat:@"%.2f%%",dx]]];
//    }
    
    if (dr < 0) {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF4040"] range:[text rangeOfString:[NSString stringWithFormat:@"%.2f%%",dr]]];
    }else{
        [att addAttribute:NSForegroundColorAttributeName value:RoseColor range:[text rangeOfString:[NSString stringWithFormat:@"+%.2f%%",dr]]];

    }
    self.attributedText = att;
}

@end
