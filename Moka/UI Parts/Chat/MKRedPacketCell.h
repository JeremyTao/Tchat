//
//  MKRedPacketCell.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "MKRedPacketMessageContent.h"

@interface MKRedPacketCell : RCMessageCell



@property(nonatomic, strong) UIImageView *bubbleBackgroundView; //气泡背景

@property(nonatomic, strong) UIView *whiteView;

@property(nonatomic, strong) UIImageView *redPacketImageView;   //左侧红包图片

@property(nonatomic, strong) UILabel *redPacketNameLabel;//红包标题

@property(nonatomic, strong) UILabel *getLabel;//"领取红包"

@property(nonatomic, strong) UILabel *mokaLabel;//"摩咖红包"

/*!
 根据消息内容获取显示的尺寸
 
 @param message 消息内容
 
 @return 显示的View尺寸
 */
+ (CGSize)getBubbleBackgroundViewSize:(MKRedPacketMessageContent *)message;

@end
