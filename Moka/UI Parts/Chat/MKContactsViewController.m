//
//  MKContactsViewController.m
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKContactsViewController.h"
#import "MKContactsTableViewCell.h"
#import "PPGetAddressBook.h"
#import <MessageUI/MessageUI.h>

#define START NSDate *startTime = [NSDate date]
#define END NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

@interface MKContactsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKContactsTableViewCellDelegate, MFMessageComposeViewControllerDelegate>

{
    UITextField *searchTextField;
    BOOL   isSearchMode; //是否搜索模式
    PPPersonModel *targetModel;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSDictionary *contactPeopleDict;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, copy) NSMutableArray *searchResults;
@property (nonatomic, strong) MFMessageComposeViewController *messgaVC;

@end

@implementation MKContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"手机通讯录";
    isSearchMode = NO;
    _searchResults = @[].mutableCopy;
    [self getContactsAdressBook];
    [self setupSearchTextField];
    [self setMyTableView];
    
}

- (void)getContactsAdressBook {
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        //装着所有联系人的字典
        self.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        self.keys = nameKeys;
        
        [self.myTableView reloadData];
    } authorizationFailure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }];

    
}



#pragma mark -- 检测已有用户
-(void)checkResgisterUserData{

    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_search_user] params:@{@"query":@""} success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"搜索用户 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}





- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 64;
    [self.myTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    self.myTableView.tintColor = RGB_COLOR_HEX(0x7894F9);
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKContactsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKContactsTableViewCell"];
    
    self.myTableView.tableFooterView = [UIView new];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:searchTextField];
    self.myTableView.tableHeaderView = tableHeaderView;
    
}

#pragma mark - TableViewDatasouce/TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return isSearchMode ? 1 : _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *key = _keys[section];
    return isSearchMode ? _searchResults.count : [_contactPeopleDict[key] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return isSearchMode ? nil : _keys[section];
}

//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return isSearchMode ? nil : _keys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKContactsTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (isSearchMode) {
        [cell configWith:_searchResults[indexPath.row] withIndexpath:indexPath];
    } else {
        NSString *key = _keys[indexPath.section];
        PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
        [cell configWith:people withIndexpath:indexPath];
        
        //NSLog(@"---------%@",people.mobileArray.firstObject);
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PPPersonModel *people;
    if (isSearchMode) {
        people = _searchResults[indexPath.row];
    } else {
        NSString *key = _keys[indexPath.section];
        people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
    }
    
    
    
}
//#pragma mark - HTTP 邀请好友
//- (void)requestInviteFriendWithPhone:(NSString *)phone {
//    [MKUtilHUD showHUD:self.view];
//    WEAK_SELF;
//    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_inviteFriend] params:@{@"phone":phone} success:^(id json) {
//        STRONG_SELF;
//        [MKUtilHUD hiddenHUD:self.view];
//        NSInteger status = [[json objectForKey:@"status"] integerValue];
//        NSString  *message = json[@"exception"];
//        DLog(@"邀请好友 %@",json);
//        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
//        
//        if (status == 200) {
//            
//        } else {
//            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        STRONG_SELF;
//        [MKUtilHUD hiddenHUD:strongSelf.view];
//        DLog(@"%@",error);
//    }];
//}
//

- (void)inviteFriendWithPerson:(PPPersonModel *)model {
//    [self requestInviteFriendWithPhone:phone];
    
    targetModel = model;
    //发短信
    
    //显示发短信的控制器
    
    MFMessageComposeViewController *vc =[[MFMessageComposeViewController alloc] init];
    
    if ([MFMessageComposeViewController canSendText]) {
        // 设置短信内容
        
        vc.body = @"Hi~ 我刚刚通过钛值找到一些附近有趣的人，你要不要试一试，下载app一起加入吧：http://www.t.top";
        
        // 设置收件人列表
        
        vc.recipients = @[targetModel.mobileArray.firstObject ? targetModel.mobileArray.firstObject : @""];
        
        // 设置代理
        
        vc.messageComposeDelegate = self;
        
        // 显示控制器
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMessage)];
        vc.navigationItem.rightBarButtonItem = cancelItem;
        
        _messgaVC = vc;
        
        UINavigationItem *navigationItem = [[[_messgaVC viewControllers] lastObject] navigationItem];
        navigationItem.rightBarButtonItem = cancelItem;
        
        [self presentViewController:_messgaVC animated:YES completion:nil];
    }
    
    
    
   
}

- (void)messageComposeViewController: (MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"已经发出");
        targetModel.invited = 1;
        [self.myTableView reloadData];
    } else {
        NSLog(@"发送失败");
    }
    
}


- (void)cancelMessage {
    [_messgaVC dismissViewControllerAnimated:YES completion:nil];
}


- (void)searchTextChanged:(UITextField *)textField {
    
    if (textField.text.length > 0 ) {
        isSearchMode = YES;
        if (_searchResults.count > 0) {
            [_searchResults removeAllObjects];
        }
        
        for (NSString *key in _keys) {
            for (PPPersonModel *model in _contactPeopleDict[key]) {
                if ([model.name containsString:textField.text] || [model.mobileArray.firstObject containsString:textField.text] ) {
                    [_searchResults addObject:model];
                }
            }
        }
        
    } else {
        isSearchMode = NO;
    }
    
    [self.myTableView reloadData];
    
}


- (void)setupSearchTextField {
    searchTextField = [[UITextField alloc] init];
    searchTextField.delegate = self;
    [searchTextField addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventAllEditingEvents];
    searchTextField.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 30);
    searchTextField.borderStyle = UITextBorderStyleNone;
    searchTextField.layer.cornerRadius = 15;
    searchTextField.backgroundColor = RGB_COLOR_HEX(0xE9EDFE);
    searchTextField.font = [UIFont systemFontOfSize:14];
    searchTextField.placeholder = @"搜索联系人";
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.clearsOnBeginEditing = YES;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftView.image = [UIImage imageNamed:@"search"];
    searchTextField.leftView = leftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
