//
//  BigOrderTradeTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 5/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BigOrderTradeTableViewCell.h"
#import "FormatUtil.h"
@interface BigOrderTradeTableViewCell ()
@property (strong,nonatomic) UILabel * sellCLabel;
@property (strong,nonatomic) UILabel * buyCLabel;
@property (strong,nonatomic) UILabel * priceLabel;
@property (strong,nonatomic) UIView * sellView;
@property (strong,nonatomic) UIView * buyView;
@property (assign,nonatomic) CGFloat priceWidth;
@end

@implementation BigOrderTradeTableViewCell

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
        [self createUI];
        self.selectionStyle = UITableViewCellEditingStyleNone;
    }
    return self;
}

- (void)createUI{
    CGFloat height = [BigOrderTradeTableViewCell cellHeight];
    CGFloat priceW = 100;
    self.sellCLabel = [self createLabelTitle:@"6800" frame:CGRectMake(16, 16, 130, 12)];
    [self.contentView addSubview:self.sellCLabel];
    
    self.buyCLabel = [self createLabelTitle:@"6800" frame:CGRectMake(SCREEN_WIDTH - 130 - 16, 16, 130, 12)];
    self.buyCLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.buyCLabel];
    
    self.priceLabel = [self createLabelTitle:@"6800" frame:CGRectMake(SCREEN_WIDTH*0.5 - priceW * 0.5, 0, priceW, 16)];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.priceLabel];
    
    self.sellView = [[UIView alloc] initWithFrame:CGRectMake(7, 16, SCREEN_WIDTH * 0.5 - (7 + 7  + priceW * 0.5 ), 12)];
    self.sellView.backgroundColor = [UIColor colorWithHexString:@"FF4040"];
    self.sellView.alpha = 0.2;
    [self.contentView addSubview:self.sellView];
   
    self.buyView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 +priceW * 0.5 + 7, 10, SCREEN_WIDTH * 0.5 - (16 + 7 + priceW + priceW * 0.5 + 7), 8)];
    self.buyView.backgroundColor = [UIColor colorWithHexString:@"228B22"];
    self.buyView.alpha = 0.2;
    [self.contentView addSubview:self.buyView];
}
                      
- (UILabel *)createLabelTitle:(NSString *)title frame:(CGRect)frame{
  UILabel *label = [[UILabel alloc] init];
  label.frame = frame;
  label.text = title;
  label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
  label.textColor = [UIColor colorWithHexString:@"525866" alpha:1];
  return label;
}

- (void)configWithDict:(NSDictionary *)dict{
    // bidAmount 买  askAmount 卖
    self.buyCLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bidAmount"]];
    self.sellCLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"askAmount"]];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"price"] doubleValue]];
    
}

- (void)configWithDict:(NSDictionary *)dict maxCount:(NSInteger)maxCount{
    
    self.buyCLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bidAmount"]];
    self.sellCLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"askAmount"]];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",@([[dict objectForKey:@"price"] doubleValue])];
    
    CGFloat priceW = 30;
    CGFloat viewWidth = (SCREEN_WIDTH * 0.5 - (7 + 7  + priceW * 0.5 ));
    // bidAmount 买  askAmount 卖
    NSInteger bidAmount = [[dict objectForKey:@"bidAmount"] integerValue];
    self.buyView.frame = CGRectMake(SCREEN_WIDTH * 0.5 +priceW * 0.5 + 7, 16, bidAmount/ (maxCount * 1.0) * viewWidth, 12);
    
    NSInteger askAmount = [[dict objectForKey:@"askAmount"] integerValue];
    CGFloat sellviewW = askAmount/ (maxCount * 1.0) * viewWidth;
    self.sellView.frame = CGRectMake(7, 16, sellviewW, 12);
    
}

- (void)configWithDict:(NSDictionary *)dict maxCount:(NSInteger)maxCount isLast:(BOOL)isLast{
    
    // bidAmount 买  askAmount 卖
    double bidAmount = [[dict objectForKey:@"bidAmount"] doubleValue];
    
    double askAmount = [[dict objectForKey:@"askAmount"] doubleValue];
    
    self.buyCLabel.text = [NSString stringWithFormat:@"%@",[FormatUtil formatCount:bidAmount]];
    self.sellCLabel.text = [NSString stringWithFormat:@"%@",[FormatUtil formatCount:askAmount]];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",[FormatUtil formatprice:[[dict objectForKey:@"price"] doubleValue]]];
    
    CGFloat viewWidth = (SCREEN_WIDTH * 0.5 - 7);
    
    self.buyView.frame = CGRectMake(SCREEN_WIDTH * 0.5, 16, bidAmount/ (maxCount * 1.0) * viewWidth, 12);
    
    
    CGFloat sellviewW = askAmount/ (maxCount * 1.0) * viewWidth;
    self.sellView.frame = CGRectMake(SCREEN_WIDTH * 0.5 -sellviewW, 16, sellviewW, 12);
    if (isLast) {
        self.sellView.frame = CGRectZero;
        self.buyView.frame = CGRectZero;
        self.buyCLabel.frame = CGRectZero;
        self.sellCLabel.frame = CGRectZero;
    }
    
}

+ (CGFloat)cellHeight{
    return 28;
}
@end
