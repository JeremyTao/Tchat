//
//  MKRedPacketDetailViewController.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRedPacketDetailViewController.h"
#import "MKRedPacketInfoCell.h"
#import "MKPeopleGetInfoCell.h"
#import "MKCheckMyRedPacketCell.h"
#import "MKRedPacketIncomeViewController.h"
#import "MKPersonalRedPacketDetailModel.h"
#import "MKPeopleGetMoneyModel.h"
#import "NewGroupDetailModel.h"
#import "GroupGetModel.h"
#import "upLoadImageManager.h"

@interface MKRedPacketDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    MKPersonalRedPacketDetailModel *persnalRPDetailModel;
    MKPeopleGetMoneyModel          *persnalPeopleModel;
    NSString          *redPacketType;
    NewGroupDetailModel *newGroupDetailModel;
    NSInteger           bestLuckIndex;
}

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *redHeadView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redHeadViewHeight;
- (IBAction)redRecordsClicked:(UIButton *)sender;

@end

@implementation MKRedPacketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bestLuckIndex = -1;
    
    [self setMyTableView];
    self.redHeadView.backgroundColor = RGB_COLOR_HEX(0xE6494E);
    _navigationView.backgroundColor = RGB_COLOR_HEX(0xE6494E);
    [self.view bringSubviewToFront:_navigationView];
    
    redPacketType  =  self.redPacketMessage.redPacketType;
    
    if ([redPacketType isEqualToString:@"0"]) {
        //个人红包
        [self requestQueryRedPacketInfoWith:self.redPacketMessage];
    } else {
        //群红包
        [self requestQueryGroupRedPacketInfoWith:self.redPacketMessage];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([redPacketType isEqualToString:@"0"]) {
            [self requestQueryRedPacketInfoWith:self.redPacketMessage];
        } else {
            [self requestQueryGroupRedPacketInfoWith:self.redPacketMessage];
        }
    });
    
}



#pragma mark - HTTP 查询个人红包信息

- (void)requestQueryRedPacketInfoWith:(MKRedPacketMessageContent *)redPacketMessage {
    NSDictionary *paramDitc = @{@"uid" : redPacketMessage.messageId};
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_redPacketDetails] params:paramDitc success:^(id json) {
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        DLog(@"查询个人红包信息 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            newGroupDetailModel = [NewGroupDetailModel mj_objectWithKeyValues:json[@"dataObj"]];
            
            //抢红包的用户
            for (int i = 0; i < newGroupDetailModel.receiveUserList.count; i ++) {
                GroupGetModel *model = newGroupDetailModel.receiveUserList[i];
            
                persnalPeopleModel = [[MKPeopleGetMoneyModel alloc] init];
                persnalPeopleModel.userId = model.id;
                persnalPeopleModel.name = model.name;
                persnalPeopleModel.img = model.portrail;
                persnalPeopleModel.money = newGroupDetailModel.totalMoney;
                persnalPeopleModel.time = [NSString stringWithFormat:@"%ld",(long)model.time];
                persnalPeopleModel.coinType = newGroupDetailModel.cointype;
                persnalPeopleModel.bestLuck = 0;
            }
            
            [strongSelf.myTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
    } failure:^(NSError *error) {
        
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}



#pragma mark -HTTP 根据userID用户基本信息

- (void)requestUserInfoWithUserID:(NSString *)userID completion:(void (^)(RCUserInfo *))completion {
    
    __block RCUserInfo *resultInfo;
    
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_getUserInfoByUserId] params:@{@"id":userID} success:^(id json) {
        
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
            resultInfo = userInfo;
            completion(resultInfo);
            
        } else {
            //[MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"%@",error);
        
    }];
}




#pragma mark - HTTP 查询群红包信息

- (void)requestQueryGroupRedPacketInfoWith:(MKRedPacketMessageContent *)redPacketMessage {
    
    NSDictionary *paramDitc = @{@"uid" : redPacketMessage.messageId};
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_redPacketDetails] params:paramDitc success:^(id json) {
        STRONG_SELF;
       // [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        
        DLog(@"查询群红包信息 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        //NSInteger redPacketStatus = [json[@"dataObj"][@"status"] integerValue];
        //0-未领取 ，1-已领取， 2-已过期  3-已抢完(自己没有抢到)
       
        if (status == 200) {
            newGroupDetailModel = [NewGroupDetailModel mj_objectWithKeyValues:json[@"dataObj"]];
            if ([redPacketMessage.redPacketType isEqualToString:@"2"] && [redPacketMessage.numbersOfRedPacket integerValue] == newGroupDetailModel.receiveUserList.count) {
                //计算手气最佳
                bestLuckIndex = -1;
                float maxMoney = 0;
                for (int i = 0; i < newGroupDetailModel.receiveUserList.count; i ++) {
                    GroupGetModel *model = newGroupDetailModel.receiveUserList[i];
                    
                    if ([model.money floatValue] > maxMoney) {
                        maxMoney = [model.money floatValue];
                        
                        bestLuckIndex = i;
                    }
                }
            }
            
//            NSLog(@"---------------bestLuckIndex : %d", bestLuckIndex);
        
            [strongSelf.myTableView reloadData];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}



- (void)setMyTableView {
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKRedPacketInfoCell" bundle:nil] forCellReuseIdentifier:@"MKRedPacketInfoCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKPeopleGetInfoCell" bundle:nil] forCellReuseIdentifier:@"MKPeopleGetInfoCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKCheckMyRedPacketCell" bundle:nil] forCellReuseIdentifier:@"MKCheckMyRedPacketCell"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        
        if (self.conversationType == ConversationType_PRIVATE) {
            if ([redPacketType isEqualToString:@"0"] && newGroupDetailModel.state == 1) {
                return 1;
            } else {
                return 0;
            }
        } else if (self.conversationType == ConversationType_GROUP) {
            if (![redPacketType isEqualToString:@"0"]) {
                return newGroupDetailModel.receiveUserList.count;
            } else {
                return 0;
            }
        } else {
            return 0;
        }
        
  
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKRedPacketInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKRedPacketInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.conversationType == ConversationType_PRIVATE) {
            [cell configGroupRedWith:newGroupDetailModel];
        }
        if (self.conversationType == ConversationType_GROUP) {
            if (newGroupDetailModel.cointype == 1) {
                [cell RMBConfigGroupRedWith:newGroupDetailModel];
            }else{
                [cell TVConfigGroupRedWith:newGroupDetailModel];
            }
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        MKPeopleGetInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKPeopleGetInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.conversationType == ConversationType_PRIVATE) {
            [cell configCellWith:persnalPeopleModel];
        }
        if (self.conversationType == ConversationType_GROUP) {
            
            if (bestLuckIndex == indexPath.row) {
                
                [cell configGroupRedWith:newGroupDetailModel.receiveUserList[indexPath.row] bestLuck:YES coinType:[NSString stringWithFormat:@"%ld",newGroupDetailModel.cointype]];
            } else {
                
                [cell configGroupRedWith:newGroupDetailModel.receiveUserList[indexPath.row] bestLuck:NO coinType:[NSString stringWithFormat:@"%ld",newGroupDetailModel.cointype]];
            }
            
//            if (bestLuckIndex == indexPath.row) {
//
//                if (newGroupDetailModel.cointype == 1) {
//
//                    [cell RMBConfigGroupRedWith:newGroupDetailModel.receiveUserList[indexPath.row] bestLuck:YES];
//                }else{
//
//                    [cell TVConfigGroupRedWith:newGroupDetailModel.receiveUserList[indexPath.row] bestLuck:YES];
//                }
//            } else {
//
//                if (newGroupDetailModel.cointype == 1) {
//
//                    [cell RMBConfigGroupRedWith:newGroupDetailModel.receiveUserList[indexPath.row] bestLuck:NO];
//                }else{
//
//                    [cell TVConfigGroupRedWith:newGroupDetailModel.receiveUserList[indexPath.row] bestLuck:NO];
//                }
//            }
        }
        return cell;
    } else {
        
        
        MKCheckMyRedPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCheckMyRedPacketCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        MKRedPacketIncomeViewController *vc = [[MKRedPacketIncomeViewController alloc] init];
        vc.coinType = [NSString stringWithFormat:@"%ld",newGroupDetailModel.cointype];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.conversationType == ConversationType_PRIVATE) {
            return 400;
        }else{
            return 429;
        }
    } else if (indexPath.section == 1) {
        return 60;
    } else {
        return 20;
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        _redHeadViewHeight.constant = 180 - scrollView.contentOffset.y;
    } else {
        _redHeadViewHeight.constant = 0;
    }
}


- (IBAction)backButtonEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (IBAction)redRecordsClicked:(UIButton *)sender {
    
    MKRedPacketIncomeViewController *vc = [[MKRedPacketIncomeViewController alloc] init];
    vc.coinType = [NSString stringWithFormat:@"%ld",newGroupDetailModel.cointype];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
