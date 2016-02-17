//
//  TTLite.h
//  TTLite
//
//  Created by TifaTsubasa on 16/2/17.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TTKeyValue.h"

#define NSRangeZero NSMakeRange(0, 0)

@interface TTLite : NSObject

+ (instancetype)liteWithPath:(NSString *)path storeClass:(Class)cls;

- (void)insertObject:(NSObject *)obj;

- (void)insertObjects:(NSArray *)objs;

- (void)deleteObjectWithCondition:(NSString *)condition;

- (void)updateObject:(NSObject *)obj condition:(NSString *)condition;

- (void)queryObjectsWithCondition:(NSString *)condition result:(void(^)(NSArray *resultArray))result;

- (void)queryObjectsWithCondition:(NSString *)condition limit:(NSRange)range orderBy:(NSString *)sortName ascending:(BOOL)asc result:(void (^)(NSArray *resultArray))result;

@end
