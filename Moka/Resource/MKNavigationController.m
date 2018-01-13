//
//  MKNavigationController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKNavigationController.h"

@interface MKNavigationController ()

@end

@implementation MKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // 背景图片
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar"] forBarMetrics:UIBarMetricsDefault];
    
    // 字体标题设置（字体大小、字体颜色设置）
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Bold" size:18],  NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //自定义导航栏返回按钮
    [self.navigationBar setBackIndicatorImage:IMAGE(@"chat_back")];
    [self.navigationBar setBackIndicatorTransitionMaskImage:IMAGE(@"chat_back")];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //得到当前Navigation栈中第一个元素
    UIViewController *firstVC = self.viewControllers[0];
    //取消"back"文字
    firstVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
        
}


- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}




@end
