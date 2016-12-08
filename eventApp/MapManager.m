#import "MapManager.h"
@implementation MapManager
static MapManager* _sharedMapManager = nil;
@synthesize loadedEvents;
- (id)initPrivate{
    if (!_sharedMapManager) {
        _sharedMapManager = [super init];
        loadedEvents = [[NSMutableSet alloc]init];
    }
    return _sharedMapManager;
}

+ (id)sharedManager{
    @synchronized([MapManager class])
    {
        if (!_sharedMapManager)
            _sharedMapManager = [[MapManager alloc] initPrivate];
        return _sharedMapManager;
    }
}
//marker is not placed on any map yet.
- (GMSMarker*)createMarkerWithEvent:(Event*) event{
    double latitude = event.location.latitude;
    double longitude = event.location.longitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
    marker.title = event.name;
    PFUser *currentUser = [PFUser currentUser];
    marker.snippet = event.host;
    return marker;
}

- (NSArray*)createMarkersWithEvents:(NSArray*) events{
    NSMutableArray* markers = [[NSMutableArray alloc]init];
    for(Event *event in events){
        [markers addObject:[self createMarkerWithEvent:event]];
    }
    return markers;
}

- (void)queryForEventsWithinGeoBox:(GMSCoordinateBounds*)bounds{
    bool __block changedLoadedEvents = NO;
    PFQuery* markerQuery = [[PFQuery alloc] initWithClassName:@"Event"];
    PFGeoPoint* southWest = [PFGeoPoint geoPointWithLatitude:bounds.southWest.latitude longitude:bounds.southWest.longitude];
    PFGeoPoint* northEast = [PFGeoPoint geoPointWithLatitude:bounds.northEast.latitude longitude:bounds.northEast.longitude];
    [markerQuery whereKey:@"location" withinGeoBoxFromSouthwest:southWest toNortheast:northEast];
    [markerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError* error){
        if(error != nil){
            NSLog(@"Failed to find objects.");
        }else{
            if(objects.count == 0){
            }else{
                for (Event *event in objects) {
                    if(![loadedEvents containsObject:event]){
                        [self willChangeValueForKey:@"loadedEvents"];
                        [loadedEvents addObject:event];
                        changedLoadedEvents = YES;
                    }
                }
                if(changedLoadedEvents){
                    [self didChangeValueForKey:@"loadedEvents"];
                }
            }
        }
    }];
}
@end