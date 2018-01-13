//
//  NewsDetaelViewController.m
//  Moka
//
//  Created by btc123 on 2018/1/4.
//  Copyright © 2018年 moka. All rights reserved.
//

#import "NewsDetaelViewController.h"

@interface NewsDetaelViewController ()<IBShareViewDelegate>
{
    NSString *_Des;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *liulanLabel;
@property (nonatomic, strong) IBShareView *shareView;
@property (nonatomic, strong) UIWebView *newsWebView;
@end

@implementation NewsDetaelViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"详情";
    [self setUp];
    [self setHeaderView];
    [self loadNewsImage];
    //
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(0, 0, 30, 30);
    [setButton setImage:IMAGE(@"dynamic_share") forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(shareNewsButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    
    self.navigationItem.rightBarButtonItem = menuItem;
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


//分享给好友
- (void)shareNewsButtonEvent {
    //弹出分享 View
    _shareView = [IBShareView newShareView];
    
    [_shareView setShareStyle:ShareViewStyleNews];
    _shareView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView show];
}



#pragma mark -- 设置头视图的值
-(void)setHeaderView{
    
    //标题
    self.titleLabel.text = self.news.title;
    //时间
    self.timeLabel.text = self.news.time;
    //浏览人数
    self.liulanLabel.text = self.news.count;
}


#pragma mark -- 加载详情中的图片
-(void)loadNewsImage{
    
    
    NSDictionary * param = @{@"id":self.news.Id};
    
    [[MKNetworkManager sharedManager] post:APINewsDetail params:param success:^(id json) {
       
        if ([[json objectForKey:@"isSuc"] boolValue]) {
            self.news.content = [[json objectForKey:@"datas"] objectForKey:@"content"];
            
            _Des = json[@"datas"][@"description"];
            NSLog(@"---------------%@",_Des);
            
            NSString * htmlString = self.news.content;
            htmlString = [NSString stringWithFormat:@"<html><head><style>p{font-size: 16px !important;color: #4f4f4f !important; text-align:justify !important;} img{width:100%%!important;height:auto!important;} a:hover, a:visited, a:link, a:active{text-decoration:none !important; color:#4f4f4f !important;} </style></head><body>%@</body></html>",htmlString];
            
            [_newsWebView loadHTMLString: htmlString baseURL:nil];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)setUp
{
    NSString * htmlString = self.news.content;
    
    htmlString = [NSString stringWithFormat:@"<html><head><style>p{font-size: 16px !important;color: #4f4f4f !important; text-align:justify !important;} img{width:100%%!important;height:auto!important;} a:hover, a:visited, a:link, a:active{text-decoration:none !important; color:#4f4f4f !important;} </style></head><body>%@</body></html>",htmlString];
    
    _newsWebView = [[UIWebView alloc]initWithFrame:CGRectMake(12, 100, SCREEN_WIDTH-24, SCREEN_HEIGHT-100-64)];
    _newsWebView.scrollView.backgroundColor = [UIColor whiteColor];
    _newsWebView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 100);
    [_newsWebView loadHTMLString: htmlString baseURL:nil];

    [self.view addSubview:_newsWebView];
}

#pragma mark - IBShareViewDelegate

- (void)shareToWeichatMoments {
    NSLog(@"分享朋友圈");
    [_shareView hide];
    
    NSString *url = [NSString stringWithFormat:@"http://m.btc123.com/news/newsdetail?id=%@",self.news.Id];
    //
    [IBCommShare shareToWeichatMoments:self.news.title shareDescription:[NSString stringWithFormat:@"%@",_Des] shareThumbImg:self.news.image shareUrl:url];
    
}

- (void)shareToWeichatFriends {
    NSLog(@"分享微信好友");
    [_shareView hide];
    
    //新闻地址
    NSString *url = [NSString stringWithFormat:@"http://m.btc123.com/news/newsdetail?id=%@",self.news.Id];
    //
    [IBCommShare shareToWeichatFriends:self.news.title shareDescription:[NSString stringWithFormat:@"%@",_Des] shareThumbImg:self.news.image shareUrl:url];
}


@end
