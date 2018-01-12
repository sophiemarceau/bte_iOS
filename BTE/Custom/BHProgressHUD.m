//
//  BHProgressHUD.m
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/27.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHProgressHUD.h"

@interface BHProgressHUD ()

@property (nonatomic,strong) MBProgressHUD *loadingHUD;
@property (nonatomic,strong) MBProgressHUD *viewHUD;

@end

@implementation BHProgressHUD

+ (instancetype)shareInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (MBProgressHUD *)loadingHUD{
    if(_loadingHUD == nil){
        _loadingHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    _loadingHUD.minShowTime = 0.5;
    _loadingHUD.label.text = kPleaseWait;
    return _loadingHUD;
}

+ (void)showLoading{
    [[[self shareInstance] loadingHUD] showAnimated:YES];
}

+ (void)hideLoading{
    [[[self shareInstance] loadingHUD] hideAnimated:YES];
    [[self shareInstance] setLoadingHUD:nil];
}

- (void)showViewHUDWithTitle:(NSString *)title{
    if(_viewHUD == nil){
        _viewHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    _viewHUD.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _viewHUD.customView = [[UIImageView alloc] initWithImage:image];
    _viewHUD.square = YES;
    [_viewHUD hideAnimated:YES afterDelay:1.0f];
    _viewHUD.label.text = NSLocalizedString(title, @"HUD done title");
}

@end
