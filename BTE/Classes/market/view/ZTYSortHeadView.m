//
//  ZTYSortHeadView.m
//  BTE
//
//  Created by wanmeizty on 15/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYSortHeadView.h"
#import "BTESortView.h"
@implementation ZTYSortHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame sortTitles:(NSArray *)titles isCanSorts:(NSArray *)canSorts aligns:(NSArray *)aligns{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat width = (frame.size.width - 32)/ (titles.count * 1.0);
        int index = 0;
        for (NSString * title in titles) {
            BOOL cansort = NO;
            if (canSorts.count > index) {
                cansort = [canSorts[index] boolValue];
            }
            NSTextAlignment algin = NSTextAlignmentRight;
            if (aligns.count > index) {
                algin = [aligns[index] intValue];
            }
            BTESortView * sortBtn = [[BTESortView alloc] initWithFrame:CGRectMake(16 + index * width, 0 , width, frame.size.height) withTitle:title canSort:cansort position:algin];
            sortBtn.tag = 200 + index;
            [sortBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:sortBtn];
            index ++;
        }
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5EE"];
        [self addSubview:lineView];
    }
    return self;
}

-(void)setUpsortTitles:(NSArray *)titles isCanSorts:(NSArray *)canSorts aligns:(NSArray *)aligns{
    int index = 0;
    for (NSString * title in titles) {
        BOOL cansort = NO;
        if (canSorts.count > index) {
            cansort = [canSorts[index] boolValue];
        }
        NSTextAlignment algin = NSTextAlignmentRight;
        if (aligns.count > index) {
            algin = [aligns[index] intValue];
        }
        BTESortView * sortBtn = [self viewWithTag:200 +index];
        sortBtn.tag = 200 + index;
        index ++;
    }
}

- (void)click:(BTESortView *)btn{
    if ([self.delegate respondsToSelector:@selector(sortClickIndex:)]) {
        [self.delegate sortClickIndex:(int)(btn.tag - 200)];
    }
}

@end
