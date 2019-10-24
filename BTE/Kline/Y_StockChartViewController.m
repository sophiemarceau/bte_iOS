//
//  YStockChartViewController.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartViewController.h"
#import "Masonry.h"
#import "Y_StockChartView.h"
#import "NetWorking.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH MAX(kScreenWidth,kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

@interface Y_StockChartViewController ()<Y_StockChartViewDataSource>

@property (nonatomic, strong) Y_StockChartView *stockChartView;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL Landscape;//是否横屏
@end

@implementation Y_StockChartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentIndex = -1;
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    _Landscape = NO;
    [self dismiss];
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of  nmthat can be recreated.
}

-(id) stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"1min";
        }
            break;
        case 2:
        {
            type = @"1min";
        }
            break;
        case 3:
        {
            type = @"5min";
        }
            break;
        case 4:
        {
            type = @"30min";
        }
            break;
        case 5:
        {
            type = @"60min";
        }
            break;
        case 6:
        {
            type = @"1day";
        }
            break;
        case 7:
        {
            type = @"1week";
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDict objectForKey:type])
    {
        [self reloadData];
    } else {
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}

- (void)reloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"period"] = self.type;
//    param[@"symbol"] = @"btcusdt";
//    param[@"size"] = @"300";
    
    
    param[@"start"] = @"2018-01-31";
    param[@"end"] = @"2018-02-1";
    param[@"type"] = self.type;
//    param[@"client"] = @"ios";
    
    [NetWorking requestWithApi:@"http://m.bte.top/app/api/okData/line" param:param thenSuccess:^(NSDictionary *responseObject)
     {
//    [NetWorking requestWithApi:@"https://api.huobi.pro/market/history/kline" param:param thenSuccess:^(NSDictionary *responseObject) {
//        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
         if (responseObject[@"data"]) {
             if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                 NSArray *tempArr = (NSArray *)responseObject[@"data"];
                 if (tempArr.count > 7) {
                     
                 }else
                 {
                     return;
                 }
             } else
             {
                 return;
             }
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"data"]];
            
            self.groupModel = groupModel;
            [self.modelsDict setObject:groupModel forKey:self.type];
            NSLog(@"%@",groupModel);
            [self.stockChartView reloadData];
        }
        
    } fail:^{
        
    }];
}
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"指标" type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"5分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"60分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"日线" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"周线" type:Y_StockChartcenterViewTypeKline],
 
                                       ];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IS_IPHONE_X) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 30, 0, 0));
            } else {
                make.edges.equalTo(self.view);
            }
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tap];
    }
    return _stockChartView;
}
- (void)dismiss
{
//    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
//    appdelegate.isEable = NO;
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self portraitAction:nil];
    
    if (_Landscape == NO) {
        NSNumber *orientation = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        if ([UIDevice currentDevice].orientation!=[orientation integerValue]) {
            [[UIDevice currentDevice] setValue:orientation forKey:@"orientation"];
        }
        _Landscape = YES;
    }
    else
    {
        NSNumber *orientation = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
        if ([UIDevice currentDevice].orientation!=[orientation integerValue]) {
            [[UIDevice currentDevice] setValue:orientation forKey:@"orientation"];
        }
        _Landscape = NO;
    }
    
    [self deviceOrientationDidChange];
}



//// 横屏
//- (void)landscapAction:(id)sender {
//    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//}
//
//// 竖屏
//- (void)portraitAction:(id)sender {
//    [self interfaceOrientation:UIInterfaceOrientationPortrait];
//}
//
//- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector             = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val                  = orientation;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//}


- (void)deviceOrientationDidChange
{
    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [self orientationChange:NO];
        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        [self orientationChange:YES];
    }
}

- (void)orientationChange:(BOOL)landscapeRight
{
    if (landscapeRight) {
        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//            self.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.view.transform = CGAffineTransformMakeRotation(0);
            self.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(0);
//            self.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
            self.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}


//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
//}
- (BOOL)shouldAutorotate
{
    return NO;
}
@end
