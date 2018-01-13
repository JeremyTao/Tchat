//
//  DYCAddressPickerView.h
//  DYCPickView
//
//  Created by DYC on 15/9/10.
//  Copyright (c) 2015年 DYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Address;

@protocol DYCAddressPickerViewDelegate<NSObject>

-(void)selectAddressProvince:(Address *)province andCity:(Address *)city andCounty:(Address *)county;

@end

@interface DYCAddressPickerView : UIPickerView
@property (strong,nonatomic) NSMutableArray *provinceArray;
@property (strong,nonatomic) NSMutableArray *cityArray;
@property (strong,nonatomic) NSMutableArray *countyArray;
@property (assign,nonatomic) id<DYCAddressPickerViewDelegate> DYCDelegate;
-(instancetype)initWithFrame:(CGRect)frame withAddressArray:(NSArray *)addressArray;
- (void)selectProvinceAtRow:(NSInteger)row;
- (void)selectCityAtRow:(NSInteger)row;
@end
