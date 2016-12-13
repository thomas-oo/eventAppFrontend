//
//  InfoWindow.h
//  eventApp
//
//  Created by Thomas Oo on 2016-12-12.
//  Copyright © 2016 Oo, Thein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoWindow : UIView
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *snippet;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *startDate;
@property (strong, nonatomic) IBOutlet UILabel *endDate;

@end
