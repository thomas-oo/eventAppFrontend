#import "ParseController.h"

@implementation ParseController
static ParseController* _sharedParseController = nil;

- (id)initPrivate{
    if (!_sharedParseController) {
        _sharedParseController = [super init];
    }
    return _sharedParseController;
}

+ (id)sharedManager{
    @synchronized([ParseController class])
    {
        if (!_sharedParseController)
            _sharedParseController = [[ParseController alloc] initPrivate];
        return _sharedParseController;
    }
}
@end
