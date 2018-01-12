//
//  UIImage+Scale.h
//  Auto
//
//  Created by song on 13-2-19.
//  Copyright (c) 2013年 song.xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
-(UIImage*)scaleToSize:(CGSize)size;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
@end
