//
//  UIViewController+KSNoNetController.m
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import "UIViewController+KSNoNetController.h"
#import "KSNoNetView.h"

@implementation UIViewController (KSNoNetController)

-(void)infoHaveFourAndThree{
    
    
    
    
}
-(void)activityPublishRefsh{
    
    
}
- (void)reloadNetworkDataSource{
    
}
-(void)reloadDataworkDataSource{
    
    
    
}
-(void)showNoDataView{
    
   CBNOData * view = [CBNOData instanceNoDataView];
    view.delegate = self;
    [self.view addSubview:view];
    
}
-(void)hidNoDataView{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[CBNOData class]]) {
            [view removeFromSuperview];
        }
    }
    
}
- (void)showNonetWork
{

    KSNoNetView* view = [KSNoNetView instanceNoNetView];
    view.delegate = self;
    [self.view addSubview:view];
    
}
- (void)hiddenNonetWork
{
   
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[KSNoNetView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)reloadRequest
{
    NSLog(@"必须由网络控制器(%@)重写这个方法(%@)，才可以使用再次刷新网络",NSStringFromClass([self class]),NSStringFromSelector(@selector(reloadRequest)));
}
@end
