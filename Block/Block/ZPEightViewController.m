//
//  ZPEightViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/28.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPEightViewController.h"
#import "ZPPerson.h"

typedef void(^ZPBlock)(void);

@interface ZPEightViewController ()

@end

@implementation ZPEightViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"EightViewController";
    
    [self test];
    
//    [self test1];
}

/**
 用"__block"修饰符修饰一个在代码块外的对象类型的对象，然后在代码块内使用这个对象；
 在终端中输入相应的命令行，把本文件在编译的时候生成一个C++文件，从C++文件中可以看出这个block的源码如下：
 struct __Block_byref_person_0 {
     void *__isa;
     __Block_byref_person_0 *__forwarding;
     int __flags;
     int __size;
     void (*__Block_byref_id_object_copy)(void*, void*);
     void (*__Block_byref_id_object_dispose)(void*);
     ZPPerson *__strong person;
 };
 
 struct __main_block_impl_0 {
     struct __block_impl impl;
     struct __main_block_desc_0* Desc;
     __Block_byref_person_0 *person; // by ref
     __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_person_0 *_person, int flags=0) : person(_person->__forwarding) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
   }
 };
 static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
 __Block_byref_person_0 *person = __cself->person; // bound by ref
 
         NSLog((NSString *)&__NSConstantStringImpl__var_folders_2r__m13fp2x2n9dvlr8d68yry500000gn_T_main_5f3c02_mi_0, (person->__forwarding->person));
     }
 static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
     _Block_object_assign((void*)&dst->person, (void*)src->person, 8);

}
 
 static void __main_block_dispose_0(struct __main_block_impl_0*src) {
 _Block_object_dispose((void*)src->person, 8);}
 
 static struct __main_block_desc_0 {
     size_t reserved;
     size_t Block_size;
     void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
     void (*dispose)(struct __main_block_impl_0*);
 } __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
 int main(int argc, const char * argv[]) {
            { __AtAutoreleasePool __autoreleasepool;
     
         ZPPerson *person = ((ZPPerson *(*)(id, SEL))(void *)objc_msgSend)((id)((ZPPerson *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("MJPerson"), sel_registerName("alloc")), sel_registerName("init"));
 
         __attribute__((__blocks__(byref))) __attribute__((objc_ownership(weak))) __Block_byref_person_0 person = {(void*)0,(__Block_byref_person_0 *)&person, 33554432, sizeof(__Block_byref_weakPerson_0),
             __Block_byref_id_object_copy_131,
             __Block_byref_id_object_dispose_131,
             person};
 
         ZPBlock block = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_person_0 *)&person, 570425344));
 
         ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
    }
    return 0;
}
 系统在编译的时候，会把block对象封装成源码中的"struct __main_block_impl_0"结构体，同时也会把person对象封装成源码中的"struct __Block_byref_person_0"结构体；
 由源码可以知道block对象(struct __main_block_impl_0)内部有一个person强指针(__Block_byref_person_0 *person)（这个指针无论怎样都是强指针），这个强指针指向"struct __Block_byref_person_0"结构体，这个结构体内部有一个"ZPPerson *__strong person"指针，这个指针的强弱取决于下面代码中是如何写的，这个指针指向"test"方法中的alloc出来的person对象；
 在ARC环境下，person对象前面只有一个"__block"修饰符进行修饰，这种情况下系统默认是用"strong"关键字进行修饰的，所以系统在编译的时候这个block对象有一个强指针指着这个person对象，block持有person，即person对象和block对象是同生共死的关系，即便出了这个person对象的作用域，它也不会被销毁掉，而是等block对象被销毁了，它才会被销毁掉；
 在MRC环境下，同样的，person对象前面只有一个"__block"修饰符进行修饰，这种情况下系统也默认是用"strong"关键字进行修饰的，但与上面不同的是，在编译的时候这个block对象不是用强指针指着这个person对象，而是用一个弱指针指着这个person对象，block不持有person，即person对象和block对象不是同生共死的关系，出了这个person对象的作用域，它就会被销毁掉。
 */
- (void)test
{
    ZPBlock block;
    
    {
        __block ZPPerson *person = [[ZPPerson alloc] init];
        
        block = ^{
            NSLog(@"person = %p", person);
        };
    }
    
    block();
}

/**
 因为下面代码中的person对象是用"__weak"修饰符进行修饰的，所以系统在编译的时候这个block对象有一个弱指针指着它，即这个person对象和这个block对象不是同生共死的关系，出了这个person对象的作用域，它就会被销毁掉。
 */
- (void)test1
{
    ZPBlock block;
    
    {
        ZPPerson *person = [[ZPPerson alloc] init];
        
        __block __weak ZPPerson *weakPerson = person;
        
        block = ^{
            NSLog(@"weakPerson = %p", weakPerson);
        };
    }
    
    block();
}

@end
