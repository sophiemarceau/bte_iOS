//
//  AnswerModel.m
//  BTE
//
//  Created by wanmeizty on 30/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "AnswerModel.h"
#import "FormatUtil.h"

@implementation AnswerModel
- (void)setCommont:(NSString *)commont{
    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    CGSize sizeToFit = [FormatUtil getsizeWithText:commont font:font width:(SCREEN_WIDTH - 32)];
    self.heigth = sizeToFit.height;
    UIFont * cfont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    CGSize size = [FormatUtil getsizeWithText:commont font:cfont width:(SCREEN_WIDTH - 61 - 16 - 20)];
    self.commontHeight = size.height;
    _commont = commont;
}
@end
