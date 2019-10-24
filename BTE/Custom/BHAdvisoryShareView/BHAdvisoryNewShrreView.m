//
//  BHAdvisoryNewShrreView.m
//  BitcoinHeadlines
//
//  Created by wangli on 2018/1/9.
//  Copyright © 2018年 zhangyuanzhe. All rights reserved.
//

#import "BHAdvisoryNewShrreView.h"
#import "BHShareTool.h"
BHAdvisoryNewShrreView *sharreV = nil;
UIScrollView *sharScrollView = nil;
@implementation BHAdvisoryNewShrreView

+ (void)showAdvisoryShareViewWithTimes:(NSString *)time content:(NSString *)content codeImage:(UIImage *)image{
    BHAdvisoryNewShrreView *shareV = [[BHAdvisoryNewShrreView alloc] init];
    [shareV showAdvisoryShareViewWithTime:time content:content codeImage:image];
}

- (void)showAdvisoryShareViewWithTime:(NSString *)time content:(NSString *)content codeImage:(UIImage *)image{
    BHAdvisoryNewShrreView *shareView = [[BHAdvisoryNewShrreView alloc] init];
    shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    shareView.backgroundColor = BHHexColor(@"F0F0F0");
    
    _shareBgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH), SCREEN_HEIGHT - 54)];
    _shareBgImageV.image = [UIImage imageNamed:@"pic_bg_sp"];
    [shareView addSubview:_shareBgImageV];
    
    int top;
    if (IS_IPHONEX) {
        top = 44;
    } else
    {
        top = 20;
    }
    _shareMainVIew = [[UIScrollView alloc] initWithFrame:CGRectMake(18, top, (SCREEN_WIDTH - 18 * 2), SCREEN_HEIGHT - 54 - 10 - 83 + 20 + 40)];
    _shareMainVIew.contentSize =  CGSizeMake(SCREEN_WIDTH - 18 * 2, _shareMainVIew.height);
    _shareMainVIew.showsVerticalScrollIndicator = FALSE;
    _shareMainVIew.backgroundColor = BHHexColor(@"F0F0F0");
//    _shareMainVIew.bounces = NO;
    [shareView addSubview:_shareMainVIew];
    
    
    _shareBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 18 * 2), SCREEN_HEIGHT - 54 - 10 - 83 + 20)];
    _shareBgView.backgroundColor = [UIColor whiteColor];
    _shareBgView.layer.masksToBounds = YES;
    _shareBgView.layer.cornerRadius = 5;
    [_shareMainVIew addSubview:_shareBgView];
    
    
    _shareHeadImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 18 * 2), 143 * (SCREEN_WIDTH - 18 * 2) / 340)];
    _shareHeadImageV.image = [UIImage imageNamed:@"pic_share_headImage"];
    [_shareMainVIew addSubview:_shareHeadImageV];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, _shareHeadImageV.bottom + 20, (SCREEN_WIDTH - 18 * 4), 12)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = BHHexColor(@"8A9299");
    _timeLabel.text = time;
    [_shareMainVIew addSubview:_timeLabel];
    
    
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.left, _timeLabel.bottom + 16, _timeLabel.width, 12)];
    _contentLabel.font = [UIFont systemFontOfSize:18];
    _contentLabel.textColor = BHHexColor(@"2A3C4C");
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.text = content;
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(_contentLabel.width, MAXFLOAT)];
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width,            size.height);
    [_shareMainVIew addSubview:_contentLabel];
    _shareMainVIew.contentSize =  CGSizeMake(SCREEN_WIDTH - 18 * 2, size.height + _contentLabel.top + 83 + 10);
    
    _shareBgView.height = size.height + _contentLabel.top + 53;
    
    _shareCodeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _shareMainVIew.contentSize.height - 83, 83, 83)];
    _shareCodeImageV.center = CGPointMake(_shareMainVIew.width / 2, _shareCodeImageV.center.y);
    _shareCodeImageV.image = image;
    [_shareMainVIew addSubview:_shareCodeImageV];
    
    UIView *shareBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 54, SCREEN_WIDTH, 54)];
    shareBottomView.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:shareBottomView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(32, 5, 28, 44);
    [backButton setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareBottomView addSubview:backButton];
    
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatButton.frame = CGRectMake(SCREEN_WIDTH - 40 - 18 - 20 - 40, 7, 40, 40);
    [wechatButton setBackgroundImage:[UIImage imageNamed:@"pic_share_wechat"] forState:UIControlStateNormal];
    [wechatButton addTarget:self action:@selector(wechatShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareBottomView addSubview:wechatButton];

    UIButton *pyjButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pyjButton.frame = CGRectMake(SCREEN_WIDTH - 40 - 18, 7, 40, 40);
    [pyjButton setBackgroundImage:[UIImage imageNamed:@"pic_share_pyj"] forState:UIControlStateNormal];
    [pyjButton addTarget:self action:@selector(wetchatFrendAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareBottomView addSubview:pyjButton];
    [sharreV removeFromSuperview];
    sharreV = nil;
    sharreV = shareView;
    sharScrollView = nil;
    sharScrollView = self.shareMainVIew;
    [self show];
}

- (void)show{
    [[[UIApplication sharedApplication] keyWindow] addSubview:sharreV];
    [UIView animateWithDuration:0.01 animations:^{
        sharreV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}

- (void)hidden{
    [UIView animateWithDuration:0.3 animations:^{
        sharreV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [sharreV removeFromSuperview];
        sharreV = nil;
    }];
}
- (void)cancleBtnAction:(UIButton *)sender {
    [self hidden];
}

- (void)wetchatFrendAction:(UIButton *)sender {
    UIImage *image = [sharreV saveLongImage:sharScrollView];
    [BHShareTool shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine VC:self.viewController ShareImage:image];
    
    [self hidden];
}

- (void)wechatShareAction:(UIButton *)sender {
    
    UIImage *image = [sharreV saveLongImage:sharScrollView];
    [BHShareTool shareImageToPlatformType:UMSocialPlatformType_WechatSession VC:self.viewController ShareImage:image];
    [self hidden];
}

-(UIImage*)UIViewToUIImageView:(UIView*)view{
    CGSize size = view.bounds.size;
    // 下面的方法：第一个参数表示区域大小；第二个参数表示是否是非透明的如果需要显示半透明效果，需要传NO，否则传YES；第三个参数是屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 长截图 类型可以是 tableView或者scrollView 等可以滚动的视图 根据需要自己改
- (UIImage *)saveLongImage:(UIScrollView *)scroll {
    
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(scroll.contentSize, YES, [UIScreen mainScreen].scale);
    
    CGPoint savedContentOffset = scroll.contentOffset;
    CGRect savedFrame = scroll.frame;
    scroll.contentOffset = CGPointZero;
    scroll.frame = CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height);
    [scroll.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    scroll.contentOffset = savedContentOffset;
    scroll.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    return image;
}

@end
