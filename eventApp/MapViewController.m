#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

@interface MapViewController ()

@end

@implementation MapViewController
GMSMapView *mapView;
BOOL firstLocationUpdate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                            longitude:0
                                                                 zoom:15];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    [mapView setMinZoom:10 maxZoom:20];
    
    [mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.view = mapView;
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
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:15];
        [mapView removeObserver:self forKeyPath:@"myLocation"];
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
