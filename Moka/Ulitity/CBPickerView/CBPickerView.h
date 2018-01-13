//
//  CBPickerView.h
//  CrunClub
//
//  Created by Knight on 7/19/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBPickerViewDelegate <NSObject>

@optional
- (void)pickerViewDidSelectTitle:(NSString *)title;
- (void)pickerViewDidSelectDate:(NSString *)date;


@end

@interface CBPickerView : UIView

@property (nonatomic, strong) UIWindow      *pickerWindow;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic  ) id<CBPickerViewDelegate> pickerDelegate;
- (instancetype)initPickerViewWithArray:(NSArray *)array pickerDelegate:(id<CBPickerViewDelegate>)pickerDelegate rootViewController:(UIViewController *)viewcontroller;
- (instancetype)initPickerViewFromPlist:(NSString *)plistFileName pickerDelegate:(id<CBPickerViewDelegate>)pickerDelegate rootViewController:(UIViewController *)viewcontroller;
- (instancetype)initDatePickerViewWithPickerDelegate:(id<CBPickerViewDelegate>)pickerDelegate rootViewController:(UIViewController *)viewcontroller;
- (void)setDatePickerViewMode:(UIDatePickerMode)mode;
- (void)setPickerViewWithDate:(NSString *)date;
- (void)setPickerViewWithTitle:(NSString *)originalTitle;
- (void)show;
- (void)remove;

@end
