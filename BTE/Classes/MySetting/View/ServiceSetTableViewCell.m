//
//  ServiceSetTableViewCell.m
//  BTE
//
//  Created by sophie on 2018/10/12.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "ServiceSetTableViewCell.h"

@implementation ServiceSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BHHexColor(@"FAFAFA");
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self.serviceSwitch setOn:YES animated:YES];
    [self.contentView addSubview:self.serviceSwitch];
    [self.contentView addSubview:self.titleLabel];
}

//// OC实现方法: 重写Cell的layoutSubViews方法
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    for (UIView *subview in self.contentView.superview.subviews) {
//        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
//            subview.hidden = NO;
//            CGRect frame = subview.frame;
//            frame.origin.x += self.separatorInset.left;
//            frame.size.width -= self.separatorInset.right;
//            subview.frame =frame;
//        }
//    }
//}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH/2, 44)];
        _titleLabel.font = UIFontRegularOfSize(SCALE_W(16));
        _titleLabel.textColor = BHHexColor(@"626A75");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UISwitch *)serviceSwitch{
    if (_serviceSwitch == nil) {
        _serviceSwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -16-32 ,12  ,32 ,20)];
        _serviceSwitch.frame = CGRectMake(SCREEN_WIDTH - 16 -_serviceSwitch.size.width , (44 - _serviceSwitch.size.height)/2, _serviceSwitch.size.width, _serviceSwitch.size.height);
    }
    return _serviceSwitch;
}

@end
