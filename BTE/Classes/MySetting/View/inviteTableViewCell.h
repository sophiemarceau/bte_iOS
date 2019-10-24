//
//  inviteTableViewCell.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/10/10.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalITableItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface inviteTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *ValueLabel;

-(void)setNormalTableItem:(NormalITableItem *)tableViewItem;
@end

NS_ASSUME_NONNULL_END
