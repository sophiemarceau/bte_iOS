//
//  BHBaseController.m
//  BitcoinHeadlines
//
//  Created by 张竟巍 on 2017/12/23.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import "BHBaseController.h"
#import "MBProgressHUD.h"

@interface BHBaseController ()

@end

@implementation BHBaseController{
    MBProgressHUD   *_mbProgressHud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hudShow:(UIView *)inView msg:(NSString *)msgText{
    if (_mbProgressHud == nil) {
        _mbProgressHud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
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
    UIImage * image = [UIImage imageNamed:@"titleImage"];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.navigationItem.titleView = imageView;
}


@end
