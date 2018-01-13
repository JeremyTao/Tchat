//
//  MKRecomondGroupViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRecomondGroupViewController.h"
#import "MKRecomondGroupCell.h"
#import "MKMyCircleSizeTableViewCell.h"
#import "MKCircleListModel.h"
#import "MKMyCirclesViewController.h"

@interface MKRecomondGroupViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

{
     NSUInteger pageNumber;
    NSUInteger pageSize;
    NSInteger  lastClickIndex;
    NSMutableArray *circleArray;
    NSInteger myCircleSize;
}


@property (strong, nonatomic)  UITextField *searchTextField;
@property (nonatomic, strong) UIButton  *searchCoverButton;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

@end

@implementation MKRecomondGroupViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationView];
    
    if (iPhone5) {
        _tableBottomConstraint.constant = 0;
        
    } else if (iPhone6) {
        
        _tableBottomConstraint.constant = 0;
    } else if (iPhone6plus) {
        
        _tableBottomConstraint.constant = 60;
    }
    
    [self setMyTableView];
    circleArray = @[].mutableCopy;
    pageNumber = 1;
    pageSize = 20;
    [self requestRecomendCircles];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCircle) name:@"RefreshCircle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"CREATED_CIRCLE"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"RefreshCircleHome"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"RefreshHomeData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"DeleteCircle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadHomeCacheData) name:@"LoadHomeCacheData" object:nil];
}

-(void)loadHomeCacheData {
    
    id json = [JsonDataPersistent readJsonDataWithName:@"HomeCircles"];
    [circleArray removeAllObjects];
    NSArray *listAll = json[@"dataObj"][@"listAll"];
    
    for (NSDictionary *dict in listAll) {
        MKCircleListModel *model = [[MKCircleListModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [circleArray addObject:model];
    }
    
    [self.myTableView reloadData];
    
}



- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 120;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKRecomondGroupCell" bundle:nil] forCellReuseIdentifier:@"MKRecomondGroupCell"];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKMyCircleSizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKMyCircleSizeTableViewCell"];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    tableHeaderView.backgroundColor = RGB_COLOR_HEX(0xF5F7FF);
    [tableHeaderView addSubview:self.searchTextField];
    [tableHeaderView addSubview:self.searchCoverButton];
  
    [IBRefsh IBheadAndFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData) andFoootTarget:self refreshingFootAction:@selector(loadMoreData) and:self.myTableView];
    
    [self.searchCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableHeaderView.mas_top).offset(0);
        make.bottom.equalTo(tableHeaderView.mas_bottom).offset(0);
        make.left.equalTo(tableHeaderView.mas_left).offset(0);
        make.right.equalTo(tableHeaderView.mas_right).offset(0);
    }];
    [self.searchCoverButton addTarget:self action:@selector(openSearch) forControlEvents:UIControlEventTouchUpInside];
    
    self.myTableView.tableHeaderView = tableHeaderView;
    
}



- (void)refreshCircle {
    [self loadNewData];
    
}

- (void)loadNewData {
    pageNumber = 1;
    [self.myTableView.mj_footer resetNoMoreData];
    [self requestRecomendCircles];
}

- (void)loadMoreData {
    pageNumber ++;
    [self requestRecomendCircles];
}

#pragma mark- HTTP 请求推荐的圈子
- (void)requestRecomendCircles {
    NSDictionary *param = @{@"pageNum":@(pageNumber), @"pageSize": @(pageSize)};
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_find_circle] params:param success:^(id json) {
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"推荐的圈子 %@",json);
        
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        
        if (status == 200) {
            
            myCircleSize = [json[@"dataObj"][@"myCircleSize"] integerValue];
            NSArray *listAll = json[@"dataObj"][@"listAll"];
            
            
            if (pageNumber == 1 && [listAll count] == 0) {
                //首次加载就无数据
                [circleArray removeAllObjects];
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                [strongSelf.myTableView reloadData];
                return;
            }
            
            if (pageNumber != 1 && [listAll count] == 0) {
                //无更多数据
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            if (pageNumber == 1 && [listAll count] > 0) {
                //下拉刷新
                [circleArray removeAllObjects];
                for (NSDictionary *dict in listAll) {
                    MKCircleListModel *model = [[MKCircleListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [circleArray addObject:model];
                }
                
                [strongSelf.myTableView reloadData];
                //重置上拉刷新
                [strongSelf.myTableView.mj_footer resetNoMoreData];
                
                //保存数据
                [JsonDataPersistent saveJsonData:json withName:@"HomeCircles"];
                
                return;
            }
            
            if (pageNumber != 1 && [listAll count] > 0) {
                //添加更多数据
                for (NSDictionary *dict in listAll) {
                    MKCircleListModel *model = [[MKCircleListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [circleArray addObject:model];
                }
                
                [strongSelf.myTableView reloadData];
                return;
            }

            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:strongSelf.view];
        
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
    }];
}

- (void)openSearch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(startSearchWithQuery:)]) {
        [self.delegate startSearchWithQuery:@""];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return circleArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKMyCircleSizeTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MKMyCircleSizeTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sizeLabel.text = [NSString stringWithFormat:@"%ld", myCircleSize];

        return cell;

    } else {
        MKRecomondGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKRecomondGroupCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWith:circleArray[indexPath.row]];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 72;
    } else {
        return 120;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedMyCircles)]) {
            [self.delegate didClickedMyCircles];
        }
        
    } else {
        lastClickIndex = indexPath.row;
        MKCircleListModel *model = circleArray[indexPath.row];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCircle:)]) {
            [self.delegate didSelectCircle:model];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section !=0 && indexPath.row == circleArray.count - 6) {
        [self loadMoreData];
    }
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField  = [[UITextField alloc] init];
        _searchTextField.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 30);
        _searchTextField.borderStyle = UITextBorderStyleNone;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.backgroundColor = RGB_COLOR_HEX(0xE9EDFE);
        _searchTextField.placeholder = @"搜索ID或名字";
//        _searchTextField.textAlignment = NSTextAlignmentCenter;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 1)];
        _searchTextField.leftView = view;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.font = [UIFont systemFontOfSize:14];
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
        rightView.contentMode = UIViewContentModeScaleAspectFit;
        rightView.image = [UIImage imageNamed:@"search"];
        _searchTextField.rightView = rightView;
        _searchTextField.rightViewMode = UITextFieldViewModeAlways;
//        _searchTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _searchTextField;
}

- (void)scrollToTop {
    [self.myTableView scrollToTop];
}

- (UIButton *)searchCoverButton {
    if (!_searchCoverButton) {
        _searchCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _searchCoverButton;
}

@end
