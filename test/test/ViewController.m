//
//  ViewController.m
//  test
//
//  Created by MAC on 2018/8/22.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseManager.h"
#import "MyModel.h"
#import <YYModel.h>

@interface ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) MyModel *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (MyModel *)model {
    if (!_model) {
        _model = [[MyModel alloc] init];
    }
    return _model;
}


@end
