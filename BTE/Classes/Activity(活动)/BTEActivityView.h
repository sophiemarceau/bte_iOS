//
//  BTEActivityView.h
//  BTE
//
//  Created by wangli on 2018/5/9.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActivateCallBack)(void);//回调跳转
typedef void(^CalcelCallBack)(void);//备用
@interface BTEActivityView : UIView
/**
 活动弹窗
 */
+ (void)popActivateNowCallBack:(ActivateCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack withUrl:(NSString *)urlString;
@end
