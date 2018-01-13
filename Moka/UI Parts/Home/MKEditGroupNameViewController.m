//
//  MKEditGroupNameViewController.m
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditGroupNameViewController.h"

@interface MKEditGroupNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation MKEditGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"圈子名称"];
    self.title = @"圈子名称";
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    _nameTextField.leftView = leftView;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.nameTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    _nameTextField.text =  _circleModel.name;
    [self setConfirmButtonState];
    
}

- (void)setConfirmButtonState {
    if (_nameTextField.text.length == 0) {
        _confirmButton.backgroundColor = buttonDisableColor;
        _confirmButton.enabled = NO;
        [MKTool removeShadowOnView:_confirmButton];
    } else {
        _confirmButton.backgroundColor = commonBlueColor;
        _confirmButton.enabled = YES;
        [MKTool addShadowOnView:_confirmButton];
    }
}


- (void)textFieldChanged:(UITextField *)textField {
    [self setConfirmButtonState];
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
    }
}

- (IBAction)confirmButtonEvent:(UIButton *)sender {
    [self requestChangeCircleName];
}


#pragma mark - 管理员操作 admin only

#pragma mark - Http -修改圈名

- (void)requestChangeCircleName {
    NSDictionary *param = @{@"id":@(_circleModel.id) , @"name":_nameTextField.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_update_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改圈子名称 %@",json);
        if (status == 200) {
            _circleListModel.name = _nameTextField.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircle" object:nil];
            _circleModel.name = _nameTextField.text;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}

@end
