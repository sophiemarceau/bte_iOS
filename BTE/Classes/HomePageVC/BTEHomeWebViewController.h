//
//  BTEHomeWebViewController.h
//  BTE
//
//  Created by wangli on 2018/1/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

//#import "BTEBaseWebVC.h"
#import "BHBaseWebVC.h"
#import "HomeProductInfoModel.h"
#import "HomeDesListModel.h"
#import "HomeDescriptionModel.h"
@interface BTEHomeWebViewController : BHBaseWebVC
{
    //设置状态栏颜色
    UIView *_statusBarView;
}
@property (nonatomic,strong) HomeProductInfoModel *productInfoModel;//策略跟随列表model
@property (nonatomic,strong) HomeDesListModel * desListModel;//市场分析列表model
@property (nonatomic,strong) HomeDescriptionModel * descriptionModel;//市场详情页model
@end
