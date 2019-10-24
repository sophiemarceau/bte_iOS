//
//  ZTYScreenshot.m
//  BTE
//
//  Created by wanmeizty on 15/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYScreenshot.h"
#import "FormatUtil.h"
@implementation ZTYScreenshot
+ (UIImage *)screenshotImage{
    
    UIImage *resultImg;
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, [UIScreen mainScreen].scale);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    self.imgView.image = screenImage;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"hhh@3x" ofType:@"png"];
//    UIImage *img = [UIImage imageWithContentsOfFile:path];
    UIImage *img = [UIImage imageNamed:@"sharebg"];
    CGImageRef imgRef = img.CGImage;
//    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //以1.png的图大小为底图
//    UIImage *img1 = [UIImage imageNamed:@"show1X"];
    CGImageRef imgRef1 = screenImage.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef1);
    CGFloat h1 = CGImageGetHeight(imgRef1);
    
//    if (IS_IPHONEX) {
//        UIImage *imgx = [UIImage imageNamed:@"show1"];
//        CGImageRef imgRefx = imgx.CGImage;
//        w1 = CGImageGetWidth(imgRefx);
//        h1 = CGImageGetHeight(imgRefx);
//        img = [UIImage imageNamed:@"shareBBB"];
//        imgRef = img.CGImage;
//        h = CGImageGetHeight(imgRef);
//        w1 = CGImageGetWidth(imgRef);
//    }
    
   
    UIImage *codeimg = [UIImage imageNamed:@"qrcode"];
    CGImageRef codeimgRef = codeimg.CGImage;
    CGFloat codew = CGImageGetWidth(codeimgRef);
    CGFloat codeh = CGImageGetHeight(codeimgRef);
    
    h1 = h1 - HOME_INDICATOR_HEIGHT;
    UIGraphicsBeginImageContext(CGSizeMake(w1, h1 ));
    [screenImage drawInRect:CGRectMake(0, 0, w1, h1 )];//先把1.png 画到上下文中
    [img drawInRect:CGRectMake(0, h1 - h, w1, h)];//再把小图放在上下文中
    [codeimg drawInRect:CGRectMake(w1 - codew - 6, h1 - h + (h - codeh) * 0.5, codew, codeh)];//再把小图放在上下文中
        
    
    resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
//    CGImageRelease(imgRef);
//    CGImageRelease(imgRef1);
    return resultImg;
}

+ (UIImage *)screenshotImageBottomImageName:(NSString *)imgName{
    
    UIImage *resultImg;
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, [UIScreen mainScreen].scale);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    self.imgView.image = screenImage;
    
    UIImage *img = [UIImage imageNamed:imgName];
    CGImageRef imgRef = img.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //以1.png的图大小为底图
    UIImage *img1 = [UIImage imageNamed:@"show1"];
    CGImageRef imgRef1 = img1.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef1);
    CGFloat h1 = CGImageGetHeight(imgRef1);
    
    
    UIGraphicsBeginImageContext(CGSizeMake(w1, h1+h));
    [screenImage drawInRect:CGRectMake(0, 0, w1, h1)];//先把1.png 画到上下文中
    [img drawInRect:CGRectMake(0, h1, w1, h)];//再把小图放在上下文中
    resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    //    CGImageRelease(imgRef);
    //    CGImageRelease(imgRef1);
    return resultImg;
}

+(UIImage *)getCapture:(BTECommontModel *)model{
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HOME_INDICATOR_HEIGHT)];
    imageview.image = [UIImage imageNamed:@"community_sharebg"];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 30, SCREEN_WIDTH - 32, 20)];
    titleLabel.text = @"说一说你在币圈令人崩溃的投资经历吧";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [imageview addSubview:titleLabel];
    
    UIImageView * iconimg = [[UIImageView alloc] initWithFrame:CGRectMake(22.1, 92.1, 34.7, 34.7)];
    NSLog(@"%@",model.icon);
//    iconimg.image = [UIImage imageNamed:@"community_headlog"];
    [iconimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.icon]] placeholderImage:[UIImage imageNamed:@"community_headlog"]];
    [imageview addSubview:iconimg];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 97, SCREEN_WIDTH - 67 - 22, 14)];
    nameLabel.textColor = [UIColor colorWithRed:48/255.0 green:140/255.0 blue:221/255.0 alpha:1/1.0];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    nameLabel.text = model.userName; //@"韭菜宝宝";
    [imageview addSubview:nameLabel];
    
    UILabel * contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 119, SCREEN_WIDTH - 67 - 22, SCREEN_HEIGHT - 119 - 128 - 14 - HOME_INDICATOR_HEIGHT)];
    contentlabel.text = model.content;
    contentlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    contentlabel.textColor = [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:1/1.0];
    contentlabel.numberOfLines = 0;
    //    [contentlabel sizeToFit];
    CGSize size = [FormatUtil getsizeWithText:contentlabel.text font:contentlabel.font width:(SCREEN_WIDTH - 67 - 22)];
    if (size.height <= (SCREEN_HEIGHT - 119 - 128 - 14 - HOME_INDICATOR_HEIGHT)) {
        [contentlabel sizeToFit];
    }
    [imageview addSubview:contentlabel];
    
    UIImage* viewImage = nil;
    UIGraphicsBeginImageContextWithOptions(imageview.frame.size, imageview.opaque, 0.0);
    {
        [imageview.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return viewImage;
}

+(UIImage*)getCapture
{
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HOME_INDICATOR_HEIGHT)];
    imageview.image = [UIImage imageNamed:@"community_sharebg"];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 30, SCREEN_WIDTH - 32, 20)];
    titleLabel.text = @"说一说你在币圈令人崩溃的投资经历吧";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [imageview addSubview:titleLabel];
    
    UIImageView * iconimg = [[UIImageView alloc] initWithFrame:CGRectMake(22.1, 92.1, 34.7, 34.7)];
    iconimg.image = [UIImage imageNamed:@"community_headlog"];
    [imageview addSubview:iconimg];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 97, SCREEN_WIDTH - 67 - 22, 14)];
    nameLabel.textColor = [UIColor colorWithRed:48/255.0 green:140/255.0 blue:221/255.0 alpha:1/1.0];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    nameLabel.text = @"韭菜宝宝";
    [imageview addSubview:nameLabel];
    
    UILabel * contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 119, SCREEN_WIDTH - 67 - 22, SCREEN_HEIGHT - 119 - 128 - 14 - HOME_INDICATOR_HEIGHT)];
    contentlabel.text = @"数字货币市场的归零，数字货币市场的归零，数字货币市场的归零，数字货币市场的归零，归零，数字货币市场的归零，归零，数字货币市场的归零～";
    contentlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    contentlabel.textColor = [UIColor colorWithRed:98/255.0 green:106/255.0 blue:117/255.0 alpha:1/1.0];
    contentlabel.numberOfLines = 0;
    //    [contentlabel sizeToFit];
    CGSize size = [FormatUtil getsizeWithText:contentlabel.text font:contentlabel.font width:(SCREEN_WIDTH - 67 - 22)];
    if (size.height <= (SCREEN_HEIGHT - 119 - 128 - 14 - HOME_INDICATOR_HEIGHT)) {
        [contentlabel sizeToFit];
    }
    [imageview addSubview:contentlabel];
    
    UIImage* viewImage = nil;
    UIGraphicsBeginImageContextWithOptions(imageview.frame.size, imageview.opaque, 0.0);
    {
        [imageview.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
