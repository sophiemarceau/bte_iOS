//
//  Tools.m
//  noMiss
//
//  Created by wy on 15/9/21.
//  Copyright (c) 2015年 北京智阅网络科技有限公司. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Tools


#pragma mark NSString 为空(nil)的验证
+ (BOOL)isEmptyOrNull:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark  Email验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//以上集合一起，并兼容14开头的

#pragma mark 电话号验证
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181
     22         */
    NSString * CT = @"^1((33|77|70|53|81|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        
        || ([regextestphs evaluateWithObject:mobileNum] == YES))
        
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
/**
 *  返回地址信息
 *
 *  @param baseS <#baseS description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)returnUrlString:(NSString *)baseS
{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:baseS];
    if ([Tools isEmptyOrNull:url]) {
        return baseS;
    }
    return url;
}
/**
 *  是否6-8位数字或者字母组合
 *
 *  @param BOOL 验证密码
 *
 *  @return 返回结果
 */
+ (BOOL)isPassWord:(NSString *)strPassword
{
    NSString *regex = @"^[A_Za-z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:strPassword];
    
    return isMatch;
}
//对图片尺寸进行压缩--

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize

{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
    
}


#pragma mark 全屏截图
+(UIImage *)fullScreenshots{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
    //  UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
}
#pragma mark  获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)firstCharactor:(NSString *)aString
{
    if ([Tools isEmptyOrNull:aString]) {
        return @"#";
    }
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}
#pragma mark 返回字符串高度
+ (CGRect)returnSizeWithString:(NSString *)str fontSize:(NSInteger)font
{
    NSDictionary *dict = @{NSFontAttributeName :KfontNormal(font)};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 6000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
    
}
#pragma mark 是否上万
+ (BOOL)isMaxTenthousand:(NSString *)count;
{
    if([count rangeOfString:@"万"].length>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark 字符串转化
+(NSString *)stringFormat:(id)s;
{
    if ([s isKindOfClass:[NSString class]]) {
        return s;
    }
    else
    {
        return [NSString stringWithFormat:@"%@",s];
    }
}
# pragma mark 文件解档
+ (id)loadLocalWithKey:(NSString *)key
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //用户信息和版本号取消关联 为兼容3.1.1版本 固定该字段
    if ([key isEqualToString:@"TTUserInfoModel"]) {
        version = @"3.1.1";
    }

    NSString *path = [NSString stringWithFormat:@"%@/UserInfoCatche%@/%@",docPath,version,key];
    NSString *foler = [NSString stringWithFormat:@"%@/UserInfoCatche%@",docPath,version];
    [self createDirectoryWithPath:foler];
    id obj=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return obj;
}
#pragma mark 文件归档
+ (void)saveLoacalWithKey:(NSString *)key object:(id)obj
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //用户信息和版本号取消关联 为兼容3.1.1版本 固定该字段
    if ([key isEqualToString:@"TTUserInfoModel"]) {
        version = @"3.1.1";
    }
    NSString *path;//=[docPath stringByAppendingPathComponent:key];
    path = [NSString stringWithFormat:@"%@/UserInfoCatche%@/%@",docPath,version,key];
  
    NSString *foler = [NSString stringWithFormat:@"%@/UserInfoCatche%@",docPath,version];
    //  NSLog(@"path=%@",path);
    [self createDirectoryWithPath:foler];
  //  NSLog(@"path=%@",path);
    [NSKeyedArchiver archiveRootObject:obj toFile:path];
}

/**
 *  创建缓存目录（如果目录不存在）
 *
 *  @param path 目录路径
 */
+ (void)createDirectoryWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        
    } else {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark 点赞放大动画
+(void)PraiseAnimationWithView:(UIView *)view;
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [view.layer addAnimation:k forKey:@"SHOW"];

}
#pragma mark 电话号码检测
+ (BOOL)checkPhoneNum:(NSString *)_text
{
    NSString *Regex =@"(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:_text];
}

#pragma mark 加载动画
+ (FLAnimatedImageView *)imageWithImage
{
    CGRect feedFooterFrame = CGRectMake(0, 0, 32, 32);
    //将图片转为NSData数据
    NSData *localFooterData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jiazaipage" ofType:@"gif"]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *loading = [window viewWithTag:1000112];
    if (loading) {
        return nil;
    }
    if (localFooterData) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:feedFooterFrame];
        FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:localFooterData];
        imageView.animatedImage = gifImage;
        imageView.tag = 1000112;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:imageView];
        imageView.center = window.center;
        return imageView;
    } else
    {
        return nil;
    }
}

/**
 *  删除动画
 *
 *  @return
 */
+ (void)removeLoadingView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *loading = [window viewWithTag:1000112];
    [loading removeFromSuperview];
}

@end
