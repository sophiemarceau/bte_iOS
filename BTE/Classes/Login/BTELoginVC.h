//
//  BHLoginVC.h
//  BTE
//
//  Created by 张竟巍 on 2018/2/27.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
/**
 登录回调

 @param isComplete 是否完成登录
 */
typedef void (^BHLoginCompletion)(BOOL isComplete);

@interface BTELoginVC : BHBaseController

+(void) OpenLogin:(UIViewController *)viewController callback:(BHLoginCompletion) loginComplation;

@end
