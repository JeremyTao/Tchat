//
//  MKShareAppViewController.m
//  Moka
//
//  Created by  moka on 2017/8/26.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKShareAppViewController.h"

@interface MKShareAppViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;


@end

@implementation MKShareAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"分享给好友"];
    self.title = @"分享给好友";
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"分享" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    
   // [self setRightButtonWithTitle:@"分享" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
}


- (void)shareEvent {
    UIImage *image = _codeImageView.image;
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    
    activityViewController.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

@end
