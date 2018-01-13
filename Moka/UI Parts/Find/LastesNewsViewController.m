//
//  LastesNewsViewController.m
//  btc123
//
//  Created by btc123 on 17/1/16.
//  Copyright © 2017年 btc123. All rights reserved.
//

#import "LastesNewsViewController.h"
#import "NewNewsCell.h"
#import "MJRefresh.h"
#import "News.h"

@interface LastesNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
//表格视图
@property (nonatomic,strong) UITableView * tableView;
//新闻数据源
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation LastesNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(245, 247, 255);
    _page = 1;
    
    [self initInformationDatas];
    [self setCustomTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewsCacheData) name:@"LoadNewsCacheData"  object:nil];
    
}

- (void)loadNewsCacheData {
    id json = [JsonDataPersistent readJsonDataWithName:@"NewsDatas"];
    
    [_dataArray removeAllObjects];
    //
    NSArray *datas = json[@"datas"];
    [self.dataArray addObjectsFromArray:datas];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- 数据相关

//获取新闻数据
-(void)initInformationDatas
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = [NSString stringWithFormat:@"%d", _page];
    dic[@"pageSize"] = @"10";
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:APINewsList params:dic success:^(id json) {
       STRONG_SELF;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        
        if ([json[@"isSuc"] boolValue]) {
            
            NSArray *datas = json[@"datas"];
            
            if (_page == 1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:datas];
                
                //保存数据
                [JsonDataPersistent saveJsonData:json withName:@"NewsDatas"];
            }else{
                
                if ([datas count] == 0) {
                    _page --;
                    return;
                }
                
                [self.dataArray addObjectsFromArray:datas];
            }
        }
         [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        DLog(@"%@",error);
    }];
}



#pragma mark -- 自定义表格视图

-(void)setCustomTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-64)];
    [self.view addSubview:_tableView];
    //背景色
    _tableView.backgroundColor = RGBCOLOR(245, 247, 255);
    //代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //取消多余单元格
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"NewNewsCell" bundle:nil] forCellReuseIdentifier:@"NewNewsCell"];
    
    [IBRefsh IBheadAndFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewsData) andFoootTarget:self refreshingFootAction:@selector(loadMoreDatas) and:self.tableView];
}

- (void)loadNewsData {
    
    _page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self initInformationDatas];
    
}

- (void)loadMoreDatas {
    
    //加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++;
        [self initInformationDatas];
    }];
}


#pragma mark -- UITableViewDelegate  && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewNewsCell" forIndexPath:indexPath];
    cell.news = [[News alloc] initWithNSDictionary:self.dataArray[indexPath.row]];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewsDatas:)]) {
        
        [self.delegate didSelectNewsDatas:[[News alloc] initWithNSDictionary:self.dataArray[indexPath.row]]];
    }
}


- (void)scrollToTop {
    
    [self.tableView scrollToTop];
}

#pragma mark -- 懒加载
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
