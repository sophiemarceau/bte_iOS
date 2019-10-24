//
//  BTEAnswerTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 30/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEAnswerTableViewCell.h"

@interface BTEAnswerTableViewCell ()
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UILabel * contentLabel;
@property (strong,nonatomic) UILabel * lastcontentLabel;
@property (strong,nonatomic) UIView * lineview;
@end

@implementation BTEAnswerTableViewCell

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
        
        self.selectionStyle = UITableViewCellEditingStyleNone;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, self.frame.size.width - 32, 12)];
        self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:1];
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 44, self.frame.size.width - 32, 41)];
        self.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
        [self.contentView addSubview:self.contentLabel];
        
        self.lastcontentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 44, self.frame.size.width - 32, 41)];
        self.lastcontentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.lastcontentLabel.numberOfLines = 0;
        self.lastcontentLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
        [self.contentView addSubview:self.lastcontentLabel];
        
        self.lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        self.lineview.backgroundColor = KBGColor;
        [self.contentView addSubview:self.lineview];
        
        
    }
    return self;
}

- (void)configWithAnswer:(CommontAndAnwerModel *)model{
    self.contentLabel.height = model.heightOfw32;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 回复 %@",model.sendUserName,model.receiveUserName];
    self.contentLabel.text = model.content;
    if ([model.read boolValue]) {
        self.contentLabel.textColor = [UIColor colorWithHexString:@"626A75"];
    }else{
        self.contentLabel.textColor = [UIColor colorWithHexString:@"FF6B28"];
    }
    
    self.lastcontentLabel.frame = CGRectMake(16, self.contentLabel.height+ 45 + 23, SCREEN_WIDTH - 32, model.lastReplyContentHeight);
    self.lastcontentLabel.text = model.lastReplyContent;
}

- (void)configWithCommontmodel:(AnswerModel *)model{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
    self.contentLabel.height = model.commontHeight;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 回复 %@",model.authorName,model.commontName];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.contentLabel.text = model.commont;
    self.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.lineview.hidden = YES;
    self.nameLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 12);
    self.contentLabel.frame = CGRectMake(10, 44, SCREEN_WIDTH - 32, 41);
}

@end
