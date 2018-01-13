//
//  MKBaseViewController.h
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBNavigationView.h"
#import "CBStoreHouseRefreshControl.h"

@interface MKBaseViewController : UIViewController<CBNavigationViewDelegate>

@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

-(void)hideNavigationView;
- (void)showNavigationView;
-(void)hideBackButton;
-(void)showBackButton;
- (void)hideRightButton;
- (void)showRightButton;

- (void)setNavigationTitle:(NSString *)title;
- (void)setCenterImageViewWithName:(NSString *)imageName;
- (void)bringNavigationViewToFront;
- (void)setNavigationBarStyle:(NavigationBarStyle)style;
- (void)setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)color imageName:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)color  imageName:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)showSearchBarWithDelegate:(id<UITextFieldDelegate>)delegate;
- (void)setSreachBarPlaceholder:(NSString *)placeholder;

- (void)showActionSheet;
- (void)setTitleViewWithUrl:(NSString *)imgUrl;

- (void)showNavigationBarShadow;
- (void)removeNavigationBarShadow;
@end
