//
//  MKRechargeCoinsViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRechargeCoinsViewController.h"
#import "NYTPhotosViewController.h"
#import "IBShowPhoto.h"
#import "RCDCustomerServiceViewController.h"
#import "upLoadImageManager.h"
#import "MKSecurity.h"

@interface MKRechargeCoinsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *myAdressLabel;
@property (strong, nonatomic) NSMutableArray *photosArray;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel1;

@property (copy, nonatomic) NSString *phoneStr;
@property (copy, nonatomic) NSString *walletAddressStr;

@end

@implementation MKRechargeCoinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    [self setNavigationTitle:@"充值"];
    self.myAdressLabel.copyingEnabled = YES;
    
    [self requestRechargeQRcodeAndAdress];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(kefuClicked:)];
}



-(void)kefuClicked:(UIBarButtonItem *)kefu{
    
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


//- (void)addTapGesture {
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOnImageView:)];
//    [_qrCodeImageView addGestureRecognizer:tap];
//    _qrCodeImageView.userInteractionEnabled = YES;
//}


//- (void)tapGestureOnImageView:(UITapGestureRecognizer *)sender {
//    if (self.photosArray.count > 0) {
//        IBShowPhoto *selectPhoto = self.photosArray[0];
//        NYTPhotosViewController *photoVC = [[NYTPhotosViewController alloc] initWithPhotos:self.photosArray initialPhoto:selectPhoto];
//
//        [self presentViewController:photoVC animated:YES completion:nil];
//        [self updateImagesOnPhotosViewController:photoVC afterDelayWithPhotos:self.photosArray];
//
//    }
//}

//- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //加载图片
//        for (int i = 0; i < photos.count; i ++) {
//            IBShowPhoto *photo = photos[i];
//
//            SDWebImageManager *manager = [SDWebImageManager sharedManager];
//
//            [manager downloadImageWithURL:[NSURL URLWithString:_qrCodeUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                if (image) {
//                    photo.image = image;
//                    [photosViewController updateImageForPhoto:photo];
//                }
//            }];
//
//
//        }
//
//    });
//
//}




#pragma mark - 充值查询

- (void)requestRechargeQRcodeAndAdress {
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_walletRecharge] params:nil success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"充值查询 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];

        if (status == 200) {
            _phoneStr = json[@"dataObj"][@"phone"];
            _walletAddressStr = json[@"dataObj"][@"address"];

            [self showWalletAddress:_walletAddressStr Phone:_phoneStr];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }

    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
    
}
//
-(void)showWalletAddress:(NSString *)walletAddress Phone:(NSString *)phone{

    //TV地址
    _myAdressLabel.text = walletAddress;
    //用户提示信息
    _warnLabel.text = [NSString stringWithFormat:@"注:这是您的钛值(TV)充值地址，请将您的钛值(TV)转入此地址，并务必在备注框中填写%@，填写错误将无法到账！！!",_phoneStr];
    _warnLabel.textColor = [UIColor blackColor];
    NSString *contentStr = _warnLabel.text;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(37, 3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(43, 24)];
    _warnLabel.attributedText = str;
    
    //
    _warnLabel1.text = [NSString stringWithFormat:@"2.您在操作钛值钱包向此地址转账时，务必填上备注信息：%@，否则将无法到账。",_phoneStr];
    NSString *contentStr1 = _warnLabel1.text;
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:contentStr1];
    //
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(18, 20)];
    _warnLabel1.attributedText = str1;
}

//
//
//- (NSMutableArray *)photosArray {
//    if (!_photosArray) {
//        _photosArray = [NSMutableArray array];
//    }
//    return _photosArray;
//}


@end
