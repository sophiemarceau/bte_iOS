//
//  BTEHomePageTableView.m
//  BTE
//
//  Created by wangli on 2018/3/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEHomePageTableView.h"
#import "BTEHomePageTableViewCell.h"
#import "LBBannerView.h"
@implementation BTEHomePageTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _homePageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _homePageTableView.backgroundColor = KBGColor;
        _homePageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homePageTableView.delegate = self;
        _homePageTableView.dataSource = self;
        defaultHeight = 68;
        fixedHeight = 60;
        btnHeight = 20;
        defaultScrollHeight = 130;
        _isShow = NO;//初始化不展开
        [self addSubview:_homePageTableView];
        [self setTableHeadView];
        [self setTableFooterView];
    }
    return self;
}

//设置头部视图
- (void)setTableHeadView
{
    
}

//设置尾部视图
- (void)setTableFooterView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 143)];
    headView.backgroundColor = KBGColor;
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 29, 74, 74)];
    image1.image = [UIImage imageNamed:@"erweima"];
    [headView addSubview:image1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 106, 80, 14)];
    titleLabel.text = @"打开微信,扫一扫";
    titleLabel.font = UIFontRegularOfSize(10);
    titleLabel.textColor = BHHexColor(@"AEAEAE");
    [headView addSubview:titleLabel];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(126, 31, 22, 12)];
    image2.image = [UIImage imageNamed:@"home_dibu_logo"];
    [headView addSubview:image2];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(151, 24, 195, 25)];
    titleLabel1.text = @"玩转比特币 多看比特易";
    titleLabel1.font = UIFontRegularOfSize(14);
    titleLabel1.textColor = BHHexColor(@"696969");
    [headView addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(126, 53, SCREEN_WIDTH - 126 - 18, 25)];
    titleLabel2.text = @"比特易是业界领先的数字货币市场专业分析平台，我们提供专业数字货币市场分析工具和风险管理策略，帮您有效控制数字货币投资风险。";
    titleLabel2.font = UIFontRegularOfSize(10);
    titleLabel2.numberOfLines = 0;
    titleLabel2.textColor = BHHexColor(@"525866");
    [titleLabel2 sizeToFit];
    [headView addSubview:titleLabel2];
    self.homePageTableView.tableFooterView = headView;
}

//刷新数据UI
-(void)refreshUi:(NSArray *)model productList:(NSArray *)productListModel model1:(HomeDescriptionModel *)DescriptionModel model2:(HomeProductInfoModel *)ProductInfoModel
{
    _dataSource = model;
    productList = productListModel;
    descriptionModel = DescriptionModel;
    productInfoModel = ProductInfoModel;
    [self setTableHeadView];
    [self.homePageTableView reloadData];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count] + 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 16;
    } else if ([_dataSource count] > 0 && indexPath.row >= 1 && indexPath.row <= [_dataSource count])
    {
        return 72;
    } else if (indexPath.row == [_dataSource count] + 1)
    {
        return [self cellHeight] + 16;
    } else if (indexPath.row == [_dataSource count] + 2)
    {
        return 53 + defaultScrollHeight + 16;
    } else if (indexPath.row == [_dataSource count] + 3)
    {
        return 16;
    } else
    {
        return 250;
    }
}

- (float)cellHeight
{
    NSString * contentStr= descriptionModel.desc;
    CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    if (rect.size.height > defaultHeight) {
        if (_isShow) {//是否展开
            return fixedHeight + btnHeight + rect.size.height;
        }else{
            return fixedHeight + btnHeight + defaultHeight;
        }
    } else {
        return fixedHeight + rect.size.height;
    }
    
    return 168;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == [_dataSource count] + 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGColor;
        return cell;
    } else if ([_dataSource count] > 0 && indexPath.row >= 1 && indexPath.row <= [_dataSource count])
    {
        static NSString *CellIdentifier = @"Cell";
        BTEHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[BTEHomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCellWithModel:_dataSource[indexPath.row - 1]];
        return cell;
    } else if (indexPath.row == [_dataSource count] + 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 32, 168)];
        bgView.height = [self cellHeight];
        bgView.backgroundColor = BHHexColor(@"F0F8FF");
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4;
        [cell.contentView addSubview:bgView];
        
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 26, 16, 16)];
        image1.image = [UIImage imageNamed:@"home_market analysis"];
        [bgView addSubview:image1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 24, 80, 20)];
        titleLabel.text = @"市场分析";
        titleLabel.font = UIFontRegularOfSize(18);
        titleLabel.textColor = BHHexColor(@"292C33");
        [bgView addSubview:titleLabel];
        
        
        NSString * contentStr= descriptionModel.desc;
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, SCREEN_WIDTH - 64, rect.size.height)];
        contentLabel.text = descriptionModel.desc;
        if (_isShow) {
            
        } else
        {
            contentLabel.height = defaultHeight;
        }
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = BHHexColor(@"525866");
        [bgView addSubview:contentLabel];
        
        if (rect.size.height > defaultHeight) {
            
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.width - 10 - 16, bgView.height - 5 - 10, 10, 5)];
            
            [bgView addSubview:arrowImage];
            if (_isShow) {//是否展开
                arrowImage.image = [UIImage imageNamed:@"home_retract"];
            }else{
                arrowImage.image = [UIImage imageNamed:@"home_more"];
            }
        }
       
        return cell;
    } else if (indexPath.row == [_dataSource count] + 2)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        
        
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 18, 16, 18)];
        image1.image = [UIImage imageNamed:@"home_Market news"];
        [cell.contentView addSubview:image1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 17, 80, 20)];
        titleLabel.text = @"市场快讯";
        titleLabel.font = UIFontRegularOfSize(18);
        titleLabel.textColor = BHHexColor(@"292C33");
        [cell.contentView addSubview:titleLabel];
        
        //创建轮播器控件
        LBBannerView *bannerView = [[LBBannerView alloc] initViewWithFrame:CGRectMake(0, 53, SCREEN_WIDTH, defaultScrollHeight) autoPlayTime:5.0f imagesArray:productList clickCallBack:^(float height) {
            NSLog(@"点击了第%f张图片",height);
            defaultScrollHeight = height;
            [self.homePageTableView beginUpdates];
            [self.homePageTableView endUpdates];
        }];
        
        [cell.contentView addSubview:bannerView];
        
        
        return cell;
    } else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BHHexColor(@"ffffff");
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 22, 16, 16)];
        image1.image = [UIImage imageNamed:@"home_Strategy follow"];
        [cell.contentView addSubview:image1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 80, 20)];
        titleLabel.text = @"策略跟随";
        titleLabel.font = UIFontRegularOfSize(18);
        titleLabel.textColor = BHHexColor(@"292C33");
        [cell.contentView addSubview:titleLabel];
        
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 48, SCREEN_WIDTH - 32, 38)];
        titleLabel1.text = @"通过领先的交易跟随技术，一键跟随专业团队交易策略，投资数字货币更简单。";
        titleLabel1.numberOfLines = 0;
        titleLabel1.font = UIFontRegularOfSize(12);
        titleLabel1.textColor = BHHexColor(@"9CA1A9");
        [cell.contentView addSubview:titleLabel1];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 94, SCREEN_WIDTH - 36, 140)];
        bgView.backgroundColor = BHHexColor(@"F0F8FF");
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4;
        [cell.contentView addSubview:bgView];
        
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 28, 32, 36)];
        if ([productInfoModel.type isEqualToString:@"日内策略"]) {
            image2.image = [UIImage imageNamed:@"ic_rinei"];
        } else if ([productInfoModel.type isEqualToString:@"中期策略"])
        {
            image2.image = [UIImage imageNamed:@"ic_zhonhqi"];
        } else
        {
            image2.image = [UIImage imageNamed:@"ic_changqi"];
        }
        
        [bgView addSubview:image2];
        
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(64, 24, SCREEN_WIDTH - 160, 20)];
        titleLabel2.text = productInfoModel.name;
        titleLabel2.font = UIFontRegularOfSize(16);
        titleLabel2.textColor = BHHexColor(@"292C33");
        [bgView addSubview:titleLabel2];
        
        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(64, 48, SCREEN_WIDTH - 160, 21)];
        titleLabel3.text = productInfoModel.desc;
        titleLabel3.font = UIFontRegularOfSize(14);
        titleLabel3.textColor = BHHexColor(@"525866");
        [bgView addSubview:titleLabel3];
        
        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 25, 24, 24)];
        bgView1.backgroundColor = [UIColor clearColor];
        bgView1.left = bgView.width - 24 - 16;
        bgView1.layer.masksToBounds = YES;
        bgView1.layer.cornerRadius = 4;
        bgView1.layer.borderWidth = 2;
        if ([productInfoModel.riskLevel integerValue] == 1) {
            bgView1.layer.borderColor = BHHexColor(@"A3D97D").CGColor;
        } else if ([productInfoModel.riskLevel integerValue] == 2)
        {
            bgView1.layer.borderColor = BHHexColor(@"FE413F").CGColor;
        } else
        {
            bgView1.layer.borderColor = BHHexColor(@"FF6B28").CGColor;
        }
        [bgView addSubview:bgView1];
        
        UILabel *titleLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        titleLabel7.textAlignment = NSTextAlignmentCenter;
        titleLabel7.text = productInfoModel.riskValue;
        titleLabel7.font = UIFontRegularOfSize(20);
        if ([productInfoModel.riskLevel integerValue] == 1) {
            titleLabel7.textColor = BHHexColor(@"A3D97D");
        } else if ([productInfoModel.riskLevel integerValue] == 2)
        {
            titleLabel7.textColor = BHHexColor(@"FE413F");
        } else
        {
            titleLabel7.textColor = BHHexColor(@"FF6B28");
        }
        
        [bgView1 addSubview:titleLabel7];
        
        
        
        
        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(64, 56, 60, 14)];
        titleLabel4.left = bgView.width - 60 - 16;
        titleLabel4.textAlignment = NSTextAlignmentRight;
        titleLabel4.text = @"风险";
        titleLabel4.font = UIFontRegularOfSize(12);
        titleLabel4.textColor = BHHexColor(@"7A8499");
        [bgView addSubview:titleLabel4];
        
        UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(16, 93, bgView.width - 32, 1)];
        bgView2.backgroundColor = BHHexColor(@"E6EBF0");
        [bgView addSubview:bgView2];
        
        
        UILabel *titleLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(16, 108, 160, 12)];
        titleLabel6.text = @"累计收益率：";
        titleLabel6.font = UIFontRegularOfSize(12);
        titleLabel6.textColor = BHHexColor(@"525866");
        [bgView addSubview:titleLabel6];
        
        UILabel *titleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(16, 104, 160, 20)];
        titleLabel5.left = bgView.width - 160 - 16;
        titleLabel5.textAlignment = NSTextAlignmentRight;
        titleLabel5.font = UIFontRegularOfSize(20);
        [bgView addSubview:titleLabel5];
        
        
        if ([productInfoModel.ror integerValue] > 0) {
            titleLabel5.text = [NSString stringWithFormat:@"+%@%%",productInfoModel.ror];
            titleLabel5.textColor = BHHexColor(@"1BAC75");
        } else if ([productInfoModel.ror integerValue] < 0)
        {
            titleLabel5.text = [NSString stringWithFormat:@"%@%%",productInfoModel.ror];
            titleLabel5.textColor = BHHexColor(@"FF6B28");
        } else
        {
            titleLabel5.text = [NSString stringWithFormat:@"%@%%",productInfoModel.ror];
            titleLabel5.textColor = BHHexColor(@"292C33");
        }

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [_dataSource count] + 1) {
        NSString *contentStr = descriptionModel.desc;
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        if (rect.size.height > defaultHeight) {
            _isShow = !_isShow;
            [self.homePageTableView reloadData];
        }
    }
}


@end
