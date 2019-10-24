//
//  ZTYDistrabuteView.h
//  BTE
//
//  Created by wanmeizty on 17/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTYDistrabuteView : UIView
@property (assign,nonatomic) CGFloat lowValue;
@property (assign,nonatomic) CGFloat highValue;
@property (assign,nonatomic) CGFloat currentWidth;

- (void)setRedLineWidth:(CGFloat)width;
- (void)hideLine:(BOOL)isHidden;

@end
