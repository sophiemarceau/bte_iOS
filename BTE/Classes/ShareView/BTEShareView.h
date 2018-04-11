//
//  BTEShareView.h
//  BTE
//
//  Created by wangli on 2018/3/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UShareUI/UMSocialShareUIConfig.h>
typedef NS_ENUM(NSUInteger, UMS_SHARE_TYPE)
{
    UMS_SHARE_TYPE_TEXT,
    UMS_SHARE_TYPE_IMAGE,
    UMS_SHARE_TYPE_IMAGE_URL,
    UMS_SHARE_TYPE_TEXT_IMAGE,
    UMS_SHARE_TYPE_WEB_LINK,
};





typedef void(^ShareViewCallBack)(void);//分享回调预留
@interface BTEShareView : UIView
//分享需要的参数
@property (nonatomic, strong) id shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;
@property (nonatomic, copy) ShareViewCallBack shareViewCallBack;
@property (nonatomic, assign) UMSocialPlatformType platform;
/**
 *  当前视图控制器
 */
@property (nonatomic,weak)  UIViewController *viewController;
/**
 分享弹窗
 */
+ (void)popShareViewCallBack:(ShareViewCallBack)shareViewCallBack
                    imageUrl:(id)_imageUrl shareUrl:(id)_shareUrl sharetitle:(NSString *)_sharetitle shareDesc:(NSString *)_shareDesc shareType:(UMS_SHARE_TYPE)_shareType currentVc:(UIViewController *)currentVc;
//对外使用对应tag点击事件
+ (void)popShareViewCallBack:(ShareViewCallBack)shareViewCallBack
                            imageUrl:(id)_imageUrl shareUrl:(id)_shareUrl sharetitle:(NSString *)_sharetitle shareDesc:(NSString *)_shareDesc shareType:(UMS_SHARE_TYPE)_shareType currentVc:(UIViewController *)currentVc shareButtonTag:(NSInteger)index;

@end
