//
//  ViewController.m
//  NSURLProtocol拦截测试
//
//  Created by wangzhe on 2019/2/15.
//  Copyright © 2019年 MoGuJie. All rights reserved.
//

#import "ViewController.h"
#import "CustomURLProtocol.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [CustomURLProtocol startMonitor];
    

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width - 40, 50)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"网络请求" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

// 网络请求
- (void)clickBtn {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.protocolClasses = @[[CustomURLProtocol class]];

//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://www.baidu.com" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
  
    
    //    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://xiaozhuanlan.com"]];
    //    NSURLSession *session = [NSURLSession sharedSession];//注意这里使用的是sharedSession
    
    
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    //    self.dataTask = [session dataTaskWithRequest:req];
    //    [self.dataTask  resume];
    
}


@end
