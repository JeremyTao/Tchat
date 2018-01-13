//
//  MKRedPacketPopView.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRedPacketPopView.h"
#import "IBAnimation.h"

@interface MKRedPacketPopView ()
{
    MKRedPacketMessageContent *myRedPackerMessage;
}

@property (weak, nonatomic) IBOutlet UIButton *darkBackgoundButton;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic, strong) UIWindow      *popWindow;
//用户相关
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UILabel *redPacketTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *openButton;

@property (weak, nonatomic) IBOutlet UIButton *seeDetailButton;


@property (weak, nonatomic) IBOutlet UIImageView *cloudImageView;


@end

@implementation MKRedPacketPopView

+ (instancetype)newPopView {
    MKRedPacketPopView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKRedPacketPopView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKRedPacketPopView class]]) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        
        return customView;
    }
    else
        return nil;
}


- (void)configRedPacketWith:(MKRedPacketMessageContent *)redPacketMessage pastDue:(BOOL)pastdue robOut:(BOOL)robOut {
    
    myRedPackerMessage = redPacketMessage;
    
    _userNameLabel.text = redPacketMessage.senderName;
    //头像
    if ([redPacketMessage.senderPortait containsString:WAP_URL] || [redPacketMessage.senderPortait containsString:WAP_IMAGE_URL]) {
        
        [_userImageView openFullPathImage:redPacketMessage.senderPortait];
    }else if ([redPacketMessage.senderPortait hasPrefix:@"alioss_"]){
        
        [_userImageView openFullPathImage:[NSString stringWithFormat:@"%@%@%@",WAP_IMAGE_URL,IMG_URL,redPacketMessage.senderPortait]];
    }else{
        
        [_userImageView openFullPathImage:[NSString stringWithFormat:@"%@%@%@",WAP_URL,IMG_URL,redPacketMessage.senderPortait]];
    }
    //
    _redPacketTitleLabel.text = redPacketMessage.redPacketTitle;
    //
    if ([redPacketMessage.redPacketType isEqualToString:@"0"]) {
        //个人红包
        _hintLabel.text = @"给你发了一个红包";
    } else {
        //群红包
        _hintLabel.text = @"发了一个圈子红包";
    }
    
    if (pastdue) {
        [self setRedPacketPastDue];
    } else {
        [self setRedPacketAvilable];
    }
}

- (void)setRedPacketAvilable {
    _hintLabel.hidden = NO;
    _cloudImageView.image = IMAGE(@"red_open_redspace");
    _openButton.hidden = NO;
    _seeDetailButton.hidden = YES;
}

//已过期界面
- (void)setRedPacketPastDue {
    _hintLabel.hidden = YES;
    _redPacketTitleLabel.text = @"该红包已过期";
    _cloudImageView.image = IMAGE(@"red_redspace_decortion");
    _openButton.hidden = YES;
    _seeDetailButton.hidden = NO;
}

//已抢完
- (void)setRedPacketRobOut {
    _hintLabel.hidden = YES;
    _redPacketTitleLabel.text = @"手慢了，红包已被抢光";
    _cloudImageView.image = IMAGE(@"red_redspace_decortion");
    _openButton.hidden = YES;
    _seeDetailButton.hidden = NO;
}


- (void)openAnimation {
    
    _openButton.enabled = NO;
    [UIView transitionWithView:_openButton duration:0.6 options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionRepeat animations:^{
        
        //[UIView setAnimationRepeatCount:20]; // **This should appear in the beginning of the block*
        
    } completion:nil];
}

- (void)showInViewController:(UIViewController *)vc {
    _openButton.enabled = YES;
    [self.inputView becomeFirstResponder];
    self.popWindow.rootViewController = vc;
    [self.popWindow addSubview:self];
    [self.popWindow makeKeyAndVisible];
    [self layoutIfNeeded];
    self.darkBackgoundButton.alpha = 0;
    self.popUpView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    //
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


- (IBAction)openButtonClicked:(UIButton *)sender {
    [self openAnimation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOpenButtonWith:)]) {
        [self.delegate  didClickedOpenButtonWith:myRedPackerMessage];
    }
}

- (IBAction)seeDetailButtonClicekd:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSeeDetailButtonWith:)]) {
        [self.delegate  didClickedSeeDetailButtonWith:myRedPackerMessage];
    }
    
}


@end
