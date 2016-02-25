//
//  TTLiteTests.m
//  TTLiteTests
//
//  Created by TifaTsubasa on 16/2/16.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTLite.h"
#import "Cast.h"
#import "TTLite.h"
#import <MJExtension.h>

@interface TTLiteTests : XCTestCase

@property (nonatomic, strong) TTLite *lite;

@end

@implementation TTLiteTests

- (TTLite *)lite
{
    if (! _lite) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"food.sqlite"];
        _lite = [TTLite liteWithPath:path storeClass:[Cast class]];
        [TTLite liteWithPath:path storeClass:[UIViewController class]];
    }
    return _lite;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
}

- (void)testInsert
{
    NSURL *castsPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"casts" ofType:nil]];
    NSData *castsData = [NSData dataWithContentsOfURL:castsPath];
    NSArray *casts = [Cast mj_objectArrayWithKeyValuesArray:[NSJSONSerialization JSONObjectWithData:castsData options:NSJSONReadingMutableLeaves error:nil]];
    
    Cast *cast = casts.lastObject;
    cast.isOk = YES;
    [self.lite insertObject:cast];
}

- (void)testMultiInsert
{
    NSURL *castsPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"casts" ofType:nil]];
    NSData *castsData = [NSData dataWithContentsOfURL:castsPath];
    NSArray *casts = [Cast mj_objectArrayWithKeyValuesArray:[NSJSONSerialization JSONObjectWithData:castsData options:NSJSONReadingMutableLeaves error:nil]];
    
    [self.lite insertObjects:casts];
}

- (void)testUpdate
{
    Cast *cast = [[Cast alloc] init];
    cast.alt = @"https://google.com";
    cast.ID = 112233;
    cast.name = nil;
    cast.isOk = YES;
    [self.lite updateObject:cast condition:@"ID = 1036321"];
}

- (void)testDelete
{
    [self.lite deleteObjectWithCondition:@"ID = 1036321"];
}

- (void)testSelect
{
    [self.lite queryObjectsWithCondition:@"ID like '%%223%%'" result:^(NSArray *result) {
        Cast *cast = result.lastObject;
//        XCTAssertTrue([cast.alt isEqualToString:@"https://google.com"], @"alt right");
//        XCTAssertTrue([cast.name isEqualToString:@"update test"], @"name right");
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
