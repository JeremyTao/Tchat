//
//  MKMemberDetailInfoTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/7.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKMemberDetailInfoTableViewCell.h"
#import "PYSearchConst.h"
#import "MKInterestTagModel.h"

@interface MKMemberDetailInfoTableViewCell ()

{
    NSMutableArray *myTagsArray;    //我的标签
    NSMutableArray *myHobbyArray;    //我的爱好
    NSArray *tagsArr;
    NSArray *hobbyArr;
}

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLine;

//来自
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLine;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHeight;
//行业
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;

@property (weak, nonatomic) IBOutlet UIView *industryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *industryViewHeight;

//我的标签
@property (weak, nonatomic) IBOutlet UIView *myTagsBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *myTagRoundCell;

@property (weak, nonatomic) IBOutlet UIView *myTagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTagsViewHeight;


//爱好

@property (weak, nonatomic) IBOutlet UIView *hobbyBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *hobbyCell;

@property (weak, nonatomic) IBOutlet UIView *hobbyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hobbyViewHeight;


@end

@implementation MKMemberDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createTags];
}

- (void)comfigUserDetailInfoWith:(MKPeopleRootModel *)userModel {
    _birthdayLabel.text = userModel.birthday;
    if (userModel.address.length > 0) {
        _addressLabel.text = userModel.address;
        _addressView.alpha = 1;
        _addressViewHeight.constant = 44;
        _birthdayLine.hidden = NO;
    } else {
        _addressView.alpha = 0;
        _addressViewHeight.constant = 0;
        _birthdayLine.hidden = YES;
    }
    
    if (userModel.industryName.length > 0) {
        _industryLabel.text = userModel.industryName;
        _industryView.alpha = 1;
        _industryViewHeight.constant = 44;
        _addressLine.hidden = NO;
    } else {
        _industryView.alpha = 0;
        _industryViewHeight.constant = 0;
        //隐藏来自的线
        _addressLine.hidden = YES;
    }
    
    
    
    //我的标签
    [myTagsArray removeAllObjects];
    for (MKInterestTagModel *tagModel in userModel.mylableList) {
        [myTagsArray addObject:tagModel.name];
    }
    
    [self removeTagsWith:tagsArr];
    tagsArr = [self createMovieLabelsWithContentView:_myTagsView
                                    layoutConstraint:_myTagsViewHeight
                                           tagsArray:myTagsArray];
    //我的爱好
    [myHobbyArray removeAllObjects];
    for (MKInterestTagModel *tagModel in userModel.filmList) {
        [myHobbyArray addObject:tagModel.name];
    }
    
    for (MKInterestTagModel *tagModel in userModel.foodList) {
        [myHobbyArray addObject:tagModel.name];
    }
    
    for (MKInterestTagModel *tagModel in userModel.motionList) {
        [myHobbyArray addObject:tagModel.name];
    }
    
    [self removeTagsWith:hobbyArr];
    hobbyArr = [self createMovieLabelsWithContentView:_hobbyView
                                     layoutConstraint:_hobbyViewHeight
                                            tagsArray:myHobbyArray];
}

- (void)removeTagsWith:(NSArray *)arr {
    for (UILabel *label in arr) {
        [label removeFromSuperview];
    }
}


- (void)createTags {
    myTagsArray = @[].mutableCopy;
    myHobbyArray = @[].mutableCopy;
}

#pragma mark - 创建标签
- (NSArray *)createMovieLabelsWithContentView:(UIView *)contentView layoutConstraint:(NSLayoutConstraint *)heightConstraint tagsArray:(NSArray *)tagTexts {
    if (tagTexts.count == 0) {
        return nil;
    }
    
    
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        [contentView addSubview:label];
        [tagsM addObject:label];
    }
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    CGFloat offsetX = 15;
    CGFloat offsetY = -3;
    
    
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        // When the number of search words is too large, the width is width of the contentView
        if (subView.py_width > contentView.py_width) subView.py_width = contentView.py_width;
        if (currentX + subView.py_width + PYSEARCH_MARGIN * countRow > contentView.py_width) {
            subView.py_x = offsetX;
            subView.py_y = (currentY += subView.py_height) + PYSEARCH_MARGIN * ++countCol + offsetY;
            currentX = subView.py_width;
            countRow = 1;
        } else {
            subView.py_x = (currentX += subView.py_width) - subView.py_width + PYSEARCH_MARGIN * countRow + offsetX;
            subView.py_y = currentY + PYSEARCH_MARGIN * countCol + offsetY;
            countRow ++;
        }
    }
    
    contentView.py_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    heightConstraint.constant = contentView.py_height + 10;
    
    [self layoutIfNeeded];
    //设置边框
    for (UILabel *tag in tagsM) {
        tag.backgroundColor = [UIColor clearColor];
        tag.layer.borderColor = RGB_COLOR_HEX(0xC4D0FF).CGColor;
        tag.layer.borderWidth = 1;
        tag.layer.cornerRadius = tag.py_height * 0.5;
    }
    
    return tagsM;
}


- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = RGB_COLOR_HEX(0x666666);
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.py_width += 30;
    label.py_height += 20;
    return label;
}




@end
