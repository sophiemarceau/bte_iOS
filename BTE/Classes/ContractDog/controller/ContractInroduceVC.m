//
//  ContractInroduceVC.m
//  BTE
//
//  Created by wanmeizty on 22/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ContractInroduceVC.h"

@interface ContractInroduceVC ()

@end

@implementation ContractInroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开通合约狗";
    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT)];
    NSURL * url = [NSURL URLWithString:kOpencontractH5Url];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    // Do any additional setup after loading the view.
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
