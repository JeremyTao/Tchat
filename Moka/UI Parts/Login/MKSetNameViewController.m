//
//  MKSetNameViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSetNameViewController.h"
#import "MKSetGenderViewController.h"
#import "CBPickerView.h"



@interface MKSetNameViewController ()<CBPickerViewDelegate>
{
   NSString  *dateString;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic,strong)  CBPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

@end

@implementation MKSetNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"完善您的资料"];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)signUpButtonClicked:(UIButton *)sender {
    MKSetGenderViewController *genderVC = [[MKSetGenderViewController alloc] init];
    [self.navigationController pushViewController:genderVC animated:YES];
}

- (IBAction)setBirthdayButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    _pickerView = [[CBPickerView alloc] initDatePickerViewWithPickerDelegate:self rootViewController:self];
    NSString *date = dateString;
    if (date.length > 0) {
        [_pickerView setPickerViewWithDate:date];
    }
   
    [_pickerView show];

    
}


- (void)pickerViewDidSelectDate:(NSString *)date {
    NSLog(@"选中日期: %@", date);
    dateString = date;
    _birthdayLabel.text = dateString;
    
}



@end
