//
//  ZPSevenViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/27.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPSevenViewController.h"

typedef void(^ZPBlock)(void);

@interface ZPSevenViewController ()

@end

@implementation ZPSevenViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"SevenViewController";
    
    [self test];
    
//    [self test1];
    
//    [self test2];
    
//    [self test3];
}

#pragma mark ————— 在block代码块内修改代码块外的auto局部变量的值的方式1 —————
/**
 给在代码块外的auto局部变量前面添加"static"关键字，然后就能在代码块内修改它的值了；
 这样做的弊端在于，原本是一个局部变量，出了它的作用域就会被销毁，但是加了"static"关键字之后，它就由局部变量变为了静态变量了，出了它的作用域也不会被销毁了，内存会驻留于整个项目中。
 */
- (void)test
{
    static int age = 10;
    
    ZPBlock block = ^{
        age = 20;
        
        NSLog(@"age is %d", age);
    };
    
    block();
}

#pragma mark ————— 在block代码块内修改代码块外的auto局部变量的值的方式2 —————
/**
 事先声明一个全局变量，然后就可以在block代码块内修改它的值了；
 这样做的弊端跟test方法中的相同，内存也不会被销毁，会驻留于整个项目中。
 */
int height = 170;

- (void)test1
{
    ZPBlock block = ^{
        height = 180;
        
        NSLog(@"height = %d", height);
    };
    
    block();
}

#pragma mark ————— 在block代码块内修改代码块外的auto局部变量的值的方式3 —————
/**
 用"__block"修饰符修饰一个在代码块外的auto局部变量（基本数据类型），然后就能在代码块内修改它的值了；
 这样做的好处是不更改变量的性质，原来是局部变量的还是局部变量，更改前后这个变量的内存都是出了它的作用域就会被销毁，不会占用多余的内存空间。
 */
- (void)test2
{
    __block int age = 10;
    
    ZPBlock block = ^{
        age = 20;
        
        NSLog(@"age = %d", age);
    };
    
    block();
}

- (void)test3
{
    NSMutableArray *mulArray = [NSMutableArray array];
    
    ZPBlock block = ^{
        /**
         这是在使用mulArray，而不是修改mulArray，所以编译能够通过，不用加"__block"修饰符。
         */
        [mulArray addObject:@"123"];
        
        NSLog(@"mulArray = %@", mulArray);
    };
    
    block();
}

@end
