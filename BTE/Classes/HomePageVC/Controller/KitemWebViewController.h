//
//  KitemWebViewController.h
//  BTE
//
//  Created by wanmeizty on 6/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KitemWebViewController : UIViewController
@property (strong,nonatomic) UIWebView * webView;
@property (copy,nonatomic) void(^updateHeightBlock)(CGFloat height);
-(void)loadView:(NSString *)urlStr;
- (instancetype)initWithUrl:(NSString *)url;
@end
