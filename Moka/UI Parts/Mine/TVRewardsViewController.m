//
//  TVRewardsViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/4.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "TVRewardsViewController.h"
#import "TchatFeedBackViewController.h"
#import "TVRewardsBillViewController.h"
#import "InputTVViewController.h"
#import "feedBackTVRewardsCell.h"
#import "feedBackTVRewardModel.h"


@interface TVRewardsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
//累计奖励
@property (strong, nonatomic) IBOutlet UILabel *totalRewardLabel;
//最新奖励
@property (strong, nonatomic) IBOutlet UILabel *latestRewardLabel;
//提升奖励
@property (strong, nonatomic) IBOutlet UIImageView *addRewardImageView;
@property (strong, nonatomic) IBOutlet UIButton *addRewardBtn;
- (IBAction)addRewardsClicked:(UIButton *)sender;
//锁定的钛值
@property (strong, nonatomic) IBOutlet UILabel *lockTVSumLabel;
//去充值
@property (strong, nonatomic) IBOutlet UIButton *toChargeBtn;
- (IBAction)toChargeClicked:(UIButton *)sender;
//
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation TVRewardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _page = 1;
    self.title = @"钛值奖励";
    
    if ([self.over isEqualToString:@"0"]) {
        self.addRewardImageView.hidden = YES;
        self.addRewardBtn.hidden = YES;
        self.toChargeBtn.hidden = YES;
    }else{
        self.addRewardImageView.hidden = NO;
        self.addRewardBtn.hidden = NO;
        self.toChargeBtn.hidden = NO;
    }
    
    [self requestHeaderDatas];
    [self requestBillDatas];
    [self loadCustomView];
    
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLockClick:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.lockTVSumLabel addGestureRecognizer:tapGesture];
    self.lockTVSumLabel.userInteractionEnabled = YES;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setRefreshView];
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


-(void)tapLockClick:(UITapGestureRecognizer *)tap{
    
    TVRewardsBillViewController * vc = [[TVRewardsBillViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setRefreshView
{
    //加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page += 1;
        [self requestBillDatas];
    }];
    
}

#pragma mark -- 数据请求
//头部数据请求
-(void)requestHeaderDatas{
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_feedBackTVReward] params:nil success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"个人中心 %@",json);
        if (status == 200) {
            
            //累计奖励
            strongSelf.totalRewardLabel.text = [NSString stringWithFormat:@"%.3f",[json[@"dataObj"][@"feedbackSum"] integerValue]/1000.0];
            //最新奖励
            strongSelf.latestRewardLabel.text = [NSString stringWithFormat:@"+%.3f",[json[@"dataObj"][@"newTvFeedback"][@"dayinterest"] integerValue]/1000.0];
            //锁定的钛值
            strongSelf.lockTVSumLabel.text = [NSString stringWithFormat:@"%.3f",[json[@"dataObj"][@"lockSum"] integerValue]/1000.0];
            
            
        }else{
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}

//明细列表
-(void)requestBillDatas{
    NSDictionary *param = @{@"curyyNum":[NSString stringWithFormat:@"%d",_page]};
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_feedBackRewardBills] params:param success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"个人中心 %@",json);
        if (status == 200) {
            NSArray * datas = json[@"dataObj"][@"records"];
            if (_page == 1)
            {
                [self.dataArray removeAllObjects];
                for (int i=0; i<datas.count; i++)
                {
                    NSDictionary * dic = datas[i];
                    feedBackTVRewardModel * model = [[feedBackTVRewardModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            else
            {
                if ([datas count] == 0)
                {
                    [MKUtilHUD showHUD:@"没有账单数据!" inView:nil];
                    _page--;
                    return ;
                }
                for (int i=0; i<datas.count; i++)
                {
                    NSDictionary * dic = datas[i];
                    feedBackTVRewardModel * model = [[feedBackTVRewardModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            
            [self.tableView reloadData];
            
        }else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark -- 基础设置
-(void)loadCustomView{
    //去转入
    self.toChargeBtn.layer.cornerRadius = 4.0f;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 285, SCREEN_WIDTH, SCREEN_HEIGHT-285-64)];
    
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    //注册
    [_tableView registerNib:[UINib nibWithNibName:@"feedBackTVRewardsCell" bundle:nil] forCellReuseIdentifier:@"feedBackTVRewardsCell"];
}



#pragma mark -- UITableViewDelegate  && UITableViewDatsSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    feedBackTVRewardsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"feedBackTVRewardsCell" forIndexPath:indexPath];

    feedBackTVRewardModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    //设置
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];



}


#pragma mark -- 提升奖励

- (IBAction)addRewardsClicked:(UIButton *)sender {
    
    TchatFeedBackViewController * vc = [[TchatFeedBackViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 去转入

- (IBAction)toChargeClicked:(UIButton *)sender {
    
    InputTVViewController * vc = [[InputTVViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
