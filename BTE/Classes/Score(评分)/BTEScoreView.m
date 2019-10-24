//
//  BTEScoreView.m
//  BTE
//
//  Created by wangli on 2018/5/7.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEScoreView.h"
@interface BTEScoreView ()

@property (nonatomic, copy) ActivateNowCallBack activateNowCallBack;
@property (nonatomic, copy) CalcelCallBack cancelCallBack;

@end
@implementation BTEScoreView
/**
 弹窗 评价视图
 */
+ (void)popActivateNowCallBack:(ActivateNowCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack
{
    BTEScoreView *actView = [[BTEScoreView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    actView.activateNowCallBack = activateNowCallBack;
    actView.cancelCallBack = cancelCallBack;
    actView.backgroundColor = kColorRgba(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:actView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 280) / 2, 194, 280, 258)];
    whiteView.backgroundColor = BHHexColorAlpha(@"ECECEC", 0.94);
    whiteView.layer.cornerRadius = 12;
    whiteView.layer.masksToBounds = YES;
    [actView addSubview:whiteView];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(110, 20, 59, 59)];
    image1.image = [UIImage imageNamed:@"icon_star_score"];
    [whiteView addSubview:image1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 280, 17)];
    titleLabel.text = @"喜欢“比特易”吗？";
    titleLabel.font = UIFontMediumOfSize(17);
    titleLabel.textColor = BHHexColor(@"626A75");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:titleLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 240, 18)];
    titleLabel1.text = @"轻点星形以在App Store 中评分。";
//    titleLabel1.numberOfLines = 0;
    titleLabel1.font = UIFontRegularOfSize(16);
    titleLabel1.textColor = BHHexColor(@"626A75");
    [titleLabel1 sizeToFit];
    [whiteView addSubview:titleLabel1];
    
    UIView *whiteViewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 166, 280, 1)];
    whiteViewLine.backgroundColor = BHHexColor(@"9F9FA1");
    [whiteView addSubview:whiteViewLine];
    
    UIView *whiteViewLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 212, 280, 1)];
    whiteViewLine1.backgroundColor = BHHexColor(@"9F9FA1");
    [whiteView addSubview:whiteViewLine1];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(0, 167, 280, 44);
    [okButton setImage:[UIImage imageNamed:@"star_score"] forState:UIControlStateNormal];
    [okButton addTarget:actView action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:okButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 213, 280, 44);
    [cancelButton setTitle:@"以后" forState:UIControlStateNormal];
    [cancelButton setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
    [cancelButton addTarget:actView action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelButton];
}

- (void)okButton
{
    if (self.activateNowCallBack) {
        self.activateNowCallBack();
        [self removeFromSuperview];
    }
}
- (void)cancelButton
{
    if (self.cancelCallBack) {
        self.cancelCallBack();
        [self removeFromSuperview];
    }
}
@end
