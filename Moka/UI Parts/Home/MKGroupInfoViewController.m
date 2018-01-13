//
//  MKGroupInfoViewController.m
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGroupInfoViewController.h"
#import "PYSearchConst.h"
#import "MKJoinGroupPopView.h"
#import "MKNearbyPeopleCell.h"
#import "MKGroupMemberViewController.h"
#import "MKMyFriendsViewController.h"
#import "MKEditGroupNameViewController.h"
#import "MKEditGroupDescriptionViewController.h"
#import "MKInviteFriendsViewController.h"
#import "MKCircleInfoModel.h"
#import "MKInterestTagModel.h"
#import "MKCircleMemberModel.h"
#import "MKCircleMemberViewController.h"
#import "MKEditCircleTagsViewController.h"
#import "MKConversationViewController.h"
#import "BubbleTransition.h"
#import "MKChangeCircleNoteNameViewController.h"
#import "MKAllMemberListController.h"

@interface MKGroupInfoViewController ()<UIViewControllerTransitioningDelegate, IBShareViewDelegate>

{
    NSMutableArray *myTagsArray;    //标签
    NSArray        *tagsArr;        ///<Label*>数组
    CGFloat        cellHeight;
    MKCircleInfoModel *circleInfoModel;
    NSString       *payPassword;
    NSString       *payMoney;
    BubbleTransition *transition;
    BOOL isSetNoDisturb;
    MKCircleMemberModel *adminModel;
    UIActivityIndicatorView *activityIndicator;
}


@property (nonatomic, copy)   NSString *circleId;  //圈子id
//scroll View
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (nonatomic, strong) IBShareView *shareView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseScrollViewBottomConstraint;

@property (strong, nonatomic) UIView *coverView;

//top view
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImgView;
@property (weak, nonatomic) IBOutlet UILabel *groupIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *editIcon;
@property (weak, nonatomic) IBOutlet UIButton *editNameButton;
@property (weak, nonatomic) IBOutlet UIButton *editHeadImgButton;

//圈子通知
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupNotificationViewHeight;
@property (weak, nonatomic) IBOutlet UIView *groupNotificationView;

//圈子ICO
@property (weak, nonatomic) IBOutlet UIView *launchICOView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *launchICOViewHeight;


//圈子介绍
@property (weak, nonatomic) IBOutlet UILabel *groupDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *editGroupDescriptionButton;
@property (weak, nonatomic) IBOutlet UIImageView *groupDescriptionArrowImg;

//圈子标签
@property (weak, nonatomic) IBOutlet UIView *groupTagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupTagsViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *editGroupTagsButton;
@property (weak, nonatomic) IBOutlet UIImageView *groupTagsArrowImg;
//我在本圈的昵称
@property (weak, nonatomic) IBOutlet UIView *myNickNameInCircleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myNickNameInCircleViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myNickNameInCircleViewTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *myNickNameInCircleLabel;

//圈主
@property (weak, nonatomic) IBOutlet UIImageView *adminHeadImage;
@property (weak, nonatomic) IBOutlet UIImageView *adminExpertImageView;
@property (weak, nonatomic) IBOutlet UILabel *adminNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adminHeadImageWidth;


//圈子成员

@property (weak, nonatomic) IBOutlet UIView *groupMembersView;
@property (strong, nonatomic) IBOutlet UIButton *groupAllMembersBtn;
- (IBAction)checkAllMemberClicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *AllMembersCountLabel;

//入圈
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (strong, nonatomic) MKJoinGroupPopView *paymentView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UIView *circleIcoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleIcoViewHeight;



@end

@implementation MKGroupInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestCircleInfos];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"圈子信息"];
    self.title = @"圈子信息";
    
    //隐藏圈子通知
    _groupNotificationViewHeight.constant = 0;
    _groupNotificationView.hidden = YES;
    //
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(0, 0, 30, 30);
    [setButton setImage:IMAGE(@"near_more") forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    
//    [self setRightButtonWithTitle:nil titleColor:nil imageName:@"near_more" addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;//只能设置中心，不能设置大小
    [self.view addSubview:activityIndicator];
    
    if (_circleListModel) {
        _circleId = [NSString stringWithFormat:@"%ld", (long)_circleListModel.id];
    } else {
        _circleId = self.cicleId;
    }
    
    transition = [[BubbleTransition alloc] init];
    
    self.notificationSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    UIColor *offColor = RGB_COLOR_HEX(0xE5E5E5);
    self.notificationSwitch.tintColor = offColor;
    self.notificationSwitch.layer.cornerRadius = 15.5;
    self.notificationSwitch.backgroundColor = offColor;
    
    [MKTool addShadowOnView:self.joinButton];
    WEAK_SELF;
    self.paymentView = [MKJoinGroupPopView newPopViewWithInputBlock:^(NSString *text) {
        STRONG_SELF;
        payPassword = text;
        //请求支付加入付费圈子
        [strongSelf requestJoinPayedCircle];
        [_paymentView hide];
        [strongSelf.view endEditing:YES];
    }];
    
    [self checkNetWork];
    
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.circleId success:^(RCConversationNotificationStatus nStatus) {
        if (nStatus == 0) {
            isSetNoDisturb = YES;
            [_notificationSwitch setOn:NO];
        } else {
            isSetNoDisturb = NO;
            [_notificationSwitch setOn:YES];
        }
        
    } error:^(RCErrorCode status) {
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCircleInfo) name:@"OutCircle" object:nil];
    
    
    [self.view addSubview:self.coverView];
    [self.view bringSubviewToFront:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
}

-(void)checkNetWork {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] checkNetWorkStatusSuccess:^(id str) {
        STRONG_SELF;
        if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
            //有网络
            [strongSelf hiddenNonetWork];
            [strongSelf requestCircleInfos];
        }else{
            //无网络
            [strongSelf showNonetWork];
            
        }
        
    }];
    
}





- (void)refreshCircleInfo {
    [self requestCircleInfos];
}

//成员UI
- (void)setupGroupMemberUserInterface {
    _baseScrollViewBottomConstraint.constant = 0;
    [self hideObjects:@[_cameraImgView, _editIcon, _editNameButton, _editHeadImgButton, _joinButton, _groupDescriptionArrowImg, _editGroupDescriptionButton, _groupTagsArrowImg, _editGroupTagsButton]];
    _sendMessageButton.hidden = NO;
    _launchICOView.hidden = YES;
    _launchICOViewHeight.constant = 0;
    
    _myNickNameInCircleView.hidden = NO;
    _myNickNameInCircleViewHeightConstraint.constant = 44;
    _myNickNameInCircleViewTopConstraint.constant = 15;
}

//没有入圈UI
- (void)setupNotJoinUserInterface {
    _groupNotificationViewHeight.constant = 0;
    _baseScrollViewBottomConstraint.constant = 70;
    
    [self hideObjects:@[_groupNotificationView, _groupDescriptionArrowImg, _editGroupDescriptionButton, _groupTagsArrowImg, _editGroupTagsButton, _cameraImgView, _editIcon, _editNameButton, _editHeadImgButton]];
    
    [self showObjects:@[_joinButton]];
    
    _sendMessageButton.hidden = YES;
    _launchICOView.hidden = YES;
    _launchICOViewHeight.constant = 0;
    
    _myNickNameInCircleView.hidden = YES;
    _myNickNameInCircleViewHeightConstraint.constant = 0;
    _myNickNameInCircleViewTopConstraint.constant = 0;
    
}

- (void)hideICOfunction {
    _launchICOView.hidden = YES;
    _launchICOViewHeight.constant = 0;
    _circleIcoView.hidden = YES;
    _circleIcoViewHeight.constant = 0;
}

//管理员UI
- (void)setupGroupAdminUserInterface {
    _baseScrollViewBottomConstraint.constant = 0;
    [self hideObjects:@[_joinButton]];
    _sendMessageButton.hidden = NO;
    _launchICOView.hidden = NO;
    _launchICOViewHeight.constant = 44;
    _myNickNameInCircleView.hidden = NO;
    _myNickNameInCircleViewHeightConstraint.constant = 44;
    _myNickNameInCircleViewTopConstraint.constant = 15;
}

- (void)hideObjects:(NSArray *)array {
    for (id obj in array) {
        if ([obj respondsToSelector:@selector(setHidden:)]) {
            [obj setHidden:YES];
        }
    }
}

- (void)showObjects:(NSArray *)array {
    for (id obj in array) {
        if ([obj respondsToSelector:@selector(setHidden:)]) {
            [obj setHidden:NO];
        }
    }
}


- (void)updateUserInterface {
    
    if (circleInfoModel.ifico == 0) {
        _circleIcoView.hidden = YES;
        _circleIcoViewHeight.constant = 0;
    } else {
        _circleIcoView.hidden = NO;
        _circleIcoViewHeight.constant = 44;
    }
    
    //1.根据是否是成员/管理员设置UI  1.成员 2.非成员 3.管理员
    if (circleInfoModel.ifmember == 1) {
        [self setupGroupMemberUserInterface];
    } else if (circleInfoModel.ifmember == 2) {
        [self setupNotJoinUserInterface];
    } else if (circleInfoModel.ifmember == 3) {
        [self setupGroupAdminUserInterface];
    }
    
    
    //hide ICO
    [self hideICOfunction];
    
    //2.设置圈子基本信息
    [_groupImageView setImageUPSUrl:circleInfoModel.imgs];
    _groupIDLabel.text = [NSString stringWithFormat:@"ID %ld", (long)circleInfoModel.code];
    _groupNameLabel.text = circleInfoModel.name;
    _groupDescriptionLabel.text = circleInfoModel.introduce;
    
//    if (circleInfoModel.notice == 1) {
//        _notificationSwitch.on = YES;
//    } else {
//        _notificationSwitch.on = NO;
//    }
    
    //我在圈子中的昵称
    if (circleInfoModel.nickNameInCircle.length > 0) {
        _myNickNameInCircleLabel.text = circleInfoModel.nickNameInCircle;
    }
    
    NSMutableArray *tempArray = @[].mutableCopy;
    for (MKInterestTagModel *tagModel in circleInfoModel.lableList) {
        [tempArray addObject:tagModel.name];
    }
    
    myTagsArray = tempArray;
    [self removeTagsWith:tagsArr];
    tagsArr = [self createMovieLabelsWithContentView:_groupTagsView
                                    layoutConstraint:_groupTagsViewHeight
                                           tagsArray:myTagsArray];
    
    if (circleInfoModel.ifpay == 0) {
        [_joinButton setTitle:@"入圈" forState:UIControlStateNormal];
    } else if (circleInfoModel.ifpay == 1) {
        [_joinButton setTitle:[NSString stringWithFormat:@"支付%@TV入圈",[NSString removeFloatAllZero: circleInfoModel.pay / 1000.0] ] forState:UIControlStateNormal];
        payMoney = [NSString stringWithFormat:@"%g", circleInfoModel.pay / 1000.0];
        
    }
    //圈子的总人数
    self.AllMembersCountLabel.text = [NSString stringWithFormat:@"%ld人", (long)circleInfoModel.count];
    
    
    //群组的消息
    adminModel = circleInfoModel.adminInfo;

    [_adminHeadImage openImage:adminModel.img];
    _adminHeadImageWidth.constant = SCREEN_WIDTH / 6.0;
    _adminHeadImage.layer.cornerRadius = _adminHeadImage.size.width / 2.0;
    _adminHeadImage.layer.masksToBounds = YES;
    _adminNameLabel.text = adminModel.name;
    if (adminModel.ifhave == 0) {
        _adminExpertImageView.hidden = YES;
    } else {
        _adminExpertImageView.hidden = NO;
    }
}

#pragma mark - IBShareViewDelegate

- (void)shareToWeichatMoments {
    NSLog(@"分享朋友圈");
    [_shareView hide];
    
    NSString * contentStr = [NSString stringWithFormat:@"在“钛值”发现一个好圈子'%@'，快来加入吧！",_groupNameLabel.text];
    [IBCommShare shareToWeichatMoments:@"钛值" shareDescription:contentStr shareThumbImg:nil shareUrl:@"www.t.top"];
}

- (void)shareToWeichatFriends {
    NSLog(@"分享微信好友");
    [_shareView hide];

    NSString * contentStr = [NSString stringWithFormat:@"在“钛值”发现一个好圈子'%@'，快来加入吧！",_groupNameLabel.text];
    [IBCommShare shareToWeichatFriends:@"钛值" shareDescription:contentStr shareThumbImg:nil shareUrl:@"www.t.top"];
}

- (void)inform {
   [_shareView hide];
    [self showInformAlertSheet];
}

- (void)outCircle {
    [_shareView hide];
    [self requestOutCircle];
}

- (void)deCircle {
    [_shareView hide];
    [self requestDisslutCircle];
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


//加入圈子
- (IBAction)joinGroupButtonClicked:(UIButton *)sender {
    if (circleInfoModel.ifpay == 1) {
        [self.paymentView showInViewController:self];
        [self.paymentView configWithCoins:[NSString stringWithFormat:@"%@ TV",payMoney]];
    } else {
        [self requestJoinFreeCircle];
    }
    
}

- (IBAction)adminButtonClicked:(UIButton *)sender {
    MKCircleMemberViewController *vc = [[MKCircleMemberViewController alloc] init];
    vc.userId = [NSString stringWithFormat:@"%ld", (long)adminModel.userid];
    [self.navigationController pushViewController:vc animated:YES];
}


//圈ICO点击

- (IBAction)circleICOButtonClicked:(UIButton *)sender {

    
}



- (IBAction)myNickNameInCircleButtonClicked:(UIButton *)sender {
    MKChangeCircleNoteNameViewController *vc = [[MKChangeCircleNoteNameViewController alloc] init];
    vc.targetCircleId =  self.circleId;
    vc.userType = circleInfoModel.ifmember;//1.成员 2.非成员 3.管理员
    vc.myRemarkName = circleInfoModel.nickNameInCircle;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -  HTTP 获取圈子信息

- (void)requestCircleInfos {
    NSDictionary *param = @{@"id":self.circleId};
//    [MKUtilHUD showHUD:self.view];
    [activityIndicator startAnimating];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_circle_info2] params:param success:^(id json) {
        STRONG_SELF;
//        [MKUtilHUD hiddenHUD:strongSelf.view];
        [activityIndicator stopAnimating];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        DLog(@"获取圈子信息 %@",json);
        if (status == 200) {
            [strongSelf.coverView removeFromSuperview];
            //
            circleInfoModel = [MKCircleInfoModel mj_objectWithKeyValues:json[@"dataObj"]];

            [strongSelf updateUserInterface];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            if ([message isEqualToString:@"该圈子已解散"]) {
                [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:2];
            }
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
//        [MKUtilHUD hiddenHUD:strongSelf.view];
        [activityIndicator stopAnimating];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}




#pragma mark - HTTP 修改圈子通知【开启时传1  关闭时传0】

- (IBAction)noticeSwitchEvent:(UISwitch *)sender {
    
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP
     targetId:self.circleId
     isBlocked:!sender.on
     success:^(RCConversationNotificationStatus nStatus) {
         NSLog(@"修改圈子通知成功 %lu", (unsigned long)nStatus);
         
     }
     error:^(RCErrorCode status) {
         NSLog(@"修改圈子通知失败");
     }];


   /*
    
    NSDictionary *param = @{@"circleid":@(circleInfoModel.id), @"state":@(sender.isOn)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_circle_notice] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改圈子通知 %@",json);
        if (status == 200) {
            
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
    */
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
            
            UIImage *originalImage = _groupImageView.image;
            _groupImageView.image = editedImage;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定更换圈子头像?" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf imageUpload];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                _groupImageView.image = originalImage;
            }]];
            
            [strongSelf presentViewController:alertController animated:YES completion:nil];
            
            
            
        }
        // 保存原图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
        }
    }];
}


#pragma mark -http 上传头像

- (void)imageUpload {
    
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    UIImage *lastImage = [_groupImageView.image scaleToWidth:2 * SCREEN_WIDTH];
    NSDictionary *prams = @{@"id" : @(circleInfoModel.id)};
    
    [[MKNetworkManager sharedManager]  post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_update_circleImg] params:prams image:lastImage success:^(id responseObject) {
        NSLog(@"上传图片: %@",responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        if (status == 200) {
            //上传图片成功
            _circleListModel.imgs = [responseObject objectForKey:@"dataObj"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircle" object:nil];
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:responseObject[@"message"] withSecond:2 inView:strongSelf.view];
        }
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
    }];
    
}



#pragma mark - HTTP 加入免费圈子

- (void)requestJoinFreeCircle {
    NSDictionary *param = @{@"circleid":@(circleInfoModel.id)};
    [MKUtilHUD showHUD:self.view];
    _joinButton.enabled = NO;
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_join_circle] params:param success:^(id json) {
        STRONG_SELF;
        _joinButton.enabled = YES;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"加入免费圈子 %@",json);
        if (status == 200) {
            _circleListModel.count += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircle" object:nil];
            [strongSelf requestCircleInfos];
            
            //跳转圈子聊天
            MKConversationViewController *conversationVC = [[MKConversationViewController alloc]init];
            
            conversationVC.conversationType = ConversationType_GROUP;
            conversationVC.targetId = [NSString stringWithFormat:@"%ld", (long)circleInfoModel.id];
            conversationVC.title = circleInfoModel.name;
            
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        _joinButton.enabled = YES;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}


#pragma mark - HTTP 加入付费圈子

- (void)requestJoinPayedCircle {
    NSString *encriptPassword = [MKTool md5_passwordEncryption:payPassword];
    
    NSDictionary *param = @{@"circleid":@(circleInfoModel.id), @"trpassword":encriptPassword, @"ifpay":@(1)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_join_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"加入付费圈子 %@",json);
        if (status == 200) {
            _circleListModel.count += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircle" object:nil];
            [strongSelf requestCircleInfos];
            
            //跳转圈子聊天
            MKConversationViewController *conversationVC = [[MKConversationViewController alloc]init];
            
            conversationVC.conversationType = ConversationType_GROUP;
            conversationVC.targetId = [NSString stringWithFormat:@"%ld", (long)circleInfoModel.id];
            conversationVC.title = circleInfoModel.name;
            
            [self.navigationController pushViewController:conversationVC animated:YES];
            
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




#pragma mark - HTTP 退出圈子

- (void)requestOutCircle {
    
    NSDictionary *param = @{@"circleid":@(circleInfoModel.id)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_out_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"退出圈子 %@",json);
        if (status == 200) {
            _circleListModel.count -= 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircle" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OutCircle" object:nil];
            
            [strongSelf requestCircleInfos];
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

#pragma mark - HTTP 解散圈子
- (void)requestDisslutCircle {
    NSDictionary *param = @{@"circleid":@(circleInfoModel.id)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_dissolut_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"解散圈子 %@",json);
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteCircle" object:nil];
           
            [strongSelf.navigationController popViewControllerAnimated:YES];
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


#pragma mark - HTTP 举报圈子

- (void)requestInformCircleWithRemark:(NSString *)remark {
    
    NSDictionary *param = @{@"otherid":@(circleInfoModel.id), @"remark":remark};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_inform_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"举报圈子 %@",json);
        if (status == 200) {
            [MKUtilHUD showHUD:@"举报成功" inView:strongSelf.view];
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

- (IBAction)shareToFriendsEvent:(UIButton *)sender {
    MKMyFriendsViewController *vc = [[MKMyFriendsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)editGroupNameButtonClicked:(UIButton *)sender {
    MKEditGroupNameViewController *vc = [[MKEditGroupNameViewController alloc] init];
    vc.circleModel = circleInfoModel;
    vc.circleListModel = self.circleListModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)editGroupDescriptionButtonClicked:(UIButton *)sender {
    MKEditGroupDescriptionViewController *vc = [[MKEditGroupDescriptionViewController alloc] init];
    vc.circleModel = circleInfoModel;
    vc.circleListModel = self.circleListModel;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)editGroupTagsButtonClicked:(UIButton *)sender {
    MKEditCircleTagsViewController *vc = [[MKEditCircleTagsViewController alloc] init];
    vc.circleModel = circleInfoModel;
    vc.circleListModel = self.circleListModel;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)editGroupHeadImageButtonClicked:(UIButton *)sender {
    [self showActionSheet];
}

#pragma mark - 发起ICO

- (IBAction)launchICOButtonClicked:(UIButton *)sender {

    
}


//打开更多菜单
- (void)openMenu {
    
    //弹出分享 View
    _shareView = [IBShareView newShareView];
    
    //1.成员 2.非成员 3.管理员
    if (circleInfoModel.ifmember == 1) {
        [_shareView setShareStyle:ShareViewStyleMember];
    } else if (circleInfoModel.ifmember == 2) {
        [_shareView setShareStyle:ShareViewStyleNotMember];
    } else if (circleInfoModel.ifmember == 3) {
        [_shareView setShareStyle:ShareViewStyleAdmin];
    }

    _shareView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView show];
    
    return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"查看圈子成员" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        MKGroupMemberViewController *vc = [[MKGroupMemberViewController alloc] init];
        vc.circleModel = circleInfoModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self showInformAlertSheet];
    }]];
    
    
    if (circleInfoModel.ifmember == 1) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"离开圈子" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [self showConfirmOutDissolutionCircle];
            
        }]];
    } else if (circleInfoModel.ifmember == 3) {
        [alertController addAction: [UIAlertAction actionWithTitle:@"解散圈子" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [self showConfirmOutDissolutionCircle];
            
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
  
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showConfirmOutDissolutionCircle {
    NSString *title;
    if (circleInfoModel.ifmember == 1) {
        title = @"确定离开圈子吗？";
    } else if (circleInfoModel.ifmember == 3) {
        title = @"确定解散圈子吗？";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        if (circleInfoModel.ifmember == 1) {
            //请求离开圈子
            [self requestOutCircle];
        } else if (circleInfoModel.ifmember == 3) {
            //请求解散圈子
            [self requestDisslutCircle];
        }
        
    }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)showInformAlertSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alertController addAction:[UIAlertAction actionWithTitle:@"广告或垃圾信息" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self requestInformCircleWithRemark:action.title];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"色情或低俗内容" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self requestInformCircleWithRemark:action.title];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"谩骂" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self requestInformCircleWithRemark:action.title];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"金钱欺诈" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self requestInformCircleWithRemark:action.title];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"激进时政或意识形态话题" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self requestInformCircleWithRemark:action.title];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"其他理由" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self requestInformCircleWithRemark:action.title];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)sendMessageButtonClicked:(UIButton *)sender {
    //跳转圈子聊天
    MKConversationViewController *conversationVC = [[MKConversationViewController alloc]init];
    
    conversationVC.conversationType = ConversationType_GROUP;
    conversationVC.targetId = [NSString stringWithFormat:@"%ld", circleInfoModel.id];
    conversationVC.title = circleInfoModel.name;

    [self.navigationController pushViewController:conversationVC animated:YES];
}



- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    transition.transitionMode = BubbleTransitionModePresent;
    transition.startingPoint = CGPointMake(SCREEN_WIDTH  / 2, SCREEN_HEIGHT - 25);
    transition.bubbleColor = [UIColor clearColor];
    return transition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    transition.transitionMode = BubbleTransitionModeDismiss;
    transition.startingPoint = CGPointMake(SCREEN_WIDTH  / 2, SCREEN_HEIGHT - 25);
    transition.bubbleColor = commonBlueColor;
    return transition;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView =  [[UIView alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor whiteColor];
        
    }
    return _coverView;
}


- (IBAction)checkAllMemberClicked:(UIButton *)sender {
    MKAllMemberListController * vc = [[MKAllMemberListController alloc]init];
    vc.circleID = [NSString stringWithFormat:@"%ld",(long)circleInfoModel.id];
    vc.circleImage = circleInfoModel.imgs;
    vc.circleName = circleInfoModel.name;
    vc.isMaster = [NSString stringWithFormat:@"%ld",(long)circleInfoModel.ifmember];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
