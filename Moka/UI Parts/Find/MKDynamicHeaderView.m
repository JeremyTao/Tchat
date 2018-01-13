//
//  MKDynamicHeaderView.m
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKDynamicHeaderView.h"

@interface MKDynamicHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView3;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img1CentX; //3:-60, 2:-40 , 1:-20

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLabelLeading;//3:42.5 , 2:25 , 1:7.5


@end

@implementation MKDynamicHeaderView

+ (instancetype)newView {
    MKDynamicHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKDynamicHeaderView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKDynamicHeaderView class]]) {
        
        
        return customView;
    }
    else
        return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addBorderToImageView:_headImgView1];
    [self addBorderToImageView:_headImgView2];
    [self addBorderToImageView:_headImgView3];
}

- (void)addBorderToImageView:(UIImageView *)imageView {
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)configWithInfo:(NSDictionary *)info {
    _headImgView1.hidden = NO;
    _headImgView2.hidden = NO;
    _headImgView3.hidden = NO;
    
    _messageCountLabel.text = [NSString stringWithFormat:@"%ld条新消息", [info[@"count"] integerValue]];
    if ([info[@"imgs"] count] == 1) {
        [_headImgView1 setImageUPSUrl:info[@"imgs"][0]];
        _headImgView2.hidden = YES;
        _headImgView3.hidden = YES;
        _img1CentX.constant = -20;
        _msgLabelLeading.constant = 7.5;
    } else if ([info[@"imgs"] count] == 2) {
        [_headImgView1 setImageUPSUrl:info[@"imgs"][0]];
        [_headImgView2 setImageUPSUrl:info[@"imgs"][1]];
        _headImgView3.hidden = YES;
        _img1CentX.constant = -40;
        _msgLabelLeading.constant = 25;
    } else if ([info[@"imgs"] count] == 3) {
        [_headImgView1 setImageUPSUrl:info[@"imgs"][0]];
        [_headImgView2 setImageUPSUrl:info[@"imgs"][1]];
        [_headImgView3 setImageUPSUrl:info[@"imgs"][2]];
        _img1CentX.constant = -60;
        _msgLabelLeading.constant = 42.5;
    }
}


- (IBAction)messageButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedHeaderView)]) {
        [self.delegate didClickedHeaderView];
    }
}


@end
