#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "JVFloatLabeledTextField.h"
#import "ParseClient.h"

@interface CreateEventViewController : UIViewController<ASValueTrackingSliderDataSource,UITextFieldDelegate>

- (void)setCoordinates:(CLLocationCoordinate2D)coordinates;

@end
