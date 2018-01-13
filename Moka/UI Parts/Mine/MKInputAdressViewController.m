//
//  MKInputAdressViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKInputAdressViewController.h"
#import "MKWithdrawDetailViewController.h"

@interface MKInputAdressViewController ()

@property (weak, nonatomic) IBOutlet UITextField *adressTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
//粘贴按钮
@property (strong, nonatomic) IBOutlet UIButton *fastBtn;
- (IBAction)fastClicked:(UIButton *)sender;


@end

@implementation MKInputAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入转出地址";
    
    self.fastBtn.layer.cornerRadius = 13.0f;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 1)];
    _adressTextField.leftView = leftView;
    _adressTextField.leftViewMode = UITextFieldViewModeAlways;
    [_adressTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    [_adressTextField becomeFirstResponder];
}


- (void)textFieldChanged:(UITextField *)textField {
    
    [self checkInfoComplete];
}

- (void)checkInfoComplete {
    if (_adressTextField.text.length > 0) {
        _nextStepButton.backgroundColor = commonBlueColor;
        _nextStepButton.enabled = YES;
        [MKTool addShadowOnView:_nextStepButton];
    } else {
        _nextStepButton.backgroundColor = buttonDisableColor;
        _nextStepButton.enabled = NO;
        [MKTool removeShadowOnView:_nextStepButton];
    }
}


- (IBAction)nextStepClicked:(UIButton *)sender {
    if ([self checkAdress]) {
        [self requestPaymentQuery];
    }
    
}

- (BOOL)checkAdress {
    NSString *adress = _adressTextField.text;
    if (([adress hasPrefix:@"TV"] || [adress hasPrefix:@"tv"]) &&
        adress.length > 20 && adress.length < 100 &&
        ![adress containsString:@" "] &&
        [self deptIdInputShouldAlphaNum:adress]) {
        
        return YES;
    } else {
        [MKUtilHUD showHUD:@"地址格式不正确" inView:self.view];
        return NO;
    }
}




- (BOOL)deptIdInputShouldAlphaNum:(NSString *)string
{
  
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
    
}


#pragma mark - HTTP 提现查询

- (void)requestPaymentQuery {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_withdrawQuery] params:@{@"key": _adressTextField.text} success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@" 提现查询 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            if ([json[@"dataObj"] integerValue] == 1) {
                //app内，提示
                
                NSString *tip = @"APP内的钱包地址不支持提现。\n您可以通过三种账户地址提现：\n1.钛币-钱包地址    \n2.官网账户的钱包地址\n3.虚拟币交易所地址    ";
                //弹窗提醒
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:tip preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                
            
                [alertController addAction:actionCancel];
               
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else if ([json[@"dataObj"] integerValue] == 2) {
                MKWithdrawDetailViewController *vc = [[MKWithdrawDetailViewController alloc] init];
                vc.withdrawURL = _adressTextField.text;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}

//粘贴板
- (IBAction)fastClicked:(UIButton *)sender {
    
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    NSString * testStr = [pasteboard string];
    self.adressTextField.text = testStr;
    [self checkInfoComplete];
}
@end

