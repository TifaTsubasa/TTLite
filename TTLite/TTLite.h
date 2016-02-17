//
//  TTLite.h
//  TTLite
//
//  Created by TifaTsubasa on 16/2/17.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTLite : NSObject

+ (instancetype)liteWithPath:(NSString *)path queryNames:(NSArray *)names;

- (instancetype)initWithPath:(NSString *)path;

- (BOOL)insertObject:(NSObject *)obj;

- (BOOL)deleteObjectWithCondition:(NSString *)condition;

@end
