//
//  MKEditNameViewController.m
//  Moka
//
//  Created by Knight on 2017/7/27.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditNameViewController.h"

@interface MKEditNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation MKEditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"昵称"];
    self.title = @"昵称";
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"完成" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    [self setRightButtonWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nameTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.nameTextField.text = self.infoModel.name;
    self.nameTextField.delegate = self;
}

- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
    }
}

- (void)confirmButtonClicked {
    [self.view endEditing:YES];
    
    if (_nameTextField.text.length == 0) {
        [MKUtilHUD showHUD:@"昵称不能为空" inView:self.view];
        return;
    }
    
    while ([_nameTextField.text hasPrefix:@" "]) {
        _nameTextField.text = [_nameTextField.text substringFromIndex:1];
    }
    
    if (_nameTextField.text.length == 0) {
        [MKUtilHUD showHUD:@"没有输入昵称，请重新填写" inView:self.view];
        return;
    }
    
    [self requestUpdateUserName];
}


- (void)requestUpdateUserName {
    NSDictionary *param = @{@"name":_nameTextField.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_updateUser] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改昵称 %@",json);
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            self.infoModel.name = _nameTextField.text;
            [strongSelf performSelector:@selector(delayPopViewController) withObject:nil afterDelay:0];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
    } failure:^(NSError *error) {
       
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)delayPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
