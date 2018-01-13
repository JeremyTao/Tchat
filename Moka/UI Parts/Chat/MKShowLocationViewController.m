//
//  MKShowLocationViewController.m
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKShowLocationViewController.h"
#import "CBUserAnotation.h"

@interface MKShowLocationViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CBUserAnotation *userAnnotation;

@end

@implementation MKShowLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置信息";
    MKCoordinateSpan span = MKCoordinateSpanMake(0.004, 0.004);
    MKCoordinateRegion region = MKCoordinateRegionMake(_locationMessage.location, span);
    [self.mapView setRegion:region animated:YES];

    _userAnnotation = [[CBUserAnotation alloc] init];
    _userAnnotation.coordinate = _locationMessage.location;
    _userAnnotation.title = _locationMessage.locationName;
    [self.mapView addAnnotation:_userAnnotation];
    self.mapView.delegate = self;
    
    [self.mapView selectAnnotation:_userAnnotation animated:YES];
}

#pragma mark - <MKMapViewDelegate>

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[CBUserAnotation class]]) {
        
        NSString *reuseIdentifier = @"CBUserAnotation";
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIdentifier];
        }
        annotationView.image = [UIImage imageNamed:@"chat_GPS"];
        annotationView.canShowCallout = YES;
       
        return annotationView;
        
        
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views

{
    
    MKAnnotationView *annotationView;
    
    for (annotationView in views)
        
    {
        
        if (![annotationView isKindOfClass:[MKPinAnnotationView class]])
            
        {
            
            CGRect endFrame = annotationView.frame;
            
            annotationView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y - 500.0, endFrame.size.width, endFrame.size.height);
            
            [UIView beginAnimations:@"drop" context:NULL];
            
            [UIView setAnimationDuration:0.45];
            
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            [annotationView setFrame:endFrame];
            
            [UIView commitAnimations];
            
        }
        
    }
    
}


- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
