//
//  TYCyclePagerViewCell.m
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell ()
@property (nonatomic, weak) UILabel *label;
@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
//        [self addLabel];
//        [self addWebView];
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = self.bounds;
        [self addSubview:bgView];
        
//        bgView.layer.cornerRadius = 6;
//        bgView.layer.shadowColor = BHHexColor(@"000000").CGColor;
//        bgView.layer.shadowRadius = 6;
//        bgView.layer.shadowOpacity = 0.1;
//        bgView.layer.shadowOffset = CGSizeMake(0,1);
        
//        BHHexColor(@"F9F9FA");
        _bannerImageView  = [[UIImageView alloc] init];
        _bannerImageView.layer.masksToBounds = YES;
        [bgView addSubview:self.bannerImageView];
        _bannerImageView.backgroundColor = [UIColor clearColor];
       
       
//        self.webView = [[UIWebView alloc] init];
//        self.webView = [[WKWebView alloc] init];
//        self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
//        self.webView.userInteractionEnabled = NO;
//        self.webView.scrollView.scrollEnabled = NO;
//
//        [bgView addSubview:self.webView];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
//        [self addLabel];
//        [self addWebView];
        
    }
    return self;
}

//- (void)addLabel {
//    UILabel *label = [[UILabel alloc]init];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:18];
//    [self addSubview:label];
//    _label = label;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _label.frame = self.bounds;
//    _webView.frame = self.bounds;
    _bannerImageView.frame = self.bounds;
     _bannerImageView.layer.cornerRadius = self.bounds.size.height/2;
//    NSLog(@"webView--------->%@",_webView);
}

//- (void)addWebView {
//    UIView *bgView = [[UIView alloc] init];
//    bgView.frame = self.bounds;
//    [self addSubview:bgView];
//
//    bgView.layer.cornerRadius = 6;
//    bgView.layer.shadowColor = BHHexColor(@"000000").CGColor;
//    bgView.layer.shadowRadius = 6;
//    bgView.layer.shadowOpacity = 0.1;
//    bgView.layer.shadowOffset = CGSizeMake(0,1);
//    UIWebView *webView = [[UIWebView alloc] init];
//    webView.userInteractionEnabled = NO;
//    webView.scrollView.scrollEnabled = NO;
//
//    [bgView addSubview:webView];
//    _webView = webView;
//}

@end
