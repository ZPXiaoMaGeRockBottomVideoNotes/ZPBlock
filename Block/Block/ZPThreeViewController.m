//
//  ZPThreeViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/21.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 block对象的内部会新增一个成员来专门存储block代码块外面的那个变量的值，这种情况叫做"捕获"。
 
 变量的类型：
 1、局部变量：
 （1）auto：自动变量，出了这个局部变量的作用域就会被销毁；
 这个"auto"可以省略，所以一般写局部变量的时候都不写；
 "auto"不能用来修饰全局变量；
 可以捕获到block的内部，通过值传递的方式把局部变量的值传递给block。
 （2）static：静态变量，内存一直存在，不会因为出了这个局部变量的作用域就会被销毁；
 "static"不能够被省略；
 "static"可以用来修饰全局变量；
 可以捕获到block的内部，把存储这个局部变量的内存地址值传递到block的内部。
 2、全局变量：
 不需要捕获到block的内部，随时都可以访问最新的全局变量的值。
 */
#import "ZPThreeViewController.h"

@interface ZPThreeViewController ()

@end

@implementation ZPThreeViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"ThreeViewController";
    
    //局部变量
    [self localVariate];
    
    //全局变量
//    [self globalVariate];
}

#pragma mark ————— 局部变量 —————
- (void)localVariate
{
    /**
     在终端中输入相应的命令行，本文件在编译的时候会生成一个C++文件，从C++文件中可以看出这个block函数的底层源码如下：
     struct __test_block_impl_0 {
         struct __block_impl impl;
         struct __test_block_desc_0* Desc;
         int age;
         int *height;
         __test_block_impl_0(void *fp, struct __test_block_desc_0 *desc, int _age, int *_height, int flags=0) : age(_age), height(_height) {
           impl.isa = &_NSConcreteStackBlock;
           impl.Flags = flags;
           impl.FuncPtr = fp;
           Desc = desc;
         }
     };
     static void __test_block_func_0(struct __test_block_impl_0 *__cself) {
         int age = __cself->age; // bound by copy
         int *height = __cself->height; // bound by copy
     
     
         NSLog((NSString *)&__NSConstantStringImpl__var_folders_2r__m13fp2x2n9dvlr8d68yry500000gn_T_main_d2875b_mi_0, age, (*height));
     }
     
     static struct __test_block_desc_0 {
         size_t reserved;
         size_t Block_size;
     } __test_block_desc_0_DATA = { 0, sizeof(struct __test_block_impl_0)};
     void test()
     {
         int age = 10;
         static int height = 10;
     
         block = ((void (*)())&__test_block_impl_0((void *)__test_block_func_0, &__test_block_desc_0_DATA, age, &height));
     
         age = 20;
         height = 20;
     
         ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
     }
     
     根据上述的"block = ((void (*)())&__test_block_impl_0((void *)__test_block_func_0, &__test_block_desc_0_DATA, age, &height));"函数中的"&height"可以知道，往这个函数中传递的是存储block代码块外面的static局部变量height的值的那片内存空间的地址，然后系统会把这个地址值传递到"struct __test_block_impl_0"结构体里面的构造函数"__test_block_impl_0(void *fp, struct __test_block_desc_0 *desc, int _age, int *_height, int flags=0) : age(_age), height(_height)"中，根据C++的语法，这个构造函数会直接把这个地址值赋值给这个结构体中的"int *height;"元素，即系统会把block代码块外面的存储static局部变量的内存地址值赋值给block对象里面的"int *height"元素，接着系统再调用"((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);"函数的时候就会来到"static void __test_block_func_0(struct __test_block_impl_0 *__cself)"函数中，在这个函数的实现中可以看到打印的是"*height"，即打印的是这块内存地址里面所存储的值，就是一开始在block代码块外面声明的那个static局部变量height的值，一开始给它的赋值是10，但是后来又给它赋值了20，所以最终的打印结果是20。
     */
    auto int age = 10;
    static int height = 10;
    
    void (^block)(void) = ^{
        NSLog(@"age is %d, height is %d", age, height);
    };
    
    age = 20;
    height = 20;
    
    block();
}

#pragma mark ————— 全局变量 —————
int weight = 110;
static int waistline = 60;

- (void)globalVariate
{
    /**
     在终端中输入相应的命令行，本文件在编译的时候生成一个C++文件，从C++文件中可以看出这个block函数的底层源码如下：
     int weight = 110;
     static int waistline = 60;
     
     struct __main_block_impl_0 {
     struct __block_impl impl;
         struct __main_block_desc_0* Desc;
         __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
             impl.isa = &_NSConcreteStackBlock;
             impl.Flags = flags;
             impl.FuncPtr = fp;
             Desc = desc;
       }
     };
     
     static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
     
                 NSLog((NSString *)&__NSConstantStringImpl__var_folders_2r__m13fp2x2n9dvlr8d68yry500000gn_T_main_c60393_mi_0, weight, waistline);
            }
     
     static struct __main_block_desc_0 {
         size_t reserved;
         size_t Block_size;
     } __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
     int main(int argc, const char * argv[]) {
                                { __AtAutoreleasePool __autoreleasepool;
     
         void (*block)(void) = &__main_block_impl_0(
                                                    __main_block_func_0,
                                                    &__main_block_desc_0_DATA
                                                    );
     
         weight = 120;
         waistline = 70;
     
         ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
      }
      return 0;
   }
     
     由源码可以看出，在"struct __main_block_impl_0"结构体内没有相应的"int weight = 110;"和"static int waistline = 60;"元素，说明系统在编译block对象的时候，不会把全局变量捕获到block对象内。在调用"static void __main_block_func_0(struct __main_block_impl_0 *__cself)"函数的时候直接访问block代码块外面的全局变量就可以了。一开始的时候系统给这些全局变量赋了值了，后来又赋了另外的值了，所以在调用"static void __main_block_func_0(struct __main_block_impl_0 *__cself)"函数打印的时候会获取最新的全局变量的值，即最后赋值的那些值。
     */
    void (^block)(void) = ^{
        NSLog(@"weight is %d, waistline is %d", weight, waistline);
    };
    
    weight = 120;
    waistline = 70;
    
    block();
}

@end
