//
//  MessageTableViewCell.h
//  BTE
//
//  Created by sophie on 2018/10/19.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageItem.h"
NS_ASSUME_NONNULL_BEGIN
//@protocol reloadDelegate<NSObject>
//-(void)reloadIndexPathWithModel:(MessageItem *)model indexPath:(NSIndexPath *)indexPath;
//@end
@interface MessageTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIImageView *blueImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *desLabel;
//@property (nonatomic, weak)id<reloadDelegate>delegate;
-(void)setNormalTableItem:(MessageItem *)tableViewItem;
@end

NS_ASSUME_NONNULL_END
