//
//  DYCAddressPickerView.m
//  DYCPickView
//
//  Created by DYC on 15/9/10.
//  Copyright (c) 2015年 DYC. All rights reserved.
//
#import "Address.h"
#import "DYCAddressPickerView.h"
@interface DYCAddressPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

//@property (strong,nonatomic) NSMutableArray *provinceArray;
//@property (strong,nonatomic) NSMutableArray *cityArray;
//@property (strong,nonatomic) NSMutableArray *countyArray;
@property (strong,nonatomic) Address *province;
@property (strong,nonatomic) Address *city;
@property (strong,nonatomic) Address *county;

@end

@implementation DYCAddressPickerView
-(instancetype)initWithFrame:(CGRect)frame withAddressArray:(NSArray *)addressArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        if (addressArray.count) {
            _provinceArray = [NSMutableArray arrayWithArray:addressArray];
            _province = _provinceArray[0];
            if (_province.sonAddress.count) {
                _cityArray = [NSMutableArray arrayWithArray:_province.sonAddress];
                _city =_cityArray[0];
                if (_city.sonAddress.count) {
                    _countyArray = [NSMutableArray arrayWithArray:_city.sonAddress];
                    _county = _countyArray[0];
                }
                else
                {
                    NSLog(@"init DYCPickerView with unavliable addressArray;please check out and make sure addressArray is valid.sonAddress in sonAddress is unvalid.");
                }
            }
            else
            {
                NSLog(@"init DYCPickerView with unavliable addressArray;please check out and make sure addressArray is valid.sonAddress is unvalid.");
            }
        }
        else
        {
            NSLog(@"init DYCPickerView with unavliable addressArray;please check out and make sure addressArray is valid.");
        }
    }
    return self;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    switch (component) {
        case 0:
            count = _provinceArray.count;
            break;
        case 1:
            count = _cityArray.count;
            break;
        case 2:
            count = _countyArray.count;
            break;
        default:
            break;
    }
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = @"";
    Address *address;
    switch (component) {
        case 0: {
            if (_provinceArray.count != 0) {
                address = _provinceArray[row];
                str = address.name;
            }
        }
            break;
        case 1: {
            if (_cityArray.count != 0) {
                address = _cityArray[row];
                str = address.name;
            }
        }
            break;
        case 2: {
            if (_countyArray.count != 0) {
                address = _countyArray[row];
                str = address.name;
            }
        }
            break;
        default:
            break;
    }
    return str;
}

- (void)selectProvinceAtRow:(NSInteger)row {
    _province = _provinceArray[row];
    if (_province.sonAddress.count) {
        _cityArray = [NSMutableArray arrayWithArray:_province.sonAddress];
        if (_city.sonAddress.count) {
            _countyArray = [NSMutableArray arrayWithArray:_city.sonAddress];
        } else {
            [_countyArray removeAllObjects];
        }
    }
}

- (void)selectCityAtRow:(NSInteger)row {
    _city = _cityArray[row];
    if (_city.sonAddress.count) {
        _countyArray = [NSMutableArray arrayWithArray:_city.sonAddress];
    } else {
        [_countyArray removeAllObjects];
    }

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            _province = _provinceArray[row];
            if (_province.sonAddress.count) {
                _cityArray = [NSMutableArray arrayWithArray:_province.sonAddress];
                _city = _cityArray[0];
                [self reloadComponent:1];
                [self selectRow:0 inComponent:1 animated:YES];
                if (_city.sonAddress.count) {
                    _countyArray = [NSMutableArray arrayWithArray:_city.sonAddress];
                    _county = _countyArray[0];
                    [self reloadComponent:2];
                    [self selectRow:0 inComponent:2 animated:YES];
                } else {
                    [_countyArray removeAllObjects];
                    [self reloadComponent:2];
                    _county = nil;
                }
            } else {
                _city = nil;
            }
            
        }
            break;
        case 1: {
            _city = _cityArray[row];
            if (_city.sonAddress.count) {
                _countyArray = [NSMutableArray arrayWithArray:_city.sonAddress];
                _county = _countyArray[0];
                [self reloadComponent:2];
                [self selectRow:0 inComponent:2 animated:YES];
            } else  {
                [_countyArray removeAllObjects];
                [self reloadComponent:2];
                _county = nil;
            }
        }
            break;
        case 2: {
            
            if (_countyArray.count != 0) {
                _county = _countyArray[row];
            } else {
                _county = nil;
            }
        }
            break;
        default:
            break;
    }
    [_DYCDelegate selectAddressProvince:_province andCity:_city andCounty:_county];
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:14];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
@end
