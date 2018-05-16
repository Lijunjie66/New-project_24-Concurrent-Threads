//
//  main.m
//  New-project_24-Concurrent-Threads
//
//  Created by Geraint on 2018/5/15.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ConcurrentProcessor.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        ConcurrentProcessor *processor = [ConcurrentProcessor new];
        [processor performSelectorInBackground:@selector(computeTask:) withObject:[NSNumber numberWithUnsignedInt:5]];
        [processor performSelectorInBackground:@selector(computeTask:) withObject:[NSNumber numberWithUnsignedInt:10]];
        [processor performSelectorInBackground:@selector(computeTask:) withObject:[NSNumber numberWithUnsignedInt:20]];
        
        while (!processor.isFinished); // 信号(是否已经完成computeTask：方法)
        NSLog(@"Computetion result = %ld", processor.computeResult); // 结果
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
