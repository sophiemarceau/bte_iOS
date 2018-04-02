//
//  NSString+category.h
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (category)

/*字符串转 MD5*/
- (NSString *)stringFromMD5;
/*字符串转 sha1*/
- (NSString *)sha1;
/*字符加换行符号\n*/
- (NSString *)appNextLineKeyword:(NSString *)word;

/*获取字符串的长度*/
- (CGSize)getSizeOfStringFontSize:(int)fontSize constroSize:(CGSize)size;
- (CGSize)getSizeOfString:(UIFont *)font constroSize:(CGSize)size;

/*邮箱验证 MODIFIED BY HELENSONG*/
- (BOOL)isValidateEmail;
/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isValidateMobile;
/*车牌号验证 MODIFIED BY HELENSONG*/
- (BOOL)validateCarNo;
/*密码验证 字母跟数字组合*/
- (BOOL)isValidatePassword;
//仅支持输入数字
- (BOOL)isValidateAccount;

//获取当前的时间字符串
+ (NSString *)getCurrentDateString;
//NSDate 转 NSString 
+ (NSString *)dateToString:(NSDate *)date;



//汉字编码
- (NSString *)URLEncodedString;
//增加千位分隔符
+ (NSString *)positiveFormat:(NSString *)text;
// 增加千位分隔符
+ (NSString *)addComm:(NSString *)string;
// 去掉千位分隔符
+ (NSString *)removeComm:(NSString *)string;

/// 是否包含某个字符串
- (BOOL)wl_containsString:(NSString *)string;

#pragma mark - 加**处理
/// 对字符处做**替代处理 保留前4位和后4位,中间用*代替
///
/// @return 15811311063 => 1581****1063
- (NSString *)secretString;

/// eg: 15811311063 => 158＊＊＊＊1063
- (NSString *)securityPhoneStr;

/// 保留前六位和后四位,中间的用*代替
///
/// @return 500222199309296130 => 500222*********6130
- (NSString *)secretIDString;

#pragma mark - 去/增 空格处理
/// 去掉字符串中的空格
- (NSString *)trimString;
/// 给字符串添加空格 例: 12345678 => 1234 5678 （实时添加）
- (NSString *)addTrimString;
/// 给字符串添加空格 例: 12345678 => 1234 5678 (整体添加)
+ (NSString *)changStringWith:(NSString *)number;

/// 电话号码添加空格 例: 15811311063 => 158 1131 1063
- (NSString *)addPhoneSpace;
/// 身份证号添加空格 130529199903335333 -> 130529 1999 0333 5333
- (NSString *)addIdCardSpace;
/// ocr返回身份证号的结果处理
- (NSString*)addIdCardSpaceAtOCR;
- (NSString*)addPhoneSpaceNoreal;
//计算字符串的字节数(汉字占两个)
+ (NSUInteger)calculateChineseCount:(NSString*)string;
//从字符串中截取指定字节数(汉字占两个)
- (NSString *)subStringByByteWithIndex:(NSInteger)index;

@end
