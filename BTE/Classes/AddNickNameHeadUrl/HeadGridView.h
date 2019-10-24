//
//  HeadGridView.h
//  BTE
//
//  Created by sophie on 2018/7/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectCallBack)(NSUInteger selectTag);
@interface HomeGridItemImageView : UIImageView
+ (instancetype)itemViewWithImage:(NSString *)imageUrlStr;
@end

@interface HomeGridItem : NSObject
@property (nonatomic, strong) NSString *imageUrlStr;
+ (instancetype)itemWithImage:(NSString *)imageUrlStr;
@end
@interface HeadGridView : UIView
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic,copy)SelectCallBack selectCallBack;
@end
