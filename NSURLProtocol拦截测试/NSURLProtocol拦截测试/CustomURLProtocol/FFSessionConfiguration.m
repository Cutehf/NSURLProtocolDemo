//
//  FFSessionConfiguration.m
//  NSURLProtocol拦截测试
//
//  Created by wangzhe on 2019/2/15.
//  Copyright © 2019年 MoGuJie. All rights reserved.
//

#import "FFSessionConfiguration.h"
#import <objc/runtime.h>
#import "CustomURLProtocol.h"

@implementation FFSessionConfiguration

+ (FFSessionConfiguration *)defaultConfiguration {
    static FFSessionConfiguration *staticConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticConfiguration=[[FFSessionConfiguration alloc] init];
    });
    return staticConfiguration;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isExchanged = NO;
    }
    return self;
}

- (void)load {
    self.isExchanged=YES;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
    
}

- (void)unload {
    self.isExchanged=NO;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    // 如果还有其他的监控protocol，也可以在这里加进去
    return @[[CustomURLProtocol class]];
}

@end
