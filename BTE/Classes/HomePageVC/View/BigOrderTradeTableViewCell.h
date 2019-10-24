//
//  BigOrderTradeTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 5/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigOrderTradeTableViewCell : UITableViewCell
- (void)configWithDict:(NSDictionary *)dict maxCount:(NSInteger)maxCount;
- (void)configWithDict:(NSDictionary *)dict maxCount:(NSInteger)maxCount isLast:(BOOL)isLast;
+ (CGFloat)cellHeight;
@end
