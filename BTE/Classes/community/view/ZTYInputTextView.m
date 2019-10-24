//
//  ZTYInputTextView.m
//  BTE
//
//  Created by wanmeizty on 5/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYInputTextView.h"
#define DefautHeight 30
@interface ZTYInputTextView ()<UITextViewDelegate>
{
    int count;
}
@property (strong,nonatomic) UITextView * textView;
@property (assign,nonatomic) CGFloat keyboardHeight;
@property (strong,nonatomic) UILabel * placeLabel;
@property (assign,nonatomic) CGFloat tmpHeight;
@end

@implementation ZTYInputTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"DBDEE2"];
        self.textView =[[UITextView alloc]init];
        self.textView.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.textView.layer.cornerRadius=5;
        self.textView.layer.masksToBounds=YES;
        self.textView.layer.borderWidth=1;
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.textView.delegate=self;
//        self.textView.textColor=[UIColor colorWithHexString:@"626A75" alpha:1];
        self.textView.frame=CGRectMake(16, (self.frame.size.height - DefautHeight) * 0.5, SCREEN_WIDTH-32, DefautHeight);
        [self addSubview:self.textView];
        
//        _textView.returnKeyType = UIReturnKeySend;
//        _textView.layer.masksToBounds = YES;
//        _textView.layer.cornerRadius = 5;
//        _textView.delegate = self;
//        _textView.font = [UIFont systemFontOfSize:18];
//        _textView.layer.borderColor = [[UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1]CGColor];
//        _textView.layer.borderWidth = 1;
//        [self addSubview:_textView];
        
        UILabel * placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 21, SCREEN_WIDTH - 56, 14)];
        placeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        placeLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
        placeLabel.text =  @"回复评论";
        self.placeLabel = placeLabel;
        [self addSubview:placeLabel];
        
        //监听弹出键盘
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setPlaceholderstr:(NSString *)placeholder{
    _placeLabel.text = placeholder;
}

- (void)hiddenKeyboard{
    [self.textView resignFirstResponder];
}

- (void)beginEidt{
    [self.textView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下
        
        if(self.finishBlock){
            
        }
        self.finishBlock(textView.text);
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if(textView.text.length < 1){
        self.placeLabel.hidden = NO;
    }else{
        self.placeLabel.hidden = YES;
    }
    if (self.beginBlock) {
        self.beginBlock();
    }
}

-(void)keyboardChanged:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    CGRect frame=[notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect currentFrame=self.frame;
    
    [UIView animateWithDuration:0.25 animations:^{
        //输入框最终的位置
        CGRect resultFrame;
        
        if (frame.origin.y==SCREEN_HEIGHT) {
            resultFrame=CGRectMake(currentFrame.origin.x, SCREEN_HEIGHT-56 - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT, currentFrame.size.width, currentFrame.size.height);
            self.textView.frame=CGRectMake(16, (56 - DefautHeight) * 0.5, SCREEN_WIDTH-32, DefautHeight);
            self.textView.text = @"";
            self.keyboardHeight= 0;
            self.placeLabel.hidden = NO;
        }else{
            resultFrame=CGRectMake(currentFrame.origin.x,SCREEN_HEIGHT-currentFrame.size.height-frame.size.height - NAVIGATION_HEIGHT , currentFrame.size.width, currentFrame.size.height);
                self.keyboardHeight=frame.size.height;
                self.placeLabel.hidden = YES;
        }
        self.frame=resultFrame;
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    self.placeLabel.hidden = YES;
    CGSize contentSize = textView.contentSize;
    
    if (contentSize.height > self.tmpHeight && self.tmpHeight != 0) {
        count = contentSize.height - self.tmpHeight;
        if (self.frame.size.height < 150) {
            [_textView scrollRangeToVisible:NSMakeRange(0, 0)];
            [self animationWithDisplace:count];
        }
        
    } else if (contentSize.height < self.tmpHeight && self.tmpHeight != 0) {
        count = _textView.contentSize.height - _textView.frame.size.height;
        if (_textView.contentSize.height <= _textView.frame.size.height ) {
            [self animationWithDisplace:count];
        }
    }
    self.tmpHeight = contentSize.height;
}

- (void)animationWithDisplace:(CGFloat)displace{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.frame;
        //inputViewFame
        rect.origin.y -= displace;
        rect.size.height += displace;
        self.frame = rect;
        
        //textView frame
        rect = _textView.frame;
        rect.size.height += displace;
        _textView.frame = rect;
    }];
}

- (BOOL)isEdit{
    return self.textView.isFirstResponder;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
