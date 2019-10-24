//
//  MessageCenterViewController.m
//  BTE
//
//  Created by sophie on 2018/10/19.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageTableViewCell.h"
#import "MessageItem.h"
#import "SecondaryLevelWebViewController.h"
@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int current_page,total_count;
}
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *listView;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"消息中心";
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    [self initSubviews];
    [self requestData];
}

-(void)requestData{
    current_page = 0;
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"0" forKey:@"offset"];
    [pramaDic setObject:@"10" forKey:@"pageSize"];
    methodName = kMessageCenterList;
    
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:1 success:^(id responseObject) {
        [self.listView.mj_header endRefreshing];
        [self.listView.mj_footer endRefreshing];
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            total_count = [[[responseObject objectForKey:@"data"] objectForKey:@"totalNum"] intValue];
            
            NSArray *array = [NSArray yy_modelArrayWithClass:[MessageItem class] json:responseObject[@"data"][@"data"]];
            for (MessageItem *temp in array) {
                temp.isShow = NO;
            }
            
            if (array != nil && array.count > 0) {
                [self.listArray removeAllObjects];
                [self.listArray addObjectsFromArray:array];
                [self.listView reloadData];
            }
            if (self.listArray.count == total_count || self.listArray.count == 0) {
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.listView.mj_header endRefreshing];
        [self.listView.mj_footer endRefreshing];
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)giveMeMoreData{
    current_page++;
    NSString *page = [NSString stringWithFormat:@"%d",current_page];
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:page forKey:@"offset"];
    [pramaDic setObject:@"10" forKey:@"pageSize"];
    methodName = kMessageCenterList;
    
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:1 success:^(id responseObject) {
         [self.listView.mj_footer endRefreshing];
        NSLog(@"kMessageCenterList----giveMeMoreData---->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            total_count = [[[responseObject objectForKey:@"data"] objectForKey:@"totalNum"] intValue];
            NSArray *array = [NSArray yy_modelArrayWithClass:[MessageItem class] json:responseObject[@"data"][@"data"]];
            for (MessageItem *temp in array) {
                temp.isShow = NO;
            }
            if (array != nil && array.count > 0) {
                [self.listArray addObjectsFromArray:array];
            }
            [self.listView reloadData];
            if (self.listArray.count == total_count || self.listArray.count == 0) {
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.listView.mj_footer endRefreshing];
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)initSubviews{
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.listView];
}

-(UITableView *)listView{
    if (_listView == nil) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - NAVIGATION_HEIGHT)];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = KBGColor;
        //也可以让分割线消失
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
         WS(weakSelf)
        _listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (User.userToken) {
                [weakSelf requestData];
            }
        }];
        MJRefreshBackNormalFooter *allfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (User.userToken) {
                [weakSelf giveMeMoreData];
            }
        }];
        _listView.mj_footer = allfooter;
       _listView.mj_footer.ignoredScrollViewContentInsetBottom = HOME_INDICATOR_HEIGHT;
    }
    return _listView;
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageItem *model = [self.listArray objectAtIndex:indexPath.row];
    return  [model heightForRowWithisShow:model.isShow];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    MessageTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setNormalTableItem:[self.listArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageItem *selectMessageItem = self.listArray[indexPath.row];
    
    NSString *urlStr =  stringFormat(selectMessageItem.redirectUrl);
    if([urlStr isEqualToString:@""]){
         selectMessageItem.isShow = !selectMessageItem.isShow;
        [self.listArray replaceObjectAtIndex:indexPath.row withObject:selectMessageItem];
        [self.listView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
        webVc.urlString = [NSString stringWithFormat:@"%@",selectMessageItem.redirectUrl];
        webVc.isHiddenLeft = NO;
        webVc.isHiddenBottom = NO;
        [self.navigationController pushViewController:webVc animated:YES];
    }
}


@end
