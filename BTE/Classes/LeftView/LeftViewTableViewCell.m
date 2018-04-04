//
//  LeftViewTableViewCell.m
//  BTE
//
//  Created by wangli on 2018/4/4.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "LeftViewTableViewCell.h"

@implementation LeftViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(26, 37, 20, 20)];
        [self.contentView addSubview:_iconImage];
        
        _subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(56, 39, 100, 17)];
        _subTitleLabel1.font = UIFontRegularOfSize(17);
        _subTitleLabel1.textColor = BHHexColor(@"ffffff");
        [self.contentView addSubview:_subTitleLabel1];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
