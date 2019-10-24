//
//  BTESortView.m
//  BTE
//
//  Created by wanmeizty on 10/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTESortView.h"
#import "FormatUtil.h"

@interface BTESortView ()
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UIImageView * upView;
@property (strong,nonatomic) UIImageView * downView;
@property (assign,nonatomic) NSTextAlignment textAlignment;
@end

@implementation BTESortView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title canSort:(BOOL)cansort position:(NSTextAlignment)textAlignment{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = textAlignment;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.nameLabel.text = title;
        self.nameLabel.textAlignment = textAlignment;
        self.nameLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
        [self addSubview:self.nameLabel];
        
        self.upView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 6, 12, 6, 5)];
        [self addSubview:self.upView];
        self.upView.image = [UIImage imageNamed:@"sort_up"];
        self.upView.hidden = YES;
        
        self.downView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 6, frame.size.height - 10 - 5, 6, 5)];
        [self addSubview:self.downView];
        self.downView.hidden = YES;
        self.downView.image = [UIImage imageNamed:@"sort_down_gray"];
        
        if (cansort) {
            
            self.upView.hidden = NO;
            self.downView.hidden = NO;
            CGFloat width = [FormatUtil getsizeWithText:title font:self.nameLabel.font height:13].width;
            if (textAlignment == NSTextAlignmentLeft) {
                self.nameLabel.frame = CGRectMake(0, 0, width, self.frame.size.height);
                self.upView.frame = CGRectMake(width + 4, 12, 6, 5);
                self.downView.frame = CGRectMake(width + 4, frame.size.height - 10 - 5, 6, 5);
                
            }else if(textAlignment == NSTextAlignmentRight){
                self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height);
            }else{
                
                self.nameLabel.frame = CGRectMake((frame.size.width - width - 10) * 0.5, 0, width, self.frame.size.height);
                self.upView.frame = CGRectMake((frame.size.width - width - 10) * 0.5 + 4, 12, 6, 5);;
                self.downView.frame = CGRectMake((frame.size.width - width - 10) * 0.5 + 4, frame.size.height - 10 - 5, 6, 5);
            }
        }else{
            self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.upView.hidden = YES;
            self.downView.hidden = YES;
        }
    }
    return self;
}

- (void)setUpTitle:(NSString *)title canSort:(BOOL)cansort position:(NSTextAlignment)textAlignment{
    if (cansort) {
        self.upView.hidden = NO;
        self.downView.hidden = NO;
        CGFloat width = [FormatUtil getsizeWithText:title font:self.nameLabel.font height:13].width;
        if (textAlignment == NSTextAlignmentLeft) {
            self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height);
            
        }else if(textAlignment == NSTextAlignmentRight){
            self.nameLabel.frame = CGRectMake((self.frame.size.width - width - 10) * 0.5, 0, width, self.frame.size.height);
            self.upView.frame = CGRectMake((self.frame.size.width - width - 10) * 0.5 + 4, 12, 6, 5);;
            self.downView.frame = CGRectMake((self.frame.size.width - width - 10) * 0.5 + 4, self.frame.size.height - 10 - 5, 6, 5);
        }else{
            self.nameLabel.frame = CGRectMake(0, 0, width, self.frame.size.height);
            self.upView.frame = CGRectMake(width + 4, 12, 6, 5);
            self.downView.frame = CGRectMake(width + 4, self.frame.size.height - 10 - 5, 6, 5);
            
        }
    }else{
        self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.upView.hidden = YES;
        self.downView.hidden = YES;
    }
}

- (void)changeStatus:(BOOL)up{
    if (up) {
        self.upView.image = [UIImage imageNamed:@"sort_up"];
        self.downView.image = [UIImage imageNamed:@"sort_down_gray"];
    }else{
        self.upView.image = [UIImage imageNamed:@"sort_up_gray"];
        self.downView.image = [UIImage imageNamed:@"sort_down"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.nameLabel.text = @"24h涨跌幅";
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.nameLabel];
        
        self.nameLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
        
        self.upView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 6, 12, 6, 5)];
        [self addSubview:self.upView];
        self.upView.image = [UIImage imageNamed:@"sort_up"];
        
        self.downView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 6, frame.size.height - 10 - 5, 6, 5)];
        [self addSubview:self.downView];
        self.downView.image = [UIImage imageNamed:@"sort_down_gray"];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title img:(NSString *)imgName{
    self.nameLabel.text = title;
    self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height);
    self.upView.hidden = NO;
    self.downView.hidden = NO;
}

- (void)setTitle:(NSString *)title{
    self.nameLabel.text = title;
    self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height);
    self.upView.hidden = NO;
    self.downView.hidden = NO;
}



- (void)sortShow:(BOOL)show{
    if (show) {
        self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height);
        self.upView.hidden = NO;
        self.downView.hidden = NO;
    }else{
        self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.upView.hidden = YES;
        self.downView.hidden = YES;
    }
    
    if (show) {
        
        self.upView.hidden = NO;
        self.downView.hidden = NO;
        CGFloat width = [FormatUtil getsizeWithText:self.nameLabel.text font:self.nameLabel.font height:13].width;
        if (self.textAlignment == NSTextAlignmentLeft) {
            self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height);
            
        }else if(self.textAlignment == NSTextAlignmentRight){
            self.nameLabel.frame = CGRectMake((self.frame.size.width - width - 10) * 0.5, 0, width, self.frame.size.height);
            self.upView.frame = CGRectMake((self.frame.size.width - width - 10) * 0.5 + 4, 12, 6, 5);;
            self.downView.frame = CGRectMake((self.frame.size.width - width - 10) * 0.5 + 4, self.frame.size.height - 10 - 5, 6, 5);
        }else{
            self.nameLabel.frame = CGRectMake(0, 0, width, self.frame.size.height);
            self.upView.frame = CGRectMake(width + 4, 12, 6, 5);
            self.downView.frame = CGRectMake(width + 4, self.frame.size.height - 10 - 5, 6, 5);
            
        }
    }else{
        self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.nameLabel.textAlignment = self.textAlignment;
        self.upView.hidden = YES;
        self.downView.hidden = YES;
    }
}

@end
