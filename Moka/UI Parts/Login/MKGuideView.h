//
//  MKGuideView.h
//  Moka
//
//  Created by  moka on 2017/8/24.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKGuideView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;

+ (instancetype)newGuideView;
- (void)showInViewController:(UIViewController *)vc;
- (void)hide;


@end
