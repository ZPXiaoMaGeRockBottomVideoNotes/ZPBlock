//
//  ZPSixViewController.m
//  Block
//
//  Created by 赵鹏 on 2019/5/24.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPSixViewController.h"
#import "ZPPerson.h"

typedef void(^ZPBlock)(void);

@interface ZPSixViewController ()

@end

@implementation ZPSixViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"SixViewController";
    
    [self test];
    
//    [self test1];
    
//    [self test2];
    
//    [self test3];
}

/**
 下面代码中的block对象外面的person对象是一个auto类型的局部变量，这种局部变量的本质就是出了它的作用域就会被系统自动销毁掉。同时，这个block对象属于"ZPFiveViewController"类中所介绍的第二种情况，在ARC的环境下，编译的时候，系统会自动给它做copy操作，把这个block对象由栈复制到堆上，并且把它的类型由__NSStackBlock__变为__NSMallocBlock__；
 在终端中输入相应的命令行，把本文件在编译的时候生成一个C++文件，从C++文件中可以看出这个block的源码如下：
 "struct __main_block_impl_0 {
     struct __block_impl impl;
     struct __main_block_desc_0* Desc;
     ZPPerson *__strong person;
     __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, ZPPerson *__strong _person, int flags=0) : person(_person) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
   }
 };
 static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
     ZPPerson *__strong person = __cself->person; // bound by copy
 
                     NSLog((NSString *)&__NSConstantStringImpl__var_folders_2r__m13fp2x2n9dvlr8d68yry500000gn_T_main_c41e64_mi_0, ((int (*)(id, SEL))(void *)objc_msgSend)((id)person, sel_registerName("age")));
               }
 static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->person, (void*)src->person, 3);}
 
 static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->person, 3);}
 
 static struct __main_block_desc_0 {
     size_t reserved;
     size_t Block_size;
     void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
     void (*dispose)(struct __main_block_impl_0*);
 } __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
 int main(int argc, const char * argv[]) {
                            { __AtAutoreleasePool __autoreleasepool;
     MJBlock block;
     
     {
         ZPPerson *person = ((ZPPerson *(*)(id, SEL))(void *)objc_msgSend)((id)((ZPPerson *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("ZPPerson"), sel_registerName("alloc")), sel_registerName("init"));
         ((void (*)(id, SEL, int))(void *)objc_msgSend)((id)person, sel_registerName("setAge:"), 10);
         
         
         int age = 10;
         block = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, person, 570425344));
     }
     
     NSLog((NSString *)&__NSConstantStringImpl__var_folders_2r__m13fp2x2n9dvlr8d68yry500000gn_T_main_c41e64_mi_1);
    }
    return 0;
}"
上述源码中的"struct __main_block_impl_0"结构体内的person元素前面是用"__strong"还是用"__weak"来修饰取决于下面代码中的block对象外外面的person对象用是用"__strong"还是用"__weak"来修饰；
当编译的时候，系统给这个block对象进行copy操作的时候，系统就会调用上述源码中的"void __main_block_copy_0"函数，这个函数的实现的意思是系统会根据这个block对象的"struct __main_block_desc_0"结构体中的person元素前面的指针类型（强指针或弱指针）来对下面代码中的block对象外面的那个person对象进行强引用或弱引用；
 当把block对象从内存中的堆上移除的时候，系统就会调用上述源码中的"void __main_block_dispose_0"函数，这个函数的实现的意思是对person这个auto局部变量进行释放，即做一次release操作。
 
 总结：
 当block代码块内访问了代码块外的对象类型的auto局部变量时：
 1、这种情况下的源码中的"struct __main_block_desc_0"结构体比代码块内不访问代码块外的东西多了两个元素，分别为："void (*copy)"和"void (*dispose)"；
 2、如果block对象是在栈上，将不会对auto局部变量产生强引用，这个局部变量出了它的作用域就会被销毁，如test1所示。
 3、如果block对象被拷贝到堆上，系统会调用源码中的"void __main_block_copy_0"函数，这个函数会根据auto局部变量的修饰符（__strong、__weak、__unsafe_unretained）做出相应的操作，形成强引用或弱引用；
 4、如果block对象从堆上移除，系统先会调用源码中的"void __main_block_dispose_0"函数，在这个函数中释放之前引用的auto局部变量。
 
 从上述的源码中可以看出系统首先会把"test"方法中的person对象捕获到block对象的结构体中，这样的话block内部就有一个强指针指着block外面的那个person对象的auto类型的局部变量了，现在这个局部变量和block对象是同生同死的关系了。根据其他类所述的内容，此block对象属于"ZPFiveViewController"类中所介绍的第二种情况，这个block在ARC的环境下属于__NSMallocBlock__类型，并且存储在内存中的堆上，所以这个block由开发者自己掌握什么时候销毁，只要这个block存在，它里面用强指针指着的那个person对象就存在，所以即便出了这个person对象的作用域，它也不会被销毁。
 */
- (void)test
{
    ZPBlock block;
    
    {
        ZPPerson *person = [[ZPPerson alloc] init];
        person.age = 10;
        
        block = ^{
            NSLog(@"age = %d", person.age);
        };
    }
    
    block();
    
    NSLog(@"---------");
}

/**
 因为weakPerson这个auto局部变量是用弱指针指着的，所以block捕获到这个局部变量之后也是用弱指针指着它，所以这个局部变量和block对象不是同生同死的关系，当出了这个局部变量的作用域之后，这个局部变量就会被系统销毁掉。
 */
- (void)test1
{
    ZPBlock block;
    
    {
        ZPPerson *person = [[ZPPerson alloc] init];
        person.age = 10;
        
        __weak ZPPerson *weakPerson = person;
        block = ^{
            NSLog(@"age = %d", weakPerson.age);
        };
    }
    
    block();
    
    NSLog(@"----------");
}

/**
 这个方法中的block对象属于"ZPFiveViewController"类中所介绍的第四种情况。在编译的时候，系统会对这个block对象进行copy操作，然后把这个block对象复制到内存中的堆上去，同时在编译的时候会把block代码块外的person对象进行强引用，所以这个block对象和person对象是同生同死的关系了。在不调用"dispatch_after"方法的时候，这个person对象出了这个方法就会被销毁掉，在调用"dispatch_after"方法以后，因为block对象用强指针持有了这个person对象，所以在运行此方法三秒后这个block对象被调用，在调用完以后，这个block对象就会被销毁，然后这个persond对象同时也会被销毁。
 */
- (void)test2
{
    NSLog(@"$$$$$$$$");
    
    ZPPerson *person = [[ZPPerson alloc] init];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"person = %@", person);
    });
    
    NSLog(@"########");
}

/**
 因为在weakPerson对象前面已经用"__weak"关键字做了标识，所以在编译的时候，这个block对象会用一个弱指针指着代码块外面的weakPerson对象，这个block对象和weakPerson对象不是同生同死的关系，所以当运行这个方法的时候这个weakPerson对象会被立刻销毁掉，等三秒之后运行"dispatch_after"方法的时候，此时weakPerson对象已经被销毁了，所以打印的结果是null。
 */
- (void)test3
{
    NSLog(@"$$$$$$$$");
    
    ZPPerson *person = [[ZPPerson alloc] init];
    
    __weak ZPPerson *weakPerson = person;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"weakPerson = %@", weakPerson);
    });
    
    NSLog(@"########");
}

@end
