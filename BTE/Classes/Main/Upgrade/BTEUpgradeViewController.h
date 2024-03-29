//
//  BTEUpgradeViewController.h
//  BTE
//
//  Created by wangli on 2018/1/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BHBaseController.h"

@interface BTEUpgradeViewController : BHBaseController
@property (nonatomic, copy) NSString * url; //下载地址
@property (nonatomic, copy) NSString * force; //是否强制升级 0否 1是
@property (nonatomic, copy) NSString * name; //升级title
@property (nonatomic, copy) NSString * desc; //升级描述
@end
