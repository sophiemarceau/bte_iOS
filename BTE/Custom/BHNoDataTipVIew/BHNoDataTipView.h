//
//  WLDefaultView.h
//  WangliBank
//
//  Created by xuehan on 16/6/16.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHNoDataTipView : UIView

- (void)setImage:(UIImage *)image message:(NSString *)tipMessage;

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) NSString  *tipMessage;

@end
