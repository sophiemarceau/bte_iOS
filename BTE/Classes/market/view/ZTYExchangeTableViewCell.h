//
//  ZTYExchangeTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 14/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTYExchangeTableViewCell : UITableViewCell
-(void)configwithDict:(NSDictionary *)dict;
+ (CGFloat)cellHeigth;
@end

NS_ASSUME_NONNULL_END
