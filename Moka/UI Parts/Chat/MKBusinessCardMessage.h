//
//  MKBusinessCardMessage.h
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCBusinessCardMessageTypeIdentifier @"MK:BusinessCard"


@interface MKBusinessCardMessage : RCMessageContent

@property (nonatomic, strong) NSString  *messageId;      //消息Id
@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *userPortrait;
@property (nonatomic, strong) NSString  *userAge;
@property (nonatomic, strong) NSString  *cardType;       //0 = 个人名片, 1 = 圈子名片

@end
