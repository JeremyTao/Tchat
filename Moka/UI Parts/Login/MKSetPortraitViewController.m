//
//  MKSetPortraitViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSetPortraitViewController.h"
#import "MKSelectTagsViewController.h"
#import "MKInterestTagsViewController.h"


@interface MKSetPortraitViewController ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;


@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation MKSetPortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"上传头像";
    [self hideBackButton];
    self.fd_interactivePopDisabled = YES;
    
    _nextStepButton.hidden = NO;
    _hintLabel.hidden = YES;
    _headImageView.layer.masksToBounds = YES;
    [self.navigationItem setHidesBackButton:YES];
    
}





- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    
    [self imageUpload];
    
}


- (IBAction)setHeadImageButtonClicked:(UIButton *)sender {
    [self showActionSheet];
}



#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    WEAK_SELF;
    [picker dismissViewControllerAnimated:YES completion:^{
        STRONG_SELF;
        UIImage *editedImage, *originalImage;
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/figurebuff.jpg"];
        BOOL created = [UIImageJPEGRepresentation(editedImage, 1.0) writeToFile:jpgPath atomically:YES];
        //NSLog(@"%@",NSHomeDirectory());
        if (created) {
            _headImageView.image = editedImage;
            [strongSelf detectFaceWithImage:editedImage];
            _nextStepButton.enabled = YES;
            _nextStepButton.backgroundColor = commonBlueColor;
            [MKTool addShadowOnView:_nextStepButton];
            
        }
        // 保存原图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
        }
    }];
}




- (void)detectFaceWithImage:(UIImage *)image {
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    NSArray *faces = [faceDetector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSLog(@"face count = %lu", (unsigned long)faces.count);
    
    //根据face数目更改界面
    if (faces.count >= 1) {
        _hintLabel.hidden = YES;
    } else {
        _hintLabel.hidden = NO;
    }
}


- (void)imageUpload {
    
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    UIImage *lastImage = [_headImageView.image scaleToWidth:2 * SCREEN_WIDTH];
    NSDictionary *prams = @{@"state" : @(1)};
   
    [[MKNetworkManager sharedManager]  post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_upLoadImage] params:prams image:lastImage success:^(id responseObject) {
        NSLog(@"上传图片: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            //上传图片成功
            if (_addInfo) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                MKInterestTagsViewController *selectTagsVC = [[MKInterestTagsViewController alloc] init];
                [self.navigationController pushViewController:selectTagsVC animated:YES];
            }
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:responseObject[@"message"] withSecond:2 inView:strongSelf.view];
        }
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
//        NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
//        [MKUtilAction doApiFailWithToken:errorResponse ctrl:strongSelf with:error];
        
    }];
    
}




@end
