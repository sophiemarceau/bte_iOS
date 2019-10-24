//
//  StraegyTableViewCell.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/10/10.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTEAccountDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StraegyTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *redimageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *moneyContent, *followContent,* getPercentContent ,*transactionStautsContent;
@property (nonatomic, strong)UILabel *moneyLabel ;
@property (nonatomic, strong)UILabel *followLabel;
@property (nonatomic, strong)UILabel *getPercentLabel;
@property (nonatomic, strong)UILabel *transactionStautsLabel;
-(void)setNormalTableItem:(Details *)tableViewItem;
@end

NS_ASSUME_NONNULL_END
