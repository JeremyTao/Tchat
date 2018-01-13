//
//  TVRewardsBillViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/4.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "TVRewardsBillViewController.h"
#import "TVfeedBackRewardCell.h"
#import "TVfeedBackRewardModel.h"

@interface TVRewardsBillViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
//顶部标签
@property (nonatomic,strong)  UIView *remarkView;
@property (nonatomic,strong)  UILabel *label1;
@property (nonatomic,strong)  UILabel *label2;
@property (nonatomic,strong)  UILabel *label3;
//表格
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation TVRewardsBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _page = 1;
    self.title = @"锁定明细";
    self.view.backgroundColor = RGBCOLOR(245, 247, 255);
    
    
    [self loadRemarkView];
    [self requestDatas];
    [self loadCustomTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //刷新
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


- (void)setRefreshView
{
    //加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page += 1;
        [self requestDatas];
    }];

}

#pragma mark -- 数据请求
-(void)requestDatas{
    NSDictionary * param = @{@"curyyNum":[NSString stringWithFormat:@"%d",_page]};
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_feedBackLockRecords] params:param success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"账单明细 %@",json);
        if (status == 200) {
            NSArray * datas = json[@"dataObj"][@"lockRecords"];
            if (_page == 1)
            {
                [self.dataArray removeAllObjects];
                for (int i=0; i<datas.count; i++)
                {
                    NSDictionary * dic = datas[i];
                    TVfeedBackRewardModel * model = [[TVfeedBackRewardModel alloc]init];
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
                    TVfeedBackRewardModel * model = [[TVfeedBackRewardModel alloc]init];
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


#pragma mark -- 设置标签栏
-(void)loadRemarkView{
    _remarkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self.view addSubview:_remarkView];
    _remarkView.backgroundColor = [UIColor clearColor];
    
    //锁定金额
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 83, CGRectGetHeight(_remarkView.frame))];
    [_remarkView addSubview:_label1];
    //
    _label1.text = @"锁定金额(TV)";
    _label1.adjustsFontSizeToFitWidth = YES;
    _label1.textColor = RGBCOLOR(102, 102, 102);
    _label1.font = [UIFont systemFontOfSize:14];
    _label1.textAlignment = NSTextAlignmentLeft;
    //状态
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 28, CGRectGetHeight(_remarkView.frame))];
    [_remarkView addSubview:_label2];
    //
    _label2.text = @"状态";
    _label2.adjustsFontSizeToFitWidth = YES;
    _label2.textColor = RGBCOLOR(102, 102, 102);
    _label2.font = [UIFont systemFontOfSize:14];
    _label2.textAlignment = NSTextAlignmentRight;
    //累计已发放(TV)
    _label3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-49, 0, 98, CGRectGetHeight(_remarkView.frame))];
    [_remarkView addSubview:_label3];
    //
    _label3.text = @"累计已发放(TV)";
    _label3.adjustsFontSizeToFitWidth = YES;
    _label3.textColor = RGBCOLOR(102, 102, 102);
    _label3.font = [UIFont systemFontOfSize:14];
    _label3.textAlignment = NSTextAlignmentRight;
}

#pragma mark -- 自定义表格
-(void)loadCustomTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_remarkView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-104)];
    
    [self.view addSubview:_tableView];
    //
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    //注册
    [_tableView registerNib:[UINib nibWithNibName:@"TVfeedBackRewardCell" bundle:nil] forCellReuseIdentifier:@"TVfeedBackRewardCell"];
    
}

#pragma mark -- UITabelView && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TVfeedBackRewardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TVfeedBackRewardCell" forIndexPath:indexPath];
    
    TVfeedBackRewardModel * model = _dataArray[indexPath.row];
    cell.model = model;
    //
    //设置
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -- 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
