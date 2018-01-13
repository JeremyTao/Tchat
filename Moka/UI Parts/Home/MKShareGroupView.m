//
//  MKShareGroupView.m
//  Moka
//
//  Created by  moka on 2017/8/2.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKShareGroupView.h"

@interface MKShareGroupView ()

{
    MKPeopleModel *myModel;
    NSString      *myTargetId;
}


@property (weak, nonatomic) IBOutlet UIButton *darkBackgoundButton;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *usarNameLabel;

@end

@implementation MKShareGroupView


+ (instancetype)newShareGroupView {
    MKShareGroupView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKShareGroupView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKShareGroupView class]]) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        return customView;
    }
    else
        return nil;
}

- (void)configView:(MKPeopleModel *)model toTargetUser:(NSString *)targetID {
    myTargetId = targetID;
    myModel = model;
    
    NSLog(@"要分享 %ld 给 %@", model.coveruserid, targetID);
    [_userImageView setImageUPSUrl:model.img];
    _usarNameLabel.text = model.name;
}



- (void)show {
    [self layoutIfNeeded];
    self.darkBackgoundButton.alpha = 0;
    self.myView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.darkBackgoundButton.alpha = 0.5;
        self.myView.alpha = 1.0;
        self.myView.transform =  CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.darkBackgoundButton.alpha = 0;
        self.myView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (IBAction)darkBackgroundButtonClicked:(UIButton *)sender {
    //[self hide];
}


- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self hide];
}

- (IBAction)confirmShareButtonClicked:(UIButton *)sender {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmSharePeople:toUser:)]) {
        [self.delegate confirmSharePeople:myModel toUser:myTargetId];
    }
    
}

@end
