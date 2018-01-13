//
//  MKTagsCollectionViewCell.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKTagsCollectionViewCell.h"

@interface MKTagsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *fillImageView;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation MKTagsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configWith:(NSString *)str {
    _tagLabel.text = str;
}


//- (void)configCellWith:(CBCommentLabelModel *)model {
//    myLabelModel = model;
//    _descriptionLabel.text = model.label;
//}

- (IBAction)selectButtonClicked:(UIButton *)sender {
//    if (myLabelModel.select) {
//        //改为未选中
//        _descriptionLabel.backgroundColor = [UIColor blackColor];
//        self.descriptionLabel.layer.borderWidth = 1;
//        myLabelModel.select = 0;
//        _removeIcon.hidden = YES;
//    } else {
//        //改为选中
//        _descriptionLabel.backgroundColor = [UIColor colorWithRed:0.902 green:0.290 blue:0.212 alpha:1.00];
//        self.descriptionLabel.layer.borderWidth = 0;
//        myLabelModel.select = 1;
//        _removeIcon.hidden = NO;
//    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        _fillImageView.image = IMAGE(@"tag_fill");
        _tagLabel.textColor = [UIColor whiteColor];
    } else {
        _fillImageView.image = IMAGE(@"tag_line");
        _tagLabel.textColor = RGB_COLOR_HEX(0x666666);
    }
}


@end
