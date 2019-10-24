//
//  SetPwdViewController.h
//  BTE
//
//  Created by sophie on 2018/9/19.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"
@protocol pwdReturnDelegate <NSObject>
- (void)setWPwdSuccess;
@end
@interface SetPwdViewController : BHBaseController
@property(nonatomic,strong)NSString *phoneStr;
@property(nonatomic,assign)Boolean isSetPWD;
@property(nonatomic,weak) id <pwdReturnDelegate>delegate;
@property(nonatomic,strong)NSString *emailStr;
@end
