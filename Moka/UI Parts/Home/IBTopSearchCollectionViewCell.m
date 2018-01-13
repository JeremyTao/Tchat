//
//  IBTopSearchCollectionViewCell.m
//  InnerBuy
//
//  Created by Knight on 5/5/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "IBTopSearchCollectionViewCell.h"

@interface IBTopSearchCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *roundCornerBGLabel;


@end

@implementation IBTopSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _roundCornerBGLabel.backgroundColor  = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.00];
//    _roundCornerBGLabel.layer.cornerRadius = 4;
//    _roundCornerBGLabel.layer.masksToBounds = YES;
//    [_roundCornerBGLabel.layer setBorderWidth:0.8];
//    CGColorSpaceRef colorSapceRef = CGColorSpaceCreateDeviceRGB();
//    CGColorRef color = CGColorCreate(colorSapceRef, (CGFloat[]){0.8, 0.8, 0.8, 1});
//    [_roundCornerBGLabel.layer setBorderColor:color];

    // Initialization code
}



@end
