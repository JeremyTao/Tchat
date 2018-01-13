//
//  YPCollectionViewCell.m
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import "YPCollectionViewCell.h"
#define KScreen_Size  [UIScreen mainScreen].bounds.size
#define KH_Gap 16.0
#define KImage_Width (KScreen_Size.width-2*KH_Gap)/3
@implementation YPCollectionViewCell{
}

- (instancetype)initWithFrame:(CGRect)frame {
 
    self =[super initWithFrame:frame] ;
    if (self) {
        
        
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageView];
        _imageView.userInteractionEnabled = YES ;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        //
        _preLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.frame.size.height-25, _imageView.frame.size.width, 25)];
        [_imageView addSubview:_preLabel];
        //设置
        _preLabel.text = @"当前头像";
        _preLabel.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.5);
        _preLabel.font = [UIFont systemFontOfSize:14.0f];
        _preLabel.textAlignment = NSTextAlignmentCenter;
        _preLabel.textColor = [UIColor whiteColor];
        
        //按钮
        _btn = [UIButton buttonWithType:0];
        [_btn setImage:[UIImage imageNamed:@"close_btn_normal"] forState:(UIControlStateNormal)];
        [_btn setImageEdgeInsets:(UIEdgeInsetsMake(-5, 5, 5, -5))];
         _btn.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) - 30, -10, 45, 45);
        [self.contentView addSubview:_btn];
        _btn.hidden = YES ;
        
    }
    return self ;
}

- (void)setCellWithImage:(UIImage *)img  IsFirstOrLastObjectHiddenBtn:(BOOL)hidden{
   
    _imageView.image = nil;
    _imageView.image = img ;
    _btn.hidden = hidden ;
    if (hidden ) {
        _btn.enabled = NO;
    }else{
        _btn.enabled = YES;
    }

}



- (CGFloat)imageHeightWithImage:(UIImage *)img
{
    CGFloat heigth = img.size.height;
    CGFloat width = img.size.width;
    return heigth*KImage_Width/width;
    
}


@end
