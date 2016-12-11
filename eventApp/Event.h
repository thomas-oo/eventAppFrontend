#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
@interface Event : PFObject<PFSubclassing>

@property NSString* name;
@property NSString* host;
@property NSArray* attendees; //not required in init
@property NSDate* startTime;
@property NSDate* endTime;
@property PFGeoPoint* location;
@property NSNumber* price;
@property PFFile* image; //not required in init

+ (NSString*)parseClassName;
- (id)init NS_UNAVAILABLE;
- (id)initWithClassName:(NSString *)newClassName NS_UNAVAILABLE;
- (id)initEventWithName:(NSString*)name Host:(NSString*)host StartTime:(NSDate*)startTime EndTime:(NSDate*)endTime Location:(PFGeoPoint*)location Price:(NSNumber*)price;
- (GMSMarker*)getMarker;

@end
