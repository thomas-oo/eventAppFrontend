#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Event.h"
@interface ParseClient : NSObject

- (void)queryForEventsWithinGeoBox:(GMSCoordinateBounds*)bounds andCompletionBlock:(void(^)(NSArray* events, NSError* error))completionBlock;

@end
