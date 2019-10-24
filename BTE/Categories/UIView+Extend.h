//
//  UIView+Extend.h
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Extend)

- (UIViewController *)viewController;

+ (UIView *)viewWithName:(NSString *)name;
- (void)clearBorderStyle;
- (void)searchContainerStyle;
- (void)heavyborderStyle;
- (void)lightBorderStyle;
- (void)borderStyle;
- (void)borderStyleWithColor:(UIColor *)color;
// 设置圆角和边框
- (void)borderStyleWithColor:(UIColor*)color borderWidth:(CGFloat)borderWidth cornerRadiusStyleWithValue:(CGFloat)value;

/**设置阴影*/
- (void)setShadowWith:(UIColor*)color andOpacity:(float)opacity;
- (void)cornerRadiusStyle;
- (void)cornerRadiusStyleWithValue:(CGFloat)value;
- (void)roundStyle;
- (void)roundHeightStyle;
- (UIColor *)colorAtPosition:(UIImage *)image position:(CGPoint)position;
- (UIColor *)colorAtPosition:(CGPoint)position;
- (UIColor *)getRGBPixelColorAtPoint:(CGPoint)point image:(UIImage *)image;
- (UIColor *)getRGBPixelColorAtPoint:(CGPoint)point;
- (CGSize)fitSize;
//- (void)setFrameWithType:(FrameType)type value:(CGFloat)value;
//- (void)setFrameWithType:(FrameType)type value:(CGFloat)value maxValue:(CGFloat)maxValue;
- (UIImage *)screenshot;
// 设置圆角
- (void)setViewRounded:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;


/**
 设置指定 VIew 圆角

 @param rect  VIew's Bounds
 @param corners 圆角的方向
 @param size 圆角的 size
 */
- (void)setViewWithRoundedRect:(CGRect)rect byBoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)size;



@end
