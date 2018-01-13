//
//  MKSelectedRegionView.h
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKSelectedRegionViewDelegate <NSObject>

- (void)didClickedOnChinaAdress;

@end

@interface MKSelectedRegionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) id<MKSelectedRegionViewDelegate> delegate;

+ (instancetype)newRegionView;
- (void)configAddress:(NSString *)address;
- (void)selected;
- (void)clearSelection;

@end
