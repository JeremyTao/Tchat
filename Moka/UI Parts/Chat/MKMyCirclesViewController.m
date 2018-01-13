//
//  MKMyCirclesViewController.m
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKMyCirclesViewController.h"
#import "MKRecomondGroupCell.h"
#import "MKCircleListModel.h"
#import "MKConversationViewController.h"
#import "MKMyCirclesHeadView.h"
#import "MKGroupInfoViewController.h"
#import "MKCreateCircleTableViewCell.h"
#import "MKNoneJoinedCircleTableViewCell.h"
#import "MKGroupTypeViewController.h"

@interface MKMyCirclesViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKNoneJoinedCircleTableViewCellDelegate>

{
    
    NSMutableArray *circlesCreatedByMe;
    NSMutableArray *circlesJoinedByMe;
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation MKMyCirclesViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatNewCreatedCircle"];
    if (show) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ChatNewCreatedCircle"];
        MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
        groupInfoVC.hidesBottomBarWhenPushed = YES;
        groupInfoVC.cicleId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChatNewCircleId"];
        [self.navigationController pushViewController:groupInfoVC animated:YES];
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的圈子";
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"创建" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createdNewCircle) name:@"CreatedNewCircle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedCircle) name:@"DeleteCircle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedCircle) name:@"OutCircle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMyCircles) name:@"RefreshCircle" object:nil];
    
    circlesCreatedByMe = @[].mutableCopy;
    circlesJoinedByMe  = @[].mutableCopy;
    
    [self setMyTableView];
    [self requestMyCircles];
    

    
    
    

}

- (void)menuClick:(UIButton *)sender {
    MKGroupTypeViewController *vc = [[MKGroupTypeViewController alloc] init];
    vc.isFromChat = self.isFromChat;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deletedCircle {
    [self requestMyCircles];
}

- (void)createdNewCircle {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShowNewCreatedCircle"];
    [self requestMyCircles];
    
}

- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 120;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKRecomondGroupCell" bundle:nil] forCellReuseIdentifier:@"MKRecomondGroupCell"];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKCreateCircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKCreateCircleTableViewCell"];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKNoneJoinedCircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKNoneJoinedCircleTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return circlesCreatedByMe.count > 0 ? circlesCreatedByMe.count : 1;
    } else {
        return circlesJoinedByMe.count > 0 ? circlesJoinedByMe.count : 1;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKMyCirclesHeadView *newView = [MKMyCirclesHeadView newCirclesHeadView];
    if (section == 0) {
        newView.titleLabel.text = @"我创建的圈子";
    } else {
        newView.titleLabel.text = @"我加入的圈子";
    }
    return newView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return circlesCreatedByMe.count > 0 ? 120 : 90;
    } else {
        return circlesJoinedByMe.count > 0 ? 120 : 250;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (circlesCreatedByMe.count == 0) {
            MKCreateCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCreateCircleTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            MKRecomondGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKRecomondGroupCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWith:circlesCreatedByMe[indexPath.row]];
            return cell;
        }
        
    } else {
        if (circlesJoinedByMe.count == 0) {
            MKNoneJoinedCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNoneJoinedCircleTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
            return cell;
        } else {
            MKRecomondGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKRecomondGroupCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWith:circlesJoinedByMe[indexPath.row]];
            return cell;
        }
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (circlesCreatedByMe.count == 0) {
            MKGroupTypeViewController *vc = [[MKGroupTypeViewController alloc] init];
            vc.isFromChat = self.isFromChat;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            MKCircleListModel *model = circlesCreatedByMe[indexPath.row];
            MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
            
            groupInfoVC.cicleId = [NSString stringWithFormat:@"%ld", model.id];
            [self.navigationController pushViewController:groupInfoVC animated:YES];
            
        }
        
    } else {
        if (circlesJoinedByMe.count == 0) {
            
        } else {
            MKCircleListModel *model = circlesJoinedByMe[indexPath.row];
            MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
            
            groupInfoVC.cicleId = [NSString stringWithFormat:@"%ld", model.id];
            [self.navigationController pushViewController:groupInfoVC animated:YES];
            
        }
    }
    /*
    if (self.isModalPresent)  {
        if (indexPath.section == 0) {
            if (circlesCreatedByMe.count == 0) {
                MKGroupTypeViewController *vc = [[MKGroupTypeViewController alloc] init];
                vc.isModalPresent = YES;
                MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
                
            } else {
                MKCircleListModel *model = circlesCreatedByMe[indexPath.row];
                MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
                
                groupInfoVC.cicleId = [NSString stringWithFormat:@"%ld", model.id];
                [self.navigationController pushViewController:groupInfoVC animated:YES];
                
            }
           
        } else {
            if (circlesJoinedByMe.count == 0) {
                
            } else {
                MKCircleListModel *model = circlesJoinedByMe[indexPath.row];
                MKGroupInfoViewController *groupInfoVC = [[MKGroupInfoViewController alloc] init];
                
                groupInfoVC.cicleId = [NSString stringWithFormat:@"%ld", model.id];
                [self.navigationController pushViewController:groupInfoVC animated:YES];

            }
        }
        
    } else {
        if (indexPath.section == 0) {
            if (circlesCreatedByMe.count == 0) {
                //创建
                MKGroupTypeViewController *vc = [[MKGroupTypeViewController alloc] init];
                vc.isModalPresent = YES;
                MKNavigationController *nav = [[MKNavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
                
            } else {
                MKCircleListModel *model = circlesCreatedByMe[indexPath.row];
                //跳转圈子聊天
                MKConversationViewController *conversationVC = [[MKConversationViewController alloc]init];
                conversationVC.conversationType = ConversationType_GROUP;
                conversationVC.targetId = [NSString stringWithFormat:@"%ld", (long)model.id];
                conversationVC.title = model.name;
                [self.navigationController pushViewController:conversationVC animated:YES];
            }
            
            
        } else {
            if (circlesJoinedByMe.count == 0) {
               

            } else {
                MKCircleListModel *model = circlesJoinedByMe[indexPath.row];
                //跳转圈子聊天
                MKConversationViewController *conversationVC = [[MKConversationViewController alloc]init];
                conversationVC.conversationType = ConversationType_GROUP;
                conversationVC.targetId = [NSString stringWithFormat:@"%ld", (long)model.id];
                conversationVC.title = model.name;
                [self.navigationController pushViewController:conversationVC animated:YES];
            }
            
            
        }
    }
    */
    
}




#pragma mark - HTTP 请求我的圈子

- (void)requestMyCircles {
    [MKUtilHUD showHUD:self.view];
    [self.activityIndicatorView startAnimating];
    
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_my_circles] params:nil success:^(id json) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilHUD hiddenHUD:self.view];
        
        
        [self.activityIndicatorView stopAnimating];
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"我的圈子 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            [circlesCreatedByMe removeAllObjects];
            [circlesJoinedByMe removeAllObjects];
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKCircleListModel *model = [[MKCircleListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                if (model.ifmember == 0) {
                    [circlesCreatedByMe addObject:model];
                } else if (model.ifmember == 1) {
                    [circlesJoinedByMe addObject:model];
                }
            }
            
            [strongSelf.myTableView reloadData];
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
     
        [self.activityIndicatorView stopAnimating];
        
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
       
        DLog(@"%@",error);
    }];
}

- (void)seeRecomandCirclesButtonClicked {
    self.tabBarController.selectedIndex = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowCircles" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}




@end
