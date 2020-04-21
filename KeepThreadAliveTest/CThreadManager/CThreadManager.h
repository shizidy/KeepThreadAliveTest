//
//  CThreadManager.h
//  KeepThreadAliveTest
//
//  Created by wdyzmx on 2020/4/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyThread.h"
#define USE_SINGLETON @"use singleton"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TaskBlock)(void);

@interface CThreadManager : NSObject

#ifdef USE_SINGLETON
/// 单例
+ (instancetype)shareInstace;
#endif

/// 运行thread
//- (void)run;
/// 停止runloop,停止thread
- (void)stop;
/// 执行task
/// @param block 回调block
- (void)executeTask:(TaskBlock)block;

@end

NS_ASSUME_NONNULL_END
