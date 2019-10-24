//
//
//  Created by zhoushengjian on 16/11/11.
//  Copyright © 2016年 ihaomu.com. All rights reserved.
//

#import "WLScaleLayoutConstrain.h"

@implementation WLScaleLayoutConstrain

- (void)awakeFromNib{
    [super awakeFromNib];
    
    CGFloat scale = (IS_IPHONE5 || IS_IPHONE4)?0.9:(IS_IPHONE6PLUS?1.1:1);
    self.constant = ceilf(self.constant * scale);
}

@end
