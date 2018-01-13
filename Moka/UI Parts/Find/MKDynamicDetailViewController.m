//
//  MKDynamicDetailViewController.m
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKDynamicDetailViewController.h"
#import "MKDynamicTableViewCell.h"
#import "MKCommentTableViewCell.h"
#import "MKArrowCell.h"
#import "YZInputView.h"
#import "MKGiveMokaCoinView.h"
#import "MKDynamicListModel.h"
#import "MKCircleMemberViewController.h"
#import "MKDynamicCommentModel.h"
#import "upLoadImageManager.h"

@interface MKDynamicDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, MKDynamicTableViewCellDelegate, IBShareViewDelegate>

{
    BOOL isNeedShowTextView;
    MKDynamicListModel *dynamicListModel;
    NSMutableArray     *commentArray;
    NSString           *replyCommentId;
    BOOL isNeedShowArrow;
    NSString  *inputPassword;
    NSString  *payMoney;
    CGFloat   keyboardHeight;
    NSString * userName;
    NSString * userContent;
}

@property (nonatomic, strong) IBShareView *shareView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKGiveMokaCoinView *giveMokaCoinPopView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewBottom;
@property (weak, nonatomic) IBOutlet YZInputView *commentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTextViewHeight;


@end

@implementation MKDynamicDetailViewController

// 移除监听
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [self checkNetWork];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"详情"];
    self.title = @"详情";
    [self setMyTableView];
    
    self.commentTextView.layer.borderWidth = 0.5;
    self.commentTextView.layer.borderColor = RGB_COLOR_HEX(0xE5E5E5).CGColor;
    self.commentTextView.delegate = self;
    //[MKTool addGrayShadowAboveOnView:self.commentTextView];
    
    if (iPhone5) {
        keyboardHeight = 216;
    } else if ( iPhone6) {
        keyboardHeight = 258;
    } else if (iPhone6plus) {
        keyboardHeight = 271;
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

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradHided) name:@"KeyboradHided" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 监听文本框文字高度改变
    self.commentTextView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        _commentTextViewHeight.constant = MIN(textHeight, 100) ;
        if (_commentTextViewHeight.constant == 100) {
            _commentTextView.scrollEnabled = YES;
        }
    };
    commentArray = @[].mutableCopy;
    
}

-(void)checkNetWork {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] checkNetWorkStatusSuccess:^(id str) {
        STRONG_SELF;
        if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
            //有网络
            [strongSelf hiddenNonetWork];
            [self requestDynamicDetail];
        }else{
            //无网络
            [strongSelf showNonetWork];
            
        }
        
    }];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        [self requestCommentWithReplyId:replyCommentId];
        
        [textView resignFirstResponder];
        _commentTextViewHeight.constant = 30;
        return NO;
    }
    
    return YES;
}

- (void)keyboradHided {
    self.commentViewBottom.constant = 0;
   
    
    [UIView animateWithDuration:0.2 animations:^{
        // 如果有需要,重新排版
        [self.view layoutIfNeeded];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.commentViewBottom.constant = 0;

        [UIView animateWithDuration:0.1 animations:^{
            // 如果有需要,重新排版
            [self.view layoutIfNeeded];
        }];
    });
}

// 监听键盘的frame即将改变的时候调用
- (void)keyboardWillChange:(NSNotification *)note{
    // 获得键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //NSLog(@"键盘的frame = %@", NSStringFromCGRect(frame));
    self.commentViewBottom.constant = self.view.frame.size.height - frame.origin.y + 64;

    // 执行动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        // 如果有需要,重新排版
        [self.view layoutIfNeeded];
    }];
}
/*
- (void)keyboardWillShow:(NSNotification *)note {
    // 获得键盘的frame
    
    self.commentViewBottom.constant = keyboardHeight;
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        // 如果有需要,重新排版
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)note {
    
    // 获得键盘的frame
//    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.commentViewBottom.constant = -50 ;
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        // 如果有需要,重新排版
        [self.view layoutIfNeeded];
    }];
}
 */



- (void)openCommentKeyboard {
    isNeedShowTextView = YES;
    [_commentTextView becomeFirstResponder];
}



- (void)setMyTableView {
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKDynamicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKDynamicTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKCommentTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MKArrowCell" bundle:nil] forCellReuseIdentifier:@"MKArrowCell"];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2){
        return commentArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 500; //动态cell
    } else if (indexPath.section == 1) {
        return 15; //箭头cell
    } else if (indexPath.section == 2) {
        return 60; //评论cell
    } else {
        return 30; //空白占位cell
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MKDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKDynamicTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type = DynamicCellTypeDetail;
        cell.delegate = self;
        [cell configDynamicCell:dynamicListModel parentViewController:self];
        return cell;
        
    } else if (indexPath.section == 1){
        MKArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKArrowCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (isNeedShowArrow) {
            cell.arrow.hidden = NO;
        } else {
            cell.arrow.hidden = YES;
        }
        return cell;
    } else if (indexPath.section == 2){
        MKCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCommentTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [cell configCell:commentArray[indexPath.row]];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
        longPressGesture.minimumPressDuration = 1.0; //seconds
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    } else {
        UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
        emptyCell.backgroundColor = [UIColor clearColor];
        emptyCell.contentView.backgroundColor = [UIColor clearColor];
        emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return emptyCell;
    }
    
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        //取出评论模型
        MKDynamicCommentModel *commentModel = commentArray[indexPath.row];
        //判断是不是自己的评论
        if (commentModel.ifdel == 1) {
             //自己的
            
            [self showDeleteCommentActionSheetWithCommentModel:commentModel];
        } else {
            replyCommentId = [NSString stringWithFormat:@"%ld", (long)commentModel.id];
            _commentTextView.placeholder = [NSString stringWithFormat:@"回复%@", commentModel.name];
            isNeedShowTextView = YES;
            [_commentTextView becomeFirstResponder];
        }
        
        
    } else {
        [self.view endEditing:YES];
    }
    
}


- (void)showDeleteCommentActionSheetWithCommentModel:(MKDynamicCommentModel *)model {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"删除评论" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self requestDeleteCommentWithCommentModel:model];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
         [self.view endEditing:YES];
    }
}


//长按评论
- (void)longPressCell:(UILongPressGestureRecognizer *)longPressGesture {
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPressGesture locationInView:self.myTableView];
        NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:point];
        if (indexPath.section != 2) {
            return;
        }
        MKDynamicCommentModel *commentModel = commentArray[indexPath.row];
        //1.判断是不是自己的动态 (是：删除每条评论, 不是：只能删自己的)
        if (dynamicListModel.ifdel == 1) {
            
            [self showDeleteCommentActionSheetWithCommentModel:commentModel];
        } else {
            if (commentModel.ifdel == 1) {
                
                [self showDeleteCommentActionSheetWithCommentModel:commentModel];
            }
        }
    }
}

- (void)shareEvent {
    
    //截图
    UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    
    activityViewController.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}



-(void)loadImage:(NSString *)imageUrl{
    //
    NSString *fullURL = [upLoadImageManager judgeThePathForImages:imageUrl];
    //NSString *fullURL = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, imageUrl];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", fullURL]]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                
                            }
                        }];
}



#pragma mark - MKDynamicTableViewCellDelegate


- (void)giveMokaCoinButtonClickedAtIndex:(NSInteger)index {
    isNeedShowTextView = NO;
    [self.giveMokaCoinPopView showInViewController:self];
}
- (void)likeDynamicButtonClickedAtIndex:(NSInteger)index status:(NSInteger)status {
    [self requestLikeDynamicWithlike:status];
}
- (void)commentButtonClickedAtIndex:(NSInteger)index {
    isNeedShowTextView = YES;
    [_commentTextView becomeFirstResponder];
}

- (void)tapedUserHeadImageAtIndex:(NSInteger)index {
    MKCircleMemberViewController *vc = [[MKCircleMemberViewController alloc] init];
    vc.userId = [NSString stringWithFormat:@"%ld", (long)dynamicListModel.userid];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)moreOptionButtonClickedAtIndex:(NSInteger)index {
    

    //弹出分享 View
    _shareView = [IBShareView newShareView];
    
    if (dynamicListModel.ifdel == 0) {
        //别人的
        [_shareView setShareStyle:ShareViewStyleDynamicOther];
        
    } else if (dynamicListModel.ifdel == 1) {
        //自己的
        [_shareView setShareStyle:ShareViewStyleDynamicSelf];
    }
    
    _shareView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView show];
    return;
  
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self shareEvent];
        
    }]];
    
    if (dynamicListModel.ifdel == 0) {
        //别人的
        [alertController addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self showInformAlertSheetAtIndex:index];
        }]];
        
    } else if (dynamicListModel.ifdel == 1) {
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



#pragma mark - HTTP : 动态详情

- (void)requestDynamicDetail {
    
    NSDictionary *paramDitc = @{@"id" : self.dynamicId};
    //[MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_dynamic_detail] params:paramDitc success:^(id json) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"动态详情 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            dynamicListModel = [MKDynamicListModel mj_objectWithKeyValues:json[@"dataObj"][@"message"]];
            
            //
            userName = [NSString stringWithFormat:@"%@",dynamicListModel.name];
            userContent = [NSString stringWithFormat:@"%@",dynamicListModel.text];
            
            [commentArray removeAllObjects];
            
            for (NSDictionary *comDic in json[@"dataObj"][@"commentList"]) {
                MKCommentModel *commentModel = [MKCommentModel mj_objectWithKeyValues:comDic];
                MKDynamicCommentModel *cdModel = [[MKDynamicCommentModel alloc] initWithCommentModel:commentModel];
                [commentArray addObject:cdModel];
                
                for (MKReplyModel *replyModel in commentModel.dataList) {
                
                    MKDynamicCommentModel *dModel = [[MKDynamicCommentModel alloc] initWithReplyModel:replyModel];
                    [commentArray addObject:dModel];
                    
                }
                
            }
            
            if (commentArray.count == 0) {
                isNeedShowArrow = NO;
            } else {
                isNeedShowArrow = YES;
            }
            
            MKDynamicCommentModel *lastModel = commentArray.lastObject;
            lastModel.hideSeperatorLine = 1;
            
            [strongSelf.myTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicListModel}];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}


#pragma mark - http:点赞和取消点赞

- (void)requestLikeDynamicWithlike:(NSInteger)like {

    NSString *url;
    if (like == 1) {
        //点赞
        url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_like_dynamic];
    } else {
        //取消点赞
        url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_dislike_dynamic];
    }
    
    NSDictionary *paramDitc = @{@"messageid" : @(dynamicListModel.id)};
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
                dynamicListModel.ifThing = 1;
                dynamicListModel.thingnum += 1;
//                [strongSelf.myTableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                [strongSelf.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [strongSelf.myTableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicListModel}];
            } else {
                //取消点赞
                dynamicListModel.ifThing = 0;
                dynamicListModel.thingnum -= 1;
//                [strongSelf.myTableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                [strongSelf.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [strongSelf.myTableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicListModel}];
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

    
    NSString *url = [NSString stringWithFormat:@"%@%@",WAP_URL, api_delete_dynamic];
    NSString *dynamicID = [NSString stringWithFormat:@"%ld", (long)dynamicListModel.id];
    NSDictionary *paramDitc = @{@"id" : dynamicID};
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
            [MKUtilHUD showAutoHiddenTextHUD:@"删除成功" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
            NSDictionary *dict = @{@"deleteID" : dynamicID};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETE_DYNAMIC" object:nil userInfo:dict];
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
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
    
    NSDictionary *param = @{@"otherid":@(dynamicListModel.id), @"remark":remark};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_inform_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"举报动态 %@",json);
        if (status == 200) {
            [MKUtilHUD showHUD:@"举报成功" inView:[UIApplication sharedApplication].keyWindow];
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

#pragma mark - HTTP 评论

- (void)requestCommentWithReplyId:(NSString *)replyId {
    
    NSDictionary *param = @{@"messageid"  : @(dynamicListModel.id),
                            @"commenttext": _commentTextView.text,
                            @"replycomid" : replyId ? replyId : @""};
    
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_addComment] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"评论 %@",json);
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"评论成功" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
            
            _commentTextView.text  = @"";
            replyCommentId = nil;
            //刷新页面
            [strongSelf requestDynamicDetail];
            
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

#pragma mark - HTTP 删除评论

- (void)requestDeleteCommentWithCommentModel:(MKDynamicCommentModel *)model {
    
    NSDictionary *param;
    if (model.replycomid == 0) {
        //第一级
        param = @{@"status"   : @(1),
                  @"id"       : @(model.id),
                  @"messageid": @(model.messageid)};
    } else {
        param = @{@"status"   : @(0),
                  @"id"       : @(model.id),
                  @"messageid": @(model.messageid)};
    }
    
   
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, aoi_deleteComment] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"删除评论 %@",json);
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"删除评论成功" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
            //刷新页面
            [strongSelf requestDynamicDetail];
           
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


#pragma mark - http 请求打赏

- (void)requestGiveReward {
    
    NSString *encriptPasswd = [MKTool md5_passwordEncryption:inputPassword];
    
    NSDictionary *param = @{@"password":encriptPasswd, @"messageid":@(dynamicListModel.id), @"money":payMoney};
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
            dynamicListModel.rewardNum += 1;
//            [strongSelf.myTableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [strongSelf.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [strongSelf.myTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DYNAMIC" object:nil userInfo:@{@"model":dynamicListModel}];
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


@end
