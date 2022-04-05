
#import "GODBManager.h"
#import <FMDatabase.h>

@interface GODBManager ()

@property (nonatomic, strong) FMDatabase *dataBase;

@end

@implementation GODBManager

static GODBManager *instance = nil;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"database.db"];
        instance.dataBase = [FMDatabase databaseWithPath:path];
        [instance.dataBase open];
    });
    return instance;
}

- (BOOL)createTable:(NSString *)table {
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, key text, data text)", table];
    if ([instance.dataBase executeStatements:sql]) {
        return YES;
    }
    return NO;
}

- (BOOL)dropTable:(NSString *)table {
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", table];
    if ([instance.dataBase executeStatements:sql]) {
        return YES;
    }
    return NO;
}
- (BOOL)insert:(NSString *)table key:(NSString *)key data:(id)data {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (key, data) VALUES ('%@', '%@')", table, key, data];
    if ([instance.dataBase executeUpdate:sql]) {
        return YES;
    }
    return NO;
}

- (BOOL)delete:(NSString *)table key:(NSString *)key {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE key = '%@'", table, key];
    if ([instance.dataBase executeUpdate:sql]) {
        return YES;
    }
    return NO;
}

- (BOOL)update:(NSString *)table key:(NSString *)key data:(id)data {
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET data = '%@' WHERE key = '%@'", table, data, key];
    if ([instance.dataBase executeUpdate:sql]) {
        return YES;
    }
    return NO;
}

- (NSArray *)select:(NSString *)table {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ", table];
    FMResultSet *s = [instance.dataBase executeQuery:sql];
    NSMutableArray *datas = [NSMutableArray array];
    while ([s next]) {
        NSString *data = [s stringForColumn:@"data"];
        [datas addObject:data];
    }
    return datas.copy;
}

- (NSArray *)select:(NSString *)table range:(NSRange)range {
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ LIMIT %lu, %lu", table, (unsigned long)range.location, (unsigned long)range.length];
    FMResultSet *s = [instance.dataBase executeQuery:sql];
    NSMutableArray *datas = [NSMutableArray array];
    while ([s next]) {
        NSString *data = [s stringForColumn:@"data"];
        [datas addObject:data];
    }
    return datas.copy;
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
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ WHERE key = '%@'", table, key];
    FMResultSet *set = [_dataBase executeQuery:sql];
    while ([set next]) {
        return YES;
    }
    return NO;
}

- (void)close {
    [instance.dataBase close];
}

@end
