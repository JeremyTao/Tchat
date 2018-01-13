//
//  RCDCustomerServiceViewController.m
//  RCloudMessage
//
//  Created by litao on 16/2/23.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDCustomerServiceViewController.h"
#import "RCDCSAnnounceView.h"
#import "RCDCSEvaluateModel.h"
@interface RCDCustomerServiceViewController ()<RCDCSAnnounceViewDelegate>
//＊＊＊＊＊＊＊＊＊应用自定义评价界面开始1＊＊＊＊＊＊＊＊＊＊＊＊＊
@property (nonatomic, strong)NSString *commentId;
@property (nonatomic)RCCustomerServiceStatus serviceStatus;
@property (nonatomic)BOOL quitAfterComment;
//＊＊＊＊＊＊＊＊＊应用自定义评价界面结束1＊＊＊＊＊＊＊＊＊＊＊＊＊

@property (nonatomic,copy) NSString *announceClickUrl;

//key为星级；value为RCDCSEvaluateModel对象
@property (nonatomic,strong)NSMutableDictionary *evaStarDic;
@property (nonatomic,strong) RCDCSAnnounceView *announceView;
@end

@implementation RCDCustomerServiceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self notifyUpdateUnreadMessageCount];
  
  self.evaStarDic = [NSMutableDictionary dictionary];

    self.navigationItem.rightBarButtonItem = nil;
  
    
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//客服VC左按键注册的selector是customerServiceLeftCurrentViewController，
//这个函数是基类的函数，他会根据当前服务时间来决定是否弹出评价，根据服务的类型来决定弹出评价类型。
//弹出评价的函数是commentCustomerServiceAndQuit，应用可以根据这个函数内的注释来自定义评价界面。
//等待用户评价结束后调用如下函数离开当前VC。
- (void)leftBarButtonItemPressed:(id)sender {
  //需要调用super的实现
  [super leftBarButtonItemPressed:sender];

  [self.navigationController popToRootViewControllerAnimated:YES];
}

//评价客服，并离开当前会话
//如果您需要自定义客服评价界面，请把本函数注释掉，并打开“应用自定义评价界面开始1/2”到“应用自定义评价界面结束”部分的代码，然后根据您的需求进行修改。
//如果您需要去掉客服评价界面，请把本函数注释掉，并打开下面“应用去掉评价界面开始”到“应用去掉评价界面结束”部分的代码，然后根据您的需求进行修改。
//- (void)commentCustomerServiceWithStatus:(RCCustomerServiceStatus)serviceStatus
//                               commentId:(NSString *)commentId
//                        quitAfterComment:(BOOL)isQuit {
//  [super commentCustomerServiceWithStatus:serviceStatus
//                                commentId:commentId
//                         quitAfterComment:isQuit];
//}

//＊＊＊＊＊＊＊＊＊应用去掉评价界面开始＊＊＊＊＊＊＊＊＊＊＊＊＊
//-
//(void)commentCustomerServiceWithStatus:(RCCustomerServiceStatus)serviceStatus
//commentId:(NSString *)commentId quitAfterComment:(BOOL)isQuit {
//    if (isQuit) {
//        [self leftBarButtonItemPressed:nil];
//    }
//}
//＊＊＊＊＊＊＊＊＊应用去掉评价界面结束＊＊＊＊＊＊＊＊＊＊＊＊＊

//＊＊＊＊＊＊＊＊＊应用自定义评价界面开始2＊＊＊＊＊＊＊＊＊＊＊＊＊
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    //(1)调用evaluateCustomerService将评价结果传给融云sdk。
    if (self.serviceStatus == RCCustomerService_RobotService)
    {//机器人评价结果
        if (buttonIndex == 0) {
            [[RCIMClient sharedRCIMClient]
            evaluateCustomerService:self.targetId knownledgeId:self.commentId
            robotValue:YES suggest:nil];
        } else if (buttonIndex == 1) {
            [[RCIMClient sharedRCIMClient]
            evaluateCustomerService:self.targetId knownledgeId:self.commentId
            robotValue:NO suggest:nil];
        }
    }
    //(2)离开当前客服VC
    if (self.quitAfterComment) {
        [self leftBarButtonItemPressed:nil];
    }
}
//＊＊＊＊＊＊＊＊＊应用自定义评价界面结束2＊＊＊＊＊＊＊＊＊＊＊＊＊

- (void)notifyUpdateUnreadMessageCount {
  __weak typeof(&*self) __weakself = self;
  int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    @(ConversationType_PRIVATE),
    @(ConversationType_DISCUSSION),
    @(ConversationType_APPSERVICE),
    @(ConversationType_PUBLICSERVICE),
    @(ConversationType_GROUP)
  ]];
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *backString = nil;
    if (count > 0 && count < 1000) {
      backString = [NSString stringWithFormat:@"返回(%d)", count];
    } else if (count >= 1000) {
      backString = @"返回(...)";
    } else {
      backString = @"返回";
    }
      
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 87, 23);
    UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
    backImg.frame = CGRectMake(-6, 4, 10, 17);
    [backBtn addSubview:backImg];
    //
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 90, 30)];
    backText.text = backString;
    //
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:[UIColor whiteColor]];
    [backBtn addSubview:backText];
    [backBtn addTarget:__weakself action:@selector(customerServiceLeftCurrentViewController)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [__weakself.navigationItem setLeftBarButtonItem:leftButton];
  });
    
}

//＊＊＊＊＊＊＊＊＊应用自定义客服通告＊＊＊＊＊＊＊＊＊＊＊＊＊

- (void)announceViewWillShow:(NSString *)announceMsg announceClickUrl:(NSString *)announceClickUrl{
  self.announceClickUrl = announceClickUrl;
  
  self.announceView.content.text = announceMsg;
  if (announceClickUrl.length == 0) {
    self.announceView.hiddenArrowIcon = YES;
  }
}

#pragma mark -- RCDCSAnnounceViewDelegate
- (void)didTapViewAction{
  if (self.announceClickUrl.length > 0) {
    [RCKitUtility openURLInSafariViewOrWebView:self.announceClickUrl base:self];
  }
}
//＊＊＊＊＊＊＊＊＊应用自定义客服通告＊＊＊＊＊＊＊＊＊＊＊＊＊

- (RCDCSAnnounceView *)announceView{
  if (!_announceView) {
    CGRect rect = self.conversationMessageCollectionView.frame;
    rect.origin.y += 64;
    rect.size.height -= 64;
    self.conversationMessageCollectionView.frame = rect;
    _announceView = [[RCDCSAnnounceView alloc] initWithFrame:CGRectMake(0,rect.origin.y-64, self.view.frame.size.width,64)];
    _announceView.delegate = self;
    [self.view addSubview:_announceView];
  }
  return _announceView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
