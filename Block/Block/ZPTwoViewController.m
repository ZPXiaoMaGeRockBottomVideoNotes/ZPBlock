//
//  ZPTwoViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/21.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPTwoViewController.h"

@interface ZPTwoViewController ()

@end

@implementation ZPTwoViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"TwoViewController";
    
    /**
     在终端中输入相应的命令行，把本文件在编译的时候生成一个C++文件，从C++文件中可以看出这个block函数的底层源码：
     struct __main_block_impl_0 {
     struct __block_impl impl;
     struct __main_block_desc_0* Desc;
     int age;
     __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _age, int flags=0) : age(_age) {
             impl.isa = &_NSConcreteStackBlock;
             impl.Flags = flags;
             impl.FuncPtr = fp;
             Desc = desc;
         }
     };
     static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
         int age = __cself->age
                   NSLog((NSString *)&__NSConstantStringImpl__var_folders_2r__m13fp2x2n9dvlr8d68yry500000gn_T_main_87bc8b_mi_0, age);
               }
     
     static struct __main_block_desc_0 {
         size_t reserved;
         size_t Block_size;
     } __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
     int main(int argc, const char * argv[]) {
                                { __AtAutoreleasePool __autoreleasepool;
             int age = 10;
     
             void (*block)(void) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA, age);
         
             age = 20;
         
             block->FuncPtr(block);
     
         }
         return 0;
}
     
     根据上面block函数的源码可以知道，程序在编译的时候会把"age = 10"的这个变量值传到上面源码中的"void (*block)(void) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA, age);"函数中，又因为"__main_block_impl_0"函数就是上面源码中的"struct __main_block_impl_0"结构体里面的一个元素，结构体内的这个元素的末尾的": age(_age)"语句，根据C++语法， 它的意思是会把从外面传进来的age参数的值直接赋给这个结构体内的另外一个参数"int age"，所以这个block对象的内部的age变量的值就是10了。而后面"age = 20;"语句代表的仅仅是把代码块外面的age变量的值由10变为了20，但是不能更改block对象里面的age的值，此时block对象里面的age的值还是10。然后系统就会执行上面源码中的"block->FuncPtr(block);"函数，即执行"static void __main_block_func_0(struct __main_block_impl_0 *__cself)"函数，根据这个函数中的"int age = __cself->age"语句可以知道，系统接着会取出这个block对象中的age元素，即就是从"struct __main_block_impl_0"结构体中取出里面的"int age"元素，然后把它放到"static void __main_block_func_0(struct __main_block_impl_0 *__cself)"函数中的NSLog中进行打印，所以打印的结果是10。
     
     总结：当初在创建block对象的时候"age = 10"已经存储在block对象里面了，相当于block对象已经把age的值捕获到block对象里面了（block的变量捕获），而后面的"age = 20"只是更改block代码块外的age变量的值，不能更改它里面的age的值，所以打印出来的结果是10。
     */
    int age = 10;
    
    void (^block)(void) = ^{
        NSLog(@"age is %d", age);
    };
    
    age = 20;
    
    block();
}

@end
