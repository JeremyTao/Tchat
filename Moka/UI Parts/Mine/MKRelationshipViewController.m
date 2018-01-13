//
//  MKRelationshipViewController.m
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRelationshipViewController.h"

@interface MKRelationshipViewController ()

{
    NSString *selectFeeling;
}

@property (weak, nonatomic) IBOutlet UIImageView *singleSelectImgView;
@property (weak, nonatomic) IBOutlet UIImageView *marriedSelectImgView;


@end

@implementation MKRelationshipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"情感状态"];
    self.title = @"情感状态";
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"完成" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    [self setRightButtonWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    if (self.infoModel.feeling != 0) {
        selectFeeling = [NSString stringWithFormat:@"%ld", (long)self.infoModel.feeling];
        if (self.infoModel.feeling == 1) {
            _singleSelectImgView.image = IMAGE(@"choose");
            _marriedSelectImgView.image = nil;
        } else {
            _singleSelectImgView.image = nil;
            _marriedSelectImgView.image = IMAGE(@"choose");
        }
    }
}

//单身
- (IBAction)singleButtonClicked:(UIButton *)sender {
    _singleSelectImgView.image = IMAGE(@"choose");
    _marriedSelectImgView.image = nil;
    selectFeeling = @"1";
}

//已婚
- (IBAction)marriedButtonClicked:(UIButton *)sender {
    _singleSelectImgView.image = nil;
    _marriedSelectImgView.image = IMAGE(@"choose");
    selectFeeling = @"2";
}

- (void)confirmButtonClicked {
    if (selectFeeling.length == 0) {
        [MKUtilHUD showHUD:@"请选择一项" inView:self.view];
        return;
    }

    [self requestUpdateUserRelationship];
}


- (void)requestUpdateUserRelationship {
    NSDictionary *param = @{@"feeling":selectFeeling};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_updateUser] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"修改感情状态 %@",json);
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            self.infoModel.feeling = [selectFeeling integerValue];
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
