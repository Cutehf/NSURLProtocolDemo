//
//  CustomURLProtocol.m
//  NSURLProtocol拦截测试
//
//  Created by wangzhe on 2019/2/15.
//  Copyright © 2019年 MoGuJie. All rights reserved.
//

#import "CustomURLProtocol.h"
#import "FFSessionConfiguration.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";
@interface CustomURLProtocol ()<NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation CustomURLProtocol

// 开始监听
+ (void)startMonitor {
    FFSessionConfiguration *sessionConfiguration = [FFSessionConfiguration defaultConfiguration];
    [NSURLProtocol registerClass:[CustomURLProtocol class]];
    if (![sessionConfiguration isExchanged]) {
        [sessionConfiguration load];
    }
}

// 停止监听
+ (void)stopMonitor {
    FFSessionConfiguration *sessionConfiguration = [FFSessionConfiguration defaultConfiguration];
    [NSURLProtocol unregisterClass:[CustomURLProtocol class]];
    if ([sessionConfiguration isExchanged]) {
        [sessionConfiguration unload];
    }
}


+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    NSString * scheme = [[request.URL scheme] lowercaseString];
    
    //看看是否已经处理过了，防止无限循环 根据业务来截取
    if ([NSURLProtocol propertyForKey: URLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    if ([scheme isEqual:@"http"]) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

//开始请求
- (void)startLoading
{
    
    NSLog(@"***监听接口：%@", self.request.URL.absoluteString);
    
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //标示该request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    //这个enableDebug随便根据自己的需求了，可以直接拦截到数据返回本地的模拟数据，进行测试
    BOOL enableDebug = NO;
    if (enableDebug) {
        
        NSString *str = @"测试数据";
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
                                                            MIMEType:@"text/plain"
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
        [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
    else {
        //使用NSURLSession继续把request发送出去
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:mainQueue];
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableReqeust];
        [task resume];
    }
}

//结束请求
- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 打印返回数据
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (dataStr) {
        NSLog(@"***截取数据***: %@", dataStr);
    }
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}


@end
