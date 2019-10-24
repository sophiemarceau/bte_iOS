//
//  SignActivity.h
//  BTE
//
//  Created by sophie on 2018/10/29.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ActivateCallBack)(void);//回调跳转
typedef void(^CalcelCallBack)(void);//备用
@interface SignActivity : UIView
/**
 活动弹窗
 */
+ (void)popActivateNowCallBack:(ActivateCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack withContinuityDayNum:(NSString *)dayNumStr;
@end

NS_ASSUME_NONNULL_END
