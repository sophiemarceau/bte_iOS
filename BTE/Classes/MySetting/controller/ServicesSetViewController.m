//
//  ServicesSetViewController.m
//  BTE
//
//  Created by sophie on 2018/10/12.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "ServicesSetViewController.h"
#import "ServiceSetTableViewCell.h"
#import "ServiceDogItem.h"
@interface ServicesSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *lzPointStr;
    NSString *bandPointStr;
    NSString *contractPointStr;
}
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) UITableView *listView;
@end

@implementation ServicesSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.listView];
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    [self requestData];
    [self getScores];
}


-(void)requestData{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName = kAllKindsDogStatus;
    
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
                NSLog(@"kAllKindsDogStatus-------->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            
            NSArray *array = [NSArray yy_modelArrayWithClass:[ServiceDogItem class] json:responseObject[@"data"]];
            if (array != nil && array.count > 0) {
                [self.listArray removeAllObjects];
                [self.listArray addObjectsFromArray:array];
            }
            [self.listView reloadData];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        
        NSLog(@"error-------->%@",error);
    }];
}

-(void)getScores{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    methodName =  kSelectDogUserScore;
    
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"kSelectDogUserScore-------->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            lzPointStr = [responseObject objectForKey:@"data"][@"lzDog"][@"point"];;
            bandPointStr = [responseObject objectForKey:@"data"][@"bandDog"][@"point"];
            contractPointStr = [responseObject objectForKey:@"data"][@"futureDog"][@"point"];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        
        NSLog(@"error-------->%@",error);
    }];
}

- (void)switchValueChanged:(id)sender{
    UISwitch* selectSwitchControl = (UISwitch*)sender;
    NSString *message;
    NSLog(@"selectSwitchControl------>%d",selectSwitchControl.on);

    if (selectSwitchControl.tag == 0) {
        if (selectSwitchControl.on) {
            NSString *messageString = [NSString stringWithFormat:@"开启撸庄狗每天将消耗%@积分，是否确认开启",lzPointStr];
            message = NSLocalizedString(messageString,nil);
        }else{
            NSString *messageString = [NSString stringWithFormat:@"是否确认关闭撸庄狗服务"];
            message = NSLocalizedString(messageString,nil);
        }
    }
    if (selectSwitchControl.tag == 1) {
        
        if (selectSwitchControl.on) {
            NSString *messageString = [NSString stringWithFormat:@"开启波段狗每天将消耗%@积分，是否确认开启",bandPointStr];
            message = NSLocalizedString(messageString,nil);
        }else{
            NSString *messageString = [NSString stringWithFormat:@"是否确认关闭波段狗服务"];
            message = NSLocalizedString(messageString,nil);
        }
    }
    if (selectSwitchControl.tag == 2 ) {
        if (selectSwitchControl.on) {
            NSString *messageString = [NSString stringWithFormat:@"开启合约狗每天将消耗%@积分，是否确认开启",contractPointStr];
            message = NSLocalizedString(messageString,nil);
        }else{
            NSString *messageString = [NSString stringWithFormat:@"是否确认关闭合约狗服务"];
            message = NSLocalizedString(messageString,nil);
        }
    }

    //    NSString *title = @"提示";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //    //改变title的大小和颜色
    //    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:title];
    //    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    //    [titleAtt addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, title.length)];
    //    [alertController setValue:titleAtt forKey:@"attributedTitle"];
    //改变message的大小和颜色
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
    [messageAtt addAttribute:NSFontAttributeName value:UIFontRegularOfSize(14) range:NSMakeRange(0, message.length)];
    [messageAtt addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"626A75") range:NSMakeRange(0, message.length)];
    [alertController setValue:messageAtt forKey:@"attributedMessage"];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [selectSwitchControl setOn:!selectSwitchControl.on animated:YES];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        if (User.userToken) {
            [pramaDic setObject:User.userToken forKey:@"bte-token"];
        }
        NSString * methodName = @"";
        if (selectSwitchControl.tag == 0) {
            methodName = kSubmitLzDogStatus;
            [pramaDic setObject:[NSString stringWithFormat:@"%d",selectSwitchControl.on] forKey:@"on_off"];
        }
        if (selectSwitchControl.tag == 1) {
            methodName = kSubmitBandDogStatus;
            [pramaDic setObject:[NSString stringWithFormat:@"%d",selectSwitchControl.on] forKey:@"on_off"];
        }
        if (selectSwitchControl.tag == 2 ) {
            methodName = kSubmitContractDogStatus;
            [pramaDic setObject:[NSString stringWithFormat:@"%d",selectSwitchControl.on] forKey:@"onOff"];
        }
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NSLog(@"switchValueChanged-------->%@",responseObject);
            NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {

                //            NSArray *array = [NSArray yy_modelArrayWithClass:[ServiceDogItem class] json:responseObject[@"data"]];
                //            if (array != nil && array.count > 0) {
                //                [self.listArray removeAllObjects];
                //                [self.listArray addObjectsFromArray:array];
                //            }
                //            [self.listView reloadData];
            }
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error-------->%@",error);
            if (error.code == 1) {
                [BHToast showMessage:error.domain];
                [selectSwitchControl setOn:!selectSwitchControl.on animated:YES];
            }
        }];
    }];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
   
    
    
//    if(control == self.serviceSwitch){
//        BOOL on = control.on;
//        //添加自己要处理的事情代码
//
//        NSLog(@"switchValueChanged----%d",on);
//
//    }
}

-(UITableView *)listView{
    if (_listView == nil) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCREEN_HEIGHT - NAVIGATION_HEIGHT)];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = KBGColor;
        UIView *headView = [UIView new];
        headView.backgroundColor = KBGColor;
        headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 36);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH -32, 12)];
        titleLabel.font = UIFontRegularOfSize(SCALE_W(12));
        titleLabel.textColor = BHHexColor(@"626A75");
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:titleLabel];
        titleLabel.text = @"服务开启/关闭设置";
        [_listView setTableHeaderView:headView];
        _listView.tableFooterView = [UIView new];//不显示多余的分割线
    }
    return _listView;
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ServiceSetTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ServiceSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.serviceSwitch.tag = indexPath.row;
    [cell.serviceSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged | UIControlEventTouchDragExit];
    if (indexPath.row == 3-1) {//最后一条数据的时候隐藏分割线
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    }else{
//        cell.separatorInset = UIEdgeInsetsMake(0, FTDefaultMenuTextMargin, 0, 10+FTDefaultMenuTextMargin);
        
    }
    ServiceDogItem * tempItem = self.listArray[indexPath.row];
    cell.titleLabel.text = tempItem.name;
    [cell.serviceSwitch setOn:[tempItem.status boolValue]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
