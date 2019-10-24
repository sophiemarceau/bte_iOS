//
//  BTEActivityView.m
//  BTE
//
//  Created by wangli on 2018/5/9.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEActivityView.h"
#import "UserStatistics.h"

@interface BTEActivityView ()

@property (nonatomic, copy) ActivateCallBack activateNowCallBack;
@property (nonatomic, copy) CalcelCallBack cancelCallBack;

@end
@implementation BTEActivityView
/**
 弹窗 活动视图
 */
+ (void)popActivateNowCallBack:(ActivateCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack withUrl:(NSString *)urlString
{
    BTEActivityView *actView = [[BTEActivityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    actView.activateNowCallBack = activateNowCallBack;
    actView.cancelCallBack = cancelCallBack;
    actView.backgroundColor = kColorRgba(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:actView];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 295) / 2, (SCREEN_HEIGHT - 408) / 2 - 20, 295, 408)];
    [image1 sd_setImageWithURL:[NSURL URLWithString:urlString]];
    image1.userInteractionEnabled = YES;
    [actView addSubview:image1];
    
    //点击手势
    UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:actView action:@selector(doTapImage)];
    [image1 addGestureRecognizer:r5];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake((SCREEN_WIDTH - 32) / 2, image1.bottom + 20, 32, 32);
    [okButton setImage:[UIImage imageNamed:@"Image_activity"] forState:UIControlStateNormal];
    [okButton addTarget:actView action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    [actView addSubview:okButton];
    
}

- (void)doTapImage
{
    [UserStatistics sendEventToServer:@"首页点击活动"];
    if (self.activateNowCallBack) {
        self.activateNowCallBack();
        [self removeFromSuperview];
    }
}

- (void)okButton
{
    [self removeFromSuperview];
}

@end
