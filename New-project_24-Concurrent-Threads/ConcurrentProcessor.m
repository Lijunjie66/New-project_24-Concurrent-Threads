//
//  ConcurrentProcessor.m
//  New-project_24-Concurrent-Threads
//
//  Created by Geraint on 2018/5/16.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import "ConcurrentProcessor.h"

@interface ConcurrentProcessor()

@property (readwrite) NSInteger computeResult; // 开头这个扩展类为这个属性启用了写入操作

@end


@implementation ConcurrentProcessor

{
    //私有实例变量:
    NSString *computeID;      // @synchronize 指令锁定的唯一对象
    NSUInteger computeTasks;  // 并行计算任务的计数
    NSLock *computeLock;      // 锁对象
}

- (id)init {
    if (self = [super init]) {
        _isFinished = NO;
        _computeResult = 0;
        computeLock = [NSLock new];
        computeID = @"1";
        computeTasks = 0;
    }
    return self;
}

// 该方法 被封装在自动释放池和@try-@catch异常语句中，这是为了确保执行该方法的线程不会泄漏对象，并且处理任何抛出的异常。
// *** 因为这个方法可以由多个线程并发执行并且能够访问和更新共享数据，所以，必须【同步】对这一数据的访问。
- (void)computeTask:(id)data {
    NSAssert(([data isKindOfClass:[NSNumber class]]), @"Not an NSNumber instance");
    NSUInteger computations = [data unsignedIntegerValue];
    @autoreleasepool {
        
        @try {
            // 获取锁并增加活动任务的计数
            // 定期检查线程的状态，如果线程取消了，则退出
            if ([[NSThread currentThread] isCancelled]) {
                return;
            }
            
            // **** 使用@synchronized指令可以控制对computeTasks变量的访问，从而允许每次一个线程更新其内容。
            @synchronized(computeID) {
                computeTasks++;
            }
            
            // 获取锁并执行关键代码部分中的计算操作
            [computeLock lock]; // 锁
            
            // 定期检查线程的状态，如果释放该锁了，则退出线程
            if ([[NSThread currentThread] isCancelled]) {
                [computeLock unlock]; // 解锁
                return;
            }
            NSLog(@"Performing computations");
            for (int ii=0; ii<computations; ii++) {
                self.computeResult = self.computeResult + 1;
            }
            [computeLock unlock];
            
            // 模拟额外的处理时间（在关键部分之外）
            [NSThread sleepForTimeInterval:1.0];
            
            // 减少活动任务数，如果数量为0，则更新标志位
            @synchronized(computeID) {
                computeTasks--;
                if (!computeTasks) {
                    self.isFinished = YES; // 这个属性实在.m文件开头的扩展类里定义的
                }
            }
        }
        @catch (NSException *ex) {}
    }
}

@end
