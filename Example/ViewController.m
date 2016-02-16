//
//  ViewController.m
//  TTLite
//
//  Created by TifaTsubasa on 16/2/16.
//  Copyright © 2016年 tifatsubasa. All rights reserved.
//

#import "ViewController.h"
#import "Cast.h"
#import <MJExtension.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"casts" ofType:nil]];
    NSData *castsData = [NSData dataWithContentsOfURL:path];
    NSArray *casts = [Cast mj_objectArrayWithKeyValuesArray:[NSJSONSerialization JSONObjectWithData:castsData options:NSJSONReadingMutableLeaves error:nil]];
    NSLog(@"%@", casts);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
