//
//  UIViewController+extend.m
//  WangliBank
//
//  Created by xuehan on 16/8/28.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIViewController+extend.h"

@implementation UIViewController (extend)
- (BOOL)isDisplaying{
    return (self.isViewLoaded && self.view.window);
}
@end
