//
//  NSObject+TTKeyValue.h
//  TTLite
//
//  Created by TifaTsubasa on 16/2/17.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTKeyValue <NSObject>
@optional
+ (NSArray *)tt_queryPropertyNames;

@end

@interface NSObject (TTKeyValue) <TTKeyValue>

@end
