//
//  UIView+Animation.m
//  WYTestDemo
//
//  Created by 王启镰 on 17/3/2.
//  Copyright © 2017年 王启镰. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

static NSArray *typesArr;
static NSArray *subtypesArr;

+ (void)initialize {
    typesArr = @[kCATransitionFade, kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, @"pageCurl", @"pageUnCurl", @"rippleEffect", @"suckEffect", @"cube", @"oglFlip"];
    subtypesArr = @[kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom];
}

- (void)wy_animate {
    [self wy_animateDuration:0.5];
}

- (void)wy_animateDuration:(CFTimeInterval)duration {
    [self wy_animateDuration:duration type:WYViewTransitionTypeFade subtype:WYViewTransitionSubtypeFromLeft];
}

- (void)wy_animateDuration:(CFTimeInterval)duration
                      type:(WYViewTransitionType)type
                   subtype:(WYViewTransitionSubtype)subtype {
    
    CATransition *transition = [CATransition animation];
    transition.type = typesArr[type];
    transition.subtype = subtypesArr[subtype];
    transition.duration = duration;
    [self.layer addAnimation:transition forKey:@"transition"];
}

- (void)wy_animateScaleWithView:(UIView *)subView {
    self.alpha = 0;
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
    }];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@0.95,@1.0,@1.05,@1.0];
    animation.duration = 0.25;
    [subView.layer addAnimation:animation forKey:@""];
}


@end
