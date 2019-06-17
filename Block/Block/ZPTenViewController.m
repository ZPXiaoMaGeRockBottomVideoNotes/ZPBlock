//
//  ZPTenViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/31.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 在运行本类代码的时候应该把项目由ARC环境变为MRC环境。在TARGETS中的Build Settings中的All中搜索"automatic re"，然后在搜索结果中把ARC由YES该为NO，即项目就由ARC环境变为了MRC环境了。
 */
#import "ZPTenViewController.h"
#import "ZPPerson.h"

@interface ZPTenViewController ()

@end

@implementation ZPTenViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"TenViewController";
    
//    [self test];
    
//    [self test1];
}

#pragma mark ————— 在MRC环境下避免block循环引用的方式1：使用"__unsafe_unretained"关键字 —————
//- (void)test
//{
//    {
//        /**
//         在MRC环境下不能使用"__weak"关键字，只能使用"__unsafe_unretained"关键字来修饰那个指针，把强指针置为弱指针。
//         */
//        __unsafe_unretained ZPPerson *person = [[ZPPerson alloc] init];
//        person.age = 10;
//        person.block = [^{
//            NSLog(@"age is %d", person.age);
//        } copy];
//
//        [person release];
//    }
//
//    NSLog(@"$$$$$$$$$$$");
//}

#pragma mark ————— 在MRC环境下避免block循环引用的方式2：使用"__block"关键字 —————
//- (void)test1
//{
//    {
//        /**
//         在MRC环境下可以使用"__block"关键字来修饰那个指针，从而避免block的引用循环。
//         */
//        __block ZPPerson *person = [[ZPPerson alloc] init];
//        
//        person.age = 10;
//        person.block = [^{
//            NSLog(@"age is %d", person.age);
//        } copy];
//        
//        [person release];
//    }
//    
//    NSLog(@"$$$$$$$$$$$");
//}

@end
