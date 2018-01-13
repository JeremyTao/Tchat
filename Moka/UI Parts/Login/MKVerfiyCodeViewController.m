//
//  MKVerfiyCodeViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKVerfiyCodeViewController.h"
#import "MQVerCodeInputView.h"
#import "MKSetPasswordViewController.h"
#import "MKSetNameViewController.h"
#import "JKCountDownButton.h"

@interface MKVerfiyCodeViewController ()

@property (weak, nonatomic) IBOutlet MQVerCodeInputView *codeView;

@property (weak, nonatomic) IBOutlet JKCountDownButton *resendCodeButton;

@end

@implementation MKVerfiyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"输入验证码"];
    _codeView.maxLenght = 4;//最大长度
    _codeView.keyBoardType = UIKeyboardTypeNumberPad;
    [_codeView mq_verCodeViewWithMaxLenght];
    _codeView.block = ^(NSString *text){
        NSLog(@"text = %@",text);
    };
    
    //获取验证码按钮倒计时
    _resendCodeButton.enabled = NO;
    [_resendCodeButton startWithSecond:60];
    
    [_resendCodeButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"Resend the verification code %d",second];
        return title;
    }];
    [_resendCodeButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"Resend the verification code";
    }];
}

- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    
    NSInteger flag = [[NSUserDefaults standardUserDefaults] integerForKey:@"LOGIN_FLAG"];
    if (flag == 0) {
        MKSetNameViewController *setNameVC = [[MKSetNameViewController alloc] init];
        [self.navigationController pushViewController:setNameVC animated:YES];
    } else {
        MKSetPasswordViewController *codeVC = [[MKSetPasswordViewController alloc] init];
        [self.navigationController pushViewController:codeVC animated:YES];
    }
    
    
}

@end
