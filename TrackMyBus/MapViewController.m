//
//  MapViewController.m
//  TrackMyBus
//
//  Created by Mummidi, Raja on 3/30/15.
//  Copyright (c) 2015 Mummidi, Raja. All rights reserved.
//



#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "EntityAnnotation.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface MapViewController ()<CLLocationManagerDelegate>
@property(nonatomic,strong) UIImageView *imageViewTarget;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic)  UITapGestureRecognizer *tapGestureRecognizer;
@property(strong,nonatomic)  UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, retain) MKPolyline *routeLine;
@property (nonatomic, retain) MKPolylineView *routeLineView;

@end

@implementation MapViewController
@synthesize locationManager,imageViewTarget;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapview.delegate = self;
    [self addTargetImageToMapView];
    [self addGesturetoMapView];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    // locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self performSelector:@selector(setLocationofMap) withObject:nil afterDelay:0];
    
    //Route Bus annotation
    CLLocationCoordinate2D BusCoordinate;
    BusCoordinate.latitude = 17.478208;
    BusCoordinate.longitude = 78.320071;
    EntityAnnotation *routeBusAnnotation = [[EntityAnnotation alloc] initWithCoordinate:BusCoordinate];
    [routeBusAnnotation setImage:[UIImage imageNamed:@"route_bus.png"]];
    routeBusAnnotation.annotationTitle=@"Route1";
    routeBusAnnotation.annotationSubtitle=@"Location: Serilingampally";
    [self.mapview addAnnotation:routeBusAnnotation];
  
    //Person Annotation
    CLLocationCoordinate2D PersonCoordinate;
    PersonCoordinate.latitude = 17.442412;
    PersonCoordinate.longitude =  78.357249;
    EntityAnnotation *personAnnotation = [[EntityAnnotation alloc] initWithCoordinate:PersonCoordinate];
    personAnnotation.annotationTitle=@"1508918";
    personAnnotation.annotationSubtitle=@"Location: Gachibowli";
    [personAnnotation setImage:[UIImage imageNamed:@"man_location.png"]];
    [self.mapview addAnnotation:personAnnotation];
    
    
    CLLocation *locSouthWest = [[CLLocation alloc] initWithLatitude:BusCoordinate.latitude longitude:BusCoordinate.longitude];
    CLLocation *locNorthEast = [[CLLocation alloc] initWithLatitude:PersonCoordinate.latitude longitude:PersonCoordinate.longitude];
    
    // This is a diag distance (if you wanted tighter you could do NE-NW or NE-SE)
    CLLocationDistance meters = [locSouthWest distanceFromLocation:locNorthEast];
    
    MKCoordinateRegion region;
    region.center.latitude = (BusCoordinate.latitude + PersonCoordinate.latitude) / 2.0;
    region.center.longitude = (BusCoordinate.longitude + PersonCoordinate.longitude) / 2.0;
    region.span.latitudeDelta =0.050;
    region.span.longitudeDelta = 0.050;
    
    region = [self.mapview regionThatFits:region];
    [self.mapview setRegion:region animated:YES];
    
    
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = CLLocationCoordinate2DMake(BusCoordinate.latitude, BusCoordinate.longitude);
    coordinateArray[1] = CLLocationCoordinate2DMake(PersonCoordinate.latitude, PersonCoordinate.longitude);
    
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    [self.mapview setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
    
    [self.mapview addOverlay:self.routeLine];
    
    
}

-(void)addTargetImageToMapView
{
    UIButton *btnTarget=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, self.view.frame.origin.y+10, 32, 32)];
    [btnTarget  setImage:[UIImage imageNamed:@"map_target_open.png"] forState:UIControlStateNormal];
    [btnTarget addTarget:self action:@selector(clickonTargetButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btnTarget.layer.borderColor=[[UIColor grayColor]CGColor];
    btnTarget.layer.borderWidth=1;
    //btnTarget.alpha=0.5;
    [self.mapview addSubview:btnTarget];
    [self.mapview bringSubviewToFront:btnTarget];
    
}

-(void)clickonTargetButton:(id)sender
{
    UIButton *btnTarget=(UIButton *)sender;
     [btnTarget  setImage:[UIImage imageNamed:@"map_target_open.png"] forState:UIControlStateNormal];
    CLLocationCoordinate2D PersonCoordinate;
    PersonCoordinate.latitude = 17.442412;
    PersonCoordinate.longitude =  78.357249;
    
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(PersonCoordinate, 10,10);
    region.span.latitudeDelta =0.0001;
    region.span.longitudeDelta = 0.00010;
    
    region = [self.mapview regionThatFits:region];
    [self.mapview setRegion:region animated:YES];
}
#pragma mark -Location services
-(void)setLocationofMap
{
    self.mapview.showsUserLocation = YES;
    CLLocationCoordinate2D  userLocation=CLLocationCoordinate2DMake(17.477742, 78.320071);
    
    CLLocation *location=[[CLLocation alloc] initWithLatitude:userLocation.latitude
                                                                      longitude:userLocation.longitude];
   MKCoordinateRegion userRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500.0, 1500.0);
   userRegion.span.latitudeDelta=0.001;
   userRegion.span.longitudeDelta=0.001;
//   [self.mapview setRegion:userRegion animated:YES];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
   // UIAlertView *errorAlert = [[UIAlertView alloc]
                          //     initWithTitle:@"Error" message:@"Can not determine Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[errorAlert show];
    
//    17.446179
//    78.351445
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
    }
}
- (void)locationManager:(CLLocationManager *)manager
                                        didUpdateToLocation:(CLLocation *)newLocation
                                        fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500.0, 1500.0);
    [self.mapview setRegion:userLocation animated:YES];
}


#pragma mark - Map Gesture delegates
-(void)addGesturetoMapView
{
    self.tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOntheMapView:)];
    self.tapGestureRecognizer.numberOfTapsRequired=1;
    [self.mapview addGestureRecognizer:self.tapGestureRecognizer];
    self.panGestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOntheMapView:)];
    [self.mapview addGestureRecognizer:self.panGestureRecognizer];
}
-(void)didTapOntheMapView:(UITapGestureRecognizer *)gesture
{
    //Register notification to the map events
    [[NSNotificationCenter defaultCenter]
                                        postNotificationName:@"mapTapGestureRecognizer"
                                        object:self];

}
-(void)didPanOntheMapView:(UIPanGestureRecognizer *)gesture
{
//    [[NSNotificationCenter defaultCenter]
//                                        postNotificationName:@"mapPanGestureRecognizer"
//                                        object:self];
}

#pragma mark - MKMapViewDelegate

// user tapped the disclosure button in the bridge callout
//
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    //id <MKAnnotation> annotation = [view annotation];
//    if ([annotation isKindOfClass:[BridgeAnnotation class]])
//    {
//        NSLog(@"clicked Golden Gate Bridge annotation");
//        
//        DetailViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
//        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//        {
//            // for iPad, we use a popover
//            if (self.bridgePopoverController == nil)
//            {
//                _bridgePopoverController = [[UIPopoverController alloc] initWithContentViewController:detailViewController];
//            }
//            [self.bridgePopoverController presentPopoverFromRect:control.bounds
//                                                          inView:control
//                                        permittedArrowDirections:UIPopoverArrowDirectionLeft
//                                                        animated:YES];
//        }
//        else
//        {
//            // for iPhone we navigate to a detail view controller using UINavigationController
//            [self.navigationController pushViewController:detailViewController animated:YES];
//        }
//    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView = nil;
    
    // in case it's the user location, we already have an annotation, so just return nil
    if (![annotation isKindOfClass:[MKUserLocation class]])
    {
        // handle our three custom annotations
        //
         if ([annotation isKindOfClass:[EntityAnnotation class]])   // for City of San Francisco
                {
                    EntityAnnotation *tmpEntityAnnotation=(EntityAnnotation *)annotation;
                    returnedAnnotationView = [EntityAnnotation createViewAnnotationForMapView:self.mapview annotation:annotation];
                    
                    // provide the annotation view's image
                    returnedAnnotationView.image = tmpEntityAnnotation.image;
                    
                    // provide the left image icon for the annotation
                    UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                    returnedAnnotationView.leftCalloutAccessoryView = sfIconView;
                }
        
     }
    
    
    
    return returnedAnnotationView;
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine)
    {
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
            
        }
        
        return self.routeLineView;
    }
    
    return nil;
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
