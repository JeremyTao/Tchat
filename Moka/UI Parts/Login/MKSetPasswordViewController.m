//
//  MKSetPasswordViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSetPasswordViewController.h"

@interface MKSetPasswordViewController ()

{
    NSString  *firstPasswordString; //密码1
    NSString  *secondPasswordString; //密码2
}
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTextField;
@end

@implementation MKSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重设密码";
    [self setNavigationTitle:@"重设密码"];
    [self.firstPasswordTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}

#pragma mark - Text Field Handel


- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.length == 0) {
        _hintLabel.hidden = NO;
    } else {
        _hintLabel.hidden = YES;
    }
}

- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    firstPasswordString = _firstPasswordTextField.text;
    secondPasswordString = _secondPasswordTextField.text;
    
    if (![firstPasswordString isEqualToString:secondPasswordString]) {
        [MKUtilHUD showAutoHiddenTextHUD:@"两次输入的密码不一致" inView:self.view];
        return;
    }
    
    if (firstPasswordString.length < 6) {
        [MKUtilHUD showAutoHiddenTextHUD:@"密码长度小于6个字符" inView:self.view];
        return;
    }
    
    [self requestChangePassword];
}

- (void)requestChangePassword {
    
    
    NSString *encryptePassword1 = [MKTool md5_passwordEncryption:firstPasswordString];
    
    NSDictionary *param = @{@"phone":_userPhone,
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
        
      
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        //NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        //[MKUtilAction doApiFailWithToken:errorResponse ctrl:strongSelf with:error];
    }];
    
}


@end
