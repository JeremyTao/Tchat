//
//  UIViewController+KSNoNetController.h
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSNoNetView.h"
#import "CBNOData.h"

@interface UIViewController (KSNoNetController)<KSNoNetViewDelegate,KSNoDataViewDelegate>


-(void)showNoDataView;

-(void)hidNoDataView;
/**
 *  为控制器扩展方法，刷新网络时候执行，建议必须实现
 */
- (void)reloadRequest;

/**
 *  显示没有网络
 */
- (void)showNonetWork;

/**
 *  隐藏没有网络
 */
- (void)hiddenNonetWork;



-(void)infoHaveFourAndThree;
-(void)activityPublishRefsh;


@end
