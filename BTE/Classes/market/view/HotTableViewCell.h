//
//  HotTableViewCell.h
//  BTE
//
//  Created by sophie on 2018/11/7.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *subNumLabel;
@property (nonatomic, strong) UILabel *priceNumLabel;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *hotOrAtomspereLabel;
@property (nonatomic, strong) UIImageView *lineImageView;

-(void)setDataDiction:(NSDictionary *)itemDictionary;
@end

NS_ASSUME_NONNULL_END
