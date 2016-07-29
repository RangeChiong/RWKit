//
//  RWRequest.m
//  Test0625
//
//  Created by 常小哲 on 16/6/25.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "RWRequest.h"

@implementation NSData (utils)

- (NSDictionary *)parseJson {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self
                                                         options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                           error:&error];
    return dict;
}

@end

static NSString *const TimeOutKeyPath = @"timeoutInterval";

@interface RWRequest () {
    AFHTTPSessionManager *_requestManager;
}

@end

@implementation RWRequest

+ (instancetype)shareRequest {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _requestManager = [AFHTTPSessionManager manager];
        _requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self setTimeoutInterval:20.0];
    }
    return self;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [_requestManager.requestSerializer willChangeValueForKey:TimeOutKeyPath];
    _requestManager.requestSerializer.timeoutInterval = timeoutInterval;
    [_requestManager.requestSerializer didChangeValueForKey:TimeOutKeyPath];

}

#pragma mark-   request

- (void)request:(NSString *)url
           type:(RequestNormalType)type
         params:(NSDictionary *)params
        success:(void (^)(NSDictionary *dict))success
        failure:(void (^)(NSError *error))failure {
    
    // 请求成功的回调
    void (^successfulRequest) (NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            NSDictionary *dict = [responseObject parseJson];
            success(dict);
        }
    };
    
    // 请求失败的回调
    void (^failedRequest) (NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) failure(error);
    };
    
    switch (type) {
        case RequestNormalType_Get: {
            [_requestManager GET:url
                      parameters:params
                        progress:nil
                         success:successfulRequest
                         failure:failedRequest];
        }
            break;
            
        case RequestNormalType_Post: {
            [_requestManager POST:url
                       parameters:params
                         progress:nil
                          success:successfulRequest
                          failure:failedRequest];
        }
            break;
            
        case RequestNormalType_Put: {
            [_requestManager PUT:url
                      parameters:params
                         success:successfulRequest
                         failure:failedRequest];
        }
            break;
            
        case RequestNormalType_Delete: {
            [_requestManager DELETE:url
                         parameters:params
                            success:successfulRequest
                            failure:failedRequest];
        }
            break;
            
        default:
            break;
    }
}

- (void)post:(NSString *)url
      params:(NSDictionary *)params
        body:(void (^)(id<AFMultipartFormData> formData))body
     success:(void (^)(NSDictionary* dic))success
     failure:(void (^)(NSError *error))failure {
    
    [_requestManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (body) body(formData);
    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (success) {
                  NSDictionary *dict = [responseObject parseJson];
                  success(dict);
              }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (failure) failure(error);
    }];
}

- (void)cancelAllRequest {
    [_requestManager.operationQueue cancelAllOperations];
}

#pragma mark-  download

- (void)downloadFile:(NSString *)url progress:(void (^)(CGFloat progress))progress {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress)
            progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}


#pragma mark-  network status

+ (void)observeNetworkStatus:(void (^)(AFNetworkReachabilityStatus status))block {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (block)
                block(status);
    }];
}

+ (void)removeNetworkStatusObserver {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark-  cache

+ (void)openRequsetCache {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

+ (void)removeAllCachedResponses {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end








