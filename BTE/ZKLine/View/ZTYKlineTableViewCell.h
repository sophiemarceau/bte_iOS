//
//  ZTYKlineTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 2018/7/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTYKlineTableViewCell : UITableViewCell
/**
 主图指标
 */
@property (nonatomic,assign) MainViewQuotaName mainquotaName;

/**
 主图类型
 */
@property (nonatomic,assign) MainChartCenterViewType mainchartType;

- (void)configWidth:(ZTYChartModel *)model scaleY:(CGFloat)scaleY topMargin:(CGFloat)topMargin maxY:(CGFloat)maxY candleWidth:(CGFloat)candleWidth candleSpace:(CGFloat)candleSpace;
@end
