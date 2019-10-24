//
//  SignActivity.m
//  BTE
//
//  Created by sophie on 2018/10/29.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "SignActivity.h"

@interface SignActivity ()

@property (nonatomic, copy) ActivateCallBack activateNowCallBack;
@property (nonatomic, copy) CalcelCallBack cancelCallBack;

@end
@implementation SignActivity


/**
 弹窗 活动视图
 */
+ (void)popActivateNowCallBack:(ActivateCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack withContinuityDayNum:(NSString *)dayNumStr
{
    SignActivity *actView = [[SignActivity alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    actView.activateNowCallBack = activateNowCallBack;
    actView.cancelCallBack = cancelCallBack;
    actView.backgroundColor = kColorRgba(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:actView];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300) / 2, (SCREEN_HEIGHT - 372) / 2 - 20, 300, 372)];
    image1.image = [UIImage imageNamed:@"signBgView"];
    image1.userInteractionEnabled = YES;
    [actView addSubview:image1];
   
    UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:actView action:@selector(doTapImage)];
    [image1 addGestureRecognizer:r5];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(image1.width - 15 - 11, 10, 15, 14);
    [okButton setImage:[UIImage imageNamed:@"cancelImage"] forState:UIControlStateNormal];
    [okButton addTarget:actView action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    [image1 addSubview:okButton];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, 168, image1.width, 18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text= @"签到成功";
    titleLabel.font = UIFontMediumOfSize(18);
    titleLabel.textColor = BHHexColor(@"FF432D");
    [image1 addSubview:titleLabel];
    
    
    UILabel *desLabel = [UILabel new];
    desLabel.frame = CGRectMake(0, titleLabel.bottom + 76, image1.width, 16);
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.text= @"连续签满7天送28算力";
    desLabel.font = UIFontRegularOfSize(16);
    desLabel.textColor = BHHexColor(@"626A75");
    [image1 addSubview:desLabel];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"conBtnBGView"] forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(20, titleLabel.bottom +122, image1.width -40, 40);
    confirmBtn.titleLabel.font = UIFontRegularOfSize(16);
    confirmBtn.titleLabel.textColor = BHHexColor(@"FFFFFF");
    [confirmBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [image1 addSubview:confirmBtn];
    [confirmBtn addTarget:actView action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * timeBgView = [UIView new];
    timeBgView.frame = CGRectMake(27, titleLabel.bottom +26, image1.width - 55, 28);
    
    [image1 addSubview:timeBgView];
    UILabel *ballLabel;
    UIView *lineView;
    for (int i = 0; i < 7; i++) {
        ballLabel = [[UILabel alloc] init];
        lineView = [[UIView alloc] init];
        ballLabel.frame = CGRectMake(9.3*i+26*i, 0, 28, 28);
        ballLabel.layer.masksToBounds = YES;
        ballLabel.layer.cornerRadius = 14;
        ballLabel.layer.borderWidth = 2;
        ballLabel.text = [NSString stringWithFormat:@"+%d",i+1];
        ballLabel.textAlignment = NSTextAlignmentCenter;
        ballLabel.font = UIFontRegularOfSize(10);
        ballLabel.textColor = BHHexColorAlpha(@"626A75",0.5);
        ballLabel.backgroundColor = BHHexColor(@"F4F6F9");
        ballLabel.layer.borderColor = BHHexColor(@"E1E1E1").CGColor;
        [timeBgView addSubview:ballLabel];
        
        if ( (i + 1) <= [dayNumStr intValue]) {
            ballLabel.textColor = BHHexColorAlpha(@"FFB346",1);
            ballLabel.backgroundColor = BHHexColor(@"FFFFFF");
            ballLabel.layer.borderColor = BHHexColorAlpha(@"FFB346",1).CGColor;
        }
        
        if (i < 6) {
            lineView.frame = CGRectMake(ballLabel.right, 12, 9.3, 2);
            lineView.backgroundColor = BHHexColor(@"EEEEEE");
            [timeBgView addSubview:lineView];
        }
        
    }
    UIImageView *kingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kingIconImage"]];
    kingImageView.frame = CGRectMake(image1.width - 14 -28.3, titleLabel.bottom +24.2, 14, 13);
    [image1 addSubview:kingImageView];
}

- (void)doTapImage{
    if (self.activateNowCallBack) {
        self.activateNowCallBack();
        [self removeFromSuperview];
    }
}

- (void)okButton{
    [self removeFromSuperview];
}

@end
