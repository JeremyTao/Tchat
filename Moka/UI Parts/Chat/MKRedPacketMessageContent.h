//
//  MKRedPacketMessageContent.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCLocalMessageTypeIdentifier @"MK:Red Packet"

@interface MKRedPacketMessageContent : RCMessageContent<NSCoding>

@property (nonatomic, strong) NSString  *messageId;      //消息Id
@property (nonatomic, strong) NSString  *redPacketTitle; //红包名称
@property (nonatomic, strong) NSString  *redPacketType;  //0：个人红包，3：圈子普通红包，2：圈子随机红包
@property (nonatomic, strong) NSString  *totalCoins;     //总金额
@property (nonatomic, strong) NSString  *numbersOfRedPacket; //红包个数(个人红包 = 1, 圈子红包时 >= 1)
@property (nonatomic, strong) NSString  *sendTime;       //发送时间(YYYY-MM-DD HH:mm:ss)
@property (nonatomic, strong) NSString  *status;         //状态 0:未领取, 1:已领取 2:已过期 3-已抢完
@property (nonatomic, strong) NSString  *senderName;         //发送人姓名
@property (nonatomic, strong) NSString  *senderPortait;      //发送人头像
@property (nonatomic, strong) NSString  *coinType;      //金额类型,1:RMB,2:TV

@end
