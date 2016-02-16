//
//  TTFMDBTool.m
//  TTLite
//
//  Created by TifaTsubasa on 16/2/16.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import "TTFMDBTool.h"
#import <FMDB/FMDB.h>

@implementation TTFMDBTool

static FMDatabase *_db;

+ (void)openDbWithPath:(NSString *)path
{
    _db = [FMDatabase databaseWithPath:path];
    NSString *createSql = @"CREATE TABLE IF NOT EXISTS t_shop (id integer PRIMARY KEY, name text NOT NULL, obj blob);";
    if ([_db open]) {
        NSLog(@"open db success");
        if ([_db executeUpdate:createSql]) {
            NSLog(@"create db success");
        } else {
            NSLog(@"create db failure");
        }
    } else {
        NSLog(@"open db failure");
    }
}

@end
