//
//  MKConversationViewController.m
//  Moka
//
//  Created by  moka on 2017/8/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKConversationViewController.h"
#import "CBPickLocationViewController.h"
#import "MKSendPersonalRedPacketViewController.h"
#import "MKSendGroupRedPacketViewController.h"
#import "MKRedPacketDetailViewController.h"
#import "MKRedPacketCell.h"
#import "MKRedPacketMessageContent.h"
#import "MKRedPacketPopView.h"
#import "MKSayHelloPopView.h"
#import "MKGiftCell.h"
#import "MKGiftMessage.h"
#import "MKShowLocationViewController.h"
#import "MKCircleMemberViewController.h"
#import "MKFollowListViewController.h"
#import "MKBusinessCardMessage.h"
#import "MKBusinessCardCell.h"
#import "MKSetPaymentPasswordViewController.h"
#import "MKGroupInfoViewController.h"
#import "MKAddNoteNameViewController.h"
#import "MKJoinGroupPopView.h"
#import "RedPacketTypeHomeViewController.h"
#import "upLoadImageManager.h"
#import "NewGroupDetailModel.h"
#import "GroupGetModel.h"

@class RCloudImageView;

@interface MKConversationViewController ()<CBPickLocationViewControllerDelegate, MKRedPacketPopViewDelegate, MKSayHelloPopViewDelegate, MKGiftCellDelegate, MKFollowListViewControllerDelegate>
{
    BOOL isInBlackList;
    BOOL isSetNoDisturb;
    BOOL isNeedReshowPopGift;
    NSInteger numbers;
    NSString * trpassword;
}
@property (nonatomic, strong) MKRedPacketPopView *redPacketPopView;
@property (nonatomic, strong) MKSayHelloPopView *sayHelloPopView;
@property (nonatomic, strong) MKJoinGroupPopView *paymentView;

@end

@implementation MKConversationViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendRedSuc" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendGroupRedSuc" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isNeedReshowPopGift) {
        [self performSelector:@selector(popSayHello) withObject:nil afterDelay:0];
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedUserInfoChangeNaviTitle:) name:@"updatedUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doClearChat) name:@"ClearChat" object:nil];
    
    self.redPacketPopView = [MKRedPacketPopView newPopView];
    self.redPacketPopView.delegate = self;
    
    self.sayHelloPopView = [MKSayHelloPopView newPopView];
    self.sayHelloPopView.delegate = self;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 30, 30);
    [moreButton setImage:IMAGE(@"near_more") forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.navigationItem.rightBarButtonItem = menuItem;
    
    //检查是否打过招呼
    if (self.ifSayHello && self.conversationType == ConversationType_PRIVATE) {
        [self performSelector:@selector(popSayHello) withObject:nil afterDelay:0];
    }
    
    //注册Cell
    [self registerClass:[MKRedPacketCell class] forMessageClass:[MKRedPacketMessageContent class]];
    [self registerClass:[MKGiftCell class] forMessageClass:[MKGiftMessage class]];
    [self registerClass:[MKBusinessCardCell class] forMessageClass:[MKBusinessCardMessage class]];
    
    
    //设置聊天界面(面板)
    //系统本来带有3个扩展功能，tag＝1001是照片，tag＝1002是拍照，tag＝1003是定位
    
    if (self.conversationType == ConversationType_PRIVATE) {
        
        self.displayUserNameInCell = NO;
        
        //自己服务器查询
       
        
        [self requestUserInfoWithUserID:self.targetId completion:^(RCUserInfo *user) {
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:self.targetId];
        }];
        
    } else if (self.conversationType  == ConversationType_GROUP) {
        
        self.displayUserNameInCell = YES;
        //在导航栏标题显示多少成员
        [self requestCircleInfoWithCircleID:self.targetId];
    }
    
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE(@"chat_function_redenv")
                                                                   title:@"红包"
                                                                 atIndex:2
                                                                     tag:2000];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE(@"chat_function_social_card")
                                                                   title:@"名片"
                                                                 atIndex:4
                                                                     tag:4000];
    
    //更换现有扩展项的图标和标题:
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:IMAGE(@"chat_function_photo") title:@"照片"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:1 image:IMAGE(@"chat_function_camera") title:@"拍摄"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:3 image:IMAGE(@"chat_function_gps") title:@"位置"];
    
    
    
    //[bizStatus:该用户是否在黑名单中。0表示已经在黑名单中，101表示不在黑名单中]
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:self.targetId success:^(int bizStatus) {
        if (bizStatus == 0) {
            isInBlackList = YES;
        } else {
            isInBlackList = NO;
        }
    } error:^(RCErrorCode status) {
        
    }];
    
    
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
        if (nStatus == 0) {
            isSetNoDisturb = YES;
        } else {
            isSetNoDisturb = NO;
        }
        
    } error:^(RCErrorCode status) {
        
    }];
    
    //注册通知 接收发送TV红包成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendPersionRedS:) name:@"sendRedSuc"object:nil];
    //sendGroupRedSuc
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendGroupRedS:) name:@"sendGroupRedSuc"object:nil];
    
}

- (void)sendPersionRedS:(NSNotification *)noti{
    [self sendMessage:noti.userInfo[@"sendPSuc"] pushContent:nil];
}
- (void)sendGroupRedS:(NSNotification *)noti{
    [self sendMessage:noti.userInfo[@"sendGSuc"] pushContent:nil];
    
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
            self.title = userName;
            //
            NSString *userPortrait = [upLoadImageManager judgeThePathForImages:json[@"dataObj"][@"portrail"]];
            //NSString *userPortrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"portrail"]];
            
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

- (void)updatedUserInfoChangeNaviTitle:(NSNotification *)noti {
    NSString *noteName = noti.userInfo[@"noteName"];
    self.title = noteName;
}


- (void)menuClick:(UIButton *)moreBtn {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (self.conversationType == ConversationType_PRIVATE) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"查看Ta的资料" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
        
            memberInfoVC.userId = self.targetId;
            [self.navigationController pushViewController:memberInfoVC animated:YES];
           
            
        }]];
        
        
        if (isInBlackList) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"移出黑名单" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [MKUtilHUD showHUD:@"移出黑名单成功" inView:self.view];
                [[RCIMClient sharedRCIMClient] removeFromBlacklist:self.targetId success:^{
                    DLog(@"移出黑名单成功");
                    
                    
                    isInBlackList = NO;
                } error:^(RCErrorCode status) { }];
                
            }]];
            
        } else {
            [alertController addAction:[UIAlertAction actionWithTitle:@"加入黑名单" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [MKUtilHUD showHUD:@"加入黑名单成功" inView:self.view];
                [[RCIMClient sharedRCIMClient] addToBlacklist:self.targetId success:^{
                    
                    DLog(@"加入黑名单成功");
                    isInBlackList = YES;
                } error:^(RCErrorCode status) { }];
                
            }]];
            
        }
        

    } else if (self.conversationType == ConversationType_GROUP) {
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"查看圈子资料" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            //跳转到圈子信息
            MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
            groupInfoVC.cicleId = self.targetId;
            [self.navigationController pushViewController:groupInfoVC animated:YES];
            
        }]];
        
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"清空聊天记录" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *confirmController = [UIAlertController alertControllerWithTitle:@"清除聊天记录?" message:@"清除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
        
        [confirmController addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [[RCIMClient sharedRCIMClient] clearMessages:self.conversationType targetId:self.targetId];
            [self.conversationDataRepository removeAllObjects];
            [self.conversationMessageCollectionView reloadData];
            
        }]];
        
        [confirmController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:confirmController animated:YES completion:nil];
       
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)popSayHello {
    [self.sayHelloPopView showInViewController:self.navigationController];
    
    
    WEAK_SELF;
    self.paymentView = [MKJoinGroupPopView newPopViewWithInputBlock:^(NSString *text) {
        STRONG_SELF;
        NSLog(@"text = %@",text);
        trpassword = text;
        [strongSelf requestSayHelloWithGift];
        //[MKUtilHUD showHUD:[NSString stringWithFormat:@"密码:%@ ,请确认发送礼物",text] inView:nil];
        [self.paymentView hide];
        [strongSelf.view endEditing:YES];
    }];
    
}

#pragma mark -  即将显示cell

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //文本文字
    if ([cell isMemberOfClass:[RCConversationCell class]]) {
        RCConversationCell *conCell = (RCConversationCell *)cell;
        UIImageView *conImageView = (UIImageView *)conCell.headerImageView;
        conImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    //打招呼
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
        //检查是否打过招呼
        if (self.ifSayHello && self.conversationType == ConversationType_PRIVATE) {
            [self requestSayHelloWithMessage:textCell.textLabel.text];
        }
    } else if ([cell isMemberOfClass:[RCLocationMessageCell class]]) {
        //地图位置
        RCLocationMessageCell *locationCell = (RCLocationMessageCell *)cell;
        locationCell.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    } else if ([cell isMemberOfClass:[MKGiftCell class]]) {
        //礼物消息
        MKGiftCell *giftCell = (MKGiftCell *)cell;
        giftCell.getDelegate = self;
    }
    
    if ([cell isMemberOfClass:[MKRedPacketCell class]]) {

        MKRedPacketCell *redPacketCell = (MKRedPacketCell *)cell;
        RCMessageModel *messageModel = self.conversationDataRepository[indexPath.row];

        if ([messageModel.content isMemberOfClass:[MKRedPacketMessageContent class]]) {

            [self changeRedPacketStatus:(MKRedPacketMessageContent *)messageModel.content changeRedState:redPacketCell];
        }

    }
}
- (void)changeRedPacketStatus:(MKRedPacketMessageContent *)redPacketMessage changeRedState:(MKRedPacketCell *)redCell{
    
    NSDictionary *paramDitc = @{@"uid" : redPacketMessage.messageId};

    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_redPacketDetails] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
    
        DLog(@"查询个人红包信息 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            NewGroupDetailModel * newGroupDetailModel = [NewGroupDetailModel mj_objectWithKeyValues:json[@"dataObj"]];
            NSInteger redPacketStatus = [json[@"dataObj"][@"state"] integerValue];
            //0-未领取 ，1-已领取， 2-已过期， 3-已抢完
            if (redPacketStatus == 0) {
                redCell.getLabel.text = @"领取红包";
                redCell.bubbleBackgroundView.tintColor = RedPacketColor;
            } else if (redPacketStatus == 1) {
                redCell.getLabel.text = @"已领取";
                redCell.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
            } else if (redPacketStatus == 2) {
                redCell.getLabel.text = @"已过期";
                redCell.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
            }else if (redPacketStatus == 3) {
                
                NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
                
                for (GroupGetModel * sendUser in newGroupDetailModel.receiveUserList) {
                    
                    NSString * userID = [NSString stringWithFormat:@"%ld",sendUser.id];

                    [array addObject:userID];

                }
                if ([array containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_USER_ID"]]) {
                    
                    redCell.getLabel.text = @"已领取";
                    redCell.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
                    
                }else{
                    
                    redCell.getLabel.text = @"已抢完";
                    redCell.bubbleBackgroundView.tintColor = RGB_COLOR_HEX(0xE18181);
                }
            }
        }
    } failure:^(NSError *error) {

    }];
}


- (CGSize)getTextLabelSize:(NSString *)message {
    if ([message length] > 0) {
        float maxWidth = [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        CGRect textRect = [message boundingRectWithSize:CGSizeMake(maxWidth, 8000) options:
                           
                           (NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                           
                                             attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15] }
                           
                                                context:nil];
        
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}

- (void)doClearChat {
    [self.conversationDataRepository removeAllObjects];
    [self.conversationMessageCollectionView reloadData];
}


#pragma mark - 点击事件回调

/*!
 点击Cell中的消息内容的回调
 
 
 @discussion SDK在此点击事件中，针对SDK中自带的图片、语音、位置等消息有默认的处理，如查看、播放等。
 您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */
- (void)didTapMessageCell:(RCMessageModel *)model {
    if ([model.content isMemberOfClass:[MKRedPacketMessageContent class]]) {
        if (self.conversationType == ConversationType_PRIVATE) {
            if (model.messageDirection == MessageDirection_RECEIVE) {
                //别人发的红包
                //查询红包
                [self requestQueryRedPacketInfoWith:(MKRedPacketMessageContent *)model.content];
                
            } else {
                MKRedPacketMessageContent *redPacketMsg = (MKRedPacketMessageContent *)model.content;
                //自己发的红包，进入详情
                MKRedPacketDetailViewController *redVC = [[MKRedPacketDetailViewController alloc] init];
                MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:redVC];
                redVC.navigationController.navigationBar.hidden = YES;
                redVC.redPacketMessage = redPacketMsg;
                redVC.conversationType = self.conversationType;
                [self presentViewController:nav animated:YES completion:nil];
            }
        } else if (self.conversationType == ConversationType_GROUP) {
            
             [self requestQueryRedPacketInfoWith:(MKRedPacketMessageContent *)model.content];
        }
        
    } else if ([model.content isMemberOfClass:[RCLocationMessage class]]) {
        RCLocationMessage *locationMessage = (RCLocationMessage *)model.content;
        //位置消息
        MKShowLocationViewController *vc = [[MKShowLocationViewController alloc] init];
        vc.locationMessage = locationMessage;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if ([model.content isMemberOfClass:[MKBusinessCardMessage class]]) {
        MKBusinessCardMessage *cardMessage = (MKBusinessCardMessage *)model.content;
        
        if ([cardMessage.cardType isEqualToString:@"0"]) {
            MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
            
            memberInfoVC.userId = cardMessage.messageId;
            [self.navigationController pushViewController:memberInfoVC animated:YES];
            
        } else if ([cardMessage.cardType isEqualToString:@"1"]) {
            MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
            
            groupInfoVC.cicleId = cardMessage.messageId;
            
            [self.navigationController pushViewController:groupInfoVC animated:YES];
        }
        
    }

    else {
        [super didTapMessageCell:model];
    }
    
}

//领取礼物
- (void)didClickedGetButtonWith:(MKGiftMessage *)message {
    
    [self requestQueryMessageInfoWith:message];
}



/*!
 点击Cell中头像的回调
 
 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId {
    NSLog(@"点击Cell中头像的回调 userId = %@", userId);
    MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
    memberInfoVC.userId = userId;
    [self.navigationController pushViewController:memberInfoVC animated:YES];
}

#pragma mark - 面板功能区点击
-  (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    
    if (tag == 2000) {
        DLog(@"红包");
        
        if (self.conversationType == ConversationType_PRIVATE) {
            RedPacketTypeHomeViewController * vc = [[RedPacketTypeHomeViewController alloc]init];
            vc.type = @"PRIVATE";
            vc.targetID = self.targetId;
            [self presentViewController:vc animated:YES completion:nil];
        }else if (self.conversationType == ConversationType_GROUP){
            
            RedPacketTypeHomeViewController * vc = [[RedPacketTypeHomeViewController alloc]init];
            vc.type = @"GROUP";
            vc.targetID = self.targetId;
            vc.number = numbers;
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        return;
        
        
    } else if (tag == 4000) {
        DLog(@"名片");
        MKFollowListViewController *vc = [[MKFollowListViewController alloc] init];
        
        vc.isShare = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (tag == PLUGIN_BOARD_ITEM_LOCATION_TAG) {
        CBPickLocationViewController *locationVC = [[CBPickLocationViewController alloc] init];
        locationVC.delegate = self;
        [self.navigationController pushViewController:locationVC animated:YES];
    } else {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
    
}

//发送名片消息

- (void)sendBusinessCard:(MKPeopleModel *)userModel toUser:(NSString *)targetID {
    
    NSLog(@"发送名片消息:%ld ，给用户ID: %@",(long)userModel.coveruserid, targetID);
    
    MKBusinessCardMessage *cardMessage = [[MKBusinessCardMessage alloc] init];
    cardMessage.messageId = [NSString stringWithFormat:@"%ld", (long)userModel.coveruserid];
    cardMessage.userName = userModel.name;
    cardMessage.userPortrait = userModel.img;
    //
    cardMessage.userAge = [NSString stringWithFormat:@"%ld", (long)userModel.age];
    cardMessage.cardType = @"0";
    [self sendMessage:cardMessage pushContent:nil];
}

#pragma mark - MKRedPacketPopViewDelegate
- (void)didClickedOpenButtonWith:(MKRedPacketMessageContent *)redPacketMessage {
     //OPEN --> 打开红包
    [self requestOpenRedPacketWith:redPacketMessage];
}

//查看红包详细
- (void)didClickedSeeDetailButtonWith:(MKRedPacketMessageContent *)redPacketMessage {
    [_redPacketPopView hide];
    //进入详情
    MKRedPacketDetailViewController *redVC = [[MKRedPacketDetailViewController alloc] init];
    MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:redVC];
    redVC.navigationController.navigationBar.hidden = YES;
    redVC.redPacketMessage = redPacketMessage;
    redVC.conversationType = self.conversationType;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - HTTP  打招呼

- (void)requestSayHelloWithGift {
    
    NSString *encripPassword  = [MKTool md5_passwordEncryption:trpassword];
    
    NSDictionary *paramDitc = @{@"coveruserid":self.sayHelloUserID,
                                @"state" : @"2",
                                @"money" : @"40",
                                @"trpassword":encripPassword,
                                @"remark" : @""
                                };
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_say_hello2] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"打招呼Gift %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            //发送礼物消息
            MKGiftMessage *giftMessage = [[MKGiftMessage alloc] init];
            giftMessage.messageId = json[@"dataObj"];
            [strongSelf sendMessage:giftMessage pushContent:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SayHelloSeccess" object:nil];
            
            strongSelf.ifSayHello = NO;
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}


- (void)requestSayHelloWithMessage:(NSString *)textMsg {
    NSDictionary *paramDitc = @{@"state" : @"1",
                                @"remark" : textMsg ? textMsg : @"",
                                @"money" : @"",
                                @"trpassword":@"",
                                @"coveruserid":self.targetId};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_say_hello2] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        //NSString  *message = json[@"exception"];
        DLog(@"打招呼TEXT %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            strongSelf.ifSayHello = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SayHelloSeccess" object:nil];
        } else {
            //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}


#pragma mark - HTTP 打开红包

- (void)requestOpenRedPacketWith:(MKRedPacketMessageContent *)redPacketMessage {
    NSDictionary *paramDitc = @{@"uid" : redPacketMessage.messageId};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_getPersRedPacket] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"打开个人红包 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            //领取成功
            [_redPacketPopView hide];
            NSString * redStatus = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"status"]];
            
            //更改刷新数据源
            for (RCMessageModel *messageModel in  strongSelf.conversationDataRepository) {
                if ([messageModel.content isMemberOfClass:[MKRedPacketMessageContent class]]) {
                    MKRedPacketMessageContent *msgContent = (MKRedPacketMessageContent *)messageModel.content;
                    if ([msgContent.messageId isEqualToString:redPacketMessage.messageId]) {
                       
                        if([redStatus isEqualToString:@"3"]) {
                            //把领取记录保存到本地  修改附加消息extra
                            msgContent.status= @"3";
                            [[RCIMClient sharedRCIMClient] setMessageExtra:messageModel.messageId value:@"3"];
                        }else if ([redStatus isEqualToString:@"2"]){
                            msgContent.status= @"2";
                            [[RCIMClient sharedRCIMClient] setMessageExtra:messageModel.messageId value:@"2"];
                        }else{
                            msgContent.status= @"1";
                            [[RCIMClient sharedRCIMClient] setMessageExtra:messageModel.messageId value:@"1"];
                        }

                        [strongSelf.conversationMessageCollectionView reloadData];
                    }
                }
            }
            
            //跳转红包详情
            MKRedPacketDetailViewController *redVC = [[MKRedPacketDetailViewController alloc] init];
            MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:redVC];
            redVC.navigationController.navigationBar.hidden = YES;
            redVC.redPacketMessage = redPacketMessage;
            redVC.conversationType = self.conversationType;
            [self presentViewController:nav animated:YES completion:nil];
            

        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}

#pragma mark - HTTP 查询红包详情信息
- (void)requestQueryRedPacketInfoWith:(MKRedPacketMessageContent *)redPacketMessage {
    NSDictionary *paramDitc = @{@"uid" : redPacketMessage.messageId};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_redPacketDetails] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        DLog(@"查询个人红包信息 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            NewGroupDetailModel * newGroupDetailModel = [NewGroupDetailModel mj_objectWithKeyValues:json[@"dataObj"]];
            NSInteger redPacketStatus = [json[@"dataObj"][@"state"] integerValue];
            //0-未领取 ，1-已领取， 2-已过期， 3-已抢完
            if (redPacketStatus == 0) {
                //弹出领红包
                [self.redPacketPopView showInViewController:self];
                [self.redPacketPopView configRedPacketWith:redPacketMessage pastDue:NO robOut:NO];
            } else if (redPacketStatus == 1) {
                //进入详情
                MKRedPacketDetailViewController *redVC = [[MKRedPacketDetailViewController alloc] init];
                MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:redVC];
                redVC.navigationController.navigationBar.hidden = YES;
                redVC.redPacketMessage = redPacketMessage;
                redVC.conversationType = self.conversationType;
                [self presentViewController:nav animated:YES completion:nil];

            } else if (redPacketStatus == 2) {
                if (self.conversationType == ConversationType_PRIVATE) {
                    //弹出已过期
                    [self.redPacketPopView showInViewController:self];
                    [self.redPacketPopView configRedPacketWith:redPacketMessage pastDue:YES robOut:NO];
                    [self.redPacketPopView setRedPacketPastDue];
                } else if (self.conversationType == ConversationType_GROUP) {
                    MKRedPacketDetailViewController *redVC = [[MKRedPacketDetailViewController alloc] init];
                    MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:redVC];
                    redVC.navigationController.navigationBar.hidden = YES;
                    redVC.redPacketMessage = redPacketMessage;
                    redVC.conversationType = self.conversationType;
                    [self presentViewController:nav animated:YES completion:nil];
                }
            }else if (redPacketStatus == 3) {
                
                NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
                for (GroupGetModel * sendUser in newGroupDetailModel.receiveUserList) {
                    
                    NSString * userID = [NSString stringWithFormat:@"%ld",sendUser.id];
                    [array addObject:userID];
                    
                }
                if ([array containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_USER_ID"]]) {
                    
                    MKRedPacketDetailViewController *redVC = [[MKRedPacketDetailViewController alloc] init];
                    MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:redVC];
                    redVC.navigationController.navigationBar.hidden = YES;
                    redVC.redPacketMessage = redPacketMessage;
                    redVC.conversationType = self.conversationType;
                    [self presentViewController:nav animated:YES completion:nil];
                    
                }else{
                    
                    //弹出已抢完
                    [self.redPacketPopView showInViewController:self];
                    [self.redPacketPopView configRedPacketWith:redPacketMessage pastDue:NO robOut:YES];
                    [self.redPacketPopView setRedPacketRobOut];
                }
            }
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}

#pragma mark- HTTP 领取礼物

- (void)requestQueryMessageInfoWith:(MKGiftMessage *)giftMessage {
    NSDictionary *paramDitc = @{@"uid" : giftMessage.messageId};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_queryGift] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        DLog(@"领取礼物 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            //更改刷新数据源
            
            for (RCMessageModel *messageModel in  strongSelf.conversationDataRepository) {
                if ([messageModel.content isMemberOfClass:[MKGiftMessage class]]) {
                    MKGiftMessage *msgContent = (MKGiftMessage *)messageModel.content;
                    if ([msgContent.messageId isEqualToString:giftMessage.messageId]) {
                        
                        //把领取记录保存到本地  修改附加消息extra
                        msgContent.status= @"1";
                        [[RCIMClient sharedRCIMClient] setMessageExtra:messageModel.messageId value:@"1"];
                        [strongSelf.conversationMessageCollectionView reloadData];
                    }
                }
            }
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}


#pragma mark - MKSayHelloPopViewDelegate

//送礼物
- (void)didClickedGiveButton {
    
    [self.sayHelloPopView hide];
    
    //检查支付密码
    [self requestPaymentPasswordSetStatus];
    
}


#pragma mark - http  检查用户是否设置支付密码
- (void)requestPaymentPasswordSetStatus {
    NSDictionary *param = @{};
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_checkPayPasswordSet] params:param success:^(id json) {
        STRONG_SELF;
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSInteger ifPassword = [json[@"dataObj"] integerValue] ;
        NSLog(@"检查用户是否设置支付密码 %@",json);
        if (status == 200 && ifPassword == 1) {
            
            //请求发礼物打招呼
            //请输入支付密码
            [self InPutPayPassword];
            
        } else {
            
            if (ifPassword == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未设置支付密码" message:@"设置支付密码之后，可以使用TV进行打赏，加入付费圈子以及发红包" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    MKSetPaymentPasswordViewController *payPasswordVC = [[MKSetPaymentPasswordViewController alloc] init];
                    
                    isNeedReshowPopGift = YES;
                    [strongSelf.navigationController pushViewController:payPasswordVC animated:YES];
                    
                    
                }]];
                
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                
                [strongSelf presentViewController:alertController animated:YES completion:nil];
            } else {
                [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            }
            
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}


-(void)InPutPayPassword{
    
    [self.paymentView showInViewController:self];
    [self.paymentView configWithCoins:@"40 TV"];
}




- (void)didSelectLocation:(CLLocationCoordinate2D)location
             locationName:(NSString *)locationName
            mapScreenShot:(UIImage *)mapScreenShot {
    
    RCLocationMessage *locationMessage =
    [RCLocationMessage messageWithLocationImage:mapScreenShot
                                       location:location
                                   locationName:locationName];
    [self sendMessage:locationMessage pushContent:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)backClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -HTTP 根据CircleID用户基本信息

- (void)requestCircleInfoWithCircleID:(NSString *)circleID  {

    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_getCircleInfoById] params:@{@"id":circleID} success:^(id json) {
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        //NSString  *message = json[@"exception"];
        DLog(@"根据CircleID用户基本信息 %@",json);
        if (status == 200) {
//            NSString *groupId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"id"]];
//            NSString *name = json[@"dataObj"][@"name"];
//            NSString *portrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"portrail"]];
            if ([json[@"dataObj"][@"count"] integerValue] != 0) {
                NSString *count = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"count"]];
                numbers = [count integerValue];
                self.title = [NSString stringWithFormat:@"%@(%@人)", self.title, count];
            }
            
            for (NSDictionary *dict in json[@"dataObj"][@"memberList"]) {
                NSString *userId = [NSString stringWithFormat:@"%@", dict[@"userid"]];
                NSString *userName = [NSString stringWithFormat:@"%@", dict[@"name"]];
                NSString *userPortrait = [NSString stringWithFormat:@"%@%@",WAP_URL, dict[@"img"]];
                
                RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:userName portrait:userPortrait];
                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
            }
        } else {
            //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"%@",error);
        
    }];
}

@end
