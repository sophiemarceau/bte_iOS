//
//  WLToast.m
//  WangliBank
//
//  Created by xuehan on 16/6/17.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "BHToast.h"

#define kMD_ScreenSize [UIScreen mainScreen].bounds.size
#define kMD_ScreenWidth kMD_ScreenSize.width
#define kMD_ScreenHeight kMD_ScreenSize.height

#define kToastFontSize 13

@interface BHToast ()
@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,strong) UILabel *messageLabel;
@end

@implementation BHToast
- (UIWindow *)window{
    if(_window == nil){
        NSArray  *windows = [UIApplication sharedApplication].windows;
        _window = [[UIWindow alloc] init];
        _window.hidden = NO;
        _window.windowLevel = [(UIWindow *)windows.lastObject windowLevel] + 1;
        _window.userInteractionEnabled = NO;
        _window.alpha = 0.6;
        _window.backgroundColor = [UIColor clearColor];
    }
    return _window;
}
+ (instancetype)shareInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
+ (void)showMessage:(NSString *)message{
    [self showMessage:message showTime:1.2f finished:nil];
}
+ (void)showMessage:(NSString *)message showTime:(NSTimeInterval)duration{
    [[self shareInstance] showMessage:message showTime:duration finished:nil];
}

+ (void)showMessage:(NSString *)message
           showTime:(NSTimeInterval)duration
           finished:(void(^)())finished {
    [[self shareInstance] showMessage:message showTime:duration finished:finished];
}

+ (void)showMessage:(NSString *)message
           showTime:(NSTimeInterval)duration
           finished:(void(^)())finished withDirection:(BOOL)isLeftRight{
    
    [[self shareInstance] showMessage:message showTime:duration finished:finished withDirection:isLeftRight];
    
}

- (void)showMessage:(NSString *)message showTime:(NSTimeInterval)duration finished:(void(^)(void))finished withDirection:(BOOL)isLeftRight{
    if (message.length == 0) return;
    
    if (isLeftRight) {
        [self.window setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    }
    UILabel *label = [[UILabel alloc] init];
    _messageLabel = label;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.text = message;
    label.preferredMaxLayoutWidth = kMD_ScreenWidth - 60.0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.layer.cornerRadius = 4;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:kToastFontSize];
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(kMD_ScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kToastFontSize]} context:nil];
    label.frame = CGRectMake(0, 0, rect.size.width+10, rect.size.height + 10);
    label.center = CGPointMake(kMD_ScreenWidth/2.0, kMD_ScreenHeight*0.5);
    [self.window addSubview:label];
    label.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [label removeFromSuperview];
            _window.hidden = YES;
            _window = nil;
            if (finished) {
                finished();
            }
        });
    }];
}

- (void)showMessage:(NSString *)message showTime:(NSTimeInterval)duration finished:(void(^)())finished {
    if (message.length == 0) return;
    
    UILabel *label = [[UILabel alloc] init];
    _messageLabel = label;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.text = message;
    label.preferredMaxLayoutWidth = kMD_ScreenWidth - 60.0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.layer.cornerRadius = 4;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:kToastFontSize];
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(kMD_ScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kToastFontSize]} context:nil];
    label.frame = CGRectMake(0, 0, rect.size.width+10, rect.size.height + 10);
    label.center = CGPointMake(kMD_ScreenWidth/2.0, kMD_ScreenHeight*0.5);
    [self.window addSubview:label];
    label.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [label removeFromSuperview];
            _window.hidden = YES;
            _window = nil;
            if (finished) {
                finished();
            }
        });
    }];
}
@end
