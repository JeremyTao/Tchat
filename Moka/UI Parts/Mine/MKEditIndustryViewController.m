//
//  MKEditIndustryViewController.m
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditIndustryViewController.h"
#import "MKInterestTagModel.h"
#import "MKTagsTableViewCell.h"

@interface MKEditIndustryViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSString *selectIndustry;
    NSInteger selectID;
    NSMutableArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation MKEditIndustryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"行业"];
    self.title = @"行业";
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"完成" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    [self setRightButtonWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self setupTableView];
    dataArray = @[].mutableCopy;
    selectIndustry = _infoModel.industryName;
    [self requestIndustryTags];
}

- (void)setupTableView {
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.rowHeight = 44;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib:[UINib nibWithNibName:@"MKTagsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKTagsTableViewCell"];
}

#pragma mark - 请求行业标签
- (void)requestIndustryTags {
    NSDictionary *param = @{@"state":@(2)};;
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getTags] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"获取行业标签 %@",json);
        if (status == 200) {
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKInterestTagModel *model = [[MKInterestTagModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [dataArray addObject:model];
            }
            [strongSelf findSeletedTagsReloadTable];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
    }];
}

- (void)findSeletedTagsReloadTable {
    
    for (MKInterestTagModel *tagModel in dataArray) {
        if ([tagModel.name isEqualToString:selectIndustry]) {
            tagModel.selected = 1;
            selectID = tagModel.id;
        }
    }
    
    [self.myTableView reloadData];
}

- (void)confirmButtonClicked {
    
    [self requestUpdateUserIndustry];
}


- (void)requestUpdateUserIndustry {
    NSDictionary *param = @{@"industryid":@(selectID)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_updateUser] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改行业 %@",json);
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            self.infoModel.industryName = selectIndustry;
            [strongSelf performSelector:@selector(delayPopViewController) withObject:nil afterDelay:0];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
    } failure:^(NSError *error) {
        
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTagsTableViewCell" forIndexPath:indexPath];
    MKInterestTagModel *model = dataArray[indexPath.row];
    [cell configSingleSelectCell:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (MKInterestTagModel *model in dataArray) {
        model.selected = 0;
    }
    
    MKInterestTagModel *model = dataArray[indexPath.row];
    selectIndustry = model.name;
    model.selected = 1;
    selectID = model.id;
    [tableView reloadData];
    
}

- (void)delayPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
