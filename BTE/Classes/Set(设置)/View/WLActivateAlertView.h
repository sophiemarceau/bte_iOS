//
//  WLActivateAlertView.h
//  WangLiBorrow
//
//  Created by wangli on 2018/2/7.
//  Copyright © 2018年 Wangli Technology Co. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void(^ActivateNowCallBack)(void);//立即激活
typedef void(^CalcelCallBack)(void);//取消
@interface WLActivateAlertView : UIView
/**
 激活弹窗
 */
+ (void)popActivateNowCallBack:(ActivateNowCallBack)activateNowCallBack
                            cancelCallBack:(CalcelCallBack)cancelCallBack;
@end
