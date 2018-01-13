//
//  MKChatTool.m
//  Moka
//
//  Created by  moka on 2017/8/12.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKChatTool.h"
#import "MKPeopleModel.h"
#import "MKCircleListModel.h"
#import "MKCircleInfoModel.h"
#import "MKCircleMemberModel.h"
#import "upLoadImageManager.h"

@interface MKChatTool ()

{
    NSString *rcToken;
}


@end

@implementation MKChatTool


+ (instancetype)sharedChatTool {
    static MKChatTool *_shareChatTool = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _shareChatTool = [[MKChatTool alloc] init];
        
    });
    
    return _shareChatTool;
}

- (instancetype)init{
    if (self = [super init]) {
       
        _friendArray = @[].mutableCopy;
        _groupArray  = @[].mutableCopy;
        
        
        //获取好友列表
        [self requestFollowList];
        
        //获取圈子列表
        [self requestGroupList];
        
    }
    return self;
}

//登录融云
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token {
    
    if (token.length > 0) {
        self.currentUserInfo = userInfo;
        rcToken = token;
    } else {
        
//        NSString *rongToken = [[A0SimpleKeychain keychain] stringForKey:apiRongCloudToken];
//        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userId"];
//        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
//        NSString *portrait = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.portraitUri"];
//        RCUserInfo *savedUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:portrait];
//        self.currentUserInfo = savedUserInfo;
//        rcToken = rongToken;
        
    }
    
    
    WEAK_SELF;
    [[RCIM sharedRCIM] connectWithToken:rcToken success:^(NSString *userId) {
        STRONG_SELF;
        NSLog(@"融云登陆成功。当前登录的用户ID：%@, 用户名: %@, 头像: %@", userId, self.currentUserInfo.name, self.currentUserInfo.portraitUri);
        

        [RCIM sharedRCIM].currentUserInfo = self.currentUserInfo;
        [[RCIM sharedRCIM] refreshUserInfoCache:self.currentUserInfo withUserId:userId];
        
        [RCIMClient sharedRCIMClient].currentUserInfo = self.currentUserInfo;
        
    
        [strongSelf.friendArray addObject:self.currentUserInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RongCloudLoginSuccess" object:nil];
    
        [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
        
        
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@ "登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"融云登录ERROR: token错误");
    }];
    
    
    
}

- (void)retryConnectRongCloud {

    NSString *rongToken = [[A0SimpleKeychain keychain] stringForKey:apiRongCloudToken];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userId"];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
    NSString *portrait = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.portraitUri"];
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:portrait];
    if (apiRongCloudToken.length > 0) {
        [self loginRongCloudWithUserInfo:userInfo withToken:rongToken];
    }
      
    
}

//从服务器获取好友
-(void)syncFriendList:(void (^)(NSMutableArray * friends,BOOL isSuccess))completion {
    
    
    completion(self.friendArray,YES);
}

//从服务器获取群组
-(void)syncGroupList:(void (^)(NSMutableArray * groups,BOOL isSuccess))completion {
    
    completion(self.groupArray,YES);
    
}

//根据ID获取用户名
-(NSString *)getNameWithUserId:(NSString *)userId{
    for (NSInteger i = 0; i < self.friendArray.count; i++) {
        RCUserInfo *aUser = self.friendArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            NSLog(@"current ＝ %@",aUser.name);
            return aUser.name;
        }
    }
    //没从好友列表找到，去服务器请求
    
    return nil;
}

//根据ID获取用户RCUserInfo
-(RCUserInfo *)getUserInfoWithUserId:(NSString *)userId{
    for (NSInteger i = 0; i < self.friendArray.count; i++) {
        RCUserInfo *aUser = self.friendArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            NSLog(@"current ＝ %@", aUser.name);
            return aUser;
        }
    }
    return nil;
}

//根据群ID获取用户RCGroup
-(RCGroup *)getGroupInfoWithGroupId:(NSString *)groupId{
    for (NSInteger i = 0; i < self.groupArray.count; i++) {
        RCGroup *aGroup = self.groupArray[i];
        if ([groupId isEqualToString:aGroup.groupId]) {
            return aGroup;
        }
    }
    return nil;
}




- (NSString *)refreshBadgeValueInTabbarController:(UITabBarController *)tabbarVC {
    NSInteger unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
    
    
    UINavigationController  *chatNav = tabbarVC.viewControllers[1];
    if (unreadMsgCount == 0) {
        chatNav.tabBarItem.badgeValue = nil;
        return nil;
    }else{
        chatNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",(long)unreadMsgCount];
        return chatNav.tabBarItem.badgeValue;
    }
    
}


#pragma mark -HTTP 我的关注人列表

- (void)requestFollowList {

    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_follow_list] params:nil success:^(id json) {
     
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        //NSString  *message = json[@"exception"];
        DLog(@"我的关注人 %@",json);
        if (status == 200) {
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKPeopleModel *model = [MKPeopleModel mj_objectWithKeyValues:dict];
                //
                NSString *portraitURL = [upLoadImageManager judgeThePathForImages:model.img];
                //NSString *portraitURL = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, model.img];
                NSString *userId = [NSString  stringWithFormat:@"%ld", (long)model.coveruserid];
                RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:model.name portrait:portraitURL];
                [_friendArray addObject:userInfo];
                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
            }
            
        } else {
            //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
        }
        
    } failure:^(NSError *error) {
     
        DLog(@"%@",error);
    }];
}


#pragma mark -HTTP 我的圈子列表

- (void)requestGroupList {
    
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_my_circles] params:nil success:^(id json) {
      
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        //NSString  *message = json[@"exception"];
        DLog(@"我的圈子 %@",json);
       
        if (status == 200) {
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKCircleListModel *model = [[MKCircleListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                NSString *groupId = [NSString stringWithFormat:@"%ld", (long)model.id];
                //
                NSString *groupPortait = [upLoadImageManager judgeThePathForImages:model.imgs];
                //NSString *groupPortait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, model.imgs];
                RCGroup *groupInfo = [[RCGroup alloc] initWithGroupId:groupId groupName:model.name portraitUri:groupPortait];
                [_groupArray addObject:groupInfo];
                [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:groupId];
            }
            
        } else {
            //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
        }
        
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
    
}

- (void)setMessageVibrate:(BOOL)vib {
    
    [[NSUserDefaults standardUserDefaults] setBool:vib forKey:@"enableVibrate"];
    
}

- (BOOL)isEnableVibrate {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"enableVibrate"];
}

- (void)setMessageVoiceEnable:(BOOL)voice {
    [[NSUserDefaults standardUserDefaults] setBool:voice forKey:@"enableVoice"];
}

- (BOOL)isEnableVoice {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"enableVoice"];
}



@end
