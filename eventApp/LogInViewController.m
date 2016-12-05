//
//  LogInViewController.m
//  eventApp
//
//  Created by Thomas Oo on 2016-12-05.
//  Copyright © 2016 Oo, Thein. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

UIImageView *backgroundImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"launch_bg"]];
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    PFLogInView *logInView = self.logInView;
    [logInView insertSubview:backgroundImage atIndex:0];
    
    UILabel *logo = [[UILabel alloc] init];
    [logo setText:@"Event App"];
    [logo setTextColor:[UIColor whiteColor]];
    [logo setFont:[UIFont fontWithName:@"SanFranciscoText-Light" size:70]];
    logInView.logo = logo;
    
    [logInView.logo sizeToFit];
    CGRect newFrame = CGRectMake(logInView.logo.frame.origin.x, logInView.usernameField.frame.origin.y - logInView.logo.frame.size.height - 16, logInView.frame.size.width, logInView.logo.frame.size.height);
    [logInView.logo setFrame:newFrame];
    
    [self makeButtonTransparent:logInView.logInButton];
    [self makeButtonTransparent:logInView.facebookButton];
    [self makeButtonTransparent:logInView.signUpButton];
    [self makeButtonTransparent:logInView.passwordForgottenButton];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    backgroundImage.frame = CGRectMake(0,0, self.logInView.frame.size.width, self.logInView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeButtonTransparent:(UIButton*)button{
    [button setBackgroundImage:nil forState:normal];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:normal];
//    button.layer.cornerRadius = 5;
//    button.layer.borderWidth = 1;
//    button.layer.borderColor = [UIColor whiteColor].CGColor;
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
