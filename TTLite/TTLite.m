//
//  TTLite.m
//  TTLite
//
//  Created by TifaTsubasa on 16/2/17.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import "TTLite.h"
#import <FMDB/FMDB.h>

@interface TTLite ()

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *sqlName;

@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) NSArray *queryNames;

@end

@implementation TTLite

+ (instancetype)liteWithPath:(NSString *)path storeClass:(__unsafe_unretained Class)cls
{
    TTLite *lite = [[TTLite alloc] initWithPath:path];
    if ([cls respondsToSelector:@selector(tt_queryPropertyNames)]) {
        lite.queryNames = [cls tt_queryPropertyNames];
    }
    
    NSString *name = [path lastPathComponent];
    NSRange range = [name rangeOfString:@"."];
    lite.sqlName = [name substringToIndex:range.location];
    
    NSMutableString *queryString = [NSMutableString string];
    for (NSString *name in lite.queryNames) {
        NSString *str = [NSString stringWithFormat:@"%@ text, ", name];
        [queryString appendString:str];
    }
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id integer PRIMARY KEY, %@obj blob);", lite.sqlName, queryString];
    
    lite.db = [FMDatabase databaseWithPath:path];
    if ([lite.db open]) {
        if (![lite.db executeUpdate:createSql]) {
            NSLog(@"create db failure");
        }
    } else {
        NSLog(@"open db failure");
    }
    
    return lite;
}

- (instancetype)initWithPath:(NSString *)path
{
    if (self = [super init]) {
        self.path = path;
    }
    return self;
}

- (BOOL)insertObject:(NSObject *)obj
{
    if (![self confirmPath]) {
        return NO;
    }
    
    NSMutableString *queryString = [NSMutableString string];
    NSMutableArray *propertyArray = [NSMutableArray array];
    NSMutableString *placeholders = [NSMutableString string];
    for (NSString *name in _queryNames) {
        NSString *str = [NSString stringWithFormat:@"%@, ", name];
        [queryString appendString:str];
        [propertyArray addObject:[obj valueForKey:name]];
        [placeholders appendString:@"?, "];
    }
    [placeholders appendString:@"?"];
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(%@obj) VALUES (%@);", _sqlName, queryString, placeholders];
    
    [propertyArray addObject:obj];
    NSLog(@"%@", insertSql);
    return [_db executeUpdate:insertSql values:propertyArray error:nil];
}

- (BOOL)deleteObjectWithCondition:(NSString *)condition
{
    if (![self confirmPath]) {
        return NO;
    }
    
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", _sqlName, condition];
    return [_db executeUpdate:deleteSql];
}

- (BOOL)updateObject:(NSObject *)obj condition:(NSString *)condition
{
    if (![self confirmPath]) {
        return NO;
    }
    
    NSMutableString *selString = [NSMutableString string];
    NSMutableArray *placeholders = [NSMutableArray array];
    for (NSString *name in _queryNames) {
        [selString appendString:[NSString stringWithFormat:@"%@ = ?, ", name]];
        [placeholders addObject:[obj valueForKey:name]];
    }
    [selString appendString:@"obj = ?"];
    [placeholders addObject:obj];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", _sqlName, selString, condition];
    return [_db executeUpdate:updateSql values:placeholders error:nil];
}

- (BOOL)confirmPath
{
    if (self.path == nil || [self.path isEqualToString:@""]) {
        NSLog(@"please set sql path first");
        return NO;
    } else {
        return YES;
    }
}
@end
