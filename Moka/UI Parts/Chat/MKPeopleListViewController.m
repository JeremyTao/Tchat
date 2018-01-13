//
//  MKPeopleListViewController.m
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKPeopleListViewController.h"
#import "MKPeopleListTableViewCell.h"
#import "MKPeopleListModel.h"
#import "MKConversationViewController.h"

@interface MKPeopleListViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray *dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation MKPeopleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMyTableView];
    
    dataSource = @[].mutableCopy;
    
    if (_listType == ListTypeNewFans) {
        self.title  = @"新的粉丝";
        [self requestNewFansList];
    } else if (_listType == ListTypeSayHello) {
        self.title  = @"打招呼";
        [self requestSayHelloList];
    }
}


- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 64;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKPeopleListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKPeopleListTableViewCell"];
    
    self.myTableView.tableFooterView = [UIView new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKPeopleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKPeopleListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWith:dataSource[indexPath.row]];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MKPeopleListModel *model = dataSource[indexPath.row];
    
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)model.userid];
    
    if (self.listType == ListTypeSayHello) {
        [self requestSelectedSayHelloWithPeopleId:userId];
    } else {
        [self requestSelectedFansWithPeopleId:userId];
    }
    
   
    MKConversationViewController *chat = [[MKConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:userId];
    
    chat.title = model.name;
    chat.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:chat animated:YES];
    
    
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - HTTP 获取打招呼列表

- (void)requestSayHelloList {
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_unreadHello_list] params:nil success:^(id json) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"获取打招呼列表 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            [dataSource removeAllObjects];
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKPeopleListModel *model = [MKPeopleListModel mj_objectWithKeyValues:dict];
                [dataSource addObject:model];
            }
            
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

#pragma mark - HTTP 获取新粉丝列表

- (void)requestNewFansList {
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_unreadFans_list] params:nil success:^(id json) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"获取新粉丝列表 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            [dataSource removeAllObjects];
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKPeopleListModel *model = [MKPeopleListModel mj_objectWithKeyValues:dict];
                model.remark = @"关注了你";
                [dataSource addObject:model];
            }
            
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


#pragma mark - HTTP 已看打招呼
- (void)requestSelectedSayHelloWithPeopleId:(NSString *)userId {
    
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_selSayHello] params:@{@"id":userId} success:^(id json) {
        STRONG_SELF;
       
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"已看打招呼 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            
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

#pragma mark - HTTP 已看粉丝

- (void)requestSelectedFansWithPeopleId:(NSString *)userId {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_selFans] params:@{@"id":userId} success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"已看粉丝 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            
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

@end
