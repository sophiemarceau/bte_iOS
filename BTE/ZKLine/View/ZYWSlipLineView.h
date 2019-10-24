//
//  ZYWSlipLineView.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZTYBaseChartView.h"

@interface ZYWSlipLineView : ZTYBaseChartView

@property (nonatomic,strong) NSArray *dataArray;

- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;
- (void)stockFill;

@end
