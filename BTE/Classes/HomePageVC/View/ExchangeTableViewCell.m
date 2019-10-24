//
//  ExchangeTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 2018/6/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ExchangeTableViewCell.h"

@interface ExchangeTableViewCell ()
@property (nonatomic,strong) UILabel * nameLabel,*descLabel;
@end

@implementation ExchangeTableViewCell

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
        
        self.backgroundColor = [UIColor colorWithHexString:@"308cdd"];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone]; 
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 13, self.frame.size.width - 4, 10)];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        [self.contentView addSubview:self.nameLabel];
        
        self.descLabel  = [[UILabel alloc] initWithFrame:CGRectMake(4, 24, self.frame.size.width - 4, 12)];
        self.descLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        self.descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self.contentView addSubview:self.descLabel];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, self.frame.size.width, 0.5)];
        lineView.backgroundColor = KBGColor;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)configwidth:(NSDictionary *)dict{
    self.nameLabel.text = [NSString stringWithFormat:@"%@/%@",[dict objectForKey:@"baseAsset"],[dict objectForKey:@"quoteAsset"]];
    self.descLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"exchange"]];
}

- (void)configwidthModel:(ExchangeModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.exchange];
    self.descLabel.text = [NSString stringWithFormat:@"%@",model.name];
}

- (void)configCommonKlinewidthModel:(ExchangeModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.exchange];
    self.descLabel.text = [NSString stringWithFormat:@"%@/%@",model.baseAsset,model.quoteAsset];
    
}

- (void)configwidthModel:(ExchangeModel *)model width:(CGFloat)width{
    self.descLabel.frame = CGRectMake(width - 96, 0, 80, self.frame.size.height);
    [self configwidthModel:model];
}
@end
