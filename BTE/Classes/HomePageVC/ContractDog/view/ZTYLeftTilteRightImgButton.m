//
//  ZTYLeftTilteRightImgButton.m
//  BTE
//
//  Created by wanmeizty on 2018/7/30.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYLeftTilteRightImgButton.h"

@implementation ZTYLeftTilteRightImgButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [self setTitle:title forState:state];
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [self setImage:image forState:state];
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
}

@end
