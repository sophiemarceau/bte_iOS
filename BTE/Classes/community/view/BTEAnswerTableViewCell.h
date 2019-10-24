//
//  BTEAnswerTableViewCell.h
//  BTE
//
//  Created by wanmeizty on 30/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModel.h"
#import "CommontAndAnwerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTEAnswerTableViewCell : UITableViewCell

- (void)configWithAnswer:(CommontAndAnwerModel *)model;
- (void)configWithCommontmodel:(AnswerModel *)model;
@end

NS_ASSUME_NONNULL_END
