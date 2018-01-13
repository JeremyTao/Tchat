//
//  CBNavigationView.m
//  CrunClub
//
//  Created by Knight on 7/15/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "CBNavigationView.h"

#define  NavigationViewFrame  CGRectMake(0, 0, SCREEN_WIDTH, 64)

@interface CBNavigationView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITextField *serchTextField;
@property (nonatomic, strong) UIImageView *naviImageView;
@end

@implementation CBNavigationView


- (instancetype)initWithTitle:(NSString *)title delegate:(id)delegate
{
    self = [super initWithFrame:NavigationViewFrame];
    if (self) {
        self.frame = NavigationViewFrame;
        
        [self initUserInterfaceWithTitle:title];
        self.delegate = delegate;
    }
    return self;
}

- (void)initUserInterfaceWithTitle:(NSString *)title {
    _backgroundView = ({
        UIView *backgroundView = [[UIView alloc] initWithFrame:NavigationViewFrame];
        backgroundView.backgroundColor =  [UIColor whiteColor];
        [self addSubview:backgroundView];
//        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//        
//        gradientLayer.colors = @[(__bridge id)RGB_COLOR_HEX(0xa58dff).CGColor,(__bridge id)RGB_COLOR_HEX(0x7894f9).CGColor];
//        
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(1, 1);
//        
//        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(backgroundView.frame), CGRectGetHeight(backgroundView.frame));
//        
//        [backgroundView.layer addSublayer:gradientLayer];
        
        _naviImageView = [[UIImageView alloc] initWithFrame:backgroundView.bounds];
        [backgroundView addSubview:_naviImageView];
        _naviImageView.image = [UIImage imageNamed:@"navibar"];
        backgroundView;
    });
    
    //[self showNavigationBarShadow];
    
    _titleLabel = ({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text  = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:0.5];
        [_backgroundView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backgroundView.mas_top).offset(20);
            make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
            make.left.equalTo(_backgroundView.mas_left).offset(50);
            make.right.equalTo(_backgroundView.mas_right).offset(-50);
        }];
        titleLabel;
    });
    
    
    _backButton = ({
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backgroundView addSubview:backButton];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(11, 10, 10, 15);
        [backButton setImage:[UIImage imageNamed:@"near_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backgroundView.mas_top).offset(20);
            make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
            make.left.equalTo(_backgroundView.mas_left).offset(0);
            make.right.equalTo(_titleLabel.mas_left).offset(0);
        }];
        
        backButton;
    });
    
    _line = ({
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor colorWithRed:0.844 green:0.844 blue:0.844 alpha:1.00];
        [_backgroundView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
            make.left.equalTo(_backgroundView.mas_left).offset(0);
            make.right.equalTo(_backgroundView.mas_right).offset(0);
        }];
        line;
    });
    
    [self setNavigationViewStyle:NavigationBarStyleWhite];
}



- (void)setNavigationViewStyle:(NavigationBarStyle)style {    
    switch (style) {
            case NavigationBarStyleBlue: {
                _backgroundView.backgroundColor = [UIColor blueColor];
                _titleLabel.textColor = [UIColor whiteColor];
                [_backButton setImage:[UIImage imageNamed:@"near_back"] forState:UIControlStateNormal];
                _line.backgroundColor = [UIColor clearColor];
            }  break;
            
            case NavigationBarStyleWhite: {
                _backgroundView.backgroundColor = [UIColor whiteColor];
                _titleLabel.textColor = [UIColor whiteColor];
                [_backButton setImage:[UIImage imageNamed:@"near_back"] forState:UIControlStateNormal];
                _line.backgroundColor = [UIColor clearColor];
            }  break;
            
            case NavigationBarStyleBlack: {
                _backgroundView.backgroundColor = [UIColor clearColor];
                _titleLabel.textColor = [UIColor whiteColor];
                [_backButton setImage:[UIImage imageNamed:@"near_back"] forState:UIControlStateNormal];
                _naviImageView.hidden = YES;
                _line.backgroundColor = [UIColor clearColor];
            } break;
            
        case NavigationBarStyleRed: {
            _backgroundView.backgroundColor = [UIColor colorWithRed:0.910 green:0.204 blue:0.188 alpha:1.00];
            _titleLabel.textColor = [UIColor whiteColor];
            [_backButton setImage:[UIImage imageNamed:@"near_back"] forState:UIControlStateNormal];
            
            _line.backgroundColor = [UIColor clearColor];
        } break;
            
        default:  break;
    }

}

- (void)backButtonTapped:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    
    }
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setCenterImageViewWithName:(NSString *)imageName {
    _titleLabel.text = @"";
    UIImageView *centerImageView = [[UIImageView alloc] init];
    centerImageView.image = [UIImage imageNamed:imageName];
    [_backgroundView addSubview:centerImageView];
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).offset(20);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
        make.left.equalTo(_backgroundView.mas_left).offset(120);
        make.right.equalTo(_backgroundView.mas_right).offset(-120);
    }];
}

- (void)setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)color imageName:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setTitleColor:color forState:UIControlStateNormal];
    [leftButton setImage:IMAGE(imageName) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton addTarget:target action:action forControlEvents:controlEvents];
    [_backButton removeFromSuperview];
    [_backgroundView addSubview:leftButton];
  
//    CGFloat buttonWidth = 0;//根据文字标题长度 设置按钮宽度
//    if (title.length == 0) {
//        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_backgroundView.mas_top).offset(20);
//            make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
//            make.left.equalTo(_backgroundView.mas_left).offset(0);
//            make.right.equalTo(_titleLabel.mas_left).offset(0);
//        }];
//        return;
//    } else if (title.length == 2) {
//        buttonWidth = 60;
//    } else if (title.length == 4) {
//        buttonWidth = 90;
//    }
    
    if (title.length == 0) {
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backgroundView.mas_top).offset(20);
            make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
            make.left.equalTo(_backgroundView.mas_left).offset(0);
            make.right.equalTo(_titleLabel.mas_left).offset(0);
            }];
        
    } else {
    

        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backgroundView.mas_top).offset(20);
            make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
            make.left.equalTo(_backgroundView.mas_left).offset(12);
            make.right.equalTo(_titleLabel.mas_left).offset(36);
            
        }];
    }
    
}

- (void)setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)color  imageName:(NSString *)imageName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:title forState:UIControlStateNormal];
    
    [_rightButton setTitleColor:color forState:UIControlStateNormal];
    [_rightButton setImage:IMAGE(imageName) forState:UIControlStateNormal];

    [_rightButton addTarget:target action:action forControlEvents:controlEvents];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_backgroundView addSubview:_rightButton];
    
    
    CGFloat buttonWidth = 0;//根据文字标题长度 设置按钮宽度
    if (title.length == 0) {
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backgroundView.mas_top).offset(20);
            make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
            make.left.equalTo(_titleLabel.mas_right).offset(0);
            make.right.equalTo(_backgroundView.mas_right).offset(0);
        }];
        return;
    } else if (title.length == 2) {
        buttonWidth = 60;
    } else if (title.length == 4) {
        buttonWidth = 90;
    }
    
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).offset(20);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(0);
        make.right.equalTo(_backgroundView.mas_right).offset(0);
        make.width.equalTo(@(buttonWidth));
    }];
}

- (void)setSreachBarPlaceholder:(NSString *)placeholder {
    
    self.placeholderLabel.text = placeholder;
    
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithRed:0.967 green:0.460 blue:0.429 alpha:1.00];
            label.font = [UIFont systemFontOfSize:14 weight:0.5];
            [_serchTextField addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_serchTextField.mas_top).offset(0);
                make.bottom.equalTo(_serchTextField.mas_bottom).offset(0);
                make.left.equalTo(_serchTextField.mas_left).offset(30);
                make.right.equalTo(_serchTextField.mas_right).offset(10);
            }];
            label;
        });
    }
    return _placeholderLabel;
}

- (void)hideRightButton {
    _rightButton.hidden = YES;
}

- (void)showRightButton {
    _rightButton.hidden = NO;
}

- (void)setTitleViewWithUrl:(NSString *)imgUrl {
    int width = 804;
    int height = 724;
    NSString *url = [NSString stringWithFormat:@"%@_%dx%d.jpg",imgUrl, width,height];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

- (void)showSearchBarWithDelegate:(id<UITextFieldDelegate>)delegate {
    _serchTextField = [[UITextField alloc] init];
    _serchTextField.backgroundColor = [UIColor colorWithRed:0.753 green:0.165 blue:0.149 alpha:1.00];
    _serchTextField.delegate = delegate;
    
    _serchTextField.borderStyle = UITextBorderStyleNone;
    [_backgroundView addSubview:_serchTextField];
    [_serchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).offset(26);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-8);
        make.left.equalTo(_backgroundView.mas_left).offset(60);
        make.right.equalTo(_backgroundView.mas_right).offset(-60);
    }];
    
    
    UIImageView *searchImage = [[UIImageView alloc] init];
    
    searchImage.image = [[UIImage imageNamed:@"home_Search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [searchImage setTintColor:[UIColor colorWithRed:0.967 green:0.460 blue:0.429 alpha:1.00]];
    
    [_backgroundView addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).offset(32);
        make.left.equalTo(_backgroundView.mas_left).offset(70);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 1)];
    _serchTextField.leftView = view;
    _serchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        [_backgroundView addSubview:_titleImageView];
        [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backgroundView.mas_top).offset(-4);
            make.bottom.equalTo(_backgroundView.mas_bottom).offset(24);
            make.left.equalTo(_backgroundView.mas_left).offset(100);
            make.right.equalTo(_backgroundView.mas_right).offset(-100);
        }];
        
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _titleImageView;
}

//导航栏阴影

- (void)showNavigationBarShadow {
    [MKTool addGrayShadowOnView:self.backgroundView];
}

- (void)removeNavigationBarShadow {
    [MKTool removeShadowOnView:self.backgroundView];
}

@end
