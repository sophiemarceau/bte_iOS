//
//  Tools.h
//  noMiss
//
//  Created by wy on 15/9/21.
//  Copyright (c) 2015年 北京智阅网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLAnimatedImage.h"
@interface Tools : NSObject<UIActionSheetDelegate>

//  2.邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email;
//  3.电话号验证
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
// 电话号码检测
+ (BOOL)checkPhoneNum:(NSString *)_text;
/**
 *  返回地址信息
 *
 *  @param baseS <#baseS description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)returnUrlString:(NSString *)baseS;
//  1.NSString 为空(nil)的验证
+ (BOOL)isEmptyOrNull:(NSString *)string;

//是否6-18位数字或者字母组合
+ (BOOL)isPassWord:(NSString *)strPassword;
/**
 *  图片压缩
 *
 *  @param image   <#image description#>
 *  @param newSize <#newSize description#>
 *
 *  @return <#return value description#>
 */
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
/**
 *  全屏截取图片
 *
 *  @return 返回对应image
 */
+(UIImage *)fullScreenshots;
/**
 *  格式化字符串，判断不是字符串类型强转string
 *
 *  @param s 对应值
 *
 *  @return 返回字符串
 */
+(NSString *)stringFormat:(id)s;

/**
 *  @author wywinstonwy, 16-04-05 16:04:43
 *
 *  汉字拼音首字母获取
 *
 *  @param aString 传入汉字
 *
 *  @return 返回拼音
 */
+ (NSString *)firstCharactor:(NSString *)aString;

/**
 *  @author wywinstonwy, 16-04-12 18:04:36
 *
 *  返回文字高度
 *
 *  @param str  字符串
 *  @param font 字体大小
 *
 *  @return 返回绘制结果
 */
+(CGRect)returnSizeWithString:(NSString *)str fontSize:(NSInteger)font;

+ (BOOL)isMaxTenthousand:(NSString *)count;

/**
 *  @author wywinstonwy, 16-03-29 20:03:15
 *
 *  获取保存的数据
 *
 *  @param key
 *
 *  @return
 */
+ (id)loadLocalWithKey:(NSString *)key;
/**
 *  @author wywinstonwy, 16-03-29 20:03:43
 *
 *  归档本地化管理
 *
 *  @param key 保存对应key路径
 *  @param obj 要保存的对象
 */
+ (void)saveLoacalWithKey:(NSString *)key object:(id)obj;
//加载动画
+ (FLAnimatedImageView *)imageWithImage;
/**
 *  删除动画
 *
 *  @return
 */
+ (void)removeLoadingView;
#pragma mark 动画类
+(void)PraiseAnimationWithView:(UIView *)view;
@end
