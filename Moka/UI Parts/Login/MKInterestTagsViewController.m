//
//  MKInterestTagsViewController.m
//  Moka
//
//  Created by Knight on 2017/7/24.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKInterestTagsViewController.h"
#import "PYSearch.h"
#import "MKTabBarViewController.h"

@interface MKInterestTagsViewController ()

{
    NSMutableArray *tagModelsArray;
    NSMutableArray *tagsArray;
}

@property (nonatomic, strong) UIButton *startUseButton;

@end

@implementation MKInterestTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"标签"];
    self.title = @"标签";
    [self hideBackButton];
    self.fd_interactivePopDisabled = YES;
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"跳过" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(skipButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.navigationItem.rightBarButtonItem = menuItem;
    
    
    //[self setRightButtonWithTitle:@"跳过" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(skipButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = commeBackgroudColor;
    
    [self.view addSubview:self.startUseButton];
    [self.startUseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.left.equalTo(self.view.mas_left).offset(37.5);
        make.right.equalTo(self.view.mas_right).offset(-37.5);
    }];
    [_startUseButton addTarget:self action:@selector(startUseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [MKTool addShadowOnView:_startUseButton];
    
    tagModelsArray = @[].mutableCopy;
    tagsArray = @[].mutableCopy;
    
    //请求
    [self requestGetTags];
}

- (void)skipButtonEvent {
    MKTabBarViewController *tabBarVC = [[MKTabBarViewController alloc] init];
    tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:tabBarVC animated:YES completion:nil];
}

- (void)startUseButtonClicked {
    [self requestPostSelectedTag];
    
}


- (void)setupPYSearchWithArray:(NSArray *)hotSeaches {
   
    // 2. Create a search view controller
    PYSearchViewController *pySearchVC = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        //        [searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
    }];
    // 3. Set style for popular search and search history
    pySearchVC.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    pySearchVC.searchHistoryStyle = PYHotSearchStyleDefault;
    pySearchVC.showSearchHistory = NO;
    pySearchVC.tagModelsArray = tagModelsArray;  //传入模型数组
    // 4. Set delegate
    //searchViewController.delegate = self;
    pySearchVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64);
    [self.view addSubview:pySearchVC.view];
    [self.view insertSubview:pySearchVC.view belowSubview:_startUseButton];
    [self addChildViewController:pySearchVC];
    
}

- (UIButton *)startUseButton {
    if (!_startUseButton) {
        _startUseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startUseButton.backgroundColor = commonBlueColor;
        [_startUseButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [_startUseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startUseButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _startUseButton.frame = CGRectMake(0, 0, SCREEN_WIDTH - 75, 50);
        _startUseButton.layer.cornerRadius = 25;
        _startUseButton.layer.masksToBounds = YES;
        
    }
    return _startUseButton;
}

#pragma mark - http :获取标签

- (void)requestGetTags {
    NSDictionary *param = @{@"state":@(1)};
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
                [tagModelsArray addObject:model];
                [tagsArray addObject:model.name];
            }
            //创建标签视图
            [self setupPYSearchWithArray:tagsArray];
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

#pragma mark - 提交标签

- (void)requestPostSelectedTag {
    
    NSMutableArray *tempArray = @[].mutableCopy;
    for (MKInterestTagModel *model in tagModelsArray) {
        if (model.selected) {
            [tempArray addObject:[NSString stringWithFormat:@"%ld", (long)model.id]];
        }
    }
    
    NSString *labelsString = [tempArray componentsJoinedByString:@","];
    
    NSDictionary *param = @{@"lableids":labelsString};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_postTags] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"提交标签 %@",json);
        if (status == 200) {
            
            MKTabBarViewController *tabBarVC = [[MKTabBarViewController alloc] init];
            tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [strongSelf presentViewController:tabBarVC animated:YES completion:nil];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
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
