//
//  BTECommontTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTECommontModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTECommontTableViewCell : UITableViewCell
@property (copy,nonatomic) void (^btnClick)(NSInteger index);
- (void)likeAdd:(NSString *)praiseNum;
- (void)configwithModel:(BTECommontModel *)model;
- (void)configNoReadwithModel:(BTECommontModel *)model;
@end

NS_ASSUME_NONNULL_END
