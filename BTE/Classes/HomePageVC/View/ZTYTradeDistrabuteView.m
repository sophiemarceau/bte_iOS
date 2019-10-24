//
//  ZTYTradeDistrabuteView.m
//  BTE
//
//  Created by wanmeizty on 27/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYTradeDistrabuteView.h"
#import "ZTYDistrabuteView.h"
#import "BTECalculateDistrabutionValue.h"
@interface ZTYTradeDistrabuteView ()
@property (assign,nonatomic) int count;
@end

@implementation ZTYTradeDistrabuteView

- (instancetype)initWithFrame:(CGRect)frame showCount:(int)count{
    if (self = [super initWithFrame:frame]) {
        
        _count = count;
        
        CGFloat distrViewH = (frame.size.height - (count + 1)* 1) / (count * 1.0);
        for (int i = 0; i < count; i ++) {
            
            ZTYDistrabuteView * distrabuteView = [[ZTYDistrabuteView alloc] initWithFrame:CGRectMake(0,(distrViewH + 1) * i, 0, distrViewH)];
            [distrabuteView setRedLineWidth:frame.size.width];
            distrabuteView.tag = 5000+i;
            [self addSubview:distrabuteView];
            
        }
    }
    return self;
}


- (void)showDistrabute:(NSArray *)dataArray max:(CGFloat)maxvalue min:(CGFloat)minvalue left:(CGFloat)left{
    
    NSDictionary * distrabuteDict =  [BTECalculateDistrabutionValue getDictwithKlineArray:dataArray max:maxvalue min:minvalue count:_count];
    double max = [[distrabuteDict objectForKey:@"max"] doubleValue];
    int maxindex = [[distrabuteDict objectForKey:@"maxindex"] intValue];
    if (!isinf(max)){
        for (int i = 0; i < _count; i ++) {
            BTEDistributionModel * model = [distrabuteDict objectForKey:[NSString stringWithFormat:@"distribution%d",i]];
            ZTYDistrabuteView * view = [self viewWithTag:5000 + i];
            CGRect tempframe = view.frame;
            tempframe.origin.x = left;
            tempframe.size.width = self.frame.size.width * 0.7 * model.distribution / max;
            if (!isnan(model.distribution) && max != 0) {
                view.frame = tempframe;
            }
            
            if (i == maxindex ) {
                [view hideLine:NO];
            }else{
                [view hideLine:YES];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
