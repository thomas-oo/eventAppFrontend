#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

@interface MapViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *marker;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation MapViewController
BOOL firstLocationUpdate;
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
    [self.mapView setMinZoom:10 maxZoom:20];
    
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
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(nonnull GMSCameraPosition *)position{
    if(!_marker.hidden){
        [_doneButton setHidden:NO];
    }
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    if(!_marker.hidden){
        [_doneButton setHidden:YES];
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
}
- (IBAction)cancelButtonClicked:(id)sender {
    [_addButton setHidden:NO];
    [_marker setHidden:YES];
    [_cancel setHidden:YES];
    [_doneButton setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:15];
        [self.mapView removeObserver:self forKeyPath:@"myLocation"];
    }
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
