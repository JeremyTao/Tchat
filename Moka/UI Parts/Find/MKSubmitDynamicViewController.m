//
//  MKSubmitDynamicViewController.m
//  Moka
//
//  Created by  moka on 2017/8/7.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSubmitDynamicViewController.h"
#import "InputLimitedTextView.h"
#import "YZInputView.h"

@interface MKSubmitDynamicViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    BOOL isSelectImg;
}

@property (weak, nonatomic) IBOutlet UIView *editBackgroundView;
@property (weak, nonatomic) IBOutlet YZInputView *myTextView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UILabel *remainCountLabel;

@end

@implementation MKSubmitDynamicViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_myTextView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"发动态"];
    self.title = @"发动态";
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"发布" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(submmit) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.navigationItem.rightBarButtonItem = menuItem;
    
    //[self setRightButtonWithTitle:@"发布" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(submmit)  forControlEvents:UIControlEventTouchUpInside];
    if (_onlyText) {
        _myImageView.hidden = YES;
        _hintLabel.hidden   = YES;
        _imageWidth.constant = 0;
    }
    self.myTextView.layer.borderWidth = 0;
    self.myTextView.layer.borderColor = [UIColor clearColor].CGColor;
    // 监听文本框文字高度改变
    
    self.myTextView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        
        _textViewHeight.constant = MIN(textHeight, 200);
        if (_textViewHeight.constant == 200) {
            _myTextView.scrollEnabled = YES;
        }
        
        
    };
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
    
}

- (void)textViewDidChange {
    //限制字数1000
    if (self.myTextView.text.length > 1000) {
        _myTextView.text = [_myTextView.text substringToIndex:1000];
    }
    _remainCountLabel.text = [NSString stringWithFormat:@"还可以输入%lu个字",1000 - _myTextView.text.length];
}


- (void)submmit {
    if (_onlyText) {
        [self requestSubmmitTextDynamic];
    } else {
        [self requestSubmmitPictureDynamic];
    }
    
}


- (IBAction)addImageGesture:(UITapGestureRecognizer *)sender {
    [self showActionSheet];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   
    [picker dismissViewControllerAnimated:YES completion:^{
   
        UIImage  *originalImage;
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/figurebuff.jpg"];
        BOOL created = [UIImageJPEGRepresentation(originalImage, 1.0) writeToFile:jpgPath atomically:YES];
        //NSLog(@"%@",NSHomeDirectory());
        if (created) {
            _myImageView.image = originalImage;
            _hintLabel.hidden = YES;
            isSelectImg = YES;
        }
        // 保存原图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
        }
    }];
}

#pragma mark UIActionSheetDelegate M
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


#pragma mark - 发布动态

- (void)requestSubmmitPictureDynamic {
    if (!isSelectImg) {
        [MKUtilHUD showHUD:@"请先选择一张图片" inView:self.view];
        return;
    }
    
    CGFloat  coordinatex =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"coordinatex"] floatValue];
    CGFloat  coordinatey =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"coordinatey"] floatValue];
    
    NSDictionary *paramDitc = @{@"text" : _myTextView.text, @"coordinatex": @(coordinatex), @"coordinatey" : @(coordinatey)};
    UIImage *lastImage = [_myImageView.image scaleToWidth:2 * SCREEN_WIDTH];
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager]  post:[NSString stringWithFormat:@"%@%@", WAP_URL, api_post_dynamic] params:paramDitc image:lastImage success:^(id responseObject) {
        DLog(@"发布动态: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SUBMMITED_DYNAMIC" object:nil];
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        } else {
            NSLog(@"-------------------------%@-----------------------",responseObject[@"exception"]);
            [MKUtilHUD showAutoHiddenTextHUD:responseObject[@"exception"] withSecond:2 inView:strongSelf.view];
        }
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)requestSubmmitTextDynamic {
    
    if (_myTextView.text.length == 0) {
        [MKUtilHUD showHUD:@"请先输入内容" inView:self.view];
        return;
    }
    
    CGFloat  coordinatex =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"coordinatex"] floatValue];
    CGFloat  coordinatey =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"coordinatey"] floatValue];
    
    NSDictionary *paramDitc = @{@"text" : _myTextView.text, @"coordinatex": @(coordinatex), @"coordinatey" : @(coordinatey)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager]  post:[NSString stringWithFormat:@"%@%@", WAP_URL, api_post_dynamic] params:paramDitc success:^(id responseObject) {
        DLog(@"发布动态: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SUBMMITED_DYNAMIC" object:nil];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"-------------------------%@-----------------------",responseObject[@"exception"]);
            [MKUtilHUD showAutoHiddenTextHUD:responseObject[@"exception"] withSecond:2 inView:strongSelf.view];
        }
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}

@end
