//
//  MKEditLocationViewController.m
//  Moka
//
//  Created by Knight on 2017/7/27.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKEditLocationViewController.h"
#import "MKSelectedRegionView.h"
#import "DYCAddress.h"
#import "Address.h"
#import "DYCAddressPickerView.h"
#import "MKTagsTableViewCell.h"
#import <MapKit/MapKit.h>

static NSString *kCellIdentifier = @"cellIdentifier";

@interface MKEditLocationViewController ()<UITableViewDelegate, UITableViewDataSource, MKSelectedRegionViewDelegate, DYCAddressDelegate,DYCAddressPickerViewDelegate, CLLocationManagerDelegate>

{
    NSMutableArray *countryArray;
    NSString       *selectAddress;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKSelectedRegionView *headerView;

@property (strong,nonatomic) DYCAddress            *dYCAddress;
@property (nonatomic, strong) DYCAddressPickerView *pickerView;
@property (nonatomic, strong) UIWindow     *pickerWindow;
@property (nonatomic, strong) UIView       *animationView;
@property (nonatomic, strong) NSArray   *addressArray;  //缓存数据
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MKEditLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"来自"];
    self.title = @"来自";
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 40, 30);
    [moreButton setTitle:@"完成" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    [self setRightButtonWithTitle:@"完成" titleColor:[UIColor whiteColor] imageName:nil addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self initAreaData];
    [self setupTableView];
    /*
    // locationManager
    self.locationManager = ({
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = 3000;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        
        locationManager;
    });
    */
    countryArray = @[].mutableCopy;
    BOOL flag = NO;
    for (NSString *code in [NSLocale ISOCountryCodes]) {
        NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode: code}];
        NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:identifier];
        //NSLog(@"%@", countryName);
        MKInterestTagModel *model = [[MKInterestTagModel alloc] init];
        model.name = countryName;
        if ([model.name isEqualToString:_infoModel.address]) {
            model.selected = 1;
            selectAddress = model.name;
            flag = YES;
        }
        if (![model.name isEqualToString:@"中国"]) {
            [countryArray addObject:model];
        }
    }
    if (!flag && _infoModel.address.length > 0) {
        [_headerView selected];
        [_headerView configAddress:_infoModel.address];
    } else {
        //[_locationManager startUpdatingLocation];
    }
    
    
}

- (void)setupTableView {
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib:[UINib nibWithNibName:@"MKTagsTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    UIView *newView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 112)];
    _headerView = [MKSelectedRegionView newRegionView];
    _headerView.frame  = newView.bounds;
    [newView addSubview:_headerView];
    _headerView.delegate = self;
    
    _myTableView.tableHeaderView = newView;
}

- (void)initAreaData {
    //先去本地数据库中读取地址
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SYS_ARER"];
    if (data) {
        _addressArray =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    _dYCAddress = [[DYCAddress alloc] init];
    _dYCAddress.dataDelegate = self;
    
    
    if (!_addressArray) {
        //解析xml数据
        [_dYCAddress handlerAddress];
    } else {
        //把数据给_dYCAddress的属性字典
        for (Address *address in _addressArray) {
            if (address.fatherCode == 0) {
                //省
                Address *provinceAddress = address;
                [_dYCAddress.provinceDictionary setValue:provinceAddress forKey:[NSString stringWithFormat:@"%ld", (long)provinceAddress.areaCode]];
                //市
                NSArray *cityArray = provinceAddress.sonAddress;
                for (Address *cityAddress in cityArray) {
                    [_dYCAddress.cityDictionary setValue:cityAddress forKey:[NSString stringWithFormat:@"%ld", (long)cityAddress.areaCode]];
                    //区
                    NSArray *countriesArray = cityAddress.sonAddress;
                    for (Address *countryAddress in countriesArray) {
                        [_dYCAddress.countryDictionary setValue:countryAddress forKey:[NSString stringWithFormat:@"%ld", (long)countryAddress.areaCode]];
                    }
                }
            }
            
        }
        
        [self creatPickerView:_addressArray];
        
    }
}

-(void)addressList:(NSArray *)array
{
    [self creatPickerView:array];
}



- (void)creatPickerView:(NSArray *)dataArray {
    
    //pickerView所依附的UIView
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    animationView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 1.5);
    animationView.backgroundColor = [UIColor whiteColor];
    
    _pickerView = [[DYCAddressPickerView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT / 2) withAddressArray:dataArray];
    _pickerView.DYCDelegate = self;
    
    [animationView addSubview:_pickerView];
    [self.pickerWindow addSubview:animationView];
    _animationView = animationView;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 40, 40);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmAdressButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIView *view  = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [view addSubview:confirmButton];
    [_animationView addSubview:view];
}
/*
#pragma mark - 更新位置📍
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Remember for later the user's current location.
    CLLocation *currentUserLocation = locations.lastObject;
    [self getAddressFromLocation:currentUserLocation.coordinate];
    
    [manager stopUpdatingLocation];
    manager.delegate = nil;
}

//发起逆地理编码
- (void)getAddressFromLocation:(CLLocationCoordinate2D)coordinate {
    
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil) {
            //NSLog(@"返地理编码成功");
            //CLPlacemark地标对象
            NSLog(@"%@",placemarks.firstObject.addressDictionary);
            NSDictionary *dict = placemarks.firstObject.addressDictionary;
            //获取街道名称
            NSString *addressString  = [NSString stringWithFormat:@"%@%@", dict[@"State"], dict[@"City"]];
            [_headerView configAddress:addressString];

        } else {
            NSLog(@"reGeo fail: %@", error);
        }
    }];
    

}
*/

#pragma mark - MKSelectedRegionViewDelegate

- (void)selectAddressProvince:(Address *)province andCity:(Address *)city andCounty:(Address *)county
{
    //设置选择的地址
    NSString *adressString = [NSString stringWithFormat:@"%@%@%@", province.name , city.name, county.name ? county.name : @""];

    //选择地址label
    [_headerView configAddress:adressString];
    selectAddress = _headerView.addressLabel.text;
    [_headerView selected];
    for (MKInterestTagModel *model in countryArray) {
        model.selected = 0;
    }
    [_myTableView reloadData];
    
    NSLog(@"%@", adressString);
}


- (void)didClickedOnChinaAdress {
    
    if ([self.headerView.addressLabel.text isEqualToString:@"选择地址"]) {
        self.headerView.addressLabel.text = @"北京北京市东城区";
    }
   
    //弹出地址选择
    [self.pickerWindow makeKeyAndVisible];
    self.pickerWindow.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.animationView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.75);
        if (IOS8) {
            self.animationView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.75 + 60);
        }
        self.pickerWindow.alpha = 1;
    }];
}

- (UIWindow *)pickerWindow {
    if (!_pickerWindow) {
        _pickerWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pickerWindow.backgroundColor = [UIColor clearColor];
        _pickerWindow.windowLevel = UIWindowLevelAlert;
        //暗色背景
        UIButton *darkBackgroundBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        darkBackgroundBtn.backgroundColor = [UIColor blackColor];
        darkBackgroundBtn.alpha = 0.5;
        [_pickerWindow addSubview:darkBackgroundBtn];
        [darkBackgroundBtn addTarget:self action:@selector(removePickerWindow) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerWindow;
}

//picker "确定"
- (void)confirmAdressButtonClicked {
    [self removePickerWindow];
    selectAddress = _headerView.addressLabel.text;
    [_headerView selected];
    for (MKInterestTagModel *model in countryArray) {
        model.selected = 0;
    }
    [_myTableView reloadData];
}

- (void)removePickerWindow {
    [UIView animateWithDuration:0.25 animations:^{
        self.animationView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 1.5);
        self.pickerWindow.alpha = 0;
    } completion:^(BOOL finished) {
        self.pickerWindow.hidden = YES;
    }];
}



#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [countryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell configSingleSelectCell:countryArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_headerView clearSelection];
    for (MKInterestTagModel *model in countryArray) {
        model.selected = 0;
    }
    
    MKInterestTagModel *model = countryArray[indexPath.row];
    selectAddress = model.name;
    model.selected = 1;
    [tableView reloadData];
}

- (void)confirmButtonClicked {
    if (selectAddress.length > 0) {
        [self requestUpdateUserAddress];
    } else {
        [MKUtilHUD showHUD:@"请选择地址" inView:self.view];
    }
    
}


- (void)requestUpdateUserAddress {
    NSDictionary *param = @{@"address" : selectAddress};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_updateUser] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"地区 %@",json);
        
        if (status == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPage" object:nil];
            self.infoModel.address = selectAddress;
            [strongSelf performSelector:@selector(delayPopViewController) withObject:nil afterDelay:0];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
    } failure:^(NSError *error) {
        
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)delayPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
