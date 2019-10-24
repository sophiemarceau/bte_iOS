//
//  BTEWalletTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 28/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEWalletTableViewCell.h"
#import "FormatUtil.h"
@interface BTEWalletTableViewCell ()
@property (strong,nonatomic) UILabel * dateLabel;
@property (strong,nonatomic) UILabel * walletName;
@property (strong,nonatomic) UILabel * countLabel;
@end
@implementation BTEWalletTableViewCell

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
        CGFloat cellheight = [BTEWalletTableViewCell cellHeight];
        self.dateLabel = [self createLabel:CGRectMake(16, 0, 80, cellheight)];
        self.dateLabel.textColor  =[UIColor colorWithHexString:@"525866" alpha:0.6];
        [self.contentView addSubview:self.dateLabel];
        
        self.walletName = [self createLabel:CGRectMake(96, 0, SCREEN_WIDTH - 2 * 96, cellheight)];
        self.walletName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.walletName];
        
        self.countLabel = [self createLabel:CGRectMake(SCREEN_WIDTH - 16 - 80, 0, 80, cellheight)];
        self.countLabel.textColor = [UIColor colorWithHexString:@"FF4040" alpha:1];
        self.countLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.countLabel];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellheight - 0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5EE"];
        [self.contentView addSubview:lineView];
    }
    return self;
}

+ (CGFloat )cellHeight{
    return 42;
}
- (void)configDict:(NSDictionary *)dict{
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"MM-dd HH:mm"];
//    NSInteger timeval = [[dict objectForKey:@"datetime"] integerValue] / 1000;
//    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeval];
    NSString *date = [dict objectForKey:@"date"];//[formatter stringFromDate:confromTimesp];
    NSString * month = [date substringWithRange:NSMakeRange(5, 2)];
    NSString * day = [date substringWithRange:NSMakeRange(8, 2)];
    NSString * time = [date substringWithRange:NSMakeRange(11, 5)];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@\n%d/%d",time,month.intValue,day.intValue];
    self.dateLabel.numberOfLines = 2;
    
    self.walletName.text = [dict objectForKey:@"type"];
    
    
    
    if ([[dict objectForKey:@"amount"] doubleValue] > 0) {
        self.countLabel.textColor = RoseColor;
        self.countLabel.text = [NSString stringWithFormat:@"+%ld",[[dict objectForKey:@"amount"] integerValue]];
    }else{
        self.countLabel.textColor = DropColor;
        self.countLabel.text = [NSString stringWithFormat:@"%ld",[[dict objectForKey:@"amount"] integerValue]];
    }
}

- (UILabel *)createLabel:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"800";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    return label;
}

@end
