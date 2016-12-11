#import "ParseClient.h"

@implementation ParseClient

////put into Business layer
//- (void)findNewEvents:(NSArray *)events {
//  __block int changedLoadedEvents;
//  for (Event *event in events) {
//                    if(![loadedEvents containsObject:event]){
//                        [self willChangeValueForKey:@"loadedEvents"];
//                        [loadedEvents addObject:event];
//                        changedLoadedEvents = YES;
//                    }
//                }
//                if(changedLoadedEvents){
//                    [self didChangeValueForKey:@"loadedEvents"];
//                }
//}

//async call for events.
- (void)queryForEventsWithinGeoBox:(GMSCoordinateBounds*)bounds andCompletionBlock:(void(^)(NSArray* events, NSError* error))completionBlock{
    PFQuery* markerQuery = [[PFQuery alloc] initWithClassName:@"Event"];
    PFGeoPoint* southWest = [PFGeoPoint geoPointWithLatitude:bounds.southWest.latitude longitude:bounds.southWest.longitude];
    PFGeoPoint* northEast = [PFGeoPoint geoPointWithLatitude:bounds.northEast.latitude longitude:bounds.northEast.longitude];
    [markerQuery whereKey:@"location" withinGeoBoxFromSouthwest:southWest toNortheast:northEast];
    
    [markerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError* error){
        if(error != nil){
            NSLog(@"Failed to find objects.");
            completionBlock(objects,error);
        }else{
            completionBlock(objects,error);
        }
    }];
}

@end
