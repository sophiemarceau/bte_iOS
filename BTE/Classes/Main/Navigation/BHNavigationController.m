//
//  BHNavigationController.m
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHNavigationController.h"

@interface BHNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BHNavigationController

+ (void)load {
//    NSArray *colorArray = @[BHHexColor(@"#BF956B"),BHHexColor(@"#BF956B")];
//    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_HEIGHT);
//    UIImage *barImg = [UIImage BgImageFromColors: colorArray withFrame: frame];
    UIImage *barImg = [UIImage imageWithColor:COLOR_RGBA(250, 250, 250, 1)];
    [[UINavigationBar appearance] setBackgroundImage:barImg forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage imageWithColor:BHHexColor(@"E6EBF0")];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:BHHexColor(@"#525866"), NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [viewController.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
    [viewController.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    viewController.navigationItem.backBarButtonItem = backItem;
}

@end
