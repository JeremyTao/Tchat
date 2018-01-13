//
//  MKSetPaidCountViewController.m
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSetPaidCountViewController.h"
#import "MKCompleteGroupInfoViewController.h"

@interface MKSetPaidCountViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *piadTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@end

@implementation MKSetPaidCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"付费设置"];
    self.title = @"付费设置";
    self.piadTextField.delegate = self;
    [self.piadTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}

- (void)textFieldChanged:(UITextField *)textField {
    if ([textField.text floatValue] == 0) {
        _nextStepButton.backgroundColor = RGB_COLOR_HEX(0xE5E5E5);
        _nextStepButton.enabled = NO;
        [MKTool removeShadowOnView:_nextStepButton];
    } else {
        _nextStepButton.backgroundColor = commonBlueColor;
        _nextStepButton.enabled = YES;
        [MKTool addShadowOnView:_nextStepButton];
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.piadTextField) {
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                if([textField.text length]==0){
                    if(single == '.'){
                        //首字母不能为小数点
                        return NO;
                    }
                    if (single == '0') {
                        _isFirstZero = YES;
                        return YES;
                    }
                }
                
                if (single=='.'){
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(single=='0'){
                    if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if([textField.text isEqualToString:@"0.00"]){
                            return NO;
                        }
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=(int)(range.location-ran.location);
                        if (tt <= 3){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if (_isFirstZero&&!_isHaveDian){
                        //首位有0没.不能再输入0
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (_isHaveDian){
                        //存在小数点，保留两位小数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt= (int)(range.location-ran.location);
                        if (tt <= 3){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if(_isFirstZero&&!_isHaveDian){
                        //首位有0没点
                        return NO;
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
}

- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    
//    if (self.ifPay == 0) {
//        MKCompleteGroupInfoViewController *vc = [[MKCompleteGroupInfoViewController alloc] init];
//        vc.ifPay = self.ifPay;
//        vc.isFromChat = self.isFromChat;
//        vc.payCount = [self.piadTextField.text floatValue];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
        BOOL isOK = [self checkTextNumber:self.piadTextField.text];
        if (isOK) {
            MKCompleteGroupInfoViewController *vc = [[MKCompleteGroupInfoViewController alloc] init];
            vc.ifPay = self.ifPay;
            vc.isFromChat = self.isFromChat;
            vc.payCount = [self.piadTextField.text floatValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
//    }
}

-(BOOL)checkTextNumber:(NSString *)tx{
    int pay = [tx intValue];
    if (pay < 1 || pay > 200000) {
        
        [MKUtilHUD showHUD:@"付费设置应在1-20万(TV)之间" inView:nil];
        return NO;
    }
    return YES;
}


@end
