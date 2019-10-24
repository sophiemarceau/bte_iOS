//
//  DataViewController.m
//  BTE
//
//  Created by sophie on 2018/11/5.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "DataViewController.h"
#import "SPPageMenu.h"
#import "SecondaryLevelWebViewController.h"

#define pageMenuH 40
#define scrollViewHeight (SCREEN_WIDTH-NAVIGATION_HEIGHT-pageMenuH - TAB_BAR_HEIGHT)
@interface DataViewController ()<SPPageMenuDelegate, UIScrollViewDelegate>
@property (nonatomic,strong) UIView  *navView;
@property (nonatomic,strong) UIView  *searchBgView;
@property (nonatomic,strong) UITextField  *searchLabel;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak)  SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@end

@implementation DataViewController

- (void)viewDidLoad {
    [self initNavgation];
    [super viewDidLoad];
    [self initSubViews];
}

-(void)initNavgation{
    [self.view addSubview:self.navView];
}

#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
//    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    
    // 如果该代理方法是由拖拽self.scrollView而触发，说明self.scrollView已经在用户手指的拖拽下而发生偏移，此时不需要再用代码去设置偏移量，否则在跟踪模式为SPPageMenuTrackerFollowingModeHalf的情况下，滑到屏幕一半时会有闪跳现象。闪跳是因为外界设置的scrollView偏移和用户拖拽产生冲突
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:YES];
        }
    }
    
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(SCREEN_WIDTH * toIndex, 0, SCREEN_WIDTH, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {

}

#pragma mark - insert or remove

- (void)removeItemAtIndex:(NSInteger)index {
    // 示例中index给的是1，所以当只剩下一个子控制器时，会走该if语句，无法继续删除
    if (index >= self.myChildViewControllers.count) {
        return;
    }
    
    [self.pageMenu removeItemAtIndex:index animated:YES];
    
    // 删除之前，先将新控制器之后的控制器view往前偏移
    for (int i = 0; i < self.myChildViewControllers.count; i++) {
        if (i >= index) {
            UIViewController *childController = self.myChildViewControllers[i];
            childController.view.frame = CGRectMake(SCREEN_WIDTH * (i>0?(i-1):i), 0, SCREEN_WIDTH, scrollViewHeight);
            [self.scrollView addSubview:childController.view];
        }
    }
    if (index <= self.pageMenu.selectedItemIndex) { // 移除的item在当前选中的item之前
        // scrollView往前偏移
        NSInteger offsetIndex = self.pageMenu.selectedItemIndex-1;
        if (offsetIndex < 0) {
            offsetIndex = 0;
        }
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*offsetIndex, 0);
    }
    
    UIViewController *vc = [self.myChildViewControllers objectAtIndex:index];
    [self.myChildViewControllers removeObjectAtIndex:index];
    [vc removeFromParentViewController];
    [vc.view removeFromSuperview];
    
    // 重新设置scrollView容量
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.myChildViewControllers.count, 0);
}

- (void)removeAllItems {
    [self.pageMenu removeAllItems];
    for (UIViewController *vc in self.myChildViewControllers) {
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    [self.myChildViewControllers removeAllObjects];
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = CGSizeMake(0, 0);
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
    // [self.pageMenu moveTrackerFollowScrollView:scrollView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

// 示例1:SPPageMenuTrackerStyleLine,下划线样式
- (void)initSubViews {
    self.dataArr = @[@"市场",@"币种",@"热度指数",@"空气指数"];
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, NAVIGATION_HEIGHT, SCREEN_WIDTH, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
    for (int i = 0; i < self.dataArr.count; i++) {
        
        BHBaseController *vc;
        if (i == 0) {
            vc = [[SecondaryLevelWebViewController alloc] init];
            vc.view.backgroundColor = [UIColor redColor];
        }else{
            vc = [[BHBaseController alloc] init];
        }
        
        [self addChildViewController:vc];
        // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
        [self.myChildViewControllers addObject:vc];
    }
    [pageMenu setItems:self.dataArr selectedItemIndex:0];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollAdaptContent;
    // 设置代理
    pageMenu.delegate = self;
    // 给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，从而实现让跟踪器跟随self.scrollView移动的效果
    pageMenu.bridgeScrollView = self.scrollView;
    pageMenu.backgroundColor = KBGCell;
//    UIImage *image = [UIImage imageNamed:@"mateor.jpg"];
//    [pageMenu setBackgroundImage:image barMetrics:0];
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
}

- (UIScrollView *)scrollView {
    if (_scrollView== nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT+pageMenuH, SCREEN_WIDTH, scrollViewHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor greenColor];
    }
    return  _scrollView;
}

- (NSMutableArray *)myChildViewControllers{
    if (_myChildViewControllers == nil) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}

-(UIView *)navView{
    if (_navView == nil) {
        _navView = [UIView new];
        _navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_HEIGHT);
        _navView.backgroundColor = KBGCell;
        [_navView addSubview:self.searchBgView];
    }
    return _navView;
}

-(UIView *)searchBgView{
    if (_searchBgView == nil) {
        _searchBgView = [UIView new];
        _searchBgView.frame = CGRectMake(16, NAVIGATION_HEIGHT - 30- 8, SCREEN_WIDTH -32, 30);
        _searchBgView.layer.cornerRadius = 15;
        _searchBgView.layer.masksToBounds = YES;
        _searchBgView.backgroundColor = BHHexColorAlpha(@"626A75", 0.09);
         UIImageView *magnifier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marketSearch"]];
        magnifier.frame = CGRectMake(14, 8, 14, 14);
//        magnifier.backgroundColor = [UIColor redColor];
        [_searchBgView addSubview:magnifier];
        UIView *verticalLineImage = [UIView new];
        verticalLineImage.frame = CGRectMake(36, 6, 1, 18);
        verticalLineImage.backgroundColor = BHHexColor(@"626A75");
        [_searchBgView addSubview:verticalLineImage];
        [_searchBgView addSubview:self.searchLabel];
    }
    return _searchBgView;
}

-(UITextField *)searchLabel{
    if (_searchLabel == nil) {
        _searchLabel = [UITextField new];
        _searchLabel.frame = CGRectMake(49, 0, self.searchBgView.width - 49 -20, self.searchBgView.height);
        _searchLabel.backgroundColor = [UIColor clearColor];
        _searchLabel.placeholder = @"请输入您要搜索的币种";
        _searchLabel.textColor = BHHexColor(@"626A75");
        _searchLabel.font = UIFontRegularOfSize(12);
    }
    return _searchLabel;
}

- (void)dealloc {
    NSLog(@"dataViewController被销毁了");
}

@end
