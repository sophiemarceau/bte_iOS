//
//  ZYWWrLineView.h
//  ZYWChart
//
//  Created by 张有为 on 2017/5/3.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZTYBaseChartView.h"

@interface ZYWWrLineView : ZTYBaseChartView

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat leftPostion;
@property (nonatomic ,assign) CGFloat candleWidth;
@property (nonatomic, assign) CGFloat candleSpace;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger displayCount;

- (void)stockFill;

@end
