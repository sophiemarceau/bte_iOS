//
//  DugRuleActivityView.m
//  BTE
//
//  Created by sophie on 2018/10/25.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "DugRuleActivityView.h"

@interface DugRuleActivityView ()

@property (nonatomic, copy) ActivateCallBack activateNowCallBack;
@property (nonatomic, copy) CalcelCallBack cancelCallBack;

@end
@implementation DugRuleActivityView

/**
 弹窗 活动视图
 */
+ (void)popActivateNowCallBack:(ActivateCallBack)activateNowCallBack
                cancelCallBack:(CalcelCallBack)cancelCallBack withUrl:(NSString *)urlString
{
    DugRuleActivityView *actView = [[DugRuleActivityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    actView.activateNowCallBack = activateNowCallBack;
    actView.cancelCallBack = cancelCallBack;
    actView.backgroundColor = kColorRgba(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:actView];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCALE_W(342)) / 2, (SCREEN_HEIGHT - SCALE_W(465)) / 2 - 20, SCALE_W(342) , SCALE_W(465))];
    image1.image = [UIImage imageNamed:@"ruleBGView"];
    image1.userInteractionEnabled = YES;
    [actView addSubview:image1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, image1.width, 35)];
    titleLabel.textColor =  BHHexColor(@"FFFFFF");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =UIFontMediumOfSize(SCALE_W(14));
    titleLabel.text = @"挖矿规则";
    [image1 addSubview:titleLabel];
    
    UITextView * contentTextView = [[UITextView alloc] initWithFrame:CGRectMake((image1.width -SCALE_W(283))/2, 78, SCALE_W(283), SCALE_W(340))];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: UIFontRegularOfSize(SCALE_W(14)),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
//    NSString *contentstr=@"1.挖矿时间为2018年10月15日至2018年11月15日\n2.比特易将每天放入3.3BTC放入奖励池\n3.每天8点和20:00分别释放一次挖矿奖励，用户可在此时间后手动领取挖矿奖励，领取后进入下一时段挖矿\n4.用户每时段获得的奖励由参与该时段挖矿的时间及算力共同决定\n5.奖励发放形式：挖矿结束后，用户获得的挖矿奖励将放入比特易区块链策略投资基金中，三个月后用户可提现收益部分(往期最高三个月最高收益60%)\n6.比特易拥有对挖矿活动的最终解释权";
    contentTextView.attributedText = [[NSAttributedString alloc] initWithString:urlString attributes:attributes];
 
    
    
    contentTextView.editable = NO;
    contentTextView.textColor = BHHexColor(@"626A75");
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.textAlignment = NSTextAlignmentLeft;
    [image1 addSubview:contentTextView];
    
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
