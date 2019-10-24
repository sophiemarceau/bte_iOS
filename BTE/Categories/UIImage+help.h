//
//  UIImage+help.h
//  IHaoMu
//
//  Created by  wuhiwi on 16/11/2.
//  Copyright © 2016年 ihaomu.com. All rights reserved.
//


@interface UIImage (help)

+ (UIImage*)scaleImage:(UIImage*)img toSize:(CGSize)size;
//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
////截取部分图像
- (UIImage*)getSubImage:(CGRect)rect;

+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image;

//处理图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//缩放图片
+ (UIImage *)scaleImage:(UIImage *)oriImage size:(CGSize)newsize;
//压缩图片 quality 0.5-0.6
+ (NSData*)compressImage:(UIImage *)oriImage quality:(float)quality;
//图片渐变
+ (UIImage*) BgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame;

@end
