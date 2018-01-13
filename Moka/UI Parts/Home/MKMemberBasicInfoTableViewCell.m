//
//  MKMemberBasicInfoTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/7.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKMemberBasicInfoTableViewCell.h"


@interface MKMemberBasicInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *authenImageView; //认证图标
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView; //性别图标
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UILabel *feelingLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *fansCountButton;
@property (weak, nonatomic) IBOutlet UIButton *attentionCountButton;

@property (weak, nonatomic) IBOutlet UILabel *autographLabel;

@property (weak, nonatomic) IBOutlet UIImageView *expertImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;


@end


@implementation MKMemberBasicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}



- (void)comfigUserBasicInfoWith:(MKPeopleRootModel *)userModel {
    NSString *name = userModel.name ? userModel.name : @"";
    NSString *noteName = userModel.remarksName.length > 0 ? AppendStrings(@"(",userModel.remarksName,@")") : @"";
    _nameLabel.text = [NSString stringWithFormat:@"%@%@", name, noteName];
    _ageLabel.text = [NSString stringWithFormat:@"%ld", (long)userModel.age];
    _userIdLabel.text = [NSString stringWithFormat:@"ID %@", userModel.code];
    //认证
    if (userModel.authentication == 1) {
        //认证
        _authenImageView.image = IMAGE(@"ture_name");
    } else {
        _authenImageView.image = IMAGE(@"dynamic_ture_name");
    }
    
    //性别
    if (userModel.sex == 1) {
        _genderImageView.image = IMAGE(@"near_female");
    } else if (userModel.sex == 2) {
        _genderImageView.image = IMAGE(@"near_male");
    } else {
       _genderImageView.image = nil;
    }
    //情感
    if (userModel.feeling == 1) {
        self.feelingLabel.text = @"单身";
    } else if (userModel.feeling == 2) {
        self.feelingLabel.text = @"已婚";
    } else {
        self.feelingLabel.text = @"";
    }
    
    if (userModel.ifhave) {
        _expertImageView.hidden = NO;
    } else {
        _expertImageView.hidden = YES;
    }
    
    //粉丝，关注数
    [_fansCountButton setTitle:[NSString stringWithFormat:@"    粉丝 %ld    ", (long)userModel.coverCount] forState:UIControlStateNormal];
    [_attentionCountButton setTitle:[NSString stringWithFormat:@"    关注 %ld    ", (long)userModel.count] forState:UIControlStateNormal];
    
    _autographLabel.text = userModel.autograph;
    
}

- (void)configCycleScrollViewWithImageUrls:(NSArray *)imageUrls delegate:(id<SDCycleScrollViewDelegate>)delegate {
    
    if (imageUrls.count > 0) {
        [_topView removeAllSubviews];
    }
    //
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_topView.bounds delegate:delegate placeholderImage:nil and:YES];
    _cycleScrollView.closeLookBigImg = YES;
    _cycleScrollView.isCustomizedDotImage = YES;
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"Carousel_dot_n"];
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"Carousel_dot"];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    //
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    _cycleScrollView.pageDotColor = [UIColor colorWithRed:0.526 green:0.526 blue:0.526 alpha:0.8];
    _cycleScrollView.backgroundColor = [UIColor clearColor];
    _cycleScrollView.delegate = delegate;
    _cycleScrollView.imageURLStringsGroup = imageUrls;
    NSLog(@"---------------%@",imageUrls);
    
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    [_topView addSubview:_cycleScrollView];
    
    if (imageUrls.count <= 1) {
        _cycleScrollView.autoScroll = NO;
    } else {
        _cycleScrollView.autoScroll = YES;
    }
    
    
}


- (IBAction)shareButtonClicked:(UIButton *)sender {
    
}

- (IBAction)fansButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(openFansController)]) {
        [self.delegate openFansController];
    }
}

- (IBAction)followerButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(openFollowersController)]) {
        [self.delegate openFollowersController];
    }
}


@end
