//
//  ViewController.m
//  test
//
//  Created by MAC on 2018/8/22.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "FMDBManager.h"
#import "MyModel.h"

@interface ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) MyModel *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([[FMDBManager shareInstance] isInclude:@"118"]) {
        NSLog(@"有");
    } else {
        NSLog(@"没有");
    }
    
    /*
    NSInteger count = [[FMDBManager shareInstance] count];
    NSLog(@"%ld",(long)count);
    
    NSArray *arr = [[FMDBManager shareInstance] selectAll];
    NSLog(@"%@",arr);
    
    NSArray *arr = [[FMDBManager shareInstance] selectLimit:3 number:5];
    
    [[FMDBManager shareInstance] update:@"7" key:@"age" value:@"456"];
    
    [[FMDBManager shareInstance] deleteWithId:@"2"];
    
    for (int i = 0; i < 20; i ++)
    {
        self.model.ID = [NSString stringWithFormat:@"%d",i];
        self.model.name = [NSString stringWithFormat:@"名字%d",i];
        self.model.age = [NSString stringWithFormat:@"2%d",i];
        self.model.height = [NSString stringWithFormat:@"1.%d",i];
        
        if (i % 2 == 0) {
            self.model.sex = @"1";
        } else {
            self.model.sex = @"2";
        }
        
        [[FMDBManager shareInstance] insert:self.model];
    }
    */
}

- (MyModel *)model {
    if (!_model) {
        _model = [[MyModel alloc] init];
    }
    return _model;
}


@end
