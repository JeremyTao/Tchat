//
//  MKForgetPasswordViewController.m
//  Moka
//
//  Created by Knight on 2017/7/24.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKForgetPasswordViewController.h"
#import "JKCountDownButton.h"

@interface MKForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet JKCountDownButton *codeButton; //获取验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
//
@property (strong, nonatomic) IBOutlet UIView *codeBackView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *codeBackViewHeight;
//提示框的长
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noticeHeight;
@property (strong, nonatomic) IBOutlet UITextField *codeImageTextField;
@property (strong, nonatomic) IBOutlet UIImageView *codeImageView;
- (IBAction)changeCodeImageBtn:(UIButton *)sender;

//新密码
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *checkPadTextField;
//完成按钮
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
//提示
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation MKForgetPasswordViewController
{
    NSString *_psdStr;
    NSString *_newPsdStr;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
    [self showImageCode:NO CodeImageStr:nil];
    _noticeLabel.adjustsFontSizeToFitWidth = YES;
    _doneBtn.layer.cornerRadius = 25.0f;
    [_phoneTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}

- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

//完成
- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    
    //手机号判断
    BOOL isPhone = [self checkPhoneNumber];
    if (isPhone) {
        //检查是否有验证码
        BOOL isCode = [self checkCode];
        if (isCode) {
            //判断新密码
            BOOL isPwd = [self checkNewPassword];
            if (isPwd) {
                [self requestChangePassword];
            }
        }
    }
    [self.view endEditing:YES];
    
}

//点击获取验证码
- (IBAction)getCodeButtonClicked:(JKCountDownButton *)sender {
    [self.view endEditing:YES];
    
    BOOL isPhone = [self checkPhoneNumber];
    if (isPhone) {
        //请求验证码
        [self requestVerfiyCode];
        //获取验证码按钮倒计时
        _codeButton.enabled = NO;
        [_codeButton startWithSecond:59];
        [_codeButton setTitle:@"59s" forState:UIControlStateNormal];
        [_codeButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"%ds",second];
            return title;
        }];
        [_codeButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            return @"重新发送";
        }];
    }
    
}


#pragma mark - http - 获取验证码
- (void)requestVerfiyCode {
    
    NSDictionary *param = @{@"phone":_phoneTextField.text , @"state" : @(1)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] loginpost:[NSString stringWithFormat:@"%@%@",WAP_URL,api_sendCode] params:param success:^(id json) {
        
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        NSLog(@"获取验证码%@",json);
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"验证码已发送到你的手机" withSecond:2 inView:self.view];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:self.view];
            [_codeButton stop];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark -- 显示图片验证码
-(void)showImageCode:(BOOL)show CodeImageStr:(NSString *)codeStr{
    
    if (show) {
        self.codeBackView.hidden = NO;
        self.codeBackViewHeight.constant = 50;
        self.noticeHeight.constant = 55;
        //
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:codeStr options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        // 将NSData转为UIImage
        UIImage * decodedImage = [UIImage imageWithData: decodeData];
        //
        self.codeImageView.image = decodedImage;
        
        
    }else{
        self.codeBackView.hidden = YES;
        self.codeBackViewHeight.constant = 0;
        self.noticeHeight.constant = 5;
    }
}


#pragma mark -- 手机号判断
-(BOOL)checkPhoneNumber{
    if (_phoneTextField.text.length < 11) {
        [MKUtilHUD showAutoHiddenTextHUD:@"手机号输入有误" withSecond:2 inView:self.view];
        return NO;
    }
    if (_phoneTextField.text.length == 0) {
        [MKUtilHUD showAutoHiddenTextHUD:@"手机号不能为空" withSecond:2 inView:self.view];
        return NO;
    }
    return YES;
}
#pragma mark -- 验证码判断
-(BOOL)checkCode{
    if (_codeTextField.text.length == 0) {
        [MKUtilHUD showAutoHiddenTextHUD:@"验证码不能为空" withSecond:2 inView:self.view];
        return NO;
    }
    return YES;
}
#pragma mark -- 新密码
-(BOOL)checkNewPassword{
    _psdStr = _pwdTextField.text;
    _newPsdStr = _checkPadTextField.text;
    //
    if (![_psdStr isEqualToString:_newPsdStr]) {
        [MKUtilHUD showAutoHiddenTextHUD:@"两次输入的密码不一致" inView:self.view];
        return NO;
    }
    if (_psdStr.length < 6) {
        [MKUtilHUD showAutoHiddenTextHUD:@"密码长度小于6个字符" inView:self.view];
        return NO;
    }
    if ([_psdStr isEqualToString:@""] || [_newPsdStr isEqualToString:@""]) {
        [MKUtilHUD showAutoHiddenTextHUD:@"密码不能为空" inView:self.view];
        return NO;
    }
    return YES;
}


#pragma mark -- 修改密码
- (void)requestChangePassword{
    
    NSString *encryptePassword1 = [MKTool md5_passwordEncryption:_psdStr];
    NSDictionary *param = @{@"phone":_phoneTextField.text,
                            @"code":_codeTextField.text,
                            @"imgCode":self.codeImageTextField.text,
                            @"password": encryptePassword1};
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] loginpost:[NSString stringWithFormat:@"%@%@",WAP_URL,api_forgetPassword] params:param success:^(id json) {
        [MKUtilHUD hiddenHUD:self.view];
        STRONG_SELF;
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        NSLog(@"修改密码 %@",json);
        if (status == 200) {
            //修改密码成功, 返回登陆
            [MKUtilHUD showAutoHiddenTextHUD:@"修改密码成功" withSecond:2 inView:self.view completionBlock:^{
                UIViewController *loginVC = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:loginVC animated:YES];
            }];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        //
        if (status == -300) {
            
            [self showImageCode:YES CodeImageStr:json[@"dataObj"][@"codeImg"]];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);

    }];
    
}


- (IBAction)changeCodeImageBtn:(UIButton *)sender {
    
    //0 注册 1 忘记密码 2 设置支付密码 3 登录
    NSDictionary * param = @{@"state":@"1",
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
            
            [self showImageCode:YES CodeImageStr:json[@"dataObj"][@"codeImg"]];
            
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
