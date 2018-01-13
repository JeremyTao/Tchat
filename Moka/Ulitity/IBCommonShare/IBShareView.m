//
//  IBShareView.m
//  InnerBuy
//
//  Created by Knight on 25/11/2016.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "IBShareView.h"

#define OneRowHeight 170
#define TwoRowHeight 280


@interface IBShareView ()

{
    BOOL isInBlack;
}

@property (weak, nonatomic) IBOutlet UIButton *darkBackgoundButton;
@property (weak, nonatomic) IBOutlet UIView *shareContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareContentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewHeight;
//扩展
@property (weak, nonatomic) IBOutlet UIButton *extentionButton;
@property (weak, nonatomic) IBOutlet UILabel *extentionTitleLabel;
//其他
@property (weak, nonatomic) IBOutlet UIButton *otherButton;
@property (weak, nonatomic) IBOutlet UILabel *otherTitleLabel;
//修改备注
@property (strong, nonatomic) IBOutlet UIButton *changeNameBtn;

//加入黑名单
@property (weak, nonatomic) IBOutlet UILabel *blackListLabel;



@end

@implementation IBShareView

+ (instancetype)newShareView {
    IBShareView *customView = [[[NSBundle mainBundle] loadNibNamed:@"IBShareView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[IBShareView class]]) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        return customView;
    }
    else
        return nil;
}


- (void)setShareStyle:(ShareViewStyle)style {
    switch (style) {
        case ShareViewStyleNotMember: {
            _shareViewHeight.constant = OneRowHeight;
            _otherButton.hidden = YES;
            _otherTitleLabel.hidden = YES;
            [_extentionButton setImage:IMAGE(@"more_complaint") forState:UIControlStateNormal];
            _extentionButton.tag = 1000;
            _extentionTitleLabel.text  = @"投诉";
        } break;
        case ShareViewStyleMember: {
            _shareViewHeight.constant = OneRowHeight;
            [_extentionButton setImage:IMAGE(@"more_leave") forState:UIControlStateNormal];
            _extentionButton.tag = 2000;
            _extentionTitleLabel.text  = @"离开圈子";
            [_otherButton setImage:IMAGE(@"more_complaint") forState:UIControlStateNormal];
            _otherButton.tag = 1000;
            _otherTitleLabel.text  = @"投诉";
        } break;
        case ShareViewStyleAdmin: {
            _shareViewHeight.constant = OneRowHeight;
            [_extentionButton setImage:IMAGE(@"more_disCircle") forState:UIControlStateNormal];
            _extentionButton.tag = 3000;
            _extentionTitleLabel.text  = @"解散圈子";
            _otherButton.hidden = YES;
            _otherTitleLabel.hidden = YES;
        } break;
        case ShareViewStyleOther: {
//            _shareViewHeight.constant = TwoRowHeight;
//            _otherButton.hidden = YES;
//            _otherTitleLabel.hidden = YES;
//            [_extentionButton setImage:IMAGE(@"more_user") forState:UIControlStateNormal];
//            _extentionTitleLabel.text  = @"钛值好友";
//            _extentionButton.tag = 4000;
            _shareViewHeight.constant = OneRowHeight;
            [_otherButton setImage:IMAGE(@"more_remark") forState:UIControlStateNormal];
            _otherButton.tag = 6000;
            _otherTitleLabel.text  = @"修改备注";
            [_extentionButton setImage:IMAGE(@"more_user") forState:UIControlStateNormal];
            _extentionTitleLabel.text  = @"钛值好友";
            _extentionButton.tag = 4000;
        } break;
        case ShareViewStyleSelf: {
            _shareViewHeight.constant = OneRowHeight;
            _otherButton.hidden = YES;
            _otherTitleLabel.hidden = YES;
            [_extentionButton setImage:IMAGE(@"more_user") forState:UIControlStateNormal];
            _extentionTitleLabel.text  = @"钛值好友";
            _extentionButton.tag = 4000;
        } break;
        case ShareViewStyleDynamicSelf: {
            _shareViewHeight.constant = OneRowHeight;
            _otherButton.hidden = YES;
            _otherTitleLabel.hidden = YES;
            [_extentionButton setImage:IMAGE(@"more_delete") forState:UIControlStateNormal];
            _extentionButton.tag = 5000;
            _extentionTitleLabel.text  = @"删除";
            
        } break;
        case ShareViewStyleDynamicOther: {
            _shareViewHeight.constant = OneRowHeight;
            _otherButton.hidden = YES;
            _otherTitleLabel.hidden = YES;
            [_extentionButton setImage:IMAGE(@"more_complaint") forState:UIControlStateNormal];
            _extentionButton.tag = 1000;
            _extentionTitleLabel.text  = @"投诉";
            
        } break;
        case ShareViewStyleNews:{
            
            _shareViewHeight.constant = OneRowHeight;
            _otherButton.hidden = YES;
            _otherTitleLabel.hidden = YES;
            _extentionButton.hidden = YES;
            _extentionTitleLabel.hidden = YES;
            
        }break;
            
        default:
            break;
    }
}


- (void)show {
    [self layoutIfNeeded];
    self.darkBackgoundButton.alpha = 0;
    self.shareContentViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.darkBackgoundButton.alpha = 0.5;
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                        
                     }];
    
    
}

- (void)hide {
    self.shareContentViewBottomConstraint.constant = -300;
    [UIView animateWithDuration:0.2 animations:^{
        self.darkBackgoundButton.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self hide];
}

- (IBAction)darkBackgroundButtonClicked:(UIButton *)sender {
    [self hide];
}

- (IBAction)shareMomentButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareToWeichatMoments)]) {
        [self.delegate shareToWeichatMoments];
    }
    
}
- (IBAction)shareWeichatFriendsClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareToWeichatFriends)]) {
        [self.delegate shareToWeichatFriends];
    }
}

- (IBAction)shareQQZoneButtonClicked:(UIButton *)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(shareToQQZone)]) {
//        [self.delegate shareToQQZone];
//    }
}

- (IBAction)shareQQFriendsButtonClicked:(UIButton *)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(shareToQQFriends)]) {
//        [self.delegate shareToQQFriends];
//    }
}


- (IBAction)buttonEvent:(UIButton *)sender {
    if (sender.tag == 1000) {
        //投诉
        if (self.delegate && [self.delegate respondsToSelector:@selector(inform)]) {
            [self.delegate inform];
        }
    } else if (sender.tag  == 2000) {
        //离开圈子
        if (self.delegate && [self.delegate respondsToSelector:@selector(outCircle)]) {
            [self.delegate outCircle];
        }
    } else if (sender.tag  == 3000) {
        //解散圈子
        if (self.delegate && [self.delegate respondsToSelector:@selector(deCircle)]) {
            [self.delegate deCircle];
        }
    } else if (sender.tag  == 4000) {
        //钛值好友
        if (self.delegate && [self.delegate respondsToSelector:@selector(taiValueFriends)]) {
            [self.delegate taiValueFriends];
        }
    } else if (sender.tag  == 5000) {
        //删除动态
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteDynamic)]) {
            [self.delegate deleteDynamic];
        }
    }else if (sender.tag == 6000){
        if (self.delegate && [self.delegate respondsToSelector:@selector(editRemark)]) {
            [self.delegate editRemark];
        }
    }
    
    
}

//修改备注
- (IBAction)editRemarkButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editRemark)]) {
        [self.delegate editRemark];
    }
}

//清空聊天记录
- (IBAction)clearChatRecoredClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clearChat)]) {
        [self.delegate clearChat];
    }
}

//加入黑名单
- (IBAction)addToBlackListClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addBlackList:)]) {
        [self.delegate addBlackList:!isInBlack];
    }
}

//投诉
- (IBAction)informButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inform)]) {
        [self.delegate inform];
    }
}

- (void)setInBlackList:(BOOL)inBlack {
    isInBlack = inBlack;
    if (inBlack) {
        _blackListLabel.text = @"移出黑名单";
    } else {
        _blackListLabel.text = @"加入黑名单";
    }
}




@end
