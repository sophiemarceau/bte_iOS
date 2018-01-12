//
//  UIView+UIStatusBar.m
//  WangliBank
//
//  Created by 王俨 on 2017/7/27.
//  Copyright © 2017年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIView+UIStatusBar.h"
#import <objc/message.h>

static UIView *statusBar = nil;

@implementation UIView (UIStatusBar)

+ (void)load {
    SEL sysSel = @selector(setFrame:);
    SEL wlSel  = @selector(wl_setFrame:);
    
    Class cls = objc_getClass("UIStatusBar");
    Method sysMethod = class_getInstanceMethod(cls, sysSel);
    Method wlMethod  = class_getInstanceMethod(cls, wlSel);
    
    if (class_addMethod(cls, sysSel, method_getImplementation(wlMethod), method_getTypeEncoding(wlMethod))) {
        class_replaceMethod(cls, wlSel, method_getImplementation(sysMethod), method_getTypeEncoding(sysMethod));
    } else {
        method_exchangeImplementations(sysMethod, wlMethod);
    }
}

+ (UIView *)statusBar {
    return statusBar;
}

- (void)wl_setFrame:(CGRect)frame {
    [self wl_setFrame:frame];
    
    statusBar = self;
}

@end
