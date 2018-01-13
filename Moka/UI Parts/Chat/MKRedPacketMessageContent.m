//
//  MKRedPacketMessageContent.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRedPacketMessageContent.h"

@interface MKRedPacketMessageContent ()

@end

@implementation MKRedPacketMessageContent

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif


#pragma mark - NSCoding协议

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.messageId = [aDecoder decodeObjectForKey:@"messageId"];
        self.redPacketTitle = [aDecoder decodeObjectForKey:@"redPacketTitle"];
        self.redPacketType = [aDecoder decodeObjectForKey:@"redPacketType"];
        self.totalCoins = [aDecoder decodeObjectForKey:@"totalCoins"];
        self.numbersOfRedPacket = [aDecoder decodeObjectForKey:@"numbersOfRedPacket"];
        self.sendTime  = [aDecoder decodeObjectForKey:@"sendTime"];
        self.status  = [aDecoder decodeObjectForKey:@"status"];
        self.senderName  = [aDecoder decodeObjectForKey:@"senderName"];
        self.senderPortait  = [aDecoder decodeObjectForKey:@"senderPortait"];
        self.coinType  = [aDecoder decodeObjectForKey:@"coinType"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.messageId forKey:@"messageId"];
    [aCoder encodeObject:self.redPacketTitle forKey:@"redPacketTitle"];
    [aCoder encodeObject:self.redPacketType forKey:@"redPacketType"];
    [aCoder encodeObject:self.totalCoins forKey:@"totalCoins"];
    [aCoder encodeObject:self.numbersOfRedPacket forKey:@"numbersOfRedPacket"];
    [aCoder encodeObject:self.sendTime forKey:@"sendTime"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.senderName forKey:@"senderName"];
    [aCoder encodeObject:self.senderPortait forKey:@"senderPortait"];
    [aCoder encodeObject:self.coinType forKey:@"coinType"];
}



#pragma mark - RCMessageCoding协议

/*!
 将消息内容序列化，编码成为可传输的json数据
 
 @discussion
 消息内容通过此方法，将消息中的所有数据，编码成为json数据，返回的json数据将用于网络传输。
 */
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    self.messageId ? [dataDict setObject:self.messageId forKey:@"messageId"] : nil;
    self.redPacketTitle ? [dataDict setObject:self.redPacketTitle forKey:@"redPacketTitle"] : nil;
    self.redPacketType ? [dataDict setObject:self.redPacketType forKey:@"redPacketType"] : nil;
    self.totalCoins ? [dataDict setObject:self.totalCoins forKey:@"totalCoins"] : nil;
    self.numbersOfRedPacket ? [dataDict setObject:self.numbersOfRedPacket forKey:@"numbersOfRedPacket"] : nil;
    self.sendTime   ? [dataDict setObject:self.sendTime forKey:@"sendTime"] : nil;
    self.status   ? [dataDict setObject:self.status forKey:@"status"] : nil;
    self.senderName   ? [dataDict setObject:self.senderName forKey:@"senderName"] : nil;
    self.senderPortait   ? [dataDict setObject:self.senderPortait forKey:@"senderPortait"] : nil;
    self.coinType   ? [dataDict setObject:self.coinType forKey:@"coinType"] : nil;
    
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [userDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portraitUri"];
        }
        if (self.senderUserInfo.userId) {
            [userDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"userId"];
        }
        [dataDict setObject:userDic forKey:@"sender"];
        
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

/*!
 将json数据的内容反序列化，解码生成可用的消息内容
 
 @param data    消息中的原始json数据
 
 @discussion
 网络传输的json数据，会通过此方法解码，获取消息内容中的所有数据，生成有效的消息内容。
 */
- (void)decodeWithData:(NSData *)data {
#if 1
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
#else
    NSString *jsonStream = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *json = [RCJSONConverter dictionaryWithJSONString:jsonStream];
#endif
    if (json) {
        self.messageId              = json[@"messageId"];
        self.redPacketTitle         = json[@"redPacketTitle"];
        self.redPacketType          = json[@"redPacketType"];
        self.totalCoins             = json[@"totalCoins"];
        self.numbersOfRedPacket     = json[@"numbersOfRedPacket"];
        self.sendTime               = json[@"sendTime"];
        self.status                 = json[@"status"];
        self.senderName             = json[@"senderName"];
        self.senderPortait          = json[@"senderPortait"];
        self.coinType               = json[@"coinType"];
        
        NSObject *object = [json objectForKey:@"sender"];
        NSDictionary *userinfoDic = nil;
        if (object &&[object isMemberOfClass:[NSDictionary class]]) {
            userinfoDic = (NSDictionary *)object;
        }
        if (userinfoDic) {
            RCUserInfo *userinfo =[RCUserInfo new];
            userinfo.userId = [userinfoDic objectForKey:@"userId"];
            userinfo.name =[userinfoDic objectForKey:@"name"];
            userinfo.portraitUri =[userinfoDic objectForKey:@"portraitUri"];
            self.senderUserInfo = userinfo;
        }
    }
}

/*!
 返回消息的类型名
 
 @return 消息的类型名
 
 @discussion 您定义的消息类型名，需要在各个平台上保持一致，以保证消息互通。
 
 @warning 请勿使用@"RC:"开头的类型名，以免和SDK默认的消息名称冲突
 */
+ (NSString *)getObjectName {
    return RCLocalMessageTypeIdentifier;
}


#pragma mark - RCMessagePersistentCompatible协议
/*!
 返回消息的存储策略
 
 @return 消息的存储策略
 
 @discussion 指明此消息类型在本地是否存储、是否计入未读消息数。
 */
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}


#pragma mark - RCMessageContentView协议
/*!
 返回在会话列表和本地通知中显示的消息内容摘要
 
 @return 会话列表和本地通知中显示的消息内容摘要
 
 @discussion
 如果您使用IMKit，当会话的最后一条消息为自定义消息时，需要通过此方法获取在会话列表展现的内容摘要；
 当App在后台收到消息时，需要通过此方法获取在本地通知中展现的内容摘要。
 */
- (NSString *)conversationDigest {
    
    return @"[红包]";
}

@end
