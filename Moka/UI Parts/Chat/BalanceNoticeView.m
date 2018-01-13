//
//  BalanceNoticeView.m
//  Moka
//
//  Created by btc123 on 2017/12/29.
//  Copyright © 2017年 moka. All rights reserved.
//


#define AlertW 250.0
#define AlertH 212.5

#import "BalanceNoticeView.h"

@interface BalanceNoticeView()<UITextFieldDelegate>

//弹窗
@property (nonatomic,retain) UIView *alertView;
//图片
@property (nonatomic,retain) UIImageView *cancleImageView;
//标题
@property (nonatomic,retain) UILabel *titleLabel;
//分割线
@property (nonatomic,retain) UIView *lineView;
//余额
@property (nonatomic,retain) UILabel *balanceLabel;
//文本框
@property (nonatomic,retain) UITextField *crashTextField;
//立即按钮
@property (nonatomic,retain) UIButton * sureBtn;

@end

@implementation BalanceNoticeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initAlertView:(NSString *)title balance:(NSString *)myBalance{
    
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
        self.cancleImageView = [[UIImageView alloc]init];
        self.cancleImageView.frame = CGRectMake(10, 17, 16, 16);
        self.cancleImageView.image = [UIImage imageNamed:@"rp_close"];
        [self.alertView addSubview:self.cancleImageView];
        
        self.cancleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self.cancleImageView addGestureRecognizer:tapGesture];
        
        //标题
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.frame = CGRectMake(AlertW/2-34, 17, 68, 16);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = RGBCOLOR(42, 42, 42);
        [self.alertView addSubview:self.titleLabel];
        
        //横线
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = CGRectMake(0, 50.0, AlertW, 1);
        self.lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        [self.alertView addSubview:self.lineView];
        
        //余额
        self.balanceLabel = [[UILabel alloc]init];
        self.balanceLabel.frame = CGRectMake(15, CGRectGetMaxY(self.lineView.frame)+20, AlertW-30, 12);
        self.balanceLabel.text = myBalance;
        self.balanceLabel.adjustsFontSizeToFitWidth = YES;
        self.balanceLabel.textAlignment = NSTextAlignmentLeft;
        self.balanceLabel.font = [UIFont systemFontOfSize:12.0f];
        self.balanceLabel.backgroundColor = [UIColor clearColor];
        self.balanceLabel.textColor = RGBCOLOR(74, 74, 74);
        [self.alertView addSubview:self.balanceLabel];
        
        //文本框
        self.crashTextField = [[UITextField alloc]init];
        self.crashTextField.frame = CGRectMake(15, CGRectGetMaxY(self.balanceLabel.frame)+10, AlertW-30, 35);
        self.crashTextField.backgroundColor = RGBCOLOR(244, 244, 244);
        self.crashTextField.placeholder = @"请输入充值金额";
        self.crashTextField.font = [UIFont systemFontOfSize:12.0f];
        self.crashTextField.textAlignment = NSTextAlignmentLeft;
        self.crashTextField.borderStyle = UITextBorderStyleNone;
        self.crashTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.crashTextField.adjustsFontSizeToFitWidth = YES;
        self.crashTextField.keyboardType = UIKeyboardTypeDecimalPad;
        self.crashTextField.returnKeyType = UIReturnKeyDone;
        self.crashTextField.delegate = self;
        CGRect frame = self.crashTextField.frame;
        frame.size.width = 5.0f;
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        self.crashTextField.leftViewMode = UITextFieldViewModeAlways;
        self.crashTextField.leftView = leftview;
        [self.alertView addSubview:self.crashTextField];
        
        //确认按钮
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.sureBtn.frame = CGRectMake(15, CGRectGetMaxY(self.crashTextField.frame)+30, AlertW-30, 40.0);
        [self.sureBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        self.sureBtn.layer.cornerRadius = 20.0f;
        [self.sureBtn setBackgroundColor:RGBCOLOR(120, 148, 249)];
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
        self.alertView.frame = CGRectMake(0, 0, AlertW, AlertH);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
        
    }
    
    return self;
}



-(void)tap:(UITapGestureRecognizer *)taps{
    
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


#pragma mark - 回调 -设置只有2 -- > 确定才回调
-(void)buttonEvent:(UIButton *)sender{
    
    if (sender.tag == 2) {
        if (self.resultText) {
            self.resultText(self.crashTextField.text);
        }
    }
    [self removeFromSuperview];
    
}


#pragma mark -- UITextFieldDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.alertView endEditing:YES];
}

@end
