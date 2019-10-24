//
//  CoinTableViewCell.h
//  BTE
//
//  Created by sophie on 2018/11/7.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormatUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinTableViewCell : UITableViewCell
@property (nonatomic,strong)NSString *flagStr;
- (void)configwidth:(NSDictionary *)dict;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
