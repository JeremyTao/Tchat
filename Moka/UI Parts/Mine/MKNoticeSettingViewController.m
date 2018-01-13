//
//  MKNoticeSettingViewController.m
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKNoticeSettingViewController.h"

@interface MKNoticeSettingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *noDisturbSwith;
@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibrateSwitch;

@end

@implementation MKNoticeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息通知";
    [self setNavigationTitle:@"消息通知"];
    [self.voiceSwitch setOn:![RCIM sharedRCIM].disableMessageAlertSound];
    [self.vibrateSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"vibrateKey"]];
    
    
    UIColor *offColor = RGB_COLOR_HEX(0xE5E5E5);
    self.voiceSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.voiceSwitch.tintColor = offColor;
    self.voiceSwitch.layer.cornerRadius = 15.5;
    self.voiceSwitch.backgroundColor = offColor;
    
    self.vibrateSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.vibrateSwitch.tintColor = offColor;
    self.vibrateSwitch.layer.cornerRadius = 15.5;
    self.vibrateSwitch.backgroundColor = offColor;
}


- (IBAction)voiceSwitchEvent:(UISwitch *)sender {
    
    [[RCIM sharedRCIM] setDisableMessageAlertSound:!sender.isOn];
}

- (IBAction)vibrateSwitchEvent:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"vibrateKey"];
}

@end
