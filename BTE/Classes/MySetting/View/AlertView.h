//
//  AlertView.h
//  BTE
//
//  Created by sophie on 2018/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ConfirmCallBack)(BOOL isComplete,NSString *returnStr);

@interface AlertView : UIView

- (instancetype)initAlertView;

@property (nonatomic,copy)ConfirmCallBack confirmCallBack;

@end
