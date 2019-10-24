//
//  UIColor+Externsion.h
//  WangliBank
//
//  Created by 王俨 on 2017/6/20.
//  Copyright © 2017年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Externsion)

+ (instancetype)colorWithTopColor:(UIColor *)topColor
                      bottomColor:(UIColor *)bottomColor
                           height:(CGFloat)height;

@end
