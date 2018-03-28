//
//  BTECurrencyTypePickerView.h
//  BTE
//
//  Created by wangli on 2018/3/28.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CZHAddressPickerViewButtonType) {
    CZHAddressPickerViewButtonTypeCancle,
    CZHAddressPickerViewButtonTypeSure
};
@interface BTECurrencyTypePickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) UIView *containView;
///
@property(nonatomic, strong) UIPickerView * pickerView;
///省
@property(nonatomic, strong) NSArray * provinceArray;
///传进来的默认选中的省
@property(nonatomic, copy) NSString * selectProvince;
///记录省选中的位置
@property(nonatomic, assign) NSInteger selectProvinceIndex;
///省份回调
@property (nonatomic, copy) void (^provinceBlock)(NSInteger rowIndex);

/**
 * 只显示币种一级
 * provinceBlock : 回调币种及RowIndex
 */
+ (instancetype)provincePickerViewWithArray:(NSArray *)CurrencyArray WithProvince:(NSString *)province ProvinceBlock:(void(^)(NSInteger rowIndex))provinceBlock;
@end
