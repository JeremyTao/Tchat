//
//  MKSendGiftMessage.h
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCGiftMessageTypeIdentifier @"MK:Gift"

@interface MKGiftMessage : RCMessageContent<NSCoding>

@property (nonatomic, strong) NSString  *messageId;      //消息Id
@property (nonatomic, strong) NSString  *sendTime;       //发送时间(YYYY-MM-DD HH:mm:ss)
@property (nonatomic, strong) NSString  *status;         //状态 0:未领取, 1:已领取 2:已过期

@end
