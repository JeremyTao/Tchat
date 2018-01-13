//
//  MKGiveMokaCoinView.h
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQVerCodeInputView.h"


@interface MKGiveMokaCoinView : UIView


@property (weak, nonatomic) IBOutlet UITextField *inputMoneyTextField;

@property (weak, nonatomic) IBOutlet MQVerCodeInputView *inputView;
@property (assign, nonatomic) NSInteger cellIndex;

+ (instancetype)newPopViewWithInputBlock:(MQTextViewBlock)inputBlock;
- (void)showInViewController:(UIViewController *)vc;
- (void)hide;

@end
