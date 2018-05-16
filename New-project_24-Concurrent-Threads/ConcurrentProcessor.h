//
//  ConcurrentProcessor.h
//  New-project_24-Concurrent-Threads
//
//  Created by Geraint on 2018/5/16.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConcurrentProcessor : NSObject

@property (readwrite) BOOL isFinished;  // 在执行下面方法的线程中发送完成计算操作的信号
@property (readonly) NSInteger computeResult;  // 计算操作取得的结果

// 方法computeTask：是由独立线程执行的方法，该方法会执行计算操作，它的参数是执行计算操作的次数。
- (void)computeTask:(id)data;

@end
