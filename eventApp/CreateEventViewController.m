#import "CreateEventViewController.h"
@interface CreateEventViewController ()
@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *pricePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *toPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *fromPicker;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pricePicker.maximumValue = 100;
    _pricePicker.popUpViewCornerRadius = 8.0;
    [_pricePicker setMaxFractionDigitsDisplayed:0];
    _pricePicker.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    [_pricePicker showPopUpViewAnimated:NO];
    _pricePicker.dataSource = self;
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


@end
