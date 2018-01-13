//
//  MKFilterPeopleViewController.m
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.


#import "MKFilterPeopleViewController.h"
#import "NMRangeSlider.h"
#import "UIImage+UISegmentIconAndText.h"

@interface MKFilterPeopleViewController ()

{
    NSString  *gender;
}

//筛选
@property (weak, nonatomic) IBOutlet UIView *filterView;

@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentControl;



@end

@implementation MKFilterPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"过滤"];
    self.title = @"过滤";
    self.fd_interactivePopDisabled = YES;
    [self hideBackButton];
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"确定" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    //[self setRightButtonWithTitle:@"确定" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self configureLabelSlider];
    [self setupSegmentControl];
    [self.view bringSubviewToFront:_filterView];
    gender = @"";  //默认全部
    _mySegmentControl.selectedSegmentIndex = 2;
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x + 3);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    
    
    CGPoint upperCenter;
    upperCenter.x = (SCREEN_WIDTH - lowerCenter.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
}

- (void)setupSegmentControl {
    UIImage *seg1 = [UIImage imageFromImage:[UIImage imageNamed:@"male"] string:@"男生" color:[UIColor whiteColor]];
    [_mySegmentControl setImage:seg1 forSegmentAtIndex:0];
    
    UIImage *seg2 = [UIImage imageFromImage:[UIImage imageNamed:@"female"] string:@"女生" color:[UIColor whiteColor]];
    [_mySegmentControl setImage:seg2 forSegmentAtIndex:1];
    
    UIImage *seg3 = [UIImage imageFromImage:[UIImage imageNamed:@"near_male_female"] string:@"全部" color:[UIColor whiteColor]];
    [_mySegmentControl setImage:seg3 forSegmentAtIndex:2];
}

- (void)configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 60;
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 60;
    
    self.labelSlider.minimumRange = 4;
    
    self.labelSlider.lowerHandleImageNormal      = IMAGE(@"old_circle");
    self.labelSlider.lowerHandleImageHighlighted = IMAGE(@"old_circle");
    self.labelSlider.upperHandleImageNormal      = IMAGE(@"old_circle");
    self.labelSlider.upperHandleImageHighlighted = IMAGE(@"old_circle");
    
    self.labelSlider.trackBackgroundImage  = IMAGE(@"old_grey");
    self.labelSlider.trackImage            = IMAGE(@"ole_blue");
    
}

- (void)updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x + 3);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
   
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x + 5);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}



- (void)confirmButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFilterWithGender:smallAge:largeAge:)]) {
        [self.delegate didSelectFilterWithGender:gender smallAge:self.labelSlider.lowerValue largeAge:self.labelSlider.upperValue];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:  gender = @"2";  break;
        case 1:  gender = @"1";  break;
        case 2:  gender = @"";  break;
        default: break;
    }
}

@end
