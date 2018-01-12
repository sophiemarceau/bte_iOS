//
//  UIButton+avoidMultiTouch.m
//  WangliBank
//
//  Created by xuehan on 16/7/22.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIButton+avoidMultiTouch.h"
#import "NSObject+swizzling.h"
#import <objc/runtime.h>

@implementation UIButton (avoidMultiTouch)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self swizzleSelector:@selector(sendAction:to:forEvent:) withSwizzledSelector:@selector(mySendAction:to:forEvent:)];
    });
}
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        if (self.isIgnoreEvent){
            return;
        }else {
            [self performSelector:@selector(resetState) withObject:nil afterDelay:0.5];
        }
    }
    self.isIgnoreEvent = YES;
    [self mySendAction:action to:target forEvent:event];
}
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent{
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isIgnoreEvent{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)resetState{
    [self setIsIgnoreEvent:NO];
}

@end
