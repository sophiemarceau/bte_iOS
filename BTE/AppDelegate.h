//
//  AppDelegate.h
//  BTE
//
//  Created by wangli on 2018/1/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSDictionary * _jPushDic;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isEable;
- (void)setHuaXinLogin;
- (void)loginHuaXinServer;
- (void)logoutHuaXinServer;
@end

