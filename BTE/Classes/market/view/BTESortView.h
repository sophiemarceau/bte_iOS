//
//  BTESortView.h
//  BTE
//
//  Created by wanmeizty on 10/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTESortView : UIButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title canSort:(BOOL)cansort position:(NSTextAlignment)textAlignment;
- (void)changeStatus:(BOOL)up;
- (void)sortShow:(BOOL)show;
//- (void)setTitle:(NSString *)title img:(NSString *)imgName;
//- (void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
