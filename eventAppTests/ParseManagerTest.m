//
//  ParseManagerTest.m
//  eventApp
//
//  Created by Thomas Oo on 2016-12-07.
//  Copyright © 2016 Oo, Thein. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseController.h"
@interface ParseManagerTest : XCTestCase

@end

@implementation ParseManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSingleton{
    ParseController *parseController = [ParseController sharedManager];
    
    ParseController *anotherController = [ParseController sharedManager];
    
    XCTAssertEqualObjects(parseController, anotherController);
}

@end
