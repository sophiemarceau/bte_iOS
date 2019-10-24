//
//  BTECommontTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTECommontTableViewCell.h"
#import "BTELeftImgRightlabelView.h"

@interface BTECommontTableViewCell ()
@property (strong,nonatomic) UILabel * commontLabel;
@property (strong,nonatomic) UIView * itembgView;
@property (strong,nonatomic) UIView * lineView;

@end

@implementation BTECommontTableViewCell

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
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        lineView.backgroundColor = KBGColor;
        [self.contentView addSubview:lineView];
        
        self.commontLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, SCREEN_WIDTH - 32, 100)];
        self.commontLabel.numberOfLines = 3;
        self.commontLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.commontLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:1];
        [self.contentView addSubview:self.commontLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
        self.lineView.backgroundColor = KBGColor;
        [self.contentView addSubview:self.lineView];
        
        self.itembgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 40)];
        [self.contentView addSubview:self.itembgView];
        
        BTELeftImgRightlabelView * shareBtn = [[BTELeftImgRightlabelView alloc] initWithFrame:CGRectMake(36, 0, 60, 40)];
        [shareBtn setUpImg:@"community_share" title:@" 分享"];
        shareBtn.tag = 1000;
        [shareBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.itembgView addSubview:shareBtn];
        
        
        BTELeftImgRightlabelView * commontBtn = [[BTELeftImgRightlabelView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) * 0.5, 0, 60, 40)];
        commontBtn.tag = 1001;
        [commontBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [commontBtn setUpImg:@"community_comment" title:@" 评论"];
        [self.itembgView addSubview:commontBtn];
        
        BTELeftImgRightlabelView * priaseBtn = [[BTELeftImgRightlabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 36 - 60, 0, 60, 40)];
        priaseBtn.tag = 1002;
        [priaseBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [priaseBtn setUpImg:@"community_priase" title:@" 点赞"];
        [self.itembgView addSubview:priaseBtn];
    }
    return self;
}

- (void)likeAdd:(NSString *)praiseNum{
    
}

- (void)click:(BTELeftImgRightlabelView *)btn{
    if (btn.tag == 1002 && !btn.selected && User.isLogin) {
        BTELeftImgRightlabelView * priaseBtn = [self.itembgView viewWithTag:1002];
        NSString * praiseNum = @" 1";
        NSString * text = [priaseBtn getTextstring];
        if (![text isEqualToString:@" 点赞"]) {
            praiseNum = [NSString stringWithFormat:@" %ld",[text integerValue] + 1];
        }
        [priaseBtn setUpImg:@"community_priaseed" title:praiseNum];
        btn.selected = YES;
    }
    
    if (self.btnClick) {
        self.btnClick(btn.tag - 1000);
    }
    
}

- (void)configNoReadwithModel:(BTECommontModel *)model{
    self.commontLabel.text = model.content;
    self.commontLabel.height = model.heigth;
    
    self.lineView.y = model.heigth + 29;
    
    self.itembgView.y = model.heigth + 30;
    
    BTELeftImgRightlabelView * shareBtn = [self.itembgView viewWithTag:1000];
    if ([model.shareCount integerValue] > 0) {
        [shareBtn setUpImg:@"community_share" title:[NSString stringWithFormat:@" %@",model.shareCount]];
    }else{
        [shareBtn setUpImg:@"community_share" title:@" 分享"];
    }
    
    
    BTELeftImgRightlabelView * commontBtn = [self.itembgView viewWithTag:1001];
    if ([model.commentCount integerValue] > 0) {
        [commontBtn setUpImg:@"community_comment" title:[NSString stringWithFormat:@" %@",model.commentCount]];
    }else{
        [commontBtn setUpImg:@"community_comment" title:@" 评论"];
    }
    
    
    BTELeftImgRightlabelView * priaseBtn = [self.itembgView viewWithTag:1002];
    if ([model.hasLike boolValue]) {
        priaseBtn.selected = YES;
        [priaseBtn setUpImg:@"community_priaseed" title:[NSString stringWithFormat:@" %@",model.likeCount]];
    }else{
        priaseBtn.selected = NO;
        if ([model.likeCount integerValue] > 0) {
            [priaseBtn setUpImg:@"community_priase" title:[NSString stringWithFormat:@" %@",model.likeCount]];
        }else{
            [priaseBtn setUpImg:@"community_priase" title:@" 点赞"];
        }
    }
    
}

- (void)configwithModel:(BTECommontModel *)model{
    self.commontLabel.text = model.content;
    self.commontLabel.height = model.heigth;
    
    self.lineView.y = model.heigth + 29;
    
    self.itembgView.y = model.heigth + 30;
    
    BTELeftImgRightlabelView * shareBtn = [self.itembgView viewWithTag:1000];
    if ([model.shareCount integerValue] > 0) {
        [shareBtn setUpImg:@"community_share" title:[NSString stringWithFormat:@" %@",model.shareCount]];
    }else{
        [shareBtn setUpImg:@"community_share" title:@" 分享"];
    }
    if ([model.newshare integerValue] > 0) {
        [shareBtn setBadgeString:[NSString stringWithFormat:@"+%@",model.newshare]];
    }else{
        [shareBtn setBadgeString:@""];
    }
    
    BTELeftImgRightlabelView * commontBtn = [self.itembgView viewWithTag:1001];
    if ([model.commentCount integerValue] > 0) {
        [commontBtn setUpImg:@"community_comment" title:[NSString stringWithFormat:@" %@",model.commentCount]];
    }else{
        [commontBtn setUpImg:@"community_comment" title:@" 评论"];
    }
    if ([model.newcomment integerValue] > 0) {
        [commontBtn setBadgeString:[NSString stringWithFormat:@"+%@",model.newcomment]];
    }else{
        [commontBtn setBadgeString:@""];
    }
    
    BTELeftImgRightlabelView * priaseBtn = [self.itembgView viewWithTag:1002];
    if ([model.hasLike boolValue]) {
        priaseBtn.selected = YES;
        [priaseBtn setUpImg:@"community_priaseed" title:[NSString stringWithFormat:@" %@",model.likeCount]];
    }else{
        priaseBtn.selected = NO;
        if ([model.likeCount integerValue] > 0) {
            [priaseBtn setUpImg:@"community_priase" title:[NSString stringWithFormat:@" %@",model.likeCount]];
        }else{
            [priaseBtn setUpImg:@"community_priase" title:@" 点赞"];
        }
    }
    
    if ([model.newlike integerValue] > 0) {
        [priaseBtn setBadgeString:[NSString stringWithFormat:@"+%@",model.newlike]];
    }else{
        [priaseBtn setBadgeString:@""];
    }
}

@end
