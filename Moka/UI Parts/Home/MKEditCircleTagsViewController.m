//
//  MKEditCircleTagsViewController.m
//  Moka
//
//  Created by  moka on 2017/8/3.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditCircleTagsViewController.h"
#import "MKTagsTableViewCell.h"
#import "MKInterestTagModel.h"

@interface MKEditCircleTagsViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSMutableArray *dataArray;
    NSString       *selectedLabels;
    NSString       *labelsNameString;
    NSMutableArray *selectedModelsArray;
    NSArray        *origalArray;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation MKEditCircleTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"圈子标签"];
    self.title = @"圈子标签";
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"完成" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.navigationItem.rightBarButtonItem = menuItem;

    //[self setRightButtonWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.rowHeight = 44;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib:[UINib nibWithNibName:@"MKTagsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKTagsTableViewCell"];
    
    dataArray = @[].mutableCopy;
    selectedModelsArray = @[].mutableCopy;
    origalArray = _circleModel.lableList;
    [self requestTags];
}

- (void)requestTags {
    NSDictionary *param = @{@"state":@(6)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getTags] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"获取标签 %@",json);
        if (status == 200) {
            
            for (NSDictionary *dict in json[@"dataObj"]) {
                MKInterestTagModel *model = [[MKInterestTagModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [dataArray addObject:model];;
            }
           [strongSelf findSeletedTagsReloadTable];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        NSHTTPURLResponse *errorResponse = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        [MKUtilAction doApiFailWithToken:errorResponse ctrl:strongSelf with:error];
    }];

}

- (void)findSeletedTagsReloadTable {
    
    for (MKInterestTagModel *selectTagModel in origalArray) {
        for (MKInterestTagModel *tagModel in dataArray) {
            if ([tagModel.name isEqualToString:selectTagModel.name]) {
                tagModel.selected = 1;
            }
        }
    }
    
    [self.myTableView reloadData];
}

- (void)confirmButtonClicked {
    NSMutableArray *tempArray = @[].mutableCopy;
    NSMutableArray *nameArray = @[].mutableCopy;
    for (MKInterestTagModel *model in dataArray) {
        if (model.selected == 1) {
            [tempArray addObject:[NSString stringWithFormat:@"%ld", (long)model.id]];
            [selectedModelsArray addObject:model];
            [nameArray addObject:model.name];
        }
    }
    selectedLabels = [tempArray componentsJoinedByString:@","];
    labelsNameString = [nameArray componentsJoinedByString:@"   "];
    
    [self requestUpdateTags];
}


- (void)requestUpdateTags {
    NSDictionary *param = @{@"lableids":selectedLabels, @"id": @(_circleModel.id)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_update_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改标签 %@",json);
        
        if (status == 200) {
            _circleListModel.lableids = labelsNameString;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircle" object:nil];
            _circleModel.lableList = selectedModelsArray;
            
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
    [cell configCell:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)delayPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
