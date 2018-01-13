//
//  MKFeedbackViewController.m
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKFeedbackViewController.h"
#import "InputLimitedTextView.h"

@interface MKFeedbackViewController ()


@property (weak, nonatomic) IBOutlet InputLimitedTextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;


@end

@implementation MKFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setNavigationTitle:@"意见反馈"];
    self.feedbackTextView.placeholder = @"您要反馈的问题是...";
    self.feedbackTextView.limitLength = 400;
    self.feedbackTextView.layer.borderWidth = 0;
    self.feedbackTextView.layer.borderColor = RGB_COLOR_HEX(0xEAE9EB).CGColor;
    [self.feedbackTextView becomeFirstResponder];
    //2.监听textView文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
}


- (void)textViewDidChange {
    if (_feedbackTextView.text.length > 0) {
        _nextStepButton.enabled = YES;
        _nextStepButton.backgroundColor = commonBlueColor;
        [MKTool addShadowOnView:_nextStepButton];
    } else {
        _nextStepButton.backgroundColor = RGB_COLOR_HEX(0xE5E5E5);
        _nextStepButton.enabled = NO;
        [MKTool removeShadowOnView:_nextStepButton];
    }
}

- (IBAction)confirmButtonClicked:(id)sender {
    if (_feedbackTextView.text.length == 0) {
        [MKUtilHUD showAutoHiddenTextHUD:@"请输入内容" withSecond:2 inView:self.view];
        return;
    }
    [self requestFeedback];
}


#pragma mark - HTTP requestFeedback

- (void)requestFeedback {
    NSDictionary *param = @{@"remark": _feedbackTextView.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_feedback] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"Feedback %@",json);
        if (status == 200) {
            [MKUtilHUD showAutoHiddenTextHUD:@"提交成功" withSecond:2 inView:self.view];
            [strongSelf performSelector:@selector(dismissViewController) withObject:nil afterDelay:2];
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

- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
