//
//  CBPickLocationViewController.m
//  CrunClub
//
//  Created by Knight on 2017/6/17.
//  Copyright © 2017年 Chengdu Sports Club Company. All rights reserved.
//

#import "CBPickLocationViewController.h"
#import <MapKit/MapKit.h>


static NSString *kCellIdentifier = @"cellIdentifier";


@interface CBPickLocationViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

{
    
    CLLocation *selectLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *locationView;
@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMagin;

@end

@implementation CBPickLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发送位置";
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(0, 0, 50, 30);
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(comfirmButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    [_searchTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 18)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftView.image = [UIImage imageNamed:@"chat_GPS"];
    _searchTextField.leftView = leftView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _searchTextField.delegate = self;
    if (_latitude == 0) {
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    } else {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(_latitude, _longtitude);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.002, 0.002);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [self.mapView setRegion:region animated:YES];
        _locationLabel.text  = _locationString;
        selectLocation = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longtitude];
    }
    
    _mapView.delegate = self;
    _searchBar.delegate = self;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [UIView new];
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
   
    // locationManager
    self.locationManager = ({
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = 5;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        [locationManager setPausesLocationUpdatesAutomatically:YES];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        locationManager;
    });
    
    
    
}

- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.length > 0 ) {
        [self startSearch:textField.text];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _topMagin.constant = 0;
    _leftMagin.constant = 0;
    _rightMagin.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _myTableView.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
    return YES;
}


#pragma mark - 更新位置📍
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    // Remember for later the user's current location.
    CLLocation *currentUserLocation = locations.lastObject;
    self.userCoordinate = currentUserLocation.coordinate;
    
    [manager stopUpdatingLocation]; // We only want one update.
    
    manager.delegate = nil;         // We might be called again here, even though we
    // called "stopUpdatingLocation", so remove us as the delegate to be sure.
    
    // We have a location now, so start the search.
    
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    [UIView animateWithDuration:0.2 animations:^{
//        _myTableView.alpha = 1.0;
//    }];
//    return YES;
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    
//    if (searchText.length > 0 ) {
//        [self startSearch:searchBar.text];
//    }
//    
//    
//}


- (void)startSearch:(NSString *)searchString {
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // Confine the map search area to the user's current location.
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userCoordinate.latitude;
    newRegion.center.longitude = self.userCoordinate.longitude;
    
    // Setup the area spanned by the map region:
    // We use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level).
    //      The numbers used here correspond to a roughly 8 mi
    //      diameter area.
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error) {
        if (error != nil) {
//            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
//                                                            message:errorStr
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        } else {
            self.places = [response mapItems];
            
            // Used for later when setting the map's region in "prepareForSegue".
            self.boundingRegion = response.boundingRegion;
            
            
            [self.myTableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil) {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}




#pragma mark - <MKMapViewDelegate>

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    /* 系统的蓝色大头针 */
     return nil;

}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    CLLocationCoordinate2D centerCoordinate = [mapView convertPoint:mapView.center toCoordinateFromView:mapView];
    selectLocation = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    
    //NSLog(@"%f %f",centerCoordinate.latitude, centerCoordinate.longitude);

    
    [self getAddressFromLocation:selectLocation];
}


- (void)getAddressFromLocation:(CLLocation *)location {
    //发起逆地理编码
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];

    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSDictionary *dict = placemarks.firstObject.addressDictionary;
        //获取街道名称
        NSString *addressString  = [dict[@"FormattedAddressLines"] objectAtIndex:0];
        _locationLabel.text = [addressString substringFromIndex:2];

    }];
    
     
     
     
}


#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

    MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = mapItem.name;
    //NSLog(@"mapItem.name = %@", mapItem.name);
    cell.textLabel.textColor  = [UIColor darkGrayColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
    CLLocationCoordinate2D selectedCoordinate2D = mapItem.placemark.coordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:selectedCoordinate2D.latitude longitude:selectedCoordinate2D.longitude];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.002, 0.002);
    MKCoordinateRegion region = MKCoordinateRegionMake(selectedCoordinate2D, span);
    [self.mapView setRegion:region animated:YES];
    
    _topMagin.constant = 20;
    _leftMagin.constant = 20;
    _rightMagin.constant = 20;
    [UIView animateWithDuration:0.2 animations:^{
        _myTableView.alpha = 0;
        [self.view layoutIfNeeded];
    }];

    [self.view endEditing:YES];
    [self getAddressFromLocation:location];
}



- (void)comfirmButtonEvent {
    //截图
    UIGraphicsBeginImageContextWithOptions(_mapView.bounds.size, NO, 0);
    [_mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectLocation:locationName:mapScreenShot:)]) {
        [self.delegate didSelectLocation:selectLocation.coordinate
                            locationName:_locationLabel.text
                           mapScreenShot:image];
       
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)backToUserLocationButtonClicked:(UIButton *)sender {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.002, 0.002);
    MKCoordinateRegion region = MKCoordinateRegionMake(_userCoordinate, span);
    [self.mapView setRegion:region animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)backButtonClicked {
    if (_myTableView.alpha == 1) {
        _topMagin.constant = 20;
        _leftMagin.constant = 20;
        _rightMagin.constant = 20;
        [UIView animateWithDuration:0.2 animations:^{
            _myTableView.alpha = 0;
            [self.view layoutIfNeeded];
        }];
        
        [self.view endEditing:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
