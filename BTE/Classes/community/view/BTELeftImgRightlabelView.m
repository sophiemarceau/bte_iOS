//
//  BTELeftImgRightlabelView.m
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTELeftImgRightlabelView.h"
#import "FormatUtil.h"
@interface BTELeftImgRightlabelView ()
@property (strong,nonatomic) UILabel * rightLabel;
@property (strong,nonatomic) UIImageView * imgView;
@property (strong,nonatomic) UILabel * noteLabel;
@end

@implementation BTELeftImgRightlabelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imgView =[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 16 - 40) * 0.5, (frame.size.height - 16) * 0.5, 16, 16)];
        [self addSubview:self.imgView];
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 16 - 40) * 0.5 + 16, 0, 40, frame.size.height)];
        self.rightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.rightLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        [self addSubview:self.rightLabel];
        
        self.noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.rightLabel.right + 5, 8, 40, 10)];
        self.noteLabel.textColor = [UIColor redColor];
        self.noteLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
        [self addSubview:self.noteLabel];
        
        
    }
    return self;
}

- (void)setBadgeString:(NSString *)number{
    
    NSString * rightText = self.rightLabel.text;
    CGSize size = [rightText getSizeOfString:self.rightLabel.font constroSize:CGSizeMake(CGFLOAT_MAX, self.rightLabel.height)];
    self.noteLabel.frame = CGRectMake((self.frame.size.width - 16 - 40) * 0.5 + 16 + size.width + 5, 8, 30, 10);
    self.noteLabel.text = number;
    
}

- (void)setUpImg:(NSString *)imgName title:(NSString *)title{
    
    self.imgView.image = [UIImage imageNamed:imgName];
    self.rightLabel.text = title;
}

- (NSString *)getTextstring{
    NSString *text= [self.rightLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return text;
}

@end
