//
//  BTECoinTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 24/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTECoinTableViewCell : UITableViewCell
//@property (copy,nonatomic) void(^selectblock)(CurrencyModel * model);
@property (copy,nonatomic) void(^selectblock)(BOOL selected);
- (void)configwidth:(NSDictionary *)dict;
- (void)configwidthModel:(CurrencyModel *)model;
- (void)configwidthModel:(CurrencyModel *)model optionList:(NSArray *)optionList;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
