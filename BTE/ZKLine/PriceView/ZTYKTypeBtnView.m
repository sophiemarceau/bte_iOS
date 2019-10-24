//
//  ZTYKTypeBtnView.m
//  BTE
//
//  Created by wanmeizty on 2018/5/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYKTypeBtnView.h"

@interface ZTYKTypeBtnView()

@property (nonatomic,assign) CGFloat btnW;
@property (nonatomic,strong) NSArray * types;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UIButton * moreBtn;
@property (nonatomic,assign) CGFloat leftMargin;

@end

@implementation ZTYKTypeBtnView

-(instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types{
    self = [super initWithFrame:frame];
    if (self)
    {
        _types = types;
        _leftMargin = 0;
        _btnW = frame.size.width / types.count;
        [self addSubviews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types leftMargin:(CGFloat)leftMargin{
    self = [super initWithFrame:frame];
    if (self)
    {
        _types = types;
        _leftMargin = leftMargin;
        _btnW = (frame.size.width - leftMargin)/ types.count;
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    [_types enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton * btn = [self createLabeltitle:obj frame:CGRectMake(_leftMargin + idx * _btnW, 0, _btnW, self.frame.size.height)];
        btn.tag = 400 + idx;
        [btn addTarget:self action:@selector(selectc:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        if ([obj isEqualToString:@"更多"]) {
            
            [btn setImage:[UIImage imageNamed:@"kline_more"] forState:UIControlStateNormal];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            // 重点位置开始
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 24 + 2, 0, -24 - 2);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
            _moreBtn = [self createLabeltitle:@"更多" frame:CGRectMake(0 + idx * _btnW - 13, 0, 50, self.frame.size.height)];
            _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            _moreBtn.backgroundColor = backBlue;
            [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _moreBtn.hidden = YES;
            [self addSubview:_moreBtn];
            
        }
    }];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake( 4 +_leftMargin, self.frame.size.height - 2, 16, 2)];
    self.lineView.backgroundColor = backBlue;
    [self addSubview:self.lineView];
}

- (void)selectc:(UIButton *)btn{
    for (int i = 0; i < _types.count; i ++) {
       UIButton * btn = [self viewWithTag:(400 + i)];
        [btn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    }
    CGSize size = [btn.titleLabel.text getSizeOfString:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constroSize:CGSizeMake(SCREEN_WIDTH, 40)];
    [btn setTitleColor:backBlue forState:UIControlStateNormal];
    
    self.lineView.frame = CGRectMake(_leftMargin + (btn.tag - 400) * _btnW + (size.width - 16) * 0.5, self.frame.size.height - 2, 16, 2);
    
    BOOL isMoreBtn = NO;
    if (btn.tag - 400 == _types.count -1 && [_types[btn.tag - 400] isEqualToString:@"更多"]) {
        _moreBtn.hidden = NO;
        isMoreBtn = YES;
    }else{
        _moreBtn.hidden = YES;
        isMoreBtn = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ktypeView:choseIndex:type:MoreBtnClick:)]) {
        [self.delegate ktypeView:self choseIndex:(btn.tag - 400) type:_types[btn.tag - 400] MoreBtnClick:isMoreBtn];
    }
    
}

- (void)hideMoreBtn{
    _moreBtn.hidden = YES;
}

-(UIButton *)createLabeltitle:(NSString *)title frame:(CGRect)frame
{
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = frame;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"626A75"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    return btn;
}

@end
