//
//  DugRuleActivityView.h
//  BTE
//
//  Created by sophie on 2018/10/25.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActivateCallBack)(void);//回调跳转
typedef void(^CalcelCallBack)(void);//备用
NS_ASSUME_NONNULL_BEGIN

@interface DugRuleActivityView : UIView
/**
 活动弹窗
 */
+ (void)popActivateNowCallBack:(ActivateCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack withUrl:(NSString *)urlString;
@end

NS_ASSUME_NONNULL_END
