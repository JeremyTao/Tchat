//
//  MKGroupMemberViewController.m
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGroupMemberViewController.h"
#import "MKGroupMemberCell.h"
#import "MKCircleMemberModel.h"
#import "MKCircleMemberViewController.h"

@interface MKGroupMemberViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)  UITextField *searchTextField;

@end

@implementation MKGroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"圈成员"];
    self.title = @"圈成员";
    [self setMyTableView];
}


- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 80;

    [self.myTableView registerNib:[UINib nibWithNibName:@"MKGroupMemberCell" bundle:nil] forCellReuseIdentifier:@"MKGroupMemberCell"];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    tableHeaderView.backgroundColor = RGB_COLOR_HEX(0xF5F7FF);
    [tableHeaderView addSubview:self.searchTextField];
    //self.myTableView.tableHeaderView = tableHeaderView;
    self.myTableView.tableFooterView = [UIView new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _circleModel.memberList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKGroupMemberCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWith:_circleModel.memberList[indexPath.row]];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MKCircleMemberModel *model = _circleModel.memberList[indexPath.row];
    
    
    MKCircleMemberViewController *vc = [[MKCircleMemberViewController alloc] init];
    vc.userId = [NSString stringWithFormat:@"%ld", (long)model.userid];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_circleModel.ifmember == 3) {
        return YES;
    }
    return NO;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定将该成员移出圈子" preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                            [tableView setEditing:NO animated:YES];
                                        }]];
                                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                            [tableView setEditing:NO animated:YES];
                                            MKCircleMemberModel *model = _circleModel.memberList[indexPath.row];
                                            [self requestDeleteCircleMemberWithUserId:model.userid];
                                            
                                        }]];
                                        
                                        [self presentViewController:alertController animated:YES completion:nil];
                                    }];
    button.backgroundColor =  RGB_COLOR_HEX(0xFF7777);
    return @[button];
}





- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField  = [[UITextField alloc] init];
        _searchTextField.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 30);
        _searchTextField.borderStyle = UITextBorderStyleNone;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.backgroundColor = RGB_COLOR_HEX(0xE9EDFE);
//        _searchTextField.textAlignment = NSTextAlignmentCenter;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
        rightView.contentMode = UIViewContentModeScaleAspectFit;
        rightView.image = [UIImage imageNamed:@"search"];
        _searchTextField.rightView = rightView;
        _searchTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _searchTextField;
}

#pragma mark - HTTP 删除成员
- (void)requestDeleteCircleMemberWithUserId:(NSInteger)userId {
    NSDictionary *param = @{@"circleid":@(_circleModel.id), @"userid":@(userId)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_delete_member] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"删除成员 %@",json);
        if (status == 200) {
            
            NSMutableArray *tempArr = @[].mutableCopy;
            for (MKCircleMemberModel *model in _circleModel.memberList) {
                if (model.userid != userId) {
                    [tempArr addObject:model];
                }
            }
            _circleModel.memberList = tempArr;
            [strongSelf.myTableView reloadData];
            
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

@end
