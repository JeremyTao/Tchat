//
//  MKTradingRecordViewController.m
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKTradingRecordViewController.h"
#import "MKTradingTableViewCell.h"
#import "MKMyAllRedPacketModel.h"
#import "MKMyWithdrawModel.h"
#import "MKRechargeModel.h"
#import "MKMyICOModel.h"
#import "MKMyAllGiftModel.h"
#import "MKMyAllRewardModel.h"
#import "MKCircleJoinModel.h"


#define TopMagin 48

typedef enum : NSUInteger {
    QueryTypeAll,
    QueryTypeCharge,
    QueryTypeWithdraw,
    QueryTypeAllRedPacket,
    QueryTypeCircle,
    QueryTypeGift
} QueryType;

@interface MKTradingRecordViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray *dataSource;
    NSMutableArray *redPacketArray;
    NSMutableArray *rechargeArray;
    NSMutableArray *withdrawArray;
    NSMutableArray *circleJoinArray;
    NSMutableArray *giftArray;
    QueryType myQueryType;
    CGFloat  indicatorWidth;
    CGFloat  indicatorHeight;
}

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) UIView *indicatorView;

@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIView *noDataView;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsArray;

@end

@implementation MKTradingRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setNavigationTitle:@"我的账单"];
    self.title = @"我的账单";
    [self setMyTableView];
    dataSource      = @[].mutableCopy;
    redPacketArray  = @[].mutableCopy;
    rechargeArray   = @[].mutableCopy;
    withdrawArray   = @[].mutableCopy;
    circleJoinArray        = @[].mutableCopy;
    giftArray       = @[].mutableCopy;
    
    indicatorWidth = 40;
    indicatorHeight = 2;
    
    [self.topView addSubview:self.indicatorView];
    [self requestAllBills];
}


- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 80;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKTradingTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKTradingTableViewCell"];
    self.myTableView.tableFooterView = [UIView new];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (myQueryType) {
        case QueryTypeAll:
            return dataSource.count;
            break;
        case QueryTypeCharge:
            return rechargeArray.count;
            break;
        case QueryTypeWithdraw:
            return withdrawArray.count;
            break;
        case QueryTypeAllRedPacket:
            return redPacketArray.count;
            break;
        case QueryTypeCircle:
            return circleJoinArray.count;
            break;
        case QueryTypeGift:
            return giftArray.count;
            break;
            
        default:
            break;
            
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTradingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTradingTableViewCell" forIndexPath:indexPath];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (myQueryType) {
        case QueryTypeAll: {
            
            id model = dataSource[indexPath.row];
            
            if ([model isMemberOfClass:[MKRechargeModel class]]) {
                
                MKRechargeModel *cModel = (MKRechargeModel *)model;
                [cell configRechargeCellWith:cModel];
                
            } else if ([model isMemberOfClass:[MKMyWithdrawModel class]]) {
                
                MKMyWithdrawModel *cModel = (MKMyWithdrawModel *)model;
                [cell configWithdrawCellWith:cModel];
                
            } else if ([model isMemberOfClass:[MKMyAllRedPacketModel class]]) {
                
                MKMyAllRedPacketModel *cModel = (MKMyAllRedPacketModel *)model;
                [cell configRedPacketCellWith:cModel];
                
            } else if ([model isMemberOfClass:[MKMyICOModel class]]) {
                
                MKMyICOModel *cModel = (MKMyICOModel *)model;
                [cell configICOCellWith:cModel];
            } else if ([model isMemberOfClass:[MKMyAllGiftModel class]]) {
                
                MKMyAllGiftModel *cModel = (MKMyAllGiftModel *)model;
                [cell configGiftCellWith:cModel];
                
            } else if ([model isMemberOfClass:[MKMyAllRewardModel class]]) {
                
                MKMyAllRewardModel *cModel = (MKMyAllRewardModel *)model;
                [cell configMyAllRewardModelCellWith:cModel];
                
            } else if ([model isMemberOfClass:[MKCircleJoinModel class]]) {
                MKCircleJoinModel *cModel = (MKCircleJoinModel *)model;
                [cell configCircleJoinCellWith:cModel];
            }
            
        }
            
            break;
        case QueryTypeCharge:
            [cell configRechargeCellWith:rechargeArray[indexPath.row]];
            break;
        case QueryTypeWithdraw:
            [cell configWithdrawCellWith:withdrawArray[indexPath.row]];
            break;
        case QueryTypeAllRedPacket:
            [cell  configRedPacketCellWith:redPacketArray[indexPath.row]];
            break;
        case QueryTypeCircle:
            [cell configCircleJoinCellWith:circleJoinArray[indexPath.row]];
            break;
        case QueryTypeGift:
            [cell configGiftCellWith:giftArray[indexPath.row]];
            break;
            
        default:
            break;
    }

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (myQueryType) {
        case QueryTypeAll: {
            
            id model = dataSource[indexPath.row];
            if ([model isMemberOfClass:[MKRechargeModel class]]) {
                MKRechargeModel * model = dataSource[indexPath.row];
                
                [self copyTxid:model.txid];
                //NSLog(@"--1--------------%@",model.txid);
                
            }else if ([model isMemberOfClass:[MKMyWithdrawModel class]]){
                MKMyWithdrawModel * model = dataSource[indexPath.row];
                //
                [self copyTxid:model.txid];
                //NSLog(@"--2--------------%@",model.txid);
            }else{
                return;
            }
        }
            break;
        case QueryTypeCharge:
        {
            MKRechargeModel * model = rechargeArray[indexPath.row];
            //
            [self copyTxid:model.txid];
            //NSLog(@"--3--------------%@",model.txid);
        }
            break;
        case QueryTypeWithdraw:
        {
            MKMyWithdrawModel * model = dataSource[indexPath.row];
            //
            [self copyTxid:model.txid];
            //NSLog(@"--4--------------%@",model.txid);
        }
            break;
        case QueryTypeAllRedPacket:
        {
//            MKMyAllRedPacketModel * model = redPacketArray[indexPath.row];
//
//            NSLog(@"--5--------------%@",model.txid);
            return;
        }
            break;
        case QueryTypeCircle:
        {
            return;
        }
            break;
        case QueryTypeGift:
        {
//            MKMyAllGiftModel * model = giftArray[indexPath.row];
//
//            NSLog(@"--6--------------%@",model.txid);
            return;
        }
        default:
            break;
    }
}

-(void)copyTxid:(NSString *)tx{
    if ([tx isEqualToString:@""] || tx == NULL) {
        return;
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = tx;
        [MKUtilHUD showHUD:@"交易id已复制到你的粘贴板" inView:nil];
    }
}



- (IBAction)filterButtonClicked:(UIButton *)sender {
    
    for (UIButton *btn in self.buttonsArray) {
        [btn setTitleColor:RGB_COLOR_HEX(0x666666) forState:UIControlStateNormal];
    }
    
    [sender setTitleColor:commonBlueColor forState:UIControlStateNormal];
    
    
    myQueryType = sender.tag - 1000;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorView.frame = CGRectMake(sender.origin.x, TopMagin, indicatorWidth, indicatorHeight);
        self.indicatorView.centerX = sender.centerX;
    }];
    
    switch (myQueryType) {
        case QueryTypeAll:
            [self requestAllBills];
            break;
        case QueryTypeCharge:
            [self requestRechargeList];
            break;
        case QueryTypeWithdraw:
            [self requestWithdrawList];
            break;
        case QueryTypeAllRedPacket:
            [self requestAllRedPacket];
            break;
        case QueryTypeCircle:
            [self requestCircleJoinList];
            break;
        case QueryTypeGift:
            [self requestGiftList];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - http 查询全部账单

- (void)requestAllBills {
    NSDictionary *param = @{};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getAllBills] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [dataSource removeAllObjects];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        DLog(@"查询全部账单 %@",json);
        
        if (status == 200) {
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
            } else {
                _noDataView.hidden = YES;
            }
            
            //type : 1=发红包， 2=礼物， 3=ICO， 4=充值／提现 (state = 0充值，state = 1 提现),5 打赏  6.圈子
            for (NSDictionary *dict in json[@"dataObj"]) {
                NSInteger type = [dict[@"type"] integerValue];
                if (type == 1) {
                    MKMyAllRedPacketModel *model  = [[MKMyAllRedPacketModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource addObject:model];
                } else if (type == 2) {
                    MKMyAllGiftModel *model  = [[MKMyAllGiftModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource addObject:model];
                } else if (type == 3) {
                    MKMyICOModel *model  = [[MKMyICOModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource addObject:model];
                } else if (type == 4) {
                    NSInteger state = [dict[@"state"] integerValue];
                    if (state == 0) {
                        //充值
                        MKRechargeModel *model  = [[MKRechargeModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [dataSource addObject:model];
                    } else if (state == 1) {
                        //提现
                        MKMyWithdrawModel *model  = [[MKMyWithdrawModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [dataSource addObject:model];
                        
                    }
                    
                } else if (type == 5) {
                    MKMyAllRewardModel *model = [[MKMyAllRewardModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource addObject:model];
                } else if (type == 6) {
                    MKCircleJoinModel *model = [[MKCircleJoinModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource addObject:model];
                }
            }
            
            
            [self.myTableView reloadData];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}


#pragma mark - http 查询所有红包

- (void)requestAllRedPacket {
    NSDictionary *param = @{};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myAllRedPacket] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [redPacketArray removeAllObjects];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        DLog(@"查询所有红包 %@",json);
        if (status == 200) {
            
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
            } else {
                _noDataView.hidden = YES;
            }
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKMyAllRedPacketModel *model  = [[MKMyAllRedPacketModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [redPacketArray addObject:model];
            }
        
            [self.myTableView reloadData];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - http 查询所有充值
- (void)requestRechargeList {
    NSDictionary *param = @{@"state":@(0)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myAllTransaction] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [rechargeArray removeAllObjects];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        DLog(@"查询所有充值 %@",json);
        if (status == 200) {
            
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
            } else {
                _noDataView.hidden = YES;
            }
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKRechargeModel *model  = [[MKRechargeModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [rechargeArray addObject:model];
            }
            
            [self.myTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}


#pragma mark - http 查询所有提现

- (void)requestWithdrawList {
    NSDictionary *param = @{@"state":@(1)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myAllTransaction] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [withdrawArray removeAllObjects];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        DLog(@"查询所有提现 %@",json);
        if (status == 200) {
            
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
            } else {
                _noDataView.hidden = YES;
            }
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKMyWithdrawModel *model  = [[MKMyWithdrawModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [withdrawArray addObject:model];
            }
            
            [self.myTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - http 查询所有礼物

- (void)requestGiftList {
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myAllGift] params:nil success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [giftArray removeAllObjects];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        DLog(@"查询所有礼物 %@",json);
        if (status == 200) {
            
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
            } else {
                _noDataView.hidden = YES;
            }
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKMyAllGiftModel *model  = [[MKMyAllGiftModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [giftArray addObject:model];
            }
            
            [self.myTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}


#pragma mark - http 查询所有付费圈子加入信息

- (void)requestCircleJoinList {
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myAllIco] params:nil success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [circleJoinArray removeAllObjects];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        DLog(@"查询所有ICO %@",json);
        if (status == 200) {
            
            if ([json[@"dataObj"] count] == 0) {
                _noDataView.hidden = NO;
            } else {
                _noDataView.hidden = YES;
            }
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKMyICOModel *model  = [[MKMyICOModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [circleJoinArray addObject:model];
            }
            
            [self.myTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}


- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = commonBlueColor;
        
        _indicatorView.frame = CGRectMake(_allButton.origin.x, TopMagin, indicatorWidth, indicatorHeight);
        _indicatorView.centerX = _allButton.centerX;
    }
    return _indicatorView;
}

@end
