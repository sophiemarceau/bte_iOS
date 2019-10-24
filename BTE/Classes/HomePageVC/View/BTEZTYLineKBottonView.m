//
//  BTEZTYLineKBottonView.m
//  BTE
//
//  Created by wanmeizty on 2018/7/10.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEZTYLineKBottonView.h"

@implementation BTEZTYLineKBottonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI]; 
       
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    UIButton * kitemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
    [kitemBtn setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
    [kitemBtn setTitle:@"K线" forState:UIControlStateNormal];
//    kitemBtn.backgroundColor = [UIColor colorWithHexString:@"636F97"];
    kitemBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    kitemBtn.tag = 20;
    [self addSubview:kitemBtn];
    [kitemBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = ( SCREEN_WIDTH - 55 - 2.5) / 4.0 ;
    NSArray * titles = @[@"资金",@"详情",@"筹码",@"评级"];
    NSArray * imgNames = @[@"foudFlow",@"currencydesc",@"kcounter",@"comment"];
    for (int index = 0; index < titles.count; index ++) {
        UIButton * btn = [self createImgTitleBtn:titles[index] imgName:imgNames[index] frame:CGRectMake(55 + index * (btnW + 0.5), 0, btnW, 40)];
        btn.tag = 21 + index;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(55 + index * btnW, 11.5, 0.5, 17)];
        line.tag = 30 + index;
        line.backgroundColor = [UIColor colorWithHexString:@"D6D9E8"];
        [self addSubview:line];
        
    }
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake((55 - 20) * 0.5, 38, 20, 2)];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"308CDD"];
    bottomLine.tag = 333;
    [self addSubview:bottomLine];
}

- (void)btnClick:(UIButton *)btn{
    for (int i =0; i < 5; i ++) {
        UIButton * button = [self viewWithTag:20 + i];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
        button.selected = NO;
        UIView *lineview =[self viewWithTag:30 + i];
        lineview.hidden = NO;
    }
    UIView * bottomLine = [self viewWithTag:333];
    if (btn.tag == 20) {
        bottomLine.frame = CGRectMake((55 - 20) * 0.5, 38, 20, 2);
    }else{
        CGFloat btnW = ( SCREEN_WIDTH - 55 - 2.5) / 4.0 ;
        bottomLine.frame = CGRectMake(55 + (btnW+ 0.5)*(btn.tag - 21) + (btnW - 20) * 0.5 , 38, 20, 2);
    }
    [btn setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
    btn.selected = YES;
    if (self.clickBlock) {
        self.clickBlock(btn.tag - 20);
        
    }
}

- (UIButton *)createImgTitleBtn:(NSString *)tilte imgName:(NSString *)imgName frame:(CGRect)frame{
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = frame;
    [button setTitle:tilte forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"636F97"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_nol",imgName]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",imgName]] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    button.imageView.bounds = CGRectMake(0, 0, 14, 14);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.bounds.size.width * 0.5+14, 0,0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, button.imageView.bounds.size.width - 5, 0,0)];
    return button;
}

@end
