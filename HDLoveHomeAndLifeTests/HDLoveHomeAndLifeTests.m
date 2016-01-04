//
//  HDLoveHomeAndLifeTests.m
//  HDLoveHomeAndLifeTests
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface HDLoveHomeAndLifeTests : XCTestCase

@end

@implementation HDLoveHomeAndLifeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testMyZZU {
    XCTAssertEqual(@1, @2);
}
@end
