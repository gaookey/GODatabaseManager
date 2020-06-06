# SPDatabaseManager



### FMDB数据库操作部分方法

```objective-c
- (BOOL)createTable:(NSString *)table arguments:(NSArray *)arguments ;

- (BOOL)insert:(NSString *)table arguments:(NSDictionary *)arguments ;

- (BOOL)delete:(NSString *)table key:(NSString *)key ;

- (BOOL)update:(NSString *)table key:(NSString *)key arguments:(NSDictionary *)arguments ;

- (NSArray *)select:(NSString *)table ;

- (NSArray *)select:(NSString *)table arguments:(NSArray *)arguments ;

- (NSArray *)select:(NSString *)table range:(NSRange)range ;

- (NSArray *)select:(NSString *)table arguments:(NSArray *)arguments range:(NSRange)range ;

- (NSUInteger)totalCount:(NSString *)table ;

- (BOOL)isInclude:(NSString *)table key:(NSString *)key ;
```

