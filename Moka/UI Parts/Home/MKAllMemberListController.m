//
//  MKAllMemberListController.m
//  Moka
//
//  Created by btc123 on 2017/11/13.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKAllMemberListController.h"
#import "AllMemberCell.h"
#import "MKCircleMemberModel.h"
#import "MKCircleInfoModel.h"
#import "MKCircleMemberViewController.h"
#import "MKInviteFriendsViewController.h"

@interface MKAllMemberListController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _isMaster;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * holderDataArray;
@end

@implementation MKAllMemberListController
{
    MKCircleMemberModel *adminModel;
    MKCircleInfoModel *memberModel;
    UIActivityIndicatorView *activityIndicator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部成员";
    self.view.backgroundColor = [UIColor cyanColor];
    
    if ([self.isMaster isEqualToString:@"3"]) {
        [self setRightItem];
    }
    [self requestMembersListData];
    [self loadMembersTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -- 数据请求
-(void)requestMembersListData{
    
    NSDictionary *param = @{@"id":self.circleID};
    //    [MKUtilHUD showHUD:self.view];
    [activityIndicator startAnimating];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_circle_members] params:param success:^(id json) {
        STRONG_SELF;
        [activityIndicator stopAnimating];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"获取圈子成员信息 %@",json);
        
        [_holderDataArray removeAllObjects];
        if (status == 200) {
            //群主的消息
            adminModel = [MKCircleMemberModel mj_objectWithKeyValues:json[@"dataObj"][@"holder"]];
            [self.holderDataArray addObject:adminModel];
            //成员
            memberModel = [MKCircleInfoModel mj_objectWithKeyValues:json[@"dataObj"]];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [activityIndicator stopAnimating];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}


-(void)setRightItem{
    
     UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMembersClick)];
    //
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"near_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addMembersClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)addMembersClick{
    
    MKInviteFriendsViewController *vc = [[MKInviteFriendsViewController alloc] init];
    vc.targetCircleId = [NSString stringWithFormat:@"%@", self.circleID];
    vc.targetCircleImage = self.circleImage;
    vc.targetCircleName = self.circleName;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- TableView
-(void)loadMembersTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    //代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //
    _tableView.backgroundColor = RGBCOLOR(233, 233, 235);
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    //分割线
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"AllMemberCell" bundle:nil] forCellReuseIdentifier:@"AllMemberCell"];
}


#pragma mark -- UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"   群主";
    }else{
        return @"   成员";
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }else{
        return 30;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _holderDataArray.count;
    }else{
        return memberModel.memberList.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllMemberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AllMemberCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        //群主
        adminModel = _holderDataArray[indexPath.row];
        cell.memberModel = adminModel;
    }else{
        //成员
        MKCircleMemberModel * model = memberModel.memberList[indexPath.row];
        cell.memberModel = model;
    }
    //
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击进入个人资料
    if (indexPath.section == 0) {//群主
        MKCircleMemberViewController *vc = [[MKCircleMemberViewController alloc] init];
        vc.userId = [NSString stringWithFormat:@"%ld", (long)adminModel.userid];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //成员
        MKCircleMemberModel *model = memberModel.memberList[indexPath.row];
        MKCircleMemberViewController *vc = [[MKCircleMemberViewController alloc] init];
        vc.userId = [NSString stringWithFormat:@"%ld", (long)model.userid];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark -- 懒加载
-(NSMutableArray *)holderDataArray{
    if (!_holderDataArray) {
        _holderDataArray = [NSMutableArray array];
    }
    return _holderDataArray;
}
@end
