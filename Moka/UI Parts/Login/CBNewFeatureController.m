//  Created by apple on 15-3-7.
//  Copyright (c) 2015年 apple. All rights reserved.

#import "CBNewFeatureController.h"
#import "CZNewFeatureCell.h"
#import "MKLoginViewController.h"
#import "MKTabBarViewController.h"
#import "AppDelegate.h"

#define NUMBER 4

@interface CBNewFeatureController ()

@property (nonatomic, weak) UIPageControl *control;

@end

@implementation CBNewFeatureController

static NSString *ID = @"cell";
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
    
    self.navigationController.navigationBar.hidden = YES;
    
}
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的尺寸
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 20);;
    // 清空行距
    layout.minimumLineSpacing = 0;
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [super initWithCollectionViewLayout:layout];
}
// self.collectionView != self.view
// 注意： self.collectionView 是 self.view的子控件

// 使用UICollectionViewController
// 1.初始化的时候设置布局参数
// 2.必须collectionView要注册cell
// 3.自定义cell

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell,默认就会创建这个类型的cell
    [self.collectionView registerClass:[CZNewFeatureCell class] forCellWithReuseIdentifier:ID];
    self.collectionView.contentOffset = CGPointMake(0 , -20);
    // 分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    
    // 添加pageController
   // [self setUpPageControl];
}
#pragma mark 添加pageController
- (void)setUpPageControl
{
    // 添加pageController,只需要设置位置，不需要管理尺寸
    UIPageControl *control = [[UIPageControl alloc] init];
    
    control.numberOfPages = NUMBER;
    //    control.hidden = YES;
    control.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    control.currentPageIndicatorTintColor = [UIColor clearColor];
    
    // 设置center
    control.center = CGPointMake(self.view.width * 0.5, SCREEN_HEIGHT - 25);
    _control = control;
    [self.view addSubview:control];
    
}

#pragma mark - UIScrollView代理
//// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    // 设置页数
    _control.currentPage = page;
}
#pragma mark - UICollectionView代理和数据源
// 返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark 返回第section组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return NUMBER;
}



#pragma mark 返回cell长什么样子
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeueReusableCellWithReuseIdentifier
    // 1.首先从缓存池里取cell
    // 2.看下当前是否有注册Cell,如果注册了cell，就会帮你创建cell
    // 3.没有注册，报错
    CZNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
    //    backView.image = IMAGE(@"sport");
    cell.backgroundView = backView;
    
    NSString *imageName = [NSString stringWithFormat:@"guide0%ld",(long)indexPath.row + 1];
    
    cell.image = [UIImage imageNamed:imageName];
    
    [cell setIndexPath:indexPath count:NUMBER];
    
//    if (_isBack) {
//        [cell.startButton setTitle:@"点击返回" forState:(UIControlStateNormal)];
//    }else{
//        [cell.startButton setTitle:@"立即开启" forState:(UIControlStateNormal)];
//    }
    
    WEAK_SELF;
    cell.backNew = ^ (NSString *str){
        
        STRONG_SELF;
        if (_isBack) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            // 保持当前的版本，用偏好设置
            
            MKLoginViewController *loginVC = [[MKLoginViewController alloc ]init];
            
            MKNavigationController *vc= [[MKNavigationController alloc] initWithRootViewController:loginVC];
            
            [strongSelf presentViewController:vc animated:NO completion:nil];
        }
        
        
        
    };
    return cell;
    
}



@end

