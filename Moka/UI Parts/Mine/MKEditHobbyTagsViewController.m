//
//  MKEditHobbyTagsViewController.m
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditHobbyTagsViewController.h"
#import "MKTagsTableViewCell.h"
#import "MKInterestTagModel.h"

@interface MKEditHobbyTagsViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSMutableArray *dataArray;
    NSArray        *origalArray;
    NSInteger      tagStatus;
    NSString       *selectedLabels;
    NSMutableArray *selectedModelsArray;
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MKEditHobbyTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"完成" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    //[self setRightButtonWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    if (_myHobby == HobbyTypeNone) {
        self.title = @"标签";
        tagStatus = 1;
        origalArray = _infoModel.mylableList;
    } else if (_myHobby == HobbyTypeMovies) {
        self.title = @"标签";
        tagStatus = 3;
        origalArray = _infoModel.filmList;
    } else if (_myHobby == HobbyTypeFoods) {
    
        self.title = @"美食";
        tagStatus = 5;
        origalArray = _infoModel.foodList;
    } else if (_myHobby == HobbyTypeSports) {
        self.title = @"运动";
        tagStatus = 4;
        origalArray = _infoModel.motionList;
    }
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.rowHeight = 44;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib:[UINib nibWithNibName:@"MKTagsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKTagsTableViewCell"];
    
    dataArray = @[].mutableCopy;
    selectedModelsArray = @[].mutableCopy;
    [self requestTags];
}


- (void)requestTags {
    NSDictionary *param = @{@"state":@(tagStatus)};;
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_getTags] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        NSLog(@"获取标签 %@",json);
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
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
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
    for (MKInterestTagModel *model in dataArray) {
        if (model.selected == 1) {
            [tempArray addObject:[NSString stringWithFormat:@"%ld", (long)model.id]];
            [selectedModelsArray addObject:model];
        }
    }
    selectedLabels = [tempArray componentsJoinedByString:@","];
    
    [self requestUpdateTags];
}


- (void)requestUpdateTags {
    NSDictionary *param = @{@"lableids":selectedLabels, @"state":@(tagStatus)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_changeTags] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改标签 %@",json);
        
        if (status == 200) {
            if (_myHobby == HobbyTypeNone) {
                _infoModel.mylableList = selectedModelsArray;
            } else if (_myHobby == HobbyTypeMovies) {
                _infoModel.filmList = selectedModelsArray;
            } else if (_myHobby == HobbyTypeFoods) {
                _infoModel.foodList = selectedModelsArray;
            } else if (_myHobby == HobbyTypeSports) {
                _infoModel.motionList = selectedModelsArray;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
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
