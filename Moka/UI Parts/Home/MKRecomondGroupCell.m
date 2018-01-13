//
//  MKRecomondGroupCell.m
//  Moka
//
//  Created by Knight on 2017/7/20.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKRecomondGroupCell.h"

@interface MKRecomondGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *circleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *circlePeopleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UILabel *circleIntroduceLabel;


@end

@implementation MKRecomondGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configCellWith:(MKCircleListModel *)model {
    _circleImageView.image = nil;
    [_circleImageView setImageUPSUrl:model.imgs];
    _circleNameLabel.text = model.name;
    _tagLabel.text = model.lableids;
    _circleIntroduceLabel.text = model.introduce;
    _circlePeopleCountLabel.text = [NSString stringWithFormat:@"%ld人", (long)model.count];
}


@end
