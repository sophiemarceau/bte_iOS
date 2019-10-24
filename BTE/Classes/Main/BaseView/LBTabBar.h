//
//  LBTabBar.h
//  BTE
//
//  Created by sophie on 2018/7/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBTabBar;
@protocol LBTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar;
@end

@interface LBTabBar : UITabBar
/** tabbar的代理 */
@property (nonatomic, weak) id<LBTabBarDelegate> myDelegate ;
@end
