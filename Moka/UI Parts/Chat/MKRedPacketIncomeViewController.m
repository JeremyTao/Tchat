//
//  MKRedPacketIncomeViewController.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRedPacketIncomeViewController.h"
#import "MKTotalInfoCell.h"
#import "MKIncomePeopleCell.h"
#import "MKInOutRedPacketModel.h"
#import "MKPayRedPacketModel.h"

typedef enum : NSUInteger {
    ListTypeIn, //收到
    ListTypeOut,//发出
} RPListType;

@interface MKRedPacketIncomeViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    MKInOutRedPacketModel *redRootModel;    //收到红包
    MKPayRedPacketModel *payRedModel;       //发出的红包
    NSMutableArray    *dataArray;
    NSInteger    pageNumber;
    RPListType   myListType;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *navigaionTitle;

@end

@implementation MKRedPacketIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = @[].mutableCopy;
    pageNumber = 1;
    myListType = ListTypeIn;
    [self setMyTableView];
    self.navigationView.backgroundColor = RGB_COLOR_HEX(0xE6494E);
    [self.view bringSubviewToFront:_navigationView];
    [self requestRedPacketReceived];
}


- (void)setMyTableView {
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKTotalInfoCell" bundle:nil] forCellReuseIdentifier:@"MKTotalInfoCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKIncomePeopleCell" bundle:nil] forCellReuseIdentifier:@"MKIncomePeopleCell"];
   [IBRefsh IBheadAndFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas) andFoootTarget:self refreshingFootAction:@selector(loadMoreDatas) and:self.myTableView];
}

- (void)loadNewDatas {
    
    [self.myTableView.mj_header endRefreshing];
}

- (void)loadMoreDatas {
    pageNumber ++;
    if (myListType == ListTypeIn) {
        [self requestRedPacketReceived];
    } else {
        [self requestRedPacketSended];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return dataArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTotalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTotalInfoCell" forIndexPath:indexPath];
        if (myListType == ListTypeIn) {
            if ([self.coinType isEqualToString:@"1"]) {
                //RMB
                [cell RMBConfigTotalInfoWith:redRootModel];
            }else{
                //TV
                [cell TVConfigTotalInfoWith:redRootModel];
            }
        }else{
            if ([self.coinType isEqualToString:@"1"]) {
                //RMB
                [cell RMBConfigTotalOutInfoWith:payRedModel];
            }else{
                //TV
                [cell TVConfigTotalOutInfoWith:payRedModel];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }  else {
        MKIncomePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKIncomePeopleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (myListType == ListTypeIn) {
            if ([self.coinType isEqualToString:@"1"]) {
                //RMB
                [cell RMBConfigIncomeCell:dataArray[indexPath.row]];
            }else{
                [cell TVConfigIncomeCell:dataArray[indexPath.row]];
            }
            
        } else {
            if ([self.coinType isEqualToString:@"1"]) {
                
                [cell RMBConfigOutcomeCell:dataArray[indexPath.row]];
            }else{
                
                [cell TVConfigOutcomeCell:dataArray[indexPath.row]];
            }
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 320;
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}


- (IBAction)backButtonEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)moreButtonClicked:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"我收到的红包" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        myListType = ListTypeIn;
        pageNumber = 1;
        [self.myTableView.mj_footer resetNoMoreData];
        [dataArray removeAllObjects];
        [self requestRedPacketReceived];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"我发出的红包" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        myListType = ListTypeOut;
        pageNumber = 1;
        [self.myTableView.mj_footer resetNoMoreData];
        [dataArray removeAllObjects];
        [self requestRedPacketSended];
    }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - HTTP 红包详情【收到】

- (void)requestRedPacketReceived {
    
    NSDictionary *paramDitc = @{@"pageNum" : @(pageNumber),
                                @"coinType":self.coinType
                                };
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_redPacketRecieve] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [strongSelf.myTableView.mj_header endRefreshing];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        DLog(@"红包详情【收到】 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            redRootModel = [MKInOutRedPacketModel mj_objectWithKeyValues:json[@"dataObj"]];
            
            if (pageNumber == 1 && [redRootModel.redList count] == 0) {
                //首次加载就无数据
                [dataArray removeAllObjects];
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                [strongSelf.myTableView reloadData];
                return;
            }
            
            if (pageNumber != 1 && [redRootModel.redList count] == 0) {
                //无更多数据
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            if (pageNumber == 1 && [redRootModel.redList count] > 0) {
                //下拉刷新
                [dataArray removeAllObjects];
                [dataArray appendObjects:redRootModel.redList];
                
                [strongSelf.myTableView reloadData];
                //重置上拉刷新
                [strongSelf.myTableView.mj_footer resetNoMoreData];
                return;
            }
            
            if (pageNumber != 1 && [redRootModel.redList count] > 0) {
                //添加更多数据
               [dataArray appendObjects:redRootModel.redList];
                
                [strongSelf.myTableView reloadData];
                return;
            }

            
            [strongSelf.myTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [strongSelf.myTableView.mj_header endRefreshing];

        DLog(@"%@",error);
    }];
}

#pragma mark - HTTP 红包详情【发出】

- (void)requestRedPacketSended {
    
    NSDictionary *paramDitc = @{@"pageNum" : @(pageNumber),
                                @"coinType":[NSString stringWithFormat:@"%@",self.coinType]
                                };
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_redPacketPay] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [strongSelf.myTableView.mj_header endRefreshing];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];

        DLog(@"红包详情【发出】 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];

        if (status == 200) {

            payRedModel = [MKPayRedPacketModel mj_objectWithKeyValues:json[@"dataObj"]];
            
            if (pageNumber == 1 && [payRedModel.redList count] == 0) {
                //首次加载就无数据
                [dataArray removeAllObjects];
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                [strongSelf.myTableView reloadData];
                return;
            }

            if (pageNumber != 1 && [payRedModel.redList count] == 0) {
                //无更多数据
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }

            if (pageNumber == 1 && [payRedModel.redList count] > 0) {
                //下拉刷新
                [dataArray removeAllObjects];
                [dataArray appendObjects:payRedModel.redList];

                [strongSelf.myTableView reloadData];
                //重置上拉刷新
                [strongSelf.myTableView.mj_footer resetNoMoreData];
                return;
            }

            if (pageNumber != 1 && [payRedModel.redList count] > 0) {
                //添加更多数据
                [dataArray appendObjects:payRedModel.redList];

                [strongSelf.myTableView reloadData];
                return;
            }


            [strongSelf.myTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];

        }

    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [strongSelf.myTableView.mj_header endRefreshing];


        DLog(@"%@",error);
    }];
}



@end
