//
//  BTECurrencyTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 11/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTECurrencyTableViewCell.h"

@interface BTECurrencyTableViewCell ()
@property (strong,nonatomic) UILabel * currencyLabel;
@end

@implementation BTECurrencyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat cellHight = [BTECurrencyTableViewCell cellHeight];
        self.currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 10, cellHight)];
        self.currencyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.currencyLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.currencyLabel];
    }
    return self;
}

- (void)configwidth:(NSString *)currency{
    self.currencyLabel.text = currency;
}

+ (CGFloat)cellHeight{
    return 44;
}

@end
