//
//  SharePicView.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/8/2.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UShareUI/UMSocialShareUIConfig.h>
typedef NS_ENUM(NSUInteger, UMS_SHAREPic_TYPE)
{
    UMS_SHAREPic_TYPE_TEXT,
    UMS_SHAREPic_TYPE_IMAGE,
    UMS_SHAREPic_TYPE_IMAGE_URL,
    UMS_SHAREPic_TYPE_TEXT_IMAGE,
    UMS_SHAREPic_TYPE_WEB_LINK,
};





typedef void(^ShareViewCallBack)(void);//分享回调预留
@interface SharePicView : UIView
//分享需要的参数
@property (nonatomic, strong) id shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *sharetitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, assign) UMS_SHAREPic_TYPE shareType;
@property (nonatomic, copy) ShareViewCallBack shareViewCallBack;
@property (nonatomic, assign) UMSocialPlatformType platform;



@property (nonatomic, strong) UIImage *sharePicImage;
/**
 *  当前视图控制器
 */
@property (nonatomic,weak)  UIViewController *viewController;
/**
 分享弹窗
 */
+ (void)popShareViewCallBack:(ShareViewCallBack)shareViewCallBack
                    imageUrl:(id)_imageUrl shareUrl:(id)_shareUrl sharetitle:(NSString *)_sharetitle shareDesc:(NSString *)_shareDesc shareType:(UMS_SHAREPic_TYPE)_shareType currentVc:(UIViewController *)currentVc WithQrImage:(UIImage *)erCodeImage WithInviteCode:(NSString *)inviteCodeStr;
//对外使用对应tag点击事件
+ (void)popShareViewCallBack:(ShareViewCallBack)shareViewCallBack
                    imageUrl:(id)_imageUrl shareUrl:(id)_shareUrl sharetitle:(NSString *)_sharetitle shareDesc:(NSString *)_shareDesc shareType:(UMS_SHAREPic_TYPE)_shareType currentVc:(UIViewController *)currentVc shareButtonTag:(NSInteger)index;


@end
