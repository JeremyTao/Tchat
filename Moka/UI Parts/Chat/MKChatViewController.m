//
//  MKCharViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKChatViewController.h"
#import "MKConversationViewController.h"
#import "MKChatHeaderView.h"
#import "MKChatListCustomCell.h"
#import "MKPeopleListViewController.h"
#import "KxMenu.h"
#import "MKAddFriendViewController.h"
#import "MKFollowListViewController.h"
#import "MKMyCirclesViewController.h"
#import "MKOnlineModel.h"
#import "MKRedPacketMessageContent.h"
#import "MKHelloFansCountModel.h"
#import "MKCircleMemberViewController.h"
#import "MKGroupInfoViewController.h"
#import "RCDCustomerServiceViewController.h"
#import "upLoadImageManager.h"
#import "MKSecurity.h"


@interface MKChatViewController ()<MKChatHeaderViewDelegate>

{
    NSMutableArray *onlineUserArray;
    BOOL     isLoadedData;
    MKHelloFansCountModel *helloFansModel;
}

@property (nonatomic, strong) MKChatHeaderView *headerView;

@end

@implementation MKChatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTabbarBadgeValue];
    //[self refreshUserInfomation];
    [self checkNetWork];
}


- (void)refreshUserInfomation {
    
    
    
    for (RCConversationModel *model in self.conversationListDataSource) {
        
        if (model.conversationType == ConversationType_PRIVATE) {
            //自己服务器查询
            [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_getUserInfoByUserId] params:@{@"id":model.targetId} success:^(id json) {
                
                NSInteger status = [[json objectForKey:@"status"] integerValue];
                //NSString  *message = json[@"exception"];
                DLog(@"根据userID查询用户基本信息 %@",json);
                if (status == 200) {
                    NSString *userId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"id"]];
                    NSString *userName = json[@"dataObj"][@"name"];
                    
                    //
                    NSString *userPortrait = [upLoadImageManager judgeThePathForImages:json[@"dataObj"][@"portrail"]];
                    
                    //NSString *userPortrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"portrail"]];
                    
                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:userName portrait:userPortrait];
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
                    
                } else {
                    //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
                }
                
            } failure:^(NSError *error) {
                
                DLog(@"%@",error);
                
            }];

        } else if (model.conversationType == ConversationType_GROUP) {
            
            [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_getCircleInfoById] params:@{@"id":model.targetId} success:^(id json) {
                
                NSInteger status = [[json objectForKey:@"status"] integerValue];
                //NSString  *message = json[@"exception"];
                DLog(@"根据CircleID用户基本信息 %@",json);
                if (status == 200) {
                    NSString *groupId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"id"]];
                    NSString *name = json[@"dataObj"][@"name"];
                    
                    //
                    NSString *portrait = [upLoadImageManager judgeThePathForImages:json[@"dataObj"][@"portrail"]];
                    
                    //NSString *portrait = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, json[@"dataObj"][@"portrail"]];
                    
                    RCGroup *circleInfo = [[RCGroup alloc] initWithGroupId:groupId groupName:name portraitUri:portrait];
                    
                    [[RCIM sharedRCIM] refreshGroupInfoCache:circleInfo withGroupId:groupId];
                    
                } else {
                    //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
                }
                
            } failure:^(NSError *error) {
                
                DLog(@"%@",error);
                
            }];

            
        }
        
    
    }
    
}

-(void)checkNetWork {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] checkNetWorkStatusSuccess:^(id str) {
        STRONG_SELF;
        if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
            //有网络
            [strongSelf hiddenNonetWork];
            [self requestChatHome];
            
        }else{
            //无网络
            [strongSelf showNonetWork];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    self.view.backgroundColor = RGB_COLOR_HEX(0xF5F7FF);
    self.conversationListTableView.backgroundColor = RGB_COLOR_HEX(0xF5F7FF);
  
    onlineUserArray = @[].mutableCopy;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 30, 30);
    [moreButton setImage:IMAGE(@"circle_information") forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    
    
    self.isShowNetworkIndicatorView = NO;
    self.showConnectingStatusOnNavigatorBar = YES;
    self.conversationListTableView.separatorColor = RGB_COLOR_HEX(0xE5E5E5);
    self.conversationListTableView.tableFooterView = [UIView new];
    
    UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_chat"]];
    emptyImageView.frame = CGRectMake(0, 200, 100, 100);
    emptyImageView.contentMode = UIViewContentModeScaleAspectFill;
    emptyImageView.centerX = self.view.centerX;
    
    self.emptyConversationView = emptyImageView;
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rongCloudLoginSuccess) name:@"RongCloudLoginSuccess" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTabbarBadgeValue:) name:@"RefreshBadgeCount" object:nil];
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                          @(ConversationType_GROUP)]];
    
    
 
    
    _headerView  = [MKChatHeaderView newChatHeaderView];
    self.conversationListTableView.tableHeaderView = _headerView;
    _headerView.delegate = self;
    
    
    [self requestChatHome];
}

/**
 *  重写方法，设置会话列表emptyConversationView的视图。
 */
- (void)showEmptyConversationView{
    
}

- (void)refreshTabbarBadgeValue:(NSNotification *)noti {
    
    NSInteger count= [noti.userInfo[@"badgeValue"] integerValue];
    
    NSLog(@"程序进入前台，刷新Badge = %ld", (long)count);
    UITabBarItem   *item = [self.tabBarController.tabBar.items objectAtIndex:1];
    
    if (count > 0) {
        item.badgeValue = [NSString stringWithFormat:@"%ld", (long)count];
    } else {
        item.badgeValue = nil;
    }
    
}


//#pragma mark - 收到消息监听
//- (void)didReceiveMessageNotification:(NSNotification *)notification {
//    
//    [self updateTabbarBadgeValue];
//    
//    [super didReceiveMessageNotification:notification];
//}

- (void)notifyUpdateUnreadMessageCount {
     [self updateTabbarBadgeValue];
}

- (void)updateTabbarBadgeValue {
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:self.displayConversationTypeArray];
        NSLog(@"刷新下标 %d", count);
        UITabBarItem   *item = [__weakSelf.tabBarController.tabBar.items objectAtIndex:1];
        
        if (count > 0) {
            
            item.badgeValue = [NSString stringWithFormat:@"%d", count];
            
        } else {
           
            item.badgeValue = nil;
            
        }
        
    });
}


- (void)rongCloudLoginSuccess {
    [self.conversationListTableView reloadData];
}

#pragma mark - 更新界面

- (void)updateUserInterface {

    [_headerView configOnlinePeopleWith:onlineUserArray];
    
    [_headerView configSayHelloAndFansWith:helloFansModel];
    
    CGFloat originalHeight = 60;
    
    if (onlineUserArray.count != 0) {
        originalHeight += 100;
    }
    

    if (helloFansModel.followSize != 0) {
        
        originalHeight += 60;
    }
    
    if (helloFansModel.sayHelloSize != 0) {
        
        originalHeight += 60;

    }
    
    if (helloFansModel.followSize != 0 || helloFansModel.sayHelloSize != 0) {
         originalHeight += 10;
    }
    
    
    
    if (onlineUserArray.count == 0 && helloFansModel.followSize == 0 && helloFansModel.sayHelloSize == 0) {
        originalHeight = 0;
    } else {
        self.emptyConversationView = [UIView new];
    }
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, originalHeight + 10);
    
    self.conversationListTableView.tableHeaderView.frame = _headerView.bounds;
    self.conversationListTableView.tableHeaderView = _headerView;
    
    
}

- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}





- (void)menuClick:(UIButton *)moreBtn{
    
    NSArray *menuItems = @[
                           
                           [KxMenuItem menuItem:@"添加朋友"
                                          image:[UIImage imageNamed:@"add_friend"]
                                         target:self
                                         action:@selector(pushAddFriend:)],
                           
                           [KxMenuItem menuItem:@"我的关注"
                                          image:[UIImage imageNamed:@"my_friend"]
                                         target:self
                                         action:@selector(pushMyFriend:)],
                           
                           [KxMenuItem menuItem:@"我的圈子"
                                          image:[UIImage imageNamed:@"my_circle"]
                                         target:self
                                         action:@selector(pushMyCircle:)],
                           
//                           [KxMenuItem menuItem:@"扫一扫"
//                                          image:[UIImage imageNamed:@""]
//                                         target:self
//                                         action:@selector(pushScan:)]
                           
                           ];
    
    [KxMenu setTintColor:RGB_COLOR_HEX(0x000000)];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:16]];
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:CGRectMake(SCREEN_WIDTH - 110, 46, 100, 0)
                 menuItems:menuItems];
    
    
}

- (void)pushAddFriend:(id)sender {
    MKAddFriendViewController *vc = [[MKAddFriendViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)pushMyFriend:(id)sender {
    MKFollowListViewController *vc = [[MKFollowListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushMyCircle:(id)sender {
    MKMyCirclesViewController *vc = [[MKMyCirclesViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isFromChat = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)pushScan:(id)sender {
    
}

//onSelected TableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    MKConversationViewController *conversationVC = [[MKConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}


/*!
 即将显示Cell的回调
 
 @param cell        即将显示的Cell
 @param indexPath   该Cell对应的会话Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的一些显示属性。
 */
//- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
//                             atIndexPath:(NSIndexPath *)indexPath {
//    for (UIView *view in cell.subviews) {
//        if ([view isKindOfClass:[UIImageView class]]) {
//            UIImageView *imageView  = (UIImageView *)view;
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
//        }
//    }
//}


/*!
 点击Cell头像的回调
 
 @param model   会话Cell的数据模型
 */
- (void)didTapCellPortrait:(RCConversationModel *)model {
    MKConversationViewController *conversationVC = [[MKConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    
    /*
    if (model.conversationType == ConversationType_PRIVATE) {
        NSLog(@"点击用户头像 %@", model.targetId);
        //跳转到用户详细
        MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
        MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:memberInfoVC];
        memberInfoVC.navigationController.navigationBar.hidden = YES;
        memberInfoVC.userId = model.targetId;
        memberInfoVC.isModalPresent = YES;
        nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    } else if (model.conversationType == ConversationType_GROUP) {
        //跳转到圈子信息
        MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
        MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:groupInfoVC];
        groupInfoVC.navigationController.navigationBar.hidden = YES;
        groupInfoVC.hidesBottomBarWhenPushed = YES;
        groupInfoVC.cicleId = model.targetId;
        groupInfoVC.isModalPresent = YES;
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }
     
     */
    
}



// 网络状态变化。
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"RCConnectionStatus = %ld",(long)status);
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [[RCIMClient sharedRCIMClient] disconnect:YES];
        }];
    }
}

#pragma mark - MKChatHeaderViewDelegate

- (void)didClickedSayHelloButton {
    MKPeopleListViewController *vc = [[MKPeopleListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.listType = ListTypeSayHello;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickedNewFansButton {
    MKPeopleListViewController *vc = [[MKPeopleListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.listType = ListTypeNewFans;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didClickedToKeFuButton{
    
    RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
    chatService.hidesBottomBarWhenPushed = YES;
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = RongCloudKeFuServer;
    chatService.title = @"客服";
    
    RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
    //ID
    csInfo.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userId"];
    //nikeName
    csInfo.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
    //头像
    csInfo.portraitUrl = [upLoadImageManager judgeThePathForImages:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userImageStr"]];
    //电话
    csInfo.mobileNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.phone"];
    
    chatService.csInfo = csInfo;
    
    [self.navigationController pushViewController :chatService animated:YES];
}


- (void)didClickedOnlinePeopleWith:(MKOnlineModel *)model {
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)model.coveruserid];
    MKConversationViewController *chat = [[MKConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:userId];
    
    chat.title = model.name;
    chat.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:chat animated:YES];
}

-(void)viewDidLayoutSubviews
{
    if ([self.conversationListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.conversationListTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.conversationListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.conversationListTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



#pragma mark - HTTP - request Chat Home

- (void)requestChatHome {
    
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_chat_home] params:nil success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"聊天首页 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
           
            
            [onlineUserArray removeAllObjects];
            for (NSDictionary *dict in json[@"dataObj"][@"user"]) {
                MKOnlineModel *onlineModel = [MKOnlineModel mj_objectWithKeyValues:dict];
                [onlineUserArray addObject:onlineModel];
            }
            
            helloFansModel = [[MKHelloFansCountModel alloc] init];
            
            helloFansModel.followSize = [json[@"dataObj"][@"followSize"] integerValue];
            helloFansModel.followTime = json[@"dataObj"][@"followTime"];
            helloFansModel.follow = json[@"dataObj"][@"follow"];
            
            helloFansModel.sayHelloSize = [json[@"dataObj"][@"sayHelloSize"] integerValue];
            helloFansModel.sayHelloTime = json[@"dataObj"][@"sayHelloTime"];
            helloFansModel.sayHello = json[@"dataObj"][@"sayHello"];
            [self updateUserInterface];
            
            [strongSelf.conversationListTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}


@end
