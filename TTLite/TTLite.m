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

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

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
    lite.sqlName = [NSString stringWithFormat:@"t_%@", [name substringToIndex:range.location]];
    
    NSMutableString *queryString = [NSMutableString string];
    for (NSString *name in lite.queryNames) {
        NSString *str = [NSString stringWithFormat:@"%@ text, ", name];
        [queryString appendString:str];
    }
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id integer PRIMARY KEY, %@obj blob);", lite.sqlName, queryString];
    
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    lite.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    if ([db open]) {
        if (![db executeUpdate:createSql]) {
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

- (void)insertObject:(NSObject *)obj
{
    if (![self confirmPath]) return;
    
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
    
    [propertyArray addObject:[NSKeyedArchiver archivedDataWithRootObject:obj]];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql values:propertyArray error:nil];
    }];
}

- (void)insertObjects:(NSArray *)objs
{
    if (![self confirmPath]) return;
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject *obj in objs) {
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
            
            [propertyArray addObject:[NSKeyedArchiver archivedDataWithRootObject:obj]];
            if (![db executeUpdate:insertSql values:propertyArray error:nil]) {
                NSLog(@"insert failure");
            }
        }
    }];
}

- (void)deleteObjectWithCondition:(NSString *)condition
{
    if (![self confirmPath]) return;
    
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", _sqlName, condition];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:deleteSql]) {
            NSLog(@"delete failure");
        }
    }];
}

- (void)updateObject:(NSObject *)obj condition:(NSString *)condition
{
    if (![self confirmPath]) return;
    
    NSMutableString *selString = [NSMutableString string];
    NSMutableArray *placeholders = [NSMutableArray array];
    for (NSString *name in _queryNames) {
        [selString appendString:[NSString stringWithFormat:@"%@ = ?, ", name]];
        [placeholders addObject:[obj valueForKey:name]];
    }
    [selString appendString:@"obj = ?"];
    [placeholders addObject:[NSKeyedArchiver archivedDataWithRootObject:obj]];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", _sqlName, selString, condition];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:updateSql values:placeholders error:nil]) {
            NSLog(@"update failure");
        }
    }];
}

- (void)queryObjectsWithCondition:(NSString *)condition result:(void (^)(NSArray *))result
{
    if (![self confirmPath]) return;
    
//    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", _sqlName, condition];
    
    [self queryObjectsWithCondition:condition limit:NSRangeZero orderBy:nil ascending:YES result:^(NSArray *resultArray) {
        if (result) {
            result(resultArray);
        }
    }];
}

- (void)queryObjectsWithCondition:(NSString *)condition limit:(NSRange)range orderBy:(NSString *)sortName ascending:(BOOL)asc result:(void (^)(NSArray *))result
{
    if (![self confirmPath]) return;
    
    NSString *queryStr = [NSString string];
    NSString *rangeStr = [NSString string];
    NSString *sortStr = [NSString string];
    NSString *ascendStr = [NSString string];
    if (condition) {
        queryStr = [NSString stringWithFormat:@"WHERE %@", condition];
    }
    if (!(range.location == 0 && range.length == 0)) {
        rangeStr = [NSString stringWithFormat:@"LIMIT %ld,%ld", (unsigned long)range.location, (unsigned long)range.length];
    }
    if (!asc) {
        ascendStr = @"DESC";
    }
    if (sortName) {
        sortStr = [NSString stringWithFormat:@"ORDER BY %@ %@", sortName, ascendStr];
    }
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ %@ %@ %@", _sqlName, queryStr, sortStr, rangeStr];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *set = [db executeQuery:selectSql];
        NSMutableArray *resultArray = [NSMutableArray array];
        while ([set next]) {
            NSObject *obj = [NSKeyedUnarchiver unarchiveObjectWithData:[set dataForColumnIndex:set.columnCount - 1]];
            [resultArray addObject:obj];
        }
        if (result) {
            result(resultArray);
        }
    }];
}

#pragma mark -- private method
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
