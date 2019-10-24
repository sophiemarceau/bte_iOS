//
//  BHBaseController.m
//  BitcoinHeadlines
//
//  Created by 张竟巍 on 2017/12/23.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHBaseController.h"
#import "BTEMBProgressHUD.h"

@interface BHBaseController ()

@end

@implementation BHBaseController{
    BTEMBProgressHUD   *_mbProgressHud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)hudShow:(UIView *)inView msg:(NSString *)msgText{
    if (_mbProgressHud == nil) {
        _mbProgressHud = [BTEMBProgressHUD showHUDAddedTo:inView animated:YES];
    }
    _mbProgressHud.contentColor = [UIColor whiteColor];
    _mbProgressHud.bezelView.color = [UIColor blackColor];
    _mbProgressHud.label.text = msgText;
    _mbProgressHud.animationType = MBProgressHUDAnimationZoom;
    [_mbProgressHud showAnimated:YES];
}
- (void)hudClose{
    if (_mbProgressHud) {
        [_mbProgressHud removeFromSuperview];
        [_mbProgressHud hideAnimated:NO];
        _mbProgressHud = nil;
    }
}

/**
自定义 titleview
 */
- (void)customtitleView {
    UIImage * image = [UIImage imageNamed:@"home_Navigation bar_logo"];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.navigationItem.titleView = imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(jpush:) name:@"JpushNotice" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JpushNotice" object:nil];
    NMRemovLoadIng;
}

-(void)jpush:(NSNotification *)noti
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[TTJPushNoticeManager shareManger] jpushwithParam:[noti object] WithVC:self];
    });
}

/**
 * 弹出提示框
 */
- (void)alertTitle:(NSString *)title
               msg:(NSString *)msg
         sureTitle:(NSString *)sureTitle
       cansleTitle:(NSString *)cansleTitle
         sureblock:(void(^)(void))sureBlock
       cancelBlock:(void(^)(void))cancelBlock{
    
    
    UIAlertController* alertvc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureBlock();
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cansleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock();
    }];
    [alertvc addAction:defaultAction];
    [alertvc addAction:cancelAction];
    [self presentViewController:alertvc animated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
