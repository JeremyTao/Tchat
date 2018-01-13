//
//  MKChatTool.h
//  Moka
//
//  Created by  moka on 2017/8/12.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKChatTool : NSObject

@property (nonatomic, strong) NSMutableArray *friendArray; //好友数组
@property (nonatomic, strong) NSMutableArray *groupArray;  //圈子数组

@property (nonatomic, strong) RCUserInfo  *currentUserInfo;



+ (instancetype)sharedChatTool;



//登录融云
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token;

//从服务器获取好友
-(void)syncFriendList:(void (^)(NSMutableArray * friends,BOOL isSuccess))completion;

//从服务器获取群组
-(void)syncGroupList:(void (^)(NSMutableArray * groups,BOOL isSuccess))completion;

//刷新tabbar的角标
-(NSString *)refreshBadgeValueInTabbarController:(UITabBarController *)tabbarVC;

//根据ID获取用户名
-(NSString *)getNameWithUserId:(NSString *)userId;

//根据ID获取用户RCUserInfo
-(RCUserInfo *)getUserInfoWithUserId:(NSString *)userId;

//根据群ID获取RCGroup
-(RCGroup *)getGroupInfoWithGroupId:(NSString *)groupId;

//消息震动通知
- (void)setMessageVibrate:(BOOL)vib;
- (BOOL)isEnableVibrate;

//是否允许语音通知
- (void)setMessageVoiceEnable:(BOOL)voice;
- (BOOL)isEnableVoice;

//重新连接
- (void)retryConnectRongCloud;

@end
