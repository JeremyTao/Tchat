
//
//  Created by apple on 15-3-7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZNewFeatureCell.h"

@interface CZNewFeatureCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *shareButton;
@property (nonatomic, weak) UIButton *resignButton;

@end

@implementation CZNewFeatureCell

- (UIButton *)shareButton
{
    if (_shareButton == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"open_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"open_icon"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        
        [self.contentView addSubview:btn];
        
        _shareButton = btn;
        
    }
    return _shareButton;
}

- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setTitle:@"" forState:UIControlStateNormal];
        [startBtn sizeToFit];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        _startButton = startBtn;

    }
    return _startButton;
}

-(UIButton *)resignButton{
//    if (_resignButton == nil) {
//        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [startBtn setTitle:@"" forState:UIControlStateNormal];
//        [startBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [startBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//        [startBtn sizeToFit];
//        [startBtn addTarget:self action:@selector(resign) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:startBtn];
//        _resignButton = startBtn;
//        
//    }
    return _resignButton;
    
    
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        _imageView = imageV;
        
        // 注意:一定要加载contentView
        [self.contentView addSubview:imageV];
        
    }
    return _imageView;
}

#pragma mark 布局子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    // 开始按钮
    self.startButton.frame= CGRectMake(0,0, 160 , 50);
    self.startButton.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT - 40);
    self.startButton.backgroundColor = commonBlueColor;
    self.startButton.layer.cornerRadius = 25;
    self.startButton.layer.masksToBounds = YES;
    [self.startButton setTitle:@"开始体验" forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    _shareButton.frame = CGRectMake(0,0, 6, 9);;
    _shareButton.center = CGPointMake(SCREEN_WIDTH - 30, SCREEN_HEIGHT - 25);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

#pragma mark 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
        self.shareButton.hidden = NO;
        self.startButton.hidden = NO;
        self.resignButton.hidden = NO;
        
    }else{ // 非最后一页，隐藏分享和开始按钮
        self.shareButton.hidden = YES;
        self.startButton.hidden = YES;
        self.resignButton.hidden = YES;

    }
}

#pragma mark 点击开始微博的时候调用
- (void)start
{
    
    if (self.backNew) {
        self.backNew(@"login");
    }

}
-(void)resign{
    
    if (self.backNew) {
        self.backNew(@"resign");
    }
    
    
    
}
@end
