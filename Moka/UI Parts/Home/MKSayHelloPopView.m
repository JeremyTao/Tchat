//
//  MKSayHelloPopView.m
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSayHelloPopView.h"

@interface MKSayHelloPopView ()

@property (weak, nonatomic) IBOutlet UIButton *darkBackgoundButton;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic, strong) UIWindow      *popWindow;

@end

@implementation MKSayHelloPopView

+ (instancetype)newPopView {
    MKSayHelloPopView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKSayHelloPopView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKSayHelloPopView class]]) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
        return customView;
    }
    else
        return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [MKTool addGrayShadowOnView:_popUpView];
}

- (void)showInViewController:(UIViewController *)vc {
    [self.inputView becomeFirstResponder];
    self.popWindow.rootViewController = vc;
    self.popWindow.windowLevel = UIWindowLevelStatusBar + 10;
    [self.popWindow addSubview:self];
    [self.popWindow makeKeyAndVisible];
    [self layoutIfNeeded];
    self.darkBackgoundButton.alpha = 0;
    self.popUpView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.darkBackgoundButton.alpha = 0.5;
        self.popUpView.alpha = 1.0;
        self.popUpView.transform =  CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.darkBackgoundButton.enabled = YES;
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.darkBackgoundButton.alpha = 0;
        self.popUpView.alpha = 0;
        self.popUpView.transform =  CGAffineTransformMakeScale(0.6, 0.6);;
    } completion:^(BOOL finished) {
        self.popWindow.hidden = YES;
        self.popWindow = nil;
    }];
    
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


- (IBAction)giveButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGiveButton)]) {
        [self.delegate  didClickedGiveButton];
    }
}



@end
