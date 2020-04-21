//
//  CThreadManager.m
//  KeepThreadAliveTest
//
//  Created by wdyzmx on 2020/4/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "CThreadManager.h"

@interface CThreadManager () <NSCopying, NSMutableCopying>
@property (nonatomic, strong) MyThread *thread;
@property (nonatomic, copy) TaskBlock block;
@end

@implementation CThreadManager

#ifdef USE_SINGLETON

static CThreadManager *manager;
static dispatch_once_t onceToken;
// 创建单例
+ (instancetype)shareInstace {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return manager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return manager;
}

- (void)__destroyManager {
    manager = nil;
    onceToken = 0;
}

#endif

#pragma mark - 初始化
// 初始化
- (instancetype)init {
    if (self = [super init]) {
        // 创建线程
        self.thread = [[MyThread alloc] initWithBlock:^{
            NSLog(@"begin - %@", [NSThread currentThread]);
            // 创建上下文(初始化结构体为0)
            CFRunLoopSourceContext context = {0};
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0,&context);
            // 添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            // 销毁source
            CFRelease(source);
            //启动（第三个参数returnAfterSourceHandled==true,表示执行source后就退出runLoop,所以设置为false）
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            NSLog(@"end - %@", [NSThread currentThread]);
        }];
    }
    return self;
}

// 开始线程
- (void)run {
    if (!self.thread) {
        return;
    }
    [self.thread start];
}

// 停止线程
- (void)stop {
    
#ifdef USE_SINGLETON
    [self __destroyManager];
#else
    
#endif
    if (!self.thread) {
        return;
    }
    // waitUntilDone:YES 等待__stop方法执行完
    if ([self.thread isExecuting]) {
        [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - 执行任务task
- (void)executeTask:(TaskBlock)block {
    if (!self.thread) {
        return;
    }
    if (![self.thread isExecuting]) {
        [self.thread start];
    }
    [self performSelector:@selector(__executeTask:) onThread:self.thread withObject:block waitUntilDone:NO];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s", __func__);
    [self stop];
}

#pragma mark - private method
- (void)__stop {
    // stop runLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    // 置nil
    self.thread = nil;
}

- (void)__executeTask:(TaskBlock)block {
    NSLog(@"执行task - %s - %@", __func__, [NSThread currentThread]);
    self.block = block;
    self.block();
}

@end
