#import "ViewController.h"
#import "LogInViewController.h"
#import "MapViewController.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"
@interface ViewController ()
@property Event *pfEvent;
@end

@implementation ViewController
@synthesize pfEvent;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([PFUser currentUser] == nil){
        LogInViewController *logInViewController = [[LogInViewController alloc]init];
        logInViewController.delegate = self;
        
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsSignUpButton | PFLogInFieldsFacebook;
        logInViewController.emailAsUsername = YES;
        logInViewController.signUpController.delegate = self;
        
        //explicitly ask for permissions here (we can use this email to make sure that the user hasnt already signed up using this email, or when the user signs up, that a previous facebook account with the same email is not already signed up)
        //loginViewController.facebookPermissions = [@"email"];
        [self presentViewController:logInViewController animated:NO completion:nil];
    }else{
        [self presentLoggedInAlert];
    }
}

- (void)logInViewController:(PFLogInViewController*)logInController didLogInUser:(nonnull PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self presentLoggedInAlert];
}

- (void) presentLoggedInAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You're logged in" message:@"Welcome to Event App" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
        //MapViewController *mapViewController = [[MapViewController alloc]init];
        //[self presentViewController:mapViewController animated:NO completion:nil];
        
        MainMenuViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        [self presentViewController:tabBarController animated:NO completion:nil];
        
    }];
    [alertController addAction:(OKAction)];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*- (IBAction)logout:(id)sender {
    [PFUser logOut];
}

- (IBAction)createEvents:(id)sender {
    PFGeoPoint *pfEventLocation = [PFGeoPoint geoPointWithLatitude:40.0 longitude:-30.0];
    pfEvent = [[Event alloc] initEventWithName:@"Test" Host:@"Thomas Oo" StartTime:[[NSDate alloc] init] EndTime:[[NSDate alloc] init] Location:pfEventLocation Price:@30];
    [pfEvent setValue:[PFUser currentUser] forKey:@"Creator"];
    [pfEvent saveInBackground];
}
- (IBAction)updateDateOfEvent:(id)sender {
    [pfEvent setStartTime:[[NSDate alloc] init]];
    [pfEvent setEndTime:[[NSDate alloc] init]];
    [pfEvent saveInBackground];
}*/









@end
