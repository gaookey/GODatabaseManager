//
//  FMDBManager.h
//  test
//
//  Created by MAC on 2018/8/22.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "MyModel.h"

@interface FMDBManager : NSObject
{
    FMDatabase *_dataBase;
}

+(instancetype)shareInstance;

- (BOOL)insert:(MyModel *)model;

- (BOOL)deleteWithId:(NSString *)Id;

- (BOOL)update:(NSString *)Id key:(NSString *)key value:(NSString *)value;

- (NSMutableArray *)selectLimit:(NSInteger)index number:(NSInteger)number;

- (NSMutableArray *)selectAll;

- (NSUInteger)count;

- (BOOL)isInclude:(NSString *)Id;

@end
