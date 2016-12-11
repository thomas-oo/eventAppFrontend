#import "EventBusiness.h"

@implementation EventBusiness

@synthesize loadedEvents;
ParseClient* _parseClient;

-(id)initWithParseClient:(ParseClient*)parseClient{
    self = [super init];
    if(self) {
        _parseClient = parseClient;
        loadedEvents = [[NSMutableSet alloc] init];
    }
    return self;
}

-(void)updateEventsForMapView:(GMSMapView*)mapView{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithRegion:mapView.projection.visibleRegion];
    PFQuery* markerQuery = [[PFQuery alloc] initWithClassName:@"Event"];
    PFGeoPoint* southWest = [PFGeoPoint geoPointWithLatitude:bounds.southWest.latitude longitude:bounds.southWest.longitude];
    PFGeoPoint* northEast = [PFGeoPoint geoPointWithLatitude:bounds.northEast.latitude longitude:bounds.northEast.longitude];
    [markerQuery whereKey:@"location" withinGeoBoxFromSouthwest:southWest toNortheast:northEast];
    
    //find of the loadedEvents, which are visible
    NSMutableSet* loadedVisibleEvents = [self findEventsWithinGeoBoxFromSouthwest:southWest toNorthEast:northEast];
    
    [markerQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableSet* visibleEvents = [NSMutableSet setWithArray:objects];
        
        if([visibleEvents isEqualToSet:loadedVisibleEvents]){
            //nothing
        }else{
            //replace events in loadedEvents from loadedVisibleEvents with the ones in objects.
            [self willChangeValueForKey:@"loadedEvents"];
            [loadedEvents minusSet:loadedVisibleEvents];
            [loadedEvents unionSet:visibleEvents];
            [self didChangeValueForKey:@"loadedEvents"];
        }
    }];
}

-(NSSet*)findEventsWithinGeoBoxFromSouthwest:(PFGeoPoint*)southWest toNorthEast:(PFGeoPoint*)northEast{
    NSMutableSet* loadedVisibleEvents = [[NSMutableSet alloc]init];
    for(Event *event in loadedEvents){
        double latitude = event.location.latitude;
        double longitude = event.location.longitude;
        if(southWest.latitude < latitude && latitude < northEast.latitude){
            if(southWest.longitude < longitude && longitude < northEast.longitude){
                //add event into loadedvisibleevents
                [loadedVisibleEvents addObject:event];
            }
        }
    }
    return loadedVisibleEvents;
}

@end
