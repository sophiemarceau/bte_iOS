//
//  ExchangeTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 2018/6/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExchangeModel.h"

@interface ExchangeTableViewCell : UITableViewCell
- (void)configwidth:(NSDictionary *)dict;
- (void)configwidthModel:(ExchangeModel *)model;
- (void)configCommonKlinewidthModel:(ExchangeModel *)model;
- (void)configwidthModel:(ExchangeModel *)model width:(CGFloat)width;
@end
