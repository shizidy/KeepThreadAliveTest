//
//  ViewController.m
//  KeepThreadAliveTest
//
//  Created by wdyzmx on 2020/4/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "ViewController.h"
#import "ThreadTaskViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"去ThreadTask页" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)buttonClick:(UIButton *)btn {
    ThreadTaskViewController *viewController = [[ThreadTaskViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
