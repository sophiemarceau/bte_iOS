//
//  FollowHeaderView.h
//  BTE
//
//  Created by sophie on 2018/10/9.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, weak) UILabel *descriptionLabel;
@end

NS_ASSUME_NONNULL_END
