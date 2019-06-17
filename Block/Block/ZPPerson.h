//
//  ZPPerson.h
//  Block
//
//  Created by 赵鹏 on 2019/5/24.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZPBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ZPPerson : NSObject

@property (nonatomic, assign) int age;
@property (nonatomic, copy) ZPBlock block;

- (void)test;

@end

NS_ASSUME_NONNULL_END
