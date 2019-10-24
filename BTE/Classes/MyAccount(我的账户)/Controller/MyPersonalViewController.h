//
//  MyPersonalViewController.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/4.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHBaseWebVC.h"

@interface MyPersonalViewController : BHBaseWebVC{
    //设置状态栏颜色
    UIView *_statusBarView;
}
@property (nonatomic,strong) NSString *isloginAndGetMyAccountInfo;//1 登录并且已获取到了用户信息


@end
