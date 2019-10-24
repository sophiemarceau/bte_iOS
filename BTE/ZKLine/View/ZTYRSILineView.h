//
//  ZTYRSILineView.h
//  BTE
//
//  Created by wanmeizty on 2018/6/1.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYBaseChartView.h"

@interface ZTYRSILineView : ZTYBaseChartView
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat leftPostion;
@property (nonatomic, assign) CGFloat candleWidth;
@property (nonatomic, assign) CGFloat candleSpace;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger displayCount;

- (void)stockFill;
@end
