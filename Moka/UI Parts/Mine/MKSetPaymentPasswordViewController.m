//
//  MKSetPaymentPasswordViewController.m
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSetPaymentPasswordViewController.h"
#import "JKCountDownButton.h"

@interface MKSetPaymentPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet JKCountDownButton *codeButton; //获取验证码按钮

@property (weak, nonatomic) IBOutlet UITextField *passwdTextField1;

@property (weak, nonatomic) IBOutlet UITextField *passwdTextField2;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation MKSetPaymentPasswordViewController

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"设置支付密码"];
    self.title = @"设置支付密码";
    self.navigationController.navigationBar.hidden = NO;
    [self rquestUserInfomation];
    [_codeTextField addTarget:self action:@selector(codeTextFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_passwdTextField1 addTarget:self action:@selector(passwdTextField1Changed:)  forControlEvents:UIControlEventAllEditingEvents];
    [_passwdTextField2 addTarget:self action:@selector(passwdTextField2Changed:)  forControlEvents:UIControlEventAllEditingEvents];
    
}


- (void)rquestUserInfomation {
    NSDictionary *param = nil;
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getUserInfo] params:param success:^(id json) {
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        if (status == 200) {
            
            _phoneTextField.text = json[@"dataObj"][@"phone"];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}



//限定文本位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //电话号码文本框
    if (textField.text.length + string.length > 11) {
        return NO;
    }
    return YES;
    
}


- (void)passwdTextField1Changed:(UITextField *)textField {
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
    [self checkInfoComplete];
}

- (void)passwdTextField2Changed:(UITextField *)textField {
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
    [self checkInfoComplete];
}

- (void)codeTextFieldChanged:(UITextField *)textField {
    if (textField.text.length > 4) {
        textField.text = [textField.text substringToIndex:4];
    }
    [self checkInfoComplete];
}


- (void)checkInfoComplete {
    if (_phoneTextField.text.length > 0 && _codeTextField.text.length > 0 && _passwdTextField1.text.length > 0 && _passwdTextField2.text.length > 0) {
        _nextStepButton.backgroundColor = commonBlueColor;
        _nextStepButton.enabled = YES;
        [MKTool addShadowOnView:_nextStepButton];
    } else {
        _nextStepButton.backgroundColor = buttonDisableColor;
        _nextStepButton.enabled = NO;
        [MKTool removeShadowOnView:_nextStepButton];
    }
}


- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    if(_phoneTextField.text.length < 11)
    {
        [MKUtilHUD showAutoHiddenTextHUD:@"手机号输入有误" withSecond:2 inView:self.view];
        return;
    }
    
    if (![_passwdTextField1.text isEqualToString:_passwdTextField2.text]) {
        [MKUtilHUD showAutoHiddenTextHUD:@"两次输入密码不一致" withSecond:2 inView:self.view];
        return;
    }
    
    if (_passwdTextField1.text.length < 6) {
        [MKUtilHUD showAutoHiddenTextHUD:@"密码必须为6位数字" withSecond:2 inView:self.view];
        return;
    }
    
    
    [self.view endEditing:YES];
    //修改密码
    [self requestModifyPaymentPassword];
}

- (IBAction)getCodeButtonClicked:(JKCountDownButton *)sender {
    [self.view endEditing:YES];
    NSString *name = self.phoneTextField.text;
    
    if(name.length == 0)
    {
        [MKUtilHUD showAutoHiddenTextHUD:@"手机号不能为空" withSecond:2 inView:self.view];
        return;
    }
    if(name.length < 11)
    {
        [MKUtilHUD showAutoHiddenTextHUD:@"手机号输入有误" withSecond:2 inView:self.view];
        return;
    }
    
    
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

#pragma mark - http - 获取验证码

- (void)requestVerfiyCode {
    
    NSDictionary *param = @{@"phone":_phoneTextField.text , @"state" : @(2)};
    [MKUtilHUD showHUD:self.view];
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@",WAP_URL,api_sendCode]);
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_sendCode] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        NSLog(@"获取验证码%@",json);
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"验证码已发送到你的手机" withSecond:2 inView:strongSelf.view];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            [_codeButton stop];
        }
        
        
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
    
    }];
    
}

#pragma mark - HTTP 修改支付密码

- (void)requestModifyPaymentPassword {
    
    //加密
    NSString *encryptePassword1 = [MKTool md5_passwordEncryption:_passwdTextField1.text];
    NSString *encryptePassword2 = [MKTool md5_passwordEncryption:_passwdTextField2.text];
    
    
    NSDictionary *param = @{@"code"     : _codeTextField.text ,
                            @"trpwd"    : encryptePassword1,
                            @"trpwdTwo" : encryptePassword2};
    [MKUtilHUD showHUD:self.view];
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@",WAP_URL,api_sendCode]);
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_setPayPassword] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        NSLog(@"修改支付密码%@",json);
        if (status == 200) {
            
            [MKUtilHUD showAutoHiddenTextHUD:@"设置成功" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            [_codeButton stop];
        }
        
       
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        //NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        
    }];
    
}

- (void)backButtonClicked {
    
    if (_isModalPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

@end
