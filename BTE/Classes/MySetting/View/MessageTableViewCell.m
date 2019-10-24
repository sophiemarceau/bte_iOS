//
//  MessageTableViewCell.m
//  BTE
//
//  Created by sophie on 2018/10/19.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = KBGColor;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.blueImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.arrowImageView];
    [self.bgView addSubview:self.dateLabel];
    [self.bgView addSubview:self.desLabel];
}


-(void)setNormalTableItem:(MessageItem *)tableViewItem{
     NSString *urlStr =  stringFormat(tableViewItem.redirectUrl);
    NSLog(@"urlStr----->%@",urlStr);
    
    self.titleLabel.text = tableViewItem.title;
    self.dateLabel.text = tableViewItem.createTime;
    
    
    if (tableViewItem.isShow) {
        self.desLabel.numberOfLines = 0;
        if([tableViewItem heightForString:tableViewItem.content fontSize:14 andWidth:SCREEN_WIDTH-32] > 47){
            self.desLabel.frame =CGRectMake(16, 62, SCREEN_WIDTH-32,  [tableViewItem heightForString:tableViewItem.content fontSize:14 andWidth:SCREEN_WIDTH-32] );
             self.bgView.frame =CGRectMake(0, 6, SCREEN_WIDTH,  self.desLabel.bottom  +12 );
        }else{
            self.desLabel.numberOfLines = 2;
            self.desLabel.frame = CGRectMake(16, 62, SCREEN_WIDTH-32, 47);
            self.bgView.frame = CGRectMake(0, 6, SCREEN_WIDTH, 121);
        }
    }else{
        self.desLabel.numberOfLines = 2;
        self.desLabel.frame = CGRectMake(16, 62, SCREEN_WIDTH-32, 47);
        self.bgView.frame = CGRectMake(0, 6, SCREEN_WIDTH, 121);
    }
    self.desLabel.text = tableViewItem.summary;
    
    if ([urlStr isEqualToString:@""]) {
        self.arrowImageView.hidden = YES;
    }else{
        self.arrowImageView.hidden = NO;
    }
}

-(UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.frame = CGRectMake(0, 6, SCREEN_WIDTH, 121);
        _bgView.backgroundColor = BHHexColor(@"FAFAFA");
    }
    return _bgView;
}

-(UIImageView *)blueImageView{
    if (_blueImageView == nil) {
        _blueImageView = [UIImageView new];
        _blueImageView.backgroundColor=  BHHexColor(@"44A0F1");
        _blueImageView.frame = CGRectMake(0, 0, 3, 13);
    }
    return _blueImageView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"centerArrow"];
        _arrowImageView.frame =CGRectMake(SCREEN_WIDTH -8 -16, 16, 8, 14);
    }
    return _arrowImageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH-23-10, 16)];
        _titleLabel.font = UIFontMediumOfSize(SCALE_W(16));
        _titleLabel.textColor = BHHexColor(@"626A75");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UILabel *)dateLabel{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH-23-10, 12)];
        _dateLabel.font = UIFontLightOfSize(SCALE_W(12));
        _dateLabel.textColor = BHHexColor(@"979DA5");
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}

-(UILabel *)desLabel{
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 62, SCREEN_WIDTH-32, 47)];
        _desLabel.font = UIFontRegularOfSize(SCALE_W(14));
        _desLabel.textColor = BHHexColor(@"626A75");
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.numberOfLines = 0;
//        _desLabel.adjustsFontSizeToFitWidth = YES;
//        _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _desLabel;
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}
@end
