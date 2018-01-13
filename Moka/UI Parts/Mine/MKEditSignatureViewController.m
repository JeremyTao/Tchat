//
//  MKEditSignatureViewController.m
//  Moka
//
//  Created by  moka on 2017/7/31.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditSignatureViewController.h"
#import "InputLimitedTextView.h"

@interface MKEditSignatureViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet InputLimitedTextView *myTextView;

@end

@implementation MKEditSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"签名"];
    self.title = @"签名";
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"完成" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    
   //[self setRightButtonWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.myTextView.text = self.infoModel.autograph;
    self.myTextView.delegate = self;
    self.myTextView.layer.cornerRadius = 5;
    self.myTextView.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
}


- (void)textViewDidChange{
    if (self.myTextView.text.length > 30) {
        self.myTextView.text = [self.myTextView.text substringToIndex:30];
    }
}

- (void)confirmButtonClicked {
    [self.view endEditing:YES];

    [self requestUpdateUserSignature];
}


- (void)requestUpdateUserSignature {
    NSDictionary *param = @{@"autograph":_myTextView.text};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_updateUser] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改签名 %@",json);
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            self.infoModel.autograph = _myTextView.text;
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

- (void)delayPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
