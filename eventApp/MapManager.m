#import "MapManager.h"
@implementation MapManager
static MapManager* _sharedMapManager = nil;

- (id)initPrivate{
    if (!_sharedMapManager) {
        _sharedMapManager = [super init];
        
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
@end
