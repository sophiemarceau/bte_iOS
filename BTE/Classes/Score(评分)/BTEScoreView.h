//
//  BTEScoreView.h
//  BTE
//
//  Created by wangli on 2018/5/7.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActivateNowCallBack)(void);//回调跳转
typedef void(^CalcelCallBack)(void);//备用
@interface BTEScoreView : UIView
/**
 激活弹窗
 */
+ (void)popActivateNowCallBack:(ActivateNowCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack;
@end
