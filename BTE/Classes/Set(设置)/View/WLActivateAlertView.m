//
//  WLActivateAlertView.m
//  WangLiBorrow
//
//  Created by wangli on 2018/2/7.
//  Copyright © 2018年 Wangli Technology Co. Ltd. All rights reserved.
//

#import "WLActivateAlertView.h"
@interface WLActivateAlertView ()

@property (nonatomic, copy) ActivateNowCallBack activateNowCallBack;
@property (nonatomic, copy) CalcelCallBack cancelCallBack;

@end
@implementation WLActivateAlertView

/**
 激活弹窗
 */
+ (void)popActivateNowCallBack:(ActivateNowCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack
{
    WLActivateAlertView *actView = [[WLActivateAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    actView.activateNowCallBack = activateNowCallBack;
    actView.cancelCallBack = cancelCallBack;
    actView.backgroundColor = kColorRgba(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:actView];
    
    UIView *bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 270) / 2, 245, 270, 178)];
    bgWhiteView.backgroundColor = BHHexColor(@"ffffff");
    bgWhiteView.layer.masksToBounds = YES;
    bgWhiteView.layer.cornerRadius = 12;
    [actView addSubview:bgWhiteView];
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 132, bgWhiteView.width, 2)];
    line1.backgroundColor = BHHexColor(@"E6EBF0");
    [bgWhiteView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((bgWhiteView.width - 2) / 2, 133, 2, 45)];
    line2.backgroundColor = BHHexColor(@"E6EBF0");
    [bgWhiteView addSubview:line2];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake((bgWhiteView.width - 168) / 2, 40, 168, 55)];
    lable1.text = @"公众号复制成功，快去微信搜索关注吧！";
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.numberOfLines = 0;
    lable1.textColor = BHHexColor(@"626A75");
    lable1.font = UIFontRegularOfSize(16);
    [lable1 sizeToFit];
    [bgWhiteView addSubview:lable1];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(0, 133, (bgWhiteView.width - 2) / 2, 44);
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:BHHexColor(@"626A75") forState:UIControlStateHighlighted];
    [cancelbutton setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
    [cancelbutton addTarget:actView action:@selector(cancelbuttondismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelbutton.titleLabel.font = UIFontRegularOfSize(16);
    [bgWhiteView addSubview:cancelbutton];
    
    UIButton *confirmbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton.frame = CGRectMake((bgWhiteView.width - 2) / 2 + 2, cancelbutton.top, cancelbutton.width, cancelbutton.height);
    [confirmbutton setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateHighlighted];
    [confirmbutton setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
    [confirmbutton setTitle:@"去关注" forState:UIControlStateNormal];
    [confirmbutton addTarget:actView action:@selector(confirmbuttondismiss) forControlEvents:UIControlEventTouchUpInside];
    confirmbutton.titleLabel.font = UIFontRegularOfSize(16);
    [bgWhiteView addSubview:confirmbutton];
    
}

// 取消
- (void)cancelbuttondismiss {
    if (self.cancelCallBack) {
        self.cancelCallBack();
    }
    [self removeFromSuperview];
}
// 去关注
- (void)confirmbuttondismiss {
    if (self.activateNowCallBack) {
        self.activateNowCallBack();
    }
    [self removeFromSuperview];
}

- (void)dealloc
{
    
}

@end
