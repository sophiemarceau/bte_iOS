//
//  ZTYFoundHeader.m
//  BTE
//
//  Created by wanmeizty on 21/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYFoundHeader.h"

@interface ZTYFoundHeader ()
@property (strong,nonatomic) UILabel * titleLabel;
@property (strong,nonatomic) UILabel * rightLabel;
@end

@implementation ZTYFoundHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 6) * 0.5, 10, 6)];
    view.backgroundColor = [UIColor colorWithHexString:@"44A0F1"];
    [self addSubview:view];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, self.height)];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    [self addSubview:self.titleLabel];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(216, 0, SCREEN_WIDTH - 232, self.height)];
    self.rightLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.rightLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.rightLabel];
}

- (void)setUpTitle:(NSString *)title right:(NSString *)right{
    self.titleLabel.text = title;
    self.rightLabel.text = right;
}
@end
