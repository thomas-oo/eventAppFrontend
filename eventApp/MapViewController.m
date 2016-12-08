#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "Event.h"
#import "MapManager.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    [self.mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    //TODO: maybe implement a way to switch the map theme depending on the time
    NSURL *styleUrl = [mainBundle URLForResource:@"style" withExtension:@"json"];
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
    NSString* name = @"Party";
    NSString* host = @"Thomas Oo";
    NSDate* startTime = [[NSDate alloc] init];
    NSDate* endTime = [[NSDate alloc] init];
    CLLocationCoordinate2D currentCoordinates = [currentPosition target];
    PFGeoPoint* location = [PFGeoPoint geoPointWithLatitude:currentCoordinates.latitude longitude:currentCoordinates.longitude];
    NSNumber* price = @20;
    
    Event* newEvent = [[Event alloc] initEventWithName:name Host:host StartTime:startTime EndTime:endTime Location:location Price:price];
    
    [newEvent saveInBackgroundWithBlock:^(BOOL success, NSError* error){
        if(success){
            //create marker
            MapManager* mapManager = [MapManager sharedManager];
            GMSMarker* marker = [mapManager createMarkerWithEvent:newEvent];
            marker.map = [self mapView];
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
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithRegion:self.mapView.projection.visibleRegion];
    MapManager *mapManager = [MapManager sharedManager];
    [mapManager queryForEventsWithinGeoBox:bounds];
    
    
//    NSArray* markers = [mapManager createMarkersWithEvents:objects];
//    for(GMSMarker *marker in markers){
//        marker.map = self.mapView;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //load markers
        NSMutableArray* events = [change objectForKey:NSKeyValueChangeNewKey];
        NSSet* newMarkers = [[MapManager sharedManager] getNewMarkers];
        for(GMSMarker *marker in newMarkers){
            marker.map = self.mapView;
        }
    }
}

- (void)registerListenerForLoadedEvents{
    MapManager* mapManager = [MapManager sharedManager];
    [mapManager addObserver:self forKeyPath:@"loadedEvents" options:NSKeyValueObservingOptionNew context:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
