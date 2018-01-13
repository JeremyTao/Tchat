//
//  MKFindViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKFriendsViewController.h"
#import "MKDynamicViewController.h"
#import "MKHotViewController.h"
#import "MKDynamicDetailViewController.h"
#import "MKCircleMemberViewController.h"
#import "MKSubmitDynamicViewController.h"
#import "MKUnreadMessageViewController.h"
#import "MKSetPaymentPasswordViewController.h"
#import "MKGuideView.h"
#import "LastesNewsViewController.h"
#import "NewsDetaelViewController.h"

@interface MKFriendsViewController ()<UIScrollViewDelegate, MKDynamicViewControllerDelegate, LastesNewsDelegate>

{
    CGRect leftChildViewControllerFrame;
    CGRect rightChildViewControllerFrame;
}

@property (nonatomic,strong)  MKGuideView *guideView;
@property (nonatomic, strong) MKDynamicViewController   *dynamicVC;
@property (nonatomic, strong) MKHotViewController       *hotVC;
@property (nonatomic, strong) LastesNewsViewController  *newsVc;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UIButton *dynamicButton;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (strong, nonatomic) IBOutlet UIButton *pushBtn;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *publishDynamicView;
@property (weak, nonatomic) IBOutlet UIImageView *addImgView;
@property (weak, nonatomic) IBOutlet UIImageView *lowerAddImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postPictureButtonTopConstraint;//80

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postTextButtonTopConstriant; //145

@property (weak, nonatomic) IBOutlet UIButton *postTextButton;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postTextImageView;

@property (weak, nonatomic) IBOutlet UIButton *postPictureButton;
@property (weak, nonatomic) IBOutlet UILabel *postPictureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postPictureImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicButtonLeftConstraint;


@end

@implementation MKFriendsViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger animate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AnimateNavifationBar"] integerValue];
    
    if (animate) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"AnimateNavifationBar"];
    
    [self requestUnreadDynamicMessage];
    [self checkNetWork];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismmis];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationView];
    //[self checkIfShowGuideFeed];
    [MKTool addGrayShadowOnView:self.topView];
    
    if (iPhone5) {
        _dynamicButtonLeftConstraint.constant = 50;
        leftChildViewControllerFrame  = CGRectMake(0, 0, SCREEN_WIDTH + 55, SCREEN_HEIGHT);
        rightChildViewControllerFrame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH + 55, SCREEN_HEIGHT);
        
    } else if (iPhone6) {
        
        leftChildViewControllerFrame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-110);
        rightChildViewControllerFrame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-110);
        
    } else if (iPhone6plus) {
        _dynamicButtonLeftConstraint.constant = 100;
        leftChildViewControllerFrame = CGRectMake(0, 0, SCREEN_WIDTH - 40, SCREEN_HEIGHT-110);
        rightChildViewControllerFrame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - 40, SCREEN_HEIGHT-110);
        
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_interactivePopDisabled = YES;
    
   
    //动态
    _dynamicVC = [[MKDynamicViewController alloc] init];
    _dynamicVC.view.frame = leftChildViewControllerFrame;
    _dynamicVC.delegate = self;
    //资讯
    _newsVc = [[LastesNewsViewController alloc] init];
    _newsVc.view.frame = rightChildViewControllerFrame;
    _newsVc.delegate = self;
    //基视图
    self.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    [self.baseScrollView addSubview:_dynamicVC.view];
    [self.baseScrollView addSubview:_newsVc.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needSetPassword) name:@"NeedSetPassword" object:nil];
    
    [self checkNetWork];
}

- (void)needSetPassword {
    MKSetPaymentPasswordViewController *payPasswordVC = [[MKSetPaymentPasswordViewController alloc] init];
    payPasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:payPasswordVC animated:YES];
    
}

-(void)checkNetWork {
//    WEAK_SELF;
    [[MKNetworkManager sharedManager] checkNetWorkStatusSuccess:^(id str) {
//        STRONG_SELF;
        if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
            //有网络
            //[strongSelf hiddenNonetWork];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicData" object:nil];
        }else{
            //无网络
            //[strongSelf showNonetWork];
            //无网络
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadDynamicCacheData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsDatas" object:nil];
        }
        
    }];
    
}

- (void)checkIfShowGuideFeed {
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:showGuideFeed];
    if (show) {
        _guideView = [MKGuideView newGuideView];
        _guideView.guideImageView.image = IMAGE(@"guide_feed");
        if (iPhone5) {
            _guideView.guideImageView.image = IMAGE(@"guide1_feed for 5");
        }
        [_guideView showInViewController:self];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:showGuideFeed];
    }
}

- (IBAction)dynamicButtonClicked:(UIButton *)sender {
    
    self.addImageView.hidden = NO;
    self.addImgView.hidden = NO;
    self.lowerAddImgView.hidden = NO;
    self.publishDynamicView.hidden = NO;
    self.pushBtn.enabled = YES;
    //
    if (self.baseScrollView.contentOffset.x == 0) {
        [self.dynamicVC scrollToTop];
    }
    [self.baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (IBAction)hotButtonClicked:(UIButton *)sender {
    
    self.addImageView.hidden = YES;
    self.addImgView.hidden = YES;
    self.lowerAddImgView.hidden = YES;
    self.publishDynamicView.hidden = YES;
    self.pushBtn.enabled = NO;
    //
    if (self.baseScrollView.contentOffset.x == SCREEN_WIDTH) {
        //[self.hotVC scrollToTop];
        [self.newsVc scrollToTop];
    }
    [self.baseScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

- (IBAction)postDynamicButtonEvent:(UIButton *)sender {
    [self dismmis];
    MKSubmitDynamicViewController *vc = [[MKSubmitDynamicViewController alloc] init];
    if (sender.tag == 100) {
        //发布 图文
        vc.onlyText = NO;
    } else {
        vc.onlyText = YES;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)selectDynamicButton {
    
    self.addImageView.hidden = NO;
    self.addImgView.hidden = NO;
    self.lowerAddImgView.hidden = NO;
    self.publishDynamicView.hidden = NO;
    self.pushBtn.enabled = YES;
    [self.dynamicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.hotButton setTitleColor:RGB_COLOR_HEX(0xCCCCCC) forState:UIControlStateNormal];
   
}

- (void)selectHotButton {
    
    self.addImageView.hidden = YES;
    self.addImgView.hidden = YES;
    self.lowerAddImgView.hidden = YES;
    self.publishDynamicView.hidden = YES;
    self.pushBtn.enabled = NO;
    [self.hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dynamicButton setTitleColor:RGB_COLOR_HEX(0xCCCCCC) forState:UIControlStateNormal];
   
}

#pragma mark - MKDynamicViewControllerDelegate

- (void)didSelectDynamicAtIndex:(NSInteger)index withDynamicID:(NSInteger)dynamicID isShowKeyboard:(BOOL)show{
    MKDynamicDetailViewController *vc = [[MKDynamicDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.dynamicId = [NSString stringWithFormat:@"%ld", (long)dynamicID];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tapedUserHeadImageAtIndex:(NSInteger)index withUserID:(NSInteger)userID {
    MKCircleMemberViewController *vc = [[MKCircleMemberViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userId = [NSString stringWithFormat:@"%ld", (long)userID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openUnreadMessageController {
    MKUnreadMessageViewController *vc = [[MKUnreadMessageViewController alloc]  init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - LastesNewsDelegate

-(void)didSelectNewsDatas:(News *)dics{
    
    NewsDetaelViewController * vc = [[NewsDetaelViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.news = dics;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)publishNewDynamicButtonClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _publishDynamicView.alpha   = 1;
        _postTextButton.alpha       = 1;
        _postPictureButton.alpha    = 1;
        _postTextLabel.alpha        = 1;
        _postPictureLabel.alpha     = 1;
        _postTextImageView.alpha    = 1;
        _postPictureImageView.alpha = 1;
        _addImgView.transform = CGAffineTransformMakeRotation(M_PI_2 / 2 + M_PI_2);
        _lowerAddImgView.transform = CGAffineTransformMakeRotation(M_PI_2 / 2 + M_PI_2);
        
    }];
    _postPictureButtonTopConstraint.constant = 80;
    _postTextButtonTopConstriant.constant    = 145;
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
}
- (IBAction)dismissPublishDynamicView:(UITapGestureRecognizer *)sender {
    [self dismmis];
}

- (void)dismmis {
    _postPictureButtonTopConstraint.constant = 60;
    _postTextButtonTopConstriant.constant    = 60;
    [UIView animateWithDuration:0.3 animations:^{
        _publishDynamicView.alpha   = 0;
        _postTextButton.alpha       = 0;
        _postPictureButton.alpha    = 0;
        _postTextLabel.alpha        = 0;
        _postPictureLabel.alpha     = 0;
        _postTextImageView.alpha    = 0;
        _postPictureImageView.alpha = 0;
        _addImgView.transform = CGAffineTransformIdentity;
        _lowerAddImgView.transform = CGAffineTransformIdentity;
        [self.view layoutIfNeeded];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    if (scrollView.contentOffset.x >= SCREEN_WIDTH / 2) {
        [self selectHotButton];
    } else {
        [self selectDynamicButton];
    }
}

#pragma mark - HTTP 未读消息

- (void)requestUnreadDynamicMessage {
    
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_unreadMessage] params:nil success:^(id json) {
        STRONG_SELF;
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        DLog(@"未读消息 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        NSMutableArray *imgArray = @[].mutableCopy;
        NSInteger      unreadCount;
        if (status == 200) {
            for (NSDictionary *ditc in json[@"dataObj"][@"por"]) {
                NSString *imgPath = ditc[@"img"];
                [imgArray addObject:imgPath];
            }
            unreadCount = [json[@"dataObj"][@"length"] integerValue];
            
            NSDictionary *infoDic = @{@"count":@(unreadCount),
                                      @"imgs":imgArray};
            [_dynamicVC configUnreadMessageWith:infoDic];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        DLog(@"%@",error);
    }];
}


@end
