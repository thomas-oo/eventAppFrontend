#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Event.h"

@interface MapManager : NSObject
@property NSMutableSet* loadedEvents;
+ (id)sharedManager;
- (id)init NS_UNAVAILABLE;
- (GMSMarker*)createMarkerWithEvent:(Event*) event;
- (NSSet*)getNewMarkers;
- (void)queryForEventsWithinGeoBox:(GMSCoordinateBounds*)bounds;

@end
