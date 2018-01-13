//
//  MKUserInfoViewController.m
//  Moka
//
//  Created by Knight on 2017/8/6.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKUserInfoViewController.h"
#import "MKUserInfoDetailViewController.h"
#import "MKUserDynamicViewController.h"

@interface MKUserInfoViewController ()<UIScrollViewDelegate>
{
    int _lastPosition;     //A variable define in headfile
}

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollVIew;
@property (nonatomic, strong) MKUserInfoDetailViewController   *userDetailInfoVC;
@property (nonatomic, strong) MKUserDynamicViewController       *userDynamicVC;

@property (weak, nonatomic) IBOutlet UIButton *userDetailInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *userDynamicButton;


@end

@implementation MKUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUersInterface];
    
}

- (void)initUersInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_interactivePopDisabled = YES;
    
    _userDetailInfoVC = [[MKUserInfoDetailViewController alloc] init];
    _userDetailInfoVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    
    _userDynamicVC = [[MKUserDynamicViewController alloc] init];
    _userDynamicVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    
    self.baseScrollView.delegate = self;
    self.baseScrollView.bounces = NO;
    
    self.bottomScrollVIew.bounces = NO;
    self.bottomScrollVIew.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.bottomScrollVIew.pagingEnabled = YES;
    self.bottomScrollVIew.delegate = self;
    
    [self.bottomScrollVIew addSubview:_userDetailInfoVC.view];
    [self.bottomScrollVIew addSubview:_userDynamicVC.view];
    
    self.baseScrollView.tag   = 1000;
    self.bottomScrollVIew.tag = 2000;
 
    
    //NSLog(@"userDetailInfoButton.frame.y = %f", _userDetailInfoButton.frame.origin.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        NSLog(@"向上");
        
        if (scrollView.tag == 1000) {
            //NSLog(@"baseScrollView: %f", scrollView.contentOffset.y);
            
            if (scrollView.contentOffset.y < _userDetailInfoButton.frame.origin.y - 64) {
                
                _userDynamicVC.myTableView.userInteractionEnabled = NO;
                
            } else {
                
                _userDynamicVC.myTableView.userInteractionEnabled = YES;
            }
        }
        
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        NSLog(@"向下");
        if (scrollView.tag == 1000) {
            //NSLog(@"baseScrollView: %f", scrollView.contentOffset.y);
            
            if (scrollView.contentOffset.y <= _userDetailInfoButton.frame.origin.y - 64) {
                
                _userDynamicVC.myTableView.userInteractionEnabled = NO;
                
            } else {
                
                _userDynamicVC.myTableView.userInteractionEnabled = YES;
            }
        }
    }
    
    
    
    
    
}


@end
