#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    if([PFUser currentUser] == nil){
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc] init];
        loginViewController.delegate = self;
        
        loginViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsSignUpButton | PFLogInFieldsFacebook;
        loginViewController.emailAsUsername = YES;
        loginViewController.signUpController.delegate = self;
        
        //explicitly ask for permissions here (we can use this email to make sure that the user hasnt already signed up using this email, or when the user signs up, that a previous facebook account with the same email is not already signed up)
        //loginViewController.facebookPermissions = [@"email"];
        [self presentViewController:loginViewController animated:NO completion:nil];
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
    }];
    [alertController addAction:(OKAction)];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    [PFUser logOut];
}







@end
