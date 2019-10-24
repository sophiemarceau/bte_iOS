//
//  BTESearchViewController.m
//  BTE
//
//  Created by wanmeizty on 23/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTESearchViewController.h"
#import "BTECoinTableViewCell.h"
#import "BTECurrencyTableViewCell.h"

@interface BTESearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSMutableArray * dataArray;

@property (strong,nonatomic) UITableView * tableview;
@property (strong,nonatomic) UITextField * searchText;
@property (strong,nonatomic) NSMutableArray * selectArray;
@end

@implementation BTESearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem = [self createNaviback];
    self.navigationItem.rightBarButtonItem = [self createNaviRight];
    self.navigationItem.titleView = [self createTitleView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.selectArray = [NSMutableArray arrayWithCapacity:0];
    [self createHotSearchview];
    [self createTableView];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapclick)];
//    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchText resignFirstResponder];
}

- (void)requestSingleCurrencyListData:(NSString *)base{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:base forKey:@"key"];
    NSString * methodName = [NSString stringWithFormat:@"%@",searchCurrencyList];
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    WS(weakSelf)
    [BTERequestTools requestWithURLString:methodName parameters:param type:1 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            
           
            [weakSelf dealOptionData:responseObject];
            
        }
    } failure:^(NSError *error) {
        RequestError(error);
    }];
}

- (void)dealOptionData:(NSDictionary *)dataDict{
    [self.dataArray removeAllObjects];
    NSArray * array = [NSArray arrayWithArray:[dataDict objectForKey:@"data"]];
    NSInteger index = 0;
    for (NSDictionary * dict in array) {
        CurrencyModel * model = [[CurrencyModel alloc] init];
        [model initWithDict:dict];
        model.index = index;
        for (NSDictionary * subDict in self.optionList) {
            if ([[subDict objectForKey:@"quote"] isEqualToString:model.quote] && [[subDict objectForKey:@"base"] isEqualToString:model.base] && [[subDict objectForKey:@"exchange"] isEqualToString:model.exchange]) {
                model.status = YES;
            }
        }
        [self.dataArray addObject:model];
        index ++;
    }
    self.tableview.hidden = NO;
    [self.tableview reloadData];
}

//创建观察者回调方法
- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //创建自带来获取穿过来的对象的info配置信息
    NSDictionary *userInfo = [aNotification userInfo];
    //创建value来获取 userinfo里的键盘frame大小
    NSValue *aValue = [userInfo         objectForKey:UIKeyboardFrameEndUserInfoKey];
    //创建cgrect 来获取键盘的值
    CGRect keyboardRect = [aValue CGRectValue];
    //最后获取高度 宽度也是同理可以获取
    CGFloat height = keyboardRect.size.height;
    self.tableview.height = SCREEN_HEIGHT - height - NAVIGATION_HEIGHT;
    
}

- (void)keyboardwillhidden:(NSNotification *)notification
{
    self.tableview.height = SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT;
}

- (void)createTableView{
    UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - HOME_INDICATOR_HEIGHT) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.hidden = YES;
    self.tableview = tableview;
    tableview.rowHeight = [BTECoinTableViewCell cellHeight];
    tableview.tableFooterView = [UIView new];
    [self.view addSubview:tableview];
}

#pragma mark -- tableView 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTECoinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BTECoinTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    CurrencyModel * cellModel = self.dataArray[indexPath.row];
    [cell configwidthModel:cellModel optionList:self.optionList];
    cell.selectblock = ^(BOOL selected) {
        if (cellModel.status != selected) {
            BOOL isSelected = NO;
            for (CurrencyModel * obj in self.selectArray) {
                if (obj.index == cellModel.index) {
                    obj.status = selected;
                    isSelected = YES;
                    break;
                }
            }
            
            if (!isSelected) {
                CurrencyModel * tempModel = [[CurrencyModel alloc] init];
                tempModel.base = cellModel.base;
                tempModel.quote = cellModel.quote;
                tempModel.exchange = cellModel.exchange;
                tempModel.status = selected;
                tempModel.index = cellModel.index;
                [self.selectArray addObject:tempModel];
            }
        }else{
            for (CurrencyModel * obj in self.selectArray) {
                if (obj.index == indexPath.row) {
                    [self.selectArray removeObject:obj];
                    break;
                }
            }
        }
    };
//    cell.selectblock = ^(CurrencyModel * _Nonnull model) {
//        if (cellModel.status == model.status) {
//            BOOL isSelected = NO;
//            for (CurrencyModel * obj in self.selectArray) {
//                if (obj.index == model.index) {
//                    obj.status = model.status;
//                    isSelected = YES;
//                    break;
//                }
//            }
//            
//            if (!isSelected) {
//                [self.selectArray addObject:model];
//            }
//        }else{
//            for (CurrencyModel * obj in self.selectArray) {
//                if (obj.index == model.index) {
//                    [self.selectArray removeObject:obj];
//                    break;
//                }
//            }
//        }
//    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchText resignFirstResponder];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * text = [[textField.text stringByReplacingCharactersInRange:range withString:string] lowercaseString];
    [self requestSingleCurrencyListData:text];
    
    return YES;
}


- (void)createHotSearchview{
    UILabel * hotTitleLabel = [self createLabelTitle:@"热门搜索" frame:CGRectMake(16, 16, 200, 14)];
    hotTitleLabel.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    [self.view addSubview:hotTitleLabel];
    
    NSArray * titles = @[@"BTC",@"ETH",@"BCH",@"EOS"];
    for (int i = 0; i < 4; i ++) {
        NSString * title = titles[i];
        UIButton * btn = [self createBtn:CGRectMake(16 + (16 + 60) * i, 16 + 16 + 14, 61, 22) title:title];
        btn.backgroundColor = [UIColor colorWithHexString:@"626A75" alpha:0.1];
        btn.layer.cornerRadius = 11;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(hotclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

-(void)hotclick:(UIButton *)btn{
    NSString * currency = btn.titleLabel.text;
    [self requestSingleCurrencyListData:currency];
}

- (UIBarButtonItem *)createNaviRight{
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    return right;
}

-(void)finish{
    NSMutableArray * finishArray = [NSMutableArray arrayWithCapacity:0];
    for (CurrencyModel * model in self.selectArray) {
        NSDictionary * dict = [model modelIntoDict];
        [finishArray addObject:dict];
    }
    NSString * json = [self arrayToJSONString:finishArray];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:json forKey:@"pairs"];
    if (User.userToken) {
        [param setObject:User.userToken forKey:@"bte-token"];
        [param setObject:User.userToken forKey:@"token"];
    }
    [BTERequestTools requestWithURLString:addBatchCurrencyList parameters:param type:3 success:^(id responseObject) {
        if (IsSafeDictionary(responseObject)) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self performSelector:@selector(updateData) withObject:nil afterDelay:2];
            
        }
    } failure:^(NSError *error) {
        RequestError(error);
    }];
}

- (void)updateData{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRefreshTradeList object:nil];
    
}

- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


- (UIBarButtonItem *)createNaviback{
    UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(disback)];
    return back;
}

- (void)disback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)createTitleView{
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 8, (SCREEN_WIDTH - 90), 28)];
    titleView.backgroundColor = [UIColor colorWithHexString:@"626A75" alpha:0.1];
    titleView.layer.cornerRadius = 14;
    titleView.layer.masksToBounds = YES;
    
    UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 18, 18)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"marketSearch"] forState:UIControlStateNormal];
    [titleView addSubview:searchBtn];
    
    UITextField * searchText = [[UITextField alloc] initWithFrame:CGRectMake(43, 5, SCREEN_WIDTH - 150, 18)];
    searchText.placeholder = @"请输入搜索币种";
    searchText.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    searchText.keyboardType = UIKeyboardTypeASCIICapable;
    searchText.delegate = self;
    [titleView addSubview:searchText];
    self.searchText = searchText;
    
    //监听弹出键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillhidden:) name:UIKeyboardWillHideNotification object:nil];
    return titleView;
}

#pragma mark -- 初始化
- (UILabel *)createLabelTitle:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    return label;
}

- (UIButton *)createBtn:(CGRect)frame title:(NSString *)title{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"626A75" alpha:0.6] forState:UIControlStateNormal];
    return button;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
