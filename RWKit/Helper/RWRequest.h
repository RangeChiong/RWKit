//
//  RWRequest.h
//  Test0625
//
//  Created by 常小哲 on 16/6/25.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RequestNormalType) {
    RequestNormalType_Get = 0,
    RequestNormalType_Post,
    RequestNormalType_Put,
    RequestNormalType_Delete
};

@interface RWRequest : NSObject

+ (instancetype)shareRequest;

/*!
 *  设置请求超时时间  默认20s
 */
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*!
 *  根据type请求
 */
- (void)request:(NSString *)url
           type:(RequestNormalType)type
         params:(NSDictionary *)params
        success:(void (^)(NSDictionary *dict))success
        failure:(nullable void (^)(NSError *error))failure;

/*!
 *  上传文件
 */
- (void)post:(NSString *)url
      params:(NSDictionary *)params
        body:(void (^)(id<AFMultipartFormData> formData))body
     success:(void (^)(NSDictionary* dic))success
     failure:(nullable void (^)(NSError *error))failure;

/*!
 *  取消网络请求
 */
- (void)cancelAllRequest;

/*!
 *  监听网络状态
 */
+ (void)observeNetworkStatus:(void (^)(AFNetworkReachabilityStatus status))block;

/*!
 *  移除网络状态监听
 */
+ (void)removeNetworkStatusObserver;

/*!
 *  开启请求的URLcache
 */
+ (void)openRequsetCache;

/*!
 *  移除所有的URLcache
 */
+ (void)removeAllCachedResponses;

@end

NS_ASSUME_NONNULL_END


