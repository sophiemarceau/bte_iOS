//
//  UIImage+category.h
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (category)

//转灰度图片
- (UIImage *)imageWithGrayScaleImage:(UIImage *)inputImg;
+ (UIImage *)createImageWithBgColor:(UIColor *)color size:(CGSize)size cornerRadius:(float)corner;

/**
 *  根据颜色生成纯色图片
 *
 *  @param color
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
