//
//  MKHomepageViewController.m
//  Moka
//
//  Created by jansonlei on 19/07/2017.
//  Copyright © 2017 moka. All rights reserved.
//

#import "MKHomepageViewController.h"
#import "MKNearbyPeopleViewController.h"
#import "MKRecomondGroupViewController.h"
#import "MKFilterPeopleViewController.h"
#import "MKGroupTypeViewController.h"
#import "MKSearchGroupViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "MKGroupInfoViewController.h"
#import "MKCircleMemberViewController.h"
#import "MKGuideView.h"
#import "MKMyCirclesViewController.h"

static NSString * const kStatusBarTappedNotification = @"statusBarTappedNotification";
@interface MKHomepageViewController ()<UIScrollViewDelegate,MKRecomondGroupViewControllerDelegate, MKFilterPeopleViewControllerDelegate, MKNearbyPeopleViewControllerDelegate, UITabBarControllerDelegate>

{
    CGRect leftChildViewControllerFrame;
    CGRect rightChildViewControllerFrame;
}

@property (nonatomic,strong)  MKGuideView *guideView;

@property (weak, nonatomic) IBOutlet UIView *topView;



@property (nonatomic, strong) MKNearbyPeopleViewController   *nearbyPeopleVC;
@property (nonatomic, strong) MKRecomondGroupViewController  *recomondGroupVC;

@property (weak, nonatomic) IBOutlet UIButton           *nearbyPeopleButton;
@property (weak, nonatomic) IBOutlet UIButton           *recomondGroupButton;

@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (weak, nonatomic) IBOutlet UIImageView *filterImageView;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nearByButtonLeftConstraint;

@property (nonatomic, strong) MKFilterPeopleViewController  *filterVC;

@end

@implementation MKHomepageViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSInteger animate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AnimateNavifationBar"] integerValue];
    
    if (animate) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"AnimateNavifationBar"];
    
    
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowNewCreatedCircle"];
    if (show) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShowNewCreatedCircle"];
        MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
        groupInfoVC.hidesBottomBarWhenPushed = YES;
        groupInfoVC.cicleId = [[NSUserDefaults standardUserDefaults] objectForKey:@"createdCircleId"];
        [self.navigationController pushViewController:groupInfoVC animated:YES];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationView];
    //[self checkIfShowGuideNearby];
    [MKTool addGrayShadowOnView:self.topView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_interactivePopDisabled = YES;
    self.tabBarController.delegate = self;
    
    if (iPhone5) {
        _nearByButtonLeftConstraint.constant = 50;
        leftChildViewControllerFrame  = CGRectMake(0, 0, SCREEN_WIDTH + 55, SCREEN_HEIGHT);
        rightChildViewControllerFrame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH + 55, SCREEN_HEIGHT);
        
    } else if (iPhone6) {
        
        leftChildViewControllerFrame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-110);
        rightChildViewControllerFrame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-110);
        
    } else if (iPhone6plus) {
        _nearByButtonLeftConstraint.constant = 100;
        leftChildViewControllerFrame = CGRectMake(0, 0, SCREEN_WIDTH - 40, SCREEN_HEIGHT-110);
        rightChildViewControllerFrame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - 40, SCREEN_HEIGHT-110);
        
    }
    
    
   
    _nearbyPeopleVC = [[MKNearbyPeopleViewController alloc] init];
    _nearbyPeopleVC.view.frame = leftChildViewControllerFrame;
    _recomondGroupVC = [[MKRecomondGroupViewController alloc] init];
    _recomondGroupVC.view.frame = rightChildViewControllerFrame;

    self.filterButton.hidden = NO;
    self.createButton.hidden = YES;
    self.filterImageView.hidden = NO;
    self.addImageView.hidden = YES;
    
    _nearbyPeopleVC.delegate  = self;
    _recomondGroupVC.delegate = self;
    
    self.pageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.delegate = self;
    [self.pageScrollView addSubview:_nearbyPeopleVC.view];
    [self.pageScrollView addSubview:_recomondGroupVC.view];
    [self.view bringSubviewToFront:self.topView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlayVideo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCircles) name:@"ShowCircles" object:nil];
    
    self.filterVC = [[MKFilterPeopleViewController alloc] init];
    self.filterVC.delegate = self;

    [self checkNetWork];
}

- (void)showCircles {
    [self.recomondGroupVC scrollToTop];
    [self.pageScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
}

-(void)checkNetWork {
    
    [[MKNetworkManager sharedManager] checkNetWorkStatusSuccess:^(id str) {
        
        if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
            //有网络
            
        }else{
            //无网络
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHomeCacheData" object:nil];
            
        }
        
    }];
    
}
 



- (void)checkIfShowGuideNearby {
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:showGuideNear];
    if (show) {
        _guideView = [MKGuideView newGuideView];
        _guideView.guideImageView.image = IMAGE(@"guide_nearby");
        if (iPhone5) {
            _guideView.guideImageView.image = IMAGE(@"guide1_nearby for 5");
        }
        [_guideView showInViewController:self];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:showGuideNear];
    }
}


- (void)checkIfShowGuideRecommend {
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:showGuideRecommend];
    if (show) {
        _guideView = [MKGuideView newGuideView];
        _guideView.guideImageView.image = IMAGE(@"guide_recommend");
        if (iPhone5) {
            _guideView.guideImageView.image = IMAGE(@"guide1_recommend for 5");
        }
        [_guideView showInViewController:self];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:showGuideRecommend];
    }
}

- (void)didClickedMyCircles {
    
    MKMyCirclesViewController *vc = [[MKMyCirclesViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)nearbyButtonClicked:(UIButton *)sender {
    if (self.pageScrollView.contentOffset.x == 0) {
        [self.nearbyPeopleVC scrollToTop];
    }
    [self.pageScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (IBAction)recomondGroupButtonClicked:(UIButton *)sender {
    if (self.pageScrollView.contentOffset.x == SCREEN_WIDTH) {
         [self.recomondGroupVC scrollToTop];
    }
    [self.pageScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
   
}

- (void)selectNearbyPeopleButton {
    [self.nearbyPeopleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.recomondGroupButton setTitleColor:RGB_COLOR_HEX(0xCCCCCC) forState:UIControlStateNormal];
    self.filterButton.hidden = NO;
    self.filterImageView.hidden = NO;
    self.createButton.hidden = YES;
    self.addImageView.hidden = YES;
}

- (void)selectRecomondGroupButton {
    [self.recomondGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nearbyPeopleButton setTitleColor:RGB_COLOR_HEX(0xCCCCCC) forState:UIControlStateNormal];
    self.filterButton.hidden = YES;
    self.filterImageView.hidden = YES;
    self.createButton.hidden = NO;
    self.addImageView.hidden = NO;
}


- (IBAction)filterButtonDidClicked:(UIButton *)sender {
    [self.navigationController pushViewController:self.filterVC animated:YES];
}

- (IBAction)createButtonDidClicked:(UIButton *)sender {
    MKGroupTypeViewController *creatVC = [[MKGroupTypeViewController alloc] init];
    creatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:creatVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    if (scrollView.contentOffset.x >= SCREEN_WIDTH / 2) {
        [self selectRecomondGroupButton];
        //[self checkIfShowGuideRecommend];
    } else {
        [self selectNearbyPeopleButton];
    }
}
#pragma mark - MKNearbyPeopleViewControllerDelegate

- (void)didSelectPeople:(MKNearbyPeopleModel *)model {
    MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
    memberInfoVC.hidesBottomBarWhenPushed = YES;
    memberInfoVC.userId = [NSString stringWithFormat:@"%ld", (long)model.id];
    [self.navigationController pushViewController:memberInfoVC animated:YES];
    
}

#pragma mark - MKFilterPeopleViewControllerDelegate

- (void)didSelectFilterWithGender:( NSString *)gender smallAge:(NSInteger)smallAge largeAge:(NSInteger)largeAge {
    [_nearbyPeopleVC filterWithGender:gender smallAge:smallAge largeAge:largeAge];
}

#pragma mark - MKRecomondGroupViewControllerDelegate

- (void)startSearchWithQuery:(NSString *)words {
    MKSearchGroupViewController *searchVC = [[MKSearchGroupViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (void)didSelectCircle:(MKCircleListModel *)circleModel {
    MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
    groupInfoVC.hidesBottomBarWhenPushed = YES;
    groupInfoVC.circleListModel = circleModel;
    [self.navigationController pushViewController:groupInfoVC animated:YES];
}



- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"AnimateNavifationBar"];
    return YES;
}


@end
