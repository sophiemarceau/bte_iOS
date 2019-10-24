//
//  CommontAndAnswerTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 30/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommontAndAnwerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommontAndAnswerTableViewCell : UITableViewCell
@property (strong,nonatomic) UIButton * lookReplyBtn;
//- (void)configwithModel:(CommontAndAnwerModel *)model;
- (void)configwithModel:(CommontAndAnwerModel *)model readShow:(BOOL)show;
//- (void)configwithCommontAndAnswerModel:(CommontAndAnwerModel *)model;
- (void)configwithCommontAndAnswerModel:(CommontAndAnwerModel *)model isRead:(BOOL)isread;
@end

NS_ASSUME_NONNULL_END
