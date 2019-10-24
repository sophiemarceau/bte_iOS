//
//  BTELeftView.h
//  BTE
//
//  Created by wangli on 2018/4/2.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActivateNowCallBack)(NSInteger index);//回调跳转
typedef void(^CalcelCallBack)(void);//备用
@interface BTELeftView : UIView
/**
 激活弹窗
 */
+ (void)popActivateNowCallBack:(ActivateNowCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack;
@end
