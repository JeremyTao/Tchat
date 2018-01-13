//
//  MKLoginCheckingViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKLoginCheckingViewController.h"
#import "MKTabBarViewController.h"
#import "MKForgetPasswordViewController.h"
#import "MKGradientButton.h"
#import "MKSetGenderViewController.h"
#import "MKSetPortraitViewController.h"
#import "upLoadImageManager.h"

@interface MKLoginCheckingViewController ()<UITextFieldDelegate>
{
    NSString *_codeImageStr;
    BOOL _showCode;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//图片验证码
@property (strong, nonatomic) IBOutlet UIImageView *codeImage;
//文本框
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
//
@property (strong, nonatomic) IBOutlet UILabel *codeBottomLabel;
//
@property (strong, nonatomic) IBOutlet UIImageView *codeImageView;
@property (strong, nonatomic) IBOutlet UIButton *changeImageBtn;
- (IBAction)codeImageClicked:(UIButton *)sender;
//
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forgetHeight;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;


@end

@implementation MKLoginCheckingViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self setNavigationTitle:@"登录"];
//    [self setNavigationBarStyle:NavigationBarStyleBlack];
    [self showCodeTextField:NO codeStr:nil];
    
    [self setGradientView];
    [self.videoView.layer addSublayer:self.avPlayerLayer];
    _nextStepButton.layer.borderWidth = 1.0;
    _nextStepButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.phoneTextField.tag = 1000;
    self.phoneTextField.delegate = self;
    //
    NSDictionary *dict = @{NSForegroundColorAttributeName : RGB_COLOR_HEX(0xcccccc)};
    NSAttributedString *phonePlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:dict];
    self.phoneTextField.attributedPlaceholder = phonePlaceholder;
    //
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:dict];
    self.passwordTextField.attributedPlaceholder = passwordPlaceholder;
    //
    NSAttributedString *codePlaceholder = [[NSAttributedString alloc]initWithString:@"输入验证码" attributes:dict];
    self.codeTextField.attributedPlaceholder = codePlaceholder;
    //
    [_phoneTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_passwordTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
}
- (void)setGradientView {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    gradientLayer.colors = @[(__bridge id)RGB_COLOR_HEX(0x136DF3).CGColor,(__bridge id)RGB_COLOR_HEX(0x845AF7).CGColor];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.gradientView.layer addSublayer:gradientLayer];
    self.gradientView.layer.opacity = 0.3;
}

//限定文本位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1000) {
        //电话号码文本框
        if (textField.text.length + string.length > 11) {
            return NO;
        }
        return YES;
    }  else {
        return YES;
    }
    
}

- (void)textFieldChanged:(UITextField *)textField {
    
}

- (BOOL)checkInfoComplete {
    if (_phoneTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

-(void)showCodeTextField:(BOOL)show codeStr:(NSString *)str{
    
    if (show) {
        self.forgetHeight.constant = 75;
        self.codeImage.hidden = NO;
        self.codeTextField.hidden = NO;
        self.codeBottomLabel.hidden = NO;
        self.codeImageView.hidden = NO;
        //
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        // 将NSData转为UIImage
        UIImage * decodedImage = [UIImage imageWithData: decodeData];
        //
        self.codeImageView.image = decodedImage;
        self.changeImageBtn.hidden = NO;
        
    }else{
        self.forgetHeight.constant = 5;
        self.codeImage.hidden = YES;
        self.codeTextField.hidden = YES;
        self.codeBottomLabel.hidden = YES;
        self.codeImageView.hidden = YES;
        self.changeImageBtn.hidden = YES;
    }
}


- (IBAction)forgetPasswordButtonClicked:(UIButton *)sender {
    MKForgetPasswordViewController *phoneVC = [[MKForgetPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:phoneVC animated:YES];
}

- (IBAction)loginButtonDidClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *phoneNumber = self.phoneTextField.text;
    NSString *password    = [MKTool md5_passwordEncryption:self.passwordTextField.text];
    NSLog(@"登录密码加密 ： %@", password);
    
    if (![MKTool isMobileNumber:phoneNumber]) {
        [MKUtilHUD showAutoHiddenTextHUD:@"请输入正确的手机号" withSecond:2 inView:self.view];
        return;
    }
    
    
    if ([self checkInfoComplete]) {
        [self requestLoginWithPhone:phoneNumber password:password];
    } else {
        [MKUtilHUD showHUD:@"请输入手机号和密码" inView:self.view];
    }
    
#warning remove blow
    
    //2. 跳转到下一步
//    MKTabBarViewController *tabBarVC = [[MKTabBarViewController alloc] init];
//    tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:tabBarVC animated:YES completion:nil];
    
}

#pragma mark - http: 登录
- (void)requestLoginWithPhone:(NSString *)phone password:(NSString *)password {
    
    NSDictionary *param = @{@"phone":phone,
                            @"password": password,
                            @"deviceUUID":deviceUUID,
                            @"code":self.codeTextField.text
                            };
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] loginpost:[NSString stringWithFormat:@"%@%@",WAP_URL,api_paswordLogin] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        NSLog(@"登录 %@",json);
        if (status == 200) {
            //登录成功
            //1. 保存用户token
            NSString *token = json[@"dataObj"][@"token"];
            [[A0SimpleKeychain keychain] setString:token forKey:apiTokenKey];
            
            //获取融云token 线上用户信息
            NSString *rcToken = json[@"dataObj"][@"cloudtoken"];
            NSString *userId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"id"]];
            NSString *name = json[@"dataObj"][@"name"];
            NSString *phone = json[@"dataObj"][@"phone"];
            
            NSString *portrait = [upLoadImageManager judgeThePathForImages:json[@"dataObj"][@"portrail"]];
            
            //NSString *portrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"portrail"]];
            //
            NSString *sex = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"sex"]];
            NSString * userImageStr = json[@"dataObj"][@"portrail"];
            
            //保存融云token
            [[A0SimpleKeychain keychain] setString:rcToken forKey:apiRongCloudToken];
            //本地数据
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userInfo.name"];
            [[NSUserDefaults standardUserDefaults] setObject:portrait forKey:@"userInfo.portraitUri"];
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userInfo.userId"];
            [[NSUserDefaults standardUserDefaults] setObject:userImageStr forKey:@"userInfo.userImageStr"];
            [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"userInfo.phone"];
            //
            RCUserInfo *userInfo  = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:portrait];
            
            [[MKChatTool sharedChatTool] loginRongCloudWithUserInfo:userInfo withToken:rcToken];
            
            //判断用户是否填写性别、头像
            if ([sex intValue] !=1 && [sex intValue]!=2 ) {
                MKSetGenderViewController *genderVC = [[MKSetGenderViewController alloc] init];
                genderVC.addInfo = NO;
                [self.navigationController pushViewController:genderVC animated:YES];
            }
            else if ([userImageStr isEqualToString:@""] || userImageStr.length == 0 || userImageStr == NULL) {
                MKSetPortraitViewController *vc = [[MKSetPortraitViewController alloc] init];
                vc.addInfo = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                //2. 跳转到下一步
                MKTabBarViewController *tabBarVC = [[MKTabBarViewController alloc] init];
                tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:tabBarVC animated:YES completion:nil];
            }
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        if (status == -300) {
            
            _codeImageStr = json[@"dataObj"][@"codeImg"];
            [self showCodeTextField:YES codeStr:_codeImageStr];
            
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
            
    }];
}


- (IBAction)codeImageClicked:(UIButton *)sender {
    
    //0 注册 1 忘记密码 2 设置支付密码 3 登录
    NSDictionary * param = @{@"state":@"3",
                             @"phone":self.phoneTextField.text
                             };
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_changeCodeImage] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"换图片验证码 %@",json);
        
        if (status == 200) {
            
            [self showCodeTextField:YES codeStr:json[@"dataObj"][@"codeImg"]];
            
        }else{
            
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
    }];
}
@end
