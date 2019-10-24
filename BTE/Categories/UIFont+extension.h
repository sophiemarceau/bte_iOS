//
//  UIFont+extension.h
//  WangliBank
//
//  Created by 王俨 on 16/8/10.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (extension)

/// 如果是iOS8 以上则会是`UIFontWeightLight` 类型字体
+ (instancetype)wy_fontOfSize:(CGFloat)size;

@end
