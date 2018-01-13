//
//  MKNoneJoinedCircleTableViewCell.m
//  Moka
//
//  Created by Knight on 2017/9/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKNoneJoinedCircleTableViewCell.h"

@implementation MKNoneJoinedCircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seeRecomandCircles:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(seeRecomandCirclesButtonClicked)]) {
        [self.delegate seeRecomandCirclesButtonClicked];
    }
}


@end
