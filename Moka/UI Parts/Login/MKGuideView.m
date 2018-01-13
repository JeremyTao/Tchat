//
//  MKGuideView.m
//  Moka
//
//  Created by  moka on 2017/8/24.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGuideView.h"

@interface MKGuideView ()

@property (nonatomic, strong) UIWindow  *popWindow;


@end

@implementation MKGuideView

+ (instancetype)newGuideView {
    MKGuideView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKGuideView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKGuideView class]]) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        return customView;
    }
    else
        return nil;
}

- (void)showInViewController:(UIViewController *)vc {
    self.popWindow.rootViewController = vc;
    [self.popWindow addSubview:self];
    [self.popWindow makeKeyAndVisible];
}

- (void)hide {
    
    self.popWindow.hidden = YES;
    
}

- (IBAction)darkBackgroundButtonClicked:(UIButton *)sender {
    [self hide];
}

- (UIWindow *)popWindow {
    if (!_popWindow) {
        _popWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _popWindow.backgroundColor = [UIColor clearColor];
        _popWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return _popWindow;
}



@end
