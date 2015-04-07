//
//  EntityAnnotation.m
//  TrackMyBus
//
//  Created by Mummidi, Raja on 4/6/15.
//  Copyright (c) 2015 Mummidi, Raja. All rights reserved.
//

#import "EntityAnnotation.h"

@implementation EntityAnnotation
@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
{
    
    coordinate.latitude=coord.latitude;
    coordinate.longitude=coord.longitude;
      return self;
}
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = coordinate.latitude;
    theCoordinate.longitude = coordinate.longitude;
    return theCoordinate;
}

- (NSString *)title
{
    return self.annotationTitle;
}

// optional
- (NSString *)subtitle
{
    return self.annotationSubtitle;
}

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView =
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([EntityAnnotation class])];
    if (returnedAnnotationView == nil){
        returnedAnnotationView =[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                                              reuseIdentifier:NSStringFromClass([EntityAnnotation class])];
        
        returnedAnnotationView.canShowCallout = YES;
    
        
        // offset the flag annotation so that the flag pole rests on the map coordinate
        returnedAnnotationView.centerOffset = CGPointMake( returnedAnnotationView.centerOffset.x + returnedAnnotationView.image.size.width/2,
                                                                                                returnedAnnotationView.centerOffset.y - returnedAnnotationView.image.size.height/2 );
    }
    else
    {
        returnedAnnotationView.annotation = annotation;
    }
    return returnedAnnotationView;
}


@end
