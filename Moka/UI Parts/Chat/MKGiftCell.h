//
//  MKGiftCell.h
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "MKGiftMessage.h"

@protocol MKGiftCellDelegate <NSObject>

- (void)didClickedGetButtonWith:(MKGiftMessage *)message;

@end

@interface MKGiftCell : RCMessageCell

@property (nonatomic, weak) id<MKGiftCellDelegate>getDelegate;

@property(nonatomic, strong) UIImageView *bubbleBackgroundView; //气泡背景

@property(nonatomic, strong) UIView *purpleView; //紫色背景

@property(nonatomic, strong) UIImageView *giftImageView;   //礼物图片

@property(nonatomic, strong) UILabel *niceToMeetULabel;//"很高兴认识你"

@property(nonatomic, strong) UIButton *getButton;//"领取"按钮




+ (CGSize)getBubbleBackgroundViewSize:(MKGiftMessage *)message;


@end
