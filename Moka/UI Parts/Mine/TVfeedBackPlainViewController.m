//
//  TVfeedBackPlainViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "TVfeedBackPlainViewController.h"

@interface TVfeedBackPlainViewController ()

@property (nonatomic,strong)UIWebView * webView;
@end

@implementation TVfeedBackPlainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"钛值回馈计划说明";
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
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor clearColor];
    
    //
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",WAP_URL,api_feedBackPlain];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    
}

@end
