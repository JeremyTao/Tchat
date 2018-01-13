//
//  TVCandyViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "TVCandyViewController.h"

@interface TVCandyViewController ()

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIWebView *webView;


@end

@implementation TVCandyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"TV糖果";
    self.view.backgroundColor = RGBCOLOR(245, 247, 255);
    self.navigationController.navigationBar.hidden = YES;
    
    
    [self loadWebView];
    [self setNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -- 导航栏
-(void)setNavi{
    
    _navView = [UIView new];
    [_webView addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    _navView.backgroundColor = [UIColor clearColor];
    //
    _backBtn = [UIButton new];
    [_backBtn setImage:[UIImage imageNamed:@"mine_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popToBack) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_backBtn];
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.text = @"TV糖果";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_navView addSubview:_titleLabel];
    //位置
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navView).offset(20);
        make.left.equalTo(_navView).offset(10);
        make.width.height.equalTo(@40);
    }];
    //
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navView).offset(20);
        make.bottom.equalTo(_navView).offset(0);
        make.left.equalTo(_navView).offset(SCREEN_WIDTH/2-40);
        make.width.equalTo(@80);
    }];
}

-(void)popToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- WebView

-(void)loadWebView{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor clearColor];
    //
    NSString * urlStr = [NSString stringWithFormat:@"%@",self.webURLStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2. 把URL告诉给服务器
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    
}

@end
