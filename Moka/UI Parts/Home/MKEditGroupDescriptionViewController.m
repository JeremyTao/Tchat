//
//  MKEditGroupDescriptionViewController.m
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditGroupDescriptionViewController.h"
#import "InputLimitedTextView.h"

@interface MKEditGroupDescriptionViewController ()

@property (weak, nonatomic) IBOutlet InputLimitedTextView *myTextView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation MKEditGroupDescriptionViewController

- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"圈子介绍"];
    self.title = @"圈子介绍";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
    _myTextView.text =  _circleModel.introduce;
    [self setConfirmButtonState];
}

- (void)setConfirmButtonState {
    if (_myTextView.text.length == 0) {
        _confirmButton.backgroundColor = buttonDisableColor;
        _confirmButton.enabled = NO;
        [MKTool removeShadowOnView:_confirmButton];
    } else {
        _confirmButton.backgroundColor = commonBlueColor;
        _confirmButton.enabled = YES;
        [MKTool addShadowOnView:_confirmButton];
    }
}

- (void)textViewDidChange {
    [self setConfirmButtonState];
    
    if (_myTextView.text.length > 200) {
        _myTextView.text = [_myTextView.text substringToIndex:200];
    }
    
}

- (IBAction)confirmButtonClicked:(UIButton *)sender {
    [self requestChangeCircleIntroduce];
}


#pragma mark - Http -修改圈介绍

- (void)requestChangeCircleIntroduce {
    NSDictionary *param = @{@"id":@(_circleModel.id) , @"introduce":_myTextView.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_update_circle] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改圈介绍 %@",json);
        if (status == 200) {
            _circleListModel.introduce = _myTextView.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircle" object:nil];
            _circleModel.introduce = _myTextView.text;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:self];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}


@end
