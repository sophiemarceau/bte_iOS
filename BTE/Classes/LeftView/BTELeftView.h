//
//  BTELeftView.h
//  BTE
//
//  Created by wangli on 2018/4/2.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActivateNowCallBack)(void);//立即激活
typedef void(^CalcelCallBack)(void);//取消
@interface BTELeftView : UIView
/**
 激活弹窗
 */
+ (void)popActivateNowCallBack:(ActivateNowCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack;
@end
