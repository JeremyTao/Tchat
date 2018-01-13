//
//  MKChangeCircleNoteNameViewController.m
//  Moka
//
//  Created by  moka on 2017/9/20.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKChangeCircleNoteNameViewController.h"

@interface MKChangeCircleNoteNameViewController ()

{
    NSString *type; //【1 群员  2 圈主】
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation MKChangeCircleNoteNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我在本圈的昵称";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    _nameTextField.leftView = view;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [_nameTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    if (self.userType == 1) {
        type = @"1";
    } else if (self.userType == 3) {
        type = @"2";
    } else {
        type = @"";
    }
    _nameTextField.text = _myRemarkName;

}


- (void)textFieldChanged:(UITextField *)textField {
    while ([_nameTextField.text hasPrefix:@" "]) {
        _nameTextField.text = [_nameTextField.text substringFromIndex:1];
    }
    
    if (_nameTextField.text.length > 15) {
        _nameTextField.text = [_nameTextField.text substringToIndex:15];
    }
    
    
    if (_nameTextField.text.length > 0) {
        _confirmButton.backgroundColor = commonBlueColor;
        _confirmButton.enabled = YES;
        [MKTool addShadowOnView:_confirmButton];
    }
    
}


- (IBAction)confirmButtonClicked:(UIButton *)sender {
    
    [self requestChangeNoteName];
}

#pragma mark - HTTP 修改我在本圈的昵称

- (void)requestChangeNoteName {
    NSDictionary *paramDitc = @{@"type":type,
                                @"circleid" : self.targetCircleId,
                                @"remark" : _nameTextField.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_addCircleRemark] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"修改我在本圈的昵称 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"修改备注成功" withSecond:2 inView:nil];
            
         
            
            [strongSelf performSelector:@selector(popViewController) withObject:nil afterDelay:2];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
