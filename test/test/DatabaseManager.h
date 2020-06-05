//
//  DatabaseManager.h
//  test
//
//  Created by MAC on 2018/8/22.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

+ (instancetype)sharedInstance ;

- (BOOL)createTable:(NSString *)table arguments:(NSArray *)arguments ;
- (BOOL)insert:(NSString *)table keys:(NSArray *)keys values:(NSArray *)values ;
- (BOOL)delete:(NSString *)table key:(NSString *)key ;
- (BOOL)update:(NSString *)table Id:(NSString *)Id key:(NSString *)key value:(NSString *)value ;
- (NSMutableArray *)selectAll:(NSString *)table ;
- (NSMutableArray *)select:(NSString *)table startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex ;
- (NSMutableArray *)selectAll:(NSString *)table arguments:(NSArray *)arguments ;
- (NSUInteger)totalCount:(NSString *)table ;
- (BOOL)isInclude:(NSString *)table key:(NSString *)key ;

@end
