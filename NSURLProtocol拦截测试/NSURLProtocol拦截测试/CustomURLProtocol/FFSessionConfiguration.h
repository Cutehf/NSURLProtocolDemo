//
//  FFSessionConfiguration.h
//  NSURLProtocol拦截测试
//
//  Created by wangzhe on 2019/2/15.
//  Copyright © 2019年 MoGuJie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFSessionConfiguration : NSObject
//是否交换方法
@property (nonatomic,assign) BOOL isExchanged;

+ (FFSessionConfiguration *)defaultConfiguration;
// 交换掉NSURLSessionConfiguration的 protocolClasses方法
- (void)load;
// 还原初始化
- (void)unload;

@end

NS_ASSUME_NONNULL_END
