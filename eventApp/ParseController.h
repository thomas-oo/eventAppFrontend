#import <Foundation/Foundation.h>

@interface ParseController : NSObject //singleton class

+ (id)sharedManager;
- (id)init NS_UNAVAILABLE;

@end
