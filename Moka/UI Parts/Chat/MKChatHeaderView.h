//
//  MKChatHeaderView.h
//  Moka
//
//  Created by  moka on 2017/8/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKOnlineModel;
@class MKHelloFansCountModel;

@protocol MKChatHeaderViewDelegate <NSObject>

- (void)didClickedSayHelloButton;
- (void)didClickedNewFansButton;
- (void)didClickedToKeFuButton;
- (void)didClickedOnlinePeopleWith:(MKOnlineModel *)model;


@end

@interface MKChatHeaderView : UIView

@property (nonatomic, weak) id<MKChatHeaderViewDelegate> delegate;

+ (instancetype)newChatHeaderView;
- (void)configOnlinePeopleWith:(NSArray *)onlineArray;
- (void)configSayHelloAndFansWith:(MKHelloFansCountModel *)model;


@end
