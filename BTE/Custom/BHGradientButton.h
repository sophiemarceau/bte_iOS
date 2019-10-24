//
//  WLGradientButton.h
//  WangliBank
//
//  Created by qy on 2017/6/20.
//  Copyright © 2017年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger, GradientType) {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
};
@interface BHGradientButton : UIButton
/** 代码控制 */
@property (nonatomic, assign) IBInspectable NSInteger  gradienttype;
@property (nonatomic, strong) IBInspectable UIColor *startColor;
@property (nonatomic, strong) IBInspectable UIColor *endColor;
/**默认为开启圆角 NO*/
@property (nonatomic, assign) IBInspectable BOOL closeCorner;

+ (instancetype)normalGradientButton;
/**置灰颜色*/
- (void)grayColorSetter;
/**正常颜色*/
- (void)gradientColorSetter;
/**传入不可点击状态的颜色*/
- (void)enableNoStartColor:(UIColor*)start endColor:(UIColor*)end;
@end
