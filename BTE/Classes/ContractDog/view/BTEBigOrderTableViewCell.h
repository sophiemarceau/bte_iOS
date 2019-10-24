//
//  BTEBigOrderTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 2018/7/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTEBigOrderTableViewCell : UITableViewCell

+ (CGFloat )cellHeight;
- (void)configWithDict:(NSDictionary*)dict isBurnedOrder:(BOOL)isBurnedOrder base:(NSString *)base;
- (void)configHanlistWithDict:(NSDictionary*)dict;
@end
