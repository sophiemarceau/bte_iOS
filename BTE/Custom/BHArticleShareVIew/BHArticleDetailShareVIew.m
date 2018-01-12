//
//  BHArticleShareVIew.m
//  BitcoinHeadlines
//
//  Created by 奥卡姆 on 2017/12/29.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHArticleDetailShareVIew.h"
#import "BHShareTool.h"

BHArticleDetailShareVIew *detailShareV = nil;

@interface BHArticleDetailShareVIew()

@property (nonatomic,copy) NSString * url;

@property (nonatomic,copy) NSString * title;

@property (nonatomic,copy) NSString * detailTitle;

@property (nonatomic,strong) UIImage * iconImage;

@end
@implementation BHArticleDetailShareVIew

+ (void)showShareViewWithUrl:(NSString *)url title:(NSString *)title DetailTitle:(NSString *)detailTitle icon:(UIImage *)iconImage{
    
    BHArticleDetailShareVIew *shareView = [[NSBundle mainBundle] loadNibNamed:@"BHArticleDetailShareVIew" owner:nil options:nil].lastObject;
    shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    shareView.url = url;
    shareView.title = title;
    shareView.detailTitle = detailTitle;
    shareView.iconImage = iconImage;
    
    detailShareV = shareView;
    
    [self show];
}

+ (void)show{
   
    detailShareV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[[UIApplication sharedApplication] keyWindow] addSubview:detailShareV];
//    [UIView animateWithDuration:0.3 animations:^{
//    } completion:nil];
}


+ (void)hidden{
//    [UIView animateWithDuration:0.3 animations:^{
//        detailShareV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
        [detailShareV removeFromSuperview];
        detailShareV = nil;
//    }];
}
- (IBAction)cancelAction:(id)sender {
    [BHArticleDetailShareVIew hidden];
}

/// 微信
- (IBAction)wechatShareAction:(id)sender {

    
    [BHShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession withVC:self.viewController WithTitle:BH_StringFormat(detailShareV.title) descr:BH_StringFormat(detailShareV.detailTitle) thumImage:detailShareV.iconImage webUrl:detailShareV.url];
    [BHArticleDetailShareVIew hidden];
}

/// 朋友圈
- (IBAction)wechatFriendsAction:(id)sender {
    
      [BHShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine withVC:self.viewController WithTitle:BH_StringFormat(detailShareV.title) descr:BH_StringFormat(detailShareV.detailTitle) thumImage:detailShareV.iconImage webUrl:detailShareV.url];    
    [BHArticleDetailShareVIew hidden];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [detailShareV removeFromSuperview];
    detailShareV = nil;
}
@end
