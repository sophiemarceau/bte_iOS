//
//  BTECurrencyTypePickerView.m
//  BTE
//
//  Created by wangli on 2018/3/28.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTECurrencyTypePickerView.h"
#import "HomeDesListModel.h"

@implementation BTECurrencyTypePickerView
/**
 * 只显示币种一级
 * provinceBlock : 回调币种及RowIndex
 */
+ (instancetype)provincePickerViewWithArray:(NSArray *)CurrencyArray WithProvince:(NSString *)province ProvinceBlock:(void(^)(NSInteger rowIndex))provinceBlock
{
    BTECurrencyTypePickerView *_view = [[BTECurrencyTypePickerView alloc] init];
    
    _view.selectProvince = province;
    _view.provinceBlock = provinceBlock;
    _view.provinceArray = CurrencyArray;
    NSInteger provinceIndex = 0;
    for (NSInteger p = 0; p < _view.provinceArray.count; p++) {
        HomeDesListModel *tempModel = _view.provinceArray[p];
        if ([tempModel.symbol isEqualToString:_view.selectProvince]) {
            _view.selectProvinceIndex = p;
            provinceIndex = p;
        }
    }
    [_view.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    
    [_view showView];
    
    return _view;
}


- (instancetype)init {
    if (self = [super init]) {
        
        [self czh_setView];
        
    }
    return self;
}

- (void)czh_setView {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIView *containView = [[UIView alloc] init];
    containView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 230);
    [self addSubview:containView];
    self.containView = containView;
    
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    toolBar.backgroundColor = BHHexColor(@"ffffff");
    [containView addSubview:toolBar];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, 0, 44, 44);
    [cancleButton setImage:[UIImage imageNamed:@"close_pick"] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.tag = CZHAddressPickerViewButtonTypeCancle;
    [toolBar addSubview:cancleButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(SCREEN_WIDTH - 36 - 6, (44 - 22) / 2, 36, 22);
    [sureButton setImage:[UIImage imageNamed:@"choose_pick"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = CZHAddressPickerViewButtonTypeSure;
    [toolBar addSubview:sureButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) / 2, (44 - 16) / 2, 60, 16)];
    titleLabel.font = UIFontMediumOfSize(16);
    titleLabel.text = @"币种";
    titleLabel.textColor = BHHexColor(@"525866");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [toolBar addSubview:titleLabel];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = BHHexColor(@"fafafa");
    pickerView.frame = CGRectMake(0, toolBar.bottom, SCREEN_WIDTH, containView.height - toolBar.height);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [containView addSubview:pickerView];
    self.pickerView = pickerView;
    
}


- (void)buttonClick:(UIButton *)sender {
    
    [self hideView];
    
    if (sender.tag == CZHAddressPickerViewButtonTypeSure) {
        
        if (_provinceBlock) {
            _provinceBlock(self.selectProvinceIndex);
        }
    }
}



- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = kColorRgba(0, 0, 0, 0.3);
        self.containView.bottom = SCREEN_HEIGHT;
    }];
}

- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark -- UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = BHHexColor(@"E6EBF0");
        }
    }
    //修改选中行背景色
//    NSArray *subviews = self.pickerView.subviews;
//    NSArray *coloms = subviews.firstObject;
//    if (coloms) {
//        NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
//        if (subviewCache.count > 0) {
//            UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
//            if (middleContainerView) {
//                middleContainerView.backgroundColor = [UIColor clearColor];
//            }
//        }
//    }
    
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.backgroundColor = [UIColor clearColor];
//        pickerLabel.textColor = BHHexColor(@"525866");
        pickerLabel.font = UIFontMediumOfSize(20);
        pickerLabel.alpha = 0.8;
    }
    // Fill the label text here
    HomeDesListModel *tempModel = self.provinceArray[row];
    pickerLabel.text = tempModel.symbol;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
    
    
    
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, 30)];
////    label.adjustsFontSizeToFitWidth = YES;
//    label.textColor = BHHexColor(@"525866");
//    label.font = UIFontMediumOfSize(20);
//    label.textAlignment = NSTextAlignmentCenter;
//    if (component == 0) {
//        HomeDesListModel *tempModel = self.provinceArray[row];
//        label.text = tempModel.symbol;
//    }
    
//    if (self.selectProvinceIndex == row) {
////        label.textColor = BHHexColor(@"525866");
////        label.font = UIFontMediumOfSize(20);
//        label.attributedText
//        = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
//    } else
//    {
//        HomeDesListModel *tempModel = self.provinceArray[row];
//       label.text = tempModel.symbol;
//       label.textColor = BHHexColor(@"525866");
//        label.font = UIFontRegularOfSize(18);
//    }
    
//    return label;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *titleString;
    if (row == self.selectProvinceIndex) {
        titleString = self.selectProvince;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleString];
    NSRange range = [titleString rangeOfString:titleString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"525866") range:range];
    
    return attributedString;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {//选择省
        self.selectProvinceIndex = row;
        HomeDesListModel *tempModel = self.provinceArray[row];
        self.selectProvince = tempModel.symbol;
//        [self.pickerView reloadAllComponents];   //修改选中字体属性 一定要写这句
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}




@end
