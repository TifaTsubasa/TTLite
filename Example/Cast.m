//
//  Cast.m
//  TTLite
//
//  Created by TifaTsubasa on 16/2/16.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import "Cast.h"
#import <MJExtension.h>
#import "TTLite.h"

@implementation Cast

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

+ (NSArray *)tt_queryPropertyNames
{
    return @[@"ID", @"name"];
}

@end
