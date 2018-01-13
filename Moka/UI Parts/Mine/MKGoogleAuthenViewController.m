//
//  MKGoogleAuthenViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGoogleAuthenViewController.h"
#import "JKCountDownButton.h"


@interface MKGoogleAuthenViewController ()


@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *dynamicCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *googleTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIView *popView;

@end

@implementation MKGoogleAuthenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"谷歌验证"];
    self.title  = @"谷歌验证";
    [self requestKey];
    
    [_dynamicCodeTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    [_googleTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}

- (void)textFieldChanged:(UITextField *)textField {
    [self checkInfoComplete];
}

- (void)checkInfoComplete {
    if (_dynamicCodeTextField.text.length > 0 && _googleTextField.text.length > 0) {
        _nextStepButton.backgroundColor = commonBlueColor;
        _nextStepButton.enabled = YES;
        [MKTool addShadowOnView:_nextStepButton];
    } else {
        _nextStepButton.backgroundColor = buttonDisableColor;
        _nextStepButton.enabled = NO;
        [MKTool removeShadowOnView:_nextStepButton];
    }
}

- (IBAction)copyKeyButtonClicked:(UIButton *)sender {
    [MKUtilHUD showAutoHiddenTextHUD:@"已复制到剪贴板" withSecond:1.5 inView:self.view];
    NSString *copyStringverse = _keyLabel.text;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:copyStringverse];
    
}

- (IBAction)sendDynamicCodeButtonClicked:(UIButton *)sender {
    
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
        return @"发送";
    }];
    
    
}

- (IBAction)pasteGoogleCodeButtonClicked:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    _googleTextField.text =  pasteboard.string;
    [self checkInfoComplete];
}

#pragma mark - Http : google authen
- (IBAction)confirmButtonClicked:(UIButton *)sender {
    NSDictionary *param = @{@"secret":_keyLabel.text,
                            @"codes":_googleTextField.text,
                            @"code": _dynamicCodeTextField.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_google_authen] params:param success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSLog(@"google authen %@",json);
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleAuthenSuccess" object:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                _popView.alpha = 1;
            }];
            [strongSelf performSelector:@selector(dismissViewController) withObject:nil afterDelay:2];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:self.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];

}

- (void)requestVerfiyCode {
    NSDictionary *param = @{@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserPhone"] , @"state" : @(3)};
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
        //NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        
    }];

}

#pragma mark - HTTP 获取google认证key
- (void)requestKey {
    NSDictionary *param = @{};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_get_authen_key] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        NSLog(@"获取google认证key %@",json);
        if (status == 200) {
            _keyLabel.text = [NSString stringWithFormat:@"%@", json[@"dataObj"]];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}

- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
