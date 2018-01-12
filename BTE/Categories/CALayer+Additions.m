//
//  CALayer+Additions.m
//  WangliBank
//
//  Created by FangYiXiong on 14-7-14.
//  Copyright (c) 2014年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)
- (void)setBorderColorFromUIColor:(UIColor *)color{
    self.borderColor = color.CGColor;
}
@end
