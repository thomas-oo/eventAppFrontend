//
//  MapViewController.h
//  eventApp
//
//  Created by Oo, Thein on 2016-11-29.
//  Copyright © 2016 Oo, Thein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CreateEventViewController.h"

@interface MapViewController : UIViewController<GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property NSMutableSet *markedEvents;
@end
