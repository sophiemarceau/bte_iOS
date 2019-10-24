//
//  BHAdvisoryNewShrreView.h
//  BitcoinHeadlines
//
//  Created by wangli on 2018/1/9.
//  Copyright © 2018年 zhangyuanzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHAdvisoryNewShrreView : UIView
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIImageView *shareCodeImageV;

@property (strong, nonatomic) UIImageView *shareHeadImageV;//头部图片
@property (strong, nonatomic) UIImageView *shareBgImageV;//背景图片
@property (strong, nonatomic) UIView *shareBgView;//白色背景

@property (strong, nonatomic) UIScrollView *shareMainVIew;
+ (void)showAdvisoryShareViewWithTimes:(NSString *)time content:(NSString *)content codeImage:(UIImage *)image;
- (void )showAdvisoryShareViewWithTime:(NSString *)time content:(NSString *)content codeImage:(UIImage *)image;

@end
