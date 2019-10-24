//
//  YUCustomHeaderView.m
//  YUFoldingTableViewDemo
//
//  Created by caiyi on 2018/2/6.
//  Copyright © 2018年 timelywind. All rights reserved.
//

#import "YUCustomHeaderView.h"


@interface YUCustomHeaderView ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *descriptionLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation YUCustomHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = KBGColor;
        // 设置子视图
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews{
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    titleLabel.textColor = BHHexColor(@"626A75");
    titleLabel.font = UIFontRegularOfSize(16);
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descriptionLabel];
    _descriptionLabel = descriptionLabel;
    descriptionLabel.font = UIFontRegularOfSize(14);
    descriptionLabel.textColor = BHHexColor(@"626A75");
    self.contentView.backgroundColor = BHHexColor(@"FAFAFA");
    
    
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"centerArrow"]];
    [self.contentView addSubview:self.arrowImageView];

    self.lineView = [[UIView alloc] init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = BHHexColor(@"E6EBF0");
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
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(16, (44 - _titleLabel.bounds.size.height)/2.0, _titleLabel.bounds.size.width, _titleLabel.bounds.size.height);
    
    [_descriptionLabel sizeToFit];
    _descriptionLabel.frame = CGRectMake(SCREEN_WIDTH - _descriptionLabel.bounds.size.width - 16 -8 -10, (44 - _descriptionLabel.bounds.size.height)/2.0, _descriptionLabel.bounds.size.width, _descriptionLabel.bounds.size.height);
    
    self.arrowImageView.frame =CGRectMake(SCREEN_WIDTH -8 -16, 16, 8, 14);
    
    self.lineView.frame =CGRectMake(16, cellSize.height -1 , SCREEN_WIDTH, 0.5);
}


@end
