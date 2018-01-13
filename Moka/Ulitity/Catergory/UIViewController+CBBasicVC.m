//
//  UIViewController+CBBasicVC.m
//  CrunClub
//
//  Created by 郑克 on 16/3/11.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "UIViewController+CBBasicVC.h"


@implementation UIViewController (CBBasicVC)

-(void)close{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)clearNavi{
    
    
    
    
}
-(void)setCommeNaviGationBar:(NSString *)title and:(BOOL)isPush{
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *topView = [MyControlUIParts createViewWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 64)) andBGColcor:[UIColor whiteColor] andRadius:0];
    
    UILabel *titleLable = [MyControlUIParts createLabelWithFrame:(CGRectMake(0, 0, 150, 44)) Font:17.0f Text:title];
    titleLable.center = CGPointMake(SCREEN_WIDTH / 2, 44);
    titleLable.textColor = commonDarkGrayColor;
    [topView addSubview:titleLable];
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 64 - 1, SCREEN_WIDTH, 0.5))];
    myView.backgroundColor = [UIColor colorWithWhite:0.749 alpha:1.000];
    [topView addSubview:myView];
    [self.view addSubview:topView];
    
    UIImageView *backImage = [MyControlUIParts createImageViewFrame:(CGRectMake(0, 0, 25, 25)) imageName:@"back_bule"];
    backImage.center = CGPointMake(24, 44);
    
    UIButton *backBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 100, 64)) target:self SEL:@selector(popBtn) title:@"" andBG:nil andRadius:0 andTitleColor:nil andtitleFont:0];
    UIButton *backdBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 60, 44)) target:self SEL:@selector(popdBtn) title:@"关闭" andBG:nil andRadius:0 andTitleColor:[UIColor colorWithWhite:0.35 alpha:1.000] andtitleFont:[UIFont systemFontOfSize:15.0f]];
    backdBtn.center = CGPointMake(SCREEN_WIDTH - 30, 44);

    if (!isPush) {
        
        [topView addSubview:backBtn];
        [topView addSubview:backImage];

    }else{
        
        [self.view addSubview:backdBtn];

    }
    
}
-(void)popdBtn{
    [self dismissViewControllerAnimated:YES completion:nil];

    
    
}
-(void)setNoback:(NSString *)title{
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *topView = [MyControlUIParts createViewWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 64)) andBGColcor:[UIColor whiteColor] andRadius:0];
    
    UILabel *titleLable = [MyControlUIParts createLabelWithFrame:(CGRectMake(0, 0, 150, 44)) Font:17.0f Text:title];
    titleLable.center = CGPointMake(SCREEN_WIDTH / 2, 44);
    titleLable.textColor = commonDarkGrayColor;
    [topView addSubview:titleLable];
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 64 - 1, SCREEN_WIDTH, 0.5))];
    myView.backgroundColor = [UIColor colorWithWhite:0.749 alpha:1.000];
    [topView addSubview:myView];
    [self.view addSubview:topView];
    
    UIImageView *backImage = [MyControlUIParts createImageViewFrame:(CGRectMake(0, 0, 25, 25)) imageName:@"back_bule"];
    backImage.center = CGPointMake(24, 44);
//    [topView addSubview:backImage];
    
//    UIButton *backBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 100, 64)) target:self SEL:@selector(popBtn) title:@"" andBG:nil andRadius:0 andTitleColor:nil andtitleFont:0];
    
//    [topView addSubview:backBtn];
}
-(void)setCommeNaviGationBar:(NSString *)title{
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *topView = [MyControlUIParts createViewWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 64)) andBGColcor:[UIColor whiteColor] andRadius:0];
    
    UILabel *titleLable = [MyControlUIParts createLabelWithFrame:(CGRectMake(0, 0, 150, 44)) Font:17.0f Text:title];
    titleLable.center = CGPointMake(SCREEN_WIDTH / 2, 44);
    titleLable.textColor = commonDarkGrayColor;
    [topView addSubview:titleLable];
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 64 - 1, SCREEN_WIDTH, 0.5))];
    myView.backgroundColor = [UIColor colorWithWhite:0.749 alpha:1.000];
    [topView addSubview:myView];
    [self.view addSubview:topView];
    
    UIImageView *backImage = [MyControlUIParts createImageViewFrame:(CGRectMake(0, 0, 25, 25)) imageName:@"back_bule"];
    backImage.center = CGPointMake(24, 44);
    [topView addSubview:backImage];
    
    UIButton *backBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 100, 64)) target:self SEL:@selector(popBtn) title:@"" andBG:nil andRadius:0 andTitleColor:nil andtitleFont:0];
    
    [topView addSubview:backBtn];
    
}
-(void)setCommeNaviGationBar:(NSString *)title andRightbtnImage:(NSString *)rightName andTarget:(id)target SEL:(SEL)method {
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *topView = [MyControlUIParts createViewWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 64)) andBGColcor:[UIColor whiteColor] andRadius:0];
    
    UILabel *titleLable = [MyControlUIParts createLabelWithFrame:(CGRectMake(0, 0, 150, 44)) Font:17.0f Text:title];
    titleLable.center = CGPointMake(SCREEN_WIDTH / 2, 44);
    titleLable.textColor = commonDarkGrayColor;
    [topView addSubview:titleLable];
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 64 - 1, SCREEN_WIDTH, 0.5))];
    myView.backgroundColor = [UIColor colorWithWhite:0.749 alpha:1.000];
    [topView addSubview:myView];
    [self.view addSubview:topView];
    
    UIImageView *backImage = [MyControlUIParts createImageViewFrame:(CGRectMake(0, 0, 25, 25)) imageName:@"back_bule"];
    backImage.center = CGPointMake(24, 44);
    [topView addSubview:backImage];
    
    UIButton *backBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 100, 64)) target:self SEL:@selector(popBtn) title:@"" andBG:nil andRadius:0 andTitleColor:nil andtitleFont:0];
    
    [topView addSubview:backBtn];
    
    UIButton *rightBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 60, 44)) target:target SEL:method title:nil andBG:nil andRadius:0 andTitleColor:[UIColor darkGrayColor] andtitleFont:[UIFont systemFontOfSize:17.0]];
    rightBtn.center = CGPointMake(SCREEN_WIDTH - 30, 44);
    [rightBtn setTitle:rightName forState:(UIControlStateNormal)];
    [topView addSubview:rightBtn];
    
}
-(void)setNewNavi:(NSString *)title andBackCoLor:(UIColor *)color andImageName:(NSString *)name andTileColor:(UIColor *)titleColor lineViewColor:(UIColor *)lineColor{
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *topView = [MyControlUIParts createViewWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 64)) andBGColcor:color andRadius:0];
    
    UILabel *titleLable = [MyControlUIParts createLabelWithFrame:(CGRectMake(0, 0, 150, 44)) Font:18.0f Text:title];
    titleLable.center = CGPointMake(SCREEN_WIDTH / 2, 44);
    titleLable.textColor = commonDarkGrayColor;
    [topView addSubview:titleLable];
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 64 - 1, SCREEN_WIDTH, 0.5))];
    myView.backgroundColor = lineColor;
    [topView addSubview:myView];
    [self.view addSubview:topView];
    
    UIImageView *backImage = [MyControlUIParts createImageViewFrame:(CGRectMake(0, 0, 25, 25)) imageName:name];
    backImage.center = CGPointMake(24, 44);
    [topView addSubview:backImage];
    
    UIButton *backBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 100, 64)) target:self SEL:@selector(popBtn) title:@"" andBG:nil andRadius:0 andTitleColor:nil andtitleFont:0];
    
    [topView addSubview:backBtn];
        
}

-(void)setNewNavi:(NSString *)title andBackCoLor:(UIColor *)color andImageName:(NSString *)name andRightbtnTitle:(NSString *)rightName andTarget:(id)target SEL:(SEL)method andRBtnColor:(UIColor *)rightColor andTileColor:(UIColor *)titleColor lineViewColor:(UIColor *)lineColor{
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *topView = [MyControlUIParts createViewWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 64)) andBGColcor:color andRadius:0];
    UILabel *titleLable = [MyControlUIParts createLabelWithFrame:(CGRectMake(0, 0, 150, 44)) Font:17.0f Text:title];
    titleLable.center = CGPointMake(SCREEN_WIDTH / 2, 44);
    titleLable.textColor = commonDarkGrayColor;

    [topView addSubview:titleLable];
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 64 - 1, SCREEN_WIDTH, 0.5))];
    myView.backgroundColor = lineColor;
    [topView addSubview:myView];
    [self.view addSubview:topView];
    
    UIImageView *backImage = [MyControlUIParts createImageViewFrame:(CGRectMake(0, 0, 16, 16)) imageName:name];
    backImage.center = CGPointMake(SCREEN_WIDTH - 31.5, 44);
    [topView addSubview:backImage];
    
    UIButton *backBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 100, 64)) target:self SEL:@selector(popBtn) title:@"" andBG:nil andRadius:0 andTitleColor:nil andtitleFont:0];
    
    [topView addSubview:backBtn];
    
    UIButton *rightBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 60, 44)) target:target SEL:method title:rightName andBG:nil andRadius:0 andTitleColor:rightColor andtitleFont:[UIFont systemFontOfSize:17.0]];
    rightBtn.center = CGPointMake(SCREEN_WIDTH - 30, 44);
    [topView addSubview:rightBtn];
}
-(void)popBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setNewNavi:(NSString *)title andBackCoLor:(UIColor *)color andImageName:(NSString *)name andleftandTarget:(id)rtarget SEL:(SEL)rmethod andRightbtnTitle:(NSString *)rightName andTarget:(id)target SEL:(SEL)method andRBtnColor:(UIColor *)rightColor andTileColor:(UIColor *)titleColor lineViewColor:(UIColor *)lineColor{
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *topView = [MyControlUIParts createViewWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 64)) andBGColcor:color andRadius:0];
    UILabel *titleLable = [MyControlUIParts createLabelWithFrame:(CGRectMake(0, 0, 150, 44)) Font:17.0f Text:title];
    titleLable.center = CGPointMake(SCREEN_WIDTH / 2, 44);
    titleLable.textColor = commonDarkGrayColor;
    
    [topView addSubview:titleLable];
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 64 - 1, SCREEN_WIDTH, 0.5))];
    myView.backgroundColor = lineColor;
    [topView addSubview:myView];
    [self.view addSubview:topView];
    
    UIImageView *backImage = [MyControlUIParts createImageViewFrame:(CGRectMake(0, 0, 25, 25)) imageName:name];
    backImage.center = CGPointMake(24, 44);
    [topView addSubview:backImage];
    
    UIButton *backBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 100, 64)) target:rtarget SEL:rmethod title:@"" andBG:nil andRadius:0 andTitleColor:nil andtitleFont:0];
    
    [topView addSubview:backBtn];
    
    UIButton *rightBtn = [MyControlUIParts createButtonWithFrame:(CGRectMake(0, 0, 60, 44)) target:target SEL:method title:rightName andBG:nil andRadius:0 andTitleColor:rightColor andtitleFont:[UIFont systemFontOfSize:15.0]];
    
    rightBtn.center = CGPointMake(SCREEN_WIDTH - 30, 44);
    [topView addSubview:rightBtn];
}
#pragma  mark 设置导航栏字体颜色白色
- (void)setupNavigationBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 44 - 1, SCREEN_WIDTH, 1))];
    myView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar addSubview:myView];
}
#pragma  mark 设置导航栏字体颜色黑色
- (void)setupNavigationBarBlack
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.35 alpha:1.000]}];
    
    UIView *myLineView = [[UIView alloc]initWithFrame:(CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5))];
    myLineView.backgroundColor = [UIColor colorWithWhite:0.749 alpha:1.000];
    
    [self.view addSubview:myLineView];
    
}

- (void)setBlueStyleNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.157 green:0.714 blue:0.902 alpha:1.00];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *attributesDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:18 weight:0.5]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributesDic];
}

- (void)setWhiteStyleNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    NSDictionary *attributesDic = @{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:18 weight:0.5]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributesDic];
}

- (void)setBlackStyleNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *attributesDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:18 weight:0.5]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributesDic];
}

#pragma  mark 设置NaviGationBar
-(void)setLeftNaviBar{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_bule"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBtnClick:)];
    
}
#pragma  mark 设置NaviGationBar
-(void)setLeftNaviBarRed{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_bule"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBtnClick:)];
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 44 - 1.5, SCREEN_WIDTH, 1.5))];
    myView.backgroundColor = commeColor;
    
    [self.navigationController.navigationBar addSubview:myView];
    
    
}
#pragma  mark 设置NaviGationBar
-(void)setLeftNaviBarIteam{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_bule"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBtnClick:)];
    
}
#pragma  mark 设置导航栏
- (void)setNavigationBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.200 alpha:1.000]}];
    
    
    UIView *myView = [[UIView alloc]initWithFrame:(CGRectMake(0, 44 - 1.5, SCREEN_WIDTH, 1.5))];
    myView.backgroundColor = [UIColor clearColor];

    [self.navigationController.navigationBar addSubview:myView];
}
-(void)leftBtnClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 切圆角
-(void)creatCircle:(UIButton *)sender{
    
    sender.layer.cornerRadius = 15;
    sender.layer.masksToBounds = YES;
    [self.view addSubview:sender];
    
    
}
#pragma mark 设置导航栏不透明
- (NSString *)cacheStringWithSDCache:(NSInteger)cacheSize{
    
    if (cacheSize == 0) {
        return @"    暂无缓存";
    }
    
    if (cacheSize > 0 && cacheSize < 1024) {
        return [NSString stringWithFormat:@"%d B",(int)cacheSize];
    }else if (cacheSize < 1024 * 1024){
        return [NSString stringWithFormat:@"%.2f KB",cacheSize / 1024.0];
    }else if (cacheSize < 1024 * 1024 * 1024){
        return [NSString stringWithFormat:@"%.2f MB",cacheSize / (1024.0 * 1024.0)];
    }else{
        return [NSString stringWithFormat:@"%.2f G",cacheSize / (1024.0 * 1024.0 * 1024.0)];
    }
    
    return nil;
}
-(void)SetNoAphr{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = commonLightColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
#pragma mark 设置导航栏透明
-(void)setNaviAphr{
    //去掉导航栏底部的线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //设置导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsCompact];
    
}
/*
#pragma mark 密码加密
-(NSString *)getPassWord:(NSString *)str{
    
    NSString *tempUrl = [Tool md532BitUpper:str];
    NSString *tempStr = [NSString stringWithFormat:@"inbuy%@",tempUrl];
    NSString *passWord = [Tool md532BitUpper:tempStr];
    return passWord;
 
}
   */
#pragma mark 数字滚动
-(void)updateUIWithOne:(NSString *)one andTwo:(NSString *)two and:(UILabel *)senderLable{
    
    POPBasicAnimation *animation = [POPBasicAnimation animation];
    animation.property = [self animationPropertyand:senderLable];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.12 :1: 0.11:0.94];
    NSNumber *a = [[NSNumber alloc] initWithInteger:[one integerValue]];
    NSNumber *b = [[NSNumber alloc] initWithInteger:[two integerValue]];
    animation.fromValue = a;
    animation.toValue = b;
    [senderLable pop_addAnimation:animation forKey:@"numberLabelAnimation"];
}
#pragma mark - 数字滚动animation
- (POPMutableAnimatableProperty *)animationPropertyand:(UILabel *)senderLable {
    return [POPMutableAnimatableProperty
            propertyWithName:@"com.curer.test"
            initializer:^(POPMutableAnimatableProperty *prop) {
                prop.writeBlock = ^(id obj, const CGFloat values[]) {
                    NSNumber *number = @(values[0]);
                    int num = [number intValue];
                    senderLable.text = [@(num) stringValue];
                };
            }];
}
/**
 *  抖动效果
 *
 *  @param view 要抖动的view
 */
- (void)shakeAnimationForView:(UIView *) view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 1, position.y);
    CGPoint y = CGPointMake(position.x - 1, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

- (void)pushViewController:(Class)vc_class {
    
    id newInstance = [vc_class new];
    if ([newInstance isKindOfClass:[UIViewController class]]) {
        UIViewController * pushVC = newInstance;
        pushVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushVC animated:YES];
    }
    
}

- (void)playConstraintsChangeAnimation {
    // 让自动布局的UIView显示动画
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
