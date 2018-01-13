//
//  TchatFeedBackViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/4.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "TchatFeedBackViewController.h"
#import "InputTVViewController.h"

@interface TchatFeedBackViewController ()

@property (nonatomic,strong)UIWebView * webView;
//锁定钛值
- (IBAction)lockTVClick:(UIButton *)sender;


@end

@implementation TchatFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"TV回馈";
    self.view.backgroundColor = RGBCOLOR(245, 247, 255);
    
    [self loadWebView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- WebView

-(void)loadWebView{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor clearColor];
    //
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",WAP_URL,api_feedBackActivity];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2. 把URL告诉给服务器
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    
}


//
- (IBAction)lockTVClick:(UIButton *)sender {
    InputTVViewController * vc = [[InputTVViewController alloc]init];
    vc.toLockSuc = self.toTChatFeedBack;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
