//
//  MKBaseViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface MKBaseViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) CBNavigationView *navigationView;
@end

@implementation MKBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    
    //self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@""];
    self.navigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //_navigationView = [[CBNavigationView alloc] initWithTitle:@"" delegate:self];
    //[self.view addSubview:_navigationView];
    //[self setNavigationBarStyle:NavigationBarStyleWhite];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.activityIndicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,100,100)];
    self.activityIndicatorView.center = [UIApplication sharedApplication].keyWindow.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:self.activityIndicatorView];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)hideBackButton{
    _navigationView.backButton.hidden = YES;
}

-(void)showBackButton{
    _navigationView.backButton.hidden = NO;
}

- (void)showNavigationView {
    _navigationView.hidden = NO;
}

-(void)hideNavigationView{
    _navigationView.hidden = YES;
}

- (void)setNavigationTitle:(NSString *)title {
    _navigationView.title = title;
}


- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCenterImageViewWithName:(NSString *)imageName {
    [_navigationView setCenterImageViewWithName:imageName];
}

///设置导航栏样式
- (void)setNavigationBarStyle:(NavigationBarStyle)style {
    [_navigationView setNavigationViewStyle:style];
}

- (void)setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)color imageName:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [_navigationView setLeftButtonWithTitle:title titleColor:color imageName:imageName addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)color  imageName:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [_navigationView setRightButtonWithTitle:title titleColor:color imageName:imageName addTarget:target action:action forControlEvents:controlEvents];
}

- (void)hideRightButton {
    [_navigationView hideRightButton];
}

- (void)showRightButton {
    [_navigationView showRightButton];
}

- (void)setSreachBarPlaceholder:(NSString *)placeholder {
    [_navigationView setSreachBarPlaceholder:placeholder];
}

- (void)bringNavigationViewToFront {
    [self.view bringSubviewToFront:_navigationView];
}

- (void)setTitleViewWithUrl:(NSString *)imgUrl {
    [_navigationView setTitleViewWithUrl:imgUrl];
}

- (void)showSearchBarWithDelegate:(id<UITextFieldDelegate>)delegate {
    [_navigationView showSearchBarWithDelegate:delegate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark 头像的选择

-(void)showActionSheet{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark UIActionSheetDelegate M
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    
    if (buttonIndex == 0) {
        //        拍照
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
        //        相册
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage, *originalImage;
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //        __weak typeof(self) weakSelf = self;
        
        
        // 保存原图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showNavigationBarShadow {
    [_navigationView showNavigationBarShadow];
}
- (void)removeNavigationBarShadow {
    [_navigationView removeNavigationBarShadow];
}


@end
