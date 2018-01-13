//
//  MKInviteFriendsViewController.m
//  Moka
//
//  Created by  moka on 2017/8/2.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKInviteFriendsViewController.h"
#import "MKInviteTableViewCell.h"
#import "MKPeopleModel.h"
#import "MKCircleMemberViewController.h"
#import "MKConversationViewController.h"
#import "MKBusinessCardMessage.h"



@interface MKInviteFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKInviteTableViewCellDelegate>

{
    NSMutableArray *myFollowList;
    NSMutableArray *searchResultList;
    NSArray        *dataSource;
}


@property (strong, nonatomic)  UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MKInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"添加成员"];
    self.title = @"添加成员";
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"邀请" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(addPeopelToCircle) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.navigationItem.rightBarButtonItem = menuItem;
    //[self setRightButtonWithTitle:@"邀请" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(addPeopelToCircle) forControlEvents:UIControlEventTouchUpInside];
    myFollowList = @[].mutableCopy;
    searchResultList = @[].mutableCopy;
    [self.searchTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self setMyTableView];
    [self requestFollowList];
}

- (void)addPeopelToCircle {
    BOOL flag = NO;
    
    for (MKPeopleModel  *model in dataSource) {
        if (model.select == 1) {
            //发送邀请
            
            NSString *userId = [NSString stringWithFormat:@"%ld", (long)model.coveruserid];
            MKConversationViewController *chatVC = [[MKConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:userId];
            
            MKBusinessCardMessage *cardMessage = [[MKBusinessCardMessage alloc] init];
            cardMessage.messageId  = self.targetCircleId;
            cardMessage.userName   = self.targetCircleName;
            cardMessage.userPortrait = self.targetCircleImage;
            cardMessage.cardType = @"1";
            RCTextMessage *textMessage = [[RCTextMessage alloc] init];
            textMessage.content = @"Hi~ 我刚刚发现一个有趣的圈子，你要不要试一试，一起加入吧!";
            [chatVC sendMessage:textMessage pushContent:nil];
            [chatVC sendMessage:cardMessage pushContent:nil];
            flag = YES;
        }
    }
    
    if (flag) {
        [MKUtilHUD showAutoHiddenTextHUD:@"已发送邀请" withSecond:2 inView:self.view];
    } else {
        [MKUtilHUD showAutoHiddenTextHUD:@"请选择用户后邀请" withSecond:2 inView:self.view];
    }
    
    
}

- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.length == 0) {
        dataSource = myFollowList;
        [self.myTableView reloadData];
    } else {
        //查询
        [searchResultList removeAllObjects];
        
        for (MKPeopleModel *model in myFollowList) {
            if ([model.name containsString:textField.text]) {
                [searchResultList addObject:model];
            }
        }
        
        dataSource = searchResultList;
        [self.myTableView reloadData];
    }
}




- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 80;

    [self.myTableView registerNib:[UINib nibWithNibName:@"MKInviteTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKInviteTableViewCell"];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    tableHeaderView.backgroundColor = RGB_COLOR_HEX(0xF5F7FF);
    [tableHeaderView addSubview:self.searchTextField];
    self.myTableView.tableHeaderView = tableHeaderView;
    self.myTableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKInviteTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWith:dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField  = [[UITextField alloc] init];
        _searchTextField.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 30);
        _searchTextField.borderStyle = UITextBorderStyleNone;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.backgroundColor = RGB_COLOR_HEX(0xE9EDFE);
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.placeholder = @"输入用户名搜索";
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
        rightView.contentMode = UIViewContentModeScaleAspectFit;
        rightView.image = [UIImage imageNamed:@"search"];
        _searchTextField.rightView = rightView;
        
        _searchTextField.rightViewMode = UITextFieldViewModeAlways;
        
//        _searchTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _searchTextField;
}

- (void)didClickedUserHeadImageWithID:(NSString *)userId {
    MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
    memberInfoVC.hidesBottomBarWhenPushed = YES;
    memberInfoVC.userId = userId;
    [self.navigationController pushViewController:memberInfoVC animated:YES];
    
}



#pragma mark -HTTP 我的关注人列表

- (void)requestFollowList {
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_follow_list] params:@{@"id":[MKChatTool sharedChatTool].currentUserInfo.userId} success:^(id json) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"我的关注人 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKPeopleModel *model = [MKPeopleModel mj_objectWithKeyValues:dict];
                [myFollowList addObject:model];
            }
            dataSource = myFollowList;
            [strongSelf.myTableView reloadData];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


@end
