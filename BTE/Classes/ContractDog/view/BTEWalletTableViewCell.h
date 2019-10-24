//
//  BTEWalletTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 28/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTEWalletTableViewCell : UITableViewCell
+ (CGFloat )cellHeight;
- (void)configDict:(NSDictionary *)dict;
@end
