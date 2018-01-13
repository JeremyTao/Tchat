//
//  MKHotViewController.m
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKHotViewController.h"
#import "MKDynamicTableViewCell.h"
#import "MKGiveMokaCoinView.h"
#import "MKDynamicListModel.h"
#import "MKDynamicListModel.h"

@interface MKHotViewController ()<UITableViewDataSource, UITableViewDelegate, MKDynamicTableViewCellDelegate, IBShareViewDelegate>
{
    NSInteger pageNum;
    NSMutableArray *dynamicArray;
    NSMutableDictionary *cellHeightsDictionary;
    NSString  *inputPassword;
    NSString  *payMoney;
    NSString * userName;
    NSString * userContent;
}

@property (nonatomic, strong) IBShareView *shareView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKGiveMokaCoinView *giveMokaCoinPopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;


@end

@implementation MKHotViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationView];
    [self setMyTableView];
    if (iPhone5) {
        _tableBottomConstraint.constant = 0;
        
    } else if (iPhone6) {
        
        _tableBottomConstraint.constant = 0;
    } else if (iPhone6plus) {
        
        _tableBottomConstraint.constant = 60;
    }
    WEAK_SELF;
    self.giveMokaCoinPopView = [MKGiveMokaCoinView newPopViewWithInputBlock:^(NSString *text) {
        STRONG_SELF;
        if (_giveMokaCoinPopView.inputMoneyTextField.text.length == 0) {
            
            [_giveMokaCoinPopView hide];
            [MKUtilHUD showHUD:@"请输入打赏金额" inView:strongSelf.view];
            return;
        }
        
        inputPassword =  text;
        payMoney = _giveMokaCoinPopView.inputMoneyTextField.text;
        
        [_giveMokaCoinPopView hide];
        
        [strongSelf requestGiveReward];
    }];
    pageNum = 1;
    dynamicArray = @[].mutableCopy;
    cellHeightsDictionary = @{}.mutableCopy;
    [self requestHotDynamics];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedRefresh:) name:@"DELETE_DYNAMIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"SUBMMITED_DYNAMIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDynamic:) name:@"UPDATE_DYNAMIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"RefreshDynamicData"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDynamicCacheData) name:@"LoadDynamicCacheData"  object:nil];
}


- (void)loadDynamicCacheData {
    id json = [JsonDataPersistent readJsonDataWithName:@"HotDynamicData"];
    
    [dynamicArray removeAllObjects];
    for (NSDictionary *dict in json[@"dataObj"]) {
        MKDynamicListModel *model = [[MKDynamicListModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [dynamicArray addObject:model];
    }
    
    [self.myTableView reloadData];
    
    
}

- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.estimatedRowHeight = 500;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKDynamicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKDynamicTableViewCell"];
    
    [IBRefsh IBheadAndFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData) andFoootTarget:self refreshingFootAction:@selector(loadMoreData) and:self.myTableView];
    
}

- (void)loadNewData {
    pageNum = 1;
    [self.myTableView.mj_footer resetNoMoreData];
    [self requestHotDynamics];
}

- (void)loadMoreData {
    pageNum ++;
    [self requestHotDynamics];
}

- (void)deletedRefresh:(NSNotification *)noti {
    NSString *dynamicID  =  noti.userInfo[@"deleteID"];
    
    for (NSInteger i = 0; i < dynamicArray.count; i ++) {
        MKDynamicListModel *model = dynamicArray[i];
        
        if (model.id == [dynamicID integerValue]) {
            
            //删除数据源
            [dynamicArray removeObjectAtIndex:i];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.myTableView reloadData];
        }
    }
    
    
}

- (void)updateDynamic:(NSNotification *)noti {
    MKDynamicListModel *dynamicModel =  noti.userInfo[@"model"];
    //替换数据源
    NSInteger index = -1;
    for (NSInteger i = 0; i < dynamicArray.count; i ++) {
        MKDynamicListModel *model = dynamicArray[i];
        if (model.id == dynamicModel.id) {
            index = i;
        }
    }
    if (index == -1) {
        return;
    }
    
    dynamicArray[index] = dynamicModel;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    [self.myTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    
    
//    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.myTableView reloadData];
}



#pragma mark - IBShareViewDelegate

- (void)shareToWeichatMoments {
    NSLog(@"分享朋友圈");
    [_shareView hide];
    
    NSString * contentStr = [NSString stringWithFormat:@"%@在‘钛值’发表了一条新动态：%@",userName,userContent];
    [IBCommShare shareToWeichatMoments:@"钛值" shareDescription:contentStr shareThumbImg:nil shareUrl:@"www.t.top"];
    
}

- (void)shareToWeichatFriends {
    NSLog(@"分享微信好友");
    [_shareView hide];
    
    NSString * contentStr = [NSString stringWithFormat:@"%@在‘钛值’发表了一条新动态：%@",userName,userContent];
    [IBCommShare shareToWeichatFriends:@"钛值" shareDescription:contentStr shareThumbImg:nil shareUrl:@"www.t.top"];
}


- (void)inform {
    [_shareView hide];
    [self showInformAlertSheetAtIndex:0];
}

- (void)deleteDynamic {
    [_shareView hide];
    [self requestDeleteDynamicAtIndex:_shareView.index];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dynamicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKDynamicTableViewCell" forIndexPath:indexPath];
    cell.cellRowIndex = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = DynamicCellTypeHome;
    cell.delegate = self;
    [cell configDynamicCell:dynamicArray[indexPath.row] parentViewController:self];
    //
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCopyClick:)];
    longPressGesture.minimumPressDuration = 1.0; //seconds
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}
//长按复制
- (void)longPressCopyClick:(UILongPressGestureRecognizer *)longPressGesture {
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPressGesture locationInView:self.myTableView];
        NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:point];
        MKDynamicListModel *model = dynamicArray[indexPath.row];
        
        //NSLog(@"-------------------%@--------------------",model.text);
        //粘贴
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.text;
        [MKUtilHUD showHUD:@"复制成功" inView:nil];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MKDynamicListModel *model = dynamicArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectHotDynamicAtIndex:withDynamicID:isShowKeyboard:)]) {
        [self.delegate didSelectHotDynamicAtIndex:indexPath.row withDynamicID:model.id isShowKeyboard:NO];
    }
    
}


// save height
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

// give exact height value
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [cellHeightsDictionary objectForKey:indexPath];
    if (height) return height.doubleValue;
    return UITableViewAutomaticDimension;
}


#pragma mark - MKDynamicTableViewCellDelegate


- (void)giveMokaCoinButtonClickedAtIndex:(NSInteger)index {
    
    [self.giveMokaCoinPopView showInViewController:self];
    self.giveMokaCoinPopView.cellIndex = index;
}

- (void)likeDynamicButtonClickedAtIndex:(NSInteger)index status:(NSInteger)status{
    [self requestLikeDynamicAtIndex:index like:status];
}

- (void)commentButtonClickedAtIndex:(NSInteger)index {
    MKDynamicListModel *dynamicModel = dynamicArray[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectHotDynamicAtIndex:withDynamicID:isShowKeyboard:)]) {
        [self.delegate didSelectHotDynamicAtIndex:index withDynamicID:dynamicModel.id isShowKeyboard:YES];
    }
}

- (void)tapedUserHeadImageAtIndex:(NSInteger)index {
    MKDynamicListModel *dynamicModel = dynamicArray[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapedUserHeadHotImageAtIndex:withUserID:)]) {
        [self.delegate tapedUserHeadHotImageAtIndex:index withUserID:dynamicModel.userid];
    }
}

- (void)shareContentWithIndex:(NSInteger)index {
    UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    //截图
   
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    
    activityViewController.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)moreOptionButtonClickedAtIndex:(NSInteger)index {
    
    MKDynamicListModel *model = dynamicArray[index];
    
    userName = [NSString stringWithFormat:@"%@",model.name];
    userContent = [NSString stringWithFormat:@"%@",model.text];
    
    //弹出分享 View
    _shareView = [IBShareView newShareView];
    _shareView.index = index;
    if (model.ifdel == 0) {
        //别人的
        [_shareView setShareStyle:ShareViewStyleDynamicOther];
        
    } else if (model.ifdel == 1) {
        //自己的
        [_shareView setShareStyle:ShareViewStyleDynamicSelf];
    }
    
    _shareView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView show];
    return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self shareContentWithIndex:index];
        
    }]];
    
    if (model.ifdel == 0) {
        //别人的
        [alertController addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self showInformAlertSheetAtIndex:index];
        }]];
        
    } else if (model.ifdel == 1) {
        //自己的
        [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self requestDeleteDynamicAtIndex:index];
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


- (void)showInformAlertSheetAtIndex:(NSInteger)index {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"广告或垃圾信息" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
//        [self requestInformDynamicWithRemark:action.title atIndex:index];
        [MKUtilHUD showHUD:@"投诉成功" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"色情或低俗内容" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"投诉成功" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"谩骂" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"投诉成功" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"金钱欺诈" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"投诉成功" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"激进时政或意识形态话题" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"投诉成功" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"其他理由" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MKUtilHUD showHUD:@"投诉成功" inView:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}




#pragma mark - http:请求动态

- (void)requestHotDynamics {
    NSDictionary *paramDitc = @{@"pageNum" : @(pageNum)};
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_hot_dynamic] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        //[MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"请求动态 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            if (pageNum == 1 && [json[@"dataObj"] count] == 0) {
                //首次加载就无数据
                [dynamicArray removeAllObjects];
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                [strongSelf.myTableView reloadData];
                return;
            }
            
            if (pageNum != 1 && [json[@"dataObj"] count] == 0) {
                //无更多数据
                [strongSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            if (pageNum == 1 && [json[@"dataObj"] count] > 0) {
                //下拉刷新
                [dynamicArray removeAllObjects];
                for (NSDictionary *dict in json[@"dataObj"]) {
                    MKDynamicListModel *model = [[MKDynamicListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dynamicArray addObject:model];
                }
                
                [strongSelf.myTableView reloadData];
                //重置上拉刷新
                [strongSelf.myTableView.mj_footer resetNoMoreData];
                //保存数据
                [JsonDataPersistent saveJsonData:json withName:@"HotDynamicData"];
                return;
            }
            
            if (pageNum != 1 && [json[@"dataObj"] count] > 0) {
                //添加更多数据
                for (NSDictionary *dict in json[@"dataObj"]) {
                    MKDynamicListModel *model = [[MKDynamicListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dynamicArray addObject:model];
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
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        
        DLog(@"%@",error);
    }];
}

#pragma mark - http 请求打赏

- (void)requestGiveReward {
    
    NSString *encriptPasswd = [MKTool md5_passwordEncryption:inputPassword];
    MKDynamicListModel *dynamicModel = dynamicArray[_giveMokaCoinPopView.cellIndex];
    NSDictionary *param = @{@"password":encriptPasswd, @"messageid":@(dynamicModel.id), @"money":payMoney};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_giveReward] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"请求打赏 %@",json);
        if (status == 200) {
           
            [MKUtilHUD showHUD:@"打赏成功" inView:strongSelf.view];
            dynamicModel.rewardNum += 1;
//            [strongSelf.myTableView reloadRow:_giveMokaCoinPopView.cellIndex inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_giveMokaCoinPopView.cellIndex inSection:0];
//            [strongSelf.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [strongSelf.myTableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicModel}];
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



#pragma mark - http:点赞和取消点赞

- (void)requestLikeDynamicAtIndex:(NSInteger)index like:(NSInteger)like {
    MKDynamicListModel *dynamicModel = dynamicArray[index];
    
    NSString *url;
    if (like == 1) {
        //点赞
        url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_like_dynamic];
    } else {
        //取消点赞
        url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_dislike_dynamic];
    }
    
    NSDictionary *paramDitc = @{@"messageid" : @(dynamicModel.id)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:url params:paramDitc success:^(id json) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"点赞和取消点赞 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            if (like == 1) {
                //点赞成功
                dynamicModel.ifThing = 1;
                dynamicModel.thingnum += 1;
//                [strongSelf.myTableView reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//                [strongSelf.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.myTableView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicModel}];
            } else {
                //取消点赞
                dynamicModel.ifThing = 0;
                dynamicModel.thingnum -= 1;
//                [strongSelf.myTableView reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//                [strongSelf.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.myTableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicModel}];
            }
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}




#pragma mark  - HTTP 删除动态

- (void)requestDeleteDynamicAtIndex:(NSInteger)index {
    MKDynamicListModel *model = dynamicArray[index];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_delete_dynamic];
    
    NSDictionary *paramDitc = @{@"id" : [NSString stringWithFormat:@"%ld", (long)model.id]};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:url params:paramDitc success:^(id json) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"删除动态 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"删除成功" withSecond:2 inView:strongSelf.view];
            //删除数据源
            [dynamicArray removeObjectAtIndex:index];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//            [strongSelf.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.myTableView reloadData];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}


#pragma mark - HTTP 举报动态

- (void)requestInformDynamicWithRemark:(NSString *)remark atIndex:(NSInteger)index{
    MKDynamicListModel *dynamicModel = dynamicArray[index];
    NSDictionary *param = @{@"otherid":@(dynamicModel.id), @"remark":remark};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_inform_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"举报动态 %@",json);
        if (status == 200) {
            [MKUtilHUD showHUD:@"举报成功" inView:strongSelf.view];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:nil];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}


- (void)scrollToTop {
    [self.myTableView scrollToTop];
}



@end
