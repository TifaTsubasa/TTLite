# TTLite
---
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/TifaTsubasa/TTLite/edit/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/TTLite.svg?style=flat)](http://cocoapods.org/?q=TTLite)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/TTLite.svg?style=flat)](http://cocoapods.org/?q=TTLite)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

简单易用的数据存储方案

### 安装方法

#### CocoaPods
由于依赖于[FMDB](https://github.com/ccgus/fmdb)，以及需要导入sqlite依赖框架，推荐使用CocoPods进行安装
在Podfile文件中添加
`pod 'TTLite'`


### 使用说明

#### 1.初始化模型

TTLite的建表依赖于需要存储对象的类型

##### 1. 以模型`Cast`为例
```
@interface Cast : NSObject

@property (nonatomic, copy) NSString *alt;
@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isOk;

@end
```
##### 2.指定查询条件
在模型实现内，导入`#import <TTLite.h>`
```
+ (NSArray *)tt_queryPropertyNames
{
    return @[@"ID", @"name", @"isOk"];
}
```
实现`tt_queryPropertyNames`标明模型将要作为查询条件的属性
##### 3.模型归档
实现模型的`NSCoding`协议，标准模型能够正确的归解档
推荐[MJExtension](https://github.com/CoderMJLee/MJExtension)的`MJCodingImplementation`宏，一键实现（详见Demo）

#### 2.建表
```
TTLite *lite = [TTLite liteWithPath:path storeClass:[Cast class]]
```
`path`参数为数据库文件路径，同一路径下返回的lite实例管理同一数据库，无需建立单例
`class`参数为存储对象的类型，根据类型名在数据库中建立`t_xxxx`表保存数据，如`t_cast`
#### 3.插入数据
```
[lite insertObject:cast]; // 单个对象插入
[lite insertObjects:casts]; // 多个对象插入
```
#### 4.查询数据
查询使用的条件是简化版的sql语句，更加直观
```
[lite queryObjectsWithCondition:@"ID = '123'" result:^(NSArray *result) {
    Cast *cast = result.lastObject;
}];
```
更多查询方式

|条件|语句|
| -------- | --------:|
|等于某个值	|`ID = '123'`|
|不等于某个值	|`ID != '123'`|
|大于某个值	|ID > '123'|
|小于某个值	|ID < '123'|
|且			|ID > '123' and name != 'jack' |
|或			|ID > '123' or name != 'jack' |
|模糊查询		|`name like '%%ac%%'`|

#### 5.删除数据
```
[lite deleteObjectWithCondition:@"ID = '123'"];
```
`condition`删除所有符合条件的对象数据

#### 6.更新数据
```
Cast *cast = [[Cast alloc] init];
cast.alt = @"https://google.com";
cast.ID = 112233;
cast.name = nil;
cast.isOk = YES;
[lite updateObject:cast condition:@"ID = '123'"];
```
`object`参数，更新后的对象，需要保证新对象所有属性的正确
`condition`更新所有符合条件的对象数据

#### 7.复杂查询
```
- (void)queryObjectsWithCondition:(NSString *)condition limit:(NSRange)range orderBy:(NSString *)sortName ascending:(BOOL)asc result:(void (^)(NSArray *resultArray))result;
```
`condition`查询条件
`range`筛选符合条件的结果
`sortName`用来排序的属性名
`asc`升序或降序(默认为升序)

---
###Help
1.Please commit issues when you encounter bug or expect new function, thanks!

2.Please pull request when you have good idea ^ ^

**E-mail: tifatsubasa@163.com**
