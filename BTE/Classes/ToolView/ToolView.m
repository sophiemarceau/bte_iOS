//
//  ToolView.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ToolView.h"
#import "TLMenuButtonView.h"
@interface ToolView ()


@property (nonatomic, strong)UIButton *plusbutton;
@property (nonatomic, strong) TLMenuButtonView *tlMenuView ;
@property (nonatomic, strong) UIImageView *halfRoundImageView;
@end
@implementation ToolView
- (instancetype)initToolView{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView:)];
                [self addGestureRecognizer:tap1];
//        self.backgroundColor = kColorRgba(0, 0, 0, 0.5);
        self.backgroundColor = [UIColor clearColor];
   
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
        
        UIImageView *halfRoundImageView = [[UIImageView alloc] init];
        halfRoundImageView.frame = CGRectMake(0, SCREEN_HEIGHT - 212, SCREEN_WIDTH, SCREEN_WIDTH);
        halfRoundImageView.backgroundColor = [UIColor colorWithHexString:@"F8FAFC"];
        halfRoundImageView.alpha = 0.95;
        halfRoundImageView.layer.cornerRadius = SCREEN_WIDTH / 2;

        //添加四个边阴影
        halfRoundImageView.layer.shadowColor = [UIColor colorWithHexString:@"E4ECF1"].CGColor;//阴影颜色
        halfRoundImageView.layer.shadowOffset = CGSizeMake(0, -10);//偏移距离
        halfRoundImageView.layer.shadowOpacity = 0.5;//不透明度
        halfRoundImageView.layer.shadowRadius = 5;//半径
        
        _halfRoundImageView = halfRoundImageView;
        [self addSubview: _halfRoundImageView];;
        
        self.plusbutton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40/2, SCREEN_HEIGHT- 40 -26, 40, 40)];
        //    button.layer.cornerRadius = 23;
        self.plusbutton.backgroundColor = [UIColor clearColor];
        self.plusbutton.tag = 1000001;
        [self.plusbutton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.plusbutton setImage:[UIImage imageNamed:@"turn off"] forState:UIControlStateNormal];


        TLMenuButtonView *tlMenuView =[TLMenuButtonView standardMenuView];
        tlMenuView.centerPoint = self.plusbutton.center;
        __weak typeof(self) weakSelf = self;
        tlMenuView.clickAddButton = ^(NSInteger tag, UIColor *color){

            //        _ISShowMenuButton = YES;
            [weakSelf selectButtonCallBack:tag];
        };

        _tlMenuView = tlMenuView;



        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI / 2 );
            [self.plusbutton setTransform:rotate];
        } completion:^(BOOL finished) {
            [_tlMenuView showItemsWith:self.plusbutton];
        }];
    }
    return self;
}



- (void)clickAddButton:(UIButton *)sender{
    if (sender.tag ==1000001) {
        self.selectCallBack(0);
    }
    [self dissmissToolView];
}

-(void)selectButtonCallBack:(NSInteger )selectTag{
    self.selectCallBack(selectTag);
    [self dissmissToolView];
}

-(void)dissmissToolView{
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform rotate = CGAffineTransformMakeRotation(0);
        [self.plusbutton setTransform:rotate];
    } completion:^(BOOL finished) {
        [_tlMenuView dismiss];
        [self.plusbutton removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)dismissShareView:(UITapGestureRecognizer *)tapgesture{
    CGPoint tapPoint = [tapgesture locationInView:self];
    if(!CGRectContainsPoint(_halfRoundImageView.frame,tapPoint)) {
        [self dissmissToolView];
    }
}
@end
