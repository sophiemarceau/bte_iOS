//
//  ZTYKTypeBtnView.h
//  BTE
//
//  Created by wanmeizty on 2018/5/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTYKTypeBtnView;
@protocol KtypeDelegate <NSObject>

- (void)ktypeView:(ZTYKTypeBtnView *)typeView choseIndex:(NSInteger)index type:(NSString *)type MoreBtnClick:(BOOL)isMoreclick;

@end

@interface ZTYKTypeBtnView : UIView

@property (nonatomic,weak) id <KtypeDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types;
- (void)hideMoreBtn;
-(instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types leftMargin:(CGFloat)leftMargin;
@end
