//
//  MKPhoneNumberViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKPhoneNumberViewController.h"
#import "MKVerfiyCodeViewController.h"

@interface MKPhoneNumberViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation MKPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:_naviTitle];
    [self.phoneTextField addTarget:self  action:@selector(phoneNumberChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.phoneTextField.tag = 1000;
    self.phoneTextField.delegate = self;
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

- (void)phoneNumberChanged:(UITextField *)textField {
    
    if ([MKTool isMobileNumber:textField.text]) {
        if (textField.text.length < 11) {
            textField.textColor = [UIColor redColor];
        } else {
            textField.textColor = [UIColor blackColor];
        }
    } else {
        textField.textColor = [UIColor redColor];
    }
}

- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    MKVerfiyCodeViewController *codeVC = [[MKVerfiyCodeViewController alloc] init];
    [self.navigationController pushViewController:codeVC animated:YES];
}


@end
