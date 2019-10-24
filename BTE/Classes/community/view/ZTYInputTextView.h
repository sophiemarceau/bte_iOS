//
//  ZTYInputTextView.h
//  BTE
//
//  Created by wanmeizty on 5/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTYInputTextView : UIView
@property (assign,nonatomic) BOOL isEdit;
@property (copy,nonatomic) void (^finishBlock)(NSString * text);
@property (copy,nonatomic) void (^beginBlock)(void);
- (void)setPlaceholderstr:(NSString *)placeholder;
- (void)hiddenKeyboard;
- (void)beginEidt;
@end

NS_ASSUME_NONNULL_END
