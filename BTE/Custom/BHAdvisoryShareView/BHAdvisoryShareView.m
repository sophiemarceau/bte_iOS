//
//  BHAdvisoryShareView.m
//  BitcoinHeadlines
//
//  Created by 奥卡姆 on 2017/12/27.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHAdvisoryShareView.h"
#import "BHShareTool.h"


BHAdvisoryShareView *shareV = nil;

@interface BHAdvisoryShareView()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shareCodeImageV;

@property (weak, nonatomic) IBOutlet UIView *shareMainVIew;


@end
@implementation BHAdvisoryShareView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}


+ (void)showAdvisoryShareViewWithTime:(NSString *)time content:(NSString *)content codeImage:(UIImage *)image{
    BHAdvisoryShareView *shareView = [[NSBundle mainBundle] loadNibNamed:@"BHAdvisoryShareView" owner:nil options:nil].lastObject;
    shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    shareView.timeLabel.text = time;
    shareView.contentLabel.text = content;            
    shareView.shareCodeImageV.image = image;
    shareV = shareView;
    [self show];
}

+ (void)show{
    [[[UIApplication sharedApplication] keyWindow] addSubview:shareV];
    [UIView animateWithDuration:0.01 animations:^{
        shareV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}

+ (void)hidden{
    [UIView animateWithDuration:0.3 animations:^{
        shareV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [shareV removeFromSuperview];
        shareV = nil;
    }];
}
- (IBAction)cancleBtnAction:(UIButton *)sender {
    [BHAdvisoryShareView hidden];
}

- (IBAction)wetchatFrendAction:(UIButton *)sender {
    UIImage *image = [shareV UIViewToUIImageView:self.shareMainVIew];
    [BHShareTool shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine VC:self.viewController ShareImage:image];
    
    [BHAdvisoryShareView hidden];
}

- (IBAction)wechatShareAction:(UIButton *)sender {
    
    UIImage *image = [shareV UIViewToUIImageView:self.shareMainVIew];
    [BHShareTool shareImageToPlatformType:UMSocialPlatformType_WechatSession VC:self.viewController ShareImage:image];
    [BHAdvisoryShareView hidden];
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



@end
