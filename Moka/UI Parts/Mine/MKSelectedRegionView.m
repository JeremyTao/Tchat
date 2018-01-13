//
//  MKSelectedRegionView.m
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSelectedRegionView.h"

@interface MKSelectedRegionView ()

@property (weak, nonatomic) IBOutlet UIImageView *selectionImg;



@end

@implementation MKSelectedRegionView

+ (instancetype)newRegionView {
    MKSelectedRegionView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKSelectedRegionView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKSelectedRegionView class]]) {
        
        return customView;
    }
    else
        return nil;
}

- (void)configAddress:(NSString *)address {
    _addressLabel.text = address;
}

- (IBAction)selectChinaAdressButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOnChinaAdress)]) {
        [self.delegate didClickedOnChinaAdress];
    }
}

- (void)clearSelection {
    _selectionImg.image = nil;
}

- (void)selected {
    _selectionImg.image = IMAGE(@"choose");
}

@end
