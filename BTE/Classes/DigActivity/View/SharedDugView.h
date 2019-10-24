//
//  SharedDugView.h
//  BTE
//
//  Created by sophie on 2018/10/30.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UShareUI/UMSocialShareUIConfig.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, UMSHAREPic_TYPE)
{
    UMSHAREPic_TYPE_TEXT,
    UMSHAREPic_TYPE_IMAGE,
    UMSHAREPic_TYPE_IMAGE_URL,
    UMSHAREPic_TYPE_TEXT_IMAGE,
    UMSHAREPic_TYPE_WEB_LINK,
};
typedef void(^ShareDigCallBack)(void);//分享回调预留
@interface SharedDugView : UIView
//分享需要的参数
@property (nonatomic, strong) id shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, assign) UMSHAREPic_TYPE shareType;
@property (nonatomic, copy) ShareDigCallBack shareViewCallBack;
@property (nonatomic, assign) UMSocialPlatformType platform;
@property (nonatomic, strong) UIImage *sharePicImage;
/**
 *  当前视图控制器
 */
@property (nonatomic,weak)  UIViewController *viewController;
/**
 分享弹窗
 */
+ (void)popShareViewCallBack:(ShareDigCallBack)shareViewCallBack
                    imageUrl:(id)_imageUrl shareUrl:(id)_shareUrl sharetitle:(NSString *)_sharetitle shareDesc:(NSString *)_shareDesc shareType:(UMSHAREPic_TYPE)_shareType currentVc:(UIViewController *)currentVc WithQrImage:(UIImage *)erCodeImage WithInviteCode:(NSString *)inviteCodeStr WithDugNum:(NSString *)dugNumStr;
@end

NS_ASSUME_NONNULL_END
