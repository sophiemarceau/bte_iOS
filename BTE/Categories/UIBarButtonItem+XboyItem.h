//
//  UIBarButtonItem+XboyItem.h
//  WangliBank
//
//  Created by Shawn on 12/11/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XboyItem)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;
@end
