#import <Foundation/Foundation.h>
#import "ParseClient.h"
#import <CoreFoundation/CoreFoundation.h>

@interface EventBusiness : NSObject
@property NSMutableSet* loadedEvents;
-(id)init NS_UNAVAILABLE;
-(id)initWithParseClient:(ParseClient*)parseClient;

-(void)updateEventsForMapView:(GMSMapView*)mapView;


@end
