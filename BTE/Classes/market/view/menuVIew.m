//
//  menuVIew.m
//  Massage
//
//  Created by 牛先 on 15/10/31.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "menuVIew.h"

@interface menuVIew (){
    CGFloat buttonWidth;
}
@property (strong, nonatomic) UIView *selectedView;
@end

@implementation menuVIew
- (instancetype)initWithFrame:(CGRect)frame WithArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KBGCell;
        buttonWidth = SCREEN_WIDTH/array.count;
        self.lineArray = [NSMutableArray arrayWithCapacity:4];
        self.buttonArray = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0 ; i < array.count; i++) {
            UIButton *menuButton = [[UIButton alloc]initWithFrame:CGRectMake(i*buttonWidth, 0, buttonWidth, 50)];
            [menuButton setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
            [menuButton setTitleColor:BHColorFontGray forState:UIControlStateNormal];
            menuButton.titleLabel.font = UIFontRegularOfSize(13);
            menuButton.tag = i+1;
            [menuButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
            menuButton.backgroundColor = [UIColor clearColor];
            [menuButton setTitleColor:BHColorBlue forState:UIControlStateSelected];
            [self.buttonArray addObject:menuButton];
            self.selectedButton = menuButton;
            
            //计算文字宽度
//            CGSize size = [menuButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:UIFontRegularOfSize(13)}];
            UIView *lineView= [[UIView alloc] init];
            lineView.tag = i+1;
            lineView.frame = CGRectMake((buttonWidth-28)/2, 50 -1, 28, 1);
            lineView.backgroundColor = BHColorBlue;
            [menuButton addSubview:lineView];
            [self.lineArray addObject:lineView];
//            NSLog(@"selectdView--计算文字宽度--->%@",self.selectedView);
            if (menuButton.tag == 1) {
                lineView.hidden = NO;
                 menuButton.selected = YES;
            }else{
                lineView.hidden = YES;
                menuButton.selected = NO;
            }
            [self addSubview:menuButton];
        }
//        
//        UIView *vLineView = [UIView new];
//        vLineView.frame = CGRectMake(0,  50 -1, SCREEN_WIDTH, 0.5);
//        vLineView.backgroundColor = BHHexColor(@"E6EBF0");
//        [self addSubview:vLineView];
    }
    return self;
}


- (void)tapped:(UIButton *)sender {
    
    //计算文字宽度
//    CGSize size = [self.selectedButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [UIView animateWithDuration:0.35 animations:^{
        for (UIView *templine in self.lineArray) {
            if (sender.tag == templine.tag) {
                templine.hidden = NO;
            }else{
                templine.hidden = YES;
            }
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(menuViewDidSelect:)]) {
        [self.delegate menuViewDidSelect:sender.tag];
    }
    for (int i=0; i < self.buttonArray.count; i++) {
        UIButton * selectimv = (UIButton *)[self.buttonArray objectAtIndex:i];
        if (sender.tag == selectimv.tag) {
            selectimv.selected = YES;
        }else{
            selectimv.selected = NO;
        }
    }
}

@end
