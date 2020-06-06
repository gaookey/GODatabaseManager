
#import "SPDatabaseManager.h"

@interface SPDatabaseManager ()

@property (nonatomic, strong) FMDatabase *dataBase;

@end

@implementation SPDatabaseManager

static SPDatabaseManager *instance = nil;

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

- (BOOL)insert:(NSString *)table arguments:(NSDictionary *)arguments {
    
    NSMutableArray *ask = [NSMutableArray array];
    for (NSInteger i = 0; i < arguments.allKeys.count; i ++) {
        [ask addObject:[NSString stringWithFormat:@"'%@'", arguments.allValues[i]]];
    }
    NSString *keyStr = [arguments.allKeys componentsJoinedByString:@", "];
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

- (BOOL)update:(NSString *)table key:(NSString *)key arguments:(NSDictionary *)arguments {
    
    NSString *k = arguments.allKeys.firstObject;
    NSString *v = arguments.allValues.firstObject;
    
    NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE id = %@", table, k, v, key]];
    if ([instance.dataBase executeUpdate:sql]) {
        return YES;
    }
    return NO;
}

- (NSArray *)select:(NSString *)table {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ", table];
    return [self selectTable:sql arguments:@[]];
}

- (NSArray *)select:(NSString *)table arguments:(NSArray *)arguments {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ", table];
    return [self selectTable:sql arguments:arguments];
}

- (NSArray *)select:(NSString *)table range:(NSRange)range {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ LIMIT %lu, %lu", table, (unsigned long)range.location, (unsigned long)range.length];
    return [self selectTable:sql arguments:@[]];
}

- (NSArray *)select:(NSString *)table arguments:(NSArray *)arguments range:(NSRange)range {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ LIMIT %lu, %lu", table, (unsigned long)range.location, (unsigned long)range.length];
    return [self selectTable:sql arguments:arguments];
}

- (NSArray *)selectTable:(NSString *)sql arguments:(NSArray *)arguments {
    
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
    return [NSArray arrayWithArray:result];
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
