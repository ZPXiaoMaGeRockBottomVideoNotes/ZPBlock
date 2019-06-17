//
//  ViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/20.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 block的概念：
 block从本质上讲就是一个OC对象，它内部也有一个isa指针；
 block是一个封装了函数调用以及函数调用环境的OC对象。
 */
#import "ViewController.h"

//下面是项目在编译的时候，生成的C++文件中block部分的源码。

struct __block_impl {
    void *isa;  //block对象里面包含一个isa指针，因为OC对象内部一般也有一个isa指针，所以印证了block实际上就是一个OC对象的结论。
    int Flags;
    int Reserved;
    void *FuncPtr;  //程序在编译block对象的时候，首先会把block代码块中的代码封装在一个函数中等待调用执行，并且这个函数的开始地址会被存储在这个 block对象中的FuncPtrt中，等将来要执行代码块中的代码的时候，系统就会根据这个地址值找到那个函数，然后再进行调用。
};

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;  //block对象占用内存空间的值。
};

/**
 在终端中输入相应的命令行，本文件在编译的时候就会生成一个C++文件，从这个C++文件中就可以看出，block对象在底层上就是一个结构体，这个结构体中又包含两个结构体和一个在block代码块外的常量。
 */
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int age;
};

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"ViewController";
    
    int age = 20;
    
    void (^block)(int, int) = ^(int a, int b){
        NSLog(@"this is a block! -- %d", age);
        NSLog(@"this is a block!");
        NSLog(@"this is a block!");
        NSLog(@"this is a block!");
    };
    
    block(10, 10);
}

@end
