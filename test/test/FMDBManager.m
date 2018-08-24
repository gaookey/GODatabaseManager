//
//  FMDBManager.m
//  test
//
//  Created by MAC on 2018/8/22.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "FMDBManager.h"

@implementation FMDBManager

+ (instancetype)shareInstance
{
    static FMDBManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dataBase.db"];
        
        _dataBase = [[FMDatabase alloc] initWithPath:path];
        [_dataBase open];

        NSString *sql = @"create table if not exists personTable(id integer primary key autoincrement,ID varchar(256), name varchar(256),age varchar(256),height varchar(256),sex varchar(256))";
        
        if ([_dataBase executeUpdate:sql]) {
            NSLog(@"建表成功");
        } else {
            NSLog(@"建表失败");
        };
    }
    return self;
}

- (BOOL)insert:(MyModel *)model
{
    NSString *sql = @"insert into personTable(ID, name, age, height, sex)values(?,?,?,?,?)";
    
    if ([_dataBase executeUpdate:sql,model.ID, model.name, model.age, model.height, model.sex]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)deleteWithId:(NSString *)Id
{
    NSString *sql = @"delete from personTable where ID = ?";
    
    if ([_dataBase executeUpdate:sql,Id]) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)update:(NSString *)Id key:(NSString *)key value:(NSString *)value
{
    NSString *sql = [NSString stringWithFormat:@"update personTable set %@ = ? where ID = ?",key];
    
    if ([_dataBase executeUpdate:sql,value,Id]) {
        return YES;
    } else {
        return NO;
    }
}
- (NSMutableArray *)selectLimit:(NSInteger)index number:(NSInteger)number
{
    NSString *sql = [NSString stringWithFormat:@"select *from personTable limit %ld, %ld",(long)index, (long)number];

    FMResultSet *s = [_dataBase executeQuery:sql];

    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    while ([s next]) {
        
        MyModel *model = [[MyModel alloc] init];
        
        model.ID = [s stringForColumn:@"ID"];
        model.name = [s stringForColumn:@"name"];
        model.age = [s stringForColumn:@"age"];
        model.height = [s stringForColumn:@"height"];
        model.sex = [s stringForColumn:@"sex"];
        
        [array addObject:model];
    }
    
    return array;
}

- (NSMutableArray *)selectAll
{
    FMResultSet *s = [_dataBase executeQuery:@"select *from personTable"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    while ([s next]) {
        
        MyModel *model = [[MyModel alloc] init];
        
        model.ID = [s stringForColumn:@"ID"];
        model.name = [s stringForColumn:@"name"];
        model.age = [s stringForColumn:@"age"];
        model.height = [s stringForColumn:@"height"];
        model.sex = [s stringForColumn:@"sex"];
        
        [array addObject:model];
    }
    
    return array;
}
- (NSUInteger)count
{
    FMResultSet *s = [_dataBase executeQuery:@"select count(*) from personTable"];
    
    NSUInteger c = 0;
    
    while ([s next]) {
        c = [s intForColumnIndex:0];
    }
    
    return c;
}
- (BOOL)isInclude:(NSString *)Id
{
    NSString *sql = @"select *from personTable where ID = ?";
    
    FMResultSet *set = [_dataBase executeQuery:sql,Id];
    
    while ([set next]) {
        return YES;
    }
    return NO;
}


@end
