//
//  MKGroupReviewPopView.h
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MQVerCodeInputView.h"

@interface MKJoinGroupPopView : UIView

@property (nonatomic, copy) NSString *feeStr;
+ (instancetype)newPopViewWithInputBlock:(MQTextViewBlock)inputBlock;

- (void)showInViewController:(UIViewController *)vc;
- (void)hide;
//TV
- (void)configWithCoins:(NSString *)coins;
//RMB
- (void)showPayFeeNoticeLabel:(NSString *)crashes;

@end
