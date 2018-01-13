//
//  IBShowPhoto.h
//  InnerBuy
//
//  Created by Knight on 2017/4/13.
//  Copyright © 2017年 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYTPhoto.h"

@interface IBShowPhoto : NSObject<NYTPhoto>

// Redeclare all the properties as readwrite for sample/testing purposes.
@property (nonatomic) UIImage *image;
@property (nonatomic) NSData *imageData;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;

@end
