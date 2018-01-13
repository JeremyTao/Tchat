//
//  alipayAllBillsViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "alipayAllBillsViewController.h"
#import "alipayChargeBillsCell.h"
#import "AlipayBillsDetailViewController.h"
#import "alipayChargeBillModel.h"

@interface alipayAllBillsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
//
@property (nonatomic,strong) UITableView *tableView;
//
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation alipayAllBillsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _page = 1;
    self.title = @"零钱明细";
    self.view.backgroundColor = RGBCOLOR(245, 247, 255);
    
    [self requestBillsData];
    [self setCustomTableView];
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
        [self requestBillsData];
    }];
    
}

#pragma mark -- 数据请求

-(void)requestBillsData{
    
    NSDictionary * param = @{@"pageNum":[NSString stringWithFormat:@"%d",_page]};
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_alipayBillsDetail] params:param success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"账单明细 %@",json);

        if (status == 200) {
            
            NSArray * datas = json[@"dataObj"][@"datas"];
            if (_page == 1)
            {
                [self.dataArray removeAllObjects];
                
                for (int i=0; i<datas.count; i++)
                {
                    NSDictionary * dic = datas[i];
                    
                    alipayChargeBillModel * model = [alipayChargeBillModel mj_objectWithKeyValues:dic];
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
                    alipayChargeBillModel * model = [alipayChargeBillModel mj_objectWithKeyValues:dic];
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

#pragma mark -- 自定义UITableView
-(void)setCustomTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_tableView];
    //
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    //注册
    [_tableView registerNib:[UINib nibWithNibName:@"alipayChargeBillsCell" bundle:nil] forCellReuseIdentifier:@"alipayChargeBillsCell"];
    
}



#pragma mark -- UITabelViewDelegate && UITabelViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    alipayChargeBillsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"alipayChargeBillsCell" forIndexPath:indexPath];
    
    alipayChargeBillModel * model = _dataArray[indexPath.row];
    cell.model = model;
    //设置
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    alipayChargeBillModel * model = _dataArray[indexPath.row];
    AlipayBillsDetailViewController * vc = [[AlipayBillsDetailViewController alloc]init];
    vc.money = model.totalMoney;
    vc.type = [NSString stringWithFormat:@"%ld",model.type];
    vc.time = model.time;
    vc.status = [NSString stringWithFormat:@"%ld",model.status];
    vc.transID = model.sourceid;
    if (model.repkUserName == nil) {
        vc.remark = model.name;
    }else{
        vc.remark = model.repkUserName;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -- 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
