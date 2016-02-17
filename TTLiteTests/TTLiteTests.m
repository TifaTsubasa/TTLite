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
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"test.sqlite"];
        _lite = [TTLite liteWithPath:path queryNames:@[@"ID", @"name"]];
        
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
    NSLog(@"%@", casts);
    
    if ([self.lite insertObject:casts.lastObject]) {
        NSLog(@"insert success");
    } else {
        NSLog(@"failure");
    }
}

- (void)testDelete
{
    if ([self.lite deleteObjectWithCondition:@"ID = '1036321'"]) {
        NSLog(@"delete success");
    } else {
        NSLog(@"delete failure");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
