//
//  ZPNineViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/29.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPNineViewController.h"
#import "ZPPerson.h"

@interface ZPNineViewController ()

@end

@implementation ZPNineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"NineViewController";
    
//    [self test];
    
//    [self test1];
    
//    [self test2];
    
    [self test3];
}

#pragma mark ————— 在ARC环境下避免block循环引用的方式1：使用"__weak"关键字 —————
/**
 这个方法的block代码块中没有self关键字；
 block循环引用的原因：下面代码中首先有一个强指针"person"指着"ZPPerson"类的一个person对象，这个person对象所对应的内存空间称为”内存空间1“。下面代码中的block对象所对应的内存空间称为”内存空间2“。从源码中可以看出，person对象中有block属性，即内存空间1中有一个"_block"成员变量，这个"_block"成员变量用强指针指着那个block对象（内存空间2）。block对象（内存空间2）的代码块中使用了"person"字眼，即内存空间2中有一个person成员变量，这个person成员变量用强指针指着之前的那个person对象（内存空间1）。当出了下面代码中的大括号的时候，之前指向person对象（内存空间1）的那个"person"强指针就被销毁了，但是，此时person对象（内存空间1）和block对象（内存空间2）都有强指针相互指着，相互引用，所以都不能够释放，这就是造成block循环引用的原因；
 解决block循环引用问题：如果想要修复上面的循环引用的问题，就要把之前的内存空间2中的person成员变量指向person对象（内存空间1）的那个强指针变为弱指针，只有这样，person对象（内存空间1）和block对象（内存空间2）才能够被释放掉。
 */
- (void)test
{
    {
        ZPPerson *person = [[ZPPerson alloc] init];
        person.age = 10;
        
        /**
         在ARC环境下可以使用"__weak"关键字来修饰那个指针，把强指针置为弱指针；
         如果用"__weak"关键字来修饰的话，等这条弱指针所指向的那个对象被销毁后，系统会自动把这条弱指针所指向的那片内存区域的地址置为nil，这样就避免了野指针的出现了；
         "typeof"的意思是获取它后面括号内的对象的类型；
         */
        __weak typeof(person) weakPerson = person;
        person.block = ^{
            NSLog(@"age is %d", weakPerson.age);
        };
        
        person.block();
    }
    
    NSLog(@"$$$$$$$$$$$");
}

#pragma mark ————— 在ARC环境下避免block循环引用的方式2：使用"__unsafe_unretained"关键字 —————
- (void)test1
{
    {
        ZPPerson *person = [[ZPPerson alloc] init];
        person.age = 10;
        
        /**
         在ARC环境下可以使用"__unsafe_unretained"关键字来修饰那个指针，把强指针置为弱指针；
         
         如果用"__unsafe_unretained"关键字来修饰的话，等这条弱指针所指向的那个对象被销毁后，系统还会保留这条弱指针所指向的那片内存区域的地址值，这样就有可能会造成野指针的出现。
         */
        __unsafe_unretained typeof(person) weakPerson = person;
        person.block = ^{
            NSLog(@"age is %d", weakPerson.age);
        };
        
        person.block();
    }
    
    NSLog(@"$$$$$$$$$$$");
}

#pragma mark ————— 在ARC环境下避免block循环引用的方式3：使用"__block"关键字 —————
- (void)test2
{
    {
        /**
         在ARC环境下可以使用"__block"关键字来修饰那个指针，从而避免block的引用循环。但是使用这种方式的话必须得在block代码块内把person对象置为nil，并且要在代码块外调用这个block对象。
         */
        __block ZPPerson *person = [[ZPPerson alloc] init];
        person.age = 10;
        person.block = ^{
            NSLog(@"age is %d", person.age);
            person = nil;
        };
        
        person.block();
    }
    
    NSLog(@"$$$$$$$$$$$");
}

/**
 这个方法的block代码块中有self关键字；
 跟上面的方法相似，下面的代码中首先有一个强指针"person"指着"ZPPerson"类的一个person对象，这个person对象所对应的内存空间称为“内存空间1”。从源码中可以看出，这个person对象中有block属性，即内存空间1中有一个"_block"成员变量，这个"_block"成员变量用强指针指着"test"方法实现中的block对象。这个"test"方法实现中的block对象所对应的内存空间称为”内存空间2“，这个block对象的代码块中用到了self关键字，即内存空间2中有一个self成员变量，这个self成员变量用强指针指着person对象（内存空间1）。当出了下面代码中的大括号的时候，之前指向person对象（内存空间1）的那个"person"强指针就被销毁了，但是，此时person对象（内存空间1）和block对象（内存空间2）都有强指针相互指着，相互引用，所以都不能够释放，这就是造成block循环引用的原因。
 */
- (void)test3
{
    {
        ZPPerson *person = [[ZPPerson alloc] init];
        person.age = 10;
        [person test];
    }
    
    NSLog(@"$$$$$$$$$$$");
}

@end
