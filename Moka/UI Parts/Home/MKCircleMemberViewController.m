//
//  MKCircleMemberViewController.m
//  Moka
//
//  Created by  moka on 2017/8/3.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKCircleMemberViewController.h"
#import "MKDynamicTableViewCell.h"
#import "MKCircleMemberSectionHeader.h"
#import "MKMemberDetailInfoTableViewCell.h"
#import "MKMemberBasicInfoTableViewCell.h"
#import "MKPeopleRootModel.h"
#import "MKPortraitModel.h"
#import "NYTPhotosViewController.h"
#import "IBShowPhoto.h"
#import "MKDynamicDetailViewController.h"
#import "MKConversationViewController.h"
#import "BubbleTransition.h"
#import "MKEditProfileViewController.h"
#import "MKFollowListViewController.h"
#import "MKBusinessCardMessage.h"
#import "MKConversationViewController.h"
#import "MKGiveMokaCoinView.h"
#import "MKFollowListViewController.h"
#import "MKMyFriendsViewController.h"
#import "MKAddNoteNameViewController.h"
#import "upLoadImageManager.h"

typedef enum : NSUInteger {
    ShowMemberDetailInfoCell,
    ShowDynamicCell
} ShowCellType;

@interface MKCircleMemberViewController ()<UITableViewDataSource, UITableViewDelegate, MKCircleMemberSectionHeaderDelegate, SDCycleScrollViewDelegate, MKDynamicTableViewCellDelegate, UIViewControllerTransitioningDelegate, MKFollowListViewControllerDelegate, MKMemberBasicInfoTableViewCellDelegate, IBShareViewDelegate>

{
    MKPeopleRootModel *userRootModel;
    NSMutableArray    *photoUrlArray;
    NSInteger         pageNum;
    NSMutableArray    *dynamicArray;
    BubbleTransition *transition;
    MKUserInfoRootModel *userInfoRootModel;
    NSMutableDictionary *cellHeightsDictionary;
    NSString            *inputPassword;
    NSString            *payMoney;
    BOOL isInBlackList;
    NSString * userName;
    NSString * userContent;
}

@property (nonatomic, strong) IBShareView *shareView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (assign, nonatomic)  ShowCellType cellType;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic)  MKCircleMemberSectionHeader *headerView;

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *unfollowButton;
@property (weak, nonatomic) IBOutlet UIButton *sayHiButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLine;

@property (strong, nonatomic) NSMutableArray *photosArray;
@property (strong, nonatomic) MKGiveMokaCoinView *giveMokaCoinPopView;


@end

@implementation MKCircleMemberViewController

- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"个人资料"];
    self.title = @"个人资料";
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(0, 0, 30, 30);
    [setButton setImage:IMAGE(@"dynamic_share") forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(shareButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    
    self.navigationItem.rightBarButtonItem = menuItem;
    
    //[self setRightButtonWithTitle:nil titleColor:nil imageName:@"dynamic_share" addTarget:self action:@selector(shareButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self setMyTableView];
    
    transition = [[BubbleTransition alloc] init];
    photoUrlArray= @[].mutableCopy;
    _cellType = ShowMemberDetailInfoCell;
    [MKTool addGrayShadowAboveOnView:_bottomView];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MKCircleMemberSectionHeader" owner:self options:nil];
    _headerView = [nib objectAtIndex:0];
    _headerView.delegate = self;
    pageNum = 1;
    dynamicArray = @[].mutableCopy;
    cellHeightsDictionary = @{}.mutableCopy;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage) name:@"RefreshPage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedRefresh:) name:@"DELETE_DYNAMIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDynamic:) name:@"UPDATE_DYNAMIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHelloSecuccess) name:@"SayHelloSeccess" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage) name:@"REFRESH_PERSON_PAGE" object:nil];
    
    WEAK_SELF;
    self.giveMokaCoinPopView = [MKGiveMokaCoinView newPopViewWithInputBlock:^(NSString *text) {
        STRONG_SELF;
        if (_giveMokaCoinPopView.inputMoneyTextField.text.length == 0) {
            [_giveMokaCoinPopView hide];
            [MKUtilHUD showHUD:@"请输入打赏金额" inView:strongSelf.view];
            return;
        }
        
        inputPassword =  text;
        payMoney = _giveMokaCoinPopView.inputMoneyTextField.text;
        
        [_giveMokaCoinPopView hide];
        
        [strongSelf requestGiveReward];
    }];
    
    
    
    [self checkNetWork];
}


- (void)refreshPage {
    [self requestMemberInfomation];
}

-(void)checkNetWork {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] checkNetWorkStatusSuccess:^(id str) {
        STRONG_SELF;
        if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
            //有网络
            [strongSelf hiddenNonetWork];
            [self requestMemberInfomation];
            [self requestMemberDynamics];
        }else{
            //无网络
            [strongSelf showNonetWork];
            
        }
        
    }];
    
}
- (void)sayHelloSecuccess {
    _sendMessageButton.hidden = NO;
    _sayHiButton.hidden = YES;
}

- (void)deletedRefresh:(NSNotification *)noti {
    NSString *dynamicID  =  noti.userInfo[@"deleteID"];
    
    for (NSInteger i = 0; i < dynamicArray.count; i ++) {
        MKDynamicListModel *model = dynamicArray[i];
        
        if (model.id == [dynamicID integerValue]) {
            
            //删除数据源
            [dynamicArray removeObjectAtIndex:i];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
//            [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.myTableView reloadData];
        }
    }
    
}


- (void)updateDynamic:(NSNotification *)noti {
    MKDynamicListModel *dynamicModel =  noti.userInfo[@"model"];
    //替换数据源
    NSInteger index = 0;
    for (NSInteger i = 0; i < dynamicArray.count; i ++) {
        MKDynamicListModel *model = dynamicArray[i];
        if (model.id == dynamicModel.id) {
            index = i;
        }
    }
    
    dynamicArray[index] = dynamicModel;
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
//    [self.myTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    [self.myTableView reloadData];
   
}


- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.estimatedRowHeight = 500;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKDynamicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKDynamicTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKMemberBasicInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKMemberBasicInfoTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKMemberDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKMemberDetailInfoTableViewCell"];
    [IBRefsh IBheadAndFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData) andFoootTarget:self refreshingFootAction:@selector(loadMoreData) and:self.myTableView];
    
    
}

- (void)loadNewData {
    pageNum = 1;
    [self.myTableView.mj_footer resetNoMoreData];
    [self requestMemberDynamics];
}

- (void)loadMoreData {
    pageNum ++;
    [self requestMemberDynamics];
}



#pragma mark - IBShareViewDelegate

- (void)shareToWeichatMoments {
    NSLog(@"分享朋友圈");
    [_shareView hide];
    
    NSString * contentStr = [NSString stringWithFormat:@"%@在“钛值”的个人名片，快来关注TA吧！",userRootModel.name];
    [IBCommShare shareToWeichatMoments:@"钛值" shareDescription:contentStr shareThumbImg:nil shareUrl:@"www.t.top"];
    
}

- (void)shareToWeichatFriends {
    NSLog(@"分享微信好友");
    [_shareView hide];
    
    NSString * contentStr = [NSString stringWithFormat:@"%@在“钛值”的个人名片，快来关注TA吧！",userRootModel.name];
    [IBCommShare shareToWeichatFriends:@"钛值" shareDescription:contentStr shareThumbImg:nil shareUrl:@"www.t.top"];
}

- (void)taiValueFriends {
    [_shareView hide];
    MKFollowListViewController *shareVC = [[MKFollowListViewController alloc] init];
    shareVC.isShare = YES;
    shareVC.delegate = self;
    MKPortraitModel *protraitModel = (MKPortraitModel *)userRootModel.portrailList.firstObject;
    shareVC.shareUser = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld", (long)userRootModel.id] name:userRootModel.name portrait:protraitModel.img];
    shareVC.title = @"分享";
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)editRemark {
    [_shareView hide];
    MKAddNoteNameViewController *vc = [[MKAddNoteNameViewController alloc] init];
    vc.targetId = [NSString stringWithFormat:@"%ld", (long)userRootModel.id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 清空聊天记录
- (void)clearChat {
    [_shareView hide];
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)userRootModel.id];
    MKConversationViewController *chat = [[MKConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:userId];

    UIAlertController *confirmController = [UIAlertController alertControllerWithTitle:@"清除聊天记录?" message:@"清除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];

    [confirmController addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [[RCIMClient sharedRCIMClient] clearMessages:chat.conversationType targetId:userId];
        [chat.conversationDataRepository removeAllObjects];
        [chat.conversationMessageCollectionView reloadData];
        [MKUtilHUD showHUD:@"清除成功" inView:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearChat" object:nil];
    }]];

    [confirmController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:confirmController animated:YES completion:nil];
}

#pragma mark -- 加入黑名单
- (void)addBlackList:(BOOL)add {
    [_shareView hide];
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)userRootModel.id];
    if (add) {
        [MKUtilHUD showHUD:@"加入黑名单成功" inView:self.view];
        [[RCIMClient sharedRCIMClient] addToBlacklist:userId success:^{

            DLog(@"加入黑名单成功");
            isInBlackList = YES;
        } error:^(RCErrorCode status) { }];
    } else {
        [MKUtilHUD showHUD:@"移出黑名单成功" inView:self.view];
        [[RCIMClient sharedRCIMClient] removeFromBlacklist:userId success:^{
            DLog(@"移出黑名单成功");

            isInBlackList = NO;
        } error:^(RCErrorCode status) { }];
    }

}

#pragma mark -- 投诉
- (void)inform {
    [_shareView hide];
    [self showInformAlertSheetAtIndex:0];
}

// save height
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// give exact height value
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [cellHeightsDictionary objectForKey:indexPath];
    if (height) return height.doubleValue;
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (_cellType == ShowMemberDetailInfoCell) {
            return 1;
        } else if (_cellType == ShowDynamicCell) {
            return dynamicArray.count;
        }
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKMemberBasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKMemberBasicInfoTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell comfigUserBasicInfoWith:userRootModel];
        [cell configCycleScrollViewWithImageUrls:photoUrlArray delegate:self];
        return cell;
    } else {
        if (_cellType == ShowMemberDetailInfoCell) {
            MKMemberDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKMemberDetailInfoTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell comfigUserDetailInfoWith:userRootModel];
            return cell;
        } else if (_cellType == ShowDynamicCell) {
            MKDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKDynamicTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = DynamicCellTypeHome;
            cell.delegate = self;
            cell.cellRowIndex = indexPath.row;
            cell.shadowViewTop.constant = 0;
            [cell configDynamicCell:dynamicArray[indexPath.row] parentViewController:self];
            return cell;
        }
        return nil;
        
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && _cellType == ShowDynamicCell) {
        MKDynamicListModel *model = dynamicArray[indexPath.row];
        MKDynamicDetailViewController *vc = [[MKDynamicDetailViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.dynamicId = [NSString stringWithFormat:@"%ld", (long)model.id];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
                //    [headerView configWith:mainModelArr[section]];
        return  _headerView;
    } else {
        return [UIView new];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    } else {
        return 0;
    }
    
}

//分享给好友
- (void)shareButtonEvent {
    //弹出分享 View
    _shareView = [IBShareView newShareView];
    
    if ([self.userId isEqualToString:[MKChatTool sharedChatTool].currentUserInfo.userId]) {
        [_shareView setShareStyle:ShareViewStyleSelf];
    } else {
        [_shareView setShareStyle:ShareViewStyleOther];
    }
    [_shareView setInBlackList:isInBlackList];
    
    _shareView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView show];
    
}

- (void)sendBusinessCard:(MKPeopleModel *)userModel toUser:(NSString *)targetID; {
    //发送名片消息
    MKBusinessCardMessage *cardMessage = [[MKBusinessCardMessage alloc] init];
    cardMessage.messageId = [NSString stringWithFormat:@"%ld", userModel.coveruserid];
    cardMessage.userName = userModel.name;
    cardMessage.userPortrait = userModel.img;
    cardMessage.userAge = [NSString stringWithFormat:@"%ld", userModel.age];
    cardMessage.cardType = @"0";
    
  
    MKConversationViewController *chatVC = [[MKConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:targetID];
    
    [chatVC sendMessage:cardMessage pushContent:nil];
}


- (void)didClickedUserInfoButton {
    _cellType = ShowMemberDetailInfoCell;
 
    //[self.myTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    [self.myTableView reloadData];
  
 
}

- (void)didClickedDynamicButton {
    _cellType = ShowDynamicCell;

    //[self.myTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    [self.myTableView reloadData];
    
 
  
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.photosArray.count > 0) {
        IBShowPhoto *selectPhoto = self.photosArray[index];
        NYTPhotosViewController *photoVC = [[NYTPhotosViewController alloc] initWithPhotos:self.photosArray initialPhoto:selectPhoto];
        
        [self presentViewController:photoVC animated:YES completion:nil];
        [self updateImagesOnPhotosViewController:photoVC afterDelayWithPhotos:self.photosArray];
        
    }
}

- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //加载图片
        for (int i = 0; i < photos.count; i ++) {
            IBShowPhoto *photo = photos[i];
            //
            NSString *originalImageUrl = [upLoadImageManager judgeThePathForImages:photoUrlArray[i]];
            //NSString *originalImageUrl = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL,photoUrlArray[i]];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            [manager downloadImageWithURL:[NSURL URLWithString:originalImageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    
                    photo.image = image;
                    [photosViewController updateImageForPhoto:photo];
                }else{
                    
                    photo.image = [UIImage imageNamed:@"edit_placeholder"];
                    [photosViewController updateImageForPhoto:photo];
                }
            }];
            
            
        }
        
    });
    
}

//关注
- (IBAction)followButtonClicked:(UIButton *)sender {
    [self requestFollowUser];
}
//取消关注
- (IBAction)unfollowButtonClicked:(UIButton *)sender {
    [self requestUnFollowUser];
}

//打招呼
- (IBAction)sayHiButtonClicked:(UIButton *)sender {
   
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)userRootModel.id];
    MKConversationViewController *chat = [[MKConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:userId];
    
    chat.ifSayHello     = YES;//还没打过招呼，进入去打招呼
    chat.sayHelloUserID = self.userId;
    chat.title = userRootModel.name;

    [self.navigationController pushViewController:chat animated:YES];

}


- (IBAction)sendMessageButtonClicked:(id)sender {
    
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)userRootModel.id];
    MKConversationViewController *chat = [[MKConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:userId];
    
    if (userRootModel.remarksName.length > 0) {
        chat.title = userRootModel.remarksName;
    } else {
        chat.title = userRootModel.name;
    }
    
  
    [self .navigationController pushViewController:chat animated:YES];

    
}

- (IBAction)editProfileButtonClicked:(UIButton *)sender {
    [self rquestUserInfomation];
    
}

#pragma mark - MKMemberBasicInfoTableViewCellDelegate

- (void)openFansController {
    NSLog(@"目标fansID: %ld",  (long)userRootModel.id);
    MKMyFriendsViewController *vc = [[MKMyFriendsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.showMemberPage = YES;
    vc.showMyFans     = YES;
    vc.targetUserId = [NSString stringWithFormat:@"%ld", (long)userRootModel.id];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)openFollowersController {
    NSLog(@"目标关注ID: %ld",  (long)userRootModel.id);
    MKMyFriendsViewController *vc = [[MKMyFriendsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.showMemberPage = YES;
    vc.targetUserId = [NSString stringWithFormat:@"%ld", (long)userRootModel.id];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - MKDynamicTableViewCellDelegate

- (void)giveMokaCoinButtonClickedAtIndex:(NSInteger)index {
    [self.giveMokaCoinPopView showInViewController:self];
    self.giveMokaCoinPopView.cellIndex = index;
}

- (void)likeDynamicButtonClickedAtIndex:(NSInteger)index status:(NSInteger)status {
    [self requestLikeDynamicAtIndex:index like:status];
}
- (void)commentButtonClickedAtIndex:(NSInteger)index {
    MKDynamicListModel *model = dynamicArray[index];
    MKDynamicDetailViewController *vc = [[MKDynamicDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;

    vc.dynamicId = [NSString stringWithFormat:@"%ld", (long)model.id];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)shareContentWithIndex:(NSInteger)index {
    //NSLog(@"分享: %ld", index);
    UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
    //截图
    
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    
    activityViewController.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}


- (void)moreOptionButtonClickedAtIndex:(NSInteger)index {
   
    MKDynamicListModel *model = dynamicArray[index];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self shareContentWithIndex:index];
        
    }]];
    
    if (model.ifdel == 0) {
        //别人的
        [alertController addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self showInformAlertSheetAtIndex:index];
        }]];
        
    } else if (model.ifdel == 1) {
        //自己的
        [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self requestDeleteDynamicAtIndex:index];
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)showInformAlertSheetAtIndex:(NSInteger)index {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"广告或垃圾信息" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"已投诉" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"色情或低俗内容" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"已投诉" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"谩骂" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"已投诉" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"金钱欺诈" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"已投诉" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"激进时政或意识形态话题" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"已投诉" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"其他理由" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"已投诉" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



#pragma mark - HTTP 请求用户数据

- (void)requestMemberInfomation {
    NSDictionary *paramDitc = @{@"id" : self.userId};
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_member_info] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"请求用户数据 %@",json[@"dataObj"]);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            userRootModel = [MKPeopleRootModel mj_objectWithKeyValues:json[@"dataObj"]];
            [photoUrlArray removeAllObjects];
            [self.photosArray removeAllObjects];
            for (MKPortraitModel *model in userRootModel.portrailList) {
                IBShowPhoto *photo = [[IBShowPhoto alloc] init];
                [self.photosArray addObject:photo];
                [photoUrlArray addObject:model.img];
            }
            
            if (userRootModel.ifFollow == 1) {
                _followButton.hidden = YES;
                _unfollowButton.hidden = NO;
            } else {
                _followButton.hidden = NO;
                _unfollowButton.hidden =YES;
            }
            
            if (userRootModel.ifSayHello == 1) {
                _sendMessageButton.hidden = NO;
                _sayHiButton.hidden = YES;
            } else {
                _sendMessageButton.hidden = YES;
                _sayHiButton.hidden = NO;
            }
            
            if ([self.userId isEqualToString:[MKChatTool sharedChatTool].currentUserInfo.userId]) {
                _editProfileButton.hidden = NO;
                _seperatorLine.hidden = YES;
                _followButton.hidden = YES;
                _unfollowButton.hidden = YES;
                _sayHiButton.hidden = YES;
                _sendMessageButton.hidden = YES;
            }
            
            [strongSelf.myTableView reloadData];
            
            //[bizStatus:该用户是否在黑名单中。0表示已经在黑名单中，101表示不在黑名单中]
            [[RCIMClient sharedRCIMClient] getBlacklistStatus:[NSString stringWithFormat:@"%ld", (long)userRootModel.id] success:^(int bizStatus) {
                if (bizStatus == 0) {
                    isInBlackList = YES;
                } else {
                    isInBlackList = NO;
                }
            } error:^(RCErrorCode status) {
                
            }];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}

#pragma mark - HTTP  ➕关注

- (void)requestFollowUser {
    NSDictionary *paramDitc = @{@"coveruserid" : self.userId};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_follow_user] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"➕关注 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            _followButton.hidden = YES;
            _unfollowButton.hidden = NO;
            [MKUtilHUD showAutoHiddenTextHUD:@"关注成功" withSecond:2 inView:strongSelf.view];
            NSDictionary *dict = @{@"userId":self.userId};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowSuccess" object:nil userInfo:dict];
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

#pragma mark - HTTP  取消关注

- (void)requestUnFollowUser {
    NSDictionary *paramDitc = @{@"coveruserid" : self.userId};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_unfollow_user] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"取消关注 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            _followButton.hidden = NO;
            _unfollowButton.hidden =YES;
            [MKUtilHUD showAutoHiddenTextHUD:@"取消关注成功" withSecond:2 inView:strongSelf.view];
            NSDictionary *dict = @{@"userId":self.userId};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnFollowSuccess" object:nil userInfo:dict];
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


#pragma mark - http:请求用户动态

- (void)requestMemberDynamics {
    NSDictionary *paramDitc = @{@"id" : _userId,
                                @"pageNum" : @(pageNum)};
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_member_dynamic] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"请求用户动态 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            if (pageNum == 1 && [json[@"dataObj"] count] == 0) {
                //首次加载就无数据
                [dynamicArray removeAllObjects];
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                [strongSelf.myTableView reloadData];
                return;
            }
            
            if (pageNum != 1 && [json[@"dataObj"] count] == 0) {
                //无更多数据
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            if (pageNum == 1 && [json[@"dataObj"] count] > 0) {
                //下拉刷新
                [dynamicArray removeAllObjects];
                for (NSDictionary *dict in json[@"dataObj"]) {
                    MKDynamicListModel *model = [[MKDynamicListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dynamicArray addObject:model];
                }
                
                [strongSelf.myTableView reloadData];
                //重置上拉刷新
                [strongSelf.myTableView.mj_footer resetNoMoreData];
                return;
            }
            
            if (pageNum != 1 && [json[@"dataObj"] count] > 0) {
                //添加更多数据
                for (NSDictionary *dict in json[@"dataObj"]) {
                    MKDynamicListModel *model = [[MKDynamicListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dynamicArray addObject:model];
                }
                
                [strongSelf.myTableView reloadData];
                return;
            }
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        
        DLog(@"%@",error);
    }];
}

#pragma mark - http:点赞和取消点赞

- (void)requestLikeDynamicAtIndex:(NSInteger)index like:(NSInteger)like {
    MKDynamicListModel *dynamicModel = dynamicArray[index];
    
    NSString *url;
    if (like == 1) {
        //点赞
        url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_like_dynamic];
    } else {
        //取消点赞
        url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_dislike_dynamic];
    }
    
    NSDictionary *paramDitc = @{@"messageid" : @(dynamicModel.id)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:url params:paramDitc success:^(id json) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"点赞和取消点赞 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            if (like == 1) {
                //点赞成功
                dynamicModel.ifThing = 1;
                dynamicModel.thingnum += 1;
                [strongSelf.myTableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicModel}];
            } else {
                //取消点赞
                dynamicModel.ifThing = 0;
                dynamicModel.thingnum -= 1;
                [strongSelf.myTableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicModel}];
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


#pragma mark  - HTTP 删除动态

- (void)requestDeleteDynamicAtIndex:(NSInteger)index {
    MKDynamicListModel *model = dynamicArray[index];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_delete_dynamic];
    
    NSDictionary *paramDitc = @{@"id" : [NSString stringWithFormat:@"%ld", (long)model.id]};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:url params:paramDitc success:^(id json) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"删除动态 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            //删除数据源
            [dynamicArray removeObjectAtIndex:index];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
//            [strongSelf.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [strongSelf.myTableView reloadData];
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


#pragma mark - HTTP 举报动态

- (void)requestInformDynamicWithRemark:(NSString *)remark atIndex:(NSInteger)index{
    MKDynamicListModel *dynamicModel = dynamicArray[index];
    NSDictionary *param = @{@"otherid":@(dynamicModel.id), @"remark":remark};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_inform_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"举报动态 %@",json);
        if (status == 200) {
            [MKUtilHUD showHUD:@"举报成功" inView:strongSelf.view];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}


- (void)rquestUserInfomation {
    NSDictionary *param = nil;
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getUserInfo] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"个人中心 %@",json);
        if (status == 200) {
            userInfoRootModel = [MKUserInfoRootModel mj_objectWithKeyValues:json[@"dataObj"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:userInfoRootModel.phone forKey:@"CurrentUserPhone"];
            
            MKEditProfileViewController *vc = [[MKEditProfileViewController alloc] init];
            vc.infoModel = userInfoRootModel;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}


#pragma mark - http 请求打赏

- (void)requestGiveReward {
    
    NSString *encriptPasswd = [MKTool md5_passwordEncryption:inputPassword];
    MKDynamicListModel *dynamicModel = dynamicArray[_giveMokaCoinPopView.cellIndex];
    NSDictionary *param = @{@"password":encriptPasswd, @"messageid":@(dynamicModel.id), @"money":payMoney};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_giveReward] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"请求打赏 %@",json);
        if (status == 200) {
            [MKUtilHUD showHUD:@"打赏成功" inView:strongSelf.view];
            dynamicModel.rewardNum += 1;
//            [strongSelf.myTableView reloadRow:_giveMokaCoinPopView.cellIndex inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            [strongSelf.myTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicModel}];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}




- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    transition.transitionMode = BubbleTransitionModePresent;
    transition.startingPoint = CGPointMake(SCREEN_WIDTH * 3 / 4, SCREEN_HEIGHT - 25);
    transition.bubbleColor = [UIColor clearColor];
    return transition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    transition.transitionMode = BubbleTransitionModeDismiss;
    transition.startingPoint = CGPointMake(SCREEN_WIDTH  * 3/ 4, SCREEN_HEIGHT - 25);
    transition.bubbleColor = commonBlueColor;
    return transition;
}


@end
