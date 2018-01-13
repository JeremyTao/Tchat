//
//  MKRegisterFirstViewController.m
//  Moka
//
//  Created by Knight on 2017/7/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRegisterFirstViewController.h"
#import "MKRegisterSecondViewController.h"
#import "XWCountryCodeController.h"
#import "JKCountDownButton.h"

@interface MKRegisterFirstViewController ()<XWCountryCodeControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeButton; //获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation MKRegisterFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"注册"];
    self.title = @"注册";
    _phoneTextField.delegate = self;
    [_phoneTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_codeTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}


- (IBAction)selectCountyButtonClicked:(UIButton *)sender {
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    countryCodeVC.deleagete = self;
    
    //block
    [countryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSArray *tempArr = [countryCodeStr componentsSeparatedByString:@" "];
        if (tempArr.count == 2) {
            _countryCodeLabel.text = tempArr[1];
            NSLog(@"%@", tempArr[1]);
        }
        
    }];
    
    [self.navigationController pushViewController:countryCodeVC animated:YES];
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

- (void)textFieldChanged:(UITextField *)textField {
    [self checkInfoComplete];
}

- (void)checkInfoComplete {
    if (_phoneTextField.text.length > 0 && _codeTextField.text.length > 0) {
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
    [self.view endEditing:YES];
    //验证-验证码
    [self requestAffirmCode];
}

- (IBAction)getCodeButtonClicked:(JKCountDownButton *)sender {
    [self.view endEditing:YES];
    NSString *phone = self.phoneTextField.text;
    
    if(phone.length == 0)
    {
        [MKUtilHUD showAutoHiddenTextHUD:@"手机号不能为空" withSecond:2 inView:self.view];
        return;
    }
   
    
    if (![MKTool isMobileNumber:phone]) {
        [MKUtilHUD showAutoHiddenTextHUD:@"请输入正确的手机号" withSecond:2 inView:self.view];
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
    
    NSDictionary *param = @{@"phone":_phoneTextField.text , @"state" : @(0)};
    [MKUtilHUD showHUD:self.view];
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@",WAP_URL,api_sendCode]);
    WEAK_SELF;
    [[MKNetworkManager sharedManager] loginpost:[NSString stringWithFormat:@"%@%@",WAP_URL,api_sendCode] params:param success:^(id json) {
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
        //NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        
    }];
    
}

#pragma mark - http - 验证验证码

- (void)requestAffirmCode {
    NSDictionary *param = @{@"phone":_phoneTextField.text, @"code": _codeTextField.text, @"state" : @(0)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] loginpost:[NSString stringWithFormat:@"%@%@",WAP_URL,api_affirmCode] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"验证验证码%@",json);
        if (status == 200) {
            MKRegisterSecondViewController *secondVC = [[MKRegisterSecondViewController alloc] init];
            secondVC.userPhone = _phoneTextField.text;
            [self.navigationController pushViewController:secondVC animated:YES];

        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
           
            [_codeButton stop];

        }
        
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        [MKUtilAction doApiFailWithToken:errorResponse ctrl:strongSelf with:error];
    }];
    
}

@end
