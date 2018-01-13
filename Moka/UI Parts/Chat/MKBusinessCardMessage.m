//
//  MKBusinessCardMessage.m
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBusinessCardMessage.h"

@implementation MKBusinessCardMessage


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
        self.userName  = [aDecoder decodeObjectForKey:@"userName"];
        self.userPortrait  = [aDecoder decodeObjectForKey:@"userPortrait"];
        self.userAge  = [aDecoder decodeObjectForKey:@"userAge"];
        self.cardType = [aDecoder decodeObjectForKey:@"cardType"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.messageId forKey:@"messageId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.userPortrait forKey:@"userPortrait"];
    [aCoder encodeObject:self.userAge forKey:@"userAge"];
    [aCoder encodeObject:self.cardType forKey:@"cardType"];
    
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
    self.userName   ? [dataDict setObject:self.userName forKey:@"userName"] : nil;
    self.userPortrait   ? [dataDict setObject:self.userPortrait forKey:@"userPortrait"] : nil;
    self.userAge   ? [dataDict setObject:self.userAge forKey:@"userAge"] : nil;
    self.cardType   ? [dataDict setObject:self.cardType forKey:@"cardType"] : nil;
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [userDic setObject:self.senderUserInfo.name forKeyedSubscript:@"senderName"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"senderPortraitUri"];
        }
        if (self.senderUserInfo.userId) {
            [userDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"senderUserId"];
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
        self.messageId               = json[@"messageId"];
        self.userName                = json[@"userName"];
        self.userPortrait            = json[@"userPortrait"];
        self.userAge                 = json[@"userAge"];
        self.cardType                = json[@"cardType"];

        
        NSObject *object = [json objectForKey:@"sender"];
        NSDictionary *userinfoDic = nil;
        if (object &&[object isMemberOfClass:[NSDictionary class]]) {
            userinfoDic = (NSDictionary *)object;
        }
        if (userinfoDic) {
            RCUserInfo *userinfo =[RCUserInfo new];
            userinfo.userId = [userinfoDic objectForKey:@"senderUserId"];
            userinfo.name =[userinfoDic objectForKey:@"senderName"];
            userinfo.name =[userinfoDic objectForKey:@"senderPortraitUri"];
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
    return RCBusinessCardMessageTypeIdentifier;
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
    
    return @"[名片]";
}




@end
