//
//  ZTYCrossKTypeBtnView.h
//  ZYWChart
//
//  Created by wanmeizty on 2018/5/22.
//  Copyright © 2018年 zyw113. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTYCrossKTypeBtnView;
@protocol MoreProtocol <NSObject>

- (void)btnView:(ZTYCrossKTypeBtnView *)btnView choseIndex:(NSInteger)index ktype:(NSString *)ktype;

@end

@interface ZTYCrossKTypeBtnView : UIView

@property (nonatomic,weak) id <MoreProtocol>delegate;

-(instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types;
@end
