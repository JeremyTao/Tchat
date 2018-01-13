//
//  MKCompleteGroupInfoViewController.m
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKCompleteGroupInfoViewController.h"
#import "PYSearchConst.h"
#import "InputLimitedTextView.h"
#import "UIImage+scareUplodeImage.h"
#import "MKInterestTagModel.h"
#import <MapKit/MapKit.h>
#import "MKGroupInfoViewController.h"

@interface MKCompleteGroupInfoViewController ()<CLLocationManagerDelegate, UIScrollViewDelegate>

{
    NSMutableArray *myTagsArray;    //标签字符串数组
    NSArray        *tagsArr;        ///标签<Label*>数组
    NSMutableArray *tagModelArray;   //标签模型数字
    //-----创建圈子必填参数-----
    NSInteger      ifpay;
    CGFloat      pay;
    NSInteger      ifImg;
    NSString      *name;
    NSString      *introduce;
    NSString      *lableids;
    CGFloat        coordinatex;
    CGFloat        coordinatey;
    //-----------------------
    NSString      *createdCircleId;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UITextField *circleNameTextField;
@property (weak, nonatomic) IBOutlet InputLimitedTextView *circleInfoTextView;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *popView;

@property (weak, nonatomic) IBOutlet UIView *tagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeight;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MKCompleteGroupInfoViewController

- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"完善圈子信息"];
    self.title = @"完善圈子信息";
    [self initParams];
    [self initUI];
    [self setupLocationManager];
    [self requestGetTags];
}


- (void)initUI {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    _circleNameTextField.leftView = leftView;
    _circleNameTextField.leftViewMode = UITextFieldViewModeAlways;
    //_circleNameTextField.delegate = self;
    [_circleNameTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    //2.监听textView文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
    [MKTool addGrayShadowOnView:_popView];
    
    _baseScrollView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    _contentView.userInteractionEnabled = YES;
    [_contentView addGestureRecognizer:tap];
    
    _popView.layer.cornerRadius = 5;
    _popView.layer.masksToBounds= YES;
}

- (void)initParams {
    ifpay = self.ifPay;
    pay   = self.payCount;
    _popView.alpha = 0;
    myTagsArray   = @[].mutableCopy;
    tagModelArray = @[].mutableCopy;
}

- (void)setupLocationManager {
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

- (void)textFieldChanged:(UITextField *)textField {
   
    name = textField.text;
    if (textField.text.length > 32) {
        textField.text = [textField.text substringToIndex:32];
    }
    
    [self setupNextButtonState];
}

- (void)textViewDidChange {
    
    introduce = _circleInfoTextView.text;
    [self setupNextButtonState];
}

- (IBAction)setImageButtonClicked:(UIButton *)sender {
   [self showActionSheet];
}

- (BOOL)checkInfoCompletion {
    
    if (ifImg == 0 || name.length == 0 || introduce.length == 0 || lableids.length == 0) {
        
        return NO;
    }
    
    return YES;
    
}

- (void)setupNextButtonState {
    if ([self checkInfoCompletion]) {
        _nextStepButton.enabled = YES;
        _nextStepButton.backgroundColor = commonBlueColor;
        [MKTool addShadowOnView:_nextStepButton];
    } else {
        _nextStepButton.backgroundColor = RGB_COLOR_HEX(0xE5E5E5);
        _nextStepButton.enabled = NO;
        [MKTool removeShadowOnView:_nextStepButton];
    }
}


#pragma mark -- UITextFiledDelegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (_circleNameTextField == textField) {
//        if ([toBeString length] > 32) {
//            textField.text = [toBeString substringFromIndex:32];
//            return NO;
//        }
//    }
//    return YES;
//}

#pragma mark - 提交 点击

- (IBAction)commitButtonClicked:(UIButton *)sender {
    
//    if ([self deptNumInputShouldNumber:_circleNameTextField.text]) {
//        [MKUtilHUD showHUD:@"圈名不能为纯数字" inView:self.view];
//        return;
//    }
    BOOL isOK = [self checkInputNameText:_circleNameTextField.text];
    if (isOK) {
        [self requestCreateCircel];
    }
    
}

//- (BOOL)deptNumInputShouldNumber:(NSString *)str
//{
//    NSString *regex = @"[0-9]*";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    if ([pred evaluateWithObject:str]) {
//        return YES;
//    }
//    return NO;
//}

-(BOOL)checkInputNameText:(NSString *)tx{
    
    if ([tx length]<2) {
        [MKUtilHUD showHUD:@"圈子名称过短" inView:nil];
        return NO;
    }else if ([tx length] > 32){
        [MKUtilHUD showHUD:@"圈子名称过长" inView:nil];
        return NO;
    }
    return YES;
}

- (void)dismissPopView {
    [UIView animateWithDuration:0.2 animations:^{
        _popView.alpha = 0;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATED_CIRCLE" object:nil];
        
        if (_isFromChat) {
            UIViewController *circleVC = self.navigationController.viewControllers[1];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ChatNewCreatedCircle"];
            [[NSUserDefaults standardUserDefaults] setObject:createdCircleId forKey:@"ChatNewCircleId"];
            [self.navigationController popToViewController:circleVC animated:NO];
             
        } else {
            //自动跳转
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShowNewCreatedCircle"];
            [[NSUserDefaults standardUserDefaults] setObject:createdCircleId forKey:@"createdCircleId"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        
       
    }];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
 
    [picker dismissViewControllerAnimated:YES completion:^{
     
        UIImage *editedImage, *originalImage;
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/figurebuff.jpg"];
        BOOL created = [UIImageJPEGRepresentation(editedImage, 1.0) writeToFile:jpgPath atomically:YES];
        //NSLog(@"%@",NSHomeDirectory());
        if (created) {
            _circleImageView.image = editedImage;
            ifImg = 1;
            [self setupNextButtonState];
        }
        // 保存原图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
        }
    }];
}

#pragma mark - 更新位置📍
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Remember for later the user's current location.
    CLLocation *currentUserLocation = locations.lastObject;
    coordinatex = currentUserLocation.coordinate.latitude;
    coordinatey = currentUserLocation.coordinate.longitude;
    NSLog(@"%@", currentUserLocation);
    [manager stopUpdatingLocation];
    manager.delegate = nil;
}


#pragma mark - 创建圈子

- (void)requestCreateCircel {
    
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    UIImage *lastImage = [_circleImageView.image scaleToWidth:2 * SCREEN_WIDTH];
    NSDictionary *prams = @{@"ifpay"      : @(ifpay),
                            @"pay"        : @(pay),
                            @"name"       : name,
                            @"introduce"  : introduce,
                            @"lableids"   : lableids,
                            @"coordinatex": @(coordinatex),
                            @"coordinatey": @(coordinatey)};
    
    [[MKNetworkManager sharedManager]  post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_create_circle] params:prams image:lastImage success:^(id responseObject) {
        NSLog(@"创建圈子: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            //创建圈子成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatedNewCircle" object:nil];
            createdCircleId = [NSString stringWithFormat:@"%@", responseObject[@"dataObj"]];
            _popView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            [UIView animateWithDuration:0.3 animations:^{
                _popView.alpha = 1;
                _popView.transform =  CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self performSelector:@selector(dismissPopView) withObject:nil afterDelay:1.2];
            }];
            
            
        } else {
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

#pragma mark - http :获取标签

- (void)requestGetTags {
    NSDictionary *param = @{@"state":@(6)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getTags] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"获取标签 %@",json);
        if (status == 200) {
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKInterestTagModel *model = [[MKInterestTagModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [tagModelArray addObject:model];
                [myTagsArray addObject:model.name];
            }
            //创建标签视图
            [strongSelf removeTagsWith:tagsArr];
            tagsArr = [strongSelf createMovieLabelsWithContentView:_tagsView
                                            layoutConstraint:_tagsViewHeight
                                                   tagsArray:myTagsArray];
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





#pragma mark - 创建标签
- (NSArray *)createMovieLabelsWithContentView:(UIView *)contentView layoutConstraint:(NSLayoutConstraint *)heightConstraint tagsArray:(NSArray *)tagTexts {
    if (tagTexts.count == 0) {
        return nil;
    }
    
    
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        
        [contentView addSubview:label];
        [tagsM addObject:label];
        label.tag = 1000 + i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTagLabel:)];
        [label addGestureRecognizer:tap];
    }
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    CGFloat offsetX = 15;
    CGFloat offsetY = 10;
    
    
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        // When the number of search words is too large, the width is width of the contentView
        if (subView.py_width > contentView.py_width) subView.py_width = contentView.py_width;
        if (currentX + subView.py_width + PYSEARCH_MARGIN * countRow > contentView.py_width) {
            subView.py_x = offsetX;
            subView.py_y = (currentY += subView.py_height) + PYSEARCH_MARGIN * ++countCol + offsetY;
            currentX = subView.py_width;
            countRow = 1;
        } else {
            subView.py_x = (currentX += subView.py_width) - subView.py_width + PYSEARCH_MARGIN * countRow + offsetX;
            subView.py_y = currentY + PYSEARCH_MARGIN * countCol + offsetY;
            countRow ++;
        }
    }
    
    contentView.py_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    heightConstraint.constant = contentView.py_height + 10;
    
    [self.view layoutIfNeeded];
    //设置边框
    for (UILabel *tag in tagsM) {
        tag.backgroundColor = [UIColor clearColor];
        tag.layer.borderColor = RGB_COLOR_HEX(0xC4D0FF).CGColor;
        tag.layer.borderWidth = 1;
        tag.layer.cornerRadius = tag.py_height * 0.5;
    }
    
    return tagsM;
}

#pragma mark - 标签点击

- (void)tapTagLabel:(UITapGestureRecognizer *)gr {
    UILabel *label = (UILabel *)gr.view;
    NSInteger index = label.tag - 1000;
    PYSEARCH_LOG(@"点击标签 %@, index %ld", label.text, (long)index);
    
    //从模型数组取出model
    MKInterestTagModel *tagModel = tagModelArray[index];
    if (!tagModel.selected) {
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = commonBlueColor;
        label.layer.borderWidth = 0;
        //[self drawGradientLayerOnView:label.superview];
        tagModel.selected = 1;
    } else {
        label.textColor = RGB_COLOR_HEX(0x666666);
        label.backgroundColor = [UIColor whiteColor];
        label.layer.borderWidth = 1;
        tagModel.selected = 0;
    }
    
    //查找选择的标签
    NSMutableArray *tempArr = @[].mutableCopy;
    for (MKInterestTagModel *tagModel in tagModelArray) {
        if (tagModel.selected) {
            [tempArr addObject:[NSString stringWithFormat:@"%ld", (long)tagModel.id]];
        }
    }
    
    lableids  = [tempArr componentsJoinedByString:@","];
    
    [self setupNextButtonState];
    
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = RGB_COLOR_HEX(0x666666);
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.py_width += 30;
    label.py_height += 20;
    return label;
}

- (void)removeTagsWith:(NSArray *)arr {
    for (UILabel *label in arr) {
        [label removeFromSuperview];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        [self.view endEditing:YES];
    }
}



@end
