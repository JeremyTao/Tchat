//
//  MKAddFriendViewController.m
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.


#import "MKAddFriendViewController.h"
#import "MKContactsViewController.h"
#import "MKCircleMemberViewController.h"

@interface MKAddFriendViewController ()<UITextFieldDelegate>

{
    NSString *queryWord;
    NSString *userID;
    
}

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;




@end

@implementation MKAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加朋友";
    [self setupSearchTextField];
}


- (void)setupSearchTextField {
   
    [_searchTextField addTarget:self action:@selector(searchTextFieldChanged:) forControlEvents:UIControlEventAllEditingEvents];
    _searchTextField.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 30);
    _searchTextField.borderStyle = UITextBorderStyleNone;
    _searchTextField.layer.cornerRadius = 15;
    _searchTextField.layer.masksToBounds = YES;
    _searchTextField.backgroundColor = RGB_COLOR_HEX(0xE9EDFE);
    _searchTextField.font = [UIFont systemFontOfSize:14];
    _searchTextField.placeholder = @"输入用户ID/手机号";
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.clearsOnBeginEditing = YES;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftView.image = [UIImage imageNamed:@"search"];
    _searchTextField.leftView = leftView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.delegate = self;
}

- (void)searchTextFieldChanged:(UITextField *)textField  {
    queryWord = textField.text;
    if (textField.text.length == 0) {
        _userInfoView.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (queryWord.length == 0) {
        [MKUtilHUD showHUD:@"请输入用户ID或者手机号搜索" inView:self.view];
        return NO;
    }
    
    [self requestSearchUser];
    return YES;
}


- (IBAction)openContact:(id)sender {
    MKContactsViewController *vc = [[MKContactsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)openUser:(id)sender {
    MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
    memberInfoVC.hidesBottomBarWhenPushed = YES;
    memberInfoVC.userId = userID;
    [self.navigationController pushViewController:memberInfoVC animated:YES];
}


#pragma mark - 搜索用户
- (void)requestSearchUser {
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_search_user] params:@{@"query":queryWord} success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"搜索用户 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            userID = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"id"]];
            [_userHeadImageView setImageUPSUrl:json[@"dataObj"][@"portrail"]];
            _userNameLabel.text = json[@"dataObj"][@"name"];
            //性别
            NSInteger sex = [json[@"dataObj"][@"sex"] integerValue];
            if (sex == 1) {
                _genderImage.image = IMAGE(@"near_female");
            } else if (sex == 2) {
                _genderImage.image = IMAGE(@"near_male");
            } else {
                _genderImage.image = nil;
            }
            //age
            _userInfoView.hidden = NO;
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            _userInfoView.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        _userInfoView.hidden = YES;
        
        DLog(@"%@",error);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
