//
//  OCThreadManager.m
//  KeepThreadAliveTest
//
//  Created by wdyzmx on 2020/4/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "OCThreadManager.h"

@interface OCThreadManager () <NSCopying, NSMutableCopying>
@property (nonatomic, strong) MyThread *thread;
@property (nonatomic, assign) BOOL isStoped;
@property (nonatomic, copy) TaskBlock block;
@end

@implementation OCThreadManager

#ifdef USE_SINGLETON

static OCThreadManager *manager;
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
        self.isStoped = NO;
        // 创建线程
        __weak typeof(self)weakSelf = self;
        self.thread = [[MyThread alloc] initWithBlock:^{
            NSLog(@"begin - %@", [NSThread currentThread]);
            // runLoop添加port保活线程
            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
            // 开启runLoop
            while (weakSelf && !weakSelf.isStoped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
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
    // isStoped
    self.isStoped = YES;
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
