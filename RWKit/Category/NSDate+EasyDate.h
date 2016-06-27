//
//  NSDate+EasyDate.h
//  RPAntus
//
//  Created by Crz on 15/12/21.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (EasyDate)

#pragma mark-   返回string

/** NSTimeInterval 转成string 默认 yyyy-MM-dd HH:mm:ss */
+ (NSString *)rw_stringFromTimeInterval:(NSTimeInterval)interval;

/** NSTimeInterval 转成string 按照format格式 */
+ (NSString *)rw_stringFromTimeInterval:(NSTimeInterval)interval
                          withFormat:(NSString *)format;

/** 获取当前时间 默认 yyyy-MM-dd HH:mm:ss */
+ (NSString *)rw_stringFromNow;

/** 获取当前时间 按照format格式 */
+ (NSString *)rw_stringFromNowWithFormat:(NSString *)format;

/** date转成string 默认格式 yyyy-MM-dd HH:mm:ss */
+ (NSString *)rw_stringFromDate:(NSDate *)date;

/** date转成string 依照 format格式 */
+ (NSString *)rw_stringFromDate:(NSDate *)date withFormat:(NSString *)format;

#pragma mark- 返回date

/** string转成date 默认格式 yyyy-MM-dd HH:mm:ss */
+ (NSDate *)rw_dateFromString:(NSString *)string;

/** string转成date 依照format格式 */
+ (NSDate *)rw_dateFromString:(NSString *)string withFormat:(NSString *)format;

#pragma mark-  返回 NSTimeInterval

/** 1970年到现在的秒数 */
+ (NSTimeInterval)rw_timeIntervalSince1970;

@end
