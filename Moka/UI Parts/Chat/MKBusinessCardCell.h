//
//  MKBusinessCardCell.h
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "MKBusinessCardMessage.h"

@interface MKBusinessCardCell : RCMessageCell

@property(nonatomic, strong) UIImageView *bubbleBackgroundView; //气泡背景


@property(nonatomic, strong) UIImageView *userImageView;   //用户头像图片

@property(nonatomic, strong) UILabel *userNameLabel;//用户名

@property(nonatomic, strong) UILabel *userAgeLabel;//用户名age




/*!
 根据消息内容获取显示的尺寸
 
 @param message 消息内容
 
 @return 显示的View尺寸
 */
+ (CGSize)getBubbleBackgroundViewSize:(MKBusinessCardMessage *)message;


@end
