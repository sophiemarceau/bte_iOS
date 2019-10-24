//
//  LBTabBarController.m
//  BTE
//
//  Created by sophie on 2018/7/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "LBTabBarController.h"
#import "BHNavigationController.h"
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
#import "BTEMarketViewController.h"
#import "PhoneInfo.h"
#import "PersonalCenterViewController.h"
#import "BTESelectViewController.h"
#import "BTECommunityListViewController.h"
#import "DataViewController.h"

@interface LBTabBarController ()<LBTabBarDelegate>{
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
    PersonalCenterViewController *psonCenterVc;
//    SecondaryLevelWebViewController *centerPersonVc;
    SecondaryLevelWebViewController *checkVc;
    BHNavigationController *stareNavVc;
    SecondaryLevelWebViewController *stareDogVc;
    BTEStrategyFollowViewController *strategyFollowPageVc;
//    SecondaryLevelWebViewController *luzhuangVc;
     SecondaryLevelWebViewController *marketAnalysisVc;
    BHNavigationController *nav1,*nav2,*nav3,*nav4;
    LBTabBar *tabbar;
}
//记录上一次点击tabbar，使用时，记得先在init或viewDidLoad里 初始化 = 0
@property(nonatomic,assign)NSInteger indexFlag;
@end

@implementation LBTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
//    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
//    dictNormal[NSForegroundColorAttributeName] =  BHHexColor(@"ABB5BE");
//    dictNormal[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
//
//    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
//    dictSelected[NSForegroundColorAttributeName] = BHHexColor(@"308CDD");;
//    dictSelected[NSFontAttributeName] =[UIFont fontWithName:@"PingFangSC-Regular" size:10];
    
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10],NSForegroundColorAttributeName:BHHexColor(@"ABB5BE")} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10],NSForegroundColorAttributeName:BHHexColor(@"308CDD")} forState:UIControlStateSelected];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setTranslucent:NO];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationUpdateUserLoginStatus object:nil];
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:NotificationReviewUpdateMenu object:nil];
    findePageVc= [[BTEHomePageViewController alloc] init];
    tradeVc = [[SecondaryLevelWebViewController alloc] init];
    checkVc = [[SecondaryLevelWebViewController alloc] init];
//    centerPersonVc= [[SecondaryLevelWebViewController alloc] init];
    psonCenterVc = [[PersonalCenterViewController alloc] init];
    strategyFollowPageVc= [[BTEStrategyFollowViewController alloc] init];
    
    tradeVc.urlString = kAppBTEH5TradDataAddress;
    tradeVc.isHiddenLeft = YES;
    tradeVc.isHiddenBottom = NO;
    
    checkVc.urlString = kAppBTECheckChainAddress;
    checkVc.isHiddenLeft = YES;
    checkVc.isHiddenBottom = NO;
    
//    centerPersonVc.urlString = kAppBTEH5MyAccountAddress;
//    centerPersonVc.isHiddenLeft = YES;
//    centerPersonVc.isHiddenBottom = NO;

//    luzhuangVc = [[SecondaryLevelWebViewController alloc] init];
//    luzhuangVc.urlString =
//    kAppBTEH5DogAddress;
//    //    @"http://www.luckincoffee.com";
//    luzhuangVc.isHiddenLeft = YES;
//    luzhuangVc.isHiddenBottom = NO;
//    luzhuangVc.isFromReviewLuZDog = YES;
    
    marketAnalysisVc = [[SecondaryLevelWebViewController alloc] init];
    marketAnalysisVc.urlString =
    kAppDetailDealAddress;
    //    @"http://www.luckincoffee.com";
    marketAnalysisVc.isHiddenLeft = YES;
    marketAnalysisVc.isHiddenBottom = NO;
    marketAnalysisVc.isFromReviewLuZDog = YES;
    
    
    
    [self initChildVC];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([[defaults objectForKey:MobileTradeNum] integerValue] == 1) {
//        [self initChildVC];
////        [self initForReviewChildVC];
//    }else{
//        [self initForReviewChildVC];
//    }
    self.view.backgroundColor = [UIColor whiteColor];
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
//    tabbar = [[LBTabBar alloc] init];
//    //设置不透明
//    tabbar.translucent = NO;
//    tabbar.myDelegate = self;
//    
//    //kvc实质是修改了系统的_tabBar
//    [self setValue:tabbar forKeyPath:@"tabBar"];
//    
//    dogVc = [[SecondaryLevelWebViewController alloc] init];
//    dogVc.urlString = kAppBTEH5DogAddress;
//    dogVc.isHiddenLeft = NO;
//    dogVc.isHiddenBottom = YES;
//    dogVc.isPresentVCFlag = YES;
//    dogVcNavVC = [[BHNavigationController alloc] initWithRootViewController:dogVc];
//    dogVcNavVC.view.backgroundColor=[UIColor whiteColor];
//    dogVcNavVC.tabBarItem.title=@"撸庄狗";
//    
//    boDogVc = [[SecondaryLevelWebViewController alloc] init];
//    boDogVc.urlString = kAppBrandDogAddress;
//    boDogVc.isHiddenLeft = NO;
//    boDogVc.isHiddenBottom = YES;
//    boDogVc.isPresentVCFlag = YES;
//    boDogVc.tabBarItem.title=@"波段狗";
//    boDogNavVc = [[BHNavigationController alloc] initWithRootViewController:boDogVc];
//    
//    researchDogVc = [[SecondaryLevelWebViewController alloc] init];
//    researchDogVc.urlString = [NSString stringWithFormat:@"%@",kResearchDogAddress];
//    researchDogVc.isHiddenLeft = NO;
//    researchDogVc.isHiddenBottom = YES;
//    researchDogVc.isPresentVCFlag = YES;
//    researchDogVc.tabBarItem.title=@"研究狗";
//    researchNavVc = [[BHNavigationController alloc] initWithRootViewController:researchDogVc];
//    
//    
//    stareDogVc = [[SecondaryLevelWebViewController alloc] init];
//    stareDogVc.urlString = [NSString stringWithFormat:@"%@",kStareDogAddress];
//    stareDogVc.isHiddenLeft = NO;
//    stareDogVc.isHiddenBottom = YES;
//    stareDogVc.isPresentVCFlag = YES;
//    stareDogVc.tabBarItem.title=@"盯盘狗";
//    stareNavVc = [[BHNavigationController alloc] initWithRootViewController:stareDogVc];
//    
//    contractDogVC = [[BTEKlineContractViewController alloc] init];
//    contractDogNaVC = [[BHNavigationController alloc] initWithRootViewController:contractDogVC];

}

#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮
- (void)initChildVC{
    
    nav1 = [self setUpOneChildVcWithVc:findePageVc Image:@"home_normal" selectedImage:@"home_selected" title:@"首页"];
    
    BTEMarketViewController * marketVc = [[BTEMarketViewController alloc] init];
//    DataViewController *marketVc = [[DataViewController alloc] init];
    
    
    nav2 = [self setUpOneChildVcWithVc:marketVc Image:@"trade_normal" selectedImage:@"trade_selected" title:@"数据"];
    
    BTESelectViewController * selectVc = [[BTESelectViewController alloc] init];
    BHNavigationController* selectNavc = [self setUpOneChildVcWithVc:selectVc Image:@"option_normal" selectedImage:@"option_selected" title:@"自选"];
    
    BTECommunityListViewController * communityVc = [[BTECommunityListViewController alloc] init];
    nav3 = [self setUpOneChildVcWithVc:communityVc Image:@"community_normal" selectedImage:@"community_selected" title:@"社区"];
//    if (User.userToken) {
//        nav3 = [self setUpOneChildVcWithVc:strategyFollowPageVc Image:@"strategy_normal" selectedImage:@"strategy_selected" title:@"策略"];
//    }else{
//        nav3 = [self setUpOneChildVcWithVc:marketAnalysisVc Image:@"strategy_normal" selectedImage:@"strategy_selected" title:@"报告"];
//    }
    nav4 = [self setUpOneChildVcWithVc:psonCenterVc Image:@"personal_normal" selectedImage:@"personal_selected" title:@"个人中心"];
//      self.viewControllers = @[nav1,nav2,nav3,nav4];
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:selectNavc];
    [self addChildViewController:nav3];
    [self addChildViewController:nav4];
   
    
}

- (void)initForReviewChildVC{
    nav1 = [self setUpOneChildVcWithVc:findePageVc Image:@"home_normal" selectedImage:@"home_selected" title:@"首页"];
    nav2 = [self setUpOneChildVcWithVc:tradeVc Image:@"trade_normal" selectedImage:@"trade_selected" title:@"数据"];
    nav3 = [self setUpOneChildVcWithVc:marketAnalysisVc Image:@"strategy_normal" selectedImage:@"strategy_selected" title:@"报告"];
    nav4 = [self setUpOneChildVcWithVc:psonCenterVc Image:@"personal_normal" selectedImage:@"personal_selected" title:@"个人中心"];
//    self.viewControllers = @[nav1,nav2,nav3,nav4];
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:nav3];
    [self addChildViewController:nav4];
}

-(void)update{
    CGRect frame = self.tabBar.frame;
//    NSLog(@"--------%@",NSStringFromCGRect(frame));
//    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height -HOME_INDICATOR_HEIGHT;
//
//    frame.size =CGSizeMake(frame.size.width, frame.size.height+HOME_INDICATOR_HEIGHT);
    
     NSLog(@"--frame------%@",NSStringFromCGRect(frame));
//    BHNavigationController *tempnav = [self.viewControllers objectAtIndex:2];
//    [self addChildVcItem:marketAnalysisVc title:@"市场分析" image:@"strategy_normal" selectedImage:@"strategy_selected"];
//    [tempnav setViewControllers:@[marketAnalysisVc] animated:NO];
    
   
    
    
//    [tabbar removeFromSuperview];
//    tabbar = nil;
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([[defaults objectForKey:MobileTradeNum] integerValue] == 1) {
//        if (User.userToken) {
//            BHNavigationController *tempnav = [self setUpOneChildVcWithVc:strategyFollowPageVc Image:@"strategy_normal" selectedImage:@"strategy_selected" title:@"策略"];
//            self.viewControllers = @[nav1,nav2,tempnav,nav4];
//
//        }else{
//            BHNavigationController *tempnav = [self setUpOneChildVcWithVc:marketAnalysisVc Image:@"strategy_normal" selectedImage:@"strategy_selected" title:@"报告"];
//            self.viewControllers = @[nav1,nav2,tempnav,nav4];
//
//        }
//    }else{//review
//        BHNavigationController *tempnav = [self setUpOneChildVcWithVc:marketAnalysisVc Image:@"strategy_normal" selectedImage:@"strategy_selected" title:@"报告"];
//        self.viewControllers = @[nav1,nav2,tempnav,nav4];
//
//    }
//
//    tabbar = [[LBTabBar alloc] init];
//    //设置不透明
//    tabbar.translucent = NO;
//    tabbar.myDelegate = self;
////    tabbar.frame = frame;
////    //kvc实质是修改了系统的_tabBar
//    [self setValue:tabbar forKeyPath:@"tabBar"];
//    self.tabBar.frame = frame;
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

//重新设置了一下他的标题和TabBar内容
- (void)addChildVcItem:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
   
    // 设置子控制器的图片
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.image = myImage;
    //声明显示图片的原始式样 不要渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    childVc.tabBarItem.title = title;
}




#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar{
    ToolView *v = [[ToolView alloc] initToolView];
    [v setSelectCallBack:^(NSUInteger selectIndex) {
        NSLog(@"tabBarPlusBtnClick----setSelectCallBack---->%ld",selectIndex);
        
        if (selectIndex == 0) {
            return ;
        }
        if (selectIndex == 1) {
            [self presentViewController:dogVcNavVC animated:YES completion:nil];
            [self requeestEvent:@"lz_dog"];
        }else if (selectIndex == 2) {
            [self presentViewController:boDogNavVc animated:YES completion:nil];
            [self requeestEvent:@"band_dog"];
        }else if (selectIndex == 3) {
            [self presentViewController:researchNavVc animated:YES completion:nil];
            [self requeestEvent:@"research_dog"];
        }else if (selectIndex == 4) {
            BTEKlineContractViewController * contravc = [[BTEKlineContractViewController alloc] init];
            BHNavigationController * contranavc = [[BHNavigationController alloc] initWithRootViewController:contravc];
            [self presentViewController:contranavc animated:YES completion:nil];
            [self requeestEvent:@"future_dog"];
        }else if (selectIndex == 5) {
            [self presentViewController:stareNavVc animated:YES completion:nil];
            [self requeestEvent:@"strategy_dog"];
        }else{
            [BHToast showMessage:@"正在开发中 敬请期待"];
        }
    }];
}

-(void)requeestEvent:(NSString *)eventType{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
         [pramaDic setObject:@"ios" forKey:@"channel"];
         [pramaDic setObject:@"menu" forKey:@"module"];
         [pramaDic setObject:@"click" forKey:@"type"];
         [pramaDic setObject:eventType forKey:@"target"];
    }else{
        return;
    }
    methodName = kEventCount;
    NSLog(@"requeestEvent---pramaDic----->%@",pramaDic);
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
         NSLog(@"responseObject-------->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
        }
    } failure:^(NSError *error) {
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//-(void)requestTabbar{
//    NSMutableDictionary * pramaDic = @{}.mutableCopy;
//    [pramaDic setObject:@"1" forKey:@"type"];
//    [pramaDic setObject:kCurrentVersion forKey:@"version"];
//    NSString * methodName = @"";
//    methodName = kAppVersion;
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
//                                                                              @"text/html",
//                                                                              @"text/json",
//                                                                              @"text/plain",
//                                                                              @"text/javascript",
//                                                                              @"text/xml",
//                                                                              @"image/*"]];
//
//    [manager GET:methodName parameters:pramaDic progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (IsSafeDictionary(responseObject)) {
//             NSLog(@"kCurrentVersion---responseObject---------->%@",responseObject);
//            BHVersionItem * appItem = [BHVersionItem yy_modelWithDictionary:responseObject[@"data"]];
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:appItem.trade forKey:MobileTradeNum];
//            [defaults synchronize];
//            if ([[defaults objectForKey:MobileTradeNum] integerValue] == 1) {
////                [self initChildVC];
//                 [self initForReviewChildVC];
//            }
//            else
//            {
//
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//
//
//}



//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//    if (index != self.indexFlag) {
//        //执行动画
//        NSMutableArray *arry = [NSMutableArray array];
//        for (UIView *btn in self.tabBar.subviews) {
//            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//                [arry addObject:btn];
//            }
//        }
//        //添加动画
//        //---将下面的代码块直接拷贝到此即可---
//        //放大效果，并回到原位
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        //速度控制函数，控制动画运行的节奏
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.duration = 0.2;       //执行时间
//        animation.repeatCount = 1;      //执行次数
//        animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
//        animation.fromValue = [NSNumber numberWithFloat:0.7];   //初始伸缩倍数
//        animation.toValue = [NSNumber numberWithFloat:1.3];     //结束伸缩倍数
//        [[arry[index] layer] addAnimation:animation forKey:nil];
//
//        self.indexFlag = index;
//    }
//}



@end
