//
//  ZTYDialogTextLayer.h
//  Dialog
//
//  Created by wanmeizty on 2018/6/25.
//  Copyright © 2018年 wanmeizty. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ZTYDialogTextLayer : CAShapeLayer
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) BOOL isDHiden;
//- (void)setBackFrame:(CGRect)frame;
- (void)setBackFrame:(CGRect)frame contentText:(NSString *)text;
- (void)setText:(NSString *)text;
@end
