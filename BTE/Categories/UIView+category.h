//
//  UIView+category.h
//  iLearning
//
//  Created by Sidney on 13-9-4.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (category)

- (BOOL)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
//- (UIImage *)viewToImage:(UIWebView*)webView;
- (UIImage*)imageWithUIView:(UIView*)view;


//－－－－－－－－－－ frame－－－－－－－－－－－－－－－
@property CGPoint origin;//获得视图的起点坐标
@property CGSize size;//获得视图的宽和高

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;//获得视图的高
@property CGFloat width;//获得视图的宽

@property CGFloat top;//获得视图的顶部y
@property CGFloat left;//获得视图的左部x

@property CGFloat bottom;//获得视图的底部y
@property CGFloat right;//获得视图的右部x


- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

-(void)cornerRadius:(float)radius;//view的圆角弧度



-(UIViewController*)viewController;//------------事件效应者-----------
- (void)removeAllSubviews;

@end
