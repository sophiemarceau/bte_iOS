//
//  MessageItem.m
//  BTE
//
//  Created by sophie on 2018/10/19.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "MessageItem.h"

@implementation MessageItem
-(CGFloat)heightForRowWithisShow:(BOOL)isShow
{//105
    if (!isShow) {
//        if ([self heightForString:_content fontSize:15 andWidth:SCREEN_WIDTH - 45] > 20) {
//
//            return 163;
//        }
//        else
//        {
//
//            return [self heightForString:_content fontSize:15 andWidth:SCREEN_WIDTH - 32] + 150;
//        }
        return  127;
    }else
    {
        if ([self heightForString:_content fontSize:SCALE_W(14) andWidth:SCREEN_WIDTH - 32] > 47) {
            return 6+62+ [self heightForString:_content fontSize:SCALE_W(14) andWidth:SCREEN_WIDTH - 32] +  12;
        }else{
            return  127;
        }
    }
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailLabel.font = UIFontRegularOfSize(fontSize);
    detailLabel.text = value;
    detailLabel.numberOfLines = 0;
    CGSize deSize = [detailLabel sizeThatFits:CGSizeMake(width,1)];
    return deSize.height;
}
@end
