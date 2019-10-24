//
//  AddNickHeaderView.m
//  BTE
//
//  Created by sophie on 2018/7/17.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "AddNickHeaderView.h"
#import "HeadGridView.h"
#import "UserCacheManager.h"

@interface AddNickHeaderView ()<UITextFieldDelegate>{
    UIImageView *bgwhiteView;
    UIButton  *confirmBtn;
    UIImageView  *headView;
    UIButton  *cancelBtn;
    UITextField *nickNameTextFiled;
    NSString *nickNameStr;
    NSArray *headArray;
    NSString *selectHeadStrFlag;
    
}
@property(nonatomic,strong) HeadGridView *gridView;
@end

@implementation AddNickHeaderView
- (instancetype)initAddNickHeadView{
    self = [super init];
    if (self) {
        nickNameStr =@"";
        selectHeadStrFlag = @"";
        self.userInteractionEnabled  = YES;
        self.backgroundColor = kColorRgba(0, 0, 0, 0.5);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView:)];
//        [self addGestureRecognizer:tap1];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
        
        bgwhiteView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 316) / 2, 121 , 316, 408)];
        
        bgwhiteView.backgroundColor = [UIColor whiteColor];
        bgwhiteView.userInteractionEnabled = YES;
        [self addSubview:bgwhiteView];
        
        headView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 84) / 2, 79, 84, 84)];
        headView.layer.masksToBounds = YES;
//        headView.layer.borderColor = [UIColor colorWithHexString:@"626A75"].CGColor;
//        headView.layer.borderWidth = 1;
        headView.layer.cornerRadius = 84/2;
        headView.backgroundColor = [UIColor grayColor];
        [self addSubview:headView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 316, 17)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = UIFontRegularOfSize(12);
        titleLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        titleLabel.text = @"选择头像";
        [bgwhiteView addSubview:titleLabel];
        
        UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 279, 316, 17)];
        nickLabel.textAlignment = NSTextAlignmentCenter;
        nickLabel.font = UIFontRegularOfSize(12);
        nickLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        nickLabel.text = @"昵称";
        [bgwhiteView addSubview:nickLabel];
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake((SCREEN_WIDTH - 46) / 2, 506, 46, 46);
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"AddHeadConfirmBtn"] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        
        nickNameTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 306, 316, 30)];
        nickNameTextFiled.font = UIFontRegularOfSize(12);
        nickNameTextFiled.returnKeyType = UIReturnKeyDone;
        nickNameTextFiled.delegate = self;
        nickNameTextFiled.textAlignment = NSTextAlignmentCenter;
        [bgwhiteView addSubview:nickNameTextFiled];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(30,nickNameTextFiled.height - 1, 272, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E6EBF0"];
        [nickNameTextFiled addSubview:lineView];
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake((SCREEN_WIDTH - 20 - 24) , 114, 20, 20);
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancelHead"] forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self getUserHeadImage];
        // 键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)cancelClick:(UIButton *)sender{
    if (self.confirmCallBack != nil) {
        self.confirmCallBack(NO,@"");
    }
    [self dismissShareView];
}

- (void)dismissShareView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGRect blackFrame = [self frame];
        blackFrame.origin.y = SCREEN_HEIGHT;
        self.frame = blackFrame;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)AddUserAndRoomHXWith:(UIButton *)sender{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    nickNameStr = nickNameTextFiled.text;
    [pramaDic setObject:self.roomName forKey:@"roomName"];
    [pramaDic setObject:nickNameStr forKey:@"nickName"];
    [pramaDic setObject:selectHeadStrFlag forKey:@"headImage"];
    
    methodName = kAddUserAndRoom;
    NSLog(@"kAddUserAndRoom-------->%@",pramaDic);
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"kAddUserAndRoom-------->%@",responseObject);
        //        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            User.hxuserName =  responseObject[@"data"][@"result"][@"userId"];
            User.hxuserPassword = responseObject[@"data"][@"result"][@"password"];
            User.nickName = responseObject[@"data"][@"result"][@"nickName"];
            NSLog(@"kAddUserAndRoom---hxuserName----->%@",User.hxuserName);
            NSLog(@"kAddUserAndRoom----hxuserPassword---->%@", User.hxuserPassword);
            NSString *chatRoomId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupid"]];
            [[EMClient sharedClient] loginWithUsername:User.hxuserName password:User.hxuserPassword completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                     NSLog(@"chatRoomId------>%@",chatRoomId);
//                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    // 通过消息的扩展属性传递昵称和头像时，需要调用这句代码缓存
                    [UserCacheManager save:User.hxuserName avatarUrl:selectHeadStrFlag nickName:User.nickName];
                    [self dismissShareView];
                    weakSelf.confirmCallBack(YES,chatRoomId);
                }else{
                    NSLog(@"---loginWithUsername--password---aerror--->%@",aError.errorDescription);
                }
            }];
        }
        sender.enabled = YES;
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error----kAddUserAndRoom---->%@",error);
        sender.enabled = YES;
    }];
}


- (void)getUserHeadImage{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    
    methodName = kgetUserHeadImage;
    
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"kgetUserHeadImage----kgetUserHeadImage---->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            headArray = responseObject[@"data"][@"result"];
            if(![headArray isEqual:[NSNull null]] && headArray !=nil){
                [headView sd_setImageWithURL:[NSURL URLWithString:headArray[0]]];
                selectHeadStrFlag = headArray[0];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                [array addObjectsFromArray:headArray];
                [array removeObjectAtIndex:0];
                [weakSelf initHeaderViewWithHeaderArrray: array];
            }
        }
    } failure:^(NSError *error) {
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error----getUserHeadImage---->%@",error);
    }];
}

//- (void)dismissShareView:(UITapGestureRecognizer *)tapgesture{
//    CGPoint tapPoint = [tapgesture locationInView:self];
//    if(!CGRectContainsPoint(bgwhiteView.frame,tapPoint)) {
//        if(CGRectContainsPoint(confirmView.frame, tapPoint)) {
//
//        }else if(CGRectContainsPoint(headView.frame, tapPoint)) {
//
//        }else {
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 self.alpha = 0;
//                                 CGRect blackFrame = [self frame];
//                                 blackFrame.origin.y = SCREEN_HEIGHT;
//                                 self.frame = blackFrame;
//                             }
//                             completion:^(BOOL finished) {
//                                 [self removeFromSuperview];
//                             }];
//        }
//    }
//}

- (void)confirmButtonOnClick:(UIButton *)sender{
    sender.enabled = NO;
    if (nickNameTextFiled.text.length == 0) {
        [BHToast showMessage:@"昵称不能为空"];
        sender.enabled = YES;
        return;
    }
    if (nickNameTextFiled.text.length > 10) {
        [BHToast showMessage:@"昵称字数不得超出10个字"];
        sender.enabled = YES;
        return;
    }
    if ([self stringContainsEmoji:nickNameTextFiled.text]) {
        [BHToast showMessage:@"昵称不得Emoji含有表情"];
         sender.enabled = YES;
        return;
    }
    [self AddUserAndRoomHXWith:sender];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (nickNameTextFiled.text.length != 0) {
        [self changeLoginEnabled:YES];
    }else{
        [self changeLoginEnabled:NO];
    }
    
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification{
    [UIView animateWithDuration:0.2 animations:^{
        self.top = -100;
    }];
}
- (void)keyboardWillBeHiden:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = 0;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
   return [textField resignFirstResponder];
}

#pragma mark  设置头像
- (void) initHeaderViewWithHeaderArrray:(NSArray *)headArray{
    self.gridView = [[HeadGridView alloc] initWithFrame:CGRectMake(0, 113, 316, 92 + 28)];
    [bgwhiteView addSubview:self.gridView];
//    NSArray *gridImages = @[@"i01", @"i02", @"i03", @"i04", @"i05", @"i06", @"i07", @"i08"];
    NSMutableArray *items = [NSMutableArray array];
    [headArray enumerateObjectsUsingBlock:^(NSString *imageNameStr, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeGridItem *item = [HomeGridItem itemWithImage:imageNameStr];
        [items addObject:item];
    }];
    _gridView.items = items;
    [self.gridView setSelectCallBack:^(NSUInteger selectTag) {
        if (selectTag > 0) {
           selectHeadStrFlag = headArray[selectTag - 1];
            NSLog(@"selectHeadFlag--------->%@",selectHeadStrFlag);
            [headView sd_setImageWithURL:[NSURL URLWithString:selectHeadStrFlag]];
        }
    }];
}

#pragma mark - 改变按钮颜色
- (void)changeLoginEnabled:(BOOL)enabled {
    
    [confirmBtn setBackgroundImage:enabled ?[UIImage imageNamed:@"queren"] : [UIImage imageNamed:@"AddHeadConfirmBtn"] forState:UIControlStateNormal];
}

//是否含有表情
-(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
