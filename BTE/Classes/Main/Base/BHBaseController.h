//
//  BHBaseController.h
//  BitcoinHeadlines
//
//  Created by 张竟巍 on 2017/12/23.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHBaseController : UIViewController

/**
 网络请求loading框

 @param inView load view
 @param msgText load 信息
 eg: [self hudShow:self.view msg:kPleaseWait];
 */
- (void)hudShow:(UIView *)inView msg:(NSString *)msgText;
/**
 关闭loading框
 eg:[self hudclose]
 */
- (void)hudClose;

@end
