#import "Event.h"

<<<<<<< HEAD
=======
@interface Event()

@property PFFile *imageFile;

@end

>>>>>>> master
@implementation Event{
    GMSMarker* eventMarker;
}

@dynamic name;
@dynamic host;
@dynamic attendees;
@dynamic startTime;
@dynamic endTime;
@dynamic location;
@dynamic price;
<<<<<<< HEAD
@dynamic image;
=======
@dynamic imageFile;
@synthesize image = _image;
>>>>>>> master

+ (void)load{
    [self registerSubclass];
}

+ (NSString*)parseClassName{
    return @"Event";
}

- (id)initEventWithName:(NSString*)name Host:(NSString*)host StartTime:(NSDate*)startTime EndTime:(NSDate*)endTime Location:(PFGeoPoint*)location Price:(NSNumber*)price Image:(UIImage*)image{
    self = [super init];
    if(self){
        self = [Event object];
        self.name = name;
        self.host = host;
        self.startTime = startTime;
        self.endTime = endTime;
        self.location = location;
        self.price = price;
        self.imageFile = [PFFile fileWithData:UIImagePNGRepresentation(image)];
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

-(UIImage*)image{
    if(!_image){
        _image = [UIImage imageWithData:[self.imageFile getData]];
    }
    return _image;
}

-(void)setImage:(UIImage*)image{
    _image = image;
    self.imageFile = [PFFile fileWithData:UIImagePNGRepresentation(image)];
}

@end
