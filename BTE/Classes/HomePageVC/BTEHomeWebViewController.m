//
//  BTEHomeWebViewController.m
//  BTE
//
//  Created by wangli on 2018/1/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEHomeWebViewController.h"
#import "BTELoginVC.h"

@interface BTEHomeWebViewController ()

@end

@implementation BTEHomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self customtitleView];
    
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor redColor];
//    btn.frame = CGRectMake(100, 100, 100, 100);
//    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}
- (void)click {
    [BTELoginVC OpenLogin:self callback:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
