//
//  CreateEventViewController.m
//  eventApp
//
//  Created by Thomas Oo on 2017-01-30.
//  Copyright © 2017 Oo, Thein. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController ()
@property (strong, nonatomic) IBOutlet UISlider *pricePicker;
@property (strong, nonatomic) IBOutlet UILabel *currentPriceLabel;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)valueChanged:(id)sender {
    _currentPriceLabel.text = [NSString stringWithFormat:@"%.2f", _pricePicker.value];
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
