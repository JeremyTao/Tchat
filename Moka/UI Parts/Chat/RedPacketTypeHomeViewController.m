//
//  RedPacketTypeHomeViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "RedPacketTypeHomeViewController.h"
#import "MKSendPersonalRedPacketViewController.h"
#import "MKSendGroupRedPacketViewController.h"

@interface RedPacketTypeHomeViewController ()

@property (strong, nonatomic) IBOutlet UIButton *TVbtn;
@property (strong, nonatomic) IBOutlet UIButton *RMBBtn;

@end

@implementation RedPacketTypeHomeViewController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.TVbtn addTarget:self action:@selector(BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.TVbtn addTarget:self action:@selector(BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.RMBBtn addTarget:self action:@selector(BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.RMBBtn addTarget:self action:@selector(BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//普通状态下的背景色
- (void)BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
}

//高亮状态下的背景色
- (void)BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = RGBCOLOR(245, 247, 255);
}



#pragma mark -- 返回按钮
- (IBAction)backNacClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 选择TV
- (IBAction)TvClicked:(id)sender {
    
    //个人红包TV
    if ([self.type isEqualToString:@"PRIVATE"]) {
        MKSendPersonalRedPacketViewController *redVC = [[MKSendPersonalRedPacketViewController alloc] init];
        redVC.coinType = @"2"; //钛值
        MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:redVC];
        redVC.navigationController.navigationBar.hidden = YES;
        redVC.targetId = self.targetID;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([self.type isEqualToString:@"GROUP"]) {
        
        MKSendGroupRedPacketViewController * vc = [[MKSendGroupRedPacketViewController alloc]init];
        vc.numberOfPeople = self.number;
        vc.circleId = self.targetID;
        vc.coinType = @"2";
        vc.navigationController.navigationBar.hidden = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark -- 选择RMB
- (IBAction)RMBClicked:(id)sender {
    
    //个人红包RMB
    if ([self.type  isEqualToString:@"PRIVATE"]) {
        MKSendPersonalRedPacketViewController *redVC = [[MKSendPersonalRedPacketViewController alloc] init];
        redVC.coinType = @"1"; //RMB
        MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:redVC];
        redVC.navigationController.navigationBar.hidden = YES;
        redVC.targetId = self.targetID;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([self.type isEqualToString:@"GROUP"]) {
        
        MKSendGroupRedPacketViewController * vc = [[MKSendGroupRedPacketViewController alloc]init];
        vc.numberOfPeople = self.number;
        vc.circleId = self.targetID;
        vc.coinType = @"1";  //RMB
        vc.navigationController.navigationBar.hidden = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}


@end
