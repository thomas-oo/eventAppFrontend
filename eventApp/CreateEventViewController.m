#import "CreateEventViewController.h"
@interface CreateEventViewController ()
@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *pricePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *toPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *fromPicker;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *eventNameField;

@end

@implementation CreateEventViewController
CLLocationCoordinate2D currentCoordinates;

- (void)setCoordinates:(CLLocationCoordinate2D)coordinates{
    currentCoordinates = coordinates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pricePicker.maximumValue = 100;
    _pricePicker.popUpViewCornerRadius = 8.0;
    [_pricePicker setMaxFractionDigitsDisplayed:0];
    _pricePicker.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
    [_pricePicker showPopUpViewAnimated:NO];
    _pricePicker.dataSource = self;
    
    _eventNameField.delegate = self;
    _eventNameField.floatingLabelFont = [UIFont systemFontOfSize:30 weight:UIFontWeightThin];
    // Do any additional setup after loading the view.
}
- (IBAction)roundValues:(id)sender {
    _pricePicker.value = round(_pricePicker.value);
}

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    return [NSString stringWithFormat:@"$%.0f", value];
}

- (IBAction)changeToPicker:(id)sender {
    _toPicker.minimumDate = _fromPicker.date;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_eventNameField resignFirstResponder];
    return YES;
}

- (IBAction)createEvent:(id)sender {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 
                 NSString* name = _eventNameField.text;
                 NSString* host = [result valueForKey:@"name"];
                 NSDate* startTime = _fromPicker.date;
                 NSDate* endTime = _toPicker.date;
                 PFGeoPoint* location = [PFGeoPoint geoPointWithLatitude:currentCoordinates.latitude longitude:currentCoordinates.longitude];
                 NSNumber* price = [NSNumber numberWithFloat:_pricePicker.value];
                 UIImage* image = [UIImage imageNamed:@"samosa"];
                 Event* newEvent = [[Event alloc] initEventWithName:name Host:host StartTime:startTime EndTime:endTime Location:location Price:price Image:image];
                 //TODO: check for valid input so that event creation does not crash. If invalid input, reflect it to the user.
                 [newEvent saveInBackgroundWithBlock:^(BOOL success, NSError* error){
                     if(success){
                         [self performSegueWithIdentifier:@"successSegue" sender:nil];
                     }else{
                         //TODO: on failure to save, reflect the error to the user.
                         NSLog(@"Failed to save event.");
                     }
                 }];
             }
         }];
    }
}



@end
