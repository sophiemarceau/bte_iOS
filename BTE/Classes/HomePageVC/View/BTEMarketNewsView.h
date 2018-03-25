//
//  BTEMarketNewsView.h
//  BTE
//
//  Created by wangli on 2018/3/25.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeProductModel.h"
@interface BTEMarketNewsView : UIView
{
    HomeProductModel *_model;
}
- (instancetype)initViewWithFrame:(CGRect)frame;
- (void)setHomeProductModel:(HomeProductModel *)model;
@end
