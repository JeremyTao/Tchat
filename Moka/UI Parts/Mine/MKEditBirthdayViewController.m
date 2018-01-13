//
//  MKEditBirthdayViewController.m
//  Moka
//
//  Created by Knight on 2017/7/27.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditBirthdayViewController.h"
#import "CBPickerView.h"

@interface MKEditBirthdayViewController ()<CBPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (nonatomic,strong)  CBPickerView *pickerView;

@end

@implementation MKEditBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"生日"];
    self.title = @"生日";
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"完成" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    [self setRightButtonWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.birthdayLabel.text = self.infoModel.birthday;
}

- (IBAction)editBrithdatButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    _pickerView = [[CBPickerView alloc] initDatePickerViewWithPickerDelegate:self rootViewController:self];
    NSString *date = self.birthdayLabel.text;
    if (date.length > 0) {
        [_pickerView setPickerViewWithDate:date];
    }
    
    [_pickerView show];
}

- (void)pickerViewDidSelectDate:(NSString *)date {
    NSLog(@"选中日期: %@", date);
    _birthdayLabel.text = date;
    
}

- (void)confirmButtonClicked {
    [self requestUpdateUserBirthday];
}


- (void)requestUpdateUserBirthday {
    NSDictionary *param = @{@"birthday":_birthdayLabel.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_updateUser] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改生日 %@",json);
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            self.infoModel.birthday = _birthdayLabel.text;
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
