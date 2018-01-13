//
//  UNbundleAlertView.m
//  Moka
//
//  Created by btc123 on 2017/12/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "UNbundleAlertView.h"

///alertView 宽
#define AlertW 250
#define AlertH 190

@interface UNbundleAlertView ()
//弹窗
@property (nonatomic,retain) UIView *alertView;
//图片
@property (nonatomic,retain) UIImageView *imageView;
//内容
@property (nonatomic,retain) UILabel *msgLabel;
//确认按钮
@property (nonatomic,retain) UIButton *sureBtn;
//取消按钮
@property (nonatomic,retain) UIButton *cancleBtn;
//横线
@property (nonatomic,retain) UIView *lineView;
//竖线
@property (nonatomic,retain) UIView *verLineView;

@end

@implementation UNbundleAlertView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//初始化
-(instancetype)initNnbundleAlertView:(NSString *)title{
    
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        //背景色
        self.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.5);
        //弹窗
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 5.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, AlertH);
        self.alertView.layer.position = self.center;
        
        //图片
        self.imageView = [[UIImageView alloc]init];
        self.imageView.frame = CGRectMake(AlertW/2-20, 30, 40, 40);
        self.imageView.image = [UIImage imageNamed:@"warning"];
        [self.alertView addSubview:self.imageView];
        
        //文字
        self.msgLabel = [[UILabel alloc]init];
        self.msgLabel.frame = CGRectMake(AlertW/2-77, CGRectGetMaxY(self.imageView.frame)+26.55, 154, 20);
        self.msgLabel.adjustsFontSizeToFitWidth = YES;
        self.msgLabel.textAlignment = NSTextAlignmentCenter;
        self.msgLabel.text = title;
        self.msgLabel.textColor = RGBCOLOR(102, 102, 102);
        self.msgLabel.backgroundColor = [UIColor clearColor];
        [self.alertView addSubview:self.msgLabel];
        
        //横线
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = CGRectMake(0, AlertH-50.5, AlertW, 1);
        self.lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        [self.alertView addSubview:self.lineView];
        
        //取消按钮
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.cancleBtn.frame = CGRectMake(0,CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2, 49.5);
        [self.cancleBtn setBackgroundColor:[UIColor whiteColor]];
        [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.cancleBtn setTitleColor:RGBCOLOR(42, 42, 42) forState:UIControlStateNormal];
        self.cancleBtn.tag = 1;
        [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        //
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancleBtn.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5.0, 5.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.cancleBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        self.cancleBtn.layer.mask = maskLayer;
        [self.alertView addSubview:self.cancleBtn];

        //竖线
        self.verLineView = [[UIView alloc] init];
        self.verLineView.frame = CGRectMake(AlertW/2, AlertH-50.5, 1, 49.5);
        self.verLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        [self.alertView addSubview:self.verLineView];
        
        //确认按钮
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.verLineView.frame), CGRectGetMaxY(self.lineView.frame), AlertW/2-1, 49.5);
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:RGBCOLOR(120, 148, 249) forState:UIControlStateNormal];
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.sureBtn setBackgroundColor:[UIColor whiteColor]];
        self.sureBtn.tag = 2;
        [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        //
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = self.sureBtn.bounds;
        maskLayer1.path = maskPath1.CGPath;
        self.sureBtn.layer.mask = maskLayer1;

        [self.alertView addSubview:self.sureBtn];
        
        
        //计算高度
        //CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, AlertH);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
        
        
    }
    
    return self;
}


#pragma mark - 回调 -设置只有2 -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 2) {
        if (self.resultIndex) {
            self.resultIndex(sender.tag);
        }
    }
    [self removeFromSuperview];
}


//展示
-(void)showAlertView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
    }];
}

@end
