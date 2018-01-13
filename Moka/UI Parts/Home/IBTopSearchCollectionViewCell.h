//
//  IBTopSearchCollectionViewCell.h
//  InnerBuy
//
//  Created by Knight on 5/5/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TopCellStyle,
    HistoryCellStyle
} SearchCellStyle;

@interface IBTopSearchCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;



@end
