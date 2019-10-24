//
//  ZTYLineTextView.m
//  ZXKlineDemo
//
//  Created by wanmeizty on 2018/5/24.
//  Copyright © 2018年 郑旭. All rights reserved.
//

#import "ZTYLineTextView.h"

#define angleDistant 5

@interface ZTYLineTextView ()
@property (nonatomic,strong) UILabel * textLabel;
@end

@implementation ZTYLineTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor clearColor];
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.frame = CGRectMake(self.frame.size.width - 48, 0, 48, 15);
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        self.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kShape"]];//[UIColor colorWithRed:48/255.0 green:140/255.0 blue:221/255.0 alpha:1/1.0];
        self.textLabel.adjustsFontSizeToFitWidth=YES;
        self.textLabel.minimumScaleFactor=0.5;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
        
        UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 0.5) * 0.5, self.frame.size.width - 48, 0.5)];
        lineview.backgroundColor = [UIColor colorWithHexString:@"E5E5EE"];
        [self addSubview:lineview];
        
    }
    return self;
}


- (void)setText:(NSString *)text{
    self.textLabel.text = text;
}

- (void)setTextColor:(UIColor *)color{
    self.textLabel.textColor = color;
}

- (void)setBackGroudImage:(NSString *)imageName{
    self.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}

@end

