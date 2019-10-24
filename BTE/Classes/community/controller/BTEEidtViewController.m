//
//  BTEEidtViewController.m
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEEidtViewController.h"
#import "BTELoginVC.h"

@interface BTEEidtViewController ()<UITextViewDelegate>
@property (strong,nonatomic) UITextView * textview;
@end

@implementation BTEEidtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    
    UIImage *buttonNormal = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:buttonNormal style:UIBarButtonItemStylePlain target:self action:@selector(disback)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 57, 24)];
    rightLabel.text = @"发布";
    rightLabel.textColor = [UIColor colorWithHexString:@"308cdd"];
    
    rightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    rightLabel.userInteractionEnabled = NO;
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.backgroundColor = [UIColor colorWithHexString:@"308cdd" alpha:0.1];
    rightLabel.layer.cornerRadius = rightLabel.height * 0.5;
    rightLabel.layer.masksToBounds = YES;
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 44)];
    [rightBtn addTarget:self action:@selector(distrube) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addSubview:rightLabel];
    
    UIBarButtonItem *rightbackItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightbackItem;
    
    UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(16,16,SCREEN_WIDTH-32,300)];
    textView.backgroundColor= [UIColor whiteColor];
    textView.text = @"分享新鲜事…";
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textView.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    textView.delegate = self;
    self.textview = textView;
    [self.view addSubview:textView];
    

    // Do any additional setup after loading the view.
}


#pragma mark -- event
-(void)disback{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"退出此次编辑？"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.navigationController popViewControllerAnimated:YES]; //响应事件
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        //响应事件
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)distrube{
    NSString * commnot = self.textview.text;
    if ([commnot isEqualToString:@"分享新鲜事…"]) {
        NSLog(@"%@",commnot);
    }else{
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        NSString * methodName = @"";
        if (User.userToken) {
            [param setObject:User.userToken forKey:@"bte-token"];
            [param setObject:User.userToken forKey:@"token"];
        }
        [param setObject:commnot forKey:@"content"];
        methodName = ComunityAddArticleUrl;
        WS(weakSelf)
        [BTERequestTools requestWithURLString:methodName parameters:param type:3 success:^(id responseObject) {
            
            if (IsSafeDictionary(responseObject)) {
                [weakSelf dealDistrubeData:responseObject];
            }
            
        } failure:^(NSError *error) {
            
            RequestError(error);
            
        }];
        
        
    }
}

-(void)dealDistrubeData:(NSDictionary *)dict{
    if ([[dict objectForKey:@"code"] integerValue] == -1) {
        
        WS(weakSelf)
        [self alertTitle:@"" msg:@"您还没有登录，请登录后发帖" sureTitle:@"去登录" cansleTitle:@"取消" sureblock:^{
            [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                
                if (isComplete) {
                    [weakSelf distrube];
                }
            }];
        } cancelBlock:^{
            
        }];
    }else if([[dict objectForKey:@"code"] integerValue] == 0){
        [self.navigationController popViewControllerAnimated:YES];
        self.distrubBlock();
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"分享新鲜事…";
        textView.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"分享新鲜事…"]){
        textView.text=@"";
        textView.textColor=[UIColor colorWithHexString:@"626A75" alpha:1];
    }
    if (!User.isLogin) {
        WS(weakSelf)
        [textView resignFirstResponder];
        [self alertTitle:@"" msg:@"您还没有登录，请登录后发帖" sureTitle:@"去登录" cansleTitle:@"取消" sureblock:^{
            [BTELoginVC OpenLogin:weakSelf callback:^(BOOL isComplete) {
                
                if (isComplete) {
                    
                }
            }];
        } cancelBlock:^{
            
        }];
    }
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
