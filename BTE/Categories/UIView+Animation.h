//
//  UIView+Animation.h
//  WYTestDemo
//
//  Created by 王启镰 on 17/3/2.
//  Copyright © 2017年 王启镰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WYViewTransitionType) {
    WYViewTransitionTypeFade         = 0, // 交叉淡化过渡
    WYViewTransitionTypeMoveIn       = 1, // 把新视图移到旧视图上
    WYViewTransitionTypePush         = 2, // 新视图把旧视图推出去
    WYViewTransitionTypeReveal       = 3, // 将旧视图移开，显示新视图
    WYViewTransitionTypePageCurl     = 4, // 向上翻一页
    WYViewTransitionTypePageUnCurl   = 5, // 向下翻一页
    WYViewTransitionTypeRippleEffect = 6, // 滴水效果
    WYViewTransitionTypeSuckEffect   = 7, // 收缩效果，如一块布被抽走
    WYViewTransitionTypeCube         = 8, // 立方体效果
    WYViewTransitionTypeoglFlip      = 9, // 上下翻转效果
};

typedef NS_ENUM(NSUInteger, WYViewTransitionSubtype) {
    WYViewTransitionSubtypeFromLeft   = 0,
    WYViewTransitionSubtypeFromRight  = 1,
    WYViewTransitionSubtypeFromTop    = 2,
    WYViewTransitionSubtypeFromBottom = 3,
};

@interface UIView (Animation)

- (void)wy_animate;
- (void)wy_animateDuration:(CFTimeInterval)duration;
- (void)wy_animateDuration:(CFTimeInterval)duration
                      type:(WYViewTransitionType)type
                   subtype:(WYViewTransitionSubtype)subtype;

- (void)wy_animateScaleWithView:(UIView *)subView;

@end
