#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (CGFloat)collapsedDrawerHeight{
    return 40;
}

- (CGFloat)partialRevealDrawerHeight{
    return 309;
}

- (NSArray<NSString *> *)supportedDrawerPositions{
    return @[@"collapsed",
             @"closed",
             @"partiallyRevealed"];
}

@end
