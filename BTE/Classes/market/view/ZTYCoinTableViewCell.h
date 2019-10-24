//
//  ZTYCoinTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 20/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTYCoinTableViewCell : UITableViewCell
- (void)configwidth:(NSDictionary *)dict;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
