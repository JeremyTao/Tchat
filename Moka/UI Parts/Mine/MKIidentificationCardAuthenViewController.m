//
//  MKIidentificationCardAuthenViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//


#define HINT_FRONT @"拍摄身份证正面"
#define HINT_REAR  @"拍摄身份证背面"
#define HINT_HAND  @"拍摄手持身份证"

#import "MKIidentificationCardAuthenViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface MKIidentificationCardAuthenViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
    UIImagePickerController *imagePickerController;
    NSMutableArray *imageArray;
    UIImage        *currentImageCreated;
    NSInteger      currentStep;
}


@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *popView;


@end

@implementation MKIidentificationCardAuthenViewController





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相机使用权限受限" message:@"请在设置中打开相机使用权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionDefault];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        self.isPresented = NO;
        // forces a return to portrait orientation
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationView];
    imageArray = @[].mutableCopy;
    currentStep = 0;
    self.isPresented = YES;
    [self takeImageWithCamera];

}

- (void)takeImageWithCamera {
    self.topView.alpha = 1;
    // 判断有摄像头，并且支持拍照功能
    if ([self isCameraAvailable] ){
        // 初始化图片选择控制器
        imagePickerController = [[UIImagePickerController alloc] init];
        
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerController setAllowsEditing:NO];
        [imagePickerController setDelegate:self];
       
        [self.view addSubview:imagePickerController.view];
        imagePickerController.view.frame = self.view.bounds;
        [self addChildViewController:imagePickerController];
        [self.view sendSubviewToBack:imagePickerController.view];
        [self performSelector:@selector(autoHideImageAndHint) withObject:nil afterDelay:5];
    }else {
        NSLog(@"Camera is not available.");
    }
    
}

- (void)autoHideImageAndHint {
    [UIView animateWithDuration:0.3 animations:^{
        self.topView.alpha = 0;
    }];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage  *originalImage;
    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/figurebuff.jpg"];
    BOOL created = [UIImageJPEGRepresentation(originalImage, 1.0) writeToFile:jpgPath atomically:YES];
    //NSLog(@"%@",NSHomeDirectory());
    if (created) {
        currentImageCreated = originalImage;
        [imageArray addObject:currentImageCreated];
        currentStep += 1;
        [self nextStepUI];
    }
//    // 保存原图片到相册中
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
//    }
//    
    
    //继续拍照
    //关闭相册界面
    [UIView animateWithDuration:0.001 animations:^{
        [imagePickerController.view removeFromSuperview];
    } completion:^(BOOL finished){
        //重新打开相机
        if (imageArray.count == 3) {
            return;
        }
        [self takeImageWithCamera];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewController];
}



- (void)nextStepUI {
   
    switch (currentStep) {
        case 0: {
            _cardImageView.image = IMAGE(@"idcard_front");
            _hintLabel.text = HINT_FRONT;
        } break;
        case 1: {
            _cardImageView.image = IMAGE(@"idcard_rear");
            _hintLabel.text = HINT_REAR;
        } break;
        case 2: {
            _cardImageView.image = IMAGE(@"handheld_idcard");
            _hintLabel.text = HINT_HAND;
        } break;
        default:
            break;
    }
    
    if (imageArray.count == 3) {
        [self requestUploadImages];
    }
    
    
}

- (void)requestUploadImages{
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];

    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_uploadMultiImages] params:nil mutiImages:imageArray success:^(id responseObject) {
        NSLog(@"上传图片: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            //上传图片成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadAuthenImages" object:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                _popView.alpha = 1;
            }];
            [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:2];
           
        
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:responseObject[@"message"] withSecond:2 inView:strongSelf.view];
        }
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);

        
    }];

}

- (void)dismissViewController {
     self.isPresented = NO;
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}



- (IBAction)backButtonClicked:(id)sender {
    self.isPresented = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (UIInterfaceOrientationMask) supportedInterfaceOrientations
//{
//   
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
//
//- (BOOL) shouldAutorotate {
//    return NO;
//}
//
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeLeft;
//}

@end
