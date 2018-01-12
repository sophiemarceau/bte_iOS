//
//  UIBarButtonItem+XboyItem.m
//  WangliBank
//
//  Created by Shawn on 12/11/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIBarButtonItem+XboyItem.h"

@implementation UIBarButtonItem (XboyItem)
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImage = [UIImage imageNamed:image];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    
    button.bounds = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
//    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
//    customView.backgroundColor = [UIColor redColor];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}
@end
