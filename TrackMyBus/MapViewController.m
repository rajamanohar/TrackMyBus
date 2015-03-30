//
//  MapViewController.m
//  TrackMyBus
//
//  Created by Mummidi, Raja on 3/30/15.
//  Copyright (c) 2015 Mummidi, Raja. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface MapViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation MapViewController
@synthesize locationManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapview.delegate = self;

        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(setLocationofMap) withObject:nil afterDelay:1];

}
-(void)setLocationofMap{

    self.mapview.showsUserLocation = YES;
}
// MKMapViewDelegate Methods
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    // Check authorization status (with class method)
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // User has never been asked to decide on location authorization
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Requesting when in use auth");
        [self.locationManager requestWhenInUseAuthorization];
    }
    // User has denied location use (either for this app or for all apps
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Location services denied");
        // Alert the user and send them to the settings to turn on location
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        
        MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500.0, 1500.0);
        [self.mapview setRegion:userLocation animated:YES];
    }
    
    NSLog(@"Test");
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500.0, 1500.0);
    [self.mapview setRegion:userLocation animated:YES];
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    NSLog(@"didUpdateUserLocation");
//    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250);
//  //  [self setRegion:[self regionThatFits:region] animated:YES];
//    
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = userLocation.coordinate;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//  //  [self addAnnotation:point];
//}
//
//- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    NSLog(@"viewForAnnotation");
//    static NSString *identifier = @"MyAnnotation";
//    
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        NSLog(@"Is the user %f, %f", [annotation coordinate].latitude, [annotation coordinate].longitude);
//        return nil;
//    }
//    
//    return nil;
//}
//
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    NSLog(@"didAddAnnotationViews");
//    for (MKAnnotationView *view in views){
//        if ([[view annotation] isKindOfClass:[MKUserLocation class]]){
//            
//            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[view annotation] coordinate] , 250, 250);
//            
//            [mapView setRegion:region animated:YES];
//        }
//    }
//}

@end
