
#import <Foundation/Foundation.h>

@interface GODBManager : NSObject

+ (instancetype)shared ;

- (BOOL)createTable:(NSString *)table ;
- (BOOL)dropTable:(NSString *)table ;

- (BOOL)insert:(NSString *)table key:(NSString *)key data:(id)data ;

- (BOOL)delete:(NSString *)table key:(NSString *)key ;

- (BOOL)update:(NSString *)table key:(NSString *)key data:(id)data ;

- (NSArray *)select:(NSString *)table ;
- (NSArray *)select:(NSString *)table range:(NSRange)range ;

- (NSUInteger)totalCount:(NSString *)table ;

- (BOOL)isInclude:(NSString *)table key:(NSString *)key ;

- (void)close ;

@end
