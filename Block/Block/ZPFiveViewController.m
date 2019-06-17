//
//  ZPFiveViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/22.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 在ARC环境下，编译器会根据如下的四种情况自动将内存中栈上的block对象复制到堆上。
 */
#import "ZPFiveViewController.h"

typedef void(^ZPBlock)(void);

@interface ZPFiveViewController ()

@end

@implementation ZPFiveViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"FiveViewController";
    
//    [self test];
    
//    [self test1];
    
//    [self test2];
    
    [self test3];
}

/**
 1、在ARC环境下，block作为函数的返回值时，编译器会自动将内存中栈上的block复制到堆上：
 这个block对象访问了auto局部变量，是属于__NSStackBlock__类型的，存储在内存中的栈上。在ARC环境下，对于这种以block作为函数的返回值的函数，系统会在该函数内最后返回block对象的时候自动做一次copy调用，把这个block对象复制到堆上，并且把它的类型由__NSStackBlock__变为__NSMallocBlock__。
 */
ZPBlock myblock()
{
    int age = 10;
    return ^{
        NSLog(@"age = %d", age);
    };
}

- (void)test
{
    ZPBlock block = myblock();
    
    block();
    
    NSLog(@"%@", [block class]);
}

/**
 2、在ARC环境下，被强指针指着的block对象，编译器会自动将内存中栈上的block复制到堆上：
 在MRC环境下，这个block对象被强指针指着，是属于__NSStackBlock__类型的，存储在内存中的栈上，所以在MRC环境下此刻打印的结果是__NSStackBlock__。在ARC环境下，对于这种被强指针指着的block对象，系统会自动给它做copy操作，把这个block对象复制到堆上，并且把它的类型由__NSStackBlock__变为__NSMallocBlock__，所以在ARC环境下此刻打印的结果是__NSMallocBlock__。
 */
- (void)test1
{
    int age = 10;
    
    ZPBlock block = ^{
        NSLog(@"age = %d", age);
    };
    
    NSLog(@"%@", [block class]);
}

/**
 3、在ARC环境下，对于以block作为方法参数，并且方法名中含有"usingBlock"字样的方法来讲，系统会给这个block参数进行copy操作，并且把这个block对象复制到内存中的堆上去。
 */
- (void)test2
{
    NSArray *array = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ;
    }];
}

/**
 4、在ARC环境下，block对象作为GCD API的方法参数的时候，系统会给这个block参数进行copy操作，并且把这个block对象复制到内存中的堆上去。
 */
- (void)test3
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ;
    });
}

@end
