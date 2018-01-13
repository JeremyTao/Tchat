//
//  MKMineViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKMineViewController.h"
#import "MKEditProfileViewController.h"
#import "MKSettingsViewController.h"
#import "MKUserInfoRootModel.h"
#import "MKSettingPasswordViewController.h"
#import "MKAboutUsViewController.h"
#import "MKRealNameAuthenViewController.h"
#import "MKMyWalletViewController.h"
#import "MKGuideView.h"
#import "MKShareAppViewController.h"
#import "MKCircleMemberViewController.h"
#import "MKMyFriendsViewController.h"
#import "TchatFeedBackViewController.h"
#import "AlipayWalletViewController.h"
#import "TVCandyViewController.h"
#import "upLoadImageManager.h"

@interface MKMineViewController ()

{
    MKUserInfoRootModel *userInfoRootModel;
    NSString *_urlStr;
}

@property (weak, nonatomic) IBOutlet UIImageView *myPortait;
@property (nonatomic,strong)  MKGuideView *guideView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noNetworkLabelTop;
//TV回馈高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *advertiseConstraints;
//TV回馈
@property (strong, nonatomic) IBOutlet UIImageView *TVBackImageView;
//TV糖果
@property (strong, nonatomic) IBOutlet UIImageView *TVCandyImageView;
//
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *acticityHeight;

@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
//我的零钱
@property (weak, nonatomic) IBOutlet UIView *myIcoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icoViewHeight;
@property (strong, nonatomic) IBOutlet UIView *allBillsView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *allBillsHeight;

//全部账单
- (IBAction)allBilleClicked:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *fansCountButton;

@property (weak, nonatomic) IBOutlet UIButton *attentionCountButton;

@property (weak, nonatomic) IBOutlet UIImageView *expertImageView;


@end

@implementation MKMineViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *token = [[A0SimpleKeychain keychain] stringForKey:apiTokenKey];
    [self checkNetWork];
    if (token.length > 0) {
        [self rquestUserInfomation];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(0, 0, 30, 30);
    [setButton setImage:IMAGE(@"settings") forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(settingsButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    
    self.navigationItem.rightBarButtonItem = menuItem;
    
    //[self setNavigationTitle:@"我的"];
    //[self hideBackButton];
    //[self setRightButtonWithTitle:nil titleColor:nil imageName:@"settings" addTarget:self action:@selector(settingsButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    //[self checkIfShowGuide];
    
//    self.myIcoView.hidden = YES;
//    self.icoViewHeight.constant = 0;
    
    self.allBillsView.hidden = YES;
    self.allBillsHeight.constant = 0;
    
}

-(void)checkNetWork {
   //WEAK_SELF;
    [[MKNetworkManager sharedManager] checkNetWorkStatusSuccess:^(id str) {
        //STRONG_SELF;
        if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
            //有网络
            
            _noNetworkLabelTop.constant = -40;
        }else{
            //无网络
            id json = [JsonDataPersistent readJsonDataWithName:@"MineData"];
            userInfoRootModel = [MKUserInfoRootModel mj_objectWithKeyValues:json[@"dataObj"]];
            [self updateUserInterface];
            _noNetworkLabelTop.constant = 0;
            
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutSubviews];
        }];
        
    }];
    
}

#pragma mark -- 广告位显示
-(void)showAdvertiseView{

    //
    self.acticityHeight.constant = (SCREEN_WIDTH-34)/2 * 200/340;
    self.advertiseConstraints.constant = self.acticityHeight.constant + 30;
    self.TVCandyImageView.hidden = NO;
    self.TVCandyImageView.hidden = NO;
    //
    self.TVBackImageView.userInteractionEnabled = YES;
    self.TVCandyImageView.userInteractionEnabled = YES;
    //
    UITapGestureRecognizer * tapI = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCllI:)];
    tapI.numberOfTapsRequired = 1;
    tapI.numberOfTouchesRequired = 1;
    [self.TVBackImageView addGestureRecognizer:tapI];
    //
    UITapGestureRecognizer * tapII = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCllII:)];
    tapII.numberOfTapsRequired = 1;
    tapII.numberOfTouchesRequired = 1;
    [self.TVCandyImageView addGestureRecognizer:tapII];
    
}

-(void)tapCllI:(UITapGestureRecognizer *)tap{
    
    TchatFeedBackViewController * vc = [[TchatFeedBackViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tapCllII:(UITapGestureRecognizer *)tap{
    
    TVCandyViewController * vc = [[TVCandyViewController alloc]init];
    vc.webURLStr = _urlStr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --隐藏广告位
-(void)hideAdvertiseView{

    self.acticityHeight.constant = 0;
    self.advertiseConstraints.constant = self.acticityHeight.constant + 30;
    self.TVCandyImageView.hidden = YES;
    self.TVCandyImageView.hidden = YES;
}


- (void)checkIfShowGuide {
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:showGuideWallet];
    if (show) {
        _guideView = [MKGuideView newGuideView];
        _guideView.guideImageView.image = IMAGE(@"guide_wallet");
        if (iPhone5) {
            _guideView.guideImageView.image = IMAGE(@"guide1_wallet for 5");
        }
        [_guideView showInViewController:self];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:showGuideWallet];
    }
}

- (IBAction)editProfileButtonClicked:(UIButton *)sender {
    MKEditProfileViewController *vc = [[MKEditProfileViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.infoModel = userInfoRootModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)settingsButtonEvent {
    MKSettingsViewController *settingsVC = [[MKSettingsViewController alloc] init];
    settingsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (IBAction)setttingPasswordButtonClicked:(id)sender {
    MKSettingPasswordViewController *settingsVC = [[MKSettingPasswordViewController alloc] init];
    settingsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingsVC animated:YES];
}
//我的零钱
- (IBAction)myICOButtonClicked:(UIButton *)sender {
    
    AlipayWalletViewController * vc = [[AlipayWalletViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)rquestUserInfomation {
    NSDictionary *param = nil;
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getUserInfo] params:param success:^(id json) {
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"个人中心 %@",json);
        if (status == 200) {
            userInfoRootModel = [MKUserInfoRootModel mj_objectWithKeyValues:json[@"dataObj"]];
            [strongSelf updateUserInterface];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)userInfoRootModel.id] forKey:@"CURRENT_USER_ID"];
            //保存数据
            [JsonDataPersistent saveJsonData:json withName:@"MineData"];
            //
            NSInteger rebates =[json[@"dataObj"][@"rebates"] integerValue];
            
            if (rebates == 1) {
                
                NSArray * arr = json[@"dataObj"][@"activities"];
                
                for (NSDictionary* dic in arr) {
                    
                    _urlStr = dic[@"url"];
                }
                
                [self showAdvertiseView];
                
            }else{
                [self hideAdvertiseView];
            }
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (void)updateUserInterface {
    [[NSUserDefaults standardUserDefaults] setObject:userInfoRootModel.phone forKey:@"CurrentUserPhone"];
    [_myPortait setImageUPSUrl:userInfoRootModel.portrail];
    _myNameLabel.text = userInfoRootModel.name;
    
    if (userInfoRootModel.ifhave == 1) {
        //是大v
        _expertImageView.hidden = NO;
    } else {
        _expertImageView.hidden = YES;
    }
    
    _idLabel.text = [NSString stringWithFormat:@"ID %@", userInfoRootModel.code];
    
    NSString *userID = [NSString stringWithFormat:@"%ld", (long)userInfoRootModel.id];
    
    //粉丝，关注数
    [_fansCountButton setTitle:[NSString stringWithFormat:@"    粉丝 %ld    ", (long)userInfoRootModel.coverCount] forState:UIControlStateNormal];
    [_attentionCountButton setTitle:[NSString stringWithFormat:@"    关注 %ld    ", (long)userInfoRootModel.count] forState:UIControlStateNormal];
    
    //
    NSString *portrait = [upLoadImageManager judgeThePathForImages:userInfoRootModel.portrail];
    //NSString *portrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, userInfoRootModel.portrail];
    
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userID name:userInfoRootModel.name portrait:portrait];
    
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userID];
    
    
}

- (IBAction)aboutUsButtonClicked:(UIButton *)sender {
    MKAboutUsViewController *aboutVC = [[MKAboutUsViewController alloc] init];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutVC animated:YES];
}


- (IBAction)realNameAuthenButtonClicked:(UIButton *)sender {
    MKRealNameAuthenViewController *authenVC = [[MKRealNameAuthenViewController alloc] init];
    authenVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authenVC animated:YES];
}


- (IBAction)myWalletButtonClicked:(UIButton *)sender {
    MKMyWalletViewController *walletVC = [[MKMyWalletViewController alloc] init];
    walletVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:walletVC animated:YES];
}

- (IBAction)shareButtonClicked:(UIButton *)sender {
    MKShareAppViewController *shareVC = [[MKShareAppViewController alloc] init];
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (IBAction)userHeadPortraitClicked:(id)sender {
    MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
    memberInfoVC.hidesBottomBarWhenPushed = YES;
    memberInfoVC.userId = [NSString stringWithFormat:@"%ld", userInfoRootModel.id];
    [self.navigationController pushViewController:memberInfoVC animated:YES];
}

- (IBAction)fansButtonClicked:(UIButton *)sender {
    MKMyFriendsViewController *vc = [[MKMyFriendsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.showMemberPage = YES;
    vc.showMyFans     = YES;
    vc.targetUserId = [NSString stringWithFormat:@"%ld", userInfoRootModel.id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)followsButtonClicked:(UIButton *)sender {
    MKMyFriendsViewController *vc = [[MKMyFriendsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.showMemberPage = YES;
    vc.targetUserId = [NSString stringWithFormat:@"%ld", userInfoRootModel.id];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)allBilleClicked:(UIButton *)sender {

    
}
@end
