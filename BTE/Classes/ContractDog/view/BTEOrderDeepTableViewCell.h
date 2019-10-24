//
//  BTEOrderDeepTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 2018/7/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTEOrderDeepTableViewCell : UITableViewCell
+ (CGFloat )cellHeight;
- (void)configDict:(NSDictionary *)dict maxMindict:(NSDictionary *)maxMinDict;
- (void)configDict:(NSDictionary *)dict maxMindict:(NSDictionary *)maxMinDict base:(NSString *)base;
@end
