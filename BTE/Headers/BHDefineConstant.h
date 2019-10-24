//
//  BHDefineConstant.h
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#ifndef BHDefineConstant_h
#define BHDefineConstant_h

/* NSLog */
#if DEBUG
#define NSLog(s,...) NSLog(@"%s LINE:%d < %@ >",__FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define NSLog(...) {}
#endif

/* safe release */
#undef SAFE_RELEASE
#define SAFE_RELEASE(__REF) \
{\
if (nil != (__REF)) \
{\
CFRelease(__REF); \
__REF = nil;\
}\
}

//请求错误 提示
#define RequestError(error) \
if (error.code == -1009) { \
[BHToast showMessage:@"网络未连接"];\
}\
if (error.code == 0) { \
[BHToast showMessage:error.domain];\
}\


/* else { \
//    [BHToast showMessage:error.domain];\
//}*/

/* BHUserDefault*/
#define BHUserDefaults [NSUserDefaults standardUserDefaults]


/** 用户BHUser */
#define User [BTEUserInfo shareInstance]


//获取埋点设备信息
#define APPStore_Def @"APPStore" //渠道 APPStore
//登录状态
#define BH_loginSuccess @"WL_loginSuccess"


//加载动画
#define NMShowLoadIng  [Tools imageWithImage]
//删除动画
#define NMRemovLoadIng [Tools removeLoadingView]


#pragma mark - 字符串相关
/**
 *  格式化字符串
 *
 *  如果字符串为@"<null>" 或 NSNull类型 或者nil，会返回 @""
 */
#define stringFormat(string) (string == nil)?@"":[@"<null>" isEqualToString:[NSString stringWithFormat:@"%@",string]]?@"":[NSString stringWithFormat:@"%@",string]
#define BH_StringFormat(object) [NSString stringWithFormat:@"%@",object]

//非空判断 宏
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || [(_ref) isEqual:@"(null)"])
//字符串是否为空
#define STRISEMPTY(str) (str==nil || [str isEqual:[NSNull null]] || [str isEqualToString:@""])


// MARK: 颜色相关
#define COLOR_RGB(r,g,b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1]
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]
#define BHHexColor(colorString) [BHHexColor hexColor:colorString]
#define BHHexColorAlpha(colorString,a) [BHHexColor hexColor:colorString alpha:a]

/// block安全使用之宏定义
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

//weakSelf 宏定义
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define BHColorWhite        [UIColor whiteColor]
/* App导航条颜色*/
#define BHColornavigationBar         [BHHexColor navigationBarColor]
/** App中主蓝色 */
#define BHColorBlue BHHexColor(@"308CDD")

#define BHColorFontGray BHHexColor(@"626A75")
#define BHColorGray         BHHexColor(@"999999")
/* App中全局文本颜色 */
#define BHColorDarkGray     BHHexColor(@"666666")
/* 文本输入框内提示文字颜色及标的提示文字颜色 */
#define BHColorLightGray    BHHexColor(@"CCCCCC")
/* 红色按钮颜色 */
#define BHColorDarkRed      BHHexColor(@"DB493F")
/* 文本输入框内信息错误提示信息颜色 */
#define BHColorRed          BHHexColor(@"F15A4A")
/* App中全局利率颜色 */
#define BHColorPinkRed      BHHexColor(@"FE3217")
/* 按钮不可点击状态颜色, #DB493F 的 40%透明度 */
#define BHColorLightRed     BHHexColor(@"F3B5B1")
/* 按钮不可点击状态颜色(灰色), */
#define BHColorButtonLightGray     BHHexColor(@"CBCBCB")

/* 控制器背景色 */
#define BHColorBgGray_VC    BHHexColor(@"F5F5F5")
/* 分割线的颜色 */
#define BHColorGray_line    BHHexColor(@"E5E5E5")
/* 部分浅灰文字颜色 */
#define BHColorLightGray_text BHHexColor(@"9B9B9B")


//新增
//背景色
#define KBGColor BHHexColor(@"edf0f2")
#define KBGCell BHHexColor(@"FAFAFA")

#define MobilePhoneNum @"MOBILEPHONENUM"
#define MobileTradeNum @"MobileTradeNum"
#define KisFutureDogUser @"isFutureDogUserKey"
#define KisFutureDogUserGoal @"isFutureDogUserGoalKey"

#pragma mark - 颜色相关

#define kColorRgb(r,g,b)               [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1]
#define kColorRgba(r,g,b,a)            [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]


// MARK: 设备相关
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE4 [[UIScreen mainScreen] bounds].size.height == 480.0
#define IS_IPHONE5 [[UIScreen mainScreen] bounds].size.height == 568.0
#define IS_IPHONE6 [[UIScreen mainScreen] bounds].size.height == 667.0
#define IS_IPHONE6PLUS [[UIScreen mainScreen] bounds].size.height == 736.0
#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

// MARK: 屏幕尺寸相关
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define NAVIGATION_HEIGHT  ((IS_IPHONEX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define TAB_BAR_HEIGHT ((IS_IPHONEX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)
#define STATUS_BAR_HEIGHT ((IS_IPHONEX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
// home indicator
#define HOME_INDICATOR_HEIGHT (IS_IPHONEX ? 34.f : 0.f)
#define LBMagin (IS_IPHONEX ? 20.f : 10.f)
// 出借助手header使用
#pragma mark - Font

#define UIFontLightOfSize(fontSize)  (IS_IOS_9 ? [UIFont fontWithName:@"PingFangSC-Light" size:fontSize] : [UIFont systemFontOfSize:fontSize])
#define UIFontRegularOfSize(fontSize)  (IS_IOS_9 ? [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize] : [UIFont systemFontOfSize:fontSize])
#define UIFontMediumOfSize(fontSize)  (IS_IOS_9 ? [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize] : [UIFont systemFontOfSize:fontSize])
#define UIFontSemiboldOfSize(fontSize)  (IS_IOS_9 ? [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize] : [UIFont systemFontOfSize:fontSize])
#define UIFontDINAlternateOfSize(fontSize)  (IS_IOS_9 ? [UIFont fontWithName:@"DINAlternate-Bold" size:fontSize] : [UIFont systemFontOfSize:fontSize])
#define UIFontSemiboldOfSize(fontSize)  (IS_IOS_9 ? [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize] : [UIFont systemFontOfSize:fontSize])


#define FontName [UIFont systemFontOfSize:[UIFont systemFontSize]].fontName // 系统字体
#define  KfontNormal(a) [UIFont fontWithName:FontName size:(a)]

//数据返回结果是字典
#define IsSafeDictionary(_ref)   [_ref isKindOfClass:[NSDictionary class]]

//数据返回结果是数组
#define IsSafeArray(_ref)        [_ref isKindOfClass:[NSArray class]]

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// MARK: 系统相关
#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)
#define IS_IOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)
#define IS_IOS_9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)
#define IS_IOS_10 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) ? YES : NO)

#define SCALE_W(x) (x*(SCREEN_WIDTH/375.0))
#define SCALE_H(y) (y*(SCREEN_WIDTH/667.0))
#define FONT(x) [UIFont systemFontOfSize:(x*(SCREEN_WIDTH/375.0))]

/// 活动弹窗更新时间
#define ActivityEtag [NSString stringWithFormat:@"%@activityEtag", User.phone]

//app版本相关
#define kCurrentVersion [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define kAPPNAME [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]
//联系地址
#define KAPPPHONENUMBER @"10086"
#define kAPPPHONE [NSString stringWithFormat:@"tel://%@",KAPPPHONENUMBER]
#define kAPPPHONEDescription [NSString stringWithFormat:@"您确定要拨打客服热线：%@？",KAPPPHONENUMBER]
#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"

//system version
#define kIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define DOCUMENT_DIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//此类枚举  是为了区别登录成功之后是否跳转首页的情况 、默认是跳转 H5不进行跳转首页
typedef NS_ENUM(NSInteger , LoginSuccessToVCType) {
    LoginSuccessToRootVC = 0, //回到首页
    LoginSuccessToOriginVC  //回到原来页
};


#endif /* BHDefineConstant_h */
