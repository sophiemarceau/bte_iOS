//
//  PersonalSettingViewController.m
//  BTE
//
//  Created by sophie on 2018/9/17.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "UIImage+fixOrientation.h"
#import "FileUploadHelper.h"
#import "AlertView.h"
#import "AddAttentionView.h"
#import <UMShare/UMShare.h>
#import "SetPwdViewController.h"
#import "OSSFileHelper.h"
#import "WXApi.h"
#import "TOCropViewController.h"
#import "UIImageView+WebCache.h"
#import "WXApiManager.h"
@interface PersonalSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WXApiManagerDelegate,TOCropViewControllerDelegate,pwdReturnDelegate>{
    UIImageView *headImageView;
    UILabel *nickLabel;
    UILabel *wechatlabel;
    UILabel *pwdLabel;
    NSString *headPicStr;
    NSString *telStr;
    NSString *nickNameStr;
    Boolean isBundleWechat;
    Boolean isSetPWD;
    NSString *headPicNAmeStr;
    NSString *bucketName,*EndPointstr;
    OSSFederationToken *token;
    NSURL *refURL;
    NSString *emailStr;
}
@property (nonatomic,retain) UITableView *setTableView;//个人中心设置
@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle; //The cropping style
@property (nonatomic, strong) UIImage *image;
@end

@implementation PersonalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    headPicStr = @"";
    telStr = @"";
    nickNameStr = @"";
    isBundleWechat = NO;
    isSetPWD = NO;
    self.title = @"个人设置";
    [self initSubViews];
    [self getUserInfo];
    [WXApiManager sharedManager].delegate = self;
}

-(void)initSubViews{
    [self.view addSubview:self.setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getUserInfo{
    //接口调用
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        [pramaDic setObject:User.userToken forKey:@"token"];
    }
    methodName = kGetUserInfoV2;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//        NSLog(@"kGetUserInfoV2-------->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (data) {
                telStr =  stringFormat([data objectForKey:@"tel"]);
                headPicNAmeStr = [data objectForKey:@"inviteCode"];
                nickNameStr = stringFormat([data objectForKey:@"name"]);
                emailStr = stringFormat([data objectForKey:@"email"]);
               
                headPicStr = stringFormat([data objectForKey:@"avator"]);
                isBundleWechat = [[data objectForKey:@"wxBindStatus"] intValue];
                isSetPWD = [[data objectForKey:@"reset"] intValue];
//                NSLog(@"kGetUserInfoV2-----emailStr--->%@",emailStr);
                if (isBundleWechat) {
                    wechatlabel.text = @"已绑定";
                    wechatlabel.textColor = BHHexColor(@"626A75");
                    weakSelf.setTableView.tableHeaderView = nil;
                }else{
                    wechatlabel.text = @"未绑定";
                    wechatlabel.textColor = BHHexColor(@"308CDD");
                    [weakSelf setTableHeadView];
                }
                
                
                if (isSetPWD) {
                    pwdLabel.text = [NSString stringWithFormat:@"%@",@"未设置"];
                }else{
                    pwdLabel.text = @"修改密码";
                }
                [self.setTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)updateUserInfoToServer{
    //接口调用
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        [pramaDic setObject:User.userToken forKey:@"token"];
        [pramaDic setObject:nickNameStr forKey:@"name"];
        [pramaDic setObject:headPicStr forKey:@"avator"];
    }
    methodName = kUpdateUserInfo;
    
    //    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//        NSLog(@"kUpdateUserInfo-------->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            if (data) {
                 nickLabel.text = nickNameStr;
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

- (void)getOSSConfigKey{
    //接口调用
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        [pramaDic setObject:User.userToken forKey:@"token"];
    }
    methodName = kGetOSSConfig;
    
//    WS(weakSelf)
//    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
//        NSLog(@"getOSSConfigKey-------->%@",responseObject);
//        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (data) {
                bucketName = [data objectForKey:@"bucketName"];
                EndPointstr = [data objectForKey:@"endPoint"];
            }
        }
    } failure:^(NSError *error) {
//        NMRemovLoadIng;
//        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(UITableView *)setTableView{
    if (_setTableView == nil) {
        self.setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _setTableView.backgroundColor = KBGColor;
        _setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _setTableView.delegate = self;
        _setTableView.dataSource = self;
        _setTableView.bounces = NO;
        _setTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_setTableView];
    }
    return _setTableView;
}

-(void)setTableHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 73)];
    UIButton *bundleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bundleButton.backgroundColor = BHHexColor(@"#308CDD");
    bundleButton.frame = CGRectMake(16, 16, SCREEN_WIDTH - 32, 40);
    [bundleButton setTitle:@"绑定微信，自动获取头像昵称" forState:UIControlStateNormal];
    bundleButton.titleLabel.font = UIFontRegularOfSize(16);
    bundleButton.layer.masksToBounds = YES;
    bundleButton.layer.cornerRadius = 4;
    [bundleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bundleButton addTarget:self action:@selector(gotoBundleWechatID) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:bundleButton];
    [self.setTableView setTableHeaderView:headView];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 60;
    }else{
        return 44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH/2, 60)];
        label.text = @"头像";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = BHHexColor(@"626A75");
        label.font = UIFontRegularOfSize(14);
        [cell.contentView addSubview:label];
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 36 - 16, 12, 36, 36)];
        headImageView.layer.masksToBounds =YES;
        headImageView.layer.cornerRadius = 16;
        headImageView.layer.borderColor = BHHexColorAlpha(@"626A75",0.5).CGColor;
        
        if (![headPicStr isEqualToString:@""]) {
        }else{
            headPicStr= @"https://file.bte.top/common/avatar/1.png";
        }
        [headImageView sd_setImageWithURL:[NSURL URLWithString:headPicStr] placeholderImage:nil options:SDWebImageRefreshCached];
        [cell.contentView addSubview:headImageView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        return cell;
    } else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 30, 44)];
        label.font = UIFontRegularOfSize(14);
        label.text = @"昵称";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        
        nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2 - 24 - 16, 0, SCREEN_WIDTH/2, 44)];
        nickLabel.font = UIFontRegularOfSize(14);
        nickLabel.textAlignment = NSTextAlignmentRight;
        
        nickLabel.textColor = BHHexColorAlpha(@"626A75",0.5);
        [cell.contentView addSubview:nickLabel];
        
        if (![nickNameStr isEqualToString:@""]) {
            if ([telStr isEqualToString:nickNameStr]) {
                nickLabel.text = nickNameStr = [NSString stringWithFormat:@"%@****%@",[nickNameStr substringToIndex:4],[nickNameStr substringFromIndex:7]];
            }else{
                if ([nickNameStr isValidateEmail]) {
                    NSArray *emailArray = [emailStr componentsSeparatedByString:@"@"];
                    if (emailArray != nil && emailArray.count >0 ) {
                        NSInteger length = [emailArray[0] length];
                        NSString *emailStr = [NSString stringWithFormat:@"%@****%@",[emailArray[0] substringToIndex:1],
                                              [nickNameStr substringFromIndex:length - 1]];
                        nickLabel.text = nickNameStr = emailStr;
                    }
                }else{
                    nickLabel.text = nickNameStr;
                }
            }
        }else{
            NSArray *emailArray = [emailStr componentsSeparatedByString:@"@"];
            if (emailArray != nil && emailArray.count >0 ) {
                NSInteger length = [emailArray[0] length];
                NSString *emailStr = [NSString stringWithFormat:@"%@****%@@%@",[emailArray[0] substringToIndex:1],
                                      [nickNameStr substringFromIndex:length - 1],emailArray[1]];
                nickLabel.text =  nickNameStr = emailStr;
            }
        }
        
        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
        [cell.contentView addSubview:arrImage];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        return cell;
    }else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 60, 44)];
        label.font = UIFontRegularOfSize(14);
        label.text = @"绑定微信";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        
        wechatlabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 16 - 8 - 16, 15, 120, 14)];
        wechatlabel.font = UIFontRegularOfSize(14);
        wechatlabel.textAlignment = NSTextAlignmentRight;
        wechatlabel.alpha = 0.5;
        wechatlabel.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:wechatlabel];
        
        if (isBundleWechat) {
             wechatlabel.text = @"已绑定";
             wechatlabel.textColor = BHHexColor(@"626A75");
        }else{
             wechatlabel.text = @"未绑定";
             wechatlabel.textColor = BHHexColor(@"308CDD");
        }
      
        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
        [cell.contentView addSubview:arrImage];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        return cell;
    }else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBGCell;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 60, 44)];
        label.font = UIFontRegularOfSize(14);
        label.text = @"登录密码";
        label.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:label];
        
        UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 16 - 8 - 16, 15, 120, 14)];
        pwdLabel.font = UIFontRegularOfSize(14);
        pwdLabel.textAlignment = NSTextAlignmentRight;
        pwdLabel.alpha = 0.5;
        pwdLabel.textColor = BHHexColor(@"626A75");
        [cell.contentView addSubview:pwdLabel];
        
        if (isSetPWD) {
            pwdLabel.text = [NSString stringWithFormat:@"%@",@"未设置"];
        }else{
            pwdLabel.text = @"修改密码";
        }
        
        UIImageView *arrImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 8, 15, 8, 14)];
        arrImage.image = [UIImage imageNamed:@"arrowImageView_icon_sz"];
        [cell.contentView addSubview:arrImage];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = BHHexColor(@"E6EBF0");
        [cell.contentView addSubview:lineView];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self getHeadPicture];
    } else if (indexPath.row == 1){
        AlertView *v = [[AlertView alloc] initAlertView];
        [v setConfirmCallBack:^(BOOL isComplete, NSString *returnStr) {
            if (isComplete) {
                nickNameStr = returnStr;
                [self updateUserInfoToServer];
            }
        }];
    }else if (indexPath.row == 2){
        [self getAuthWithUserInfoFromWechat];
    }else if (indexPath.row == 3){
        SetPwdViewController *vc = [[SetPwdViewController alloc] init];
        vc.delegate = self;
        if([telStr isEqualToString:@""]){
            vc.phoneStr = @"";
            vc.emailStr = emailStr;
        }else{
           vc.phoneStr = telStr;
            vc.emailStr =@"";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)setWPwdSuccess{
    isSetPWD = 0;
    pwdLabel.text = @"修改密码";
    [self.setTableView reloadData];
}

#pragma mark - 图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:image];
    cropController.delegate = self;
    self.image = image;
    
    //If profile picture, push onto the same navigation stack
    if (self.croppingStyle == TOCropViewCroppingStyleCircular) {
        [picker pushViewController:cropController animated:YES];
    } else { //otherwise dismiss, and then present from the main controller
        [picker dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:cropController animated:YES completion:nil];
        }];
    }
    refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Cropper Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController{
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        UIImage *img;
        img =image;
        img = [img fixOrientation];
 
        NSString *fileName = [imageRep filename];
        
//        if (fileName == nil)
//        {
//            // 要上传保存在服务器中的名称
//            // 使用时间来作为文件名 2014-04-30 14:20:57.png
//            // 让不同的用户信息,保存在不同目录中
//            //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            //            // 设置日期格式
//            //            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//            //            NSString *Name = [formatter stringFromDate:[NSDate date]];
//
//            fileName = [NSString stringWithFormat:@"%@%@", headPicNAmeStr,@".jpg"];
//            //            fileName = @"tempcapt.jpg";
//        }else{
//            fileName = [NSString stringWithFormat:@"%@%@", headPicNAmeStr,fileName];
//        }
         fileName = [NSString stringWithFormat:@"%@%@", headPicNAmeStr,@".jpg"];
        //        NSLog(@"fileName--------%@",fileName);
        NSString *localFile = [FileUploadHelper PreUploadImagePath:img AndFileName:fileName];
        if([localFile isEqualToString:@""])
        {
            [BHToast showMessage:@"图片获取失败"];
            return;
        }
        
        //        NSString *pathext = [NSString stringWithFormat:@".%@",[localFile pathExtension]];
        //        pathext = [pathext lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        NSData *imageData = [NSData dataWithContentsOfFile:localFile];
        
//        NSLog(@"localFile = %@",localFile);
        
        NSString *authUrlStr = [NSString stringWithFormat:@"%@?bte-token=%@",kGetOSSauthUrl,User.userToken];
        [[OSSFileHelper fileHelperShareInstance] uploadWithEndPointstr:EndPointstr WithAuthServerUrlStr:authUrlStr WithFileData:imageData WithFilenName:fileName WithbucketName:bucketName callback:^(BOOL isreturnSuccessFlag,NSString *returnpicStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isreturnSuccessFlag) {
                    [headImageView setImage:[UIImage imageWithData:imageData]];
                    
//                    NSLog(@"returnpicStr = %@",returnpicStr);
                    headPicStr = returnpicStr;
                    [self updateUserInfoToServer];
                }
            });
            
        }];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)gotoBundleWechatID{
    [self getAuthWithUserInfoFromWechat];
}

- (void)getHeadPicture{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 8.0f)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *bundleWechatAction;
        if (isBundleWechat) {
        }else{
            bundleWechatAction = [UIAlertAction actionWithTitle:@"获取微信，自动获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self getAuthWithUserInfoFromWechat];
            }];
        }

        UIAlertAction *addPhoneAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //照片来源为相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                [imgPicker setDelegate:self];
                [imgPicker setAllowsEditing:NO];
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imgPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                //            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
                imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
                //                [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
                //            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                [self presentViewController:imgPicker animated:YES completion:nil];
            }
        }];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //照片来源为相册
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:NO];
            self.croppingStyle = TOCropViewCroppingStyleDefault;
            //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
            //            imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
            //            [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
            
            //        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
            [self presentViewController:imgPicker animated:YES completion:nil];
            
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        if (isBundleWechat) {
        }else{
            [bundleWechatAction setValue:BHHexColor(@"308CDD") forKey:@"titleTextColor"];
            [actionSheet addAction:bundleWechatAction];
        }

        [addPhoneAction setValue:BHHexColorAlpha(@"626A75",0.5) forKey:@"titleTextColor"];
        [photoAction setValue:BHHexColorAlpha(@"626A75",0.5)  forKey:@"titleTextColor"];
        [cancelAction setValue:BHHexColor(@"626A75")  forKey:@"titleTextColor"];
       
        [actionSheet addAction:photoAction];
        [actionSheet addAction:addPhoneAction];
        [actionSheet addAction:cancelAction];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}


- (void)getAuthWithUserInfoFromWechat{
//    if ([WXApi isWXAppInstalled]) {
//        JumpToBizWebviewReq *req = [[JumpToBizWebviewReq alloc]init];
//        req.tousrname = kWechatPublicBTEID;
//        //        req.username = kWechatPublicBTEID;/*公众号原始ID*/
//        req.extMsg = @"";
//        [WXApi sendReq:req];
//    } else {
//        [BHToast showMessage:@"请您先安装微信"];
//    }
    if (isBundleWechat) {
        [self requestWechatUnBind];
    }else{
        if ([WXApi isWXAppInstalled]) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = WechatStatueStr;
            [WXApi sendReq:req];
        } else {
            [BHToast showMessage:@"请您先安装微信"];
        }
    }
}

-(void)requestWechatUnBind{
    //接口调用
    NSMutableDictionary *pramaDic = @{}.mutableCopy;
    NSString *methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        [pramaDic setObject:User.userToken forKey:@"token"];
    }
    
    methodName = kGetWXUnBind;
//    NSLog(@"requestWechatUnBind-------->%@",pramaDic);
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
//        NSLog(@"requestWechatUnBind-------->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (data) {
                [BHToast showMessage:@"取消微信绑定"];
                [weakSelf getUserInfo];
                isBundleWechat = 0;
            }
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error----requestWechatUnBind---->%@",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getOSSConfigKey];
//    [self getUserInfo];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    // 向微信请求授权后,得到响应结果
    if ([response.state isEqualToString:WechatStatueStr] && response.errCode == WXSuccess) {
//        NSLog(@"code-------->%@",response.code);
//        NSLog(@"errStr-------->%@",response.errStr);
        
        //接口调用
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString *methodName = @"";
        if (User.userToken) {
            [pramaDic setObject:User.userToken forKey:@"bte-token"];
            [pramaDic setObject:User.userToken forKey:@"token"];
        }
        [pramaDic setObject:response.code forKey:@"code"];
        methodName = kGetWXBind;
         NSLog(@"pramaDic-------->%@",pramaDic);
            WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NSLog(@"kGetWXBind-------->%@",responseObject);
            NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {
                NSDictionary * data = [responseObject objectForKey:@"data"];
                if (data) {
                    [weakSelf getUserInfo];
                }
                AddAttentionView *v = [[AddAttentionView alloc] initAlertView];
                [v setConfirmCallBack:^(BOOL isComplete, NSString *returnStr) {
                    if (isComplete) {
                        
                    }
                }];
            }
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error----kGetWXBind---->%@",error);
        }];
    }
}

@end
