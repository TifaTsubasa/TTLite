//
//  TTLite.h
//  TTLite
//
//  Created by TifaTsubasa on 16/2/17.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TTKeyValue.h"

@interface TTLite : NSObject

+ (instancetype)liteWithPath:(NSString *)path storeClass:(Class)cls;

- (instancetype)initWithPath:(NSString *)path;

- (BOOL)insertObject:(NSObject *)obj;

- (BOOL)deleteObjectWithCondition:(NSString *)condition;

- (BOOL)updateObject:(NSObject *)obj condition:(NSString *)condition;

- (NSArray *)objectsWithCondition:(NSString *)condition;

@end
