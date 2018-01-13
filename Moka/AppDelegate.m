//
//  AppDelegate.m
//  Moka

//  Created by jansonlei on 19/07/2017.
//  Copyright © 2017 moka. All rights reserved.


#import "AppDelegate.h"
#import "MKNavigationController.h"
#import "MKLoginViewController.h"
#import "MKTabBarViewController.h"
#import "CBNewFeatureController.h"
#import "MKSecurity.h"
#import <MapKit/MapKit.h>
#import "MKRedPacketMessageContent.h"
#import "MKGiftMessage.h"
#import "MKBusinessCardMessage.h"
#import "PPGetAddressBook.h"
#import <AVKit/AVKit.h>
#import "MKIidentificationCardAuthenViewController.h"
#import "MKCircleInfoModel.h"
#import "MKCircleMemberModel.h"
#import "WXApi.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <AlipaySDK/AlipaySDK.h>
#import "upLoadImageManager.h"

@interface AppDelegate ()<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate, RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupMemberDataSource, WXApiDelegate,UIAlertViewDelegate>

{
    int unreadMsgCount;
    NSString *_downloadURLStr;
    NSString *_msgStr;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKTabBarViewController *tabBarVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self requestCheckVersion];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance]  setActive:YES error:nil];
    //Clear keychain on first run in case of reinstallation
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        // Delete values from keychain here
        [[NSUserDefaults standardUserDefaults] setValue:@"1strun" forKey:@"FirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //清除token
        [[A0SimpleKeychain keychain] deleteEntryForKey:apiTokenKey];
        [[A0SimpleKeychain keychain] deleteEntryForKey:apiRongCloudToken];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.name"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.portraitUri"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.userId"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CurrentUserPhone"];
        
        //清除未读消息
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor  = [UIColor whiteColor];
    
    //注册融云
    [self registerRongCloudService];
    //注册友盟
    [self initUMSDK];
    
    // 1.获取当前的版本号
    NSString *myCurrentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:CDVersionKey];
    // 2.获取上一次的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:CDVersionKey];
    //3.token是否存在
    NSString *token = [[A0SimpleKeychain keychain] stringForKey:apiTokenKey];
    // 判断当前是否有新的版本
    if ([myCurrentVersion isEqualToString:lastVersion]){
        // 没有最新的版本号
        if (token.length > 0) {
            //进主页
            self.tabBarVC = [[MKTabBarViewController alloc] init];
            
            self.window.rootViewController = self.tabBarVC;
        }else{
            //登陆页面
            MKNavigationController *loginNavigationController = [[MKNavigationController alloc] initWithRootViewController:[[MKLoginViewController alloc] init]];
            self.window.rootViewController = loginNavigationController;
        }
        
    }else{
        //有新版本发布
        CBNewFeatureController *login = [[CBNewFeatureController alloc] init];
        MKNavigationController *navi = [[MKNavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController = navi;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:showGuideNear];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:showGuideRecommend];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:showGuideWallet];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:showGuideFeed];
        
        
        
        
        //登陆页面
//        MKNavigationController *loginNavigationController = [[MKNavigationController alloc] initWithRootViewController:[[MKLoginViewController alloc] init]];
//        self.window.rootViewController = loginNavigationController;

    }
    
    
    [self.window makeKeyAndVisible];
    

    // locationManager
    self.locationManager = ({
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = 3000;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        locationManager;
    });
    
    //注册消息推送
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //>= IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:notiSettings];
        
    }
    
    //通讯录
    [PPGetAddressBook requestAddressBookAuthorization];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    
    //注册微信
    [WXApi registerApp:WeiChatAppKey];
   
    return YES;
}


//（3）回调方法
/**
 *  errCode
 *   0        成功       展示成功页面
 *   -1       错误       可能的原因：签名错误、未注册APPID、项目设置APPID不正确、
 注册的APPID与设置的不匹配、其他异常等。
 *   -2       用户取消       无需处理。发生场景：用户不支付了，点击取消，返回APP。
 
 */
-(void)onResp:(BaseResp*)resp
{
    //NSLog(@"%@",temp.code);
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSLog(@"%@",temp.code);
        if (temp.code.length > 0) {
            
            
        }
        
    }
    
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    NSLog(@"微信pay: %@", strMsg);
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
//        [QQApiInterface handleOpenURL:url delegate:self];
//        return [TencentOAuth HandleOpenURL:url];
//
//    }
    
    return [WXApi handleOpenURL:url delegate:self];
}


//（2）跳转处理
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    
    NSLog(@"跳转到URL schema中配置的地址-->%@",url);//跳转到URL schema中配置的地址
    
    
    
    [WXApi handleOpenURL:url delegate:self];
    
    
//    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
//        [QQApiInterface handleOpenURL:url delegate:self];
//        return [TencentOAuth HandleOpenURL:url];
//    }
//
    return YES;
}

- (void)requestCheckVersion {
    //获取当前版本
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    NSString *versionCode = [NSString stringWithFormat:@"%@",info[@"CFBundleVersion"]];
    NSDictionary *paraDic = @{@"os": @"1",
                              @"currentVersion":versionCode
                              };
    //
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_checkAppUpdate] params:paraDic success:^(id json) {
        DLog(@"版本更新 %@", json);
        if ([json[@"status"] isEqualToString:@"200"]) {
            //1.增加更新细节提示。\n2.优化界面细节调整。\n3.修复查看成员时出现的闪退现象。\n4.增加打招呼中，送礼物需要验证支付密码的功能。
            _downloadURLStr = json[@"dataObj"][@"downloadUrl"];
            _msgStr = [NSString stringWithFormat:@"%@",[json[@"dataObj"][@"msg"] stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
            //更新
            int code = [json[@"dataObj"][@"updateType"] intValue];
            if (code == 0) {
                [self alertNoticeUpdate];
            }else{
                //强制更新
                [self alertNoticeMustUpdate];
            }
            
        }else{
            //[MKUtilHUD showHUD:json[@"exception"] inView:nil];
        }
    } failure:^(NSError *error) {
        DLog(@"版本更新检查失败 %@", error);
    }];
    
}
#pragma mark  -- 更新提示框
-(void)alertNoticeUpdate{
    //有新版本
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:_msgStr preferredStyle:UIAlertControllerStyleAlert];
    //行设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //行间距
    paragraphStyle.lineSpacing = 5.0;
    //字体
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName : paragraphStyle};
    //
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:_msgStr];
    [attributedTitle addAttributes:attributes range:NSMakeRange(0, _msgStr.length)];
    [alertController setValue:attributedTitle forKey:@"attributedMessage"];
    //
    [alertController addAction:[UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoAppStore];
        
    }]];
    //取消
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //
    [self.tabBarVC presentViewController:alertController animated:YES completion:nil];
}


-(void)alertNoticeMustUpdate{
    //有新版本
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:_msgStr preferredStyle:UIAlertControllerStyleAlert];
    //行设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //行间距
    paragraphStyle.lineSpacing = 5.0;
    //字体
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName : paragraphStyle};
    //
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:_msgStr];
    [attributedTitle addAttributes:attributes range:NSMakeRange(0, _msgStr.length)];
    [alertController setValue:attributedTitle forKey:@"attributedMessage"];
    //
    [alertController addAction:[UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoAppStore];
        
    }]];
    //
    [self.tabBarVC presentViewController:alertController animated:YES completion:nil];
}

-(void)gotoAppStore{
    if (IOS10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadURLStr] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadURLStr]];
    }
}





#pragma mark - Orientation



- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([self.window.rootViewController.presentedViewController isKindOfClass:[MKIidentificationCardAuthenViewController class]])
    {
        MKIidentificationCardAuthenViewController *secondController = (MKIidentificationCardAuthenViewController *) self.window.rootViewController.presentedViewController;
        
        if (secondController.isPresented)
        {
            return UIInterfaceOrientationMaskLandscapeRight;
        }
        else return UIInterfaceOrientationMaskPortrait;
    }
    else return UIInterfaceOrientationMaskPortrait;
}


//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
//    
//    //震动
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    AudioServicesPlaySystemSound(1007);
//}



#pragma mark -- 友盟统计
-(void)initUMSDK{
    
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"5a068fdc8f4a9d51a4000023" channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    //
    [MobClick setCrashReportEnabled:YES];
    
}


- (void)registerRongCloudService {
    NSLog(@"融云版本 %@", [[RCIMClient sharedRCIMClient] getSDKVersion]);
    //1. 注册融云
    [[RCIM sharedRCIM] initWithAppKey:RongCloudAppKey];
   
    
    //注册自定义消息类型
    [[RCIM sharedRCIM] registerMessageType:MKRedPacketMessageContent.class];
    [[RCIM sharedRCIM] registerMessageType:MKGiftMessage.class];
    [[RCIM sharedRCIM] registerMessageType:MKBusinessCardMessage.class];
    //开启用户信息和群组信息数据持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = NO;
    //开启消息@功能
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    
    //开启消息撤回
    [RCIM sharedRCIM].enableMessageRecall = NO;
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    
    
    //设置聊天人头像
    [[RCIM sharedRCIM] setGlobalConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    [[RCIM sharedRCIM] setGlobalConversationPortraitSize:CGSizeMake(40, 40)];
    [[RCIM sharedRCIM] setGlobalMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    [[RCIM sharedRCIM] setGlobalMessagePortraitSize:CGSizeMake(40, 40)];
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor colorWithRed:0.000 green:0.471 blue:1.000 alpha:1.000];
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    
    //设置Log级别，开发阶段打印详细log
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    
    // 设置数据源
    [RCIM sharedRCIM].userInfoDataSource  = self;
    [RCIM sharedRCIM].groupInfoDataSource = self;
    //群成员数据源
    [RCIM sharedRCIM].groupMemberDataSource = self;
}


/*!
 获取当前群组成员列表的回调（需要实现用户信息提供者 RCIMUserInfoDataSource）
 
 @param groupId     群ID
 @param resultBlock 获取成功 [userIdList:群成员ID列表]
 */
- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock {
    [self requestCircleInfosWithCircleId:groupId result:^(NSArray *list) {
        
        NSMutableArray *ret =  [[NSMutableArray alloc] init];
        for (RCUserInfo *user in list) {
            [ret addObject:user.userId];
        }
        resultBlock(ret);
        
    }];
}




#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    //    if (userId == nil || [userId length] == 0) {
    //        RCUserInfo *user = [RCUserInfo new];
    //        user.userId = userId;
    //        user.portraitUri = @"";
    //        user.name = @"";
    //        completion(user);
    //        return ;
    //    }
    //
    //    for (NSInteger i = 0; i <self.friendArray.count; i++) {
    //        RCUserInfo *user = self.friendArray[i];
    //        if ([userId isEqualToString:user.userId]) {
    //            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
    //            completion(user);
    //            break;
    //        }
    //    }
    
    
    //自己服务器查询
    [self requestUserInfoWithUserID:userId completion:^(RCUserInfo *user) {
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
        completion(user);
        
    }];
    
}


#pragma mark - RCIMGroupInfoDataSource
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion {
    NSLog(@"getGroupInfoWithUserId ----- %@", groupId);
    
    //    if (groupId == nil || [groupId length] == 0) {
    //        completion(nil);
    //        return ;
    //    }
    //
    //    for (NSInteger i = 0; i < self.groupArray.count; i++) {
    //
    //        RCGroup *aGroup = self.groupArray[i];
    //
    //        if ([groupId isEqualToString:aGroup.groupId]) {
    //
    //            completion(aGroup);
    //            break;
    //        }
    //    }
    
    [self requestCircleInfoWithCircleID:groupId completion:^(RCGroup *circle) {
        [[RCIM sharedRCIM] refreshGroupInfoCache:circle withGroupId:groupId];
    }];
    
    
}



#pragma mark -HTTP 根据userID用户基本信息

- (void)requestUserInfoWithUserID:(NSString *)userID completion:(void (^)(RCUserInfo *))completion {
    
    __block RCUserInfo *resultInfo;
    
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_getUserInfoByUserId] params:@{@"id":userID} success:^(id json) {
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        //NSString  *message = json[@"exception"];
        DLog(@"根据userID查询用户基本信息 %@",json);
        if (status == 200) {
            NSString *userId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"id"]];
            NSString *userName = json[@"dataObj"][@"name"];
            //
            NSString * userPortrait = [upLoadImageManager judgeThePathForImages:json[@"dataObj"][@"portrail"]];
            
            //NSString *userPortrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"portrail"]];
            //
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:userName portrait:userPortrait];
            resultInfo = userInfo;
            completion(resultInfo);
            
        } else {
            //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"%@",error);
        
    }];
}



#pragma mark -HTTP 根据CircleID用户基本信息

- (void)requestCircleInfoWithCircleID:(NSString *)circleID completion:(void (^)(RCGroup *))completion {
    
    __block RCGroup *resultInfo;
    
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_getCircleInfoById] params:@{@"id":circleID} success:^(id json) {
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        //NSString  *message = json[@"exception"];
        DLog(@"根据CircleID用户基本信息 %@",json);
        if (status == 200) {
            NSString *groupId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"id"]];
            NSString *name = json[@"dataObj"][@"name"];
            //
            NSString *portrait = [upLoadImageManager judgeThePathForImages:json[@"dataObj"][@"imgs"]];
            //NSString *portrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"imgs"]];
            
            RCGroup *circleInfo = [[RCGroup alloc] initWithGroupId:groupId groupName:name portraitUri:portrait];
            resultInfo = circleInfo;
            completion(resultInfo);
            
        } else {
            //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"%@",error);
        
    }];
}


#pragma mark -  HTTP 获取圈子信息

- (void)requestCircleInfosWithCircleId:(NSString *)circleId result:(void (^)(NSArray *userIdList))resultBlock {
    
    NSDictionary *param = @{@"id":circleId};
    
    //api_circel_info
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_circle_members] params:param success:^(id json) {
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        //        NSString  *message = json[@"exception"];
        
        DLog(@"获取圈子信息 %@",json);
        if (status == 200) {
            
            NSMutableArray *array = @[].mutableCopy;
            //群主
            MKCircleMemberModel *adminModel = [MKCircleMemberModel mj_objectWithKeyValues:json[@"dataObj"][@"holder"]];
            //
            NSString *adminPortrait = [upLoadImageManager judgeThePathForImages:adminModel.img];
            //NSString *adminPortrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, adminModel.img];
            RCUserInfo *adminUser = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",(long)adminModel.userid] name:adminModel.name portrait:adminPortrait];
            [array addObject:adminUser];
            //群成员
            MKCircleInfoModel *memberModel = [MKCircleInfoModel mj_objectWithKeyValues:json[@"dataObj"]];
            for (MKCircleMemberModel * model in memberModel.memberList) {
                //
                NSString *memberPortrait = [upLoadImageManager judgeThePathForImages:model.img];
                //NSString *memberPortrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, model.img];

                RCUserInfo *memberUser = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld", (long)model.userid] name:model.name portrait:memberPortrait];

                [array addObject:memberUser];
            }

            resultBlock(array);
            
//            MKCircleInfoModel *circleInfoModel = [MKCircleInfoModel mj_objectWithKeyValues:json[@"dataObj"]];
//
//            NSMutableArray *array = @[].mutableCopy;
//
//            for (MKCircleMemberModel *model in circleInfoModel.memberList) {
//                NSString *portrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, model.img];
//
//                RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld", (long)model.userid] name:model.name portrait:portrait];
//
//                [array addObject:user];
//            }
//
//            resultBlock(array);
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}





- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"Registfail%@",error);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString * tokenstring = [[[deviceToken description]
                               stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                              stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"---Token--: %@", tokenstring);
    NSLog(@"%@",deviceToken);
    [[NSUserDefaults standardUserDefaults] setObject:tokenstring forKey:@"Token"];
    [self pushToken:tokenstring];
    
    
    NSString *token =  [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                                              withString:@""]
                         stringByReplacingOccurrencesOfString:@">"  withString:@""]
                         stringByReplacingOccurrencesOfString:@" " withString:@""];
    /*
     deviceToken 用于 APNS 的，从苹果服务器获取的设备唯一标识。
     您需要将获取到的 deviceToken 通过 setDeviceToken 方法传给融云，才能收到苹果的 APNS 远程通知，否则在您的应用退出之后，将无法收到消息的远程通知。
     */
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Background &&
         left.integerValue == 0) {
        unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_DISCUSSION),
                                                                             @(ConversationType_APPSERVICE),
                                                                             @(ConversationType_PUBLICSERVICE),
                                                                             @(ConversationType_GROUP)
                                                                             ]];
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        unreadMsgCount;
        if (unreadMsgCount == 0) {
            _tabBarVC.tabBar.items[1].badgeValue = nil;
        } else {
            _tabBarVC.tabBar.items[1].badgeValue = [NSString stringWithFormat:@"%d", unreadMsgCount];
        }
        
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{ // 处理推送消息
    
    NSLog(@"userinfo:%@",userInfo);
    
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);

    
}

-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName{
    //群组通知不弹本地通知
    if ([message.content isKindOfClass:[RCGroupNotificationMessage class]]) {
        return YES;
    }
    return NO;
}


- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left {
    
    
   
    //自己服务器查询
//    [self requestUserInfoWithUserID:message.targetId completion:^(RCUserInfo *user) {
//        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
//
//    }];
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"vibrateKey"]) {
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    
}


- (void)pushToken:(NSString *)pushToken {
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[
                                               @(ConversationType_PRIVATE),
                                               @(ConversationType_DISCUSSION),
                                               @(ConversationType_APPSERVICE),
                                               @(ConversationType_PUBLICSERVICE),
                                               @(ConversationType_GROUP)
                                               ]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }

}



#pragma mark -- 支付宝

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"充值结果 result = %@",resultDic[@"resultStatus"]);
            
            //通知传值 -> 零钱充值
            NSNotification *notification = [NSNotification notificationWithName:@"AlipayCharge" object:nil userInfo:@{@"result":resultDic[@"resultStatus"]}];

            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
                
                //通知传值 -> 零钱首页
                NSNotification *notification = [NSNotification notificationWithName:@"MyWallet" object:nil userInfo:@{@"authCode":authCode}];
                
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            }else{
                
                [MKUtilHUD showHUD:@"授权失败..." inView:nil];
            }


        }];
        
        
        
    }
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshBadgeCount" object:nil userInfo:@{@"badgeValue":@(unreadMsgCount)}];
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
