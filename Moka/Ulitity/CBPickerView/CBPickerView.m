//
//  CBPickerView.m
//  CrunClub
//
//  Created by Knight on 7/19/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "CBPickerView.h"


static CGFloat PickerHeight = 330;

@interface CBPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, strong) NSArray       *dataArray;
@property (weak, nonatomic  ) IBOutlet  UIPickerView *pickerView;
@property (weak, nonatomic  ) IBOutlet  UIDatePicker *datePickerView;
@property (nonatomic, copy) NSString      *plistFileName;
@property (nonatomic, copy) NSString     *pickedTitle;//选择的title
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) UIView *darkBackground;


@end

@implementation CBPickerView

- (instancetype)initPickerViewFromPlist:(NSString *)plistFileName pickerDelegate:(id<CBPickerViewDelegate>)pickerDelegate rootViewController:(UIViewController *)viewcontroller
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CBPickerView" owner:nil options:nil] firstObject];
        // make sure customView is not nil or the wrong class!
        if ([self isKindOfClass:[CBPickerView class]]) {
            NSString *path= [[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"];
            NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
            self.dataArray = array;
            self.plistFileName = plistFileName;
            self.pickerView.dataSource = self;
            self.pickerView.delegate = self;
            self.pickerDelegate = pickerDelegate;
            self.pickerWindow.rootViewController = viewcontroller;
            [self.pickerWindow addSubview:self];
            [self setViewTheme];
            
        }
    }
    return self;
    
}

- (instancetype)initPickerViewWithArray:(NSArray *)array pickerDelegate:(id<CBPickerViewDelegate>)pickerDelegate rootViewController:(UIViewController *)viewcontroller
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CBPickerView" owner:nil options:nil] firstObject];
        // make sure customView is not nil or the wrong class!
        if ([self isKindOfClass:[CBPickerView class]]) {
            
            self.dataArray = array;
            
            self.pickerView.dataSource = self;
            self.pickerView.delegate = self;
            self.pickerDelegate = pickerDelegate;
            [self.pickerWindow addSubview:self];
            self.pickerWindow.rootViewController = viewcontroller;
//            _pickedTitle = array.firstObject;
            [self setViewTheme];
       
        }
    }
    return self;
    
}

- (instancetype)initDatePickerViewWithPickerDelegate:(id<CBPickerViewDelegate>)pickerDelegate rootViewController:(UIViewController *)viewcontroller
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CBPickerView" owner:nil options:nil] lastObject];
        // make sure customView is not nil or the wrong class!
        if ([self isKindOfClass:[CBPickerView class]]) {
            
            //设置UIDatePicker控件
            //self.datePickerView.minimumDate = [NSDate date];
            //[self.datePickerView setValue:[UIColor blackColor] forKeyPath:@"textColor"];
            self.datePickerView.datePickerMode = UIDatePickerModeDate;
            self.pickerDelegate = pickerDelegate;
            [self.pickerWindow addSubview:self];
            self.pickerWindow.rootViewController = viewcontroller;
            [self setViewTheme];
            

        }
    }
    return self;
    
}

- (void)setViewTheme  {
    
//    self.topView.backgroundColor = [UIColor blueColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + PickerHeight);
}

- (void)setPickerViewWithDate:(NSString *)date {
    NSDate *setDate ;
    setDate = [NSDate dateWithString:date format:@"yyyy-MM-dd"];
    [self.datePickerView setDate:setDate animated:NO];
    
}

- (void)setDatePickerViewMode:(UIDatePickerMode)mode {
    self.datePickerView.datePickerMode = mode;
}

- (void)setPickerViewWithTitle:(NSString *)originalTitle {
    
    NSInteger row = 0;
    if (originalTitle) {
        _pickedTitle = originalTitle;
        for (int i = 0; i < _dataArray.count; i ++) {
            if ([originalTitle isEqualToString:_dataArray[i]]) {
                row = i;
                break;
            }
        }
    } else {
        _pickedTitle = self.dataArray.firstObject;
    }
    [self.pickerView selectRow:row inComponent:0 animated:NO];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return _dataArray.count;
}



//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    return _dataArray[row];
//
//}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = _dataArray[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _pickedTitle = _dataArray[row];
}

- (UIWindow *)pickerWindow {
    if (!_pickerWindow) {
        _pickerWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pickerWindow.backgroundColor = [UIColor clearColor];
        _pickerWindow.windowLevel = UIWindowLevelStatusBar;
        //暗色背景
        _darkBackground = [[UIButton alloc] initWithFrame:CGRectMake(0, -PickerHeight, SCREEN_WIDTH, SCREEN_HEIGHT + PickerHeight)];
        _darkBackground.backgroundColor = [UIColor blackColor];
        _darkBackground.alpha = 0.5;
        [_pickerWindow addSubview:_darkBackground];
        
    }
    return _pickerWindow;
}

- (void)show {
    [self.pickerWindow makeKeyAndVisible];
    self.darkBackground.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.darkBackground.alpha = 0.5;
        self.frame = CGRectMake(0, -PickerHeight, SCREEN_WIDTH, SCREEN_HEIGHT+PickerHeight);
    }];
    //传出当前title
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewDidSelectTitle:)] && _pickedTitle) {
        [self.pickerDelegate pickerViewDidSelectTitle:_pickedTitle];
    }
}

- (void)remove {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.darkBackground.alpha = 0;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + PickerHeight);
    } completion:^(BOOL finished) {
        self.pickerWindow.hidden = YES;
        self.pickerWindow = nil;
    }];
}

- (IBAction)confirmButtonClicked:(UIButton *)sender {

    [self remove];
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewDidSelectTitle:)] && _pickedTitle) {
        [self.pickerDelegate pickerViewDidSelectTitle:_pickedTitle];
    } else if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerViewDidSelectDate:)] && self.datePickerView.date) {
        //读取日期
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString * time = [formatter stringFromDate:self.datePickerView.date];
    
        [self.pickerDelegate pickerViewDidSelectDate:time];
    }
}

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self remove];
}





@end
