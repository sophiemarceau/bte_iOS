//
//  ZTYExchangeTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 14/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYExchangeTableViewCell.h"
#import "FormatUtil.h"

@interface ZTYExchangeTableViewCell()

@property (strong,nonatomic) UIImageView * iconView;
@property (strong,nonatomic) UILabel * exchangeLabel;
@property (strong,nonatomic) UILabel * moneyLabel;
@property (strong,nonatomic) UILabel * flowLabel;
@property (strong,nonatomic) UILabel * airLabel;

@end

@implementation ZTYExchangeTableViewCell

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
        CGFloat cellHeight = [ZTYExchangeTableViewCell cellHeigth];
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, (cellHeight - 22) * 0.5, 22, 22)];
        [self.contentView addSubview:self.iconView];
        
        
        
        CGFloat width = (SCREEN_WIDTH - 32)/4.0;
        
        self.exchangeLabel  =[self createLabelTitle:@"0.24" frame:CGRectMake(46, 0, 50, cellHeight)];
        self.exchangeLabel.textAlignment = NSTextAlignmentLeft;
        self.exchangeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [self.contentView addSubview:self.exchangeLabel];
        
        self.moneyLabel = [self createLabelTitle:@"0.24" frame:CGRectMake(16+width, 0, width, cellHeight)];
        [self.contentView addSubview:self.moneyLabel];
        
        self.flowLabel = [self createLabelTitle:@"0.24" frame:CGRectMake(16+width * 2, 0, width, cellHeight)];
        [self.contentView addSubview:self.flowLabel];
        
        self.airLabel = [self createLabelTitle:@"0.24" frame:CGRectMake(16+width * 3, 0, width, cellHeight)];
        [self.contentView addSubview:self.airLabel];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5EE"];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (UILabel *)createLabelTitle:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    label.font =  [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    return label;
}

-(void)configwithDict:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@""]];
    self.exchangeLabel.text = [dict objectForKey:@"name"];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[FormatUtil formatprice:[[dict objectForKey:@"amount"] doubleValue]]];//[NSString stringWithFormat:@"%@",[dict objectForKey:@"amount"]];
    
    
    self.airLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"airIndex"]];
    
    
    self.flowLabel.text = [NSString stringWithFormat:@"%@",[FormatUtil formatCount:[[dict objectForKey:@"netAmount"] doubleValue]]];
    if ([[dict objectForKey:@"netAmount"] doubleValue] > 0 ) {
        self.flowLabel.textColor = [UIColor colorWithHexString:@"228B22"];
    }else{
        self.flowLabel.textColor = [UIColor colorWithHexString:@"FF4040"];
        
    }
}
+ (CGFloat)cellHeigth{
    return 54;
}

@end
