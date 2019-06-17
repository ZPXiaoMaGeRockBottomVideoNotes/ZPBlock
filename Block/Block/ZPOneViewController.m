//
//  ZPOneViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/21.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPOneViewController.h"

@interface ZPOneViewController ()

@end

@implementation ZPOneViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"OneViewController";
    
    /**
     当程序编译的时候系统会对block对象做如下的操作：
     1、系统首先会把block代码块中的代码封装到block执行逻辑的函数中：
     从编译的时候取得的C++文件中可以看到，系统把block代码块中的代码封装到了"static void __main_block_func_0(struct __main_block_impl_0 *__cself, int a, int b)"函数中；
     2、接着系统会为这个block对象生成一个结构体：
     "struct __main_block_impl_0 {
         struct __block_impl impl;
         struct __main_block_desc_0* Desc;
         __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
         impl.isa = &_NSConcreteStackBlock;
         impl.Flags = flags;
         impl.FuncPtr = fp;
         Desc = desc;
         }
     };"
     3、然后系统会调用2中所述的这个结构体中的构造函数"__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0)"来创建一个结构体对象，并把这个结构体的地址赋值给一个block变量：
     "void (*block)(int, int) = ((void (*)(int, int))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));"，所以最终这个block变量就指向了
     "struct __main_block_impl_0 {
     struct __block_impl impl;
     struct __main_block_desc_0* Desc;
     };"结构体了。
     */
    void (^block)(void) = ^{
        NSLog(@"Hello, World!");
    };
    
    block();
}

@end
