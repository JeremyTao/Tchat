//
//  CBNavigationView.h
//  CrunClub
//
//  Created by Knight on 7/15/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NavigationBarStyleBlue,
    NavigationBarStyleWhite,
    NavigationBarStyleBlack,
    NavigationBarStyleRed
} NavigationBarStyle;


@protocol CBNavigationViewDelegate <NSObject>

- (void)backButtonClicked;

@end

@interface CBNavigationView : UIView
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<CBNavigationViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title delegate:(id)delegate;

- (void)setNavigationViewStyle:(NavigationBarStyle)style;

- (void)setCenterImageViewWithName:(NSString *)imageName;

- (void)setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)color imageName:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)color  imageName:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setTitleViewWithUrl:(NSString *)imgUrl;

- (void)hideRightButton;
- (void)showRightButton;
- (void)showSearchBarWithDelegate:(id<UITextFieldDelegate>)delegate;
- (void)setSreachBarPlaceholder:(NSString *)placeholder;
- (void)showNavigationBarShadow;
- (void)removeNavigationBarShadow;

@end
