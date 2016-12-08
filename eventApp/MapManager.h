#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Event.h"

@interface MapManager : NSObject

+ (id)sharedManager;
- (id)init NS_UNAVAILABLE;
- (GMSMarker*)createMarkerWithEvent:(Event*) event;
- (NSArray*)createMarkersWithEvents:(NSArray*) events;

@end
