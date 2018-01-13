//
//  MKTabBaeViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKTabBarViewController.h"
#import "MKHomepageViewController.h"
#import "MKMineViewController.h"
#import "MKFriendsViewController.h"
#import "MKChatViewController.h"
#import "MKSetGenderViewController.h"
#import "MKSetPortraitViewController.h"
#import "upLoadImageManager.h"

@interface MKTabBarViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D  coordinate2D;
@end

@implementation MKTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self creatViewControllers];
    [[NSUserDefaults standardUserDefaults] setObject:currentPhoneSystemVersion forKey:CDVersionKey];
    [self tokenLogin];
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
    
    CLLocation *currentUserLocation = locations.lastObject;
    
    _coordinate2D.latitude = currentUserLocation.coordinate.latitude;
    _coordinate2D.longitude = currentUserLocation.coordinate.longitude;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(_coordinate2D.latitude) forKey:@"coordinatex"];
    [[NSUserDefaults standardUserDefaults] setObject:@(_coordinate2D.longitude) forKey:@"coordinatey"];
    NSLog(@"更新位置: %f  %f", _coordinate2D.latitude, _coordinate2D.longitude);
    
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    
 ;
}


- (void)tokenLogin {
    NSString *token = [[A0SimpleKeychain keychain] stringForKey:@"token"];
    if (token.length > 0) {
        NSString *currentTime  = [DateUtil getCurrentTime];
        NSString *encrypteToken = [MKTool md5_passwordEncryption: [NSString stringWithFormat:@"%@%@", currentTime, token]];
        [self loginWithToken:token date:currentTime encryption:encrypteToken];
    }
    
}

- (void)setupUI {
    UIView *tabBarView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 1))];
    tabBarView.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:tabBarView];
    
//    self.tabBar.barTintColor= RGBCOLOR(14, 14, 14);
    self.tabBar.tintColor = commonBlueColor;
    //取消设置半透明
//    self.tabBar.translucent = NO;
}

//检查资料完整
- (void)requestAuthInfoCompletion {
    
    NSDictionary *param = nil;
    
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_autoInfo] params:param success:^(id json) {
        STRONG_SELF;
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSInteger gender  = [json[@"dataObj"][@"sex"] integerValue];
        NSString  *portait = json[@"dataObj"][@"portrait"];
        NSLog(@"检查资料完整 %@",json);
        if (status == 200) {
            if (gender == 0) {
                //未设置性别
                MKSetGenderViewController *setGenderVC = [[MKSetGenderViewController alloc] init];
                MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:setGenderVC];
                setGenderVC.addInfo = YES;
                [self presentViewController:nav animated:YES completion:nil];
            } else {
                if (portait.length == 0) {
                    //未设置头像
                    MKSetPortraitViewController *setPortraitVC = [[MKSetPortraitViewController alloc] init];
                    MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:setPortraitVC];
                    setPortraitVC.addInfo = YES;
                    [self presentViewController:nav animated:YES completion:nil];
                }
            }
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}

-(void)loginWithToken:(NSString *)token date:(NSString *)time encryption:(NSString *)encryptionToken {
    //token传给服务器
    NSDictionary *param = @{@"time":time, @"encryption": encryptionToken, @"deviceUUID":deviceUUID};
    
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_tokenLogin] params:param success:^(id json) {
        STRONG_SELF;
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
       // [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
        
        
        NSLog(@"token认证登陆 %@",json);
        if (status == 200) {
            [strongSelf requestAuthInfoCompletion];
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
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        [[MKChatTool sharedChatTool] loginRongCloudWithUserInfo:nil withToken:nil];
    }];
    
}

- (void)creatViewControllers {
    MKNavigationController *homeNav = [self creatNavigationControllerWithTitle:@"附近" nomalImgae:IMAGE(@"new_nearby") selectImage:IMAGE(@"new_nearby_fill") viewController:[[MKHomepageViewController alloc] init]];
    
    MKNavigationController *chatNav = [self creatNavigationControllerWithTitle:@"聊天" nomalImgae:IMAGE(@"new2_chat") selectImage:IMAGE(@"new_chat") viewController:[[MKChatViewController alloc] init]];
    
    
    MKNavigationController *friendsNav = [self creatNavigationControllerWithTitle:@"动态" nomalImgae:IMAGE(@"new_feed") selectImage:IMAGE(@"new_feed_fill") viewController:[[MKFriendsViewController alloc] init]];
    
    MKNavigationController *mineNav = [self creatNavigationControllerWithTitle:@"我的" nomalImgae:IMAGE(@"new_center") selectImage:IMAGE(@"new_center_fill") viewController:[[MKMineViewController alloc] init]];
    
    self.viewControllers = @[homeNav,chatNav, friendsNav,mineNav];
    
}

- (MKNavigationController *)creatNavigationControllerWithTitle:(NSString *)title nomalImgae:(UIImage *)normImg selectImage:(UIImage *)selImg viewController:(UIViewController *)vc {
    MKNavigationController *navi = [[MKNavigationController alloc] initWithRootViewController:vc];
    navi.tabBarItem.title = title;
    navi.tabBarItem.image = [normImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    navi.tabBarItem.selectedImage = [selImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    return navi;
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}


@end
