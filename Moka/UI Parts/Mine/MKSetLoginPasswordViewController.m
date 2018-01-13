//
//  MKSetLoginPasswordViewController.m
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSetLoginPasswordViewController.h"

@interface MKSetLoginPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *originalPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField1;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField2;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation MKSetLoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"修改登录密码"];
    self.title = @"修改登录密码";
    [_originalPasswordTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_passwordTextField1 addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_passwordTextField2 addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];

}

- (void)textFieldChanged:(UITextField *)textField {
    [self checkInfoComplete];
}

- (void)checkInfoComplete {
    if (_originalPasswordTextField.text.length > 0 && _passwordTextField1.text.length > 0 && _passwordTextField2.text.length > 0) {
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
   
    
    [self.view endEditing:YES];
    //修改密码
    [self requestModifyLoginPassword];
}

#pragma mark - HTTP 修改登录密码

- (void)requestModifyLoginPassword {
    
    //加密
    NSString *originalPassword = [MKTool md5_passwordEncryption:_originalPasswordTextField.text];
    NSString *encryptePassword1 = [MKTool md5_passwordEncryption:_passwordTextField1.text];
    NSString *encryptePassword2 = [MKTool md5_passwordEncryption:_passwordTextField2.text];
    
    
    NSDictionary *param = @{@"password" : originalPassword ,
                            @"pwd"    : encryptePassword1,
                            @"pwdTwo" : encryptePassword2};
    [MKUtilHUD showHUD:self.view];
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@",WAP_URL,api_sendCode]);
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_setLoginPasswd] params:param success:^(id json) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        NSLog(@"修改登录密码%@",json);
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"设置成功" withSecond:2 inView:strongSelf.view];
            [strongSelf performSelector:@selector(dismissVC) withObject:nil afterDelay:2];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        //NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        
    }];
    
}

- (void)dismissVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
