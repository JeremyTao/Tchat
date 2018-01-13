//
//  MKLoginViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//
#define ButtonBorderColor  [UIColor colorWithRed:0.216 green:0.608 blue:0.875 alpha:1.00].CGColor

#import "MKLoginViewController.h"
#import "MKLoginCheckingViewController.h"
#import "MKRegisterFirstViewController.h"
#import "MKUserAgreementViewController.h"

@interface MKLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;

@end

@implementation MKLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self hideNavigationView];
    [self.videoView.layer addSublayer:self.avPlayerLayer];
    [self setGradientView];
    
    _loginButton.layer.borderWidth = 1.0;
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _registerButton.layer.borderWidth = 1.0;
    _registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (void)setGradientView {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    gradientLayer.colors = @[(__bridge id)RGB_COLOR_HEX(0x136DF3).CGColor,(__bridge id)RGB_COLOR_HEX(0x845AF7).CGColor];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.gradientView.layer addSublayer:gradientLayer];
    self.gradientView.layer.opacity = 0.3;
}


- (IBAction)loginButtonClicked:(UIButton *)sender {
    MKLoginCheckingViewController *loginCheckVC = [[MKLoginCheckingViewController alloc] init];
    [self.navigationController pushViewController:loginCheckVC animated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"LOGIN_FLAG"];
}


- (IBAction)registerButtonClicked:(UIButton *)sender {
    MKRegisterFirstViewController *phoneVC = [[MKRegisterFirstViewController alloc] init];
    [self.navigationController pushViewController:phoneVC animated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LOGIN_FLAG"];
}

- (IBAction)userAgressmentButtonClicked:(UIButton *)sender {
    MKUserAgreementViewController  *vc = [[MKUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
