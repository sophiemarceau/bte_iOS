//
//  CommontAndAnswerTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 30/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "CommontAndAnswerTableViewCell.h"

@interface CommontAndAnswerTableViewCell ()
@property (strong,nonatomic) UIImageView * iconView;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UILabel * commontLabel;
@property (copy,nonatomic) CommontAndAnwerModel * currentModel;
@end

@implementation CommontAndAnswerTableViewCell

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
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 35, 35)];
        [self.contentView addSubview:self.iconView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 21, SCREEN_WIDTH - 61 - 16, 14)];
        self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.nameLabel.textColor = backBlue;
        [self.contentView addSubview:self.nameLabel];
        
        self.commontLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 45, SCREEN_WIDTH - 16 - 61, 42)];
        self.commontLabel.numberOfLines = 0;
        self.commontLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self.contentView addSubview:self.commontLabel];
        
        self.lookReplyBtn.hidden = YES;
        [self.contentView addSubview:self.lookReplyBtn];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineBGColor;//KBGColor;
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

- (UIButton*)lookReplyBtn{
    if (!_lookReplyBtn) {
        _lookReplyBtn = [[UIButton alloc] initWithFrame:CGRectMake(61, 93, SCREEN_WIDTH - 61 - 16, 32)];
        [_lookReplyBtn setImage:[UIImage imageNamed:@"bte_arrow_right"] forState:UIControlStateNormal];
        int count = random() % 300;
        _lookReplyBtn.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
        [_lookReplyBtn setTitle:[NSString stringWithFormat:@"查看全部%d多条回复",count] forState:UIControlStateNormal];
        [_lookReplyBtn setTitleColor:[UIColor colorWithHexString:@"308CDD"] forState:UIControlStateNormal];
        _lookReplyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _lookReplyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_lookReplyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_lookReplyBtn.imageView.size.width + 10, 0, _lookReplyBtn.imageView.size.width - 10)];
        [_lookReplyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _lookReplyBtn.titleLabel.bounds.size.width + 15, 0, -_lookReplyBtn.titleLabel.bounds.size.width)];
        _lookReplyBtn.layer.cornerRadius = 5;
        _lookReplyBtn.layer.masksToBounds = YES;
    }
    return _lookReplyBtn;
}

- (void)configwithModel:(CommontAndAnwerModel *)model readShow:(BOOL)show{
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"community_headlog"]];
    self.nameLabel.text = model.userName;
    self.commontLabel.text = model.content;
    self.commontLabel.height = model.height;
    if (model.postReplyItemList.count > 0) {
        self.lookReplyBtn.hidden = NO;
        NSString * title = [NSString stringWithFormat:@"查看全部回复%ld条",model.postReplyItemList.count];
        [_lookReplyBtn setTitle:title forState:UIControlStateNormal];
        [_lookReplyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_lookReplyBtn.imageView.size.width + 10, 0, _lookReplyBtn.imageView.size.width - 10)];
        [_lookReplyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _lookReplyBtn.titleLabel.bounds.size.width + 15, 0, -_lookReplyBtn.titleLabel.bounds.size.width)];
        
        _lookReplyBtn.y = model.height + 45 + 6;
        
    }else{
        self.lookReplyBtn.hidden = YES;
    }
    
    if (show) {
        if (![model.read boolValue]) {
            self.commontLabel.textColor = [UIColor colorWithHexString:@"FF6B28"];
        }else{
            self.commontLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        }
    }
}

- (void)configwithModel:(CommontAndAnwerModel *)model{
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"community_headlog"]];
    self.nameLabel.text = model.userName;
    self.commontLabel.text = model.content;
    self.commontLabel.height = model.height;
    if (model.postReplyItemList.count > 0) {
        self.lookReplyBtn.hidden = NO;
        NSString * title = [NSString stringWithFormat:@"查看全部回复%ld条",model.postReplyItemList.count];
        [_lookReplyBtn setTitle:title forState:UIControlStateNormal];
        [_lookReplyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_lookReplyBtn.imageView.size.width + 10, 0, _lookReplyBtn.imageView.size.width - 10)];
        [_lookReplyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _lookReplyBtn.titleLabel.bounds.size.width + 15, 0, -_lookReplyBtn.titleLabel.bounds.size.width)];
        
        _lookReplyBtn.y = model.height + 45 + 6;
        
    }else{
        self.lookReplyBtn.hidden = YES;
    }
}

- (void)configwithCommontAndAnswerModel:(CommontAndAnwerModel *)model{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"community_headlog"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 回复 %@",model.sendUserName,model.receiveUserName];
    self.commontLabel.text = model.content;
    self.commontLabel.height = model.height;
    self.contentView.backgroundColor = KBGColor;
}

- (void)configwithCommontAndAnswerModel:(CommontAndAnwerModel *)model isRead:(BOOL)isread{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"community_headlog"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 回复 %@",model.sendUserName,model.receiveUserName];
    self.commontLabel.text = model.content;
    self.commontLabel.height = model.height;
    self.contentView.backgroundColor = KBGColor;
    
    if (isread) {
        if ([model.read boolValue]) {
            self.commontLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        }else{
            self.commontLabel.textColor = [UIColor colorWithHexString:@"FF6B28"];
        }
    }
}
@end
