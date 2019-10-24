//
//  StrageyHeaderView.m
//  BTE
//
//  Created by sophie on 2018/10/9.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "StrageyHeaderView.h"
@interface StrageyHeaderView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *cellbgView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end
@implementation StrageyHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
//        KBGColor;
        // 设置子视图
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews{
    self.cellbgView = [UIView new];
    self.cellbgView.backgroundColor = KBGColor;
    [self.contentView addSubview:self.cellbgView];
    
    self.bgView = [UIView new];
    [self.cellbgView addSubview:self.bgView];
    self.bgView.backgroundColor = BHHexColor(@"FAFAFA");
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.bgView addSubview:titleLabel];
    _titleLabel = titleLabel;
    titleLabel.font = UIFontRegularOfSize(16);
    titleLabel.textColor = BHHexColor(@"626A75");
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    [self.bgView addSubview:descriptionLabel];
    _descriptionLabel = descriptionLabel;
    descriptionLabel.font = UIFontRegularOfSize(14);
    descriptionLabel.textColor = BHHexColor(@"626A75");

    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"centerArrow"]];
    [self.bgView addSubview:self.arrowImageView];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setDescriptionText:(NSString *)descriptionText{
    _descriptionText = descriptionText;
    _descriptionLabel.text = descriptionText;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize cellSize = self.bounds.size;
    self.cellbgView.frame = CGRectMake(0, 0, cellSize.width, cellSize.height);
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(16, (44 - _titleLabel.bounds.size.height)/2.0, _titleLabel.bounds.size.width, _titleLabel.bounds.size.height);
    
    [_descriptionLabel sizeToFit];
    _descriptionLabel.frame = CGRectMake(SCREEN_WIDTH - _descriptionLabel.bounds.size.width - 16 -8 -10, (44 - _descriptionLabel.bounds.size.height)/2.0, _descriptionLabel.bounds.size.width, _descriptionLabel.bounds.size.height);
    
    self.arrowImageView.frame =CGRectMake(SCREEN_WIDTH -8 -16, 16, 8, 14);
}


@end
