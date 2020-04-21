//
//  ThreadTaskViewController.m
//  KeepThreadAliveTest
//
//  Created by wdyzmx on 2020/4/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "ThreadTaskViewController.h"
#import "MyThreadManager.h"

@interface ThreadTaskViewController ()
@property (nonatomic, strong) MyThreadManager *threadManager;
@end

@implementation ThreadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"test in runLoop" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 150, 50)];
    [self.view addSubview:btn2];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"stop runLoop" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    
#ifndef USE_SINGLETON
    self.threadManager = [[MyThreadManager alloc] init];
#else
    
#endif
    // Do any additional setup after loading the view.
}

- (void)buttonClick:(UIButton *)btn {
#ifdef USE_SINGLETON
    [[MyThreadManager shareInstace] executeTask:^{
        // 处理回调
    }];
#else
    [self.threadManager executeTask:^{
        // 处理回调
    }];
#endif
}

- (void)buttonClick2:(UIButton *)btn {
    // 手动停止runloop,thread
#ifdef USE_SINGLETON
    [[MyThreadManager shareInstace] stop];
#else
    [self.threadManager stop];
#endif
}

- (void)dealloc {
    NSLog(@"%s", __func__);
#ifdef USE_SINGLETON
    [[MyThreadManager shareInstace] stop];
#else
    
#endif
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
