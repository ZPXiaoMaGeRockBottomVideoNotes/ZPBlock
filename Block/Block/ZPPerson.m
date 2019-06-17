//
//  ZPPerson.m
//  Block
//
//  Created by 赵鹏 on 2019/5/24.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPerson.h"

@implementation ZPPerson

- (void)dealloc
{
    NSLog(@"ZPPerson对象被销毁了！");
}

- (void)test
{
    //为了避免出现block的循环引用问题。
    __weak typeof(self) weakSelf = self;
    
    self.block = ^{
        NSLog(@"age is %d", weakSelf.age);
    };
}

@end
