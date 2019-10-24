//
//  DugCoinViewContrllerViewController.m
//  BTE
//
//  Created by sophie on 2018/10/23.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "DugCoinViewContrllerViewController.h"
#import "DugRuleActivityView.h"
#import "SecondaryLevelWebViewController.h"
#import "MissionViewController.h"
#import "SignActivity.h"
#import "SharedDugView.h"
#import "DigItem.h"
#import "TaskItem.h"
#import "InfoObject.h"
#import "SKAutoScrollLabel.h"
@interface DugCoinViewContrllerViewController (){
    UILabel *caculateLabel;
    UILabel *coinNumLabel;
    UIView *countDownDateBeginView;
    UIView *powerCollectBallView;
    CGSize itemSize;
    UIImage *decodedImage;
    NSString *invteCodeStr;
    UILabel *poolLabel;
    UILabel *btcNumLabel1;
    UILabel *btcBNumLabel2;
    UIButton *btcButton1;
    UIButton *btcButton2;
    dispatch_source_t _timer;
    dispatch_source_t _timer1;
    
    UILabel *timeLabel;
    int status;
    NSString *rule;
    NSString *startTime;
    UILabel *dateLabel;
    UIImageView *ballImageView;
    NSString *digStartStr;
    TaskItem *taskItem ;
    InfoObject *infoObject;
    BOOL isInTimeFlag;
    SKAutoScrollLabel *messageLabel;
    UILabel *reportTitleLabel;
    UIImageView * repoertIconImageView;
}
@property (nonatomic,strong)NSMutableArray *deslabelArray;
@end

@implementation DugCoinViewContrllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rule =@"";
    status = 0;
    isInTimeFlag = NO;
    itemSize = CGSizeMake(56, 56);
    [self setheaderView];
    [self setTaskTabBarView];
    [self setPowerCollectBallView];
    powerCollectBallView.hidden = YES;
    countDownDateBeginView.hidden = YES;
    [self getUserInvateFrend];
    [self requestDataFromServer];
    [self eventCountToServerWithClickType:@"home"];
}

-(void)setheaderView{
    self.title = @"全民挖矿";
    ballImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ballImageView"]];
    ballImageView.userInteractionEnabled = YES;
    ballImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH   , SCALE_W(603) );
    [self.view addSubview:ballImageView];
    self.view.backgroundColor = BHHexColor(@"11111B");
    
    UIImageView *alpaCalcuImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleBgView"]];
    alpaCalcuImageview.frame = CGRectMake(16, 30, SCALE_W(211) , SCALE_W(24));
    alpaCalcuImageview.userInteractionEnabled = YES;
    [ballImageView addSubview:alpaCalcuImageview];
    
    UIView *caculateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCALE_W(97) , SCALE_W(24))];
    caculateBgView.backgroundColor = BHHexColorAlpha(@"308CDD", 0.5);
    caculateBgView.layer.cornerRadius = 12;
    caculateBgView.layer.masksToBounds = YES;
    caculateBgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapShareView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoEnergy:)];
    [caculateBgView addGestureRecognizer:tapShareView];
    [alpaCalcuImageview addSubview:caculateBgView];
    
    UIImageView *caculateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caculateIcon"]];
    caculateImage.frame = CGRectMake(11, 3, SCALE_W(18), SCALE_W(18));
    [caculateBgView addSubview:caculateImage];
    
    caculateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(31), 0, caculateBgView.width -(SCALE_W(31)), caculateBgView.height)];
    caculateLabel.textColor = BHHexColor(@"FFFFFF");
    caculateLabel.font = UIFontRegularOfSize(SCALE_W(14));
    caculateLabel.textAlignment = NSTextAlignmentLeft;
    [caculateBgView addSubview:caculateLabel];
    
    UIImageView *bteImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bteIcon"]];
    bteImageview.frame = CGRectMake(caculateBgView.right+12, 3, SCALE_W(18), SCALE_W(18));
    [alpaCalcuImageview addSubview:bteImageview];
    
    coinNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(bteImageview.right +4, 0, alpaCalcuImageview.width -(bteImageview.right +4), caculateBgView.height)];
    coinNumLabel.textColor = BHHexColor(@"FFFFFF");
    coinNumLabel.font = UIFontRegularOfSize(SCALE_W(13));
    coinNumLabel.textAlignment = NSTextAlignmentCenter;
    [alpaCalcuImageview addSubview:coinNumLabel];
    
    UIButton *walletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    walletBtn.frame = CGRectMake(caculateBgView.right, 0, alpaCalcuImageview.width - caculateBgView.right, alpaCalcuImageview.height);
    [walletBtn addTarget:self action:@selector(gotoMyWallet) forControlEvents:UIControlEventTouchUpInside];
    [alpaCalcuImageview addSubview:walletBtn];
    
    
    UIButton *poolImageView = [[UIButton alloc] init];
    [poolImageView setBackgroundImage:[UIImage imageNamed:@"ruleBgIcon"] forState:UIControlStateNormal];
    poolImageView.frame = CGRectMake(SCREEN_WIDTH - SCALE_W(109), 30, SCALE_W(109) , SCALE_W(24));
    poolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCALE_W(109) -16, caculateBgView.height)];
    poolLabel.textColor = BHHexColor(@"FFFFFF");
    poolLabel.font = UIFontRegularOfSize(SCALE_W(11));
    poolLabel.textAlignment = NSTextAlignmentRight;
    
    [poolImageView addSubview:poolLabel];
    [ballImageView addSubview:poolImageView];
    
    
    UIButton *ruleImageView = [[UIButton alloc] init];
    [ruleImageView setBackgroundImage:[UIImage imageNamed:@"ruleBgIcon"] forState:UIControlStateNormal];
    ruleImageView.frame = CGRectMake(SCREEN_WIDTH - SCALE_W(109), 74, SCALE_W(109) , SCALE_W(24));
    [ruleImageView addTarget:self action:@selector(gotoRule) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCALE_W(48), caculateBgView.height)];
    ruleLabel.textColor = BHHexColor(@"FFFFFF");
    ruleLabel.font = UIFontRegularOfSize(SCALE_W(12));
    ruleLabel.textAlignment = NSTextAlignmentLeft;
    ruleLabel.text = [NSString stringWithFormat:@"挖矿规则"];
    [ruleImageView addSubview:ruleLabel];
    UIImageView *arrowImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dugArrowIcon"]];
    arrowImageview.frame = CGRectMake(ruleImageView.width - SCALE_W(13)- 8, SCALE_W(6.5), SCALE_W(13) , SCALE_W(11));
    [ruleImageView addSubview:arrowImageview];
    [ballImageView addSubview:ruleImageView];
    
    [self setCountDownView];
    
    UIImageView *volumeImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"volumeImagIcon"]];
     volumeImageView.frame = CGRectMake(16, countDownDateBeginView.bottom + 53, SCALE_W(12), SCALE_W(12));
    [self.view addSubview:volumeImageView];
    
    messageLabel = [[SKAutoScrollLabel alloc] initWithFrame:CGRectMake(36,
                                                                       countDownDateBeginView.bottom + 53, SCREEN_WIDTH*2/3, SCALE_W(12))];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.textColor = BHHexColor(@"DDE0ED");
    messageLabel.font = UIFontRegularOfSize(SCALE_W(12));
    messageLabel.direction = SK_AUTOSCROLL_DIRECTION_LEFT;
    messageLabel.text = [NSString stringWithFormat:@""];
    [ballImageView addSubview:messageLabel];
    
    
    UIImageView *caculateImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caculateImage"]];
    caculateImage1.frame = CGRectMake(16, countDownDateBeginView.bottom +91, SCALE_W(22), SCALE_W(23));
    [ballImageView addSubview:caculateImage1];
    
    UILabel *subTitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(46,  countDownDateBeginView.bottom +93, SCALE_W(64), SCALE_W(16))];
    subTitleLabel.textColor = BHHexColor(@"FFFFFF");
    subTitleLabel.font = UIFontRegularOfSize(SCALE_W(14));
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    subTitleLabel.text = [NSString stringWithFormat:@"算力提升"];
    [ballImageView addSubview:subTitleLabel];
    
    UIButton *missionBtn = [[UIButton alloc] init];
    missionBtn.backgroundColor = [UIColor clearColor];
    missionBtn.frame = CGRectMake(SCREEN_WIDTH - SCALE_W(48+31),  countDownDateBeginView.bottom +97, SCALE_W(48+31) , SCALE_W(12));
    [missionBtn addTarget:self action:@selector(gotoMission:) forControlEvents:UIControlEventTouchUpInside];
    [ballImageView addSubview:missionBtn];
    
    UILabel *missionLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0,  0, SCALE_W(48), SCALE_W(12))];
    missionLabel.textColor = BHHexColor(@"FFFFFF");
    missionLabel.font = UIFontRegularOfSize(SCALE_W(12));
    missionLabel.textAlignment = NSTextAlignmentLeft;
    missionLabel.text = [NSString stringWithFormat:@"固定任务"];
    [missionBtn addSubview:missionLabel];
    
    UIImageView *arrowImageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dugArrowIcon"]];
    arrowImageview1.frame = CGRectMake(missionBtn.width - SCALE_W(13)- 8, SCALE_W(0.5), SCALE_W(13) , SCALE_W(11));
    [missionBtn addSubview:arrowImageview1];
}

-(void)setTaskTabBarView{
    UIView *bgview = [UIView new];
    bgview.backgroundColor = [UIColor clearColor];
    bgview.frame = CGRectMake(16,countDownDateBeginView.bottom + 135, SCREEN_WIDTH - 32, 96);
    [self.view addSubview:bgview];
    
    UIButton *btn;
    UILabel *desLabel;
    UILabel *titleLabel;
    UIImageView *iconImageView;
    UIImageView *lineImageView;
    for(int i = 0; i < 4 ;i++){
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        
        titleLabel = [[UILabel alloc] init];
        desLabel = [[UILabel alloc] init];
        iconImageView = [[UIImageView alloc] init];
        lineImageView = [[UIImageView alloc] init];
        [bgview addSubview:btn];
        [btn addSubview:titleLabel];
        [btn addSubview:desLabel];
        [btn addSubview:iconImageView];
//        [btn addSubview:lineImageView];
        
//        btn.backgroundColor = BHHexColor(@"262754");
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 3;
        btn.frame = CGRectMake(
                               12*i+i*(SCREEN_WIDTH -32 -3*12)/4,
                               0,
                               (SCREEN_WIDTH -32 -3*12)/4,
                               96);
        iconImageView.frame = CGRectMake(0, 0,  btn.width, 52);
        titleLabel.frame = CGRectMake(0 , SCALE_W(53), btn.width, SCALE_W(12));
        lineImageView.frame = CGRectMake(0 , btn.height -2, btn.width, 2);
        titleLabel.font = UIFontLightOfSize(SCALE_W(12));
        titleLabel.textColor = BHHexColor(@"FFFFFF");
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (i ==0) {
            titleLabel.text = @"邀请好友";
            iconImageView.image = [UIImage imageNamed:@"inviteIcon"];
            [btn setBackgroundImage:[UIImage imageNamed:@"mission1"] forState:UIControlStateNormal];
//            lineImageView.image = [UIImage imageNamed:@"greenLine"];
        }
        if (i ==1) {
            titleLabel.text = @"连续签到";
            iconImageView.image = [UIImage imageNamed:@"signIcon_normal"];
             [btn setBackgroundImage:[UIImage imageNamed:@"mission2"] forState:UIControlStateNormal];
//            lineImageView.image = [UIImage imageNamed:@"yellowLine"];
        }
        if (i ==2) {
            titleLabel.text = @"每日分享";
            iconImageView.image = [UIImage imageNamed:@"shared_normal"];
            [btn setBackgroundImage:[UIImage imageNamed:@"mission3"] forState:UIControlStateNormal];
            //            lineImageView.image = [UIImage imageNamed:@"pinkLine"];
        }
        if (i ==3) {
            reportTitleLabel = titleLabel;
            repoertIconImageView = iconImageView;
            titleLabel.text = @"阅读报告";
            iconImageView.image = [UIImage imageNamed:@"readIcon_normal"];
            [btn setBackgroundImage:[UIImage imageNamed:@"mission4"] forState:UIControlStateNormal];
//            lineImageView.image = [UIImage imageNamed:@"orangeLine"];
        }
        
        desLabel.frame = CGRectMake(0 , 75, btn.width, SCALE_W(18));
        desLabel.backgroundColor  = [UIColor clearColor];
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.font = UIFontSemiboldOfSize(SCALE_W(14));
        desLabel.textColor =  BHHexColorAlpha(@"FFFFFF",1);
        
        
        [self.deslabelArray addObject:desLabel];
        
        [btn addTarget:self action:@selector(doFinishMission:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setCountDownView{
    countDownDateBeginView = [UIView new];
    countDownDateBeginView.frame = CGRectMake((SCREEN_WIDTH -SCALE_W(256))/2, 113, SCALE_W(256), SCALE_W(256));
    countDownDateBeginView.backgroundColor = [UIColor clearColor];
    [ballImageView addSubview:countDownDateBeginView];
    
    UIButton *prButton;
    UILabel *BNumLabel;
    for(int i = 0; i < 1 ;i++){
        BNumLabel = [[UILabel alloc] init];
        BNumLabel.font = UIFontRegularOfSize(12);
        BNumLabel.textAlignment = NSTextAlignmentCenter;
        BNumLabel.textColor =  BHHexColorAlpha(@"FFFFFF",1);
        BNumLabel.text = @"00000000000000";
        [BNumLabel sizeToFit];
        BNumLabel.size = CGSizeMake(BNumLabel.width, BNumLabel.height);
        prButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
        prButton.enabled = NO;
        prButton.titleLabel.font = UIFontDINAlternateOfSize(12);
        prButton.titleLabel.textColor =BHHexColorAlpha(@"FFFFFF",1);
        [prButton setBackgroundImage:[UIImage imageNamed:@"coinImageView"] forState:UIControlStateNormal];
        CGPoint point = [self generateCenterPointInRadar];
        prButton.center = CGPointMake(point.x, point.y);
        BNumLabel.center = CGPointMake(point.x, point.y +BNumLabel.height+10);
        
        [countDownDateBeginView addSubview:BNumLabel];
        [countDownDateBeginView addSubview:prButton];
        prButton.tag = 200000+i;
//        BNumLabel.tag = 200000+i;
        if (i == 0) {
            btcNumLabel1 = BNumLabel;
            btcButton1 = prButton;
        }
//        if (i == 1) {
//            btcBNumLabel2 = BNumLabel;
//            [prButton setBackgroundImage:[UIImage imageNamed:@"coinImageViewTime"] forState:UIControlStateNormal];
//            btcButton2 = prButton;
//        }
        [prButton addTarget:self action:@selector(collectmoney:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setPowerCollectBallView{
    powerCollectBallView = [UIView new];
    powerCollectBallView.frame = CGRectMake((SCREEN_WIDTH -SCALE_W(256))/2, 113, SCALE_W(256), SCALE_W(256));
    powerCollectBallView.backgroundColor = [UIColor clearColor];
    [ballImageView addSubview:powerCollectBallView];
    
    UILabel *dugTitleLabel = [UILabel new];
    dugTitleLabel.frame = CGRectMake(0, 65, powerCollectBallView.width, 18);
    dugTitleLabel.font = UIFontMediumOfSize(18);
    dugTitleLabel.textAlignment = NSTextAlignmentCenter;
    dugTitleLabel.textColor = [UIColor whiteColor];
    dugTitleLabel.text = @"距挖矿开始还有";
    [powerCollectBallView addSubview:dugTitleLabel];
    
    timeLabel = [UILabel new];
    timeLabel.frame = CGRectMake(0, 109, powerCollectBallView.width, 26);
    timeLabel.font = UIFontMediumOfSize(26);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    [powerCollectBallView addSubview:timeLabel];
    
    dateLabel = [UILabel new];
    dateLabel.frame = CGRectMake(0, 159, powerCollectBallView.width, 12);
    dateLabel.font = UIFontMediumOfSize(12);
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    
    [powerCollectBallView addSubview:dateLabel];
    
    UILabel *subLabel = [UILabel new];
    subLabel.frame = CGRectMake(0, powerCollectBallView.height - 12 - 57, powerCollectBallView.width, 12);
    subLabel.font = UIFontMediumOfSize(12);
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.textColor = [UIColor whiteColor];
    subLabel.text = @"现在您可正常做算力任务";
    [powerCollectBallView addSubview:subLabel];
}

-(CGPoint)generateCenterPointInRadar{
    double angle = arc4random()%360;
    double radius = ((NSInteger)arc4random()) % ((NSInteger)((countDownDateBeginView.width - itemSize.width)/2));
    double x = cos(angle) * radius;
    double y = sin(angle) * radius;
    return CGPointMake(x + countDownDateBeginView.width/2, y + countDownDateBeginView.height/2);
}

-(void)gotoMission:(UIButton *)sender{
//    MissionViewController *vc = [[MissionViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
    webVc.urlString = [NSString stringWithFormat:@"%@",kAppMissionlistAddress];
    webVc.isHiddenLeft = NO;
    webVc.isHiddenBottom = NO;
    [self.navigationController pushViewController:webVc animated:YES];
}

-(void)gotoEnergy:(UIGestureRecognizer *)sender{
    [self eventCountToServerWithClickType:@"power"];
    SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
    webVc.urlString = [NSString stringWithFormat:@"%@",kAppMyEnergyAddress];
    webVc.isHiddenLeft = NO;
    webVc.isHiddenBottom = NO;
    [self.navigationController pushViewController:webVc animated:YES];
}

-(void)gotoMyWallet{
    [self eventCountToServerWithClickType:@"income"];
    SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
    webVc.urlString = [NSString stringWithFormat:@"%@",kAppMyWalletAddress];
    webVc.isHiddenLeft = NO;
    webVc.isHiddenBottom = NO;
    [self.navigationController pushViewController:webVc animated:YES];
}

-(void)gotoRule{
    [self eventCountToServerWithClickType:@"rule"];
    [DugRuleActivityView popActivateNowCallBack:^{} cancelCallBack:^{} withUrl:rule];
}

-(void)doFinishMission:(UIButton *)sender{
    if (sender.tag ==0) {
        [self eventCountToServerWithClickType:@"invite"];
        SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
        webVc.urlString = [NSString stringWithFormat:@"%@",kAppMyInviteRecordAddress];
        webVc.invteCodeStr = invteCodeStr;
        webVc.idStr = infoObject.id;
        webVc.isHiddenLeft = NO;
        webVc.isHiddenBottom = NO;
        [self.navigationController pushViewController:webVc animated:YES];
    }
    if (sender.tag ==1) {
        if ([taskItem.sign intValue] != 0) {
            [self checkin];
        }
    }
    if (sender.tag ==2) {
        [SharedDugView popShareViewCallBack:^{
            [self getDigInfo];
            [self digScheduleInfo];
            
        } imageUrl:[UIImage imageNamed:@"share_icon"] shareUrl:@"" sharetitle:@"" shareDesc:@"" shareType:UMSHAREPic_TYPE_IMAGE currentVc:self WithQrImage:decodedImage WithInviteCode:invteCodeStr WithDugNum:infoObject.id];
    }
    if (sender.tag ==3) {
        if ([taskItem.read intValue]> 0) {
            if ([taskItem.reportStatus intValue]> 0) {
                if ( ![@"" isEqualToString:stringFormat(taskItem.reportUrl)]) {
                    SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
                    webVc.urlString = [NSString stringWithFormat:@"%@",taskItem.reportUrl];
                    webVc.isHiddenLeft = NO;
                    webVc.isHiddenBottom = NO;
                    [self.navigationController pushViewController:webVc animated:YES];
                }
            }
        }else{
            if (![@"" isEqualToString:stringFormat(taskItem.reportUrl)]) {
                SecondaryLevelWebViewController *webVc= [[SecondaryLevelWebViewController alloc] init];
                webVc.urlString = [NSString stringWithFormat:@"%@",taskItem.reportUrl];
                webVc.isHiddenLeft = NO;
                webVc.isHiddenBottom = NO;
                [self.navigationController pushViewController:webVc animated:YES];
            }else{
                [BHToast showMessage:@"还没有生成报告,请耐心等待"];
            }
        }
    }
}

-(void)collectmoney:(UIButton *)sender{
//    sender.hidden = YES;
    
    // status -2 活动暂停 前端控制无法操作即可
    // status  0 活动未开始 获取digStart进行倒计时
    // status  1 算力收集中 获取digStart进行倒计时
    // status  2 挖矿 获取income显示收益信息，可点击获取
//    if (status == 1) {
//        sender.enabled = NO;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
//        NSDate *endDate_tomorrow = [formatter dateFromString:nextDigStart];
//        NSLog(@"endDate_tomorrow-%@",endDate_tomorrow);
//
//        NSDate *startDate = [NSDate date];
////        NSString *timeString= [formatter stringFromDate:startDate];
////         NSLog(@"timeString-%@",timeString);
////
////        NSDate *beginDate  = [formatter dateFromString:timeString];
//
//        NSLog(@"beginDate-%@",startDate);
//        [self forBTCButton:sender WithFinishDateTime:endDate_tomorrow WithStartDateTime:startDate];
//
//    }
    
    if( status == 2){
        [self getDigPower];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self digScheduleInfo];
    [self getDigInfo];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    dispatch_source_cancel(_timer1);
    _timer1 = nil;
//    dispatch_source_cancel(_timer);
    _timer = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)startDugWithBegin:(NSDate *)beginDate WithEnd:(NSDate *)endDate{
     NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:beginDate];
    if (_timer1==nil) {
        __block int timeout = timeInterval; //倒计时时间
        __block NSString *daysStr,*hoursStr,*minutesStr,*secondsStr;
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer1,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer1, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer1);
                    _timer1 = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *dateStr = [NSString stringWithFormat:@"%@%@%@%@",@"0天",@"0时",@"0分",@"0秒"];
                        timeLabel.text = dateStr;
                        powerCollectBallView.hidden = NO;
                        countDownDateBeginView.hidden = YES;
                        [self digScheduleInfo];
                        
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            daysStr = @"";
                        });
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            daysStr = @"";
                        }else{
                           daysStr = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours<10) {
                            hoursStr = [NSString stringWithFormat:@"0%d时",hours];
                        }else{
                            hoursStr = [NSString stringWithFormat:@"%d时",hours];
                        }
                        if (minute<10) {
                            minutesStr = [NSString stringWithFormat:@"0%d分",minute];
                        }else{
                            minutesStr = [NSString stringWithFormat:@"%d分",minute];
                        }
                        if (second<10) {
                            secondsStr = [NSString stringWithFormat:@"0%d秒",second];
                        }else{
                            secondsStr = [NSString stringWithFormat:@"%d秒",second];
                        }
                        NSString *dateStr = [NSString stringWithFormat:@"%@%@%@%@",daysStr,hoursStr,minutesStr,secondsStr];
                        timeLabel.text = dateStr;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer1);
        }
    }
}

-(void)forBTCButton:(UIButton *)tempBtn WithFinishDateTime:(NSDate *)endDate WithStartDateTime:(NSDate *)startDate{
    NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
    __block int timeout = timeInterval; //倒计时时间
//    NSLog(@"timeout-------->%d",timeout);
    __block NSString *daysStr,*hoursStr,*minutesStr
//    ,*secondsStr
    ;
    if (timeout!=0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                _timer = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self digScheduleInfo];
                    
                });
            }else{
                int days = (int)(timeout/(3600*24));
                if (days==0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        daysStr = @"";
                    });
                }
                int hours = (int)((timeout-days*24*3600)/3600);
                int minute = (int)(timeout-days*24*3600-hours*3600)/60;
//                    int second = timeout-days*24*3600-hours*3600-minute*60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (days==0) {
                        daysStr = @"";
                    }else{
                        daysStr = [NSString stringWithFormat:@"%d:",days];
                    }
                    if (hours<10) {
                        hoursStr = [NSString stringWithFormat:@"0%d",hours];
                    }else{
                        hoursStr = [NSString stringWithFormat:@"%d",hours];
                    }
                    if (minute<10) {
                        minutesStr = [NSString stringWithFormat:@"0%d",minute];
                    }else{
                        minutesStr = [NSString stringWithFormat:@"%d",minute];
                    }
//                        if (second<10) {
//                            secondsStr = [NSString stringWithFormat:@"0%d",second];
//                        }else{
//                            secondsStr = [NSString stringWithFormat:@"%d",second];
//                        }
                       
                    [tempBtn setBackgroundImage:[UIImage imageNamed:@"coinImageViewTime"] forState:UIControlStateNormal];
                    NSMutableString *t = [[NSMutableString alloc] init];
                    if (days!=0) {
                        [t appendString:daysStr];
                    }
                    NSString *dateStr = [NSString stringWithFormat:@"%@:%@",hoursStr,minutesStr];
                    [t appendString:dateStr];
//                    NSLog(@"hoursStr---------->%@",hoursStr);
//                     NSLog(@"minutesStr---------->%@",minutesStr);
                    [tempBtn setTitle:t forState:UIControlStateNormal];
                    tempBtn.enabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}

-(NSMutableArray *)deslabelArray{
    if(_deslabelArray == nil){
        _deslabelArray = [NSMutableArray array];
    }
    return _deslabelArray;
}

/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
-(NSDate *)getyyyyMMddHHmmss:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *endDate_tomorrow = [formatter dateFromString:dateStr];
    return endDate_tomorrow;
}

//挖矿 矿活动配置信息
-(void)requestDataFromServer{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:kGetUserInvateFrendUrl forKey:@"url"];
    
    methodName = kDigConfigInfo;
    
    //    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:1 success:^(id responseObject) {
        NMRemovLoadIng;
        NSLog(@"kDigConfigInfo-------->%@",responseObject);
        
        if (IsSafeDictionary(responseObject)) {
            NSString *ruleStr =  [[responseObject objectForKey:@"data"] objectForKey:@"rule"];
//            rule = [ruleStr stringByReplacingOccurrencesOfString:@"|" withString:@"\n"options:NSCaseInsensitiveSearch range:NSMakeRange(0, ruleStr.length)];
            NSMutableString *ruleMutableStr = [[NSMutableString alloc] init];
            NSArray *ruleArray = [ruleStr componentsSeparatedByString:@"|"];
            if (ruleArray && ruleArray.count > 0) {
                for (int i = 0; i< ruleArray.count; i++) {
                    NSString *tempStr = [NSString stringWithFormat:@"%d,%@%@",i+1,ruleArray[i],@"\n"];
                    [ruleMutableStr appendString:tempStr];
                }
            }
            rule = ruleMutableStr;
            
            
            
            
            startTime =  [[responseObject objectForKey:@"data"] objectForKey:@"start"];
            dateLabel.text = [NSString stringWithFormat:@"开始时间：%@",startTime];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//挖矿 算力签到
- (void)checkin{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"terminal"];
    methodName = kDigSign;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSLog(@"kCheckin-->%@",responseObject);
            [weakSelf reloadSignAcvity];
            [weakSelf digScheduleInfo];
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)reloadSignAcvity{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"terminal"];
    methodName = kGetDigInfo;
    
    //    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
//            NSLog(@"getDigInfo-->%@",responseObject);
            taskItem = [TaskItem yy_modelWithDictionary:responseObject[@"data"][@"task"]];
            infoObject = [InfoObject yy_modelWithDictionary:responseObject[@"data"][@"info"]];
            caculateLabel.text = [NSString stringWithFormat:@"算力:%@",infoObject.totalPower];
            coinNumLabel.text = [NSString stringWithFormat:@"%@",infoObject.totalIncome];
            UILabel *label0 =  self.deslabelArray[0];
            label0.text =[NSString stringWithFormat:@"+%@",taskItem.invite];
            
            UILabel *label1 =  self.deslabelArray[1];
            if ([taskItem.sign intValue] != 0) {
                label1.text = [NSString stringWithFormat:@"+%@",taskItem.sign];
                label1.font = UIFontSemiboldOfSize(SCALE_W(14));
            }else{
                label1.text = [NSString stringWithFormat:@"已连续签到%@天",infoObject.signStatus];
                label1.font = UIFontSemiboldOfSize(SCALE_W(10));
            }
            [SignActivity popActivateNowCallBack:^{} cancelCallBack:^{} withContinuityDayNum:infoObject.signStatus];
//            UILabel *label2 =  self.deslabelArray[2];
//            if ([taskItem.share intValue] != 0) {
//                label2.text = [NSString stringWithFormat:@"+%@",taskItem.share];
//                label2.font = UIFontSemiboldOfSize(SCALE_W(14));
//            }else{
//                label2.text = [NSString stringWithFormat:@"今日已分享"];
//                label2.font = UIFontSemiboldOfSize(SCALE_W(10));
//            }
//
//            UILabel *label3 = self.deslabelArray[3];
//            if ([taskItem.read intValue] != 0) {
//                label3.text = [NSString stringWithFormat:@"+%@",taskItem.read];
//                if ([taskItem.reportStatus intValue]> 0) {
//                    label3.font = UIFontSemiboldOfSize(SCALE_W(14));
//                }else{
//                    label3.font = UIFontLightOfSize(SCALE_W(14));
//                }
//            }else{
//                label3.text = [NSString stringWithFormat:@"今日已阅读"];
//                label3.font = UIFontSemiboldOfSize(SCALE_W(10));
//            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//挖矿 算力领取
-(void)getDigPower{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"terminal"];
    methodName = kGetDigPower;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSLog(@"kGetDigPower-->%@",responseObject);
            [weakSelf digScheduleInfo];
            [weakSelf getDigInfo];
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//挖矿 用户挖矿账户及任务状态信息
-(void)getDigInfo{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"terminal"];
    methodName = kGetDigInfo;
    //    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSLog(@"getDigInfo-->%@",responseObject);
            taskItem = [TaskItem yy_modelWithDictionary:responseObject[@"data"][@"task"]];
            infoObject = [InfoObject yy_modelWithDictionary:responseObject[@"data"][@"info"]];
            caculateLabel.text = [NSString stringWithFormat:@"算力:%@",infoObject.totalPower];
            coinNumLabel.text = [NSString stringWithFormat:@"%@",infoObject.totalIncome];
            UILabel *label0 =  self.deslabelArray[0];
            label0.text =[NSString stringWithFormat:@"+%@",taskItem.invite];
            
            UILabel *label1 =  self.deslabelArray[1];
            if ([taskItem.sign intValue] != 0) {
                 label1.text = [NSString stringWithFormat:@"+%@",taskItem.sign];
                 label1.font = UIFontSemiboldOfSize(SCALE_W(14));
            }else{
                label1.text = [NSString stringWithFormat:@"已连续签到%@天",infoObject.signStatus];
                label1.font = UIFontSemiboldOfSize(SCALE_W(10));
            }
            
            UILabel *label2 =  self.deslabelArray[2];
            if ([taskItem.share intValue] != 0) {
                label2.text = [NSString stringWithFormat:@"+%@",taskItem.share];
                label2.font = UIFontSemiboldOfSize(SCALE_W(14));
            }else{
                label2.text = [NSString stringWithFormat:@"今日已分享"];
                label2.font = UIFontSemiboldOfSize(SCALE_W(10));
            }
            
            UILabel *label3 = self.deslabelArray[3];
            if ([taskItem.read intValue] != 0) {
                label3.text = [NSString stringWithFormat:@"+%@",taskItem.read];
                if ([taskItem.reportStatus intValue]> 0) {
                    label3.font = UIFontSemiboldOfSize(SCALE_W(14));
                     label3.textColor = BHHexColor(@"FFFFFF");
                    reportTitleLabel.textColor = BHHexColor(@"FFFFFF");
                    repoertIconImageView.image = [UIImage imageNamed:@"readIcon_normal"];
                }else{
                     label3.font = UIFontLightOfSize(SCALE_W(14));
                     label3.textColor = BHHexColor(@"707070");
                     reportTitleLabel.textColor =  BHHexColor(@"707070");
                    repoertIconImageView.image = [UIImage imageNamed:@"readIcon_selected"];
                }
            }else{
                label3.text = [NSString stringWithFormat:@"今日已阅读"];
                label3.font = UIFontSemiboldOfSize(SCALE_W(10));
                label3.textColor = BHHexColor(@"FFFFFF");
                reportTitleLabel.textColor = BHHexColor(@"FFFFFF");
                repoertIconImageView.image = [UIImage imageNamed:@"readIcon_normal"];
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//挖矿 挖矿活动进度信息
-(void)digScheduleInfo{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"terminal"];
    methodName = kDigScheduleInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSLog(@"kDigScheduleInfo-->%@",responseObject);
            status = [[[responseObject objectForKey:@"data"] objectForKey:@"status"] intValue];
            // status -2 活动暂停 前端控制无法操作即可
            // status  0 活动未开始 获取digStart进行倒计时
            // status  1 算力收集中 获取digStart进行倒计时
            // status  2 挖矿 获取income显示收益信息，可点击获取
            if (status==1) {
                powerCollectBallView.hidden = YES;
                countDownDateBeginView.hidden = NO;
                digStartStr= [[responseObject objectForKey:@"data"] objectForKey:@"digStart"];
                btcButton1.enabled = NO;
                [btcButton1 setBackgroundImage:[UIImage imageNamed:@"coinImageView"] forState:UIControlStateNormal];
                btcNumLabel1.text = @"";
                NSDate *endDate_tomorrow= [self getyyyyMMddHHmmss:digStartStr];
                
                NSDate *startDate = [NSDate date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval = [zone secondsFromGMTForDate: startDate];
                NSDate *localeNowDate = [startDate  dateByAddingTimeInterval: interval];
                [weakSelf forBTCButton:btcButton1 WithFinishDateTime:endDate_tomorrow WithStartDateTime:localeNowDate];
                 btcNumLabel1.text = @"挖矿中";
            }else if(status==0){
                powerCollectBallView.hidden = NO;
                countDownDateBeginView.hidden = YES;
                btcButton1.enabled = NO;
                [btcButton1 setBackgroundImage:[UIImage imageNamed:@"coinImageViewTime"] forState:UIControlStateNormal];
                 btcNumLabel1.text = @"";
                // 倒计时的时间
                NSString *notStartTime =  [[responseObject objectForKey:@"data"] objectForKey:@"digStart"];
                NSDate *endDate_tomorrow= [self getyyyyMMddHHmmss:notStartTime];
                
                NSDate *startDate = [NSDate date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval = [zone secondsFromGMTForDate: startDate];
                NSDate *localeNowDate = [startDate  dateByAddingTimeInterval: interval];
                [weakSelf startDugWithBegin:localeNowDate WithEnd:endDate_tomorrow];
               
            }else if(status == 2){
                powerCollectBallView.hidden = YES;
                countDownDateBeginView.hidden = NO;
                [btcButton1 setTitle:@"" forState:UIControlStateNormal];
                [btcButton1 setBackgroundImage:[UIImage imageNamed:@"coinImageView"] forState:UIControlStateNormal];
                btcButton1.enabled = YES;
                NSString *incomeStr = [NSString stringWithFormat:@"%f",[[[responseObject objectForKey:@"data"]  objectForKey:@"income"] floatValue]];
                btcNumLabel1.text = incomeStr;
            }
            NSString *poolstr = [NSString stringWithFormat:@"%.2f",[[[responseObject objectForKey:@"data"]  objectForKey:@"amount"] floatValue]];
            
            poolLabel.text = [NSString stringWithFormat:@"奖励池:%@BTC",poolstr];
            messageLabel.text = [[responseObject objectForKey:@"data"] objectForKey:@"message"];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

//生成指定二维码
- (void)getUserInvateFrend{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@?inviteCode=%@",kDigInvateFrendUrl,self.invteCodeStr];
    [pramaDic setObject:kDigInvateFrendUrl forKey:@"url"];
    
    methodName = kGetHomePageUserInvateFrend;
    
    //    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        //        NSLog(@"kGetUserInvateFrend-------->%@",responseObject);
        
        if (IsSafeDictionary(responseObject)) {
            NSDictionary *dicInvate = [responseObject objectForKey:@"data"];
            
            if (dicInvate) {
                NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:[dicInvate objectForKey:@"base64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                decodedImage = [UIImage imageWithData:decodedImageData];
                invteCodeStr = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"][@"inviteCode"]];
            }
            //            NSLog(@"invteCodeStr-------->%@",invteCodeStr);
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}


/**
 服务器 挖矿活动埋点统计

 @param tagetStr 挖矿 点击事件种类 如 首页 open 钱包 邀请
 */
-(void)eventCountToServerWithClickType:(NSString *)tagetStr{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:@"ios" forKey:@"channel"];
    [pramaDic setObject:@"dig" forKey:@"module"];
    [pramaDic setObject:@"click" forKey:@"type"];
    [pramaDic setObject:tagetStr forKey:@"target"];
    methodName = kEventCount;
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        NSLog(@"kEventCount----%@---->%@",tagetStr,responseObject);
//        if (IsSafeDictionary(responseObject)) {
//        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}


@end
