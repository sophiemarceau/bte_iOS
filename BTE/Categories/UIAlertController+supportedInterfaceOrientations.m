//
//  UIAlertController+supportedInterfaceOrientations.m
//  WangliBank
//
//  Created by 王俨 on 17/3/13.
//  Copyright © 2017年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIAlertController+supportedInterfaceOrientations.h"

@implementation UIAlertController (supportedInterfaceOrientations)

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

@end
