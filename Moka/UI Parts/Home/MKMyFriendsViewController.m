//
//  MKMyFriendsViewController.m
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKMyFriendsViewController.h"
#import "MKGroupMemberCell.h"
#import "MKShareGroupView.h"
#import "MKPeopleModel.h"
#import "MKCircleMemberViewController.h"

@interface MKMyFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

{
    NSMutableArray *myFollowList;
    NSMutableArray *searchResultList;
    NSArray        *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)  UITextField *searchTextField;
@property (strong, nonatomic)  MKShareGroupView *popView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;


@end

@implementation MKMyFriendsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myFollowList = @[].mutableCopy;
    searchResultList = @[].mutableCopy;
    
    if (!_targetUserId) {
        _targetUserId = [MKChatTool sharedChatTool].currentUserInfo.userId;
    }
    
    [self.searchTextField addTarget:self  action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    if (_showMyFans) {
        
        self.title = @"粉丝列表";
        [self requestFansList];
    } else {
        
        self.title = @"关注列表";
        [self requestFollowList];
    }
    
    [self setMyTableView];
    
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
    NSString  *userId;
    
    if (_showMyFans) {
        userId = [NSString stringWithFormat:@"%ld", (long)model.userid];
        
    } else {
        
        userId = [NSString stringWithFormat:@"%ld", (long)model.coveruserid];
    }
    

    
    if (self.showMemberPage) {
        MKCircleMemberViewController *memberInfoVC = [[MKCircleMemberViewController alloc] init];
        memberInfoVC.hidesBottomBarWhenPushed = YES;
        memberInfoVC.userId = userId;
        [self.navigationController pushViewController:memberInfoVC animated:YES];
    } else {
        _popView = [MKShareGroupView newShareGroupView];
        [[UIApplication sharedApplication].keyWindow addSubview:_popView];
        [_popView show];
    }
    
    
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
        _searchTextField.placeholder = @"搜索列表中的用户";
        _searchTextField.font = [UIFont systemFontOfSize:13];
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
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_follow_list] params:@{@"id":_targetUserId} success:^(id json) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"关注人list %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
                _noDataLabel.text = @"暂时没有关注";
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

#pragma mark - HTTP 粉丝

- (void)requestFansList {
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_myFans_list] params:@{@"id":_targetUserId} success:^(id json) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"粉丝list %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
                _noDataLabel.text = @"暂时没有粉丝";
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

@end
