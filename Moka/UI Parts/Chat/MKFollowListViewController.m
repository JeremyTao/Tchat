//
//  MKFollowListViewController.m
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKFollowListViewController.h"
#import "MKGroupMemberCell.h"
#import "MKShareGroupView.h"
#import "MKConversationViewController.h"
#import "MKCircleMemberViewController.h"

@interface MKFollowListViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKShareGroupViewDelegate>
{
    NSMutableArray *myFollowList;
    NSMutableArray *searchResultList;
    NSArray        *dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)  UITextField *searchTextField;
@property (strong, nonatomic)  MKShareGroupView *popView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@end

@implementation MKFollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的人";
    if (_isShare) {
        self.title = @"分享";
    }
    
    
    myFollowList = @[].mutableCopy;
    searchResultList = @[].mutableCopy;
    [self.searchTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self setMyTableView];
    [self requestFollowList];
    
    
}

- (void)changeTitle:(NSString *)title {
    
    self.title = title;
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
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKGroupMemberCell" bundle:nil] forCellReuseIdentifier:@"MKGroupMemberCell"];
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
    MKGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKGroupMemberCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithPeopleModel:dataSource[indexPath.row]];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MKPeopleModel *model = dataSource[indexPath.row];
    NSString *targetId = [NSString stringWithFormat:@"%ld", model.coveruserid];
    if (self.isShare) {
        
        //分享名片
        _popView = [MKShareGroupView newShareGroupView];
        _popView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_popView];
        _popView.shareLabel.text = @"分享名片";
        MKPeopleModel *shareModel = [[MKPeopleModel alloc] init];
        
        if (_shareUser) {
            shareModel.coveruserid = [_shareUser.userId integerValue];
            shareModel.name = _shareUser.name;
            shareModel.img = _shareUser.portraitUri;
        } else {
            shareModel.coveruserid = model.coveruserid;
            shareModel.name = model.name;
            shareModel.img = model.img;
        }
        
        [_popView configView:shareModel toTargetUser:targetId];
        [_popView show];
        
        
        
    } else {
        
        //聊天
        NSString *userId = [NSString stringWithFormat:@"%ld", (long)model.coveruserid];
        MKConversationViewController *chat = [[MKConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:userId];
        
        chat.title = model.name;
        chat.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:chat animated:YES];

        
    }
    
}
- (void)confirmSharePeople:(MKPeopleModel *)model toUser:(NSString *)targetID {

    //发送名片
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendBusinessCard:toUser:)]) {
        
        [self.delegate sendBusinessCard:model toUser:targetID];
        
        [MKUtilHUD showAutoHiddenTextHUD:@"分享成功" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
        
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
        rightView.contentMode = UIViewContentModeScaleAspectFit;
        rightView.image = [UIImage imageNamed:@"search"];
        _searchTextField.rightView = rightView;
        _searchTextField.rightViewMode = UITextFieldViewModeAlways;
//        _searchTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _searchTextField;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
            
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
            } else {
                _noDataView.hidden = YES;
            }
            
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


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)backClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
