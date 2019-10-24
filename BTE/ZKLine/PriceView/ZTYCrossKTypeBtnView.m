//
//  ZTYCrossKTypeBtnView.m
//  ZYWChart
//
//  Created by wanmeizty on 2018/5/22.
//  Copyright © 2018年 zyw113. All rights reserved.
//

#import "ZTYCrossKTypeBtnView.h"

@interface ZTYCrossKTypeBtnView()

@property (nonatomic,strong) NSArray * types;

@end

@implementation ZTYCrossKTypeBtnView

-(instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types{
    self = [super initWithFrame:frame];
    if (self)
    {
        _types = types;
        [self addSubviews];
        self.backgroundColor = backBlue;
    }
    return self;
}

-(void)addSubviews
{
    [_types enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * btn = [self createLabeltitle:obj frame:CGRectMake(0 + idx * 55, 0, 55, self.frame.size.height)];
        btn.tag = 500 + idx;
        [self addSubview:btn];
    }];
}

-(UIButton *)createLabeltitle:(NSString *)title frame:(CGRect)frame
{
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnclick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnView:choseIndex:ktype:)]) {
        [self.delegate btnView:self choseIndex:(btn.tag - 500) ktype:btn.titleLabel.text];
    }
    self.hidden = YES;
}

@end
