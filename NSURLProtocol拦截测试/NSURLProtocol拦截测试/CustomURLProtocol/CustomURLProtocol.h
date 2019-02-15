//
//  CustomURLProtocol.h
//  NSURLProtocol拦截测试
//
//  Created by wangzhe on 2019/2/15.
//  Copyright © 2019年 MoGuJie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomURLProtocol : NSURLProtocol

//开始监听
+(void)startMonitor;

//停止监听
+ (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
