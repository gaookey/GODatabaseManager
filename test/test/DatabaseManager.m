//
//  DatabaseManager.m
//  test
//
//  Created by MAC on 2018/8/22.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "DatabaseManager.h"
#import <FMDatabase.h>

@interface DatabaseManager ()

@property (nonatomic, strong) FMDatabase *dataBase;

@end

@implementation DatabaseManager

static DatabaseManager *instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"database.db"];
        instance.dataBase = [FMDatabase databaseWithPath:path];
        
        [instance.dataBase open];
    });
    return instance;
}

- (BOOL)createTable:(NSString *)table arguments:(NSArray *)arguments {
    
    NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT", table]];
    
    for (NSInteger i = 0; i < arguments.count; i ++) {
        NSString *str = [NSString stringWithFormat:@", %@ text", arguments[i]];
        [sql appendString:str];
    }
    [sql appendString:@")"];
    
    if ([instance.dataBase executeStatements:sql]) {
        return YES;
    }
    return NO;
}

- (BOOL)insert:(NSString *)table keys:(NSArray *)keys values:(NSArray *)values {
    
    NSMutableArray *ask = [NSMutableArray array];
    for (NSInteger i = 0; i < keys.count; i ++) {
        [ask addObject:[NSString stringWithFormat:@"'%@'", values[i]]];
    }
    NSString *keyStr = [keys componentsJoinedByString:@", "];
    NSString *valueStr = [ask componentsJoinedByString:@", "];
    
    NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", table, keyStr, valueStr]];
    if ([instance.dataBase executeUpdate:sql]) {
        return YES;
    }
    return NO;
}

- (BOOL)delete:(NSString *)table key:(NSString *)key {
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %@", table, key];
    if ([instance.dataBase executeUpdate:sql]) {
        return YES;
    }
    return NO;
}

- (BOOL)update:(NSString *)table Id:(NSString *)Id key:(NSString *)key value:(NSString *)value {
    
    NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE id = %@", table, key, value, Id]];
    if ([instance.dataBase executeUpdate:sql]) {
        return YES;
    }
    return NO;
}

- (NSMutableArray *)selectAll:(NSString *)table {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ", table];
    return [self selectTable:sql arguments:@[]];
}

- (NSMutableArray *)select:(NSString *)table startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ LIMIT %ld, %ld", table, (long)startIndex, (long)endIndex];
    return [self selectTable:sql arguments:@[]];
}

- (NSMutableArray *)selectAll:(NSString *)table arguments:(NSArray *)arguments {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ", table];
    return [self selectTable:sql arguments:arguments];
}

- (NSMutableArray *)selectTable:(NSString *)sql arguments:(NSArray *)arguments {
    
    FMResultSet *s = [_dataBase executeQuery:sql];
    
    NSMutableArray *columnArray = [NSMutableArray array];
    if (arguments.count == 0) {
        NSEnumerator *columns = [s.columnNameToIndexMap keyEnumerator];
        NSString *tempcolumn = @"";
        while ((tempcolumn = [columns nextObject])) {
            [columnArray addObject:tempcolumn];
        }
    } else {
        columnArray = [NSMutableArray arrayWithArray:arguments];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    while ([s next]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < columnArray.count; i ++) {
            NSString *value = [s stringForColumn:columnArray[i]];
            [dict setObject:value forKey:columnArray[i]];
        }
        [result addObject:dict];
    }
    return result;
}

- (NSUInteger)totalCount:(NSString *)table {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ ", table];
    FMResultSet *s = [_dataBase executeQuery:sql];
    NSUInteger totalCount = 0;
    while ([s next]) {
        totalCount = [s intForColumnIndex:0];
    }
    return totalCount;
}

- (BOOL)isInclude:(NSString *)table key:(NSString *)key {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ WHERE ID = %@", table, key];
    FMResultSet *set = [_dataBase executeQuery:sql];
    while ([set next]) {
        return YES;
    }
    return NO;
}

@end
