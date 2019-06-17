//
//  ZPFourViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/22.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 block有3种类型，可以通过调用class方法或者isa指针查看具体的类型，最终都是继承自NSBlock类型：
 1、__NSGlobalBlock__ (_NSConcreteGlobalBlock)；
 2、__NSStackBlock__ (_NSConcreteStackBlock)；
 3、__NSMallocBlock__ (_NSConcreteMallocBlock)。
 
 程序在内存中是分段管理的，应用程序的内存分配如下（由低地址到高地址）：
 1、程序区域（.text区）：主要用来存储代码，所以俗称代码段；
 2、数据区域（.data区）：一般放一些全局变量，_NSConcreteGlobalBlock类型的block也放在这个区域中；
 3、堆：一般放alloc出来的对象，动态分配内存的对象。这里面存储的对象一般需要开发人员进行申请，并且也需要开发人员自己管理内存。_NSConcreteMallocBlock类型的block也放在这个区域中；
 4、栈：一般存储局部变量。它的特点是系统会自动为对象分配内存空间并且自动销毁内存。_NSConcreteStackBlock类型的block也放在这个区域中。
 */
#import "ZPFourViewController.h"

@interface ZPFourViewController ()

@end

@implementation ZPFourViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"FourViewController";
    
    [self test];
    
//    [self test1];
    
//    [self test3];
}

- (void)test
{
    void (^block)(void) = ^{
        NSLog(@"Hello!");
    };
    
    /**
     由下面的代码可知，block对象的父子关系为：block对象:__NSGlobalBlock__:__NSGlobalBlock:NSBlock:NSObject。
     */
    NSLog(@"%@", [block class]);
    NSLog(@"%@", [[block class] superclass]);
    NSLog(@"%@", [[[block class] superclass] superclass]);
    NSLog(@"%@", [[[[block class] superclass] superclass] superclass]);
}

- (void)test1
{
    /**
     没有访问auto局部变量的block是属于__NSGlobalBlock__类型的；
     一般这种类型的block放在内存中的数据区域中。
     */
    void (^block)(void) = ^{
        NSLog(@"Hello!");
    };
    
    /**
     访问了auto局部变量的block是属于__NSStackBlock__类型的，但是在控制台打印出来却是__NSMallocBlock__，这是因为有ARC的原因，在TARGETS中的Build Settings中的All中搜索"automatic re"，然后在搜索结果中把ARC由YES该为NO即可，接着运行程序打印出来的就是__NSStackBlock__了；
     一般这种类型的block放在内存中的栈中。
     */
    int age = 10;
    void (^block1)(void) = ^{
        NSLog(@"Hello - %d", age);
    };
    
    NSLog(@"%@, %@, %@", [block class], [block1 class], [^{
        NSLog(@"%d", age);
    } class]);
}

void (^block)(void);

- (void)test2
{
    /**
     由于这个block对象访问了auto局部变量，所以它是属于__NSStackBlock__类型的，并且它是存放在内存中的栈中的。根据栈的特点，等调用完这个方法（出了这个作用域）的时候，这个block对象就会被系统自动销毁掉，所以之前被该block对象捕获的age局部变量也会被连同销毁掉，所以将来在"test3"方法中调用该block对象的时候打印出来的age是一个乱码；
     要想修复上述的问题，就要把__NSStackBlock__类型的block对象由内存中的栈放到堆里面，让开发者自己控制什么时候来释放该block对象。要想放在堆里面就要让该block对象调用copy方法，然后该block对象就由__NSStackBlock__类型变为了__NSMallocBlock__类型，从而该block对象就存放在了堆里面了。这也是为什么block属性一般用copy关键字来修饰的原因。
     
     总结：
     1、对于__NSGlobalBlock__类型的block对象而言，原来它是存储在内存中的数据区域中的，在调用copy方法后，没有任何变化，它还是存储在内存中的数据区域中；
     2、对于__NSStackBlock__类型的block对象而言，原来它是存储在内存中的栈中的，在调用copy方法后，它会变为__NSMallocBlock__类型，并且系统会把它从栈复制到堆中；
     3、对于__NSMallocBlock__类型的block对象而言，原来它是存储在内存中的堆中的，在调用copy方法后，引用计数会增加1，其他的不会有变化。
     */
    int age = 10;
    block = [^{
        NSLog(@"Hello - %d", age);
    } copy];  //在MRC的情况下需要自己手动调用copy方法，在ARC的情况下系统会自动调用copy方法，所以在ARC的情况下这里并不需要手动调用copy方法。
}

- (void)test3
{
    [self test2];
    
    block();
//    [block release];  //当前是MRC状态，因为之前对block对象做了copy操作，引用计数会加1，在不用block对象的时候应该把这个block对象释放掉，这样才不会引起内存泄露。
}

@end
