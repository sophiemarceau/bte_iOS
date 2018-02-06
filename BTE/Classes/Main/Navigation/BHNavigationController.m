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
    NSArray *colorArray = @[BHHexColor(@"#FAFAFA"),BHHexColor(@"#FAFAFA")];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_HEIGHT);
    UIImage *barImg = [UIImage BgImageFromColors: colorArray withFrame: frame];
    [[UINavigationBar appearance] setBackgroundImage:barImg forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage new];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:BHHexColor(@"#454F6B"), NSFontAttributeName:[UIFont systemFontOfSize:18]}];
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
    
    UIImage *buttonNormal = [[UIImage imageNamed:@"ic_global_return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [viewController.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
    [viewController.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    viewController.navigationItem.backBarButtonItem = backItem;
}

@end
