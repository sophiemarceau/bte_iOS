//
//  HeadGridView.m
//  BTE
//
//  Created by sophie on 2018/7/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "HeadGridView.h"
@implementation HomeGridItemImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat imageW = 46;
//    CGFloat imageH = 46;
//    CGFloat imageX = (self.frame.size.width - imageW) / 2;
//    self.frame = CGRectMake(imageX, 0, imageW, imageH);
}

+ (instancetype)itemViewWithImage:(NSString *)imageUrlStr{
    HomeGridItemImageView *buttonImageView = [[HomeGridItemImageView alloc] initWithFrame:CGRectZero];
    buttonImageView.userInteractionEnabled = YES;
//    [button setImage:image forState:UIControlStateNormal];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
    [buttonImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
    return buttonImageView;
}
@end

@implementation HomeGridItem
+ (instancetype)itemWithImage:(NSString *)imageUrlStr{
    HomeGridItem *item = [[HomeGridItem alloc] init];
    item.imageUrlStr = imageUrlStr;
    return item;
}

@end


@implementation HeadGridView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _itemViews = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = 46;
    CGFloat height = 46;
    CGFloat spaceY =  28;
    [_itemViews enumerateObjectsUsingBlock:^(HomeGridItemImageView *itemView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 8) {
            *stop = YES;
        }
        NSInteger row = idx / 4;
        NSInteger col = idx % 4;
        itemView.frame = CGRectMake( 30 + col * width  + 24 * col, (height * row)+ (spaceY) * row, width, height);
        itemView.tag = idx + 1;
        itemView.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
        itemView.layer.masksToBounds = YES;
        itemView.layer.cornerRadius = 46/2;
        itemView.layer.borderWidth = 1;
        itemView.layer.borderColor = [UIColor clearColor].CGColor;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
        [itemView addGestureRecognizer:tap1];
    }];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    [_itemViews enumerateObjectsUsingBlock:^(HomeGridItemImageView *itemView, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemView removeFromSuperview];
    }];
    
    [items enumerateObjectsUsingBlock:^(HomeGridItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeGridItemImageView *itemView = [HomeGridItemImageView itemViewWithImage:item.imageUrlStr];
        [self addSubview:itemView];
        [_itemViews addObject:itemView];
    }];
}


- (void)btnClick:(UITapGestureRecognizer *)sender{
    
    for (int i = 0; i < _itemViews.count; i ++) {
        UIImageView *btn = _itemViews[i];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    for (int i = 0; i < _itemViews.count; i ++) {
        UIImageView *tempImageView = _itemViews[i];
        if (tempImageView.tag == sender.view.tag) {
            tempImageView.layer.borderColor = [UIColor colorWithHexString:@"308CDD"].CGColor;
            self.selectCallBack(sender.view.tag);
            break;
        }
    }

}
@end
