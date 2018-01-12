//
//  UIView+Extend.m
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView(Extend)

/*- (UIViewController *)viewController {
    
    //for (UIView* next = [self superview]; next; next = next.superview) {
        
        UIResponder* nextResponder = [self nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController*)nextResponder;
        }
    //}
    return nil;
}*/

+ (UIView *)viewWithName:(NSString *)name {
    
    return [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] objectAtIndex:0];
}

- (UIViewController *) viewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}



- (void)clearBorderStyle {
    
    self.layer.borderWidth = 0;
    self.layer.masksToBounds = YES;
}

- (void)searchContainerStyle {
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


- (void)borderStyleWithColor:(UIColor *)color {
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)setViewRounded:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setShadowWith:(UIColor*)color andOpacity:(float)opacity {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = opacity;
}

- (void)cornerRadiusStyle {
    
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
}

- (void)cornerRadiusStyleWithValue:(CGFloat)value {
    
    self.layer.cornerRadius = value;
    self.layer.masksToBounds = YES;
}

- (void)borderStyleWithColor:(UIColor*)color borderWidth:(CGFloat)borderWidth cornerRadiusStyleWithValue:(CGFloat)value {
    self.layer.cornerRadius = value;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}

- (void)roundStyle {
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
}

- (void)roundHeightStyle {
    
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds = YES;
}

- (UIColor *)colorAtPosition:(CGPoint)position {
    
    CGPoint p = CGPointMake(position.x / self.frame.size.width, position.y / self.frame.size.height);
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef cgImage = [image CGImage];
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    CFDataRef bitmapData = CGDataProviderCopyData(provider);
    const UInt8* data = CFDataGetBytePtr(bitmapData);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    int col = p.x*(width-1);
    int row = p.y*(height-1);
    const UInt8* pixel = data + row*bytesPerRow+col*4;
    UIColor* returnColor = [UIColor colorWithRed:pixel[2]/255. green:pixel[1]/255. blue:pixel[0]/255. alpha:1.0];
    CFRelease(bitmapData);
    return returnColor;
}

- (CGSize)fitSize {
    
    CGRect rect = self.frame;
    [self sizeToFit];
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.frame = rect;
    return size;
}

- (UIImage *)screenshot {
    
    CGSize s = self.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setViewWithRoundedRect:(CGRect)rect byBoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


@end
