//
//  MKRegisterSecondViewController.m
//  Moka
//
//  Created by Knight on 2017/7/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRegisterSecondViewController.h"
#import "MKSetGenderViewController.h"
#import "CBPickerView.h"
#import "MKUserAgreementViewController.h"
#import <MapKit/MapKit.h>
#import "upLoadImageManager.h"

@interface MKRegisterSecondViewController ()<CBPickerViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
{
    NSString  *nameString;  //姓名
    NSString  *dateString; //生日
    NSString  *firstPasswordString; //密码1
    NSString  *secondPasswordString; //密码2
    CLLocationDegrees latitude;   //纬度
    CLLocationDegrees longitude;  //经度
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTextField;

@property (nonatomic,strong)  CBPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MKRegisterSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"填写资料"];
    self.title = @"填写资料";
    [self.nameTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    [self.firstPasswordTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.firstPasswordTextField.delegate = self;
    
    [self.secondPasswordTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    // locationManager
    self.locationManager = ({
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = 3000;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        locationManager;
    });
}

#pragma mark - 更新位置📍
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Remember for later the user's current location.
    CLLocation *currentUserLocation = locations.lastObject;
    latitude = currentUserLocation.coordinate.latitude;
    longitude = currentUserLocation.coordinate.longitude;
    
    [manager stopUpdatingLocation];
    manager.delegate = nil;
}


#pragma mark - Text Field Handel


- (void)textFieldChanged:(UITextField *)textField {
    if (textField.tag == 1000) {
        nameString = textField.text;
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
        
    } else if (textField.tag == 2000) {
        firstPasswordString = textField.text;
        if (textField.text.length == 0) {
            _hintLabel.hidden = NO;
        } else {
            _hintLabel.hidden = YES;
        }
        
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
        
        
    } else if (textField.tag == 3000){
        secondPasswordString = textField.text;
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
    
    [self checkInfoComplete];
}

- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    BOOL isOK = [self checkInputNameText:_nameTextField.text];
    if (isOK) {
        if (![firstPasswordString isEqualToString:secondPasswordString]) {
            [MKUtilHUD showAutoHiddenTextHUD:@"两次输入的密码不一致" inView:self.view];
            return;
        }
        
        if (firstPasswordString.length < 6) {
            [MKUtilHUD showAutoHiddenTextHUD:@"密码长度小于6个字符" inView:self.view];
            return;
        }
        //在这里请求
        [self requestRegisterNewUser];
    }
}

-(BOOL)checkInputNameText:(NSString *)tx{
    
    if ([tx length]<2) {
        [MKUtilHUD showHUD:@"昵称太短,建议在2-16个字符之间" inView:nil];
        return NO;
    }else if ([tx length] > 16){
        [MKUtilHUD showHUD:@"昵称太长,建议在2-16个字符之间" inView:nil];
        return NO;
    }
    return YES;
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
    _birthdayLabel.textColor = RGB_COLOR_HEX(0x808080);
    [self checkInfoComplete];
}

- (void)checkInfoComplete {
    if (nameString.length > 0 && dateString.length > 0 && firstPasswordString.length > 0 && secondPasswordString.length > 0) {
        _registerButton.backgroundColor = commonBlueColor;
        _registerButton.enabled = YES;
        [MKTool addShadowOnView:_registerButton];
    } else {
        _registerButton.backgroundColor = buttonDisableColor;
        _registerButton.enabled = NO;
        [MKTool removeShadowOnView:_registerButton];
    }
}

#pragma mark - http 注册

- (void)requestRegisterNewUser {
    
    NSString *encryptePassword1 = [MKTool md5_passwordEncryption:firstPasswordString];
    NSString *encryptePassword2 = [MKTool md5_passwordEncryption:secondPasswordString];
    
    NSDictionary *param = @{@"name":nameString,
                            @"birthday": dateString,
                            @"password": encryptePassword1,
                            @"passwordtwo": encryptePassword2,
                            @"phone": _userPhone,
                            @"deviceUUID":deviceUUID,
                            @"coordinatex":@(latitude),
                            @"coordinatey": @(longitude)};
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] loginpost:[NSString stringWithFormat:@"%@%@",WAP_URL,api_register] params:param success:^(id json) {
        [MKUtilHUD hiddenHUD:self.view];
        STRONG_SELF;
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        NSLog(@"注册 %@",json);
        if (status == 200) {
            //注册成功
            
            //1. 保存用户token
            NSString *token = json[@"dataObj"][@"token"];
            [[A0SimpleKeychain keychain] setString:token forKey:apiTokenKey];
            
            //1.1 登陆融云
            //获取融云token
            NSString *rcToken = json[@"dataObj"][@"cloudtoken"];
            NSString *userId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"id"]];
            NSString *name = json[@"dataObj"][@"name"];
            //
            NSString *portrait = [upLoadImageManager judgeThePathForImages:json[@"dataObj"][@"portrail"]];
            //NSString *portrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"portrail"]];
            
            [[A0SimpleKeychain keychain] setString:rcToken forKey:apiRongCloudToken];
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userInfo.name"];
            [[NSUserDefaults standardUserDefaults] setObject:portrait forKey:@"userInfo.portraitUri"];
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userInfo.userId"];
            
            RCUserInfo *userInfo  = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:portrait];
            [[MKChatTool sharedChatTool] loginRongCloudWithUserInfo:userInfo withToken:rcToken];
            
            //2. 跳转到下一步
            MKSetGenderViewController *genderVC = [[MKSetGenderViewController alloc] init];
            genderVC.addInfo = NO;
            [self.navigationController pushViewController:genderVC animated:YES];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        //NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        //[MKUtilAction doApiFailWithToken:errorResponse ctrl:strongSelf with:error];
    }];
}
- (IBAction)seeButtonClicked:(id)sender {
    MKUserAgreementViewController *vc = [[MKUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
