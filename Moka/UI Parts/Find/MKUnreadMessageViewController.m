//
//  MKUnreadMessageViewController.m
//  Moka
//
//  Created by  moka on 2017/8/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKUnreadMessageViewController.h"
#import "MKUnreadTableViewCell.h"
#import "MKUnreadMessageModel.h"
#import "MKDynamicDetailViewController.h"

@interface MKUnreadMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MKUnreadMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setMyTableView];
    dataArray = @[].mutableCopy;
    [self requestUnreadMessage];
}


- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 80;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKUnreadTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKUnreadTableViewCell"];
    self.myTableView.tableFooterView = [UIView new];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKUnreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKUnreadTableViewCell" forIndexPath:indexPath];
    [cell configCell:dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MKUnreadMessageModel *model = dataArray[indexPath.row];
    
    MKDynamicDetailViewController *vc = [[MKDynamicDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dynamicId = [NSString stringWithFormat:@"%ld", (long)model.messageid];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - HTTP 未读消息详细

- (void)requestUnreadMessage {
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_unreadDetail] params:nil success:^(id json) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"未读消息详细 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
     
        if (status == 200) {
            for (NSDictionary *dic in json[@"dataObj"]) {
                MKUnreadMessageModel *model = [MKUnreadMessageModel mj_objectWithKeyValues:dic];
                [dataArray addObject:model];
                [strongSelf.myTableView reloadData];
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


@end
