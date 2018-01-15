//
//  BTEUpgradeViewController.m
//  BTE
//
//  Created by wangli on 2018/1/13.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEUpgradeViewController.h"

@interface BTEUpgradeViewController ()
@property (nonatomic, strong) UITextView *textUpdateTips1;
@end

@implementation BTEUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35 / 2, 131, (SCREEN_WIDTH - 35), (872 * (SCREEN_WIDTH - 35) / 680))];
    bgImageView.image = [UIImage imageNamed:@"upgrad_image"];
    bgImageView.layer.masksToBounds = YES;
    bgImageView.layer.cornerRadius = 10;
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    //titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 198, bgImageView.width - 61 * 2, 20)];
    titleLabel.text = @"68%的用户正在使用最新版本V2.0";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = BHHexColor(@"000000");
    [bgImageView addSubview:titleLabel];
    
    _textUpdateTips1 = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, 120)];
    _textUpdateTips1.editable = NO;
    _textUpdateTips1.textColor = BHHexColor(@"333333");
    [bgImageView addSubview:_textUpdateTips1];
    
    NSString *tips = [@"1.修复了部分bug。2.新增了播放功能。3.完善了部分页面。4.优化了推荐速度。" stringByReplacingOccurrencesOfString:@"。" withString:@"\n"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tips];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tips length])];
    self.textUpdateTips1.attributedText = attributedString;
    _textUpdateTips1.font = [UIFont systemFontOfSize:14];
    
    UIButton *onButton = [UIButton buttonWithType:UIButtonTypeCustom];
    onButton.frame = CGRectMake((bgImageView.width - 510 / 2) / 2, bgImageView.height - 30 - 44, 510 / 2, 88 / 2);
    [onButton setBackgroundImage:[UIImage imageNamed:@"upgrad_button_on"] forState:UIControlStateNormal];
    [onButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [onButton setTitleColor:BHHexColor(@"ffffff") forState:UIControlStateNormal];
    [onButton addTarget:self action:@selector(updateNow) forControlEvents:UIControlEventTouchUpInside];
    onButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [bgImageView addSubview:onButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake((SCREEN_WIDTH - 41) / 2, bgImageView.bottom + 15, 41, 41);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"upgrad_button_off"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)updateNow
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:STRISEMPTY(self.url) ? kAppStoreAddress : self.url]];
        if (self.force.integerValue == 1) {
            //强制升级退出程序
            exit(0);
        }
    });
}

- (void)closeNow
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"关闭");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
