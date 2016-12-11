#import "Event.h"

@implementation Event

@dynamic name;
@dynamic host;
@dynamic attendees;
@dynamic startTime;
@dynamic endTime;
@dynamic location;
@dynamic price;
@dynamic image;

GMSMarker* eventMarker;

+ (void)load{
    [self registerSubclass];
}

+ (NSString*)parseClassName{
    return @"Event";
}

- (id)initEventWithName:(NSString*)name Host:(NSString*)host StartTime:(NSDate*)startTime EndTime:(NSDate*)endTime Location:(PFGeoPoint*)location Price:(NSNumber*)price{
    self = [super init];
    if(self){
        self = [Event object];
        self.name = name;
        self.host = host;
        self.startTime = startTime;
        self.endTime = endTime;
        self.location = location;
        self.price = price;
        [self setValue:[PFUser currentUser] forKey:@"Creator"];
    }
    return self;
}

- (GMSMarker*)getMarker{
    if(eventMarker == nil){
        CLLocationCoordinate2D coordinate =CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude);
        eventMarker = [GMSMarker markerWithPosition:coordinate];
    }
    return eventMarker;
}

@end
