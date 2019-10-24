//
//  TLMenuButtonView.m
//  MiShu
//
//  Created by tianlei on 16/6/24.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import "TLMenuButtonView.h"
#define ColorWithRGB(r, g, b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:0.9]
#define kWindow [[UIApplication sharedApplication] keyWindow]

@interface TLMenuButtonView ()

@property (nonatomic, strong) TLMenuButton *menu1;

@property (nonatomic, strong) TLMenuButton *menu2;

@property (nonatomic, strong) TLMenuButton *menu3;

@property (nonatomic, strong) TLMenuButton *menu4;

@property (nonatomic, strong) TLMenuButton *menu5;

@property (nonatomic, strong) TLMenuButton *menu6;

@property (nonatomic, strong) TLMenuButton *menu7;
@end

static TLMenuButtonView *instanceMenuView;

@implementation TLMenuButtonView
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}


- (void)showItemsWith:(UIButton *)plusButton{
    CGPoint center = self.centerPoint;
    
    CGFloat r = 155 ;

    CGPoint point1 = CGPointMake(center.x - r*cos(M_PI / 8),     center.y-r*sin(M_PI/8)+30);
    CGPoint point2 = CGPointMake(center.x - r*cos(M_PI * 2 / 8), center.y - r*sin(M_PI * 2 / 8)+30);
    CGPoint point3 = CGPointMake(center.x - r*cos(M_PI * 3 / 8), center.y - r*sin(M_PI * 3 / 8)+30);
    CGPoint point4 = CGPointMake(center.x - r*cos(M_PI * 4 / 8 ), center.y - r*sin(M_PI * 4 / 8)+30);
    CGPoint point5 = CGPointMake(center.x - r*cos(M_PI * 5 / 8) , center.y - r*sin(M_PI * 5 / 8)+30);
    CGPoint point6 = CGPointMake(center.x - r*cos(M_PI * 6 / 8 ), center.y - r*sin(M_PI * 6 / 8)+30);
    CGPoint point7 = CGPointMake(center.x - r*cos(M_PI * 7 / 8) , center.y - r*sin(M_PI * 7 / 8)+30);
   
    
    TLMenuButton *menu1 = [TLMenuButton buttonWithTitle:@"" imageTitle:@"luzhaung" center:center color:ColorWithRGB(93,198,78)];
    menu1.tag = 1;
    [menu1 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
   // CGPoint point2 = CGPointMake(center.x - r*cos(M_PI / 8-M_PI*3/48), center.y - r*sin(M_PI / 8-M_PI*3/48));
    TLMenuButton *menu2 = [TLMenuButton buttonWithTitle:@"" imageTitle:@"boduanicon" center:center color:ColorWithRGB(242,104,90)];
     menu2.tag = 2;
    [menu2 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
   // CGPoint point3 = CGPointMake(center.x - r*cos(M_PI / 4-M_PI/24), center.y - r*sin(M_PI / 4-M_PI/24));
    
    TLMenuButton *menu3 = [TLMenuButton buttonWithTitle:@"" imageTitle:@"yanjiu" center:center color:ColorWithRGB(93,198,78)];
    menu3.tag = 3;
    [menu3 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
    //CGPoint point4 = CGPointMake(center.x - r*cos(M_PI * 3 / 8-M_PI/48), center.y - r*sin(M_PI * 3 / 8-M_PI/48));
    TLMenuButton *menu4 = [TLMenuButton buttonWithTitle:@"" imageTitle:@"heyue" center:center color:ColorWithRGB(189,111,221)];
    menu4.tag = 4;
    [menu4 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
   // CGPoint point5 = CGPointMake(center.x, center.y - r);
    TLMenuButton *menu5 = [TLMenuButton buttonWithTitle:@"" imageTitle:@"dingpan" center:center color:ColorWithRGB(87,211,200)];
    menu5.tag = 5;
    [menu5 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
    
    TLMenuButton *menu6 = [TLMenuButton buttonWithTitle:@"" imageTitle:@"xiaoxi" center:center color:ColorWithRGB(87,211,200)];
    menu6.tag = 6;
    [menu6 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
    TLMenuButton *menu7 = [TLMenuButton buttonWithTitle:@"" imageTitle:@"jiqi" center:center color:ColorWithRGB(87,211,200)];
    menu7.tag = 7;
    [menu7 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
    
   
    
    _menu1 = menu1;
    _menu2 = menu2;
    _menu3 = menu3;
    _menu4 = menu4;
    _menu5 = menu5;
    _menu6 = menu6;
    _menu7 = menu7;
    
    _menu1.alpha = 0;
    _menu2.alpha = 0;
    _menu3.alpha = 0;
    _menu4.alpha = 0;
    _menu5.alpha = 0;
    _menu6.alpha = 0;
    _menu7.alpha = 0;
    
    
    
    [kWindow addSubview:menu1];
    [kWindow addSubview:menu2];
    [kWindow addSubview:menu3];
    [kWindow addSubview:menu4];
    [kWindow addSubview:menu5];
    [kWindow addSubview:menu6];
    [kWindow addSubview:menu7];
    [kWindow addSubview:plusButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        _menu1.alpha = 1;
        _menu2.alpha = 1;
        _menu3.alpha = 1;
        _menu4.alpha = 1;
        _menu5.alpha = 1;
        _menu6.alpha = 1;
        _menu7.alpha = 1;
        
        _menu1.center = point1;
        _menu2.center = point2;
        _menu3.center = point3;
        _menu4.center = point4;
        _menu5.center = point5;
        _menu6.center = point6;
        _menu7.center = point7;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        _menu1.center = self.centerPoint;
        _menu2.center = self.centerPoint;
        _menu3.center = self.centerPoint;
        _menu4.center = self.centerPoint;
        _menu5.center = self.centerPoint;
        _menu6.center = self.centerPoint;
        _menu7.center = self.centerPoint;
        _menu1.alpha = 0;
        _menu2.alpha = 0;
        _menu3.alpha = 0;
        _menu4.alpha = 0;
        _menu5.alpha = 0;
        _menu6.alpha = 0;
        _menu7.alpha = 0;
        
    } completion:^(BOOL finished) {
        [_menu1 removeFromSuperview];
        [_menu2 removeFromSuperview];
        [_menu3 removeFromSuperview];
        [_menu4 removeFromSuperview];
        [_menu5 removeFromSuperview];
        [_menu6 removeFromSuperview];
        [_menu7 removeFromSuperview];
        
    }];
}

- (void)dismissAtNow{
    [_menu1 removeFromSuperview];
    [_menu2 removeFromSuperview];
    [_menu3 removeFromSuperview];
    [_menu4 removeFromSuperview];
    [_menu5 removeFromSuperview];
    [_menu6 removeFromSuperview];
    [_menu7 removeFromSuperview];
    
}

- (void)_addExamApprovel:(UIButton *)sender{
    //[self dismiss];
    NSLog( @"_addExamApprovel------->%@", sender );
    if (self.clickAddButton) {
        self.clickAddButton(sender.tag, [sender valueForKey:@"backgroundColor"] );
    }
}
+ (instancetype)standardMenuView{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instanceMenuView = [[self alloc] init];
    });
    return instanceMenuView;
}
@end
