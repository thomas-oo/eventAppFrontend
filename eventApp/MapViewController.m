#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "Event.h"
#import "EventBusiness.h"
#import "InfoWindow.h"
@interface MapViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *marker;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@end

//TODO: clean up observers on view destroy
@implementation MapViewController
@synthesize markedEvents;
BOOL firstLocationUpdate;
GMSCameraPosition* currentPosition;
ParseClient *parseClient;
EventBusiness* eventBusiness;
NSDateFormatter *dateFormat = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    parseClient = [[ParseClient alloc] init];
    eventBusiness = [[EventBusiness alloc] initWithParseClient:parseClient];

    UIEdgeInsets mapInsets = UIEdgeInsetsMake(0, 0, 40, 0);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:100
                                                            longitude:100
                                                                 zoom:15];
    self.mapView.camera = camera;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.rotateGestures = NO;
    self.mapView.settings.tiltGestures = NO;
    [self.mapView setMinZoom:10 maxZoom:20];
    self.mapView.padding = mapInsets;
    
    [self.mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    //TODO: maybe implement a way to switch the map theme depending on the time
    NSURL *styleUrl = [mainBundle URLForResource:@"styleDay" withExtension:@"json"];
    NSError *error;
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    self.mapView.mapStyle = style;
    self.mapView.delegate = self;
    [self registerListenerForLoadedEvents];
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(nonnull GMSCameraPosition *)position{
    [self loadMarkers];
    if(!_marker.hidden){
        [_doneButton setHidden:NO];
        [_addressLabel setHidden:NO];
        [self displayAddressHere:position];
    }
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    if(!_marker.hidden){
        [_doneButton setHidden:YES];
        [_addressLabel setHidden:YES];
        _addressLabel.text = @"Searching address...";
    }
}
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self.mapView animateToLocation:coordinate];
}
- (IBAction)addEventButtonClicked:(id)sender {
    [_addButton setHidden:YES];
    [_marker setHidden:NO];
    [_cancel setHidden:NO];
    [_doneButton setHidden:NO];
    [_addressLabel setHidden:NO];
    GMSCameraPosition* position = [self.mapView camera];
    [self displayAddressHere:position];
}
- (IBAction)cancelButtonClicked:(id)sender {
    [_addButton setHidden:NO];
    [_marker setHidden:YES];
    [_cancel setHidden:YES];
    [_doneButton setHidden:YES];
    [_addressLabel setHidden:YES];
    _addressLabel.text = @"";
}
- (IBAction)doneButtonClicked:(id)sender {
    NSString* name = @"Samosa";
    NSString* host = @"Thomas Oo";
    NSDate* startTime = [[NSDate alloc] init];
    NSDate* endTime = [[NSDate alloc] init];
    CLLocationCoordinate2D currentCoordinates = [currentPosition target];
    PFGeoPoint* location = [PFGeoPoint geoPointWithLatitude:currentCoordinates.latitude longitude:currentCoordinates.longitude];
    NSNumber* price = @20;
    UIImage* image = [UIImage imageNamed:@"samosa"];
    Event* newEvent = [[Event alloc] initEventWithName:name Host:host StartTime:startTime EndTime:endTime Location:location Price:price Image:image];
    
    [newEvent saveInBackgroundWithBlock:^(BOOL success, NSError* error){
        if(success){
            [self loadMarkers];
        }else{
            NSLog(@"Failed to save event.");
        }
    }];
}

- (void)displayAddressHere:(GMSCameraPosition*)position{
    currentPosition = position;
    CLLocationCoordinate2D currentCoordinates = [position target];
    GMSGeocoder *geocoder = [[GMSGeocoder alloc]init];
    [geocoder reverseGeocodeCoordinate:currentCoordinates completionHandler:^(GMSReverseGeocodeResponse* geocodeResponse,NSError*error){
        if(error != nil){
            NSLog(@"Error grabbing reverse geocode");
        }else{
            NSArray *addresslines = geocodeResponse.firstResult.lines;
            NSMutableString* address = addresslines[0];
            _addressLabel.text = address;
        }
    }];
}

- (void)loadMarkers{
    [eventBusiness updateEventsForMapView:self.mapView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"myLocation"] && !firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:15];
        [self.mapView removeObserver:self forKeyPath:@"myLocation"];
    }else if([keyPath isEqualToString:@"loadedEvents"]){
        NSMutableSet* addedEvents = [change objectForKey:NSKeyValueChangeNewKey];
        NSMutableSet* deletedEvents = [change objectForKey:NSKeyValueChangeOldKey];
        for(Event *event in addedEvents){
            GMSMarker* marker = [event getMarker];
            marker.map = self.mapView;
            marker.title = event.name;
            marker.snippet = event.host;
        }
        for(Event* event in deletedEvents){
            GMSMarker* marker = [event getMarker];
            marker.map = nil;
            marker.title = nil;
            marker.snippet = nil;
        }
    }
}

- (void)registerListenerForLoadedEvents{
    [eventBusiness addObserver:self forKeyPath:@"loadedEvents" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(UIView*)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    InfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    Event* eventOfMarker;
    
    //search for the owner of this marker
    for(Event* event in eventBusiness.loadedEvents){
        if(event.getMarker == marker){
            eventOfMarker = event;
            continue;
        }
    }
    //able to access the event that owns this marker
    [infoWindow.title setText:eventOfMarker.name];
    [infoWindow.snippet setText:eventOfMarker.host];
    [infoWindow.image setImage: eventOfMarker.image];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MMM dd yyyy h:mm a"];
    [infoWindow.startDate setText:[df stringFromDate:eventOfMarker.startTime]];
    [infoWindow.endDate setText:[df stringFromDate:eventOfMarker.endTime]];
    return infoWindow;
}

@end
