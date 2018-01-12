//
//  WLDefaultView.m
//  WangliBank
//
//  Created by xuehan on 16/6/16.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "BHNoDataTipView.h"

@interface BHNoDataTipView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation BHNoDataTipView

- (void)setImage:(UIImage *)image message:(NSString *)tipMessage{
    _imageView.image = image;
    _tipLabel.text = tipMessage;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}
- (void)setTipMessage:(NSString *)tipMessage{
    _tipMessage = tipMessage;
    _tipLabel.text = _tipMessage;
}
@end
