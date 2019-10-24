//
//  MCTabBarController.m
//  MCTabBarDemo
//
//  Created by chh on 2017/12/4.
//  Copyright © 2017年 Mr.C. All rights reserved.
//

#import "MCTabBarController.h"
#import "ViewController.h"
#import "BHNavigationController.h"
#import "MCTabBar.h"
#import "ViewController.h"
#import "MyAccountViewController.h"
#import "BTEHomePageViewController.h"
#import "BTEStrategyFollowViewController.h"
#import "BTEKlineContractViewController.h"
#import "LBTabBar.h"
#import "ToolView.h"
#import "SecondaryLevelWebViewController.h"
#import "BHVersionTool.h"
#import "BTEHomeWebViewController.h"
@interface MCTabBarController ()<UITabBarControllerDelegate>{
    BHNavigationController *dogVcNavVC;
    BHNavigationController *boDogNavVc;
    SecondaryLevelWebViewController *dogVc;
    SecondaryLevelWebViewController *boDogVc;
    BHNavigationController * contractDogNaVC;
    BTEKlineContractViewController * contractDogVC;
    BHNavigationController *researchNavVc;
    SecondaryLevelWebViewController *researchDogVc;
    BTEHomePageViewController *findePageVc;
    SecondaryLevelWebViewController *tradeVc;
    SecondaryLevelWebViewController *centerPersonVc;
}
@property (nonatomic, strong) MCTabBar *mcTabbar;
@property (nonatomic, assign) NSUInteger selectItem;//选中的item
@end

@implementation MCTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10],NSForegroundColorAttributeName:BHHexColor(@"ABB5BE")} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10],NSForegroundColorAttributeName:BHHexColor(@"308CDD")} forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    findePageVc= [[BTEHomePageViewController alloc] init];
    tradeVc= [[SecondaryLevelWebViewController alloc] init];
    centerPersonVc= [[SecondaryLevelWebViewController alloc] init];
    
    tradeVc.urlString = kAppBTEH5TradDataAddress;
    tradeVc.isHiddenLeft = YES;
    tradeVc.isHiddenBottom = NO;
    
    centerPersonVc.urlString = kAppBTEH5MyAccountAddress;
    centerPersonVc.isHiddenLeft = YES;
    centerPersonVc.isHiddenBottom = NO;

    _mcTabbar = [[MCTabBar alloc] init];
     [_mcTabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //选中时的颜色
    _mcTabbar.tintColor = [UIColor colorWithRed:27.0/255.0 green:118.0/255.0 blue:208/255.0 alpha:1];
   //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    _mcTabbar.translucent = NO;
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_mcTabbar forKeyPath:@"tabBar"];
    self.selectItem = 0; //默认选中第一个
    self.delegate = self;
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:MobileTradeNum] integerValue] == 1) {
        [self initChildVC];
    }else{
        [self initForReviewChildVC];
    }
    self.view.backgroundColor = [UIColor whiteColor];

    dogVc = [[SecondaryLevelWebViewController alloc] init];
    dogVc.urlString = kAppBTEH5DogAddress;
    dogVc.isHiddenLeft = NO;
    dogVc.isHiddenBottom = YES;
    dogVc.isPresentVCFlag = YES;
    dogVcNavVC = [[BHNavigationController alloc] initWithRootViewController:dogVc];
    dogVcNavVC.view.backgroundColor=[UIColor whiteColor];
    dogVcNavVC.tabBarItem.title=@"撸庄狗";
    
    boDogVc = [[SecondaryLevelWebViewController alloc] init];
    boDogVc.urlString = kAppBrandDogAddress;
    boDogVc.isHiddenLeft = NO;
    boDogVc.isHiddenBottom = YES;
    boDogVc.isPresentVCFlag = YES;
    boDogVc.tabBarItem.title=@"波段狗";
    boDogNavVc = [[BHNavigationController alloc] initWithRootViewController:boDogVc];
    
    researchDogVc = [[SecondaryLevelWebViewController alloc] init];
    researchDogVc.urlString = [NSString stringWithFormat:@"%@",kResearchDogAddress];
    researchDogVc.isHiddenLeft = NO;
    researchDogVc.isHiddenBottom = YES;
    researchDogVc.isPresentVCFlag = YES;
    researchDogVc.tabBarItem.title=@"研究狗";
    researchNavVc = [[BHNavigationController alloc] initWithRootViewController:researchDogVc];
    
    contractDogVC = [[BTEKlineContractViewController alloc] init];
    contractDogNaVC = [[BHNavigationController alloc] initWithRootViewController:contractDogVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)buttonAction:(UIButton *)button{
    self.selectedIndex = 2;//关联中间按钮
    if (self.selectItem != 2){
        [self rotationAnimation];
    }
//    self.selectItem = 2;
}

//tabbar选择时的代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 2){//选中中间的按钮
        if (self.selectItem != 2){
             [self rotationAnimation];
        }
    }else {
        [_mcTabbar.centerBtn.layer removeAllAnimations];
    }
    self.selectItem = tabBarController.selectedIndex;
}
//旋转动画
- (void)rotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 3.0;
    rotationAnimation.repeatCount = HUGE;
    [_mcTabbar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮
- (void)initChildVC{
    BTEStrategyFollowViewController *strategyFollowPageVc= [[BTEStrategyFollowViewController alloc] init];
    BHNavigationController *nav1 = [self setUpOneChildVcWithVc:findePageVc Image:@"home_normal" selectedImage:@"home_selected" title:@"首页"];
    BHNavigationController *nav2 = [self setUpOneChildVcWithVc:tradeVc Image:@"trade_normal" selectedImage:@"trade_selected" title:@"行情"];
    BHNavigationController *navcenter = [self setUpOneChildVcWithVc:[[UIViewController alloc] init] Image:@"" selectedImage:@"" title:@"工具"];
    BHNavigationController *nav3 = [self setUpOneChildVcWithVc:strategyFollowPageVc Image:@"strategy_normal" selectedImage:@"strategy_selected" title:@"策略"];
    BHNavigationController *nav4 = [self setUpOneChildVcWithVc:centerPersonVc Image:@"personal_normal" selectedImage:@"personal_selected" title:@"个人中心"];
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:navcenter];
    [self addChildViewController:nav3];
    [self addChildViewController:nav4];
}

- (void)initForReviewChildVC{
    SecondaryLevelWebViewController *luzhuangVc = [[SecondaryLevelWebViewController alloc] init];
    luzhuangVc.urlString =
    kAppBTEH5DogAddress;
    //    @"http://www.luckincoffee.com";
    luzhuangVc.isHiddenLeft = YES;
    luzhuangVc.isHiddenBottom = NO;
    luzhuangVc.isFromReviewLuZDog = YES;
    
    BHNavigationController *nav1 = [self setUpOneChildVcWithVc:findePageVc Image:@"home_normal" selectedImage:@"home_selected" title:@"首页"];
    BHNavigationController *nav2 = [self setUpOneChildVcWithVc:tradeVc Image:@"trade_normal" selectedImage:@"trade_selected" title:@"行情"];
     BHNavigationController *navcenter = [self setUpOneChildVcWithVc:[[UIViewController alloc] init] Image:@"" selectedImage:@"" title:@"工具"];
    BHNavigationController *nav3 = [self setUpOneChildVcWithVc:luzhuangVc Image:@"strategy_normal" selectedImage:@"strategy_selected" title:@"撸庄狗"];
    BHNavigationController *nav4 = [self setUpOneChildVcWithVc:centerPersonVc Image:@"personal_normal" selectedImage:@"personal_selected" title:@"个人中心"];
    
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:navcenter];
    [self addChildViewController:nav3];
    [self addChildViewController:nav4];
}

#pragma xxxxxxmark - 初始化设置tabBar上面单个按钮的方法
/**
 *  设置单个tabBarButton
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (BHNavigationController *)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    BHNavigationController *nav = [[BHNavigationController alloc] initWithRootViewController:Vc];
    Vc.view.backgroundColor = [UIColor whiteColor];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    
    return nav;
}
@end
