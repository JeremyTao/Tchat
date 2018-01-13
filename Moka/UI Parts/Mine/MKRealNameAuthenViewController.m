//
//  MKRealNameAuthenViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRealNameAuthenViewController.h"
#import "MKUploadIdenticationPhotoViewController.h"
#import "MKGoogleAuthenViewController.h"
#import "RCDCustomerServiceViewController.h"
#import "upLoadImageManager.h"
#import "MKSecurity.h"

@interface MKRealNameAuthenViewController ()

{
    NSInteger currentStatus;
}

@property (weak, nonatomic) IBOutlet UILabel *cardAuthenLabel;
@property (weak, nonatomic) IBOutlet UILabel *googleAuthenLabel;
@property (weak, nonatomic) IBOutlet UIButton *cardAuthenButton;
@property (weak, nonatomic) IBOutlet UIButton *googleAuthenButton;
@property (weak, nonatomic) IBOutlet UIImageView *cardAuthenArrow;
@property (weak, nonatomic) IBOutlet UIImageView *googleAuthenArrow;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *popView;



@end

@implementation MKRealNameAuthenViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // forces a return to portrait orientation
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self setNavigationTitle:@"实名认证"];
    currentStatus = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadCardImagesSuccess) name:@"UploadAuthenImages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleAuthenSuccess) name:@"GoogleAuthenSuccess" object:nil];
    
    [self requestAuthenStatus];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(keFuClick:)];
    
}


-(void)keFuClick:(UIBarButtonItem *)item{
    
    RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = RongCloudKeFuServer;
    chatService.title = @"客服";

    RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
    //ID
    csInfo.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userId"];
    //nikeName
    csInfo.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
    //头像
    csInfo.portraitUrl = [upLoadImageManager judgeThePathForImages:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userImageStr"]];
    //电话
    csInfo.mobileNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.phone"];

    chatService.csInfo = csInfo;

    [self.navigationController pushViewController :chatService animated:YES];
    
    
}



- (void)uploadCardImagesSuccess {
    _cardAuthenLabel.text = @"审核中";
    _cardAuthenLabel.textColor = RGB_COLOR_HEX(0x2a2a2a);
    currentStatus = 0;
}

- (void)googleAuthenSuccess {
    _googleAuthenLabel.text = @"已认证";
    _googleAuthenLabel.textColor = commonBlueColor;
    _googleAuthenArrow.hidden  = YES;
    _googleAuthenButton.enabled = NO;
}


- (IBAction)IidentificationCardAuthenEvent:(UIButton *)sender {
    
    if (currentStatus == 2 || currentStatus == 3) {
        MKUploadIdenticationPhotoViewController *vc = [[MKUploadIdenticationPhotoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (currentStatus == 0) {
        self.popView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.popView.alpha = 1.0;
            self.popView.transform =  CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
           
        }];

    }
    
    
}
- (IBAction)googleAuthenEvent:(id)sender {
    MKGoogleAuthenViewController *vc = [[MKGoogleAuthenViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)okButtonClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _popView.alpha = 0;
    }];
}


#pragma mark - HTTP 查询是否认证
- (void)requestAuthenStatus {
    NSDictionary *param = @{};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_ifAuthen] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        NSLog(@"是否认证 %@",json);
        if (status == 200) {
            NSInteger googleAuthen = [json[@"dataObj"][@"google"] integerValue];
            NSInteger identityAuthen = [json[@"dataObj"][@"identity"] integerValue];
            currentStatus  = identityAuthen;
            
            if (googleAuthen == 0) {
                _googleAuthenLabel.text = @"未认证";
                _googleAuthenLabel.textColor = RGB_COLOR_HEX(0x2a2a2a);
                _googleAuthenButton.enabled = YES;
                _googleAuthenArrow.hidden  = NO;
            } else {
                _googleAuthenLabel.text = @"已认证";
                _googleAuthenLabel.textColor = commonBlueColor;
                _googleAuthenButton.enabled = NO;
                _googleAuthenArrow.hidden  = YES;
            }
            
            if (identityAuthen == 1) {
                _cardAuthenLabel.text = @"已认证";
                _cardAuthenLabel.textColor = commonBlueColor;
                _cardAuthenArrow.hidden = YES;
                
            } else if (identityAuthen == 0) {
                _cardAuthenLabel.text = @"审核中";
                _cardAuthenLabel.textColor = RGB_COLOR_HEX(0x2a2a2a);
                _cardAuthenArrow.hidden = NO;
                
            } else if (identityAuthen == 2) {
                _cardAuthenLabel.text = @"审核失败";
                _cardAuthenLabel.textColor = RGB_COLOR_HEX(0x2a2a2a);
                _cardAuthenArrow.hidden = NO;
                
            } else if (identityAuthen == 3) {
                _cardAuthenLabel.text = @"未认证";
                _cardAuthenLabel.textColor = RGB_COLOR_HEX(0x2a2a2a);
                _cardAuthenArrow.hidden = NO;
                
            }
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}


@end
