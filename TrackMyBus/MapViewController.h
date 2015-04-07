//
//  MapViewController.h
//  TrackMyBus
//
//  Created by Mummidi, Raja on 3/30/15.
//  Copyright (c) 2015 Mummidi, Raja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import "MapView.h"
@interface MapViewController : UIViewController<MKMapViewDelegate>
@property(nonatomic,retain) IBOutlet MKMapView *mapview;
@end
