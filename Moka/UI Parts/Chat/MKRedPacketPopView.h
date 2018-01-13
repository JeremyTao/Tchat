//
//  MKRedPacketPopView.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKRedPacketMessageContent.h"

@protocol MKRedPacketPopViewDelegate <NSObject>

- (void)didClickedOpenButtonWith:(MKRedPacketMessageContent *)redPacketMessage;
- (void)didClickedSeeDetailButtonWith:(MKRedPacketMessageContent *)redPacketMessage;

@end

@interface MKRedPacketPopView : UIView

@property (nonatomic, weak) id<MKRedPacketPopViewDelegate> delegate;

+ (instancetype)newPopView;
- (void)showInViewController:(UIViewController *)vc;
- (void)hide;

- (void)configRedPacketWith:(MKRedPacketMessageContent *)redPacketMessage pastDue:(BOOL)pastdue robOut:(BOOL)robOut;
//已过期
- (void)setRedPacketPastDue;
//已抢完
- (void)setRedPacketRobOut;
@end
