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
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300) / 2, (SCREEN_HEIGHT - 360) / 2 + 20, 300, 360)];
    bgImageView.image = [UIImage imageNamed:@"upgrad_image"];
    bgImageView.layer.masksToBounds = YES;
    bgImageView.layer.cornerRadius = 10;
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    //titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 148, bgImageView.width - 41 * 2, 20)];
    titleLabel.text = self.name;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = BHHexColor(@"000000");
    [bgImageView addSubview:titleLabel];
    
    _textUpdateTips1 = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom + 7, titleLabel.width, 70)];
    _textUpdateTips1.editable = NO;
    _textUpdateTips1.textColor = BHHexColor(@"333333");
    [bgImageView addSubview:_textUpdateTips1];
    
    NSString *tips = [self.desc stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tips];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tips length])];
    self.textUpdateTips1.attributedText = attributedString;
    _textUpdateTips1.font = [UIFont systemFontOfSize:14];
    
    UIButton *onButton = [UIButton buttonWithType:UIButtonTypeCustom];
    onButton.frame = CGRectMake((bgImageView.width - 510 / 2) / 2, bgImageView.height - 60 - 44, 510 / 2, 88 / 2);
    [onButton setBackgroundImage:[UIImage imageNamed:@"upgrad_button_on"] forState:UIControlStateNormal];
    [onButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [onButton setTitleColor:BHHexColor(@"ffffff") forState:UIControlStateNormal];
    [onButton addTarget:self action:@selector(updateNow) forControlEvents:UIControlEventTouchUpInside];
    onButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [bgImageView addSubview:onButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake((bgImageView.width - 90) / 2, bgImageView.height - 18 - 25, 90, 25);
    [closeButton setTitle:@"稍后更新" forState:UIControlStateNormal];
    [closeButton setTitleColor:BHHexColor(@"65B0F3") forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [closeButton addTarget:self action:@selector(closeNow) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:closeButton];
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
