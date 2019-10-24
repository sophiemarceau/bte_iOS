//
//  BTECurrencyTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 11/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTECurrencyTableViewCell : UITableViewCell
- (void)configwidth:(NSString *)currency;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
