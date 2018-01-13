//
//  MKEditProfileViewController.m
//  Moka
//
//  Created by Knight on 2017/7/25.
//  Copyright © 2017年 moka. All rights reserved.
//

#define MAX_PHOTOS_NUM 6

#import "MKEditProfileViewController.h"
#import "PYSearchConst.h"
#import "MKPortraitModel.h"
#import "YPCommentView.h"
#import "TZImagePickerController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "UIImage+scareUplodeImage.h"
#import "MKInterestTagModel.h"
#import "MKEditNameViewController.h"
#import "MKEditBirthdayViewController.h"
#import "MKEditLocationViewController.h"
#import "MKRelationshipViewController.h"
#import "MKEditHobbyTagsViewController.h"
#import "MKEditIndustryViewController.h"
#import "MKEditSignatureViewController.h"
#import "upLoadImageManager.h"


typedef enum : NSUInteger {
    EditName,
    EditSignature,
    EditBirthday,
    EditLocation,
    EditIndustry,
    EditRelationship,
    EditMyTags,
    EditMovies,
    EditFoods,
    EditSports
} EditInfo;

@interface MKEditProfileViewController ()<backHeightDelegater, YPPhotosViewDelegate>

{
    NSMutableArray *myTagsArray;    //我的标签
    NSMutableArray *myMoviesArray;    //我的电影
    NSMutableArray *myFoodsArray;    //我的电影
    NSMutableArray *mySportsArray;    //我的电影
    EditInfo currentEditInfo; //当前要更改的
    
    NSArray *tagsArr;
    NSArray *moviesArr;
    NSArray *foodsArr;
    NSArray *sportsArr;
    
}

//照片墙

@property (weak, nonatomic) IBOutlet UIView *photosBaseView;
@property (nonatomic,strong)YPPhotosView *photosView;
@property (nonatomic,strong)NSMutableArray *imgArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosBaseViewHeight;
@property (assign, nonatomic) NSInteger rowH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewToTop;

//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//性别
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
//生日
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
//来自
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//行业
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;
//情感状态
@property (weak, nonatomic) IBOutlet UILabel *relationshipLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

//我的标签
@property (weak, nonatomic) IBOutlet UIView *myTagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTagsViewHeight;

@property (weak, nonatomic) IBOutlet UIView *moviesTagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moviesTagsViewHeight;

@property (weak, nonatomic) IBOutlet UIView *foodsTagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foodTagsViewHeight;

@property (weak, nonatomic) IBOutlet UIView *sportsTagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sportsTagsViewHeight;




@end

@implementation MKEditProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //基本信息
    [self loadUserInfomation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"编辑资料"];
    self.title = @"编辑资料";
    [self configurePhotosView];
    [self updatePhotoWall];
    
}

#pragma mark - 加载用户的信息 

- (void)loadUserInfomation {
    
    //基本信息
    [self updateUserBasicInfo];
    
    //标签
    [self updateUserTags];
}



- (void)updateUserBasicInfo {
    _phoneLabel.text = self.infoModel.phone;          //2.手机号
    _nameLabel.text = self.infoModel.name;            //3.昵称
    _signatureLabel.text = self.infoModel.autograph;  //签名
    if (self.infoModel.sex == 1) {
        _genderLabel.text = @"女";
    } else if (self.infoModel.sex == 2) {
        _genderLabel.text = @"男";                     //4.性别
    } else {
        _genderLabel.text = @"";
    }
    _birthdayLabel.text = self.infoModel.birthday;     //5.生日
    
    _locationLabel.text = self.infoModel.address;      //6.来自
    
    _industryLabel.text = self.infoModel.industryName; //7.行业
    
    
    if (self.infoModel.feeling == 1) {                  //8.情感状态 0 未  1 单身  2 已婚
        self.relationshipLabel.text = @"单身";
    } else if (self.infoModel.feeling == 2) {
        self.relationshipLabel.text = @"已婚";
    } else {
        self.relationshipLabel.text = @"";
    }
}


- (void)updateUserTags {
    myTagsArray = @[].mutableCopy;
    for (MKInterestTagModel *tagModel in self.infoModel.mylableList) {
        [myTagsArray addObject:tagModel.name];
    }
    [self removeTagsWith:tagsArr];
    tagsArr = [self createMovieLabelsWithContentView:_myTagsView
                                    layoutConstraint:_myTagsViewHeight
                                           tagsArray:myTagsArray];
    
    myMoviesArray = @[].mutableCopy;
    for (MKInterestTagModel *tagModel in self.infoModel.filmList) {
        [myMoviesArray addObject:tagModel.name];
    }
    [self removeTagsWith:moviesArr];
    moviesArr = [self createMovieLabelsWithContentView:_moviesTagsView
                                      layoutConstraint:_moviesTagsViewHeight
                                             tagsArray:myMoviesArray];
    
    myFoodsArray = @[].mutableCopy;
    for (MKInterestTagModel *tagModel in self.infoModel.foodList) {
        [myFoodsArray addObject:tagModel.name];
    }
    [self removeTagsWith:foodsArr];
    foodsArr = [self createMovieLabelsWithContentView:_foodsTagsView
                                     layoutConstraint:_foodTagsViewHeight
                                            tagsArray:myFoodsArray];
    
    mySportsArray = @[].mutableCopy;
    for (MKInterestTagModel *tagModel in self.infoModel.motionList) {
        [mySportsArray addObject:tagModel.name];
    }
    [self removeTagsWith:sportsArr];
    sportsArr = [self createMovieLabelsWithContentView:_sportsTagsView
                                      layoutConstraint:_sportsTagsViewHeight
                                             tagsArray:mySportsArray];
}


- (void)updatePhotoWall {
    
    [self.imgArr removeAllObjects];
    [_photosView setYPPhotosView:nil];
    
    for (MKPortraitModel *imgModel in _infoModel.portrailList) {
        [self loadImage:imgModel.img];
    }
}



-(void)loadImage:(NSString *)imageUrl{
    //
    NSString *fullURL = [upLoadImageManager judgeThePathForImages:imageUrl];
    //NSString *fullURL = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, imageUrl];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //
    
    [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", fullURL]]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if (image) {
                                [_imgArr addObject:image];
                                NSArray *arr = @[];
                                arr = [_imgArr arrayByAddingObjectsFromArray:@[[UIImage imageNamed:@"add_image"]]];
                                [_photosView setYPPhotosView:arr];
                            }else{
                                [_imgArr addObject:[UIImage imageNamed:@"edit_placeholder"]];
                                NSArray *arr = @[];
                                arr = [_imgArr arrayByAddingObjectsFromArray:@[[UIImage imageNamed:@"add_image"]]];
                                [_photosView setYPPhotosView:arr];
                            }
                        }];
}

- (void)removeTagsWith:(NSArray *)arr {
    for (UILabel *label in arr) {
        [label removeFromSuperview];
    }
}


#pragma mark - YPPhotosViewDelegate

- (void)didSelectPhotoAtIndexRow:(NSInteger)index {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *actionSetProtait = [UIAlertAction actionWithTitle:@"设为头像" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self requestSetPortraitImageWithIndex:index];
    }];
    
    UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        if (self.imgArr.count == 1) {
            [MKUtilHUD showHUD:@"不能删除最后一张照片" inView:self.view];
            return;
        }
        
        [self requestDeleteImageWithIndex:index];
        
    }];
    
    
    [alertController addAction:actionSetProtait];
    [alertController addAction:actionDelete];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark- HTTP 请求个人中心

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
            
            NSLog(@"----------------%@",json[@"dataObj"]);
            
            
            _infoModel = [MKUserInfoRootModel mj_objectWithKeyValues:json[@"dataObj"]];
            
            [strongSelf loadUserInfomation];
            [strongSelf updatePhotoWall];
            
            
            NSLog(@"-----头像------------%@",json[@"dataObj"][@"portrail"]);
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - HTTP 上传照片
- (void)requestImageUpload:(NSArray *)imageArray {
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    
    NSDictionary *prams = @{@"state" : @(2)};
   
    [[MKNetworkManager sharedManager]  post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_upLoadImage] params:prams mutiImages:imageArray success:^(id responseObject) {
        NSLog(@"上传图片: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            //上传图片成功
            /*
            NSMutableArray *tempArray = @[].mutableCopy;
           
            [tempArray appendObjects:_infoModel.portrailList];
            
            for (NSDictionary *dict in responseObject[@"dataObj"]) {
                MKPortraitModel *newPortraitModel = [[MKPortraitModel alloc] init];
                [newPortraitModel setValuesForKeysWithDictionary:dict];
                [tempArray addObject:newPortraitModel];
            }
            _infoModel.portrailList = tempArray;
            */
            [strongSelf rquestUserInfomation];
           
            

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
#pragma mark - HTTP 删除照片
- (void)requestDeleteImageWithIndex:(NSInteger)index {
    NSDictionary *prams;
    MKPortraitModel *imgModel = _infoModel.portrailList[index];
    if (imgModel.state == 2) {
        //不是关键照片，直接删除
        prams = @{@"id" : @(imgModel.id), @"state":@(2)};
    }
    if (imgModel.state == 1) {
        //删除了头像
        if (index + 1 <= _infoModel.portrailList.count) {
            MKPortraitModel *nextImgModel = _infoModel.portrailList                                                                 [index + 1];
            prams = @{@"id" : @(imgModel.id), @"state":@(1), @"ids":@(nextImgModel.id)};
        }
    }
    

    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager]  post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_deleteImage] params:prams  success:^(id responseObject) {
        NSLog(@"删除图片: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            [_photosView deleteImageAtIndex:index];
            [self.imgArr removeObjectAtIndex:index];
            
            NSMutableArray *tempArr = @[].mutableCopy;
            [tempArr setArray:_infoModel.portrailList];
            [tempArr removeObjectAtIndex:index];
            _infoModel.portrailList = tempArr;
            [strongSelf updatePhotoWall];
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



#pragma mark - HTTP 设置头像

- (void)requestSetPortraitImageWithIndex:(NSInteger)index {
    
    MKPortraitModel *imgModel = _infoModel.portrailList[index];
    MKPortraitModel *portaitModel = _infoModel.portrailList.firstObject;
    NSDictionary *prams = @{@"id" : @(imgModel.id), @"state":@(1), @"ids":@(portaitModel.id)};
    
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager]  post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_setPortrait] params:prams  success:^(id responseObject) {
        NSLog(@"设置头像: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            [MKUtilHUD showAutoHiddenTextHUD:@"设置成功" withSecond:2 inView:strongSelf.view];
            imgModel.state = 1;
            portaitModel.state = 2;
            NSMutableArray *tempArry = @[].mutableCopy;
            for (MKPortraitModel *model in _infoModel.portrailList) {
                if (model.state == 2) {
                    [tempArry addObject:model];
                } else {
                    [tempArry insertObject:model atIndex:0];
                }
            }
            
            _infoModel.portrailList = tempArry;
            [strongSelf updatePhotoWall];
            
            
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



#pragma mark - 配置照片墙View
-(void)configurePhotosView {
    
    if (iPhone5) {
        _rowH = 85;
    } else if (iPhone6) {
        _rowH = 114;
    } else if (iPhone6plus) {
        _rowH = 120;
    }
    
    _photosView = [[YPPhotosView alloc] initWithFrame:CGRectMake(0, 30 , _photosBaseView.frame.size.width, _rowH)];
    _photosView.backgroundColor = [UIColor whiteColor];
    _photosView.myHDelegaher = self;
    _photosView.myPhotoDelegate = self;
    [_photosView setYPPhotosView:@[[UIImage imageNamed:@"add_image"]]];
    WEAK_SELF;
    
    _photosView.clicklookImage = ^(NSInteger index , NSArray *imageArr){
        STRONG_SELF;
        YPImagePreviewController *yvc = [YPImagePreviewController new];
        yvc.images = imageArr ;
        yvc.index = index ;
        UINavigationController *uvc = [[UINavigationController alloc]initWithRootViewController:yvc];
        [strongSelf presentViewController:uvc animated:YES completion:nil];
    };
    
    _photosView.clickChooseView = ^{
        STRONG_SELF;
        // 调用相册
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_PHOTOS_NUM - strongSelf.imgArr.count delegate:nil];
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            NSArray *arr = @[];
            if (( strongSelf.imgArr.count + photos.count) > MAX_PHOTOS_NUM) {
                [MKUtilHUD showMoreHUD:@"最多可选择6张图片" inView:strongSelf.view];
                return;
            }
            [strongSelf.imgArr addObjectsFromArray:photos];
            [strongSelf requestImageUpload:photos];
            NSLog(@"%ld",strongSelf.imgArr.count);
            arr = [strongSelf.imgArr arrayByAddingObjectsFromArray:@[[UIImage imageNamed:@"add_image"]]];
            
            
        }];
        [strongSelf presentViewController:imagePickerVc animated:YES completion:nil];
        
    };
    
    //
//    if (_imgArr.firstObject) {
//        //  添加标示
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//        label.backgroundColor = [UIColor cyanColor];
//        [_photosView addSubview:label];
//    }
    
    [_photosBaseView addSubview:_photosView];
    
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photosBaseView.mas_top).offset(50);
        make.bottom.equalTo(_photosBaseView.mas_bottom).offset(-10);
        make.left.equalTo(_photosBaseView.mas_left).offset(0);
        make.right.equalTo(_photosBaseView.mas_right).offset(0);
    }];
}


- (NSMutableArray *)imgArr
{
    if (_imgArr == nil) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

-(void)uplodeMyH:(CGFloat)myH{
    
    if (iPhone5) {
        _photosBaseViewHeight.constant = 100 + myH;
        _photosView.frame = CGRectMake(0, 30, _photosBaseView.frame.size.width, myH);
        
        if (_photosView.photoArray.count <= 3) {
            _baseViewToTop.constant = 168;
        } else {
            _baseViewToTop.constant = 168 + 120;
        }
    } else if (iPhone6) {
        _photosBaseViewHeight.constant = 100 + myH;
        _photosView.frame = CGRectMake(0, 30, _photosBaseView.frame.size.width, myH);
        
        if (_photosView.photoArray.count <= 3) {
            _baseViewToTop.constant = 168;
        } else {
            _baseViewToTop.constant = 168 + 120;
        }
    } else if (iPhone6plus) {
        
        _photosBaseViewHeight.constant = 100 + myH;
        _photosView.frame = CGRectMake(0, 30, _photosBaseView.frame.size.width, myH + 60);
        
        if (_photosView.photoArray.count <= 3) {
            _baseViewToTop.constant = 230;
        } else {
            _baseViewToTop.constant = 230 + 140;
        }
    }
   
    [_photosView layoutSubviews];
    
}

#pragma mark - Button Event

- (IBAction)buttonEvent:(UIButton *)sender {
    currentEditInfo = sender.tag - 1000;
    switch (currentEditInfo) {
        case EditName: {
            MKEditNameViewController *vc = [[MKEditNameViewController alloc] init];
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case EditSignature: {
            MKEditSignatureViewController *vc = [[MKEditSignatureViewController alloc] init];
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case EditBirthday: {
            MKEditBirthdayViewController *vc = [[MKEditBirthdayViewController alloc] init];
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case EditLocation: {
            MKEditLocationViewController *vc = [[MKEditLocationViewController alloc] init];
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case EditIndustry: {
            MKEditIndustryViewController *vc = [[MKEditIndustryViewController alloc] init];
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case EditRelationship: {
            MKRelationshipViewController *vc = [[MKRelationshipViewController alloc] init];
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case EditMyTags: {
            MKEditHobbyTagsViewController *vc = [[MKEditHobbyTagsViewController alloc] init];
            vc.myHobby = HobbyTypeNone;
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case EditMovies: {
            MKEditHobbyTagsViewController *vc = [[MKEditHobbyTagsViewController alloc] init];
            vc.myHobby = HobbyTypeMovies;
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }  break;
        case EditFoods:{
            MKEditHobbyTagsViewController *vc = [[MKEditHobbyTagsViewController alloc] init];
            vc.myHobby = HobbyTypeFoods;
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }  break;
        case EditSports:{
            MKEditHobbyTagsViewController *vc = [[MKEditHobbyTagsViewController alloc] init];
            vc.myHobby = HobbyTypeSports;
            vc.infoModel = self.infoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }  break;
            
    }
    
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
    }
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    CGFloat offsetX = 15;
    CGFloat offsetY = 0;
    
    
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
    label.py_width += 20;
    label.py_height += 12;
    return label;
}



@end
