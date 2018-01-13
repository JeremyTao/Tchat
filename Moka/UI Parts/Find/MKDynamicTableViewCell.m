//
//  MKDynamicTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKDynamicTableViewCell.h"
#import "NYTPhotosViewController.h"
#import "IBShowPhoto.h"
#import "PaddingLabel.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "upLoadImageManager.h"

@interface MKDynamicTableViewCell ()

{
    MKDynamicListModel *myDynamicModel;
    NSString *originalImageUrl;
    UIViewController *cellParentVC;
    NSDictionary *attributeDic;
}

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *contentLabel;
@property (weak, nonatomic) IBOutlet YYLabel *yyContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (weak, nonatomic) IBOutlet UIButton *mokaCoinButton;

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) NSMutableArray *photosArray;



@end

@implementation MKDynamicTableViewCell

- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 2.0; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    
    attributeDic = @{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                   NSParagraphStyleAttributeName:paraStyle,
                                   NSForegroundColorAttributeName: RGB_COLOR_HEX(0x2A2A2A)};
    
    _shadowView.layer.masksToBounds = NO;
    _shadowView.layer.shadowColor = RGB_COLOR_HEX(0xCCCCCC).CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 3);
    _shadowView.layer.shadowRadius = 2;
    _shadowView.layer.shadowOpacity = 0.3;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOnImageView:)];
    
    [_contentImageView addGestureRecognizer:tap];
}

- (void)configDynamicCell:(MKDynamicListModel *)model parentViewController:(UIViewController *)parentVC {
    myDynamicModel = model;
    cellParentVC = parentVC;
    _userHeadImageView.image = nil;
    _contentImageView.image = nil;
    [_userHeadImageView setImageUPSUrl:model.img];
    _userNameLabel.text = model.name;
    _dateLabel.text     =  [NSString compareCurrentTime:model.time];
    
   
   
    _contentLabel.attributedText =  [[NSMutableAttributedString alloc] initWithString:myDynamicModel.text ?  myDynamicModel.text : @"" attributes:attributeDic];
    
    [self setupYYLabel];
    
    
    if (model.imgs.length > 0 ) {
        [_contentImageView setImageUPSUrl:model.imgs];
        _imageHeight.constant = 300;
        [self.photosArray removeAllObjects];
        IBShowPhoto *photo = [[IBShowPhoto alloc] init];
        [self.photosArray addObject:photo];
        //
        originalImageUrl = [upLoadImageManager judgeThePathForImages:model.imgs];
        //originalImageUrl = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, model.imgs];
    } else {
        _imageHeight.constant = 0;
        _contentImageView.image = nil;
    }
    
    [self layoutIfNeeded];
    
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.commentnum] forState:UIControlStateNormal];
    [_likesButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.thingnum] forState:UIControlStateNormal];
    [_mokaCoinButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.rewardNum] forState:UIControlStateNormal];
    if (model.ifThing == 1) {
        //点过赞
        [_likesButton setImage:[UIImage imageNamed:@"dynamic_like_fill"] forState:UIControlStateNormal];
    } else {
        [_likesButton setImage:[UIImage imageNamed:@"dynamic_like"] forState:UIControlStateNormal];
    }
    
}

- (void)setupYYLabel {

    //赋值
    _yyContentLabel.attributedText =  [[NSMutableAttributedString alloc] initWithString:myDynamicModel.text ?  myDynamicModel.text : @"" attributes:attributeDic];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
    YYTextHighlight *hi = [YYTextHighlight new];
    [text yy_setColor:RGB_COLOR_HEX(0x7894F9) range:[text.string rangeOfString:@"全文"]];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"全文"]];
    text.yy_font = _yyContentLabel.font;
    //
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    seeMore.userInteractionEnabled = NO;
    [seeMore sizeToFit];
    //
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    _yyContentLabel.truncationToken = truncationToken;
    
}

- (void)setType:(DynamicCellType)type {
    if (type == DynamicCellTypeDetail) {
        _contentLabel.numberOfLines = 0;
        _yyContentLabel.numberOfLines = 0;
        _yyContentLabel.hidden = YES;
    }else {
        _contentLabel.numberOfLines = 3;
        _yyContentLabel.numberOfLines = 3;
        _yyContentLabel.hidden = NO;
    }
}

- (IBAction)giveMokaCoinButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(giveMokaCoinButtonClickedAtIndex:)]) {
        [self.delegate giveMokaCoinButtonClickedAtIndex:_cellRowIndex];
    }
}

- (IBAction)likeDynamicButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeDynamicButtonClickedAtIndex:status:)]) {
        [self.delegate likeDynamicButtonClickedAtIndex:_cellRowIndex status:!myDynamicModel.ifThing];
    }
}
- (IBAction)commentButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentButtonClickedAtIndex:)]) {
        [self.delegate commentButtonClickedAtIndex:_cellRowIndex];
    }
}


- (IBAction)tapUserHeadEvent:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapedUserHeadImageAtIndex:)]) {
        [self.delegate tapedUserHeadImageAtIndex:_cellRowIndex];
    }
}


- (IBAction)moreButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreOptionButtonClickedAtIndex:)]) {
        
        NSLog(@"cellRowIndex = %ld", _cellRowIndex);
        
        [self.delegate moreOptionButtonClickedAtIndex:_cellRowIndex];
        
    }
}

- (void)tapGestureOnImageView:(UITapGestureRecognizer *)sender {
    [cellParentVC.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KeyboradHided" object:nil];
    if (self.photosArray.count > 0) {
        IBShowPhoto *selectPhoto = self.photosArray[0];
        NYTPhotosViewController *photoVC = [[NYTPhotosViewController alloc] initWithPhotos:self.photosArray initialPhoto:selectPhoto];
        
        [cellParentVC presentViewController:photoVC animated:YES completion:nil];
        [self updateImagesOnPhotosViewController:photoVC afterDelayWithPhotos:self.photosArray];
        
    }
}

- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //加载图片
        for (int i = 0; i < photos.count; i ++) {
            IBShowPhoto *photo = photos[i];
           
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            [manager downloadImageWithURL:[NSURL URLWithString:originalImageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    photo.image = image;
                    [photosViewController updateImageForPhoto:photo];
                }
            }];
            
            
        }
        
    });
    
}

@end
