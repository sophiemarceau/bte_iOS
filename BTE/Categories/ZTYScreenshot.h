//
//  ZTYScreenshot.h
//  BTE
//
//  Created by wanmeizty on 15/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTECommontModel.h"
@interface ZTYScreenshot : NSObject

+ (UIImage *)screenshotImage;
+ (UIImage *)screenshotImageBottomImageName:(NSString *)imgName;
+(UIImage *)getCapture:(BTECommontModel *)model;
+(UIImage*)getCapture;
@end
