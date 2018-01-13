//
//  YPImagePreviewController.m
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import "YPImagePreviewController.h"
#define KScreen_Size  [UIScreen mainScreen].bounds.size
@interface YPImagePreviewController ()<UIScrollViewDelegate>

@end

@implementation YPImagePreviewController
{
    UIScrollView * _scrollView;
    UIImageView * _imageView;
    UILabel *_titleLab;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createUI];
    [self addImagesToScrollView];
    // Do any additional setup after loading the view.
}

- (void)createNav{
    self.view.backgroundColor = [UIColor blackColor];
    _titleLab= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    _titleLab.text = [NSString stringWithFormat:@"%d/%d",(int)(self.index +1),(int)self.images.count];
    _titleLab.textAlignment = NSTextAlignmentCenter ;
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20];
    
    self.navigationItem.titleView = _titleLab;

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 50, 44)];
    [backButton setImage:[UIImage imageNamedFromMyBundle:@"navi_back.png"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton addTarget:self action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
 
    
}

- (void)createUI {

    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(KScreen_Size.width*self.images.count, KScreen_Size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self ;
    _scrollView.contentOffset = CGPointMake(self.index*KScreen_Size.width,0);
    [self.view addSubview:_scrollView];
}

-(void)addImagesToScrollView
{
    for (int i = 0;i < _images.count ;i ++) {
        
        _imageView.userInteractionEnabled = YES;
        
        _imageView = [[UIImageView alloc] init];
        
        _imageView.frame = CGRectMake(i*(KScreen_Size.width),0,KScreen_Size.width, KScreen_Size.height);
        
        _imageView.image = _images[i];
        
        
        CGRect cellHeight = _imageView.frame;
        
        cellHeight.size.height = [self setImageHeightWithImage:_images[i]];
        
        _imageView.frame = cellHeight;
        
        CGPoint point = _imageView.center;
        
        point.y = (KScreen_Size.height-64)/2.0;
        
        _imageView.center = point;
        
        [_scrollView addSubview:_imageView];
    }
}

- (CGFloat)setImageHeightWithImage:(UIImage *)img
{
    CGFloat height = img.size.height;
    CGFloat width = img.size.width;
    return height*KScreen_Size.width/width;
}

#pragma mark - 结束滚动代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 
    _titleLab.text = [NSString stringWithFormat:@"%d/%d",(int)(scrollView.contentOffset.x / KScreen_Size.width)+1,(int)_images.count];
}


- (void)popViewControllerAnimated{
  
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
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

@end
@implementation UIImage (MyBundle)

+ (UIImage *)imageNamedFromMyBundle:(NSString *)name {
    UIImage *image = [UIImage imageNamed:[@"TZImagePickerController.bundle" stringByAppendingPathComponent:name]];
    if (image) {
        return image;
    } else {
        image = [UIImage imageNamed:[@"Frameworks/TZImagePickerController.framework/TZImagePickerController.bundle" stringByAppendingPathComponent:name]];
        return image;
    }
}

@end


