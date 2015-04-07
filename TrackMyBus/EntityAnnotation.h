//
//  EntityAnnotation.h
//  TrackMyBus
//
//  Created by Mummidi, Raja on 4/6/15.
//  Copyright (c) 2015 Mummidi, Raja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EntityAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString  *annotationTitle;
@property (nonatomic, strong) NSString  *annotationSubtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;
@end
