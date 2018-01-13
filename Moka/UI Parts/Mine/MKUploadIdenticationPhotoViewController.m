//
//  MKUploadIdenticationPhotoViewController.m
//  Moka
//
//  Created by  moka on 2017/8/25.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKUploadIdenticationPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MKUploadIdenticationPhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
    NSInteger currentIndex;
    UIImage   *currentSetImage;
    UIImage   *cardImageFront;
    UIImage   *cardImageRear;
    UIImage   *cardImageHand;
}

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *popView;



@end

@implementation MKUploadIdenticationPhotoViewController


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




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"身份证认证"];
    self.title = @"身份证认证";
    
}

- (IBAction)uploadImageButtonClicked:(UIButton *)sender {
    currentIndex = sender.tag;
   
    [self showActionSheet];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;//设置可编辑
    
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage  *originalImage;
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/figurebuff.jpg"];
        BOOL created = [UIImageJPEGRepresentation(originalImage, 1.0) writeToFile:jpgPath atomically:YES];
        
        if (created) {
            currentSetImage = originalImage;
            
            [self refreshUserInterface];
        }
    }];
    
    
}

- (void)refreshUserInterface {
    switch (currentIndex) {
        case 1000:
            _imageView1.image = currentSetImage;
            cardImageFront = currentSetImage;
            break;
        case 2000:
            _imageView2.image = currentSetImage;
            cardImageRear = currentSetImage;
            break;
        case 3000:
            _imageView3.image = currentSetImage;
            cardImageHand = currentSetImage;
            break;
            
        default:
            break;
    }
    
    if (cardImageFront && cardImageRear && cardImageHand) {
        self.imageArray = @[cardImageFront, cardImageRear, cardImageHand];
        _uploadButton.backgroundColor = commonBlueColor;
        _uploadButton.enabled = YES;
        [MKTool addShadowOnView:_uploadButton];
    }
    
}


- (IBAction)uploadButtonDidClicked:(UIButton *)sender {
    [self requestUploadImages];
}



- (void)requestUploadImages{
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_uploadMultiImages] params:nil mutiImages:self.imageArray success:^(id responseObject) {
        NSLog(@"上传图片: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            //上传图片成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadAuthenImages" object:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                strongSelf.popView.alpha = 1;
            }];
            [strongSelf performSelector:@selector(dismissViewController) withObject:nil afterDelay:2];
            
            
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
    [self.navigationController popViewControllerAnimated:YES];
}

@end
