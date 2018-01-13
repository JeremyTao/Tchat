//
//  MKAddNoteNameViewController.m
//  Moka
//
//  Created by  moka on 2017/9/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKAddNoteNameViewController.h"
#import "upLoadImageManager.h"

@interface MKAddNoteNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;



@end

@implementation MKAddNoteNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改备注";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    _nameTextField.leftView = view;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
     [_nameTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
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

#pragma mark - HTTP 修改备注

- (void)requestChangeNoteName {
    NSDictionary *paramDitc = @{@"coveruserid" : self.targetId,
                                @"remarks" : _nameTextField.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_addRemark] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"修改备注 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"修改备注成功" withSecond:2 inView:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_PERSON_PAGE" object:nil];
            [strongSelf updateUserInfo];
            
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


- (void)updateUserInfo {
    //自己服务器查询
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_getUserInfoByUserId] params:@{@"id":self.targetId} success:^(id json) {
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        //NSString  *message = json[@"exception"];
        DLog(@"根据userID查询用户基本信息 %@",json);
        if (status == 200) {
            
            NSString *userId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"id"]];
            NSString *userName = json[@"dataObj"][@"name"];
            
            //
            NSString *userPortrait = [upLoadImageManager judgeThePathForImages:json[@"dataObj"][@"portrail"]];
           //NSString *userPortrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"portrail"]];
            
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:userName portrait:userPortrait];
            [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
            NSDictionary *dic = @{@"noteName":userName};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedUserInfo" object:nil userInfo:dic];
            
        } else {
            //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"%@",error);
        
    }];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
